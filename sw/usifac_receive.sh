#|2PC on the CPC
#Then press 1 and enter on the PC to start transferring from CPC
#Finish reception with Ctrl+C when motor stops or use -w10

MYPORT="10000"

#Set a server listening on a given port and redirect output to a file
echo "Server started. Press 1 + Enter to start downloading"
echo "Set -w10 to a proper value if not enough"
nc -w10 -l $MYPORT > MYFILERAW

#Get name and remove spaces
MYFILE=`head -12c MYFILERAW | tr -d " " `
echo "Saving $MYFILE"

#Then, strip first 12 bytes and we are done
tail +13c MYFILERAW > $MYFILE

#Clean up the house
rm MYFILERAW
