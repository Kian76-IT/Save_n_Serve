import { createClient } from "@supabase/supabase-js";
import multer from "multer";
import path from "path";

// Use service role key to bypass Storage RLS; fall back to anon key.
// Add SUPABASE_SERVICE_KEY to your .env for this to work correctly.
const storageClient = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY ?? process.env.SUPABASE_ANON_KEY
);

const BUCKET = "food-images";

const ALLOWED_EXTENSIONS = new Set([".jpg", ".jpeg", ".png", ".webp"]);

export const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024, files: 10 },
  fileFilter: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if (ALLOWED_EXTENSIONS.has(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only jpg, jpeg, png, webp images are allowed"));
    }
  },
});

/*
  POST /uploads
  Accepts up to 10 image files (field name: "images").
  Uploads each to Supabase Storage and returns their public URLs.
*/
export const uploadImages = async (req, res) => {
  try {
    const files = req.files;
    if (!files || files.length === 0) {
      return res.status(400).json({ message: "No files uploaded" });
    }

    const urls = [];

    for (const file of files) {
      const ext = path.extname(file.originalname).toLowerCase();
      const fileName = `${Date.now()}-${Math.random().toString(36).slice(2, 9)}${ext}`;

      const { data, error } = await storageClient.storage
        .from(BUCKET)
        .upload(fileName, file.buffer, {
          contentType: file.mimetype,
          upsert: false,
        });

      if (error) {
        return res.status(500).json({ message: `Upload failed: ${error.message}` });
      }

      const {
        data: { publicUrl },
      } = storageClient.storage.from(BUCKET).getPublicUrl(data.path);

      urls.push(publicUrl);
    }

    return res.status(200).json({ urls });
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
};
