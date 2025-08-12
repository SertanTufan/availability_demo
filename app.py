from fastapi import FastAPI
from pydantic import BaseModel
from datetime import date, timedelta
import json

app = FastAPI()

with open("inventory.json") as f:
    INV = json.load(f)["inventory"]

class AvReq(BaseModel):
    hotel_id: str
    check_in: date
    check_out: date
    room_type: str
    rooms_needed: int = 1
    adults: int
    children: int = 0

@app.post("/availability")
def availability(req: AvReq):
    days = []
    d = req.check_in
    while d < req.check_out:
        days.append(d.isoformat())
        d += timedelta(days=1)

    prices = []
    cur = None
    for day in days:
        match = next((x for x in INV if x["hotel_id"] == req.hotel_id and x["date"] == day and x["room_type"] == req.room_type), None)
        if not match or match["stock"] < req.rooms_needed:
            return {"available": False, "reason": "no_stock"}
        prices.append(match["price"])
        cur = match["currency"]

    avg = sum(prices) / len(prices)
    total = sum(prices) * req.rooms_needed

    return {
        "available": True,
        "nights": len(days),
        "currency": cur,
        "avg_price": avg,
        "total_price": total,
        "room_code": req.room_type,
        "notes": "Standard rate"
    }
