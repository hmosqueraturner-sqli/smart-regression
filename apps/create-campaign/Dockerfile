FROM mcr.microsoft.com/azure-functions/python:4-python3.11-appservice AS base

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "main.py" ]