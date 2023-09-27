from prefect.blocks.notifications import SlackWebhook
from prefect.states import Completed

slack_webhook_block = SlackWebhook(
    notify_type='prefect_default', url="https://hooks.slack.com/services/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", only_states=[Completed])

slack_webhook_block.save("slack-notification", overwrite=True)
slack_webhook_block.notify()
