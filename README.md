This Docker image is **deprecated**.  Please use the [Heroku-16 image](https://hub.docker.com/r/heroku/heroku/).  
Learn more about [local development with Docker Compose](https://devcenter.heroku.com/articles/local-development-with-docker-compose) and 
[deploying your image to Heroku](https://devcenter.heroku.com/articles/container-registry-and-runtime). 

# Heroku Ruby Docker Image

This image is for use with Heroku Docker CLI.

## Usage

Your project must contain the following files:

* `Gemfile` and `Gemfile.lock`
* Ruby 2.2.3
* `assets:precompile` rake task
* `Procfile` (see [the Heroku Dev Center for details](https://devcenter.heroku.com/articles/procfile))

Then create an `app.json` file in the root directory of your application with
at least these contents:

```json
{
  "name": "Your App's Name",
  "description": "An example app.json for heroku-docker",
  "image": "heroku/ruby"
}
```

Install the heroku-docker toolbelt plugin:

```sh-session
$ heroku plugins:install heroku-docker
```

Initialize your app:

```sh-session
$ heroku docker:init
Wrote Dockerfile
Wrote docker-compose.yml
```

And run it with Docker Compose:

```sh-session
$ docker-compose up web
```

The first time you run this command, Bundler will download all dependencies into
the container, precompile your assets (using the `assets:precompile rake task),
build your application, and then run it. Subsequent runs will use cached
dependencies (unless your `Gemfile` or `Gemfile.lock` has changed).

You'll be able to access your application at `http://<docker-ip>:8080`, where
`<docker-ip>` is either the value of running `boot2docker ip` if you are on Mac
or Windows. If you're running it natively, you'll need to use `docker inspect`
to find the `IPAddress` key.
