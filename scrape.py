#import the library used to query a website
#import the beautifulsoup library functions tothe parse the data returned from the website
#import regex
import urllib2
from bs4 import BeautifulSoup
import re

#all departments scraped from "https://oa.cc.iitk.ac.in/Oa/Jsp/Main_Frameset.jsp"
depts = ["ACES", "ACMS", "AE", "BIO", "BSBE", "CDC", "CDTE", "CESE", "CELT", "CELP", "CMCH", "CHE", "CHM",\
	 "CE", "CGS", "CSE", "COSE", "BSE", "MD", "DESP", "ES", "ECOS", "ECO", "ECON", "EE", "MCH",\
	 "EEM", "HSS", "IME", "LT", "DES", "MDES", "MET", "MME", "MSE", "MS", "MSP", "MATH", "ME", "MEC",\
	 "VLFM", "MTH", "NET", "PHY", "STAT", "SBER"]

#to remove control characters from strings
mpa = dict.fromkeys(range(32))

print '|' + "ROLL NO".center(10) + '|' + "NAME".center(40) + '|' + "PROGRAMME".center(15) + '|' + "DEPARTMENT".center(30) + \
			'|' + "HOSTEL INFO".center(20) + '|' + "EMAIL".center(27) + '|' + "BLOOD GROUP".center(17) + '|' + "GENDER".center(5) + \
			'|' + "NATIONALITY".center(26) + '|'

for de in depts:
	counter = 0
	page = urllib2.urlopen("https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchStudRoll.jsp?recpos=" + str(counter) + "&selstudrol=&selstuddep=" + de + "&selstudnam=")
	soup = BeautifulSoup(page, "html.parser")
	while (len(soup.find_all("a", href=re.compile("IITk_SrchRes.jsp?"))) != 0):
		roll_links = soup.find_all("a", href=re.compile("IITk_SrchRes.jsp?"))
		for roll_link in roll_links:
			roll = roll_link.string.translate(mpa)
			stud_info_page = urllib2.urlopen("https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchRes.jsp?typ=stud&numtxt=" + roll + "&sbm=Y")
			stud_info_soup = BeautifulSoup(stud_info_page, "html.parser")
			stud_info_tag = stud_info_soup.find("td", class_ = "TableContent")
			stud_info_attr = stud_info_tag.find_all("b")
			stud_info_keys = ["Roll No", "Name", "Programme", "Department", "Hostel Info", "Email", "Blood Group", "Gender", "Nationality"]
			stud_info = {}
			for key, attr in zip(stud_info_keys, stud_info_attr):
				try:
					stud_info[key] = attr.next_sibling.translate(mpa)
				except TypeError:
					stud_info[key] = attr.parent.a.string.translate(mpa)
			print '|' + stud_info["Roll No"].center(10) + '|' + stud_info["Name"].center(40) + '|' + stud_info["Programme"].center(15) + '|' + stud_info["Department"].center(30) + \
			'|' + stud_info["Hostel Info"].center(20) + '|' + stud_info["Email"].center(27) + '|' + stud_info["Blood Group"].center(17) + '|' + stud_info["Gender"].center(6) + \
			'|' + stud_info["Nationality"].center(26) + '|'
			#print stud_info["Name"]

		counter += 12
		page = urllib2.urlopen("https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchStudRoll.jsp?recpos=" + str(counter) + "&selstudrol=&selstuddep=" + de + "&selstudnam=")
		soup = BeautifulSoup(page, "html.parser")

			#print roll
	'''for table_row in table_rows:
	roll = table_row.find("a").find(text=True)
	stud_info_page = urllib2.urlopen("https://oa.cc.iitk.ac.in/Oa/Jsp/OAServices/IITk_SrchRes.jsp?typ=stud&numtxt=" + str(roll) + "&sbm=Y")
	soup2 = BeautifulSoup(stud_info_page, "html.parser")
	stud_info = soup2.find("table", class_ = "TableContent").find_all("p")
	name = stud_info[0]
	program = stud_info[1]
	department = stud_info[2]
	hostel_info = stud_info[3]
	email = stud_info[4]
	blood_group = stud_info[5]
	gender = stud_info[6]
	nationality = stud_info[7]
	print roll, name, program


#the url from which to scrape data
#wiki = "https://en.wikipedia.org/wiki/List_of_state_and_union_territory_capitals_in_India"

#Query the website and return the html to trhe variable page
#page = urllib2.urlopen(wiki)

#Parse the html in the page variable , and store in Beautiful Soup format
#soup = BeautifulSoup(page, "html.parser")

#print soup.title
#print soup.title.string
#print soup.a'''

'''links = [link.get("href") for link in soup.find_all("a")]
print links

all_tables = soup.find_all("table")
print all_tables'''

#right_table = soup.find("table", class_ = "wikitable sortable plainrowheaders")
#right_table2 = soup.find_all("table", class_ = "wikitable sortable plainrowheaders")

#print right_table
#print right_table2
