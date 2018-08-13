# docker-algernon
Dockerfile for Algernon Web Server

This is a copy of the original Algernon Web Server production dockerfile with several modifications:

- Uses golang alpine as base instead of regular golang
- Runs as user instead of root
- Disabled SSL (I'm using nginx as reverse proxy)
- Removed "-c" option so it can detect when files are modified
