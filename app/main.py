from fastapi import FastAPI

app = FastAPI()
data = "Hello World!"
@app.get("/")
async def root():
    return data