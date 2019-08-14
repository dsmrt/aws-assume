# AWS ASSUME

Shell scripts to automate common actions when managing multiple AWS accounts thru Switch roles/role based authentication.

## Sub Commands

### `open`
Open the AWS Console to Switch Roles of the profile specified.

### `cp-public-key`
Copy CodeCommit public key from one account to the other. This command will create a user if needed, assign the 
AWSCodeCommitPowerUser managed role, and upload the public key from one account (specified profile) to an other (specified profile).

### `upload-public-key`
Upload CodeCommit public key from your local machine. This command will create a user if needed.

#### Background
CodeCommit can be difficult to manage user permission thru git when work on role based authentication. HTTPs authentication 
doesn't work well (from my experience) and it's much easier to create a user for git authentication and assign a ssh key 
to the user.

### `get-ssh-config`
Get the current ssh key for the specified user and return the ssh configuation as needed for the `~/.ssh/config`. This 
also outputs an example clone command.

### `temp-creds`
Output temporary credentials from a specific profile into a text file like a .env. This will work with an existing file and 
will overwrite the items it creates (if run more than one time).

#### Variables Overwritten
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_SESSION_TOKEN`
* `EXPIRATION`
