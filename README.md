# drupalvm-buildkite

This docker image is built on the [DrupalVM docker image by Jeff Geerling](https://hub.docker.com/r/geerlingguy/drupal-vm/), with a Buildkite Agent installed on top, as well as Selenium (which consequently also provides Google Chrome), for headless browser testing.

You will need a buildkite agent to initialise it when running, as follows:
```
docker run --rm --name foo --env BUILDKITE_AGENT_TOKEN=xxx drupalvm-buildkite
```
