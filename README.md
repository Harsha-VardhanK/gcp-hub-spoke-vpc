GCP Hub-Spoke VPC Architecture

Production-style hub-and-spoke network topology on Google Cloud, built with Terraform and deployed via GitHub Actions using Workload Identity Federation (no service account keys).

Architecture

                    ┌─────────────────────────────┐
                    │         HUB VPC              │
                    │     (gcpai-iac-dev)           │
                    │                               │
                    │  10.0.0.0/24                  │
                    │  - Cloud Router               │
                    │  - Cloud NAT                  │
                    │  - Baseline firewall rules     │
                    └───────────┬───────────┬───────┘
                  VPC Peering   │           │   VPC Peering
                    ┌───────────┘           └───────────┐
                    ▼                                    ▼
        ┌───────────────────────┐          ┌───────────────────────┐
        │      DEV SPOKE         │          │      PROD SPOKE        │
        │   (gcpai-iac-dev)      │          │   (gcpai-iac-prod)     │
        │                        │          │                        │
        │  Subnet: 10.1.0.0/24   │          │  Subnet: 10.2.0.0/24   │
        │  Pods:   10.1.128.0/17 │          │  Pods:   10.2.128.0/17 │
        │  Svc:    10.1.64.0/20  │          │  Svc:    10.2.64.0/20  │
        └───────────────────────┘          └───────────────────────┘

Each spoke is isolated from the other spoke — VPC Peering is non-transitive by design, so dev and prod cannot route to each other even though both peer with hub. Only the hub provides shared services (NAT, future shared DNS/bastion).

Why VPC Peering Instead of Shared VPC

GCP's Shared VPC requires an Organization resource to bind host and service projects. This project runs on a personal GCP account with no Organization, so Shared VPC isn't available.

VPC Peering achieves the same architectural intent — centralized shared services, isolated workload environments — without requiring org-level administration. It's also the pattern most startups and SMBs use in practice, since many don't operate under a GCP Organization either. The tradeoff documented here: Peering is non-transitive and each connection must be explicitly created and managed per VPC pair, whereas Shared VPC centralizes that in one host project.

What's Deployed

ComponentHubDev SpokeProd SpokeVPC✅✅✅Subnet (custom, regional)✅✅✅Secondary ranges (pods/services)—✅✅Cloud Router + Cloud NAT✅——Deny-all-ingress baseline rule✅✅✅Allow-internal rule✅✅✅Allow-from-hub rule—✅✅IAP SSH firewall rule—✅✅VPC Peering (bi-directional)—✅✅

Repository Structure

gcp-hub-spoke-vpc/
├── modules/
│   ├── hub_vpc/          # Hub VPC, subnet, Cloud Router, Cloud NAT, baseline firewall
│   ├── spoke_vpc/        # Reusable spoke VPC module (used by both dev and prod)
│   └── vpc_peering/      # Bi-directional peering module (hub <-> spoke)
├── environments/
│   ├── hub/              # Hub deployment (gcpai-iac-dev)
│   ├── dev/              # Dev spoke deployment (gcpai-iac-dev)
│   └── prod/             # Prod spoke deployment (gcpai-iac-prod)
└── .github/workflows/
    ├── terraform-plan.yml   # Runs on PR — plans all 3 environments, posts plan as PR comment
    └── terraform-apply.yml  # Runs on push to main — applies all 3 environments

CI/CD


Authentication: Workload Identity Federation — GitHub Actions exchanges its OIDC token for short-lived GCP credentials. No JSON service account keys stored anywhere.
Plan on PR: Every pull request triggers a terraform plan across hub, dev, and prod, posted as a PR comment for review before merge.
Apply on merge: Merging to main triggers terraform apply across all three environments automatically.
Remote state: Each environment keeps isolated state in a shared GCS bucket (gcpai-iac-tfstate), under separate prefixes (hub/networking, dev/networking, prod/networking).


Connectivity Verification

Tested using temporary Compute Engine VMs (no external IP, accessed via IAP tunnel) in the dev and prod subnets:


dev → prod direct ping: blocked (confirms peering is non-transitive — correct, intended isolation)
Both spokes successfully peer with the hub independently


Test VMs were destroyed immediately after verification to avoid ongoing cost.

Cost

All networking resources (VPCs, subnets, firewall rules, peering) are free. The only billable component is Cloud NAT on the hub, which runs at minimal cost for a portfolio-scale workload.

Tech Stack

Terraform · Google Cloud Platform (VPC, Cloud Router, Cloud NAT, VPC Peering, IAM, Compute Engine) · GitHub Actions · Workload Identity Federation