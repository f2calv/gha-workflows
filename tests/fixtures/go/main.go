// Command fixture prints its build version; CI uses it to exercise app-build-go.yml.
package main

import "fmt"

var version = "dev"

func describe(v string) string {
	if v == "" {
		return "unversioned"
	}
	return "v" + v
}

func main() {
	fmt.Println(describe(version))
}
