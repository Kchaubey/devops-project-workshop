#!/usr/bin/env bash
set -euo pipefail

# Demonstration only. Review the current Azure Monitor Scheduled Query Rules
# API contract and organization RBAC before using this in production.

SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
RESOURCE_GROUP="<RESOURCE_GROUP>"
LOCATION="<REGION>"
RULE_NAME="dp-databricks-job-consecutive-failure-prod"
WORKSPACE_RESOURCE_ID="<LOG_ANALYTICS_WORKSPACE_RESOURCE_ID>"
ACTION_GROUP_ID="<ACTION_GROUP_RESOURCE_ID>"

cat <<'KQL'
// Insert the validated query from kql/consecutive-failures.kql
let lookback = 48h;
let requiredFailures = 3;
// ...
KQL

echo "Rule: ${RULE_NAME}"
echo "Workspace: ${WORKSPACE_RESOURCE_ID}"
echo "Action Group: ${ACTION_GROUP_ID}"
echo "Subscription: ${SUBSCRIPTION_ID}"
echo "Resource Group: ${RESOURCE_GROUP}"
echo "Location: ${LOCATION}"

echo "Use the current Scheduled Query Rules API or IaC module to deploy the rule."
