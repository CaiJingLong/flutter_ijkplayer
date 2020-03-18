if [ "$1" == "dev" ]; then
    rm IJKMediaFramework.framework
    ln -s /Volumes/Samsung-T5/code/media_projects/ijkplayer/flutter_ijk/ios/output/IJKMediaFramework.framework IJKMediaFramework.framework
    rm flutter_ijkplayer.podspec
    ln flutter_ijkplayer.dev.podspec flutter_ijkplayer.podspec
    echo 'switch to local'
elif [ "$1" == "prod" ]; then
    rm IJKMediaFramework.framework
    rm flutter_ijkplayer.podspec
    ln flutter_ijkplayer.prod.podspec flutter_ijkplayer.podspec
    echo 'switch to pod version'
else
    echo "Switch dev or product"
    echo "Usage:"
    echo "  $0 dev|prod"
fi
