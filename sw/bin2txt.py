# bintxt.py
# python utility to convert z80 binary into text and viceversa
# it also has support for AMSDOS headers
#
# author: issalig
# date: 26/05/2021

import sys
import argparse
import logging
import array
import io

__version__ = "0.1"

# Create logger
logging.basicConfig(
    #format = '%(asctime)-5s %(name)-15s %(levelname)-8s %(message)s', 
    format = '%(message)s', 
    level  = logging.INFO,
)
logger = logging.getLogger('bin2txt')
logger.setLevel(logging.INFO)
        
#http://www.cpcwiki.eu/imgs/b/bc/S968se09.pdf
#http://www.cpcwiki.eu/index.php/AMSDOS_Header
def valid_amsdos_header(data):
    
    if (len(data) < 128):
        return 0
    
    user_number = data[0]
    file_name = data[1:12].decode("utf-8", errors='ignore') #ignore strange chars
    file_type = data[18]
    #data_location = data[19] + (data[20] << 8)
    load_address =  data[21] + (data[22] << 8)
    file_length =   data[64] + (data[65] << 8) + (data[66] << 16)
    mychecksum = sum(data[0:66])
    checksum =  data[67] + (data[68] << 8)
    entry_address=data[26] + (data[27] << 8)
    logical_length = data[24] + (data[25] << 8)
    
    if (checksum != mychecksum):
        print('Not a valid AMSDOS header, checksum incorrect',checksum,  mychecksum)
    
    else:
        print("Name: ", file_name)
        print("User: ", user_number)
        print("Type: ", file_type, end='')
        if (file_type == 0):
            print(" (BASIC)")
        elif (file_type == 1):
            print(" (Protected)")
        elif (file_type == 2):
            print(" (Binary)")
        elif (file_type == 16):
            print(" (Unprotected ASCII v1)")
                    
        print("Length: ", file_length, "/", hex(file_length),"bytes")
        #print("First block ", data[23])
        print("Logical length ", logical_length, "/", hex(logical_length),"bytes")
        print("Entry address ", entry_address, '/', hex(entry_address))
        #print("Data location: ", data_location)
        print("Load address: ", load_address, '/', hex(load_address))
        print("Checksum: ", hex(checksum))
    
        #print(len(data), file_length, hex(file_length), len(data)-file_length, data[66],hex(data[65]),hex(data[64]))
        
    return not(checksum != mychecksum)

def create_amsdos_header(file_name, file_type, file_length, entry_address=0x300, load_address=0x600):
    data=array.array('B',[]) #unsigned char array
 
    data.extend([0]*128) #128 bytes

    data[0]=0 #user_number
    #file name format 12 bytes 12345678.EXT
    print(file_name)
    s=file_name.split('.')
    basename=s[0]
    print(s)
    basename=basename[:8] #truncate to 8 chars
    basename=basename.ljust(8) #fill whith blanks
    ext=s[1]
    print(basename,ext)
    ext=ext[:3] #truncate to 3 chars
    ext=ext.ljust(3) 
    
    print(basename,ext)
    
    f=basename+ext
    f=f.upper().encode('ascii')    
    for i in range(len(f)):        
        data.insert(i+1,f[i])
        
    data[18]=int(file_type)
    #data_location=0 #address of 2kb buffer
    #data[19]=data_location & 0xFF # LSB
    #data[20]=data_location >> 8     #MSB
    
    data[21]=load_address & 0xFF # LSB
    data[22]=load_address >> 8     #MSB
    
    logical_length=file_length
    data[24]=logical_length & 0xFF
    data[25]=logical_length >> 8
    
    data[26]=entry_address & 0xFF
    data[27]=entry_address >> 8
    
    #Real Length. Just a copy
    data[64]=file_length & 0xFF   #LSB
    data[65]=(file_length >> 8) & 0xFF
    data[66]=file_length >> 16      #MSB
    
    checksum=sum(data[0:66])
    data[67]=checksum & 0xFF      #LSB
    data[68]=checksum >> 8          #MSB
    
    return data

def basic_loader(data, values):
    #redirect output to file
    output = io.StringIO()
    back_stdout = sys.stdout
    sys.stdout = output 
    
    print("10 REM MACHINE CODE LOADER")    
    print("20 size=", len(data))    
    print("30 addr=", args.callAddress)    
    print("40 FOR b=0 TO size-1: READ a$:POKE addr+b,VAL(\"&\"+a$):NEXT")
    print("50 CALL ",args.callAddress)
    
    line=60
    
    str1 = ''.join(map(str,values))
    str1=str1.splitlines()
    
    for i in range(len(str1)):
        print(line, str1[i])
        line=line+10
    
    contents = output.getvalue()
    output.close()
    sys.stdout=back_stdout
    
    return contents
    
def bin2txt(data):
    if valid_amsdos_header(data):    
        #strip header and get only data from logical length
        logical_length = data[24] + (data[25] << 8)      
        data=data[128:128+logical_length]
    
    linesize=args.linesize
    
    #redirect output to file
    output = io.StringIO()
    back_stdout = sys.stdout
    sys.stdout = output 
    for i in range(len(data)):
        if not(i%linesize):  #print linesize bytes per line
            if (args.prefix): #print prefix in the beginning of line
                print(args.prefix, " ",end="")
        if args.hex:
            if (args.hexprefix):
                print(args.hexprefix,end='')
            print("%02x"%((data[i])),end="")
        else:
            print("%3d"%(data[i]),end="")
        if (not((i+1)%linesize) or ((i+1)==len(data))): print()
        else: 
            if (args.sep):
                print(args.sep,end='')
            else:
                print(" ",end='')

    contents = output.getvalue()
    output.close()
    sys.stdout=back_stdout
    return contents

    
