# Notify me

A collection of Perl scripts to notify you via Mailgun, Microsoft Teams, Pushover, Discord, sipgate SMS, GitHub and GitLab issues.

Also available as [Docker image](https://hub.docker.com/r/cyclenerd/notify-me).

Docker Hub registry:
```shell
docker pull cyclenerd/notify-me:latest
docker run cyclenerd/notify-me:latest pushover.pl --help
```

[![Latest Docker images](https://github.com/Cyclenerd/notify-me/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/Cyclenerd/notify-me/actions/workflows/docker-latest.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/cyclenerd/notify-me)](https://hub.docker.com/r/cyclenerd/notify-me)
[![GitHub](https://img.shields.io/github/license/cyclenerd/notify-me)](https://github.com/Cyclenerd/notify-me/blob/master/LICENSE)

## Services supported

* 📧 [Mailgun](https://github.com/Cyclenerd/notify-me#mailgun--mailgunpl)
* 👪 [Microsoft Teams](https://github.com/Cyclenerd/notify-me#microsoft-teams--ms-teamspl)
* 🔔 [Pushover](https://github.com/Cyclenerd/notify-me#pushover--pushoverpl)
* 👾 [Discord](https://github.com/Cyclenerd/notify-me#discord--discordpl)
* ☎️ [sipgate SMS](https://github.com/Cyclenerd/notify-me#sipgate-sms--sipgatepl)
* 😽 [GitHub Issue](https://github.com/Cyclenerd/notify-me#github-issue--github-issuepl)
* 🦊 [GitLab Issue](https://github.com/Cyclenerd/notify-me#gitlab-issue--gitlab-issuepl)

## Tested

* [![Ubuntu](https://github.com/Cyclenerd/notify-me/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/Cyclenerd/notify-me/actions/workflows/ubuntu.yml)
* [![macOS](https://github.com/Cyclenerd/notify-me/actions/workflows/macos.yml/badge.svg)](https://github.com/Cyclenerd/notify-me/actions/workflows/macos.yml)
* [![Latest Docker image](https://github.com/Cyclenerd/notify-me/actions/workflows/docker-latest.yml/badge.svg)](https://github.com/Cyclenerd/notify-me/actions/workflows/docker-latest.yml)

## Requirement

* Perl 5 (`perl`)
* Perl modules:
	* [App::Options](https://metacpan.org/pod/App::Options)
	* [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent)
	* [JSON::XS](https://metacpan.org/pod/JSON::XS)

Debian/Ubuntu:
```shell
sudo apt update
sudo apt install \
	libapp-options-perl \
	libwww-perl \
	libjson-xs-perl
```

Or install modules with cpanminus:
```shell
cpan App::cpanminus
cpanm --installdeps .
```

## Mailgun ( `mailgun.pl`)

Send plain text message via Mailgun API:
<https://documentation.mailgun.com/en/latest/api-sending.html#sending>

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/mailgun.pl
```

Run:
```shell
perl mailgun.pl \
	--key="YOUR_API_KEY" \
	--domain="YOUR_DOMAIN_NAME" \
	--from="SENDER_OF_THE_MESSAGE" \
	--to="RECIPIENT_OF_THE_MESSAGE" \
	--title="YOUR_SUBJECT" \
	--msg="YOUR_MESSAGE"
```

You can also create a `mailgun.conf` configuration file in the same directory as the `mailgun.pl` program with default values:

```text
key = YOUR_API_KEY
domain = YOUR_DOMAIN_NAME
from = SENDER_OF_THE_MESSAGE
to = RECIPIENT_OF_THE_MESSAGE
title = YOUR_SUBJECT
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## Microsoft Teams ( `ms-teams.pl`)

Create an webhook URL for your Microsoft Teams Group:
<https://docs.microsoft.com/en-us/outlook/actionable-messages/send-via-connectors>

The webhook URL should look similar to the following:

```text
https://outlook.office365.com/webhook/ ↩
a1269812-6d10-44b1-abc5-b84f93580ba0@ ↩
9e7b80c7-d1eb-4b52-8582-76f921e416d9/ ↩
IncomingWebhook/3fdd6767bae44ac58e5995547d66a4e4/ ↩ 
f332c8d9-3397-4ac5-957b-b8e3fc465a8c
```

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/ms-teams.pl
```

Run:
```shell
perl ms-teams.pl \
	--url="YOUR_WEBHOOK_URL" \
	--title="YOUR_OPTIONAL_TITLE" \
	--msg="YOUR_MESSAGE"
```

You can also create a `ms-teams.conf` configuration file in the same directory as the `ms-teams.pl` program with default values:

```text
url = YOUR_WEBHOOK_URL
title = YOUR_OPTIONAL_TITLE
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## Pushover ( `pushover.pl`)

Send message via Pushover API:
<https://pushover.net/api>

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/pushover.pl
```

Run:
```shell
perl pushover.pl \
	--user="USER" \
	--token="TOKEN" \
	--msg="MESSAGE"
```

You can also create a `pushover.conf` configuration file in the same directory as the `pushover.pl` program with default values:

```text
user = USER
token = TOKEN
msg = MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## Discord ( `discord.pl`)

Discord webhook API:
<https://discord.com/developers/docs/resources/webhook#execute-webhook>

Create an webhook URL for your Discord channel:
<https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks>

The webhook URL should look similar to the following:
```text
https://discord.com/api/webhooks/<webhook-id>/<webhook-token>
```

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/discord.pl
```

Run:
```shell
perl discord.pl \
	--url="YOUR_WEBHOOK_URL" \
	--msg="MESSAGE"
```

You can also create a `discord.conf` configuration file in the same directory as the `discord.pl` program with default values:

```text
url = YOUR_WEBHOOK_URL
msg = MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## sipgate SMS ( `sipgate.pl`)

Send an SMS via the sipgate REST API:
<https://www.sipgate.io/rest-api>

1. Order the free feature "SMS senden": <https://app.sipgatebasic.de/feature-store/sms-senden>
1. Get token id and token with 'sessions:sms:write' scope: <https://app.sipgate.com/personal-access-token>

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/sipgate-sms.pl
```

```shell
perl sipgate-sms.pl \
	--id="YOUR_SIPGATE_TOKEN_ID" \
	--token="YOUR_SIPGATE_TOKEN" \
	--sms="YOUR_SIPGATE_SMS_EXTENSION_DEFAULT_S0" \
	--tel="RECIPIENT_PHONE_NUMBER" \
	--msg="YOUR_MESSAGE"
```

You can also create a `sipgate-sms.conf` configuration file in the same directory as the `sipgate-sms.pl` program with default values:

```text
id = YOUR_SIPGATE_TOKEN_ID
token = YOUR_SIPGATE_TOKEN
sms = YOUR_SIPGATE_SMS_EXTENSION_DEFAULT_S0
tel = RECIPIENT_PHONE_NUMBER
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.

The token should have the `sessions:sms:write` scope.
For more information about personal access tokens visit <https://www.sipgate.io/rest-api/authentication#personalAccessToken>.

The `smsId` uniquely identifies the extension from which you wish to send your message.
Further explanation is given in the section Web SMS Extensions <https://github.com/sipgate-io/sipgateio-sendsms-php#web-sms-extensions>.


## GitHub Issue ( `github-issue.pl`)

Create an GitHub issue via the GitHub REST API.
Any user with pull access to a repository can create an issue.

1. [Generate a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
1. Select scope:
	* `public_repo` : To create issues in public repositories
	* `repo` (Full control of private repositories ) : To create issues in private repositories

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/github-issue.pl
```

```shell
perl github-issue.pl \
	--ower="GITHUB_REPO_OWNER" \
	--repo="GITHUB_REPO" \
	--username="YOUR_GITHUB_USERNAME" \
	--token="YOUR_GITHUB_TOKEN" \
	--title="YOUR_TITLE" \
	--msg="YOUR_MESSAGE"
```

You can also create a `github-issue.conf` configuration file in the same directory as the `github-issue.pl` program with default values:

```text
ower = GITHUB_REPO_OWNER
repo = GITHUB_REPO
username = YOUR_GITHUB_USERNAME
token = YOUR_GITHUB_TOKEN
title = YOUR_TITLE
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.

### GitHub Issue Comment ( `github-issue-comment.pl`)

Create an GitHub issue comment via the GitHub REST API.

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/github-issue-comment.pl
```

```shell
perl github-issue.pl \
	--ower="GITHUB_REPO_OWNER" \
	--repo="GITHUB_REPO" \
	--issue="GITHUB_ISSUE_NUMBER" \
	--username="YOUR_GITHUB_USERNAME" \
	--token="YOUR_GITHUB_TOKEN" \
	--msg="YOUR_MESSAGE"
```

You can also create a `github-issue-comment.conf` configuration file in the same directory as the `github-issue-comment.pl` program with default values:

```text
ower = GITHUB_REPO_OWNER
repo = GITHUB_REPO
issue = GITHUB_ISSUE_NUMBER
username = YOUR_GITHUB_USERNAME
token = YOUR_GITHUB_TOKEN
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## GitLab Issue ( `gitlab-issue.pl`)

Create an GitLab issue via the GitLab REST API v4.

1. [Generate a personal access token](https://gitlab.com/-/profile/personal_access_tokens?name=notify-me&scopes=api) ([Help](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token))
1. Select scope: `api`

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/gitlab-issue.pl
```

```shell
perl gitlab-issue.pl \
	--server="OPTIONAL_YOUR_OWN_GITLAB_SERVER" \
	--project="GITLAB_PROJECT_ID" \
	--token="YOUR_GITLAB_TOKEN" \
	--title="YOUR_TITLE" \
	--msg="YOUR_MESSAGE"
```

You can also create a `gitlab-issue.conf` configuration file in the same directory as the `gitlab-issue.pl` program with default values:

```text
server = OPTIONAL_YOUR_OWN_GITLAB_SERVER
project = GITLAB_PROJECT_ID
token = YOUR_GITLAB_TOKEN
title = YOUR_TITLE
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.

## GitLab Issue Comment ( `gitlab-issue-comment.pl`)

Create an GitLab issue comment via the GitLab REST API v4.

Download script:
```
curl -O https://raw.githubusercontent.com/Cyclenerd/notify-me/master/gitlab-issue-comment.pl
```

```shell
perl gitlab-issue-comment.pl \
	--server="OPTIONAL_YOUR_OWN_GITLAB_SERVER" \
	--project="GITLAB_PROJECT_ID" \
	--issue="GITLAB_ISSUE_NUMBER" \
	--token="YOUR_GITLAB_TOKEN" \
	--msg="YOUR_MESSAGE"
```

You can also create a `gitlab-issue-comment.conf` configuration file in the same directory as the `gitlab-issue-comment.pl` program with default values:

```text
server = OPTIONAL_YOUR_OWN_GITLAB_SERVER
project = GITLAB_PROJECT_ID
issue = GITLAB_ISSUE_NUMBER
token = YOUR_GITLAB_TOKEN
msg = YOUR_MESSAGE
```

More about this also in the [Configuration](#Configuration) section.


## Configuration

The Perl module [App::Options](https://metacpan.org/pod/App::Options) is used.
App::Options combines command-line arguments, environment variables, option files and program defaults.

### Option Files

A cascading set of option files are all consulted to allow individual users to specify values that override the normal values for certain programs.

Furthermore, the values for individual programs can override the values configured generally system-wide.

The resulting value for an option variable comes from the first place that it is ever seen.
Subsequent mentions of the option variable within the same or other option files will be ignored.

The following files are consulted in order.

```text
$ENV{HOME}/.app/$app.conf
$ENV{HOME}/.app/app.conf
$prog_dir/$app.conf
$prog_dir/app.conf
$prefix/etc/app/$app.conf
$prefix/etc/app/app.conf
/etc/app/app.conf
```

If the special option, `$app` is the program name without any trailing extension (i.e. ".exe", ".pl", etc.).

The Program Directory `$prog_dir` is the directory in which the program exists on the file system.

The Special Option `$prefix` represents the root directory of the software installation.

### Environment Variables

For each variable/value pair that is to be inserted into the option,
the corresponding environment variables are searched to see if they are defined.

The environment always overrides an option file value.

By default, the environment variable for an option variable named `msg` would be `APP_MSG`.

Example:
```
export APP_MSG="My Teams message"
export APP_TITLE="My Teams title"
perl ms-teams.pl
```

### Command Line Argument

Each command line argument that begins with a "-" or a "--" is considered to be an option:

```shell
--msg=test # long option, with arg
-msg=test  # short option, with arg
```

The command line argument always overrides an option file value and environment variable.

### Debug

Specifying the `--debug_options` option on the command line will assist in figuring out which files App::Options is looking at.

Example:
```text
$ perl ms-teams.pl --debug_options
1. Parsed Command Line Options. [--debug_options]
3. Provisional prefix Set. prefix=[/home/nils/perl5/perlbrew/perls/perl-5.26.1] origin=[perl prefix]
4. Set app variable. app=[ms-teams] origin=[program name (ms-teams.pl)]
5. Scanning Option Files
   Looking for Option File [/etc/app/policy.conf]
   Looking for Option File [/home/nils/.app/ms-teams.conf]
   Looking for Option File [/home/nils/.app/app.conf]
   Looking for Option File [./ms-teams.conf]
   Looking for Option File [./app.conf]
   Looking for Option File [/home/nils/perl5/perlbrew/perls/perl-5.26.1/etc/app/ms-teams.conf]
   Looking for Option File [/home/nils/perl5/perlbrew/perls/perl-5.26.1/etc/app/app.conf]
   Looking for Option File [/etc/app/app.conf]
6. Scanning for Environment Variables.
7. prefix Made Definitive [/home/nils/perl5/perlbrew/perls/perl-5.26.1]
8. Set Defaults.
```

## Contributing

Have a patch that will benefit this project?
Awesome! Follow these steps to have it accepted.

1. Please read [how to contribute](CONTRIBUTING.md).
1. Fork this Git repository and make your changes.
1. Create a Pull Request.
1. Incorporate review feedback to your changes.
1. Accepted!


## License

All files in this repository are under the [Apache License, Version 2.0](LICENSE) unless noted otherwise.