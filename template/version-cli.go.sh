#!/bin/bash

cat <<EOF > "${GIT_ROOT}/internal/cli/version.go"
package cli

import (
	"fmt"

	"${GO_MODULE}/internal/version"
	"github.com/spf13/cobra"
)

func newVersionCommand() *cobra.Command {
	return &cobra.Command{
		Use:   "version",
		Short: "Build information for ${CMD_NAME}",
		RunE: func(command *cobra.Command, args []string) error {
			fmt.Printf("%#v\n", version.Get())
			return nil
		},
	}
}
EOF
