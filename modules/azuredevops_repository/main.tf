resource "azuredevops_git_repository" "this" {
  project_id     = var.project_id
  name           = var.name
  default_branch = "refs/heads/main"

  initialization {
    init_type = "Clean"
  }

  lifecycle {
    ignore_changes = [initialization]
  }
}

# Converts the user-facing branch_policies list into a map keyed by ref so each
# policy resource can use for_each.  The ref is normalised to a full Git ref
# (e.g. "main" → "refs/heads/main") so it can be passed directly to the ADO API.
locals {
  branch_policies = {
    for bp in var.branch_policies :
    bp.ref => bp
  }

  # Normalise a plain branch name into a full Git ref; leave it alone if it
  # already starts with "refs/".
  _normalised_refs = {
    for k, bp in local.branch_policies :
    k => startswith(bp.ref, "refs/") ? bp.ref : "refs/heads/${bp.ref}"
  }
}

# ---------------------------------------------------------------------------
# Minimum reviewers policy
# Maps from: required_pull_request_reviews.required_approving_review_count
#            required_pull_request_reviews.dismiss_stale_reviews   (→ on_push_reset_approved_votes)
#            required_pull_request_reviews.require_last_push_approval (→ last_pusher_cannot_approve)
# ---------------------------------------------------------------------------
resource "azuredevops_branch_policy_min_reviewers" "this" {
  for_each   = { for k, bp in local.branch_policies : k => bp if bp.required_pull_request_reviews != null }
  project_id = var.project_id

  enabled  = each.value.enabled
  blocking = each.value.blocking

  settings {
    reviewer_count                         = each.value.required_pull_request_reviews.required_approving_review_count
    submitter_can_vote                     = false
    last_pusher_cannot_approve             = each.value.required_pull_request_reviews.require_last_push_approval
    allow_completion_with_rejects_or_waits = false
    on_push_reset_approved_votes           = each.value.required_pull_request_reviews.dismiss_stale_reviews
    on_push_reset_all_votes                = false

    scope {
      repository_id  = azuredevops_git_repository.this.id
      repository_ref = local._normalised_refs[each.key]
      match_type     = "Exact"
    }
  }
}

# ---------------------------------------------------------------------------
# Comment resolution policy
# Maps from: require_conversation_resolution
# ---------------------------------------------------------------------------
resource "azuredevops_branch_policy_comment_resolution" "this" {
  for_each   = { for k, bp in local.branch_policies : k => bp if bp.require_conversation_resolution }
  project_id = var.project_id

  enabled  = each.value.enabled
  blocking = each.value.blocking

  settings {
    scope {
      repository_id  = azuredevops_git_repository.this.id
      repository_ref = local._normalised_refs[each.key]
      match_type     = "Exact"
    }
  }
}

# ---------------------------------------------------------------------------
# Merge types policy
# Maps from: allow_squash_merge, allow_rebase_merge, allow_merge_commit,
#            required_linear_history (no fast-forward disabled when true)
# ---------------------------------------------------------------------------
resource "azuredevops_branch_policy_merge_types" "this" {
  for_each   = { for k, bp in local.branch_policies : k => bp if bp.merge_types != null }
  project_id = var.project_id

  enabled  = each.value.enabled
  blocking = each.value.blocking

  settings {
    allow_squash                  = each.value.merge_types.allow_squash
    allow_rebase_and_fast_forward = each.value.merge_types.allow_rebase_and_fast_forward
    # no-fast-forward (basic merge commit) is the only strategy allowed when
    # required_linear_history is true; expose it directly as well.
    allow_basic_no_fast_forward = each.value.merge_types.allow_basic_no_fast_forward
    allow_rebase_with_merge     = each.value.merge_types.allow_rebase_with_merge

    scope {
      repository_id  = azuredevops_git_repository.this.id
      repository_ref = local._normalised_refs[each.key]
      match_type     = "Exact"
    }
  }
}
