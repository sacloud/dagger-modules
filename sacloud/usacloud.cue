// SAKURA cloud base package
package sacloud

import (
	"alpha.dagger.io/docker"
	"alpha.dagger.io/os"
)

// Default image and version
let defaultVersion = "latest"

// Re-usable cli(usacloud) component
#CLI: {
	config: #Config

	version: string | *defaultVersion

	// Container image
	os.#Container & {
		image: docker.#Pull & {
			from: "ghcr.io/sacloud/usacloud:\(version)"
		}

		always: true

		command: """
			usacloud config edit --token "$(cat /run/secrets/token)" --secret "$(cat /run/secrets/secret)" --zone "\(config.zone)" --default-output-type table > /dev/null 2>&1
			"""

		secret: {
		  "/run/secrets/token":  config.token
		  "/run/secrets/secret": config.secret
		}
	}
}