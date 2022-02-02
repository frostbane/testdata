# ○○○ #

----------------------------------------------------------------------

## Setup ##

yesod will not build when using powershell as your shell

**create a project**

```sh
$ stack new some-project yesodweb/postgres
```

stack templates

- minimal
- mongo
- mysql
- postgres
- simple
- sqlite

**build yesod cli tool (maybe optional?)**

```sh
$ stack install yesod-bin
```

**build project**

```sh
$ cd some-proj
$ stack build
```

stack will not be able to build a yesod project if yesod is not found in the path.

@see [License](./dev/LICENSE.md)

@see [Security](./dev/SECURITY.md)
