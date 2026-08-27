output "talosconfig" {
  description = "Talos configuration file for the cluster"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes kubeconfig for the cluster"
  value = {
    client_key  = talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key
    client_cert = talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate
    ca_cert     = talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate
    host        = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    kubeconfig  = talos_cluster_kubeconfig.this.kubeconfig_raw
  }
  sensitive = true
}

output "talos_health" {
  description = "Health status of the Kubernetes API server, can be used for other resources to depend on"
  value       = data.http.talos_health.response_body
}

output "talos_image_schematic_id" {
  description = "ID of the Talos image schematic"
  value       = talos_image_factory_schematic.this.id
}

output "ha_vip_enabled" {
  description = "Whether HA VIP is enabled for the cluster"
  value       = local.ha_vip_enabled
}

output "ha_vip" {
  description = "HA VIP address for the cluster (when HA is enabled)"
  value       = local.ha_vip
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint for the cluster"
  value       = local.cluster_endpoint
}

output "node_ips" {
  description = "Map of node alias (e.g. \"controlplane-1\", \"worker-5\") to its IP address, for consumers that need the concrete node list (e.g. firewall/pg_hba rules) rather than a CIDR range."
  value = merge(
    { for k, v in local.controlplanes : k => v.ip_address },
    { for k, v in local.workers : k => v.ip_address }
  )
}