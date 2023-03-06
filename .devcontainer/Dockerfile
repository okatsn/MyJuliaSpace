# Only if it is VERY necessary and having discussion with your co-worker you may modify this file.
# References:
# https://github.com/andferrari/julia_notebook/blob/master/Dockerfile
# https://github.com/marius311/CMBLensing.jl/blob/master/Dockerfile
# https://github.com/MalteBoehm/julia_docker-compose_template/blob/main/Dockerfile

# From dockerhub get an example image that you don't need to build your linux environment from scratch
FROM jupyter/minimal-notebook:python-3.10
# https://hub.docker.com/layers/jupyter/minimal-notebook/python-3.10/images/sha256-ff7d41def49b6805cb40c0e570d0a0fa12131d1bb9377d7744935be561d16dc9?context=explore
USER root


# RUN echo $("ls")
# To see where am I

ARG PROJECT_DIR=/home/jovyan/whateverisoksinceitwillbeoverwritten
## Starship configuration
# - The current building context (see docker-compose.yml) is ".." (the parent folder of Dockerfile); thus .devcontainer/starship.toml is the right directory
# - In jupyter/base-notebook, WORKDIR is switched to $HOME; in jupyter/minimal-notebook, no WORKDIR switch action. The WORKDIR in previous building seems to be void in this stage.
# - Make sure all things under /home/$NB_USER should be fix-permissions later.
COPY .devcontainer/starship.toml /home/$NB_USER/.config/starship.toml



# [Optional] Add sudo support. Omit if you don't need to install software after connecting.
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo \
        curl \
        bash-completion \
        lcov \
        jq \
        ghostscript \
        pdf2svg \
    && echo $NB_USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$NB_USER \
    && chmod 0440 /etc/sudoers.d/$NB_USER \
    && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

    # ghostscript for handling eps image files
    # pdf2svg is for vscode eps-preview extension


# Install Julia
ARG VARIANT="what.ever.is.ok.since.it.will.be.overwritten.by.that.in.docker-compose.yml"
ARG JULIA_PKG_DEVDIR="this.is.into.which.dev.clones.packages."
ARG SUB_PROJECT_DIR="this.is.into.which.git.clones.any.repos."

# Set enviroment variable
# RUN export JULIA_PKG_DEVDIR=${JULIA_PKG_DEVDIR} \
#     && export SUB_PROJECT_DIR=${SUB_PROJECT_DIR} \
ENV JULIA_PKG_DEVDIR=${JULIA_PKG_DEVDIR} \
    SUB_PROJECT_DIR=${SUB_PROJECT_DIR}

# it should be defined here, despite it will overwritten by that in docker-compose.yml
RUN mkdir /opt/julia-${VARIANT} \
    && curl -L https://julialang-s3.julialang.org/bin/linux/x64/`echo ${VARIANT} | cut -d. -f 1,2`/julia-${VARIANT}-linux-x86_64.tar.gz | tar zxf - -C /opt/julia-${VARIANT} --strip=1 \
    && ln -fs /opt/julia-${VARIANT}/bin/julia /usr/local/bin/julia




# CHECKPOINT: I don't know why USER's GID is 1000, which is not 100  as here (https://hub.docker.com/layers/jupyter/minimal-notebook/ubuntu-22.04/images/sha256-a1b3973c6699351118799ad96b55c1fa71b186fa2a9983a4a63aa103905fb073?context=explore) or here (https://hub.docker.com/r/jupyter/base-notebook/dockerfile)
# Add NB_USER to the group of NB_GID (fix-permissions still failed (14/14] RUN fix-permissions /home/jovyan))
# RUN usermod -g $NB_GID $NB_USER



# NB_USER is defined in jupyter/minimal-notebook
USER $NB_USER
WORKDIR $PROJECT_DIR





# Environments
# TODO: CHECK!! use environment.yml, Project.toml and Manifest.toml to add python and julia packages
COPY .devcontainer/environment.yml ${PROJECT_DIR}
RUN conda env update --file environment.yml \
    && rm -f environment.yml
#     && mkdir -p ~/.julia/environments/v`echo ${VARIANT} | cut -d. -f 1,2`
#     && cp Project.toml Manifest.toml ~/.julia/environments/v`echo ${VARIANT} | cut -d. -f 1,2`/Project.toml \
#     && julia -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

# Add python packages and add invoke shell completion
# installation of rise: equivalent to `conda install -c conda-forge rise` in bash.
#     Note that installing "rise" and other packages at the same time will give an error (not sure why), so use the new install command line to install "rise".
# jupyter_contrib_nbextensions: equivalent to `pip install jupyter_contrib_nbextensions` and `jupyter contrib nbextension install --user` in bash.
# BONUS: setting `"rise": {"scroll": true}`: Open File in vscode (Ctrl+O) and add `"rise": {"scroll": true}` in `/home/<username>/.jupyter/nbconfig/notebook.json`.
# HINT: `conda list` to see the version.
# HINT: `jupyter notebook` in bash to get the link to the notebook hosted in the virtual machine.
# TODO: write documentation in InstallJupyterLabWithoutAnaconda.md


