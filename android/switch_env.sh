cd src/main
case "$1" in
"dev")
    mv libs libs-prod
    ln -s /Volumes/Samsung-T5/code/media_projects/ijkplayer/flutter_ijk/android/out/libs libs
    ;;
"prod")
    rm libs
    mv libs-prod libs
    ;;
*)
    echo "$0 dev|prod"
    exit 1
    ;;
esac
