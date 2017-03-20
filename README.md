# watchn

[![Build Status](https://travis-ci.org/satosystems/watchn.svg?branch=master)](https://travis-ci.org/satosystems/watchn)

Watch file and run command.

## Usage

```
Usage:
  watchn -c 'open -g -a Preview out.png' -f 'out.png' -e M
  watchn -c "cat ?" -e AM
  watchn -c 'touch .lock' -f '.lock' -e R

Available options:
  -c 'command'       Command when matched file
                       ('?' means mached file name)
  -f 'filename'      Filter watching file name (optional)
  -e [A|M|R]         Filter events (optional)
                       A: Added
                       M: Modified
                       R: Removed
  --help             Show this help
  --version          Show version
```

## Installation

### Homebrew

```sh
$ brew tap satosystems/watchn
$ brew install watchn
```

### Binaries

Check out the latest [releases](https://github.com/satosystems/watchn/releases) for
precompiled binaries.

### Stack

Alternatively, feel free to build it yourself with
[stack](http://haskellstack.org).

```sh
$ stack install watchn
$ watchn -V
watchn 0.1.0.0
```

## License

Apache-2.0

