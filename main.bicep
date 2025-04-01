// Parameters
param location string = resourceGroup().location
param containerGroupName string = 'osmedeus-aci'
param containerImage string = 'j3ssie/osmedeus:latest' // Corrected image
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
              cpu: 1
              memoryInGB: 2
            }
          }
          ports: [
            {
              port: containerPort
            }
          ]
          command: ['osmedeus', 'server'] // Added command to start the server
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
    restartPolicy: 'Always'
  }
}
