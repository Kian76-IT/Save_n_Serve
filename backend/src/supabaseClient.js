import { createClient } from "@supabase/supabase-js";
import "dotenv/config";

// Shared client — used by route handlers and auth middleware.
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

// Isolated admin client for server-side writes that must bypass RLS.
// persistSession/autoRefreshToken disabled so auth middleware calls on the
// shared client cannot bleed into this instance's auth state.
export const supabaseAdmin = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
);

export default supabase;