run "fixture_output" {
  command = plan

  assert {
    condition     = output.fixture == "ok"
    error_message = "The fixture output must be ok."
  }
}
