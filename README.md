# ○○○ #

----------------------------------------------------------------------

## Setup ##

create a project

```sh
$ stack new some-project yesodweb/postgres
```

build yesod cli tool

```sh
$ stack install yesod-bin
```

build project
```sh
$ cd some-proj
$ stack build
```

stack will not be able to build a yesod project if yesod is not found in the path.

@see [License](./dev/LICENSE.md)

@see [Security](./dev/SECURITY.md)
