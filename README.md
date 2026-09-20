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

## Docker automatic image building
Each time a commit is pushed to the main branch or if a new tag (in the `v*.*.*` format) is created, the workflow _Docker publish_ (found in the `.github/workflows/docker-publish.yml` file) is run.

The workflow builds the Docker image for the project (using the `Dockerfile` found in the project root), logs in to the `ghcr.io` registry and publishes it if the event **is a tag creation**.
In the case where no tag has been pushed (only a regular push), the container is still built, but not pushed (the build can still be found as an artifact in the action).