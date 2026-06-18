const AI_SERVICE_URL = process.env.AI_SERVICE_URL ?? "http://localhost:8000";

/*
  POST /ai/check
  Accepts a single image (field: "image"), forwards it to the Python AI
  service, and returns { status: "fresh" | "rotten", confidence: number }.

  This is a soft check — the caller decides what to do with the result.
  A network failure or timeout returns { status: "unknown" } so the client
  can always proceed without being hard-blocked.
*/
export const checkFreshness = async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No image provided" });
  }

  try {
    const formData = new FormData();
    formData.append(
      "file",
      new Blob([req.file.buffer], { type: req.file.mimetype }),
      req.file.originalname
    );

    const aiRes = await fetch(`${AI_SERVICE_URL}/predict`, {
      method: "POST",
      body: formData,
      signal: AbortSignal.timeout(10_000),
    });

    if (!aiRes.ok) {
      const text = await aiRes.text();
      console.error("[AI] predict failed:", text);
      return res.status(200).json({ status: "unknown", confidence: null });
    }

    const data = await aiRes.json();
    return res.status(200).json(data);
  } catch (err) {
    // Timeout or Python server not running — soft-fail, don't block the user.
    console.warn("[AI] service unreachable:", err.message);
    return res.status(200).json({ status: "unknown", confidence: null });
  }
};
