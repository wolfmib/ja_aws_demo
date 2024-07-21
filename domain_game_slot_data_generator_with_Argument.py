# 2024-05-29 generated csv for slot 

import pandas as pd
import random
from datetime import datetime, timedelta
import sys




# Read command-line arguments
if len(sys.argv) != 3:
    print("Usage: python generate_data.py <input_date> <num_rows>")
    sys.exit(1)


def date_interface(i_date):
    return i_date.replace("-","_")

input_date = date_interface(sys.argv[1])  # Example:  #input_date =bash"2024-01-01" to  "2024_01_01"
num_rows = int(sys.argv[2])  # Example: #num_rows = 2000





# Function to generate unique play_id
    #modifed:  use 2024010100000 to make every day data
def generate_play_id(index, date_str):
    date_int = int(date_str.replace("_", "")) * 100000
    return date_int + index

# Function to generate a random timestamp for the given date
def generate_timestamp(date, start="00:00:00", end="23:59:59"):
    start_time = datetime.strptime(date + " " + start, "%Y_%m_%d %H:%M:%S")
    end_time = datetime.strptime(date + " " + end, "%Y_%m_%d %H:%M:%S")
    random_time = start_time + timedelta(seconds=random.randint(0, int((end_time - start_time).total_seconds())))
    return random_time

# Initial setup
user_ids = list(range(101, 200))
game_ids = [1000, 2000, 3000, 4000]
game_type = "SLOT"
initial_coin = 10000
affiliates = {1: list(range(101, 134)), 2: list(range(134, 167)), 3: list(range(167, 200))}
device_types = ["MOBILE", "PC"]
device_type_weights = [0.8, 0.2]
results = ["win", "lose"]
result_weights = [0.3, 0.7]

# Dictionary to keep track of user's coin balance
user_coin_balance = {user_id: initial_coin for user_id in user_ids}

# Data generation
data = []

for i in range(num_rows):
    user_id = random.choice(user_ids)
    play_id = generate_play_id(i,input_date)
    game_id = random.choice(game_ids)
    timestamp = generate_timestamp(input_date)
    original_coin = user_coin_balance[user_id]
    bet = random.randint(500, 2800000)
    result = random.choices(results, result_weights)[0]
    commission = 0
    net_result = bet * 2 if result == "win" else 0
    updated_coin = original_coin + net_result
    user_coin_balance[user_id] = updated_coin
    affiliate_id = next(affiliate for affiliate, users in affiliates.items() if user_id in users)
    device_type = random.choices(device_types, device_type_weights)[0]
    session_duration = random.randint(1, 4)
    
    data.append({
        "play_id": play_id,
        "user_id": user_id,
        "game_id": game_id,
        "game_type": game_type,
        "timestamp": timestamp,
        "original_coin": original_coin,
        "bet": bet,
        "result": result,
        "commission": commission,
        "net_result": net_result,
        "updated_coin": updated_coin,
        "affiliate_id": affiliate_id,
        "game_result_description": "SKIP",
        "other_members": "",
        "device_type": device_type,
        "session_duration": session_duration
    })

# Convert to DataFrame
df = pd.DataFrame(data)

# Save to CSV
csv_filename = f"{input_date}__gaming_slot_data.csv" #use "__" to split "yyyy_mm_dd"  et "data_name"  
df.to_csv(csv_filename, index=False)

print(f"Data for {input_date} has been generated and saved to {csv_filename}.")
