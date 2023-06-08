# README
This is a workspace of the julia language built based on [jupyter/minimal-notebook](https://hub.docker.com/r/jupyter/minimal-notebook).
You can use built image `FROM` [okatsn/my-julia-space](https://hub.docker.com/repository/docker/okatsn/my-julia-space).

## Instruction for developer
### Build the image based on files in .devcontainer
Make sure the following files are prepared:
- Dockerfile: Script for building the container
- docker-compose.yml: The Compose file that uses Dockerfile and set volumes up.
- devcontainer.json: The file for vscode set up.

#### In vscode 

Steps
- Install `Dev Containers` (as well as WSL and so on. See [this](https://github.com/okatsn/swc-forecast-TWAI-23a/blob/master/DEVELOPMENT.md#install-or-set-up-prerequisite) for more information)
- `Ctrl+Shift+P` and select **Dev Containers: Rebuild Container Without Cache**

### Docker commit, tag, and push

[Ref.](https://docs.docker.com/engine/reference/commandline/commit/)

Once an image is successfully built, commit and push the image as follows:

#### Get container ID
**in wsl**
- `docker container list` to get the CONTAINER_ID 

**in Docker Desktop**
- click on tab "Containers" 
- expand the droplist of `myjuliaspace_devcontainer` and it shows

#### Commit

- In wsl, `docker commit CONTAINER_ID user/repo` 
    - e.g., `docker commit 3935a2cd9ee6 okatsn/my-julia-space`

commit with a tag and message:
- `docker commit -m "Hello World!" 89065a96c90b okatsn/my-tex-life-with-julia:helloworld`

#### Push committed image

Push committed image
- in wsl, `docker image push okatsn/my-julia-space`
- By default it pushes the image with the tag of `latest`.

Push the image with the `helloworld` tag:
- `docker image push okatsn/my-julia-space:helloworld`

#### To use the image:
- in .devcontainer/Dockerfile, with `FROM okatsn/my-julia-space`
- add .devcontainer/docker-compose.yml
- add .devcontainer/devcontainer.json

