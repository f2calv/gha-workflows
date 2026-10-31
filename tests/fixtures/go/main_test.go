package main

import "testing"

func TestDescribe(t *testing.T) {
	cases := map[string]string{"1.2.3": "v1.2.3", "": "unversioned"}
	for in, want := range cases {
		if got := describe(in); got != want {
			t.Errorf("describe(%q) = %q, want %q", in, got, want)
		}
	}
}
