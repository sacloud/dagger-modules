// SAKURA cloud base package
package sacloud

import (
	"alpha.dagger.io/dagger"
)

zone: string
zone: "is1a" | "is1b" | "tk1a" | "tk1b" | "tk1v"

// Config shared by all Sacloud packages
#Config: {
	zone: dagger.#Input & {zone}
	token: dagger.#Input & dagger.#Secret
	secret: dagger.#Input & dagger.#Secret
}