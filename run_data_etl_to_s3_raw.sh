#!/bin/bash


 
#2023-06-04
#Data format  yyyy_mm_dd__YOURFILENAME.csv

#2024_01_16__gaming_slot_data.csv  2024_02_08__gaming_slot_data.csv  2024_03_02__gaming_slot_data.csv  2024_03_25__gaming_slot_data.csv
#2024_01_17__gaming_slot_data.csv  2024_02_09__gaming_slot_data.csv  2024_03_03__gaming_slot_data.csv  2024_03_26__gaming_slot_data.csv
#2024_01_18__gaming_slot_data.csv  2024_02_10__gaming_slot_data.csv  2024_03_04__gaming_slot_data.csv  2024_03_27__gaming_slot_data.csv
#2024_01_19__gaming_slot_data.csv  2024_02_11__gaming_slot_data.csv  2024_03_05__gaming_slot_data.csv  2024_03_28__gaming_slot_data.csv
#2024_01_20__gaming_slot_data.csv  2024_02_12__gaming_slot_data.csv  2024_03_06__gaming_slot_data.csv  2024_03_29__gaming_slot_data.csv
#2024_01_21__gaming_slot_data.csv  2024_02_13__gaming_slot_data.csv  2024_03_07__gaming_slot_data.csv  2024_03_30__gaming_slot_data.csv
#2024_01_22__gaming_slot_data.csv  2024_02_14__gaming_slot_data.csv  2024_03_08__gaming_slot_data.csv  2024_03_31__gaming_slot_data.csv
#2024_01_23__gaming_slot_data.csv  2024_02_15__gaming_slot_data.csv  2024_03_09__gaming_slot_data.csv



# Variables
BUCKET_NAME="demo-lambda-s3-upload-trigger"
BASE_PATH="gaming_two" # S3/Endpooint
LOCAL_PATH="/home/ec2-user/environment/game_data" #<< Data location

# Loop through each file in the local directory
for FILE in ${LOCAL_PATH}/*.csv; do
  # Extract the file name without the path
  FILE_NAME=$(basename "${FILE}")

  # Split the file name to get the date and endpoint
  DATE_STRING=$(echo ${FILE_NAME} | cut -d'_' -f1-3)
  ENDPOINT_STRING=$(echo ${FILE_NAME} | cut -d'_' -f4- | sed 's/^_//')

  # Format the date string to extract year, month, and day
  YEAR=$(echo ${DATE_STRING} | cut -d'_' -f1)
  MONTH=$(echo ${DATE_STRING} | cut -d'_' -f2)
  DAY=$(echo ${DATE_STRING} | cut -d'_' -f3)
  
#  """
#  Extracting DATE_STRING:
#
#    DATE_STRING=$(echo ${FILE_NAME} | cut -d'_' -f1-3)
#    -d'_': Specifies the delimiter, which is the underscore _.
#    -f1-3: Extracts fields 1, 2, and 3. This gives us the yyyy_mm_dd part of the filename.
#
#  Extracting ENDPOINT_STRING:
#
#    ENDPOINT_STRING=$(echo ${FILE_NAME} | cut -d'_' -f4- | sed 's/^_//')
#    -f4-: Extracts from the 4th field to the end. This gives us _gaming_slot_data.csv.
#    sed 's/^_//': The sed command is used to remove the leading underscore. s/^_// means substitute (s) the leading underscore (^_) with nothing (//).

#. Extracting Year, Month, and Day:
#
#    YEAR=$(echo ${DATE_STRING} | cut -d'_' -f1): Extracts the first field, which is the year.
#    MONTH=$(echo ${DATE_STRING} | cut -d'_' -f2): Extracts the second field, which is the month.
#    DAY=$(echo ${DATE_STRING} | cut -d'_' -f3): Extracts the third field, which is the day.
#  
#  """
  
  # Create destination path
  DEST_PATH="s3://${BUCKET_NAME}/${BASE_PATH}/year=${YEAR}/month=${MONTH}/day=${DAY}/${ENDPOINT_STRING}"

  echo "${BASE_PATH}:   ${DATE_STRING}:  ${YEAR} ${MONTH} ${DAY} ${ENDPOINT_STRING}"
  echo "${DEST_PATH}"
  # Upload file to S3
  aws s3 cp "${FILE}" "${DEST_PATH}"
done
