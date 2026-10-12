# Solution Overview: Hardened Fedora Golden Image

## Fedora Lane's Challenges
Fedora Lane required a highly secure, repeatable, and compliant operating system baseline for their cloud workloads. The primary challenges were ensuring strict Mandatory Access Control (MAC) without regressions, locking down management interfaces, and maintaining code hygiene across the deployment repository.

## High-Level Architecture
1. **Source Image:** CIS-Hardened Fedora Linux.
2. **Target Environment:** AWS EC2.
3. **Security Boundary:** Pre-configured with SELinux in `Enforcing` mode, restricted to key-only authentication on a non-standard SSH port (`2222`).
4. **Version Control & Quality:** Local Git repository integrated with `pre-commit` hooks to prevent malformed configurations or excessively large files from entering the source of truth.

## Why This Was Built
This solution provides Fedora Lane with a verifiable, zero-regression golden image. By enforcing pre-commit checks locally, we guarantee that the infrastructure-as-code remains pristine. By validating SELinux at runtime, we prove the system's security posture survives the cloud provisioning process.
