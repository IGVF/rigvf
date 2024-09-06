{
    "query": "{{{query}}}",
    "bindVars": {{{bindVars}}},
    "count": true,
    {{#batchSize}}"batchSize": {{{batchSize}}},{{/batchSize}}
    "cache": true,
    "memoryLimit": 0,
    "ttl": 0,
    "options": {
        "allowDirtyReads": true,
        "allowRetry": false,
        "failOnWarning": true,
        "fillBlockCache": true,
        "fullCount": true,
        "intermediateCommitCount": 0,
        "intermediateCommitSize": 0,
        "maxDNFConditionMembers": 0,
        "maxNodesPerCallstack": 0,
        "maxNumberOfPlans": 0,
        "maxTransactionSize": 0,
        "maxWarningCount": 0,
        "profile": 0,
        "satelliteSyncWait": 0,
        "skipInaccessibleCollections": true,
        "spillOverThresholdMemoryUsage": 0,
        "spillOverThresholdNumRows": 0,
        "stream": true
    }
}
