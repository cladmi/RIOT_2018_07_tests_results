#! /bin/bash

# create summary for older results that did not use the last version

set -u

cd $1

resultdir_content=$(echo $(ls | LANG=C sort))
if [ "${resultdir_content}" != "examples tests" ] ; then
    echo "There is not 'examples' and 'tests' only in this directory, abort"
    exit 1
fi

output_for_step() {
    local step=$1
    if find . -name ${step}.failed | grep -q ${step}.failed; then
        echo Failures during ${step}:
        for name in $(find . -name ${step}.failed | sed 's|^./||'); do
            echo "- [$(dirname ${name})](${name})"
        done
    fi
}

out=failuresummary.md
rm -i ${out}
output_for_step compilation | tee -a ${out}
output_for_step test | tee -a ${out}
