
chkpath() { tr ":" "\n" <<< "${PATH}"; }
now() { date +"%Y%m%d-%H%M%S"; }
out-clip() { xclip -selection clipboard; }
out-code() { code -; }
out-curl() { curl --form "clbin=<-" https://clbin.com; }
