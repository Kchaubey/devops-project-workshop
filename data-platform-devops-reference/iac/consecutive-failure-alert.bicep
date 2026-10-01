@description('Name of the scheduled query alert rule')
param alertRuleName string = 'dp-databricks-job-consecutive-failure-prod'

@description('Azure region for the alert resource')
param location string = resourceGroup().location

@description('Log Analytics workspace resource ID')
param workspaceResourceId string

@description('Existing Action Group resource ID')
param actionGroupResourceId string

@description('Runbook URL')
param runbookUrl string

resource alertRule 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: alertRuleName
  location: location
  kind: 'LogAlert'
  properties: {
    displayName: alertRuleName
    description: 'Detect repeated Databricks job failures without successful recovery'
    severity: 2
    enabled: true
    evaluationFrequency: 'PT5M'
    windowSize: 'PT10M'
    scopes: [
      workspaceResourceId
    ]
    criteria: {
      allOf: [
        {
          query: '''
let lookback = 48h;
let requiredFailures = 3;

let events =
    DatabricksJobs
    | where TimeGenerated >= ago(lookback)
    | extend
        JobId = tostring(column_ifexists("JobId", "")),
        JobName = tostring(column_ifexists("JobName", "")),
        RunId = tostring(column_ifexists("RunId", "")),
        ActionName = tostring(column_ifexists("ActionName", ""));

let latestSuccess =
    events
    | where ActionName == "runSucceeded"
    | summarize LastSuccessTime = max(TimeGenerated) by JobId;

let failuresSinceSuccess =
    events
    | where ActionName == "runFailed"
    | join kind=leftouter latestSuccess on JobId
    | extend Cutoff = coalesce(LastSuccessTime, ago(lookback))
    | where TimeGenerated > Cutoff
    | summarize
        FailureCount = count(),
        LastFailureTime = max(TimeGenerated),
        LastRunId = arg_max(TimeGenerated, RunId)
      by JobId, JobName, LastSuccessTime;

failuresSinceSuccess
| where FailureCount >= requiredFailures
| project JobId, JobName, FailureCount, LastFailureTime, LastRunId, LastSuccessTime
'''
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 0
          dimensions: [
            {
              name: 'JobId'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'JobName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
        }
      ]
    }
    actions: {
      actionGroups: [
        actionGroupResourceId
      ]
      customProperties: {
        Environment: 'PROD'
        Signal: 'DatabricksJobConsecutiveFailure'
        Runbook: runbookUrl
      }
    }
    autoMitigate: true
  }
}
