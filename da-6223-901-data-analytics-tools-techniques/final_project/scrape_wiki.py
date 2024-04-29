import requests
from bs4 import BeautifulSoup
from time import sleep
from selenium import webdriver
from selenium.webdriver.common.by import By
import json
import re
from pandas import read_csv, set_option
set_option('display.max_columns', None)

drivers_df = read_csv('f1/drivers.csv')
# print(drivers_df)
count = 0
for idx, row in drivers_df.iterrows():
    count =+ 1
    if count < 2:
        # print(row['url'])
        browser = webdriver.Firefox()
        browser.implicitly_wait(5)
        headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.93 Safari/537.36'}
        browser.get(row['url'])
        html = browser.page_source
        the_soup = BeautifulSoup(html, 'html.parser')
        scripts = the_soup.find_all("th", class_='infobox-lab')
        # scripts1 = the_soup.find_all("td", class_="infobox-data")
        print(scripts)
        # print(scripts1)
        sleep(5)
        browser.close()
    else:
        break