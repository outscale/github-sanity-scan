# Github Sanity Check

This reprository helps preventing some dangerous github configuration.

# Usage

Example
```
./scan.sh --no-pull-request-target --path /my/reprository/
```

# Features

Features are very limited for now and may not be suited for your need.

## Forbid `pull_request_target` usage

`--no-pull-request-target`

This scanner will scan `.github/workflows` folder and succeeed if no .yaml or .yml file match `pull_request_target`.

Workflows triggered by events are run in the context of the base branch. Since the base branch is considered trusted, workflows triggered by these events will always run, regardless of approval settings. This mean that usage of `pull_request_target` may allow PR from external reprositories to access github secrets. Using `pull_request_target` is ok if you use environments that you manually approve.

# Contributing

Feel free to open an issue for discussion.
`./tests/tests.sh` to run tests.

# Using scanner in Github actions

## Description

This Github action allows you to scan for dangerous github configuration.
See [action.yml](action.yml)

## Inputs

| Parameter                  | Description                                       | Required | Default          |
| :------------------------- | :------------------------------------------------ | :------- | :--------------- |
| `no-pull-request-target`   | Scan for `pull_request_target` in github actions  | `false`  | `false`          |
| `project-path`             | Path to project's root                            | `false`  | project's folder |

## Output
N/A

## Example

- Create workflow folder: `mkdir -p .github/workflows`
- Create workflow file `.github/workflows/github-sanity-scan.yml` with the following content (adjust `branches`)

```yaml
name: Github sanity scanner

on:
  pull_request:
    branches: [ master ]

jobs:
  cred-scan:
    runs-on: ubuntu-20.04
    steps:
    - uses: actions/checkout@v2
    - name: Github sanity scanner
      uses: outscale/github-sanity-scan@main
      with:
        no-pull-request-target: true
```

# License

> Copyright Outscale SAS
>
> BSD-3-Clause

`LICENSE` folder contain raw licenses terms following spdx naming.

You can check which license apply to which copyright owner through `.reuse/dep5` specification.

You can test [reuse](https://reuse.software/.) compliance by running:
```
docker run --rm --volume $(pwd):/data fsfe/reuse:0.11.1 lint
```
