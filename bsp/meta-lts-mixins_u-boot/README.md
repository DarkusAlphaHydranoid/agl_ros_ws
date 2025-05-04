# meta-lts-mixin scarthgap/u-boot

"Mixin" layer for adding current u-boot into the Yocto Project LTS.

At the time Scarthgap was released in April 2024 it included u-boot 2024.01,
and officially Scarthgap supports only that. This thin special-purpose
mixin layer is meant to provide a current u-boot for Scarthgap
by extending or backporting the appropriate recipes from the master branch of
openembedded-core.

Maintainers:
- Tim Orling <tim.orling AT konsulko DOT com>
- Tom Rini <tom.rini AT konsulko DOT com>
