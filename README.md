# Cloud Foundry Notifications for Hubot

[Hubot](https://hubot.github.com/) plugin that posts notifications of Cloud Foundry activity via Hubot. When deploying, it sends a notification to the specified channel. Example:

**someuser@myorg.com, from the terminal**

```bash
cf push someapp
```

**Hubot, in the #cf-notifications chat room**

```
someuser@myorg.com is deploying someapp
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

1. Add read-only permissions for the organizations/spaces you want notifications for. You can always add more later.

    ```bash
    cf set-org-role hubot-cf-listener <org> OrgAuditor
    ```

1. Set the following environment variables:
    * `HUBOT_CF_USER` – username of listener user created above
    * `HUBOT_CF_PASS` – password of listener user
    * `HUBOT_CF_API_ORIGIN` – something like `https://api.mycf.com` – look in `~/.cf/config.json` for `Target`
    * `HUBOT_CF_UAA_ORIGIN` – something like `https://uaa.mycf.com` – look in `~/.cf/config.json` for `UaaEndpoint`
    * `HUBOT_CF_ROOM` – optional, defaults to to `cf-notifications`
