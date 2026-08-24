output "id" {
  description = "The ID of the Azure DevOps Git repository."
  value       = azuredevops_git_repository.this.id
}

output "full_name" {
  description = "VCS identifier for HCP Terraform in the form \"<ado_org>/<ado_project>/_git/<repo_name>\" as required by tfe_registry_module."
  value       = "${var.ado_org_name}/${var.project_name}/_git/${azuredevops_git_repository.this.name}"
}

output "branch_policies" {
  description = "Map of all branch policy resource objects managed by this module, keyed by branch ref."
  value = {
    min_reviewers      = { for k, v in azuredevops_branch_policy_min_reviewers.this : k => v }
    comment_resolution = { for k, v in azuredevops_branch_policy_comment_resolution.this : k => v }
    merge_types        = { for k, v in azuredevops_branch_policy_merge_types.this : k => v }
  }
}

output "remote_url" {
  description = "Git HTTPS URL of the repository."
  value       = azuredevops_git_repository.this.remote_url
}

output "ssh_url" {
  description = "Git SSH URL of the repository."
  value       = azuredevops_git_repository.this.ssh_url
}

output "web_url" {
  description = "Web link to the repository."
  value       = azuredevops_git_repository.this.web_url
}
