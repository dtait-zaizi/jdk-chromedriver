# jdk-chromedriver
## Java JDK with SSL

This is a small bootstrap container that allows for custom certificate bundles and CA's  to be added to a mounted volume.
It will then update the certificate stores and the default java keystore.


## Expectations

* /certs - can contain bundle certificates
* /ca - must contain any private trusted CA's you need to trust as individual PEM or CRT files.


# alpine-chrome
Minimal java jdk8 & Headless Chrome Docker Images built on Alpine Linux
Based on `DigitalPatterns/jdk`

# Why this image

We often need a headless chrome.
We created this image to get a fully headless chrome image.
Be careful to the "--no-sandbox" flag from Chrome

# 3 ways to use Chrome Headless with this image

## Not secured

Launch the container using:

`docker container run -it --rm dtait-zaizi/jdk-chromedriver` and use the `--no-sandbox` flag for all your commands. 

Be careful to know the website you're calling.

Explanation for the `no-sandbox` flag in a [quick introduction here](https://www.google.com/googlebooks/chrome/med_26.html) and for [More in depth design document here](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)

## With SYS_ADMIN capability

Launch the container using:
`docker container run -it --rm --cap-add=SYS_ADMIN dtait-zaizi/jdk-chromedriver`

This allows to run Chrome with sandboxing but needs unnecessary privileges from a Docker point of view.

## The best: With seccomp 

Thanks to ever-awesome Jessie Frazelle seccomp profile for Chrome.

[chrome.json](https://github.com/Zenika/alpine-chrome/blob/master/chrome.json)

Also available here `wget https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json`

Launch the container using: 
`docker container run -it --rm --security-opt seccomp=$(pwd)/chrome.json dtait-zaizi/jdk-chromedriver`

# How to use in command line

## Default entrypoint 

The default entrypoint does the following command: `chromium-browser --headless --disable-gpu`

You can get full control by overriding the entrypoint using: `docker run -it --rm --entrypoint "" dtait-zaizi/jdk-chromedriver chromium-browser ...`

## Use the devtools

Command (with no-sandbox): `docker container run -d -p 9222:9222 dtait-zaizi/jdk-chromedriver --no-sandbox --remote-debugging-address=0.0.0.0 --remote-debugging-port=9222 https://www.chromestatus.com/`

Open your browser to: `http://localhost:9222` and then click on the tab you want to inspect. Replace the beginning 
`https://chrome-devtools-frontend.appspot.com/serve_file/@.../inspector.html?ws=localhost:9222/[END]`
by 
`chrome-devtools://devtools/bundled/inspector.html?ws=localhost:9222/[END]`

## Print the DOM 

Command (with no-sandbox): `docker container run -it --rm dtait-zaizi/jdk-chromedriver --no-sandbox --dump-dom https://www.chromestatus.com/`

## Print a PDF

Command (with no-sandbox):  `docker container run -it --rm -v $(pwd):/usr/src/app dtait-zaizi/jdk-chromedriver --no-sandbox --print-to-pdf --hide-scrollbars https://www.chromestatus.com/`

## Take a screenshot

Command (with no-sandbox):  `docker container run -it --rm -v $(pwd):/usr/src/app dtait-zaizi/jdk-chromedriver --no-sandbox --screenshot --hide-scrollbars https://www.chromestatus.com/`

### Size of a standard letterhead.

Command (with no-sandbox):  `docker container run -it --rm -v $(pwd):/usr/src/app dtait-zaizi/jdk-chromedriver --no-sandbox --screenshot --hide-scrollbars --window-size=1280,1696 https://www.chromestatus.com/`

### Nexus 5x

Command (with no-sandbox):  `docker container run -it --rm -v $(pwd):/usr/src/app dtait-zaizi/jdk-chromedriver --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/`

### Screenshot owned by current user (by default the file is owned by the container user)

Command (with no-sandbox):  ``docker container run -u `id -u $USER` -it --rm -v $(pwd):/usr/src/app dtait-zaizi/jdk-chromedriver --no-sandbox --screenshot --hide-scrollbars --window-size=412,732 https://www.chromestatus.com/``



# References

 * Headless Chrome website: https://developers.google.com/web/updates/2017/04/headless-chrome

 * List of all options of the "Chromium" command line: https://peter.sh/experiments/chromium-command-line-switches/

 * Where to file issues: https://github.com/dtait-zaizi/jdk-chromedriver/issues

 * Maintained by: https://www.zaizi.com

# Versions (in latest)

## Alpine version

```
docker run -it --rm --entrypoint "" dtait-zaizi/jdk-chromedriver cat /etc/alpine-release
3.8.0
```

## Chrome version

```
docker run -it --rm --entrypoint "" dtait-zaizi/jdk-chromedriver chromium-browser --version
Chromium 68.0.3440.75
```
