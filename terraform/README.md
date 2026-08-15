# Stage 1: Cluster Infrastructure

This Terraform config provisions:
- 1 VPC with a public subnet, internet gateway, and route table
- 1 security group (SSH, Kubernetes API, and NodePort range restricted to your IP only; full traffic allowed between cluster nodes)
- 3 EC2 instances (1 control-plane + 2 workers), each bootstrapped with containerd, kubeadm, kubelet, and kubectl via `scripts/node-prep.sh`
- A CloudWatch billing alarm (emails you if estimated charges exceed $25/month, configurable)

Note: `node-prep.sh` installs everything kubeadm needs, but does **not** run
`kubeadm init` or `kubeadm join` — you'll run those by hand over SSH once the
instances are up. That's intentional: that step is where you actually learn
how a cluster forms.

## Setup

1. Generate an SSH key if you haven't already:
   ```bash
   mkdir -p ~/.ssh/k8s-lab
   ssh-keygen -t ed25519 -f ~/.ssh/k8s-lab/k8s-lab-key -C "k8s-lab" -N ""
   ```

2. Find your public IP:
   ```bash
   curl -s https://checkip.amazonaws.com
   ```

3. Copy the tfvars template and fill it in:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # edit terraform.tfvars: set my_ip and alert_email
   ```

4. Initialize and apply:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

5. Check your email for the SNS subscription confirmation and click it —
   otherwise you won't actually get billing alerts.

6. Wait ~1-2 minutes after apply for `node-prep.sh` to finish running on
   each instance (it's installing packages). You can check progress via:
   ```bash
   ssh -i ~/.ssh/k8s-lab/k8s-lab-key ubuntu@<ip> "cat /var/log/node-prep-done.log"
   ```
   If that file doesn't exist yet, prep is still running — wait a bit longer.

## Cost control

**Destroy the cluster whenever you're not actively working on it:**
```bash
terraform destroy
```
Re-running `terraform apply` later recreates everything from scratch in a
couple of minutes (state like manually-run kubeadm setup will NOT persist —
see Stage 2 notes on saving your kubeadm join commands somewhere safe).

## Outputs

After `apply`, run `terraform output` to get SSH commands and IPs for all
three nodes.
