import os
import sys
import json

from shared.config.loader import set_config, get_config
from shared.logger import JsonLogger as log

logger = log(__file__)


def handler(event, context):
    try:
        set_config()
        environment = os.environ.get("environment", "")
        if environment == "local":
            logger.set_request_id("local")
        else:
            logger.set_request_id(context.aws_request_id)

        logger.log("incoming event: " + json.dumps(event))
        return "hello world!"
    except Exception:
        logger.log_error(sys.exc_info())
        error_message = "failure"
        logger.log(error_message)
        raise RuntimeError(error_message)


######
######
# For local testing
#
# Just run: python3 hello-world.py
######
if __name__ == "__main__":
    os.environ["environment"] = "local"
    testData = {
        "body": {
        }
    }
    handler(testData, "")
