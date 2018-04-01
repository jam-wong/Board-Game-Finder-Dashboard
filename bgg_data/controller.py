import logging
import sys
import subprocess

import log.mylogger
import scrape_data.scrape_game_ids
import scrape_data.get_game_info
import scrape_data.download_board_game_images

logger = log.mylogger.set_up_logger(__name__)

def main():
    logger.info("Starting controller.py module")

    num_pages = int(raw_input("Enter the number of pages you wish to scrape:\n"))
    logger.info("User input '{0}'. Scraping {0} page(s)".format(num_pages))

    replace_downloaded_images = raw_input("Replace downloaded images? (y/n):\n").lower()
    if replace_downloaded_images != "y":
        logger.info("User entered '{}': NOT replacing existing images".format(replace_downloaded_images))
    else:
        logger.info("User entered '{}': Replacing existing images".format(replace_downloaded_images))

    logger.info(' === Running Python scripts === ')
    scrape_data.scrape_game_ids.main(num_pages)
    scrape_data.get_game_info.main()
    scrape_data.download_board_game_images.main(replace_downloaded_images)

    logger.info(' === Running R script === ')
    cmd = ['RScript', './format_data/format_for_R.R']
    subprocess.call(cmd, shell = True)

if __name__ == '__main__':
    main()
