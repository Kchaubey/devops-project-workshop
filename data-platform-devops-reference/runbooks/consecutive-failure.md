# Runbook — Consecutive Databricks Job Failure

## Trigger

Use when the alert reports repeated failed runs without successful recovery.

## 1. Identify the workload

Capture:

- Environment
- JobId
- JobName
- FailureCount
- LastRunId
- LastFailureTime

## 2. Check for recovery

```kusto
let targetJobId = "<JOB_ID>";
DatabricksJobs
| where TimeGenerated > ago(6h)
| extend JobId = tostring(column_ifexists("JobId", "")), ActionName = tostring(column_ifexists("ActionName", "")), RunId = tostring(column_ifexists("RunId", ""))
| where JobId == targetJobId
| project TimeGenerated, ActionName, RunId
| order by TimeGenerated desc
```

If a new `runSucceeded` event is present, the alert may already be recovered.

## 3. Investigate the failed run

Check:

- failed task/notebook
- exception message
- runtime and compute health
- dependency/library changes
- upstream data availability
- schema/data-quality issues
- storage/network connectivity
- identity/RBAC/secret failures
- recent application or configuration changes

## 4. Mitigate

Use the approved workload procedure. A manual retry is appropriate only when the data-processing semantics and side effects are understood.

## 5. Verify

Recovery should be supported by evidence such as a successful run event and restored downstream freshness/SLA.

## 6. Record RCA

Capture summary, impact, timeline, root cause, remediation, prevention and monitoring improvements.
