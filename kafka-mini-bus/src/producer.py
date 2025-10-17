from confluent_kafka import Producer
import json, time, uuid, random

p = Producer({"bootstrap.servers": "localhost:9092"})
topic = "demo.events"

while True:
    key = f"user-{random.randint(1,10)}"
    val = {
        "event_id": str(uuid.uuid4()),
        "user": key,
        "amount": random.randint(10,999),
        "ts": int(time.time()*1000)
    }
    p.produce(topic, key=key.encode(), value=json.dumps(val).encode())
    p.poll(0)         # dr callbacks
    print("→ produced", key, val)
    time.sleep(0.5)
