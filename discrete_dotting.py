from decimal import *
###   Part 1: Read sensitivity map from s_map.txt  ###
# One thing to be noticed here. The precision of decimal number is 28 digits by default. Please do not worry about the precision problem.
s_map = open('s_map.txt','r')
s_value = []
for i in s_map:
    s_value.append(Decimal(i))
s_map.close()
#print s_value


###   Part 2: Analyse data; Prepare for dotting
# Read from txt. Analyse data.
coe_txt = open('coeff.txt','r')
coeff = list()
for line in open('coeff.txt'):
    line = coe_txt.readline()
    line = line.strip("\n")
    coeff.append(line)
coe_txt.close()

