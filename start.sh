#!/bin/bash

# Print Debug Message.
echo "Starting TeamSpeak5 Client in a Nutshell."

# Run TeamSpeak5 if Display is not null (Building Process).
if [ "$BUILD" = "false" ]; then
  ./TeamSpeak
fi
