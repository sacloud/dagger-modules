// SAKURA cloud base package
package sacloud

import (
	"alpha.dagger.io/dagger/op"
	"alpha.dagger.io/os"
)

// Default image and version
let defaultVersion = "latest"

// Re-usable cli(usacloud) component
#CLI: {
	config: #Config

	version: string | *defaultVersion

	// List of packages to install
	package: [string]: true | false | string

	// Container image
	os.#Container & {
		image: {
			from: "ghcr.io/sacloud/usacloud:\(version)"
			#up: [
				op.#FetchContainer & {ref: from},
    		for pkg, info in package {
    			if (info & true) != _|_ {
    				op.#Exec & {
    					args: ["apk", "add", "-U", "--no-cache", pkg]
    				}
    			}
    			if (info & string) != _|_ {
    				op.#Exec & {
    					args: ["apk", "add", "-U", "--no-cache", "\(pkg)\(info)"]
    				}
    			}
    		},
			]
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