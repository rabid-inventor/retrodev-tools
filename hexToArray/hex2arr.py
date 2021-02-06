from intelhex import IntelHex
import sys
TYPEDEF = "uint8_t"
OPENARRAY = "{"
CLOSEARRAY ="};\n"
inputFile = "test.txt"
template = "template.h"
filename = "software.h"
names = ['resetVector','bios','software']
locations = [0xFFFE,0xF000,0x8000]
datasizes = [2,2,2]

biosLocation = 0xF000
biosSize = 0x0F
softwareLoctaion = 0x8000
softwareSize = 0x0F

def getData(importedhex, startAddress, Size):
    retstr = ""
    for index in range(Size):
        retstr+=str(importedhex[startAddress+index])
        if index+1 < Size:
            retstr+=( ',')
    return retstr

def createArrayStr(importedhex, arrayName, startAddress, Size):
    retstr = TYPEDEF + ' '+arrayName+'[] '+ OPENARRAY+getData(hexDict,startAddress,Size)+CLOSEARRAY
    return retstr

f = open(filename,mode='w')
importedHexFile = IntelHex(inputFile)


hexDict=importedHexFile.todict()
print (hexDict)
f.write("hex file converted from "+inputFile+"\n")
for memoryIndex in range(len(names)):
    
    f.write(createArrayStr(hexDict,names[memoryIndex], locations[memoryIndex] ,datasizes[memoryIndex]) )

f.close()


