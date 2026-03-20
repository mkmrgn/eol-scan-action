# HeroDevs EOL Scan Action

A GitHub Action that scans your project for end-of-life (EOL) dependencies using the [HeroDevs EOL Data Set](https://www.herodevs.com/eol-dataset).

## Prerequisites

- A HeroDevs authentication token stored as a GitHub Actions secret (see [Authentication](#authentication))

## Authentication

Store your HeroDevs token as a repository or organization secret:

1. Go to **Settings → Secrets and variables → Actions → Secrets**
2. Click **New repository secret**
3. Name it `HD_CI_CREDENTIAL` and paste your token as the value

## Usage

### Basic Usage (Docker, default)

```yaml
jobs:
  eol-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5

      - name: Run EOL Scan
        id: eol
        uses: mkmrgn/eol-scan-action@v1
        with:
          auth-token: ${{ secrets.HD_CI_CREDENTIAL }}

      - name: Upload Report
        uses: actions/upload-artifact@v5
        with:
          name: eol-report
          path: ${{ steps.eol.outputs.report-path }}
```

### Client Method (no Docker required)

Use this method if your runner does not have Docker available, or if you prefer a lighter-weight approach that installs the HeroDevs CLI directly onto the runner.

```yaml
jobs:
  eol-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5

      - name: Run EOL Scan
        id: eol
        uses: mkmrgn/eol-scan-action@v1
        with:
          auth-token: ${{ secrets.HD_CI_CREDENTIAL }}
          method: client

      - name: Upload Report
        uses: actions/upload-artifact@v5
        with:
          name: eol-report
          path: ${{ steps.eol.outputs.report-path }}
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `auth-token` | HeroDevs authentication token | ✅ Yes | — |
| `method` | Execution method: `docker` or `client` | No | `docker` |
| `output-path` | Filename for the generated report | No | `herodevs.report.json` |

## Outputs

| Output | Description |
|--------|-------------|
| `report-path` | Absolute path to the generated EOL report on the runner |

Use `${{ steps.<step-id>.outputs.report-path }}` in subsequent steps to reference the report, for example when uploading it as an artifact.

## Execution Methods

### `docker` (default)

Pulls and runs the HeroDevs EOL Scanner as a Docker container. Requires Docker to be available on the runner (all GitHub-hosted `ubuntu-latest` runners include Docker).

**Best for:**
- Most use cases
- Isolated, reproducible scan environments
- Runners where you don't want to install additional software

### `client`

Installs the HeroDevs CLI (`@herodevs/cli`) directly onto the runner via npm and runs the scan natively.

**Best for:**
- Runners without Docker
- Environments where installing CLI tools is preferred over running containers
- Faster execution when Docker pull times are a concern

## Example: Full Workflow with Triggers

```yaml
name: HeroDevs EOL Scan

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  eol-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5

      - name: Run EOL Scan
        id: eol
        uses: mkmrgn/eol-scan-action@v1
        with:
          auth-token: ${{ secrets.HD_CI_CREDENTIAL }}
          method: docker
          output-path: herodevs.report.json

      - name: Upload Report
        uses: actions/upload-artifact@v5
        with:
          name: eol-report
          path: ${{ steps.eol.outputs.report-path }}
```

## Report

After a successful scan, a JSON report is saved to the path specified by `output-path` (default: `herodevs.report.json`) in the repository workspace. The report includes:

- Total packages scanned
- End-of-Life (EOL) packages
- Upcoming EOL packages
- Packages with HeroDevs NES remediation available

A link to the full report is also printed to the workflow log.

## License

See [LICENSE](LICENSE) for details.
