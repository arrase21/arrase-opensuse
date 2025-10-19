#!/usr/bin/env bash
set +e # disable immediate exit on error

if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
  { wlsunset; } >/dev/null 2>&1 || :
else
  {  pkill wlsunset; } >/dev/null 2>&1 || :
fi

exit 0
