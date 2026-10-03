package com.google.android.material.color.utilities;

import java.util.function.Function;

public final class MaterialDynamicColors {
    public DynamicColor highestSurface(DynamicScheme dynamicScheme) {
        return dynamicScheme.isDark ? surfaceBright() : surfaceDim();
    }

    public DynamicColor primaryPaletteKeyColor() {
        return DynamicColor.fromPalette("primary_palette_key_color", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).primaryPalette.getKeyColor().getTone());
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor secondaryPaletteKeyColor() {
        return DynamicColor.fromPalette("secondary_palette_key_color", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).secondaryPalette.getKeyColor().getTone());
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor tertiaryPaletteKeyColor() {
        return DynamicColor.fromPalette("tertiary_palette_key_color", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).tertiaryPalette.getKeyColor().getTone());
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor neutralPaletteKeyColor() {
        return DynamicColor.fromPalette("neutral_palette_key_color", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).neutralPalette.getKeyColor().getTone());
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor neutralVariantPaletteKeyColor() {
        return DynamicColor.fromPalette("neutral_variant_palette_key_color", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).neutralVariantPalette.getKeyColor().getTone());
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor background() {
        return new DynamicColor("background", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 6.0d : 98.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor onBackground() {
        return new DynamicColor("on_background", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 90.0d : 10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m46x24678954((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(3.0d, 3.0d, 4.5d, 7.0d), null);
    }

    DynamicColor m46x24678954(DynamicScheme dynamicScheme) {
        return background();
    }

    public DynamicColor surface() {
        return new DynamicColor("surface", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 6.0d : 98.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceDim() {
        return new DynamicColor("surface_dim", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 6.0d : 87.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceBright() {
        return new DynamicColor("surface_bright", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 24.0d : 98.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceContainerLowest() {
        return new DynamicColor("surface_container_lowest", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 4.0d : 100.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceContainerLow() {
        return new DynamicColor("surface_container_low", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 10.0d : 96.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceContainer() {
        return new DynamicColor("surface_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 12.0d : 94.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceContainerHigh() {
        return new DynamicColor("surface_container_high", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 17.0d : 92.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor surfaceContainerHighest() {
        return new DynamicColor("surface_container_highest", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 22.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor onSurface() {
        return new DynamicColor("on_surface", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 90.0d : 10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    public DynamicColor surfaceVariant() {
        return new DynamicColor("surface_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 30.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor onSurfaceVariant() {
        return new DynamicColor("on_surface_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 80.0d : 30.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), null);
    }

    public DynamicColor inverseSurface() {
        return new DynamicColor("inverse_surface", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 90.0d : 20.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, null, null, null, null);
    }

    public DynamicColor inverseOnSurface() {
        return new DynamicColor("inverse_on_surface", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 20.0d : 95.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m44xcbcaf83d((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m44xcbcaf83d(DynamicScheme dynamicScheme) {
        return inverseSurface();
    }

    public DynamicColor outline() {
        return new DynamicColor("outline", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 60.0d : 50.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.5d, 3.0d, 4.5d, 7.0d), null);
    }

    public DynamicColor outlineVariant() {
        return new DynamicColor("outline_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 30.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), null);
    }

    public DynamicColor shadow() {
        return new DynamicColor("shadow", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(0.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, null, null, null, null);
    }

    public DynamicColor scrim() {
        return new DynamicColor("scrim", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(0.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, null, null, null, null);
    }

    public DynamicColor surfaceTint() {
        return new DynamicColor("surface_tint", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 80.0d : 40.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, null, null, null, null);
    }

    public DynamicColor primary() {
        return new DynamicColor("primary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$primary$53((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m70x39203b5((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    static Double lambda$primary$53(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 100.0d : 0.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 80.0d : 40.0d);
    }

    ToneDeltaPair m70x39203b5(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(primaryContainer(), primary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onPrimary() {
        return new DynamicColor("on_primary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$onPrimary$56((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m49x16f20f37((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    static Double lambda$onPrimary$56(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 10.0d : 90.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 20.0d : 100.0d);
    }

    DynamicColor m49x16f20f37(DynamicScheme dynamicScheme) {
        return primary();
    }

    public DynamicColor primaryContainer() {
        return new DynamicColor("primary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$primaryContainer$59((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m71x8277b1b9((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    static Double lambda$primaryContainer$59(DynamicScheme dynamicScheme) {
        if (isFidelity(dynamicScheme)) {
            return Double.valueOf(performAlbers(dynamicScheme.sourceColorHct, dynamicScheme));
        }
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 85.0d : 25.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 30.0d : 90.0d);
    }

    ToneDeltaPair m71x8277b1b9(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(primaryContainer(), primary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onPrimaryContainer() {
        return new DynamicColor("on_primary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m50x617ce7dc((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m51x3d3e639d((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    Double m50x617ce7dc(DynamicScheme dynamicScheme) {
        if (isFidelity(dynamicScheme)) {
            return Double.valueOf(DynamicColor.foregroundTone(primaryContainer().tone.apply(dynamicScheme).doubleValue(), 4.5d));
        }
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 0.0d : 100.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 90.0d : 10.0d);
    }

    DynamicColor m51x3d3e639d(DynamicScheme dynamicScheme) {
        return primaryContainer();
    }

    public DynamicColor inversePrimary() {
        return new DynamicColor("inverse_primary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 40.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m45x6f94cccc((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), null);
    }

    DynamicColor m45x6f94cccc(DynamicScheme dynamicScheme) {
        return inverseSurface();
    }

    public DynamicColor secondary() {
        return new DynamicColor("secondary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 80.0d : 40.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m74x991d7367((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m74x991d7367(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(secondaryContainer(), secondary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onSecondary() {
        return new DynamicColor("on_secondary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$onSecondary$71((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m56x1ad791fe((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    static Double lambda$onSecondary$71(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 10.0d : 100.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 20.0d : 100.0d);
    }

    DynamicColor m56x1ad791fe(DynamicScheme dynamicScheme) {
        return secondary();
    }

    public DynamicColor secondaryContainer() {
        return new DynamicColor("secondary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$secondaryContainer$74((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m75x485cd00f((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    static Double lambda$secondaryContainer$74(DynamicScheme dynamicScheme) {
        double d = dynamicScheme.isDark ? 30.0d : 90.0d;
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 30.0d : 85.0d);
        }
        if (!isFidelity(dynamicScheme)) {
            return Double.valueOf(d);
        }
        return Double.valueOf(performAlbers(dynamicScheme.secondaryPalette.getHct(findDesiredChromaByTone(dynamicScheme.secondaryPalette.getHue(), dynamicScheme.secondaryPalette.getChroma(), d, !dynamicScheme.isDark)), dynamicScheme));
    }

    ToneDeltaPair m75x485cd00f(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(secondaryContainer(), secondary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onSecondaryContainer() {
        return new DynamicColor("on_secondary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m57x4fcce1f2((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m58x2b8e5db3((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    Double m57x4fcce1f2(DynamicScheme dynamicScheme) {
        if (isFidelity(dynamicScheme)) {
            return Double.valueOf(DynamicColor.foregroundTone(secondaryContainer().tone.apply(dynamicScheme).doubleValue(), 4.5d));
        }
        return Double.valueOf(dynamicScheme.isDark ? 90.0d : 10.0d);
    }

    DynamicColor m58x2b8e5db3(DynamicScheme dynamicScheme) {
        return secondaryContainer();
    }

    public DynamicColor tertiary() {
        return new DynamicColor("tertiary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$tertiary$80((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m78x1f6aa165((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    static Double lambda$tertiary$80(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 90.0d : 25.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 80.0d : 40.0d);
    }

    ToneDeltaPair m78x1f6aa165(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(tertiaryContainer(), tertiary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onTertiary() {
        return new DynamicColor("on_tertiary", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$onTertiary$83((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m63x36068449((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    static Double lambda$onTertiary$83(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 10.0d : 90.0d);
        }
        return Double.valueOf(dynamicScheme.isDark ? 20.0d : 100.0d);
    }

    DynamicColor m63x36068449(DynamicScheme dynamicScheme) {
        return tertiary();
    }

    public DynamicColor tertiaryContainer() {
        return new DynamicColor("tertiary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return MaterialDynamicColors.lambda$tertiaryContainer$86((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m79x357de1a8((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    static Double lambda$tertiaryContainer$86(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 60.0d : 49.0d);
        }
        if (isFidelity(dynamicScheme)) {
            return Double.valueOf(DislikeAnalyzer.fixIfDisliked(dynamicScheme.tertiaryPalette.getHct(performAlbers(dynamicScheme.tertiaryPalette.getHct(dynamicScheme.sourceColorHct.getTone()), dynamicScheme))).getTone());
        }
        return Double.valueOf(dynamicScheme.isDark ? 30.0d : 90.0d);
    }

    ToneDeltaPair m79x357de1a8(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(tertiaryContainer(), tertiary(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onTertiaryContainer() {
        return new DynamicColor("on_tertiary_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m64xb5c66ea9((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m65x9867113f((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    Double m64xb5c66ea9(DynamicScheme dynamicScheme) {
        if (isMonochrome(dynamicScheme)) {
            return Double.valueOf(dynamicScheme.isDark ? 0.0d : 100.0d);
        }
        if (isFidelity(dynamicScheme)) {
            return Double.valueOf(DynamicColor.foregroundTone(tertiaryContainer().tone.apply(dynamicScheme).doubleValue(), 4.5d));
        }
        return Double.valueOf(dynamicScheme.isDark ? 90.0d : 10.0d);
    }

    DynamicColor m65x9867113f(DynamicScheme dynamicScheme) {
        return tertiaryContainer();
    }

    public DynamicColor error() {
        return new DynamicColor("error", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).errorPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 80.0d : 40.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m42x590ec46a((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m42x590ec46a(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(errorContainer(), error(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onError() {
        return new DynamicColor("on_error", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).errorPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 20.0d : 100.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m47xb6a5d3ac((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m47xb6a5d3ac(DynamicScheme dynamicScheme) {
        return error();
    }

    public DynamicColor errorContainer() {
        return new DynamicColor("error_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).errorPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 30.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m43x33346ee5((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m43x33346ee5(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(errorContainer(), error(), 15.0d, TonePolarity.NEARER, false);
    }

    public DynamicColor onErrorContainer() {
        return new DynamicColor("on_error_container", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).errorPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 90.0d : 10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m48x2dffdbdb((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, null, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m48x2dffdbdb(DynamicScheme dynamicScheme) {
        return errorContainer();
    }

    public DynamicColor primaryFixed() {
        return new DynamicColor("primary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 40.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m72xcb141198((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m72xcb141198(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(primaryFixed(), primaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor primaryFixedDim() {
        return new DynamicColor("primary_fixed_dim", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 30.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m73x8f195ac5((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m73x8f195ac5(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(primaryFixed(), primaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor onPrimaryFixed() {
        return new DynamicColor("on_primary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 100.0d : 10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m52x702e4bf2((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m53x4befc7b3((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m52x702e4bf2(DynamicScheme dynamicScheme) {
        return primaryFixedDim();
    }

    DynamicColor m53x4befc7b3(DynamicScheme dynamicScheme) {
        return primaryFixed();
    }

    public DynamicColor onPrimaryFixedVariant() {
        return new DynamicColor("on_primary_fixed_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 90.0d : 30.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m54x19d0bbbf((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m55xf5923780((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), null);
    }

    DynamicColor m54x19d0bbbf(DynamicScheme dynamicScheme) {
        return primaryFixedDim();
    }

    DynamicColor m55xf5923780(DynamicScheme dynamicScheme) {
        return primaryFixed();
    }

    public DynamicColor secondaryFixed() {
        return new DynamicColor("secondary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 80.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m76x75ece309((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m76x75ece309(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(secondaryFixed(), secondaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor secondaryFixedDim() {
        return new DynamicColor("secondary_fixed_dim", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 70.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m77x801c242f((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m77x801c242f(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(secondaryFixed(), secondaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor onSecondaryFixed() {
        return new DynamicColor("on_secondary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m59xf72fd9a3((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m60xd2f15564((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m59xf72fd9a3(DynamicScheme dynamicScheme) {
        return secondaryFixedDim();
    }

    DynamicColor m60xd2f15564(DynamicScheme dynamicScheme) {
        return secondaryFixed();
    }

    public DynamicColor onSecondaryFixedVariant() {
        return new DynamicColor("on_secondary_fixed_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).secondaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 25.0d : 30.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m61x26187114((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m62x8b913aa((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), null);
    }

    DynamicColor m61x26187114(DynamicScheme dynamicScheme) {
        return secondaryFixedDim();
    }

    DynamicColor m62x8b913aa(DynamicScheme dynamicScheme) {
        return secondaryFixed();
    }

    public DynamicColor tertiaryFixed() {
        return new DynamicColor("tertiary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 40.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m80x59237289((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m80x59237289(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(tertiaryFixed(), tertiaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor tertiaryFixedDim() {
        return new DynamicColor("tertiary_fixed_dim", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 30.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, true, new MaterialDynamicColors$$ExternalSyntheticLambda162(this), null, new ContrastCurve(1.0d, 1.0d, 3.0d, 7.0d), new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m81x24c02d4a((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    ToneDeltaPair m81x24c02d4a(DynamicScheme dynamicScheme) {
        return new ToneDeltaPair(tertiaryFixed(), tertiaryFixedDim(), 10.0d, TonePolarity.LIGHTER, true);
    }

    public DynamicColor onTertiaryFixed() {
        return new DynamicColor("on_tertiary_fixed", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 100.0d : 10.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m66xfe3fcbf0((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m67xe0e06e86((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(4.5d, 7.0d, 11.0d, 21.0d), null);
    }

    DynamicColor m66xfe3fcbf0(DynamicScheme dynamicScheme) {
        return tertiaryFixedDim();
    }

    DynamicColor m67xe0e06e86(DynamicScheme dynamicScheme) {
        return tertiaryFixed();
    }

    public DynamicColor onTertiaryFixedVariant() {
        return new DynamicColor("on_tertiary_fixed_variant", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).tertiaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(MaterialDynamicColors.isMonochrome((DynamicScheme) obj) ? 90.0d : 30.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m68x702fc122((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return this.f$0.m69x4bf13ce3((DynamicScheme) obj);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new ContrastCurve(3.0d, 4.5d, 7.0d, 11.0d), null);
    }

    DynamicColor m68x702fc122(DynamicScheme dynamicScheme) {
        return tertiaryFixedDim();
    }

    DynamicColor m69x4bf13ce3(DynamicScheme dynamicScheme) {
        return tertiaryFixed();
    }

    public DynamicColor controlActivated() {
        return DynamicColor.fromPalette("control_activated", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).primaryPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 30.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor controlNormal() {
        return DynamicColor.fromPalette("control_normal", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 80.0d : 30.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor controlHighlight() {
        return new DynamicColor("control_highlight", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 100.0d : 0.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, false, null, null, null, null, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 0.2d : 0.12d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor textPrimaryInverse() {
        return DynamicColor.fromPalette("text_primary_inverse", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 10.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor textSecondaryAndTertiaryInverse() {
        return DynamicColor.fromPalette("text_secondary_and_tertiary_inverse", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralVariantPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 30.0d : 80.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor textPrimaryInverseDisableOnly() {
        return DynamicColor.fromPalette("text_primary_inverse_disable_only", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 10.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor textSecondaryAndTertiaryInverseDisabled() {
        return DynamicColor.fromPalette("text_secondary_and_tertiary_inverse_disabled", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 10.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    public DynamicColor textHintInverse() {
        return DynamicColor.fromPalette("text_hint_inverse", new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return ((DynamicScheme) obj).neutralPalette;
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        }, new Function() {
            @Override
            public Function andThen(Function function) {
                return j$.util.function.Function.-CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj) {
                return Double.valueOf(((DynamicScheme) obj).isDark ? 10.0d : 90.0d);
            }

            @Override
            public Function compose(Function function) {
                return j$.util.function.Function.-CC.$default$compose(this, function);
            }
        });
    }

    private static ViewingConditions viewingConditionsForAlbers(DynamicScheme dynamicScheme) {
        return ViewingConditions.defaultWithBackgroundLstar(dynamicScheme.isDark ? 30.0d : 80.0d);
    }

    private static boolean isFidelity(DynamicScheme dynamicScheme) {
        return dynamicScheme.variant == Variant.FIDELITY || dynamicScheme.variant == Variant.CONTENT;
    }

    private static boolean isMonochrome(DynamicScheme dynamicScheme) {
        return dynamicScheme.variant == Variant.MONOCHROME;
    }

    static double findDesiredChromaByTone(double d, double d2, double d3, boolean z) {
        Hct hctFrom = Hct.from(d, d2, d3);
        if (hctFrom.getChroma() >= d2) {
            return d3;
        }
        double chroma = hctFrom.getChroma();
        Hct hct = hctFrom;
        double d4 = d3;
        while (hct.getChroma() < d2) {
            d4 += z ? -1.0d : 1.0d;
            Hct hctFrom2 = Hct.from(d, d2, d4);
            if (chroma > hctFrom2.getChroma() || Math.abs(hctFrom2.getChroma() - d2) < 0.4d) {
                return d4;
            }
            if (Math.abs(hctFrom2.getChroma() - d2) < Math.abs(hct.getChroma() - d2)) {
                hct = hctFrom2;
            }
            chroma = Math.max(chroma, hctFrom2.getChroma());
        }
        return d4;
    }

    static double performAlbers(Hct hct, DynamicScheme dynamicScheme) {
        Hct hctInViewingConditions = hct.inViewingConditions(viewingConditionsForAlbers(dynamicScheme));
        if (DynamicColor.tonePrefersLightForeground(hct.getTone()) && !DynamicColor.toneAllowsLightForeground(hctInViewingConditions.getTone())) {
            return DynamicColor.enableLightForeground(hct.getTone());
        }
        return DynamicColor.enableLightForeground(hctInViewingConditions.getTone());
    }
}
