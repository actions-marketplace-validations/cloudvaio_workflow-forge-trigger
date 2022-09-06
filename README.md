# Workflow Forge Trigger

A Github workflow action to invoke CloudVA Forge Trigger and wait for its return code.
Passes all GITHUB_* and FORGE_* environment variables to the Trigger target.

# Usage:
```yaml
  - name: Invoke deployment hook
    uses: cloudvaio/workflow-forge-trigger
    env:
      FORGE_TRIGGER: https://cloudva.io/trigger/deadbeef/pull
      FORGE_SECRET:  ${{ secrets.forge_deadbeef_secret }}
      FORGE_CPU: 6    # optional
      FORGE_RAM: 8192 # optional
      FORGE_ENV: {    # optional, extra user-defined environment
        answer: 42    # this will be accessible as "$answer" on Forge
      }
```

Will invoke the 'deadbeef' trigger on Forge.
A Forge Docker or Run flow connected to the trigger will have access to GITHUB_* and FORGE_* environment variables as well as those defined in FORGE_ENV, so the following Run flow works as expected:

```yaml
prepare:
  - git clone https://github.com/$GITHUB_REPOSITORY repo
  - cd repo
  - git checkout $GITHUB_REF
  - echo $answer #echoes "42"
execute:
  - cd repo
  - ./configure 
  - make -j $FORGE_CPU
```
