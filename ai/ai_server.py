import io
import torch
import torch.nn as nn
from torchvision import models, transforms
from PIL import Image
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import JSONResponse

# ── Model setup ───────────────────────────────────────────────────────────────

DEVICE = torch.device("cpu")
MODEL_PATH = "save_n_serve_resnet50.pth"

# Mirror the exact architecture from food_detector.ipynb
def build_model():
    model = models.resnet50(weights=None)
    num_features = model.fc.in_features
    model.fc = nn.Sequential(
        nn.Linear(num_features, 256),
        nn.ReLU(),
        nn.Dropout(0.3),
        nn.Linear(256, 1),
        nn.Sigmoid(),
    )
    return model

model = build_model()
model.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE, weights_only=False))
model.eval()
model.to(DEVICE)

# Deterministic transform for inference (no random augmentation)
infer_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
])

# ── FastAPI app ────────────────────────────────────────────────────────────────

app = FastAPI(title="Save n Serve AI Service")

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        img = Image.open(io.BytesIO(contents)).convert("RGB")
    except Exception:
        raise HTTPException(status_code=400, detail="Cannot read image")

    tensor = infer_transform(img).unsqueeze(0).to(DEVICE)

    with torch.no_grad():
        prob = model(tensor).item()

    # prob > 0.5 → rotten (class index 1), else fresh (class index 0)
    label = "rotten" if prob > 0.5 else "fresh"
    confidence = round(prob if label == "rotten" else 1 - prob, 4)

    return JSONResponse({"status": label, "confidence": confidence})

# ── Entry point ────────────────────────────────────────────────────────────────
# Run with:  uvicorn ai_server:app --host 0.0.0.0 --port 8000 --reload

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("ai_server:app", host="0.0.0.0", port=8000, reload=True)
