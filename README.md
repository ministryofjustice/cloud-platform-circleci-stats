# CircleCI Stats

Fetch metadata from the CircleCI API on all ministryofjustice jobs and log to an elasticsearch cluster.

This data can be used to track how long jobs are waiting to be processed by CircleCI, to inform decisions about how much capacity to purchase.

## Usage

See `makefile` for instructions on building, tagging and pushing a docker image for this project.

See `example.env` for the environment variables that need to be in scope when the container is executed.
