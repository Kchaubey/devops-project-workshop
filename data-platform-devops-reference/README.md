# Data Platform DevOps — Azure Monitor Alerting Reference

A reusable production-style reference for monitoring data-platform workloads with Azure Monitor, Log Analytics and KQL. Databricks Jobs are the primary worked example, but the patterns are intended to be reused for ADF, Fabric, Power BI refreshes, streaming workloads and other data services.

## Core workflow

Requirement → Telemetry → Investigation KQL → Alert KQL → Scheduled Query Rule → Action Group → Incident routing → Runbook → RCA

## What is included

- Azure Databricks diagnostic logging to Log Analytics
- Databricks job failure detection
- Consecutive-failure detection using latest-success recovery semantics
- Long-running job detection
- No-success recovery detection
- Alert dimensions and Common Alert Schema guidance
- Power Automate / Logic Apps / PagerDuty integration pattern
- Production runbooks and RCA workflow
- Azure CLI / Scheduled Query Rule deployment example
- An anonymized layered-lakehouse reference scenario

## Structure

```text
data-platform-devops-reference/
├── README.md
├── docs/
│   ├── implementation-guide.md
│   ├── architecture.md
│   ├── alert-design.md
│   └── references.md
├── kql/
│   ├── README.md
│   ├── job-failure.kql
│   ├── consecutive-failures.kql
│   ├── long-running-jobs.kql
│   └── no-success-recovery.kql
├── alert-rules/
│   └── consecutive-failure.md
├── automation/
│   └── pagerduty-payload-example.json
├── runbooks/
│   └── consecutive-failure.md
├── iac/
│   └── scheduled-query-alert.example.sh
└── examples/
    └── layered-lakehouse.md
```

## Important: validate schema first

Microsoft currently documents `DatabricksJobs` as the Log Analytics table for Databricks Jobs audit logs. Your organization may also have a normalized/custom table. Always validate the actual schema before copying a query:

```kusto
DatabricksJobs
| getschema
```

Then inspect real records:

```kusto
DatabricksJobs
| where TimeGenerated > ago(1h)
| order by TimeGenerated desc
| take 20
```

Typical logical fields are TimeGenerated, ActionName, JobId, JobName and RunId. Confirm the exact names in your workspace.

## Reference scenario

A scheduled layered-lakehouse workload has a downstream SLA. One transient job failure may be retried automatically. Repeated failures without a successful recovery should create an actionable incident with the affected JobId, JobName, failure count and latest run context.

The project-specific names, IDs, URLs and thresholds are intentionally removed. Replace placeholders for your own environment.

## Design principles

1. Alert on actionable conditions, not every raw event.
2. Keep investigation queries separate from alert queries.
3. Make success/recovery semantics explicit.
4. Return compact, stable alert context.
5. Keep thresholds configurable and documented.
6. Version-control alert definitions and runbooks.
7. Never commit credentials, tokens or private identifiers.

## GitHub working branch

This reference is isolated on the `data-platform-devops-monitoring` branch of the existing `Kchaubey/devops-project-workshop` repository so the current `main` branch is not changed.
