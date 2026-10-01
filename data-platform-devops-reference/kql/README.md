# KQL Library

## Reusable mapping

The templates use `column_ifexists()` so the logical fields can be adapted to different schemas.

```kusto
extend JobId = tostring(column_ifexists("JobId", ""))
```

## Core concepts

- `runStart` — run started
- `runSucceeded` — successful run
- `runFailed` — failed run
- `RunId` — execution identifier
- `JobId` — job identifier
- `JobName` — readable job name

Validate the exact event names and fields in the target workspace before production rollout.

## Query categories

- `job-failure.kql` — raw failure investigation
- `consecutive-failures.kql` — repeated failure alert
- `long-running-jobs.kql` — started but not terminal
- `no-success-recovery.kql` — failed and not recovered

## Alert-query standard

An alert query should have a clear lookback, explicit threshold, deterministic entity grouping and compact output. Empty result should mean healthy.
