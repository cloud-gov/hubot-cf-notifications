# Cloud Foundry Notifications for Hubot

[![Build Status](https://travis-ci.org/18F/hubot-cf-notifications.svg?branch=master)](https://travis-ci.org/18F/hubot-cf-notifications)

[Hubot](https://hubot.github.com/) plugin that posts deployment notifications of applications within Cloud Foundry. Example:

**someuser@myorg.com, from the terminal**

```bash
cf push someapp
```

**Hubot, in the #cf-notifications chat room**

```
Hubot: someuser@myorg.com is deploying someapp
```

## Installation

1. In your Hubot repository, run:

    ```bash
    npm install hubot-cf-notifications --save
    ```

1. Include the plugin in your `external-scripts.json`.

    ```json
    [
      "hubot-cf-notifications"
    ]
    ```

1. Create a Cloud Foundry user that will be used by this bot. You don't need to create a dedicated user, but it's recommended.

    ```bash
    cf create-user hubot-cf-listener <password>
    ```

1. Set the following environment variables:
    * `HUBOT_CF_USER` – username of listener user created above
    * `HUBOT_CF_PASS` – password of listener user
    * `HUBOT_CF_API_ORIGIN` – something like `https://api.mycf.com` – look in `~/.cf/config.json` for `Target`
    * `HUBOT_CF_UAA_ORIGIN` – something like `https://uaa.mycf.com` – look in `~/.cf/config.json` for `UaaEndpoint`

## Adding applications

To get deployment notifications for all applications in an organization/space, run

```bash
cf set-org-role hubot-cf-listener <org> OrgAuditor
# or
cf set-space-role hubot-cf-listener <org> <space> SpaceAuditor
```

This will give the bot read-only permissions to view the events for those applications, and thus send deployment notifications.

### Configuration

*Optional.* To have notification directed to specific chat rooms/channels, create a `cf_config.json` file in the root of your Hubot directory. All sections are optional.

```javascript
{
  // Mappings of notifications from particular organizations to particular rooms.
  "orgs": {
    "myorg": {
      "room": "myroom"
    },
    // ...
  },
  // The room to direct notifications to, if not otherwise specified above. Defaults to `cf-notifications`.
  "room": "notification-central"
}
```

## Development

To run tests, clone the repository, then from the project directory run:

```bash
npm install
npm test
```

To check code coverage:

```bash
npm run coverage
```

To run smoke tests against the live API:

```bash
HUBOT_CF_API_ORIGIN=... HUBOT_CF_UAA_ORIGIN=... HUBOT_CF_USER=hubot-cf-listener HUBOT_CF_PASS=... npm run smoke
```

## See also

* [cfbot](https://github.com/jthomas/cfbot)
* [hubot-cf](https://github.com/andypiper/hubot-cf)
* [hubot-deploy](https://github.com/atmos/hubot-deploy)
