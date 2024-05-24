# Update Action File

A simple GitHub action for updating a template file with specified values and
pushing the changes to a repository.

## Inputs

### `repository`

- **Description**: The repository to push the changes to. Can be obtained from
  the `github.repository` context.
- **Example**: `alvelive/update-action`
- **Required**: true

### `branch`

- **Description**: The branch to push the changes to. Can be obtained from the
  `github.head_ref` context.
- **Example**: `main`, `user/feature-branch`
- **Required**: true

### `sha`

- **Description**: The commit SHA to be used to construct `base_url`. Can be
  obtained from the `github.sha` context.
- **Required**: true

### `template`

- **Description**: The file to read the input from.
- **Default**: `action-template.yml`
- **Required**: true

### `output`

- **Description**: The file to write the output to.
- **Default**: `action.yml`
- **Required**: true

### `match`

- **Description**: The string to replace.
- **Default**: `{{base_url}}`
- **Required**: true

### `replace`

- **Description**: The string to replace with.
- **Default**: `https://raw.githubusercontent.com/${{ repository }}/${{ sha }}/`
- **Required**: false

## Usage

This action reads a template file, replaces a specified string with a given
value or a generated URL, and writes the result to an output file. It then
commits and pushes the changes to the specified repository and branch.

### Example Workflow

```yaml
name: Update Action File

on:
  push:
    branches:
      - main

jobs:
  update-action-file:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v2

      - name: Update Action File
        uses: ./.github/actions/update-action
        with:
          repository: ${{ github.repository }}
          branch: ${{ github.head_ref }}
          sha: ${{ github.sha }}
          template: 'action-template.yml'
          output: 'action.yml'
          match: '{{base_url}}'
          replace: 'https://example.com/new-url'
```

## Steps

1. **Configure Git**

   - Sets global Git configuration for user name and email.

2. **Pull latest changes**

   - Pulls the latest changes from the specified branch with rebase.

3. **Update action file**

   - Reads the template file.
   - Replaces the specified string (`match`) with the given or generated value
     (`replace`).
   - Writes the result to the output file.
   - Verifies the replacement.

4. **Commit and push action**
   - Adds the updated output file.
   - Commits the changes with a message.
   - Pushes the changes to the specified branch.

## Environment Variables

The action uses the following environment variable to construct the replacement
string if `replace` is not provided:

- `replacement`: Constructed as
  `https://raw.githubusercontent.com/{repository}/{sha}/`

## Notes

- Ensure that the `template` file exists and is accessible.
- The action will fail if the specified `match` string is not found and replaced
  in the `template` file.
- The action uses Bash scripts to perform file operations and Git commands.
  Ensure that the runner environment supports Bash.

# Path: action-template.yml
