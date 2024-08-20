## Google Cloud Subnetwork

Google Cloud Subnetworks are a part of the Virtual Private Cloud (VPC) network. They allow you to create logically isolated network partitions within the larger VPC network, each having its own IP address range. Subnetworks facilitate the organization and isolation of GCP resources, enabling them to communicate securely within a specified IP range.

### Design Decisions

This implementation includes the following design features:

- **Automatic CIDR Allocation:** If the network is set to automatic, CIDR ranges are dynamically assigned.
- **Private Google Access:** Enables private access for Google services within the subnet.
- **VPC Access Connector:** Facilitates serverless applications' access to Redis, Postgres, etc.
- **NAT Configuration:** Automatic NAT IP allocation to facilitate outgoing connections for instances without public IPs.
- **API Enablement:** This configuration needs specific APIs like `monitoring.googleapis.com` and `vpcaccess.googleapis.com` to be enabled for proper operation.

### Runbook

#### API Not Enabled

If you encounter issues with services not working correctly, you may need to check if the required APIs are enabled.

To view enabled services:

```sh
gcloud services list --enabled
```

If the required APIs are not listed, enable them:

```sh
gcloud services enable monitoring.googleapis.com
gcloud services enable vpcaccess.googleapis.com
```

#### Subnetwork Not Created

If the subnetwork is not created as expected, you can list existing subnetworks to verify:

```sh
gcloud compute networks subnets list --regions=<your-region>
```

Replace `<your-region>` with your specific region. If the subnetwork is not listed, check your configurations or retry creation.

#### Connectivity Issues

For connectivity issues within the VPC, verify the routes and firewall rules:

List routes:

```sh
gcloud compute routes list --filter="network=<your-vpc-name>"
```

Check firewall rules:

```sh
gcloud compute firewall-rules list --filter="network=<your-vpc-name>"
```

Replace `<your-vpc-name>` with your VPC name to ensure the correct routes and firewall rules are in place.

#### NAT Issues

If instances cannot access the internet, ensure that the NAT configuration is functioning correctly:

Check the NAT status:

```sh
gcloud compute routers nats list --router=<your-router-name> --region=<your-region>
```

Replace `<your-router-name>` and `<your-region>` with your specific router name and region.

For detailed logging:

```sh
gcloud logging read "resource.type=gce_router AND resource.labels.router_id=<your-router-name>" --limit=50
```

Here, replace `<your-router-name>` with your router's name to review the latest logs.

