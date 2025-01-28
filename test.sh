#!/bin/bash
AWS_DEFAULT_REGION="ap-south-1"
from="xxx"
to="xxx"
subject="Test email sent at $(date)"
text="Test email with test data sent at test date $(date)"
aws ses send-email --region "${AWS_DEFAULT_REGION}" --from "${from}" --subject "${subject}" --text "${text}" --to "${to}"
