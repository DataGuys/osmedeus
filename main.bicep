// Parameters
param location string = resourceGroup().location
param containerGroupName string = 'osmedeus-aci'
param containerImage string = 'mablanco/osmedeus:latest' // Replace with the desired Osmedeus Docker image
param containerPort int = 8000

// Container Group Resource (ACI)
resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: containerGroupName
  location: location
  properties: {
    osType: 'Linux'
    containers: [
      {
        name: 'osmedeus'
        properties: {
          image: containerImage
          resources: {
            requests: {
              cpu: 1.0
              memoryInGB: 1.5
            }
          }
          ports: [
            {
              port: containerPort
            }
          ]
        }
      }
    ]
    ipAddress: {
      type: 'Public'
      ports: [
        {
          protocol: 'TCP'
          port: containerPort
        }
      ]
    }
  }
}
