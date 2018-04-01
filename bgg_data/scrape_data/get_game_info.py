import logging
import pandas as pd
import requests
import time
from xml.etree import cElementTree as ET

import mylogger
logger = mylogger.set_up_logger(__name__)

def get_singular_item_elements(root, board_game_info_list, elements_list):

    for element in elements_list:
        try:
            if element == 'name':
                board_game_info_list.append(root.find('.//name[@primary="true"]').text.encode('utf-8'))
            else:
                board_game_info_list.append(root.find(element).text.encode('utf-8'))
        except Exception:
            board_game_info_list.append('')
            logger.warning("Potential '{}' error for board game id = {}".format(element, root.attrib['objectid']))

    return board_game_info_list

def get_multiple_item_elements(root, board_game_info_list, elements_list):

    for element in elements_list:
        try:
            if element == 'boardgamehonor':
                num_honors = len(root.findall(element))
                board_game_info_list.append(num_honors)
            else:
                multiple_element_list = []
                for value in root.findall(element):
                    multiple_element_list.append(value.text.encode('utf-8'))

                multiple_element_string = ';'.join(multiple_element_list)
                board_game_info_list.append(multiple_element_string)
        except:
            board_game_info_list.append('')
            logger.warning("Potential '{}' error for board game id = {}".format(element, root.attrib['objectid']))

    return board_game_info_list

def get_statistics_elements(root, board_game_info_list, elements_list):

    stats = root.find('statistics')
    ratings = stats.find('ratings')
    for element in elements_list:
        try:
            if element == 'rank':
                rank = ratings.find('ranks')
                board_game_info_list.append(rank.find('.//rank[@type="subtype"]').attrib['value'])
            else:
                board_game_info_list.append(ratings.find(element).text)
        except:
            board_game_info_list.append('')
            logger.warning("Potential '{}' error for board game id = {}".format(element, root.attrib['objectid']))

    return board_game_info_list

def get_board_game_info():
    board_game_ids_df = pd.read_csv('./data/board_game_geek_board_game_ids.csv')
    game_ids = board_game_ids_df.game_id.astype(str).tolist()
    board_game_geek_api_base_url = 'https://www.boardgamegeek.com/xmlapi/boardgame/{}?&stats=1'
    final_board_game_info_list = []

    singular_elements = ['name', 'yearpublished', 'minplayers', 'maxplayers', 'playingtime', 'age', 'description', 'thumbnail', 'image']
    multiple_elements = ['boardgamepublisher', 'boardgamedesigner', 'boardgameartist', 'boardgamehonor', 'boardgamemechanic', 'boardgamecategory', 'boardgamesubdomain']
    statistics_elements = ['usersrated', 'average', 'rank']

    for i in range(0, (len(game_ids)/10)):
        try:
            temp = game_ids[i*10:(i+1)*10]
            print temp

            r = requests.get(board_game_geek_api_base_url.format(','.join(temp))).content
        except Exception:
            logger.error("Error with request for ids {}".format(temp))
            continue

        tree = ET.fromstring(r)

        for game_id in temp:
            board_game_info_list = []
            root_boardgame = tree.find('.//boardgame[@objectid="{}"]'.format(game_id))
            board_game_info_list.append(game_id)
            board_game_info_list = get_singular_item_elements(root_boardgame, board_game_info_list, singular_elements)
            board_game_info_list = get_multiple_item_elements(root_boardgame, board_game_info_list, multiple_elements)
            board_game_info_list = get_statistics_elements(root_boardgame, board_game_info_list, statistics_elements)

            final_board_game_info_list.append(board_game_info_list)

        time.sleep(5)

    elements_list =  ['game_id'] + singular_elements + multiple_elements + statistics_elements
    return final_board_game_info_list, elements_list

def write_board_game_info_list_to_csv(master_game_list, elements_list):
    final_data_df = pd.DataFrame(master_game_list, columns = elements_list)
    logger.info('Writing {} boardgame data to csv\n'.format(len(final_data_df)))
    final_data_df.to_csv('./data/board_game_geek_board_game_info.csv', index = False, encoding = "utf-8")

def main():
    logger.info('Starting get_game_info.py script')
    board_game_info_lists, elements_list = get_board_game_info()
    write_board_game_info_list_to_csv(board_game_info_lists, elements_list)

if __name__ == '__main__':
    main()
