# Worked Example — Layered Lakehouse Batch Platform

## Scenario

A data platform processes data through a layered lakehouse:

```text
Source → Landing/Bronze → Silver → Gold → Reporting
```

Several scheduled Databricks jobs form the transformation chain. A downstream SLA depends on the jobs recovering within the expected processing window.

## Requirement

A single transient failure can be retried. Repeated failures without a successful recovery should generate an actionable incident.

## Detection logic

Example sequence:

```text
08:00  runSucceeded
09:00  runFailed
10:00  runFailed
11:00  runFailed   ← alert threshold reached
12:00  runSucceeded ← recovery
```

The query in `kql/consecutive-failures.kql` treats the latest success as the reset point and counts failures after it.

## Expected alert context

```text
Environment: PROD
Job: <JOB_NAME>
JobId: <JOB_ID>
FailureCount: 3
LastFailureTime: <UTC_TIME>
LastRunId: <RUN_ID>
Runbook: <URL>
```

## Investigation path

1. Confirm the failed run.
2. Check whether an upstream job or data source failed first.
3. Check runtime/cluster/serverless health.
4. Check code, dependency and configuration changes.
5. Check network/storage/identity errors.
6. Retry only when safe.
7. Verify successful recovery.
8. Record RCA.

## Reuse for other platforms

| Workload | Equivalent pattern |
|---|---|
| ADF pipeline | failed pipelines since last success |
| Fabric pipeline | failed executions since last success |
| Power BI refresh | refresh failure after latest success |
| Streaming workload | unhealthy/stopped state window |
| API ingestion | failure-rate threshold |
| Data quality | failed rule threshold per dataset |
