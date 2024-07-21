#!/bin/bash

## 2023-05-28
# Below is the modified bash script to include the echo statement for monitoring and to 
# randomly choose the number of rows (between 1900 and 2300) for each day.



start_date="2024-01-02"
end_date="2024-03-31"

current_date="$start_date"
while [ "$current_date" != "$(date -I -d "$end_date + 1 day")" ]; do
    num_rows=$(shuf -i 1900-2300 -n 1)
    python3 domain_game_slot_data_generator_with_Argument.py "$current_date" "$num_rows"
    echo "Finished generating gaming_data_$current_date.csv with $num_rows rows."
    current_date=$(date -I -d "$current_date + 1 day")
done
