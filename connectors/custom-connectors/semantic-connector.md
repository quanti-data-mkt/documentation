# Semantic Connector

The **Semantic Connector** is a custom connector that lets you expose external tables already present in your BigQuery project to QUANTI:'s Semantic Layer.

Unlike standard connectors that ingest data from external platforms, the Semantic Connector does not move or sync any data. It reads the structure of tables that originate outside QUANTI: — for example, an e-commerce order export, a CRM dataset, or any other table loaded into your project from a third-party source — and makes them available to the QUANTI: MCP.

This allows the MCP to intelligently cross-reference your external data with your QUANTI: connector data.

### Setup

* In the QUANTI: app, go to **Custom Connectors**
* Click **Add custom connector** and select **Semantic Connector** from the list
* Click **Setup**
* Enter a name for the connector and select the target dataset
* Click **Create** to confirm

The connector is created in a single step.

### Adding tables

Once the connector is created, go to the **Reports** tab.

* Click **Add table**
* Select the table you want to expose
* Choose the fields to include

Once the fields are configured, open the **Semantic** panel and add descriptions for each field. These descriptions feed the MCP and enable accurate cross-referencing with your other data sources.
