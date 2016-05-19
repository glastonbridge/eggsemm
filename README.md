# Eggsemm Renoise to XM exporter

(c) 2016 Alex Shaw aka aldroid of slipstream

At least one other tool exists that exports Renoise modules to FastTracker XM format, but I couldn't figure out how to get it to compile on a mac so I wrote my own.  It's extremely limited, it needs a lot of tweaking after export, but if you don't have any other alternatives it's better than a poke in the face.

Stuff it currently does:

* Exports patterns
* Exports volume levels
* Exports single-sample instruments correctly, and multi-sample instruments badly

Stuff that's currently broken:

* Tuning.  Oh boy I made a mess of that
* Effect columns.  Nope, couldn't be bothered
* Error reporting.  Sometimes something's just broken

This exporter is provided under the MIT license.  It's effectively abandonware, I have better things to do than maintain this little plugin, but I would gladly accept pull requests from anyone that wants to fix any of the million things that are wrong, to make effects work nicely or tune the instruments in a sensible way.

# How to include in Renoise

There should be an xrnx file in the Releases section in github.  That's the easiest way to install.  If you want to build it yourlself, just clone the repository and add the source to the `RENOISE_PREFERENCES/Scripts/Tools/__My Tools__/Eggsemm` directory.
