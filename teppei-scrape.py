from bs4 import BeautifulSoup
import urllib.request
import re

BASE_URL = "https://www.jafra.or.jp/library/letter/backnumber/"

# top level page
home_page = urllib.request.urlopen(BASE_URL)
soup = BeautifulSoup(home_page, "lxml")

# get each anchor to the year pages
year_links = soup.find_all("ul", "link-list")
year_link_anchors = year_links[0].find_all("a")

# grab the page at the first year link anchor to develop
# later, we will do all years in a for loop
year_anchor = year_link_anchors[0]
text = year_anchor.text
year_number = text[0:4]

year_page_url = BASE_URL + year_number
year_page = urllib.request.urlopen(year_page_url)
year_page_soup = BeautifulSoup(year_page, "lxml")

box = year_page_soup.find_all("div", "box")
box_a = str(box[0].find_all("a")[0])

reg = year_number + "/" + "\d\d"
month = re.findall(reg, box_a)[0].split("/")[1]

year_month_page_url = year_page_url + "/" + month

year_month_page = urllib.request.urlopen(year_month_page_url)
year_month_page_soup = BeautifulSoup(year_month_page, "lxml")

# each page contains a list of links to districts
# open each district page in a loop later
district_links = year_month_page_soup.find_all("ul", class_="link-list")[0].find_all("a")

first_district_link_a = district_links[0]
first_district_link_a_str = str(district_links[0])

first_district_link_parts = first_district_link_a_str.split("href=")[1].split(">")[0].split("/")
first_district_link_final_3_parts = "/".join(first_district_link_parts[6:8])

first_district_url_trailing_quote = year_month_page_url + "/" + first_district_link_final_3_parts
first_district_url = first_district_url_trailing_quote[:-1]

first_district_page = urllib.request.urlopen(first_district_url)
first_district_soup = BeautifulSoup(first_district_page, "lxml")

contents = first_district_soup.find_all("section", class_="mb-6")[0]
print(contents)

file_name = "/Users/daniel/Code/teppei-project/" + first_district_url[8:].replace("/", "_");

f = open(file_name , "w")
f.write(str(contents))

