import logging
import os.path
import pandas as pd
import urllib

import mylogger
logger = mylogger.set_up_logger(__name__)

def download_board_game_images(df, replace_downloaded_images):
    path = "../dashboard/www/thumbnails"

    print '\nBegin Downloading Images'
    for index, row in df.iterrows():
        try:
            print row['name'], row['game_id'], row['thumbnail']

            if replace_downloaded_images == "y":
                urllib.urlretrieve(row['thumbnail'], "{}/{}t.jpg".format(path, row['game_id']))
            else:
                if os.path.isfile("{}/{}t.jpg".format(path, row['game_id'])):
                    print 'Image already downloaded'
                else:
                    urllib.urlretrieve(row['thumbnail'], "{}/{}t.jpg".format(path, row['game_id']))
        except:
            print 'failed to download image'
            logger.warning("Failed to download image for board game {}, id = {}".format(row['name'], row['game_id']))


def main(replace_downloaded_images):
    logger.info('Starting download_board_game_images.py script')
    board_game_df = pd.read_csv('./data/board_game_geek_board_game_info.csv')
    download_board_game_images(board_game_df, replace_downloaded_images)

if __name__ == '__main__':
    replace_downloaded_images = raw_input("Replace downloaded images? (y/n):\n").lower()

    if replace_downloaded_images != "y":
        print 'NOT replacing existing images'
    else:
        print 'replacing existing images'
    main(replace_downloaded_images)
