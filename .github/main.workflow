workflow "Test Help Commands" {
  on = "push"
  resolves = ["Test Helpers"]
}

action "Filters for Master branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Test Helpers" {
  uses = "./actions/help"
}
