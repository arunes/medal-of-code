# Medal of Code

![logo](priv/static/images/logo-light.png "Logo")

Turn your development work into a playful quest for glory with Medal of Code — the gamified dev experience!

![build](https://github.com/arunes/medal-of-code/actions/workflows/build-test-publish.yml/badge.svg)

## Docker

**Running with the default configuration**

```shell
docker run -p 8080:4000 --pull always ghcr.io/arunes/medal-of-code
```

Go to http://localhost:8080

### Other options
- If you are running Medal of Code publicly, it is strongly suggested that you use your own secret key by setting `SECRET_KEY_BASE` environment variable to any 64 bit string.
- If you are running Medal of Code somewhere else other than localhost, you have to set `PHX_HOST` environment variable to your host name.

# Roadmap

- Fix views for mobile
- Add user management
- Add ability to change cutoff date for imports
- Add ability to update organization
- Add github
