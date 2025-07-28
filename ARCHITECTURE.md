# Overall Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                           AWS Organization                          │
├─────────────────┬─────────────────┬─────────────────┬───────────────┤
│   Production    │     Staging     │  Development    │    Shared     │
│    Account      │    Account      │    Account      │   Services    │
│                 │                 │                 │   Account     │
├─────────────────┼─────────────────┼─────────────────┼───────────────┤
│                 │                 │                 │               │
│  ┌─────────────┐│  ┌─────────────┐│  ┌─────────────┐│ ┌───────────┐ │
│  │     VPC     ││  │     VPC     ││  │     VPC     ││ │CloudTrail │ │
│  │ 10.0.0.0/16 ││  │ 10.1.0.0/16 ││  │ 10.2.0.0/16 ││ │   Logs    │ │
│  └─────────────┘│  └─────────────┘│  └─────────────┘│ └───────────┘ │
│                 │                 │                 │               │
│  ┌─────────────┐│  ┌─────────────┐│  ┌─────────────┐│ ┌───────────┐ │
│  │ EKS Cluster ││  │ EKS Cluster ││  │ EKS Cluster ││ │ DNS Zone  │ │
│  │ Production  ││  │  Staging    ││  │Development  ││ │Management │ │
│  └─────────────┘│  └─────────────┘│  └─────────────┘│ └───────────┘ │
│                 │                 │                 │               │
│  ┌─────────────┐│  ┌─────────────┐│  ┌─────────────┐│ ┌───────────┐ │
│  │   Bastion   ││  │   Bastion   ││  │   Bastion   ││ │Monitoring │ │
│  │    Host     ││  │    Host     ││  │    Host     ││ │Aggregation│ │
│  └─────────────┘│  └─────────────┘│  └─────────────┘│ └───────────┘ │
│                 │                 │                 │               │
└─────────────────┴─────────────────┴─────────────────┴───────────────┘
```

## Network Architecture

### VPC Design

Each environment uses a dedicated VPC with carefully planned CIDR blocks:

```
Production VPC (10.0.0.0/16):
├── Public Subnets
│   ├── us-east-1a: 10.0.0.0/19    (32,768 IPs)
│   ├── us-east-1b: 10.0.32.0/19   (32,768 IPs)
│   └── us-east-1c: 10.0.64.0/19   (32,768 IPs)
└── Private Subnets
    ├── us-east-1a: 10.0.96.0/19   (32,768 IPs)
    ├── us-east-1b: 10.0.128.0/19  (32,768 IPs)
    └── us-east-1c: 10.0.160.0/19  (32,768 IPs)

Staging VPC (10.1.0.0/16):
├── Public Subnets: 10.1.0.0/19, 10.1.32.0/19, 10.1.64.0/19
└── Private Subnets: 10.1.96.0/19, 10.1.128.0/19, 10.1.160.0/19

Development VPC (10.2.0.0/16):
├── Public Subnets: 10.2.0.0/19, 10.2.32.0/19, 10.2.64.0/19
└── Private Subnets: 10.2.96.0/19, 10.2.128.0/19, 10.2.160.0/19
```

### Security Groups Strategy

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Group Layers                   │
├─────────────────┬─────────────────┬─────────────────────────┤
│  Load Balancer  │   Application   │       Database         │
│  Security Group │ Security Group  │   Security Group       │
├─────────────────┼─────────────────┼─────────────────────────┤
│ • Port 80/443   │ • App Ports     │ • DB Ports Only        │
│ • Internet →    │ • ALB → App     │ • App → DB Only        │
│ • Health Checks │ • Health Checks │ • Backup Access        │
└─────────────────┴─────────────────┴─────────────────────────┘
```

## Kubernetes Architecture

### EKS Cluster Design

```
┌─────────────────────────────────────────────────────────────┐
│                    EKS Control Plane                       │
│                   (Managed by AWS)                         │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────────┐
│                Node Groups                                  │
├─────────────────┬───┼───────┬───────────────┬───────────────┤
│  Ingress Nodes  │          │ App Nodes     │ Monitoring    │
│  c6i.xlarge     │   Core   │ t3.medium     │ r6i.large     │
│                 │   Nodes  │               │               │
│ • ALB Controller│   t3.med │ • Applications│ • Prometheus  │
│ • Nginx Ingress │          │ • Services    │ • Grafana     │
│ • Cert Manager  │   System │ • Workers     │ • Datadog     │
│                 │   Pods   │ • Autoscaling │ • Log Aggreg  │
└─────────────────┴───┴───────┴───────────────┴───────────────┘
```
