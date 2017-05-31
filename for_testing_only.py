some_string = "valar morghulis   morghulis"
length1 = len(some_string)
length2 = len(some_string.replace('morghulis',''))
print some_string.replace('morghulis','')
print (length1-length2)/len('morghulis')
 