# KEYNOTE: In cases of AttributeError, (e.g., AttributeError: module 'lib' has no attribute 'OpenSSL_add_all_algorithms'), try the followings: 
# # [In the case where there is no attribute openssl](https://stackoverflow.com/questions/74980825/build-the-project-in-git-actions-using-sam-i-am-getting-new-error-attributeerr)
# RUN pip install --upgrade pyopenssl
# Similar issues:
# # https://askubuntu.com/questions/1428181/module-lib-has-no-attribute-x509-v-flag-cb-issuer-check/1433089#1433089
# # https://stackoverflow.com/questions/73830524/attributeerror-module-lib-has-no-attribute-x509-v-flag-cb-issuer-check
# RUN pip install pip --upgrade \
#     && pip install pyopenssl --upgrade
#
# # [In the case where there is no attribute X509_V_FLAG_CB_ISSUER_CHECK](https://stackoverflow.com/questions/74705127/how-to-fix-error-module-lib-has-no-attribute-x509-v-flag-cb-issuer-check)
# RUN pip uninstall -y cryptography \
#     && pip install --upgrade cryptography==36.0.2

# KEYNOTE: Pinned Version is successfully installed at 2023-03-03
RUN mamba install --quiet --yes \
        invoke=2.0 \
        pre-commit=3.1 \
        commitizen=2.28 \
        dvc-s3=2.21 \
        dvc-gdrive=2.19 \
    && mamba clean --all -f -y \
    && npm cache clean --force

# Add julia packages and precompile
# NOTE: These packages will be added under @#.# (e.g. @v1.6)
RUN julia -e 'using Pkg; Pkg.update()' \
    && julia -e '\
        using Pkg; \
        Pkg.Registry.add(RegistrySpec(url = "https://github.com/okatsn/OkRegistry.git")); \
        Pkg.add( \
            [ \
                PackageSpec(name="Revise"), \
                PackageSpec(name="BenchmarkTools"), \
                PackageSpec(name="OhMyREPL"), \
                PackageSpec(name="JuliaFormatter"), \
                PackageSpec(name="Documenter"), \
                PackageSpec(name="LiveServer"), \
                PackageSpec(name="Pluto"), \
                PackageSpec(name="PlutoUI"), \
                PackageSpec(name="DaemonMode"), \
                PackageSpec(name="LocalCoverage"), \
                PackageSpec(name="OkPkgTemplates"), \
            ] \
        ) \
    ' \
    && julia -e ' \
        using Pkg; \
        Pkg.add(name="IJulia"); \
        using IJulia \
    '

ENV JULIA_PROJECT=@.

# Avoid VS Code extension reinstalls
# https://code.visualstudio.com/remote/advancedcontainers/avoid-extension-reinstalls
RUN mkdir -p /home/$NB_USER/.vscode-server/extensions \
        /home/$NB_USER/.vscode-server-insiders/extensions \
        $SUB_PROJECT_DIR \
    && chown -R $NB_USER \
        /home/$NB_USER/.vscode-server \
        /home/$NB_USER/.vscode-server-insiders

# Jupyter settings
RUN mkdir -p /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/notebook-extension \
    && echo '{"codeCellConfig": {"lineNumbers": true}}' | jq\
        >> /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings \
    && mkdir -p /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension \
    && echo '{"shortcuts": [{"command": "runmenu:restart-and-run-all", "keys": ["Alt R"], "selector": "[data-jp-code-runner]"}]}' | jq\
        >> /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/shortcuts-extension/shortcuts.jupyterlab-settings \
    && mkdir -p /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/apputils-extension \
    && echo '{"modal": false}' | jq\
        >> /home/$NB_USER/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/palette.jupyterlab-settings \
    && mkdir -p /home/$NB_USER/.jupyter/nbconfig \
    && echo '{"nbext_hide_incompat": false}' | jq \
        >> /home/$NB_USER/.jupyter/nbconfig/commom.json \
    && echo '{"load_extensions": {"toc2/main": true}, "rise": {"scroll": true, "enable_chalkboard": true}}' | jq \
        >> /home/$NB_USER/.jupyter/nbconfig/notebook.json

# Shell completion and alias
RUN inv --print-completion-script bash > ~/.invoke-completion.sh \
    && echo "source ~/.invoke-completion.sh" >> ~/.bashrc \
    && dvc completion -s bash | sudo tee /etc/bash_completion.d/dvc \
    && echo -e "alias juliaclient='julia --startup-file=no -e \"using DaemonMode; runargs()\"'" >> ~/.bashrc

# Install Starship
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y \
    && echo 'eval "$(starship init bash)"' >> ~/.bashrc \
    && mkdir -p ~/.config
#    && echo -e '[conda]\nsymbol = "Conda "\nignore_base = false' > ~/.config/starship.toml
# starship settings are now all managed directly in .devcontainer/starship.toml
# ">" : overwrite
# ">>": append

# # CHECKPOINT: Temporary disable fix-permissions
# (2023-3-3) Container successfully built but
# (my-julia-space) pkg> dev FSDatasets
#      Cloning git-repo `https://github.com/okatsn/FSDatasets.jl`
# ERROR: IOError: could not spawn `'f()' '{' /home/jovyan/.vscode-server/bin/441438abd1ac652551dbe4d408dfcec8a499b8bf/node /tmp/vscode-remote-containers-de4ebca6-e333-4bfa-b397-59900a3e2d17.js git-credential-helper '$*;' '};' f get`: no such file or directory (ENOENT)
# RUN fix-permissions /home/$NB_USER
# See also: [The fix-permissions script must be re-run on $HOME after various setup.](https://github.com/jupyter/docker-stacks/issues/547)

# # CHECKPOINT: fix-permissions with sudo failed:
# #  14/14] RUN sudo fix-permissions /home/jovyan:
# # #0 0.686 find: argument to -group is empty, but should be a group name
# RUN sudo fix-permissions /home/$NB_USER

# Pluto port
EXPOSE 1234
