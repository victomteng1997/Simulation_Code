txt = open(r'F:\IIR filter\codes\Simulation_Code\coeff.txt','r')
content = txt.read()
txt.close()


string = ''
coeff_list = []
for i in content:
    if i != "\n":
       string = string + i
    else:
        coeff_list.append(string)
        string = ''

        
# print coeff_list
search_list = []

i = 4
while i <2047:       #the number can be changed, depends on how many common blocks you want to search, in current situation, all common blocks within 10 digits will be searched.
    binary = "{0:b}".format(i)
    search_list.append(binary)
    i +=1
    


### Then find common blocks  ###
result = []
all_coeff = ''
for coeff in coeff_list:
    all_coeff += coeff
    all_coeff += ' '
for block in search_list:
    block_len = len(block)
    num = (len(all_coeff)-len(all_coeff.replace(block,'')))/block_len
    if num != 0:
        result.append(block)
        result.append(num)

print result


###get the best coeff


i = len(result)
i = i/2
j = 0
best = 0
best_coeff = ''
while j < i:
    if len(result[2*j])*result[2*j+1]>best:
        best = len(result[2*j])*result[2*j+1]
        best_coeff = result[2*j]
    elif len(result[2*j])*result[2*j+1]==best:
        best_coeff += ' '
        best_coeff  += result[2*j]
    else:
        pass
    j += 1
print best
print best_coeff
