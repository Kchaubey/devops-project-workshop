# Implementation Guide

## Phase 1 — Telemetry

For Azure Databricks, configure Diagnostic settings on the Databricks workspace and send the required diagnostic logs to the target Log Analytics workspace.

Microsoft documents Log Analytics as a supported destination for Databricks diagnostic logs.

## Phase 2 — Schema discovery

Start with:

```kusto
DatabricksJobs
| getschema
```

Then inspect:

```kusto
DatabricksJobs
| where TimeGenerated > ago(24h)
| project TimeGenerated, ActionName, JobId, JobName, RunId
| order by TimeGenerated desc
| take 100
```

If a column does not exist in your table, replace it with the real field name. Use `column_ifexists()` when building reusable templates.

## Phase 3 — Baseline behavior

Before creating an alert, establish normal behavior:

```kusto
DatabricksJobs
| where TimeGenerated > ago(7d)
| summarize Total=count(), Failed=countif(ActionName == "runFailed"), Succeeded=countif(ActionName == "runSucceeded") by bin(TimeGenerated, 1h)
| order by TimeGenerated asc
```

Use this baseline to understand schedule frequency, normal retries and expected success/failure volume.

## Phase 4 — Alert query

Use `kql/consecutive-failures.kql` for the reusable repeated-failure pattern.

The key logic is:

1. Read job lifecycle events.
2. Find the latest successful event per JobId.
3. Count failures after that success.
4. Compare against the required consecutive-failure threshold.
5. Return one row per affected job.

This means a later successful run resets the failure sequence.

## Phase 5 — Azure Monitor scheduled query alert

Portal path:

Azure Monitor → Alerts → Create → Alert rule

For the scope, select the Log Analytics workspace that receives the Databricks events.

Condition:

1. Select Custom log search.
2. Paste the validated KQL.
3. Use a result-count condition such as Number of results > 0.
4. Configure the evaluation frequency and search window.
5. Add dimensions such as JobId and JobName when supported by the selected rule configuration.
6. Select the Action Group.
7. Set severity.
8. Add useful custom properties.
9. Create and test the rule.

Azure Monitor Scheduled Query Rules support query criteria, dimensions, failing periods, action groups and custom properties.

## Phase 6 — Action Group

Build a shared Action Group for the data platform. Downstream options can include email, webhook, Logic Apps, Power Automate and PagerDuty integration.

For automation, prefer the Common Alert Schema so downstream logic can consume a consistent alert envelope.

## Phase 7 — Test matrix

| Test case | Expected |
|---|---|
| Success → Success | No alert |
| Success → Failure | No alert when threshold is 2+ |
| Success → Failure → Failure | Alert at threshold 2 |
| Failure → Failure → Success | Recovered; no ongoing alert |
| Job A fails, Job B healthy | Only Job A context |
| Two jobs reach threshold | Both affected job contexts |

## Phase 8 — Production hardening

- Document threshold rationale.
- Link a runbook.
- Assign an owner.
- Verify RBAC.
- Verify Action Group routing.
- Review alert frequency and query cost.
- Define maintenance/suppression behavior.
- Test the recovery path, not only the firing path.
