import logging
import pandas as pd
import re
import requests
from bs4 import BeautifulSoup

import mylogger
logger = mylogger.set_up_logger(__name__)

def scrape_board_game_geek_ids(num_pages):
    board_game_geek_base_url = 'https://boardgamegeek.com/browse/boardgame/page/{}'
    boardgame_ids_list = []

    for page in range(1, num_pages+1):
        print '===Scraping Board Game Geek page {}==='.format(page)

        try:
            r = requests.get(board_game_geek_base_url.format(page)).text
            soup = BeautifulSoup(r, 'html.parser')
            collection_table = soup.find('table', class_= 'collection_table')

            for fragment_urls in collection_table.find_all('a', href = re.compile('^/boardgame/\d+/')):
                boardgame_ids_list.append(fragment_urls['href'].split('/')[2:]) #url convention = '/boardgame/GAMEID/GAMENAME'

        except Exception:
            logger.exception("Error on page {}".format(page))
            continue

    return boardgame_ids_list

def write_ids_list_to_csv(ids_list):
    df = pd.DataFrame(ids_list, columns = ['game_id', 'name']).drop_duplicates('game_id')

    logger.info('Writing {} boardgame ids to file\n'.format(len(df)))
    df.to_csv('./data/board_game_geek_board_game_ids.csv'.format(len(df)), index = False)

def main(num_pages):
    logger.info('Starting scrape_game_ids.py script')
    boardgame_ids_list = scrape_board_game_geek_ids(num_pages)
    write_ids_list_to_csv(boardgame_ids_list)

if __name__ == "__main__":
    num_pages = int(raw_input("Enter the number of pages you wish to scrape:\n"))
    main(num_pages)
