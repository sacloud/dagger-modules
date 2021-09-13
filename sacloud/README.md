# a dagger module for SAKURA Cloud

## Examples

```cue
package test

import (
  "alpha.dagger.io/dagger"
  "alpha.dagger.io/os"
  
  "github.com/sacloud/dagger-modules/sacloud"
)

account: #AuthStatus

#AuthStatus: {
	config: sacloud.#Config

	account: string & dagger.#Output

	// Container image
	ctr: os.#Container & {
		image: sacloud.#CLI & {
			"config": config
		}
		always: true

		command: """
			usacloud auth-status -o json > /account
			"""
	}

	// account information
	account: ({
		os.#File & {
			from: ctr
			path: "/account"
		}
	}).contents
}
```