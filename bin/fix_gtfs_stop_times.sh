#!/bin/bash

# this script requires: zip, unzip, sort, awk, grep
# everything should come installed except maybe zip

# Provide a gtfs zip file which contains trips.txt and stop_times.txt
if [ -z "${1}" ]; then
    echo "Please provide a zip file"
    exit 1
fi

echo "Extracting the trips and stop_times files from $1"
unzip $1 trips.txt stop_times.txt
# don't need to remove ^M
#sed -e 's/'`echo "\015"`'//g' stop_times.txt

echo "Get all the unique trip ids and read into stop_times_trips.txt"
# take the file stop_times.txt and output to the unique file out.txt
sort -u -t, -k1,1 stop_times.txt | cut -d \, -f 1 > stop_times_trips.txt

# kill the last line which isn't numeric
#head -n -1 stop_times_trips.txt > temp.txt ; mv temp.txt stop_times_trips.txt

# just the trip id from trips.txt
echo "Get just the trip ids from trips.txt"
cat trips.txt | cut -d \, -f 3 > just_trips.txt

#strip the first line out
#tail -n +2 just_trips.txt > temp.txt ; mv temp.txt just_trips.txt

# these will need to be removed
echo "Build a list of stop_times that will need to be removed due to missing parent trip id"
grep -v -F -x -f just_trips.txt stop_times_trips.txt > missing_no_parents.txt

NUMOFLINES=$(wc -l < "missing_no_parents.txt")

# this will most likely be empty
grep -v -F -x -f stop_times_trips.txt just_trips.txt > missing_no_kids.txt

if [ "$NUMOFLINES" -gt 0 ]; then
  counter=1
  while read DELETEME
  do
      echo "Removing $DELETEME; number $counter of $NUMOFLINES"
      let counter++
      awk '!/'"$DELETEME"'/' stop_times.txt > temp && mv temp stop_times.txt
  done < missing_no_parents.txt

  # replace the stop_times file
  echo "Rebuild the zip file"
  zip -f $1 stop_times.txt
else
  echo "Nothing missing!"
fi

# cleanup
rm just_trips.txt
rm trips.txt
rm stop_times_trips.txt
rm stop_times.txt
