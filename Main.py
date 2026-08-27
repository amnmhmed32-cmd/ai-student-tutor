from fastapi import FastAPI
from pydantic import BaseModel
import google.generativeai as genai

app = FastAPI()

genai.configure(api_key="YOUR_GEMINI_API_KEY")
model = genai.GenerativeModel("gemini-1.5-flash")

class PromptRequest(BaseModel):
    prompt: str
    grade_level: int = 9

SYSTEM_INSTRUCTION = """
You are an expert AI Tutor for Ethiopian high school students (Grades 9-12).
Break down complex topics into simple, step-by-step explanations.
Focus on Math, Physics, Chemistry, and Biology.
"""

@app.post("/generate")
async def generate_response(request: PromptRequest):
    full_prompt = f"{SYSTEM_INSTRUCTION}\nGrade: {request.grade_level}\nQuestion: {request.prompt}"
    response = model.generate_content(full_prompt)
    return {"response": response.text}
