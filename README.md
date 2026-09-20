# Docker CI/CD demonstration
A simple project to demonstrate how to push a Docker Image automatically using GitHub Actions.

This project uses a simple Next.js app as an example.

## Project structure
```
docker-ci-cd/
├── .github/workflows   # Folder containing GitHub workflows
│   └── docker-publish.yml
├── app/                # Source code for the application
│   └── page.tsx
├── .gitignore 
├── .dockerignore       # Files to ignore when building docker image
├── Dockerfile          # File containing instructions to build the docker image
├── README.md           # The file you are literally looking at right now :o
├── package.json        # Project dependencies
├── package-lock.json
└── ...
```

## Instructions to build the image manually
First, clone the project:
```bash
git clone https://github.com/Dav0105/docker-ci-cd.git && cd docker-ci-cd
```

Then, build the container:
```bash
docker build -t docker-ci-cd .
```

If everything went smoothly, you can run a container with said image:
```bash
docker run -p 3000:3000 docker-ci-cd
```

The webserver can then be accessed at `http://localhost:3000`.

## CI/CD
This repository contains a single workflow (found in the `.github/workflows/docker-publish.yml` file), which contains the two following jobs:
- `test` executing the tests and checking for eventual errors
- `build` building, publishing the artifact and Docker image to the `ghcr.io` registry, using the `Dockerfile` in the project's root.
  - *This job waits for `test` to finish and runs only if there were no errors.*
  - *Only executes after a reviewer approves the execution.*
---
**Note: Do not confuse artifact and pushed images.**
- **Artifacts** are generated on each workflow build before publishing the image. Those can be found on the action tab, within the workflow run.
- **Pushed image** corresponds to the image that can be found on the _Packages_ tab of the repo. It is the image published on the `ghcr.io` repository.