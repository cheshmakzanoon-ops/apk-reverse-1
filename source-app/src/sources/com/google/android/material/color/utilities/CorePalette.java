package com.google.android.material.color.utilities;

public final class CorePalette {

    public TonalPalette f38a1;

    public TonalPalette f39a2;

    public TonalPalette f40a3;
    public TonalPalette error;

    public TonalPalette f41n1;

    public TonalPalette f42n2;

    public static CorePalette m41of(int i) {
        return new CorePalette(i, false);
    }

    public static CorePalette contentOf(int i) {
        return new CorePalette(i, true);
    }

    private CorePalette(int i, boolean z) {
        Hct hctFromInt = Hct.fromInt(i);
        double hue = hctFromInt.getHue();
        double chroma = hctFromInt.getChroma();
        if (z) {
            this.f38a1 = TonalPalette.fromHueAndChroma(hue, chroma);
            this.f39a2 = TonalPalette.fromHueAndChroma(hue, chroma / 3.0d);
            this.f40a3 = TonalPalette.fromHueAndChroma(60.0d + hue, chroma / 2.0d);
            this.f41n1 = TonalPalette.fromHueAndChroma(hue, Math.min(chroma / 12.0d, 4.0d));
            this.f42n2 = TonalPalette.fromHueAndChroma(hue, Math.min(chroma / 6.0d, 8.0d));
        } else {
            this.f38a1 = TonalPalette.fromHueAndChroma(hue, Math.max(48.0d, chroma));
            this.f39a2 = TonalPalette.fromHueAndChroma(hue, 16.0d);
            this.f40a3 = TonalPalette.fromHueAndChroma(60.0d + hue, 24.0d);
            this.f41n1 = TonalPalette.fromHueAndChroma(hue, 4.0d);
            this.f42n2 = TonalPalette.fromHueAndChroma(hue, 8.0d);
        }
        this.error = TonalPalette.fromHueAndChroma(25.0d, 84.0d);
    }
}
