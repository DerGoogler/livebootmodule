width=$(dumpsys display | grep -i real | grep -vi overridedisplay | awk '{print $2}')
height=$(dumpsys display | grep -i real | grep -vi overridedisplay | awk '{print $3}')

fallback_width="fallbackwidth=$width"
fallback_height="fallbackheight=$height"

ui_print "$fallback_width"
ui_print "$fallback_height"

echo "#!/system/bin/sh
#app_process=/system/bin/app_process64
DISABLE=\"/data/adb/modules/livebootmagisk/disable\"
if ! test -e \"\$DISABLE\"; then
  NO_ADDR_COMPAT_LAYOUT_FIXUP=1
  ANDROID_ROOT=/system
  LD_LIBRARY_PATH=/system/lib64:/system/lib64/drm:/system/lib64/hw:/vendor/lib64:/vendor/lib64/camera:/vendor/lib64/egl:/vendor/lib64/hw:/vendor/lib64/mediacas:/vendor/lib64/mediadrm:/vendor/lib64/soundfx:/system/bin:/librootjava
  CLASSPATH=/data/adb/modules/livebootmagisk/liveboot
  /data/adb/modules/livebootmagisk/libdaemonize.so
  /system/bin/app_process64
  /system/bin --nice-name=eu.chainfire.liveboot:root eu.chainfire.liveboot.e.d /data/adb/modules/livebootmagisk/liveboot boot dark
  $fallback_width
  $fallback_height
  logcatlevels=WEFS
  logcatbuffers=C
  logcatformat=brief
  logcatnocolors
  dmesg=0--1
  lines=80
  wordwrap
fi" > $MODPATH/0000bootlive

install_script -p $MODPATH/0000bootlive
install_script -l $MODPATH/0000bootlive
