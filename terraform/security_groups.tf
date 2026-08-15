# Single security group shared by all cluster nodes.
# Kubernetes needs many ports open BETWEEN nodes (API server, etcd, kubelet,
# CNI overlay, etc.) — rather than hand-picking every one (error-prone and
# a common source of "why won't my cluster join" pain for first-timers),
# we allow all traffic between members of this same group, and only expose
# the handful of ports we actually need to the outside world (you).

resource "aws_security_group" "cluster" {
  name        = "${var.project_name}-cluster-sg"
  description = "Security group for kubeadm cluster nodes"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-cluster-sg"
  }
}

# Allow ALL traffic between nodes that share this security group
# (control-plane <-> workers: etcd, kubelet, CNI, etc.)
resource "aws_security_group_rule" "internal_all" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.cluster.id
  description               = "Allow all traffic between cluster nodes"
}

# SSH — locked to your IP only, never 0.0.0.0/0
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.cluster.id
  description        = "SSH from your IP only"
}

# Kubernetes API server — so kubectl on your laptop/WSL can reach the cluster
resource "aws_security_group_rule" "k8s_api" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.cluster.id
  description        = "Kubernetes API server, from your IP only"
}

# NodePort range — lets you reach demo apps exposed via NodePort service, for testing
resource "aws_security_group_rule" "nodeport" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]
  security_group_id = aws_security_group.cluster.id
  description        = "NodePort range for testing exposed apps, from your IP only"
}

# All outbound traffic allowed (needed for package installs, pulling images, etc.)
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
  description        = "Allow all outbound traffic"
}
