import { Hono } from "hono"
import { bearerAuth } from "hono/bearer-auth"
import { cors } from "hono/cors"
import { logger } from "hono/logger"

import { completionRoutes } from "./routes/chat-completions/route"
import { embeddingRoutes } from "./routes/embeddings/route"
import { messageRoutes } from "./routes/messages/route"
import { modelRoutes } from "./routes/models/route"
import { tokenRoute } from "./routes/token/route"
import { usageRoute } from "./routes/usage/route"

export const server = new Hono()

server.use(logger())
server.use(cors())

// API key authentication — set COPILOT_API_KEY env var to enable
const apiKey = process.env.COPILOT_API_KEY
if (apiKey) {
  server.use("*", async (c, next) => {
    // Check x-api-key header first (Anthropic-style)
    const xApiKey = c.req.header("x-api-key")
    if (xApiKey === apiKey) {
      return next()
    }
    // Fall back to Authorization: Bearer (OpenAI-style)
    const auth = bearerAuth({ token: apiKey })
    return auth(c, next)
  })
}

server.get("/", (c) => c.text("Server running"))

server.route("/chat/completions", completionRoutes)
server.route("/models", modelRoutes)
server.route("/embeddings", embeddingRoutes)
server.route("/usage", usageRoute)
server.route("/token", tokenRoute)

// Compatibility with tools that expect v1/ prefix
server.route("/v1/chat/completions", completionRoutes)
server.route("/v1/models", modelRoutes)
server.route("/v1/embeddings", embeddingRoutes)

// Anthropic compatible endpoints
server.route("/v1/messages", messageRoutes)
