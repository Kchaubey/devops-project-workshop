# Reference Architecture

```text
Azure Databricks Jobs
        |
        | Diagnostic logs
        v
Log Analytics Workspace
        |
        +--> Investigation KQL
        |
        +--> Alert KQL
                 |
                 v
        Azure Monitor Scheduled Query Rule
                 |
                 v
            Action Group
                 |
        +--------+---------+
        |        |         |
   PagerDuty  Power Automate  Email/Teams
        |        |         |
        +--------+---------+
                 |
                 v
          On-call Runbook
                 |
                 v
            RCA / Changes
```

## Components

### 1. Databricks
Produces audit/job lifecycle events such as run start and terminal outcomes.

### 2. Log Analytics
Stores telemetry and provides the KQL query surface.

### 3. KQL
Converts raw events into an operational signal.

### 4. Scheduled Query Rule
Executes the KQL on a defined cadence and evaluates the condition.

### 5. Action Group
Provides the notification and automation fan-out.

### 6. Runbook
Defines the human response from detection through recovery.

## Context model

A useful alert should contain, directly or through dimensions/custom properties:

- environment
- platform/domain
- JobId
- JobName
- FailureCount
- LastFailureTime
- LastRunId
- alert rule name
- runbook link
- search-results link

Avoid placing credentials, tokens, full raw log payloads or unnecessary high-cardinality values into alert context.

## Environment promotion

Use one logical alert design and promote it across DEV → QA → STAGING → PROD. Only environment-specific resource IDs, Action Groups, routing targets and intentionally different thresholds should change.
