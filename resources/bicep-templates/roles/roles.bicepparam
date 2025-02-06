using 'create-role.bicep'
var SUBSCRIPTION_NAME = 'azure-for-students'
var ENVIRONMENT = 'dev'
var RESOURCES_REGION = 'westus'
var PREFIX = '${SUBSCRIPTION_NAME}-${RESOURCES_REGION}-${ENVIRONMENT}'
param roles = [
  {
    roleName: '${PREFIX}-aks-read-and-delete-role'
    roleDescription: 'Role to read and delete cluster resources'
    actions: [
      'Microsoft.Authorization/*/read'
      'Microsoft.Resources/subscriptions/operationresults/read'
      'Microsoft.Resources/subscriptions/read'
      'Microsoft.Resources/subscriptions/resourceGroups/read'
      'Microsoft.ContainerService/managedClusters/listClusterUserCredential/action'
    ]
    notActions: []
    dataActions: [
      'Microsoft.ContainerService/managedClusters/*'
    ]
    notDataActions: []
  }
  {
    roleName: '${PREFIX}-aks-read-and-edit-role'
    roleDescription: 'Role to read and edit cluster resources'
    actions: [
      'Microsoft.Authorization/*/read'
      'Microsoft.Resources/subscriptions/operationresults/read'
      'Microsoft.Resources/subscriptions/read'
      'Microsoft.Resources/subscriptions/resourceGroups/read'
      'Microsoft.ContainerService/managedClusters/listClusterUserCredential/action'
    ]
    notActions: []
    dataActions: [
      'Microsoft.ContainerService/managedClusters/apps/controllerrevisions/read'
      'Microsoft.ContainerService/managedClusters/apps/daemonsets/*'
      'Microsoft.ContainerService/managedClusters/apps/deployments/*'
      'Microsoft.ContainerService/managedClusters/apps/replicasets/*'
      'Microsoft.ContainerService/managedClusters/apps/statefulsets/*'
      'Microsoft.ContainerService/managedClusters/autoscaling/horizontalpodautoscalers/*'
      'Microsoft.ContainerService/managedClusters/batch/cronjobs/*'
      'Microsoft.ContainerService/managedClusters/coordination.k8s.io/leases/read'
      'Microsoft.ContainerService/managedClusters/coordination.k8s.io/leases/write'
      'Microsoft.ContainerService/managedClusters/coordination.k8s.io/leases/delete'
      'Microsoft.ContainerService/managedClusters/discovery.k8s.io/endpointslices/read'
      'Microsoft.ContainerService/managedClusters/batch/jobs/*'
      'Microsoft.ContainerService/managedClusters/configmaps/*'
      'Microsoft.ContainerService/managedClusters/endpoints/*'
      'Microsoft.ContainerService/managedClusters/events.k8s.io/events/read'
      'Microsoft.ContainerService/managedClusters/events/*'
      'Microsoft.ContainerService/managedClusters/extensions/daemonsets/*'
      'Microsoft.ContainerService/managedClusters/extensions/deployments/*'
      'Microsoft.ContainerService/managedClusters/extensions/ingresses/*'
      'Microsoft.ContainerService/managedClusters/extensions/networkpolicies/*'
      'Microsoft.ContainerService/managedClusters/extensions/replicasets/*'
      'Microsoft.ContainerService/managedClusters/limitranges/read'
      'Microsoft.ContainerService/managedClusters/metrics.k8s.io/pods/read'
      'Microsoft.ContainerService/managedClusters/metrics.k8s.io/nodes/read'
      'Microsoft.ContainerService/managedClusters/namespaces/read'
      'Microsoft.ContainerService/managedClusters/networking.k8s.io/ingresses/*'
      'Microsoft.ContainerService/managedClusters/networking.k8s.io/networkpolicies/*'
      'Microsoft.ContainerService/managedClusters/persistentvolumeclaims/*'
      'Microsoft.ContainerService/managedClusters/pods/*'
      'Microsoft.ContainerService/managedClusters/policy/poddisruptionbudgets/*'
      'Microsoft.ContainerService/managedClusters/replicationcontrollers/*'
      'Microsoft.ContainerService/managedClusters/resourcequotas/read'
      'Microsoft.ContainerService/managedClusters/secrets/*'
      'Microsoft.ContainerService/managedClusters/serviceaccounts/*'
      'Microsoft.ContainerService/managedClusters/services/*'

    ]
    notDataActions: []
  }
  {
    roleName: '${PREFIX}-aks-read-only-role'
    roleDescription: 'Role to read cluster resources'
    actions: [
      'Microsoft.Authorization/*/read'
      'Microsoft.Resources/subscriptions/operationresults/read'
      'Microsoft.Resources/subscriptions/read'
      'Microsoft.Resources/subscriptions/resourceGroups/read'
      'Microsoft.ContainerService/managedClusters/listClusterUserCredential/action'
    ]
    notActions: []
    dataActions: [
      'Microsoft.ContainerService/managedClusters/apps/daemonsets/read'
      'Microsoft.ContainerService/managedClusters/apps/deployments/read'
      'Microsoft.ContainerService/managedClusters/apps/replicasets/read'
      'Microsoft.ContainerService/managedClusters/apps/statefulsets/read'
      'Microsoft.ContainerService/managedClusters/autoscaling/horizontalpodautoscalers/read'
      'Microsoft.ContainerService/managedClusters/batch/cronjobs/read'
      'Microsoft.ContainerService/managedClusters/batch/jobs/read'
      'Microsoft.ContainerService/managedClusters/configmaps/read'
      'Microsoft.ContainerService/managedClusters/discovery.k8s.io/endpointslices/read'
      'Microsoft.ContainerService/managedClusters/endpoints/read'
      'Microsoft.ContainerService/managedClusters/events.k8s.io/events/read'
      'Microsoft.ContainerService/managedClusters/events/read'
      'Microsoft.ContainerService/managedClusters/extensions/daemonsets/read'
      'Microsoft.ContainerService/managedClusters/extensions/deployments/read'
      'Microsoft.ContainerService/managedClusters/extensions/ingresses/read'
      'Microsoft.ContainerService/managedClusters/extensions/networkpolicies/read'
      'Microsoft.ContainerService/managedClusters/extensions/replicasets/read'
      'Microsoft.ContainerService/managedClusters/limitranges/read'
      'Microsoft.ContainerService/managedClusters/metrics.k8s.io/pods/read'
      'Microsoft.ContainerService/managedClusters/metrics.k8s.io/nodes/read'
      'Microsoft.ContainerService/managedClusters/namespaces/read'
      'Microsoft.ContainerService/managedClusters/networking.k8s.io/ingresses/read'
      'Microsoft.ContainerService/managedClusters/networking.k8s.io/networkpolicies/read'
      'Microsoft.ContainerService/managedClusters/persistentvolumeclaims/read'
      'Microsoft.ContainerService/managedClusters/pods/read'
      'Microsoft.ContainerService/managedClusters/policy/poddisruptionbudgets/read'
      'Microsoft.ContainerService/managedClusters/replicationcontrollers/read'
      'Microsoft.ContainerService/managedClusters/resourcequotas/read'
      'Microsoft.ContainerService/managedClusters/serviceaccounts/read'
      'Microsoft.ContainerService/managedClusters/services/read'
    ]
    notDataActions: []
  }
]
