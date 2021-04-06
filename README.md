# Reliably GitHub Action

Reliably integrates with GitHub as a [GitHub Action][gh-action] that you can add to your own GitHub CI/CD workflows. Our Action is available on GitHub's [Marketplace][view-on-marketplace].

[gh-action]: https://github.com/features/actions
[view-on-marketplace]: https://github.com/marketplace/actions/reliably-github-action



You use the Reliably GitHub Action by including it in any of your GitHub workflow
YAML files:

```yaml
name: Example workflow using Reliably
on: push
jobs:
  reliably:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout source code'
        uses: actions/checkout@v2
      - name: Get Reliably suggestions
        uses: reliablyhq/gh-action@v1
        env:
          RELIABLY_TOKEN: ${{ secrets.RELIABLY_TOKEN }}
```
The code above adds a new job called `reliably` that checks out the code from your repository and then uses the Reliably GitHub Action to obtain any reliability advice and suggestions based on the code in the checked out repository.

The Reliably GitHub Action has properties which are passed to the underlying image.
These are passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| dir | . | Path of the folder to scan for advice |
| format | simple | Format of report generated by Reliably |
| output | | Write the report to a specific file path; if not specified, report is printed to stdout |


### Getting your Reliably token

The Action example above refer to a Reliably access token:

```yaml
env:
  RELIABLY_TOKEN: ${{ secrets.RELIABLY_TOKEN }}
```

You can retrieve your access token once authenticated with the CLI:
```
$ reliably auth status --show-token
```

### Specifying a custom folder for review

```yaml
name: Example workflow using Reliably with a custom folder
on: push
jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout source code'
        uses: actions/checkout@v2
      - name: Get Reliably suggestions
        uses: reliablyhq/gh-action@v1
        with:
          dir: './manifests'
```

### Triggering the action on a specific file change only

You can trigger the workflow only when your manifests files change,
using the `on` syntax as follow:

```yaml

on:
  push:
    paths:
      - 'manifest.yaml'
```

Or for any yaml file within your repository:

```yaml

on:
  push:
    paths:
      - '**.yaml'
```

To know more on how to filter paths, for triggering your workflow,
you can have a look at the [GitHub Workflow syntax](https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-syntax-for-github-actions#onpushpull_requestpaths) reference docs.


### Continuing on error

The above examples will fail the workflow when any Reliability suggestions are made.
If you want to ensure the Action continues, even if Reliably surfaces suggestions,
then [continue-on-error](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idstepscontinue-on-error) can be used.


```yaml
name: Example workflow using Reliably with continue on error
on: push
jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout source code'
        uses: actions/checkout@v2
      - name: Run Reliably to check Kubernetes manifests for reliability advice
        uses: reliablyhq/gh-action@v1
        continue-on-error: true
```


### Change the report format & output

Reliably supports mutltiple output formats, such as `simple` (default),
`json`, `yaml`, `sarif`, `codeclimate`.

To ask the action to generate the report in another format, you can
use the `format` property, as follow:

```yaml
- name: 'Run Reliably'
  uses: reliablyhq/gh-action@v1
  with:
    format: "sarif"
```

You can also decide to generate and write the report to a local file,
rather than to the standard output, by using the `output` property:

```yaml
- name: 'Run Reliably'
  uses: reliablyhq/gh-action@v1
  with:
    output: "reliably.sarif"
```

As a reminder, the `format` and `output` properties can be combined together.

### Install Reliably's CLI in your workflow runner

You can also setup Reliably within your workflow, so that the command
is directly available in a job step.

You will find the `Setup Reliably` action details [here](https://github.com/reliablyhq/gh-action/tree/main/setup).