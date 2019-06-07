#!/usr/bin/env bash

IMAGEDIR="$ROOT/assets"
PROFILE='imagestore5'
BUCKET='http-imagestore'
KEY='branchdiff'
TMPDIR='/tmp'


pkg_path=$(cd "$(dirname $0)"; pwd -P)


function _git_root(){
    ##
    ##  determines full path to current git project root
    ##
    echo "$(git rev-parse --show-toplevel 2>/dev/null)"
}


function _valid_iamuser(){
    ##
    ##  use Amazon STS to validate credentials of iam user
    ##
    local iamuser="$1"

    if [[ $(aws sts get-caller-identity --profile $PROFILE 2>/dev/null) ]]; then
        return 0
    fi
    return 1
}


ROOT=$(_git_root)

# color codes
source "$ROOT/core/colors.sh"
source "$ROOT/core/std_functions.sh"


if _valid_iamuser $PROFILE; then

    printf -- '\n'
    cd "$IMAGEDIR" || true

    declare -a arr_files
    mapfile -t arr_files < <(ls . 2>/dev/null)

    for i in "${arr_files[@]}"; do

        # upload object
        printf -- '\n%s\n\n' "s3 object $BOLD$i$UNBOLD:"
        aws --profile $PROFILE s3 cp ./$i s3://$BUCKET/$KEY/$i 2>/dev/null > $TMPDIR/aws.txt
        printf -- '\t%s\n' "- s3 upload: $(cat $TMPDIR/aws.txt  | awk -F ':' '{print $2 $3}')"

        aws --profile $PROFILE s3api put-object-acl --acl 'public-read' --bucket $BUCKET --key $KEY/$i
        printf -- '\t%s\n' "- s3 acl applied to object $i..."

    done

    printf -- '\n'
    cd "$ROOT" || true

else
    std_message "You must ensure ${bd}${orange}$PROFILE${rst} is present in the local awscli configuration" "ERROR"
fi

# clean up
rm $TMPDIR/aws.txt || true

exit 0
