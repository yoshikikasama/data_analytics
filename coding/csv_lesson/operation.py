"""
CSV(Comma Separated Value)・・・「,」で区切ってデータを並べたファイル形式
"""
import csv

# 読み込み
with open('files/example.csv', 'r') as f:
    reader = csv.reader(f)
    # for line in reader:
    #     print(line)
    line = [row for row in reader]
    print(line)

with open('files/examplebirthday.csv', 'r') as f:
    csv_reader = csv.DictReader(f)
    for row in csv_reader:
        print(row)

# 書き込み
word = "red, blue"
words = word.split(",")
with open('files/test.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(words)

# 追記
with open('files/test.csv', 'a') as f:
    writer = csv.writer(f)
    writer.writerow(words)

# 辞書として書き込み
with open('files/test_dict.csv', 'w') as f:
    field_name = ['name', 'dept', 'birth']
    writer = csv.DictWriter(f, fieldnames=field_name)
    writer.writeheader()
    writer.writerow({
        'name':'Adam',
        'dept': 'Engineering Department',
        'birth': 'July 7'
    })
