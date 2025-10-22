from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
# from mangum import Mangum

# Create a FastAPI instance
# app = FastAPI()
app = FastAPI(root_path="/api")
# Allow frontend (React) to access backend (FastAPI)
app.add_middleware(
    CORSMiddleware,
    # allow_origins=["http://localhost:3000"],  # React app URL
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

# Define a route (homepage)
@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI Application! 🎉"}


# Define the request body model
class NameRequest(BaseModel):
    name: str

# POST endpoint
@app.post("/welcome")
def welcome_user(data: NameRequest):
    return {
        "message": f"Welcome {data.name}, know this application is yours!"
    }

# AWS Lambda handler
# handler = Mangum(app)  #add this at the end of code