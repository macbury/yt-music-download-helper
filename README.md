# YouTube Music Download Helper

## Build Setup
```
pip install -r requirements.txt 
bundle install
yarn
```

## run development
```
bin/foreman start
# for back-end
# open http://localhost:9292
# for front-end
# open http://localhost:8080
```

## run production
```
docker pull macbury/yt-music-download-helper:latest
docker run -p 9292:9292 yt-music-download-helper:latest -v <path/to/download/result>:/download -v <path/to/result>:/output
```

## deploy
```
rake build
docker tag yt-music-download-helper macbury/yt-music-download-helper:latest
docker push macbury/yt-music-download-helper:latest
```