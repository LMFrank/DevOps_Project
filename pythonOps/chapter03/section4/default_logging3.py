import logging

logging.basicConfig(filename='app.log', level=logging.DEBUG, format='%(asctime)s : %(levelname)s : %(message)s')

logging.debug('debug message')
logging.info('info message')
logging.warning('warn message')
logging.error('error message')
logging.critical('critical message')