def txt2bin(data):    
    #we will have a csv
    #blanks will be commas
    csv=data.replace(' ',',')
    csv=csv.replace(',,',',')
    csv=csv.replace(',,',',')
    csv=csv.replace(',,',',')
    csv=csv.replace('\n',',')
    csv=csv.replace('\r',',')
    csv=csv.replace('0x','&')

    tokens = csv.split(',')
    values=array.array('B',[]) #unsigned char array
    
    for i in range(len(tokens)):        
        token=tokens[i]
        #ignore not a number or empty
        if (token == 'defb') or (token == 'db') or (token == 'data') or \
           (token == 'DEFB') or (token == 'DB') or (token == 'DATA') or \
           (len(token)==0):
            continue
        #autodetect hex or forced   
        if ('&' in token) or ('#' in token) or args.hex:
            hex_string = token[1:] #remove first char
            val=int(hex_string,16)
            values.append(val)
        #integer value    
        else:
            print("t", token,"t")
            val=int(token)
            values.append(val)
                        
    return values
               
def main():
    """
    This is the main 
    """

    # Create parser
    parser = argparse.ArgumentParser(description='%s v%s - Bin <-> Text Conversion Utility for CPC' % (sys.argv[0], __version__), prog=sys.argv[0])

    #Input/Output options
    parser.add_argument('--file', '-f', help='File name')
    parser.add_argument('--out', '-o', default="out", help='Output file')
    parser.add_argument('--printout', help='Prints output on stdout', action='store_true')
    
    #TXT/BIN options
    parser.add_argument('--totxt', '-t', help='Binary to ascii', action='store_true')
    parser.add_argument('--tobin', '-b', help='ascii to binary', action='store_true')
    parser.add_argument('--prefix', '-p', help='Line prefix string defb, data, etc, ...')
    parser.add_argument('--hex', '-x', help='Hex conversion (integer by default', action='store_true')
    parser.add_argument('--hexprefix', '-e', default="&", help="& # 0x or whatever")
    parser.add_argument('--sep', '-s', default=",", help="Bye separator, space, comma, ...")
    parser.add_argument('--linesize', '-l', default=30, type=int, help="Number of bytes in a text line when --dump")
    parser.add_argument('--basicLoader', help="BASIC loader", action='store_true')
    parser.add_argument('--callAddress', default="40000", help="BASIC loader call address")
    
    #AMSDOS options
    parser.add_argument('--info', '-c', help='Header info', action='store_true')
    parser.add_argument('--addHeader', '-a', help='Add header AMSDOS', action='store_true')
    parser.add_argument('--removeHeader', '-r', help='Remove header', action='store_true')
    parser.add_argument('--load', help='AMSDOS load address')
    parser.add_argument('--entry', help='AMSDOS entry point')
    parser.add_argument('--type', help='AMSDOS File type 0: BASIC, 1: Protected 2:Binary 16:Unprotected ASCII v1')
        
    # Execute parse_args()
    global args
    args = parser.parse_args()
    
    if (args.info):
        fname=args.file
        try:
            with open(fname, 'rb') as reader:
                data = reader.read()
            if not(valid_amsdos_header(data)):
                print("Not an AMSDOS file")
            
        except FileNotFoundError:
            print('Cannot open file \'%s\'' % (fname))        

    if (args.totxt):
        fname=args.file
        try:
            with open(fname, 'rb') as reader:
                data = reader.read()
            
            values=bin2txt(data)
            
            if args.basicLoader:
                values=basic_loader(data, values)                
                                                        
            if args.printout:
                print(values)
                
            #save
            with open(args.out, 'w') as file:                
                file.write(values)            
            
        except FileNotFoundError:
            print('Cannot open file \'%s\'' % (fname))        

    if (args.tobin):
        fname=args.file
        try:
            with open(fname, 'r') as reader:
                data = reader.read()
                
            values=txt2bin(data)
            
            #save
            with open(args.out, 'wb') as file:            
                file.write(values)
            
        except FileNotFoundError:
            print('Cannot open file \'%s\'' % (fname)) 
   
   
    if (args.addHeader):
        fname=args.file
        try:
            with open(fname, 'rb') as reader:
                data = reader.read()
            #if already AMSDOS header replace it
            if valid_amsdos_header(data):
                #skip first 128
                d=data[128:]
            else:
                d=data
            
            header=create_amsdos_header(args.file, 2, len(d))            
            header.extend(d)
            
                #save
            with open(args.out, 'wb') as file:
            #file.write(values.astype("char"))
                file.write(header)

            
        except FileNotFoundError:
            print('Cannot open file \'%s\'' % (fname)) 
       
    if (args.removeHeader):
        fname=args.file
        try:
            with open(fname, 'rb') as reader:
                data = reader.read()
            #if already AMSDOS header replace it
            if valid_amsdos_header(data):
                #skip first 128
                d=data[128:]
                        
            #save
            with open(args.out, 'wb') as file:
            #file.write(values.astype("char"))
                file.write(header)

            
        except FileNotFoundError:
            print('Cannot open file \'%s\'' % (fname)) 
if __name__ == '__main__':
    main()

