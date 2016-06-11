import csv
import math


header1 = ('0','0','0','0','0') # 0/1 == force/displacement
header2 = ('0','1','2','5','5') # node id
header3 = ('0','1','1','1','2') # 1/2 == x/y axis

a = 0
b = 0
c = 0

#102
for i in [1,10,100]:

  freq = i / float(10)
  ofile  = open( "q3_freq_" + str(freq) + '.csv', "wb")
  writer = csv.writer(ofile, delimiter=',')

  writer.writerow(header1)
  writer.writerow(header2)
  writer.writerow(header3)

  # 500
  for ms in range(50000): 

    d = 50*math.sin(freq*ms/100)
    row = (ms/float(100000),a,b,c,d)
    writer.writerow(row)

  ofile.close()