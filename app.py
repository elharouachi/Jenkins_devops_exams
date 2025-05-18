from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {"message": "✅ Hello depuis FastAPI avec Jenkins & Docker"}
