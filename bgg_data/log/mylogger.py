import logging

def set_up_logger(logger_name):
    logger = logging.getLogger(logger_name)
    handler = logging.FileHandler('bgg_run_log.log')
    formatter = logging.Formatter('%(asctime)s [%(levelname)s]: %(filename)s(%(funcName)s:%(lineno)s) \n%(message)s\n')

    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    return logger

if __name__ == "__main__":
    set_up_logger()
