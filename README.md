# vAuditRBAC – Role-Based Access Control Validator for vCenter Server

## 🎯 Project Objective
Enable secure and consistent RBAC enforcement across VMware vCenter environments by comparing current roles and permissions to a centrally defined policy hosted in GitHub or Confluence.

## 🧱 How It Works (MVP v1.0)
1. Connects to vCenter to extract custom roles, privileges, and group assignments.
2. Retrieves YAML-based role definitions from a source-of-truth web repository.
3. Compares live data to policy:
   - Flags missing or extra privileges
   - Verifies assignments are made to the correct groups on the right object levels
   - Checks propagation flags
4. Generates a report (HTML/CSV/Markdown) for compliance and remediation.

## 💡 Key Features
- Detect role drift or misconfiguration
- Support for custom and built-in roles
- GitOps-style policy version control
- Optional integration with ChatOps (Slack, Teams, vCenter Chat Assistant)

## 🔧 Tech Stack
- PowerCLI
- YAML or JSON policy schema
- Confluence API or GitHub raw YAML fetch

## 🚀 Use Cases
- Validate production vCenter servers RBAC configurations
- Ensure compliance with internal security policies
- Automate security reviews and audits

## 🙌 Team Members
- Pawel Piotrowski
- Lukasz Piotrowski
- TBD
- TBD
- TBD

