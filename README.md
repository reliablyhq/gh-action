# Reliably GitHub Action

A [GitHub Action](https://github.com/features/actions) for using
[Reliably](https://reliably.com) to check for vulnerabilities in your
Kubernetes manifests.


You can use the Action as follows:

```yaml
name: Example workflow using Reliably
on: push
jobs:
  demo:
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout source code'
        uses: actions/checkout@v2
      - name: Run Reliably to check Kubernetes manifests for vulnerabilities
        uses: reliablyhq/gh-action@main
        with:
          files: 'manifest.yaml'
```

The Reliably Action has properties which are passed to the underlying image.
These are passed to the action using `with`.

| Property | Default | Description |
| --- | --- | --- |
| files |   | List of file paths to check for vulnerabilities |



### Continuing on error

The above examples will fail the workflow when issues are found.
If you want to ensure the Action continues, even if Reliably finds vulnerabilities,
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
      - name: Run Reliably to check Kubernetes manifests for vulnerabilities
        continue-on-error: true
        uses: reliablyhq/gh-action@main
        with:
          files: 'manifest.yaml'
```