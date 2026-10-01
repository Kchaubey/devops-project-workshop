# Microsoft References

## Azure Monitor

- Create log search alert rules: https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-log-alert-rule
- Common Alert Schema: https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-common-schema
- Alert payload samples: https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-payload-samples
- Scheduled Query Rules API: https://learn.microsoft.com/en-us/rest/api/monitor/scheduled-query-rules/create-or-update?view=rest-monitor-2021-08-01
- Diagnostic settings: https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings

## Azure Databricks

- Diagnostic log delivery: https://learn.microsoft.com/en-us/azure/databricks/admin/account-settings/audit-log-delivery
- Diagnostic log reference: https://learn.microsoft.com/en-us/azure/databricks/admin/account-settings/audit-logs
- Databricks Log Analytics tables: https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/microsoft-databricks-workspaces

## Current implementation note

Microsoft's current Azure Monitor table reference lists `DatabricksJobs` as the Log Analytics table for Databricks Jobs audit logs. The Databricks audit-log documentation includes job lifecycle events such as `runStart` and `runSucceeded`.

Documentation and schemas can change, so re-check the Microsoft references when adapting this repository to a new environment.
