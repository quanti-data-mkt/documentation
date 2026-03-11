---
description: This page explains how to set-up QUANTI MCP in your favorite LLM
---

# MCP Set-up

***

### Set-up by AI LLM

{% stepper %}
{% step %}
#### Claude (Anthropic)

**Claude.ai (browser)**

* Log in to [claude.ai](https://claude.ai)
* Go to **Settings > Integrations > Add Integration**
* Paste the Quanti MCP server URL
* Authenticate with your Quanti account

**Claude Desktop (application)**

Edit the Claude configuration file:

* **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
* **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

Add the following configuration:

```json
{
  "mcpServers": {
    "quanti": {
      "url": "YOUR_QUANTI_MCP_SERVER_URL"
    }
  }
}
```

Restart Claude Desktop. The MCP icon will appear in the input area.
{% endstep %}

{% step %}
#### ChatGPT (OpenAI)

* Log in to [chatgpt.com](https://chatgpt.com)
* Go to **Settings > Apps**
* Activate the **Developer mode**
* Click **Create App**
* Set the Quanti MCP server URL
{% endstep %}

{% step %}
#### Microsoft Copilot

* Open [copilot.microsoft.com](https://copilot.microsoft.com)
* Go to **Settings > Plugins > Add plugin**
* Enter the Quanti MCP server URL
* Connect your Quanti account via OAuth
{% endstep %}

{% step %}
#### Le Chat (Mistral)

* Log in to [chat.mistral.ai](https://chat.mistral.ai)
* Go to **Settings > Connectors > Add connector**
* Add the Quanti server URL
* Validate OAuth authentication
{% endstep %}
{% endstepper %}

***

### Troubleshooting

<details>

<summary>Need Help?</summary>

Contact QUANTI support at [support@quanti.io](mailto:support@quanti.io) or consult our comprehensive documentation at [https://docs.quanti.io](https://docs.quanti.io)

</details>

