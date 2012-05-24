'''
Created on Apr 28, 2012
@author: Nikhil
'''

import sys
mainlist=[]
fname=''

for line in sys.stdin:
    main=line.split(',')
    mainlist.append(main)
    
def generateNewData():
    tmp1=[]
    tmp2=[]
    tmp3=[]
    newlist=[]

    for l1 in mainlist:
        
        if (l1[0]=="training.txt"):    
            try:
                    tmp1[:]=l1[:]
                    tmp1.pop(0)
                    tmp3.append(tmp1[11])
                    
            except:
                pass
     
    tmp3=list(set(tmp3))
    z1=[]
    for zz in tmp3:
          if zz!='\n':
              z1.append(zz)
    
    tmp3=z1
    
    for l2 in mainlist:
        if (l2[0]=="userid_profile.txt"):
            
                try:
                           
                    tmp2[:]=l2[:]
                    tmp2.pop(0)
                    
                    if len(tmp2)==3:
                    
                        tmp3.append(tmp2[0])
                except:
                     pass
           
    n=len(tmp3)
    
    for i in range(n):
        for j in range(i+1, n):
            if tmp3[i] == tmp3[j]:
                try:    
                    newlist.append(tmp3[i])    
                    
                except:
                    pass       
                
    for i in range(len(newlist)):
        tmp1=[]
        for newData in mainlist:
            if (newData[0]=="userid_profile.txt"):
                try:
                    tmp1[:]=newData[:]
                    tmp1.pop(0)
                except:
                     pass
    
            if (newlist[i]==newData[1]):
                    try:
                        if newData[3]!='\n':
                            newDataFile=newlist[i]+'\t'+newData[2]+'\t'+newData[3]
                            print newDataFile
                    except:
                        pass    
                   
generateNewData()