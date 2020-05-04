for r in deployment service ingress; do
    for c in us-east.oncokb.dev ap-northeast.oncokb.dev; do
        echo; echo ------------ ${c} resource: ${r} ------------; echo
        kubectl --context=${c} get ${r} -n test
        echo; echo
    done
done