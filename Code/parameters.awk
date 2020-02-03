# ===========================================================
# AWK Script for calculating:
# => Throughput, PDR,E2E Delay
#
#=============================================================

BEGIN {
  recvdSize = 0
  startTime = 400
  stopTime = 0
  sent=0;
  received=0;
  seqno = -1;    
  count = 0;
}

  {
    event = $1
    time = $2
    node_id = $3
    pkt_size = $8
    level = $4
    
    if (level == "AGT" && event == "s" && pkt_size >= 512)
    {
      if (time < startTime) 
      {
        startTime = time
      }

    }

arrival time
if (level == "AGT" && event == "r" && pkt_size >= 512) 
{
  if (time > stopTime) 
  {
    stopTime = time
  }

hdr_size = pkt_size % 512
pkt_size -= hdr_size


recvdSize += pkt_size

}
  if($1=="s" && $4=="AGT")
   {
    sent++;
   }
  else if($1=="r" && $4=="AGT")
   {
     received++;
   }
   
  if($4 == "AGT" && $1 == "s" && seqno < $6) {
          seqno = $6;
    } 
    if($4 == "AGT" && $1 == "s") {
          start_time[$6] = $2;
    } else if(($7 == "cbr") && ($1 == "r")) {
        end_time[$6] = $2;
    } else if($1 == "D" && $7 == "cbr") {
          end_time[$6] = -1;
    } 


  }

END {
printf("Average Throughput[kbps] = %.2f\t\tStartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
printf "Packet Sent:%d",sent;
printf "\t\t\t\t\tPacket Received:%d",received;
printf "\nPacket Delivery Ratio:%.2f\n",(received/sent)*100;
for(i=0; i<=seqno; i++) {
          if(end_time[i] > 0) {
              idelay = end_time[i] - start_time[i];
	      delay = delay + idelay;
                  count++;
        }
    }

   delay = delay/count;
   print "\nAverage End-to-End Delay    = " delay * 1000 " ms";
}



