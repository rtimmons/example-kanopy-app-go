# Golang Web Application Template Repo

This repo helps to setup some of the boilerplate for a Golang web application. The repository structure is informed by how we manage Kanopy applications and should adhere to guidance in our [coding style guide](https://github.com/10gen/infrastructure-handbook/tree/master/docs/code/style).

## Usage

### Build from GitHub template
```
make
```

### Build from clone
```
# Configure repo variable
REPO=my-org/my-app

# Clone this repo
git clone git@github.com:10gen/kanopy-app-go.git $(basename ${REPO})
cd $(basename ${REPO})

# Set new remote URL
git remote set-url origin git@github.com:${REPO}.git

# Build templates
make
```

### Run the application (after the initial make)
```
make docker docker-run
```

To validate it works navigate to http://localhost:8080/ and you should see `hello world` displayed.
Alternatively you can send a get request (through curl or postman) to localhost:8080 and get `hello world` as a response.

### Reset build changes
```
git remote set-url origin git@github.com:10gen/kanopy-app-go.git
git reset --hard origin/main
```
