# Roles & Permissions

Each QUANTI: project has three distinct roles: `owner`, `admin`, and `user`. Roles control what each member can see and do within a project.

***

## Permission matrix

| Action | owner | admin | user |
|---|:---:|:---:|:---:|
| View the project | ✅ | ✅ | ✅ |
| View project members | ✅ | ✅ | ✅ |
| View own permissions | ✅ | ✅ | ✅ |
| Access the data warehouse (schema, datasets, tables) | ✅ | ✅ | ✅ |
| Use the AI assistant (query) | ✅ | ✅ | ✅ |
| Edit the project AI context | ✅ | ✅ | ✅ |
| Invite a member | ✅ | ✅ | ❌ |
| Change a member's role | ✅ | ✅ | ❌ |
| Remove a member | ✅ | ✅ | ❌ |
| Edit project settings | ✅ | ❌ | ❌ |
| Edit BigQuery configuration | ✅ | ❌ | ❌ |
| Edit DWH budget | ✅ | ❌ | ❌ |
| Delete the project | ✅ | ❌ | ❌ |

***

## Role descriptions

**`owner`**

The owner has full control over the project, including configuration, billing settings, and member management. There must always be at least one owner on a project — the last owner cannot be demoted or removed. Only an owner can promote another member to the `owner` role; admins can only invite members as `admin` or `user`.

**`admin`**

Admins can manage the team (invite, change roles, remove members) but cannot modify project-level settings or delete the project. This role is suited for team leads who need to onboard colleagues without full platform access.

**`user`**

Users have read-only access to the project and its data. They can query the data warehouse and use the AI assistant, but cannot manage members or change any settings. This role is suited for analysts and stakeholders who consume data without administering the project.

***

## Invitation lifecycle

When a member is invited to a project, the invitation goes through the following states:

```
pending → success (accepted)
       → refused (declined)
```

The invited person receives a transactional email at the time of the invitation. Once accepted:

- If the project uses a **Managed BigQuery**, the new member is automatically added to the GCP IAM policy with the `roles/bigquery.admin` role.
- When a member is removed, their GCP IAM access is **revoked before the deletion** is recorded. If the GCP revocation fails, the deletion does not proceed.

***

## Plan limits

The number of members per project depends on the plan associated with the project's Billing Account. This limit is checked at every invitation. Contact your QUANTI: account manager to adjust your plan if needed.
