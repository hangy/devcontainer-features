# Development Container Features

'Features' are self-contained units of installation code and development container configuration. Features are designed
to install atop a wide-range of base container images (**this repo focuses on `debian` based images**).

This repo contains features used by hangy in his projects. You may find these useful as well.

Issues and PR's are welcome, but no guarantees are made.

You may learn about Features at [containers.dev](https://containers.dev/implementors/features/), which is the website for the dev container specification.

## Known Issues

  * `liquibase`
	* N/A

## Usage

The Liquibase CLI is used to work with liquibase projects.

For example, if you develop Python-based Azure Functions that use SQL Server, your `.devcontainer.json` should look like:

```jsonc
{
	"name": "Java & PostgreSQL",
	"dockerComposeFile": "docker-compose.yml",
	"service": "app",
	"workspaceFolder": "/workspaces/${localWorkspaceFolderBasename}",
	"features": {
		"ghcr.io/hangy/devcontainer-features/liquibase:1": {
			"version": "17"
		}
	}
}
```
