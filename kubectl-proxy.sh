#!/bin/sh

ADDR=127.0.0.1

function usage() {
echo "
Usage: $0 [options...]

Options:
 -w, --wide STRING  Specify proxy wide: local(default) or cluster.
 -h, --help         This help text
"
}

ARGS=`getopt -l wide:,help -- w:h "$@"` || `usage; exit 1`
eval set -- "$ARGS"

while true ; do
    case "$1" in
        -w|--wide)
            case "$2" in
                "local") ADDR=${ADDR:-127.0.0.1};;
                "cluster") ADDR=0.0.0.0;;
                *) echo "Unknown wide \"$2\""; usage; exit 1;;
            esac
            shift 2;;
        -h|--help) usage; exit 0;;
        --) break;;
    esac
done

API_SERVER="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT"
CA_CRT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
TOKEN="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)"

/kubectl proxy --server="$API_SERVER" --certificate-authority="$CA_CRT" --token="$TOKEN" --address="${ADDR}" --port=8080 --accept-hosts='^.*'
