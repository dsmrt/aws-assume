workflow "Test Help Commands" {
  on = "push"
  resolves = ["Test Helpers"]
}

action "Test Helpers" {
  uses = "./actions/help"
}
