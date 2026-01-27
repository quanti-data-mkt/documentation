---
description: This page explains how to set-up QUANTI MCP in your favorite LLM
---

# MCP Set-up

***

## Set-up by AI LLM

#### Claude (Anthropic)

**Claude.ai (browser)**

1. Log in to claude.ai
2. Go to **Settings > Integrations > Add Integration**
3. Paste the Quanti MCP server URL
4. Authenticate with your Quanti account

**Claude Desktop (application)**

Edit the Claude configuration file:

* **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
* **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

Add the following configuration:

json

```json
{
  "mcpServers": {
    "quanti": {
      "url": "https://mcp-public.app.quanti.io/mcp"
    }
  }
}
```

Restart Claude Desktop. The MCP icon will appear in the input area.

#### ChatGPT (OpenAI)

1. Log in to chatgpt.com

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

1. Go to **Settings > Apps**
2. Activate the developper mode
3. Create APP

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

4. Set the MCP URL in&#x20;

```
https://mcp-public.app.quanti.io/mcp
```

#### Microsoft Copilot

1. Open copilot.microsoft.com
2. Go to **Settings > Plugins > Add plugin**
3. Enter the Quanti MCP server URL
4. Connect your Quanti account via OAuth

#### Le Chat (Mistral)

1. Log in to chat.mistral.ai
2. Go to **Settings > Connectors > Add connector**
3. Add the Quanti server URL
4. Validate OAuth authentication

