'''
Created on Apr 28, 2012
@author: Nikhil Bendre
'''

from fnmatch import fnmatch
import os, os.path
import sys

newVal=[]
newData = []

def createMapper(pattern,dir1,files):
    newVal=[]
    for filename in files:
        if fnmatch(filename,pattern):
            filepath=dir1+'/'+filename
        
            fh=open(filepath,'r')
            for line in fh:
                tag=line.strip().split('\t')
                if tag[0]!='0':
                    print tag                    
                    newData = filename +','
                    for i in tag:
                        if i!='':
                            newData = newData + i+','
                            newVal.append(newData)
                    
    if newVal!=[]:
            for each in newVal:
               print each      
os.path.walk('/scratch/jt3/pdata/', createMapper, '*.txt')