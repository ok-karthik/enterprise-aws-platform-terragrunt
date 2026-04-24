# 💰 FinOps & Cost Optimization Strategy

This platform is designed with "Cost-Aware Infrastructure" principles, ensuring transparency and efficiency in cloud spending.

## 📊 Cost Visibility (Infracost)
Every Pull Request triggers an automated cost breakdown using **Infracost**.
- **Visual Gating**: Cost changes are posted as comments in the PR.
- **Threshold Alerts**: Any change increasing monthly costs by more than 20% requires explicit Senior Engineer review.

## 💸 Saving Strategies

### 1. Spot Instance Orchestration
In the `dev` environment, we leverage **AWS Spot Instances** for EKS Managed Node Groups.
- **Impact**: Up to 90% cost reduction compared to On-Demand.
- **Graceful Termination**: Handled via the AWS Node Termination Handler.

### 2. Environment Life-cycling
Non-production environments follow a surgical lifecycle:
- **Manual Teardown**: A dedicated workflow allows for destroying expensive resources (RDS, EKS) when they are not needed for testing.
- **Resource Sizing**: `dev` environments use the smallest viable Nitro instances (e.g., `t3.medium`) compared to high-availability `prod` types.

### 3. Storage Optimization
- **S3 Intelligent-Tiering**: Automatically enabled for data buckets with unknown access patterns.
- **EBS Lifecycle**: Snapshots older than 30 days are automatically transitioned to Glacier or deleted (except for `prod`).

## 🏷️ Cost Allocation
100% of resources are tagged with `Project` and `Environment`. This allows for granular reporting in **AWS Cost Explorer** using Tag-Based Cost Allocation.

## 🚀 Future Roadmap
- **Automated "Shutdown at Night"**: Implementation of instance scheduling for `dev` environments.
- **Karpenter Integration**: Replacing Cluster Autoscaler with Karpenter for more aggressive rightsizing of Kubernetes nodes.
