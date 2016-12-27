{ terminator }:
terminator.overrideDerivation (drv: {
  patches = (drv.patches or []) ++ [ ./config-search.patch ];
})
