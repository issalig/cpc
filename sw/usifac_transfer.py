# usifac_transfer.py
# python utility to communicate with USIFAC
#
# author: issalig
# date: 10/05/2021

import argparse
import sys, time
import socket, select
import logging
import array

__version__ = "0.1"


RECV_CHUNKSIZE=1024
RECV_FNAME_SIZE=12
MY_PORT = 10000

# Create logger
logging.basicConfig(
    #format = '%(asctime)-5s %(name)-15s %(levelname)-8s %(message)s', 
    format = '%(message)s', 
    level  = logging.INFO,
)
logger = logging.getLogger('usifac transfer')
logger.setLevel(logging.INFO)
    
# utility function because gethostbyname does not report it ok
def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

#receive files from CPC
def fromCPC(port):
    
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    #sock.setblocking(1)
        
    # Bind the socket to the port
    local_ip=get_ip()        
    server_address = (local_ip, port)
    logger.info('Starting up on {} port {}'.format(*server_address))
    sock.bind(server_address)

    # Listen for incoming connections
    sock.listen(1)

    # Wait for a connection
    logger.info('Waiting for CPC')
    connection, client_address = sock.accept()
    connection.settimeout(10.0)
    try:
        logging.info('CPC connected from %s', client_address)
        print('Waiting for data', end='')
        
        #send fromCPC mode
        while True:
            print(".", end='', flush=True)
            connection.sendall(b'1') #send 1 to start transfer until CPC answers
            r, _, _ = select.select([connection], [], [], 0.1)
            if r:
            # ready to receive
                print("")
                chunk = connection.recv(RECV_FNAME_SIZE)  #filename is first 12 bytes
                if chunk: 
                    logger.info("Connected to CPC")
                    logger.debug('Received filename {!r}'.format(chunk))                
                    fname = chunk.decode("utf-8", errors='ignore')  #ignore strange chars
                    fname = fname.replace(' ', '')                    
                    logger.info("Receiving file: %s", fname)
                break
            time.sleep(1)
        
        # Receive the data in small chunks
        data=bytearray()#b'' #binary stream
        while True:
            chunk = connection.recv(RECV_CHUNKSIZE)
            if chunk:
                data.extend(chunk)
                logger.debug('Received data {!r}'.format(chunk))                
                print(data)
            else:
                logger.debug('No data from', client_address)
                break

    except socket.timeout: # fail after 3 second of no activity
        logger.debug("Socket timeout")
        logger.info("Bytes received %d", len(data))         
        if (len(data)>0):
            logger.info("Saving file %s",fname)
            f = open(fname, "wb")
            f.write(data)
            f.close()

    finally:
        # Clean up the connection
        logger.info("Closing socket")
        connection.close()

#To use with |COM on the CPC
def terminal(port):
    
    # Create a TCP/IP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    #sock.setblocking(1)
        
    # Bind the socket to the port
    local_ip=get_ip()        
    server_address = (local_ip, port)
    logger.info('Starting up on {} port {}'.format(*server_address))
    sock.bind(server_address)

    # Listen for incoming connections
    sock.listen(1)

    # Wait for a connection
    logger.info('Waiting for a connection')
    connection, client_address = sock.accept()
    #connection.settimeout(3.0)
    try:
        logging.info('Connection from %s', client_address)
                    
        while True:
            # Receive the data 
            r, _, _ = select.select([connection], [], [], 0.1)  # do not block input
            if r:
                chunk = connection.recv(128)                
                if chunk:                    
                    logger.debug('Received data {!r}'.format(chunk))
                    msg = chunk.decode("utf-8", errors='ignore')  #ignore strange chars                           
                    msg=msg.replace('\n','') #remove CR LF
                    msg=msg.replace('\r','')
                    
                    print("CPC:", msg)
                    
            r, _, _ = select.select([sys.stdin], [], [], 0.1)
            if r:
                input1 = input() + '\r\n'  # add CRLF       
                connection.sendall(bytearray(input1,"utf-8"))

    finally:
        # Clean up the connection
        logger.info("Closing socket")
        connection.close()
    
def main():
    """
    This is the main 
    """

    # Create parser
    parser = argparse.ArgumentParser(description='%s v%s - USiFaC Transfer Utility' % (sys.argv[0], __version__), prog=sys.argv[0])

    # Add arguments
    #parser.add_argument('--send', '-s', help='Send file to CPC')  #TODO
    parser.add_argument('--receive', '-r', help='Receive file from CPC', action='store_true')
    parser.add_argument('--terminal', '-t', help='Terminal', action='store_true')
    parser.add_argument('--port', '-p', type=int, default=10000, help='Port')
    parser.add_argument('--myip', '-m', help='Check current IP', action='store_true')

    # Execute parse_args()
    global args
    args = parser.parse_args()
       
    if (args.receive):
        try:
            fromCPC(args.port)
            print("Transfer finished")
        except KeyboardInterrupt:
            print("Exiting from Ctrl+C")
            sys.exit()            

    if (args.terminal):
        try:
            terminal(args.port)
            print("Terminal exited")
        except KeyboardInterrupt:
            print("Exiting from Ctrl+C")
            sys.exit()            
        
    if (args.myip):
        print("Call |WIFI and set IP to:", get_ip());
        
if __name__ == '__main__':
    main()

