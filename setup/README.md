# Reliably Setup Action

A [GitHub Action](https://github.com/features/actions) for installing
[Reliably CLI](https://github.com/reliablyhq/cli) to check for
Reliably Advice and Suggestions.

You can use the Action as follows:

```yaml
name: Install Reliably CLI example
on: push
jobs:
  reliability:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: reliablyhq/gh-action/setup@v1
```

The Reliably Setup Action has properties which are passed to the underlying script.
These are passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| reliably-version | latest | Install a specific version of Reliably |

The Action also has outputs:

| Property | Default | Description |
| --- | --- | --- |
| version |   | The full version of the Reliably CLI installed |

For example, you can choose to install a specific version of Reliably.
The installed version can be grabbed from the output:

```yaml
name: Install Reliably CLI example with a specific version
on: push
jobs:
  reliability:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: reliablyhq/gh-action/setup@v1
      id: reliably
      with:
        reliably-version: v0.1.0
    - name: Installed Reliably version
      run: echo "${{ steps.reliably.outputs.version }}"
```