output "control_plane_public_ip" {
  value = aws_instance.control_plane.public_ip
}

output "worker_public_ips" {
  value = aws_instance.worker[*].public_ip
}

output "ssh_control_plane" {
  value = "ssh -i ~/.ssh/k8s-lab/k8s-lab-key ubuntu@${aws_instance.control_plane.public_ip}"
}

output "ssh_workers" {
  value = [for ip in aws_instance.worker[*].public_ip : "ssh -i ~/.ssh/k8s-lab/k8s-lab-key ubuntu@${ip}"]
}
