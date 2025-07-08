import os
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse
import uvicorn

from query_cosmos import run as query_cosmos
from query_search import search_index
from generate_json import run as generate_json
from shared.azure_clients import get_blob_client

app = FastAPI()

@app.post("/evaluate")
async def evaluate(request: Request):
    try:
        body = await request.json()
        jql_name = body.get("jql_name")

        if not jql_name:
            raise HTTPException(status_code=400, detail="Missing 'jql_name' in request body")

        # Step 1: Query CosmosDB 
        cosmos_data = query_cosmos(jql_name)

        # Step 2: Query Azure Search
        search_data = search_index(jql_name)

        # Step 3: Generate JSON file showing indexed data
        json_path = generate_json(jql_name)

        # Step 4 (optional): upload JSON generated file to Azure Blob
        blob_name = f"rag-results/results_{jql_name}.json"
        blob_client = get_blob_client()
        with open(json_path, "rb") as data:
            blob_client.upload_blob(name=blob_name, data=data, overwrite=True)

        blob_url = f"https://{os.environ['STORAGE_ACCOUNT_NAME']}.blob.core.windows.net/{os.environ['BLOB_CONTAINER_NAME']}/{blob_name}"

        return JSONResponse(status_code=200, content={
            "message": "Evaluation completed successfully",
            "blob_url": blob_url
        })

    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8080)


