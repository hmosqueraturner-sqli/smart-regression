# 📦 front-react

Frontend to call the Azure Container Apps API (`api-evaluate`), generate and read a JSON file from Azure Storage.

---

## 🚀 Requisitos

- Node.js >= 18
- Docker
- Azure CLI (`az`)
- Azure Container Registry (ACR)
- Azure Container Apps Environment
- `.env` con:

```env
REACT_APP_EVALUATE_API=https://<tu-api-evaluate>.azurecontainerapps.io/evaluate
REACT_APP_JSON_URL=https://<tu-storage>.blob.core.windows.net/<container>/result.json
