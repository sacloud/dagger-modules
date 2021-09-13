# a dagger module for SAKURA Cloud

## Examples

```cue
package example

import (
  "alpha.dagger.io/dagger"
  "alpha.dagger.io/os"
  
  "github.com/sacloud/dagger-modules/sacloud"
)

account: #AuthStatus

#AuthStatus: {
	config: sacloud.#Config

	// Container image
	_status: os.#Container & {
		image: sacloud.#CLI & {
			"config": config
			package: jq: true
		}
		always: true

		command: """
			usacloud auth-status -o json | jq .[] > /auth-status
			"""
	}

	// account information
	status: dagger.#Output & {
		#up: [
			op.#Load & {from: _status},
			op.#Export & {
				source: "/auth-status"
				format: "json"
			},
		]
	}
}
```