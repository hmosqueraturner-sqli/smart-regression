import openai
from dotenv import load_dotenv
import os

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")

def generate_answer(documents):
    context = "\n".join([doc.get("content", "") for doc in documents])
    prompt = f"Con base en el siguiente contexto, responde: \n{context}\n"

    response = openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.5,
    )

    return response.choices[0].message.content
