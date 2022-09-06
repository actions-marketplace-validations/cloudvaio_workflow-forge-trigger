#!/bin/bash
if [ -z "$FORGE_TRIGGER" ]; then
  echo "No FORGE_TRIGGER"
  exit 1
fi
if [ -z "$FORGE_SECRET" ]; then
  echo "No FORGE_SECRET"
  exit 1
fi
if [ -z "$FORGE_TIMEOUT" ]; then
  FORGE_TIMEOUT=600
fi
function post(){
  endpoint=$1
  payload=$2
  signature=$(echo -n "$payload" | openssl dgst -sha256 -hmac "$FORGE_SECRET" -binary | xxd -p |tr -d '\n')
  curl -k -s --http1.1 --fail \
    -H "Content-Type: application/json" \
    -H "User-Agent: GitHub-Hookshot/760256b" \
    -H "X-Hub-Signature-256: sha256=$signature" \
    -H "X-GitHub-Delivery: $GITHUB_RUN_NUMBER" \
    -H "X-GitHub-Event: $GITHUB_EVENT_NAME" \
    --data "$payload" $endpoint
}
payload="$(jq -n 'env|with_entries(select(.key|test("GITHUB_|FORGE_")))')"
id=$(post $FORGE_TRIGGER "$payload" | jq -r '.job')
joburl=https://cloudva.io/job/$id/state
while [ $FORGE_TIMEOUT -gt 0 ]; do
  state=$(post $joburl "" | jq -r '.state')
  case $state in
    queued|running)
      FORGE_TIMEOUT=$((FORGE_TIMEOUT-5));
      sleep 5;;
    success)
      exit 0;;
    *)
      exit 1;;
  esac
done
if [ $FORGE_TIMEOUT -gt 0 ]; then
  exit 0
fi
exit 1
