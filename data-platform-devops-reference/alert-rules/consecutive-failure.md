# Alert Rule — Consecutive Databricks Job Failure

## Purpose

Detect repeated failed job runs without successful recovery.

## Source query

`kql/consecutive-failures.kql`

## Condition

Recommended result-count model:

`Number of search results > 0`

The query itself decides whether a particular JobId has crossed the consecutive-failure threshold.

## Example settings

| Setting | Example |
|---|---|
| KQL lookback | 48h |
| Evaluation frequency | 5m |
| Required failed runs | 3 |
| Severity | organization-specific |
| Dimensions | JobId, JobName |
| Action Group | Data Platform On-call |

These are demonstration values only. Use workload schedule, retry policy and SLA requirements to select production values.

## Custom context

Recommended context:

- Environment
- JobId
- JobName
- FailureCount
- LastFailureTime
- LastRunId
- Alert rule name
- Runbook URL
- Search result link

Azure Monitor supports custom properties for downstream automation actions, and the Common Alert Schema provides standardized alert metadata.

## Validation

1. Success then one failure — no alert.
2. Success then two failures — no alert when threshold is three.
3. Success then three failures — alert.
4. Three failures followed by success — recovery.
5. Multiple jobs — each job must remain independently identifiable.
6. Job with no historical success — follow the documented policy for this case.
