FROM jenkins/jenkins:latest

USER root

# Install R and system dependencies
RUN apt-get update && \
    apt-get install -y \
    r-base \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    git \
    && apt-get clean

# Create working directory and copy project files
RUN mkdir /workspace
COPY . /workspace
WORKDIR /workspace

# Switch to Jenkins user
USER jenkins

# Add a shell script to run the R pipeline
RUN echo '#!/bin/bash\n\
echo "GITHUB_PAT is: $GITHUB_PAT"\n\
Rscript -e "renv::activate()"\n\
Rscript -e "renv::restore()"\n\
echo "Current directory:"\n\
ls\n\
Rscript pipeline.R' > run_pipeline.sh && chmod +x run_pipeline.sh

EXPOSE 8080

CMD ["./run_pipeline.sh"]
