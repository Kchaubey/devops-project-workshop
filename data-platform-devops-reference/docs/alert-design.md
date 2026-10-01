# Alert Design Standards

## Naming

Recommended format:

`DP-<Platform>-<Signal>-<Condition>-<Environment>`

Example:

`DP-Databricks-Job-ConsecutiveFailure-Prod`

## Threshold design

For repeated-failure monitoring define:

- N = required number of consecutive failed runs
- W = KQL lookback window
- F = alert evaluation frequency
- R = built-in retry behavior
- B = business/SLA impact window

Do not use an arbitrary threshold. Document why the value is appropriate for the workload.

## Event failures vs evaluation failures

These are different:

**Three failed job runs** should be encoded in KQL sequence/state logic.

**Three failed alert evaluations** can be modeled with Scheduled Query Rule failing periods.

Do not mix the two.

## Dimensions

Good dimensions:

- JobId
- JobName
- Environment
- DataDomain

Avoid:

- request IDs
- user email addresses
- full exception text
- sensitive identifiers
- extremely high-cardinality values

## Severity

Use a documented organization-wide mapping. Azure Monitor Scheduled Query Rules support severity values 0 through 4.

## Alert fatigue

A useful alert answers:

What happened? Where? Since when? How bad? What should I check next?

If an engineer must manually reconstruct all context before starting triage, the alert is too weak.

## Cost and performance

Keep alert queries efficient:

- filter TimeGenerated early
- project only needed columns
- avoid unnecessary wide joins
- keep output compact
- use realistic evaluation frequency
- review ingestion/query cost for high-volume tables
