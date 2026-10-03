package androidx.compose.material3;

import androidx.compose.foundation.BorderStroke;
import androidx.compose.foundation.BorderStrokeKt;
import androidx.compose.material3.tokens.FilledIconButtonTokens;
import androidx.compose.material3.tokens.FilledTonalIconButtonTokens;
import androidx.compose.material3.tokens.IconButtonTokens;
import androidx.compose.material3.tokens.OutlinedIconButtonTokens;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0014\bÇ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\u0016\u001a\u00020\nH\u0007¢\u0006\u0002\u0010\u0017J:\u0010\u0016\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u001eJ\r\u0010\u001f\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010 JN\u0010\u001f\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u00192\b\b\u0002\u0010!\u001a\u00020\u00192\b\b\u0002\u0010\"\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b#\u0010$J\r\u0010%\u001a\u00020\nH\u0007¢\u0006\u0002\u0010\u0017J:\u0010%\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b&\u0010\u001eJ\r\u0010'\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010 JN\u0010'\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u00192\b\b\u0002\u0010!\u001a\u00020\u00192\b\b\u0002\u0010\"\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b(\u0010$J\r\u0010)\u001a\u00020\nH\u0007¢\u0006\u0002\u0010\u0017J:\u0010)\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b*\u0010\u001eJ\r\u0010+\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010 JN\u0010+\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u00192\b\b\u0002\u0010!\u001a\u00020\u00192\b\b\u0002\u0010\"\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b,\u0010$J\u0015\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u000200H\u0007¢\u0006\u0002\u00101J\r\u00102\u001a\u00020\nH\u0007¢\u0006\u0002\u0010\u0017J:\u00102\u001a\u00020\n2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b3\u0010\u001eJ\u001f\u00104\u001a\u0004\u0018\u00010.2\u0006\u0010/\u001a\u0002002\u0006\u00105\u001a\u000200H\u0007¢\u0006\u0002\u00106J\r\u00107\u001a\u00020\u000fH\u0007¢\u0006\u0002\u0010 JN\u00107\u001a\u00020\u000f2\b\b\u0002\u0010\u0018\u001a\u00020\u00192\b\b\u0002\u0010\u001a\u001a\u00020\u00192\b\b\u0002\u0010\u001b\u001a\u00020\u00192\b\b\u0002\u0010\u001c\u001a\u00020\u00192\b\b\u0002\u0010!\u001a\u00020\u00192\b\b\u0002\u0010\"\u001a\u00020\u0019H\u0007ø\u0001\u0000¢\u0006\u0004\b8\u0010$J\u001e\u00109\u001a\u00020\n*\u00020\u000b2\u0006\u0010:\u001a\u00020\u0019H\u0000ø\u0001\u0000¢\u0006\u0004\b;\u0010<J\u001e\u0010=\u001a\u00020\u000f*\u00020\u000b2\u0006\u0010:\u001a\u00020\u0019H\u0000ø\u0001\u0000¢\u0006\u0004\b>\u0010?J\u001e\u0010@\u001a\u00020\n*\u00020\u000b2\u0006\u0010:\u001a\u00020\u0019H\u0000ø\u0001\u0000¢\u0006\u0004\bA\u0010<J\u001e\u0010B\u001a\u00020\u000f*\u00020\u000b2\u0006\u0010:\u001a\u00020\u0019H\u0000ø\u0001\u0000¢\u0006\u0004\bC\u0010?R\u0011\u0010\u0003\u001a\u00020\u00048G¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\u00048G¢\u0006\u0006\u001a\u0004\b\b\u0010\u0006R\u0018\u0010\t\u001a\u00020\n*\u00020\u000b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0018\u0010\u000e\u001a\u00020\u000f*\u00020\u000b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u0011R\u0018\u0010\u0012\u001a\u00020\n*\u00020\u000b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0013\u0010\rR\u0018\u0010\u0014\u001a\u00020\u000f*\u00020\u000b8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0011\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006D"}, d2 = {"Landroidx/compose/material3/IconButtonDefaults;", "", "()V", "filledShape", "Landroidx/compose/ui/graphics/Shape;", "getFilledShape", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/graphics/Shape;", "outlinedShape", "getOutlinedShape", "defaultFilledIconButtonColors", "Landroidx/compose/material3/IconButtonColors;", "Landroidx/compose/material3/ColorScheme;", "getDefaultFilledIconButtonColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/IconButtonColors;", "defaultFilledIconToggleButtonColors", "Landroidx/compose/material3/IconToggleButtonColors;", "getDefaultFilledIconToggleButtonColors$material3_release", "(Landroidx/compose/material3/ColorScheme;)Landroidx/compose/material3/IconToggleButtonColors;", "defaultFilledTonalIconButtonColors", "getDefaultFilledTonalIconButtonColors$material3_release", "defaultFilledTonalIconToggleButtonColors", "getDefaultFilledTonalIconToggleButtonColors$material3_release", "filledIconButtonColors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/IconButtonColors;", "containerColor", "Landroidx/compose/ui/graphics/Color;", "contentColor", "disabledContainerColor", "disabledContentColor", "filledIconButtonColors-ro_MJ88", "(JJJJLandroidx/compose/runtime/Composer;II)Landroidx/compose/material3/IconButtonColors;", "filledIconToggleButtonColors", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/material3/IconToggleButtonColors;", "checkedContainerColor", "checkedContentColor", "filledIconToggleButtonColors-5tl4gsc", "(JJJJJJLandroidx/compose/runtime/Composer;II)Landroidx/compose/material3/IconToggleButtonColors;", "filledTonalIconButtonColors", "filledTonalIconButtonColors-ro_MJ88", "filledTonalIconToggleButtonColors", "filledTonalIconToggleButtonColors-5tl4gsc", "iconButtonColors", "iconButtonColors-ro_MJ88", "iconToggleButtonColors", "iconToggleButtonColors-5tl4gsc", "outlinedIconButtonBorder", "Landroidx/compose/foundation/BorderStroke;", "enabled", "", "(ZLandroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/BorderStroke;", "outlinedIconButtonColors", "outlinedIconButtonColors-ro_MJ88", "outlinedIconToggleButtonBorder", "checked", "(ZZLandroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/BorderStroke;", "outlinedIconToggleButtonColors", "outlinedIconToggleButtonColors-5tl4gsc", "defaultIconButtonColors", "localContentColor", "defaultIconButtonColors-4WTKRHQ$material3_release", "(Landroidx/compose/material3/ColorScheme;J)Landroidx/compose/material3/IconButtonColors;", "defaultIconToggleButtonColors", "defaultIconToggleButtonColors-4WTKRHQ$material3_release", "(Landroidx/compose/material3/ColorScheme;J)Landroidx/compose/material3/IconToggleButtonColors;", "defaultOutlinedIconButtonColors", "defaultOutlinedIconButtonColors-4WTKRHQ$material3_release", "defaultOutlinedIconToggleButtonColors", "defaultOutlinedIconToggleButtonColors-4WTKRHQ$material3_release", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class IconButtonDefaults {
    public static final int $stable = 0;
    public static final IconButtonDefaults INSTANCE = new IconButtonDefaults();

    private IconButtonDefaults() {
    }

    public final Shape getFilledShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1265841879, "C584@27553L5:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1265841879, i, -1, "androidx.compose.material3.IconButtonDefaults.<get-filledShape> (IconButton.kt:584)");
        }
        Shape value = ShapesKt.getValue(FilledIconButtonTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final Shape getOutlinedShape(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1327125527, "C588@27711L5:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1327125527, i, -1, "androidx.compose.material3.IconButtonDefaults.<get-outlinedShape> (IconButton.kt:588)");
        }
        Shape value = ShapesKt.getValue(OutlinedIconButtonTokens.INSTANCE.getContainerShape(), composer, 6);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return value;
    }

    public final IconButtonColors iconButtonColors(Composer composer, int i) {
        composer.startReplaceGroup(-1519621781);
        ComposerKt.sourceInformation(composer, "C(iconButtonColors)593@27925L7,594@27968L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1519621781, i, -1, "androidx.compose.material3.IconButtonDefaults.iconButtonColors (IconButton.kt:592)");
        }
        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContentColor);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        IconButtonColors iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release = m2419defaultIconButtonColors4WTKRHQ$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6), jM4600unboximpl);
        if (Color.m4591equalsimpl0(iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.getContentColor(), jM4600unboximpl)) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release;
        }
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.m2414copyjRlVdoo((5 & 1) != 0 ? iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.containerColor : 0L, (5 & 2) != 0 ? iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.contentColor : jM4600unboximpl, (5 & 4) != 0 ? iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.disabledContainerColor : 0L, (5 & 8) != 0 ? iconButtonColorsM2419defaultIconButtonColors4WTKRHQ$material3_release.disabledContentColor : Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors m2427iconButtonColorsro_MJ88(long j, long j2, long j3, long j4, Composer composer, int i, int i2) {
        long jM4600unboximpl;
        ComposerKt.sourceInformationMarkerStart(composer, 999008085, "C(iconButtonColors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color)617@28950L7,622@29180L11,623@29247L7:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        if ((i2 & 2) != 0) {
            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localContentColor);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        } else {
            jM4600unboximpl = j2;
        }
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4589copywmQWz5c$default = (i2 & 8) != 0 ? Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null) : j4;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(999008085, i, -1, "androidx.compose.material3.IconButtonDefaults.iconButtonColors (IconButton.kt:622)");
        }
        ColorScheme colorScheme = MaterialTheme.INSTANCE.getColorScheme(composer, 6);
        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localContentColor2);
        ComposerKt.sourceInformationMarkerEnd(composer);
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = m2419defaultIconButtonColors4WTKRHQ$material3_release(colorScheme, ((Color) objConsume2).m4600unboximpl()).m2414copyjRlVdoo(jM4626getUnspecified0d7_KjU, jM4600unboximpl, jM4626getUnspecified0d7_KjU2, jM4589copywmQWz5c$default);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors m2419defaultIconButtonColors4WTKRHQ$material3_release(ColorScheme colorScheme, long j) {
        IconButtonColors defaultIconButtonColorsCached = colorScheme.getDefaultIconButtonColorsCached();
        if (defaultIconButtonColorsCached != null) {
            return defaultIconButtonColorsCached;
        }
        IconButtonColors iconButtonColors = new IconButtonColors(Color.INSTANCE.m4625getTransparent0d7_KjU(), j, Color.INSTANCE.m4625getTransparent0d7_KjU(), Color.m4589copywmQWz5c$default(j, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.setDefaultIconButtonColorsCached$material3_release(iconButtonColors);
        return iconButtonColors;
    }

    public final IconToggleButtonColors iconToggleButtonColors(Composer composer, int i) {
        composer.startReplaceGroup(-589987581);
        ComposerKt.sourceInformation(composer, "C(iconToggleButtonColors)651@30397L7,652@30440L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-589987581, i, -1, "androidx.compose.material3.IconButtonDefaults.iconToggleButtonColors (IconButton.kt:650)");
        }
        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContentColor);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        IconToggleButtonColors iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release = m2420defaultIconToggleButtonColors4WTKRHQ$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6), jM4600unboximpl);
        if (Color.m4591equalsimpl0(iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.getContentColor(), jM4600unboximpl)) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release;
        }
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.m2437copytNS2XkQ((53 & 1) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.containerColor : 0L, (53 & 2) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.contentColor : jM4600unboximpl, (53 & 4) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.disabledContainerColor : 0L, (53 & 8) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.disabledContentColor : Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), (53 & 16) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.checkedContainerColor : 0L, (53 & 32) != 0 ? iconToggleButtonColorsM2420defaultIconToggleButtonColors4WTKRHQ$material3_release.checkedContentColor : 0L);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors m2428iconToggleButtonColors5tl4gsc(long j, long j2, long j3, long j4, long j5, long j6, Composer composer, int i, int i2) {
        long jM4600unboximpl;
        ComposerKt.sourceInformationMarkerStart(composer, -2020719549, "C(iconToggleButtonColors)P(2:c#ui.graphics.Color,3:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color)678@31629L7,685@31979L11,686@32052L7:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        if ((i2 & 2) != 0) {
            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localContentColor);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        } else {
            jM4600unboximpl = j2;
        }
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4589copywmQWz5c$default = (i2 & 8) != 0 ? Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null) : j4;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM4626getUnspecified0d7_KjU4 = (i2 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2020719549, i, -1, "androidx.compose.material3.IconButtonDefaults.iconToggleButtonColors (IconButton.kt:685)");
        }
        ColorScheme colorScheme = MaterialTheme.INSTANCE.getColorScheme(composer, 6);
        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localContentColor2);
        ComposerKt.sourceInformationMarkerEnd(composer);
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = m2420defaultIconToggleButtonColors4WTKRHQ$material3_release(colorScheme, ((Color) objConsume2).m4600unboximpl()).m2437copytNS2XkQ(jM4626getUnspecified0d7_KjU, jM4600unboximpl, jM4626getUnspecified0d7_KjU2, jM4589copywmQWz5c$default, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors m2420defaultIconToggleButtonColors4WTKRHQ$material3_release(ColorScheme colorScheme, long j) {
        IconToggleButtonColors defaultIconToggleButtonColorsCached = colorScheme.getDefaultIconToggleButtonColorsCached();
        if (defaultIconToggleButtonColorsCached != null) {
            return defaultIconToggleButtonColorsCached;
        }
        IconToggleButtonColors iconToggleButtonColors = new IconToggleButtonColors(Color.INSTANCE.m4625getTransparent0d7_KjU(), j, Color.INSTANCE.m4625getTransparent0d7_KjU(), Color.m4589copywmQWz5c$default(j, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), Color.INSTANCE.m4625getTransparent0d7_KjU(), ColorSchemeKt.fromToken(colorScheme, IconButtonTokens.INSTANCE.getSelectedIconColor()), null);
        colorScheme.setDefaultIconToggleButtonColorsCached$material3_release(iconToggleButtonColors);
        return iconToggleButtonColors;
    }

    public final IconButtonColors filledIconButtonColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1857395287, "C(filledIconButtonColors)719@33486L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1857395287, i, -1, "androidx.compose.material3.IconButtonDefaults.filledIconButtonColors (IconButton.kt:719)");
        }
        IconButtonColors defaultFilledIconButtonColors$material3_release = getDefaultFilledIconButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultFilledIconButtonColors$material3_release;
    }

    public final IconButtonColors m2423filledIconButtonColorsro_MJ88(long j, long j2, long j3, long j4, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -669858473, "C(filledIconButtonColors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color)732@34130L31,736@34326L11:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM2173contentColorForek8zF_U = (i2 & 2) != 0 ? ColorSchemeKt.m2173contentColorForek8zF_U(jM4626getUnspecified0d7_KjU, composer, i & 14) : j2;
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-669858473, i, -1, "androidx.compose.material3.IconButtonDefaults.filledIconButtonColors (IconButton.kt:736)");
        }
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = getDefaultFilledIconButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2414copyjRlVdoo(jM4626getUnspecified0d7_KjU, jM2173contentColorForek8zF_U, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors getDefaultFilledIconButtonColors$material3_release(ColorScheme colorScheme) {
        IconButtonColors defaultFilledIconButtonColorsCached = colorScheme.getDefaultFilledIconButtonColorsCached();
        if (defaultFilledIconButtonColorsCached != null) {
            return defaultFilledIconButtonColorsCached;
        }
        IconButtonColors iconButtonColors = new IconButtonColors(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getContainerColor()), ColorSchemeKt.m2172contentColorFor4WTKRHQ(colorScheme, ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getContainerColor())), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getDisabledContainerColor()), FilledIconButtonTokens.INSTANCE.getDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getDisabledColor()), FilledIconButtonTokens.INSTANCE.getDisabledOpacity(), 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.setDefaultFilledIconButtonColorsCached$material3_release(iconButtonColors);
        return iconButtonColors;
    }

    public final IconToggleButtonColors filledIconToggleButtonColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1554706367, "C(filledIconToggleButtonColors)766@35781L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1554706367, i, -1, "androidx.compose.material3.IconButtonDefaults.filledIconToggleButtonColors (IconButton.kt:766)");
        }
        IconToggleButtonColors defaultFilledIconToggleButtonColors$material3_release = getDefaultFilledIconToggleButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultFilledIconToggleButtonColors$material3_release;
    }

    public final IconToggleButtonColors m2424filledIconToggleButtonColors5tl4gsc(long j, long j2, long j3, long j4, long j5, long j6, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 1887173701, "C(filledIconToggleButtonColors)P(2:c#ui.graphics.Color,3:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color)788@36995L38,790@37088L11:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM4626getUnspecified0d7_KjU2 = (i2 & 2) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j2;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU4 = (i2 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        long jM4626getUnspecified0d7_KjU5 = (i2 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM2173contentColorForek8zF_U = (i2 & 32) != 0 ? ColorSchemeKt.m2173contentColorForek8zF_U(jM4626getUnspecified0d7_KjU5, composer, (i >> 12) & 14) : j6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1887173701, i, -1, "androidx.compose.material3.IconButtonDefaults.filledIconToggleButtonColors (IconButton.kt:790)");
        }
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = getDefaultFilledIconToggleButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2437copytNS2XkQ(jM4626getUnspecified0d7_KjU, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5, jM2173contentColorForek8zF_U);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors getDefaultFilledIconToggleButtonColors$material3_release(ColorScheme colorScheme) {
        IconToggleButtonColors defaultFilledIconToggleButtonColorsCached = colorScheme.getDefaultFilledIconToggleButtonColorsCached();
        if (defaultFilledIconToggleButtonColorsCached != null) {
            return defaultFilledIconToggleButtonColorsCached;
        }
        IconToggleButtonColors iconToggleButtonColors = new IconToggleButtonColors(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getUnselectedContainerColor()), ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getToggleUnselectedColor()), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getDisabledContainerColor()), FilledIconButtonTokens.INSTANCE.getDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getDisabledColor()), FilledIconButtonTokens.INSTANCE.getDisabledOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getSelectedContainerColor()), ColorSchemeKt.m2172contentColorFor4WTKRHQ(colorScheme, ColorSchemeKt.fromToken(colorScheme, FilledIconButtonTokens.INSTANCE.getSelectedContainerColor())), null);
        colorScheme.setDefaultFilledIconToggleButtonColorsCached$material3_release(iconToggleButtonColors);
        return iconToggleButtonColors;
    }

    public final IconButtonColors filledTonalIconButtonColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1099140437, "C(filledTonalIconButtonColors)830@39188L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1099140437, i, -1, "androidx.compose.material3.IconButtonDefaults.filledTonalIconButtonColors (IconButton.kt:830)");
        }
        IconButtonColors defaultFilledTonalIconButtonColors$material3_release = getDefaultFilledTonalIconButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultFilledTonalIconButtonColors$material3_release;
    }

    public final IconButtonColors m2425filledTonalIconButtonColorsro_MJ88(long j, long j2, long j3, long j4, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -18532843, "C(filledTonalIconButtonColors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color)844@39854L31,848@40050L11:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM2173contentColorForek8zF_U = (i2 & 2) != 0 ? ColorSchemeKt.m2173contentColorForek8zF_U(jM4626getUnspecified0d7_KjU, composer, i & 14) : j2;
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-18532843, i, -1, "androidx.compose.material3.IconButtonDefaults.filledTonalIconButtonColors (IconButton.kt:848)");
        }
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = getDefaultFilledTonalIconButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2414copyjRlVdoo(jM4626getUnspecified0d7_KjU, jM2173contentColorForek8zF_U, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors getDefaultFilledTonalIconButtonColors$material3_release(ColorScheme colorScheme) {
        IconButtonColors defaultFilledTonalIconButtonColorsCached = colorScheme.getDefaultFilledTonalIconButtonColorsCached();
        if (defaultFilledTonalIconButtonColorsCached != null) {
            return defaultFilledTonalIconButtonColorsCached;
        }
        IconButtonColors iconButtonColors = new IconButtonColors(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getContainerColor()), ColorSchemeKt.m2172contentColorFor4WTKRHQ(colorScheme, ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getContainerColor())), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getDisabledContainerColor()), FilledTonalIconButtonTokens.INSTANCE.getDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getDisabledColor()), FilledTonalIconButtonTokens.INSTANCE.getDisabledOpacity(), 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.setDefaultFilledTonalIconButtonColorsCached$material3_release(iconButtonColors);
        return iconButtonColors;
    }

    public final IconToggleButtonColors filledTonalIconToggleButtonColors(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 434219587, "C(filledTonalIconToggleButtonColors)878@41565L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(434219587, i, -1, "androidx.compose.material3.IconButtonDefaults.filledTonalIconToggleButtonColors (IconButton.kt:878)");
        }
        IconToggleButtonColors defaultFilledTonalIconToggleButtonColors$material3_release = getDefaultFilledTonalIconToggleButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return defaultFilledTonalIconToggleButtonColors$material3_release;
    }

    public final IconToggleButtonColors m2426filledTonalIconToggleButtonColors5tl4gsc(long j, long j2, long j3, long j4, long j5, long j6, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -19426557, "C(filledTonalIconToggleButtonColors)P(2:c#ui.graphics.Color,3:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color)894@42431L31,900@42747L11:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        long jM2173contentColorForek8zF_U = (i2 & 2) != 0 ? ColorSchemeKt.m2173contentColorForek8zF_U(jM4626getUnspecified0d7_KjU, composer, i & 14) : j2;
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 8) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j4;
        long jM4626getUnspecified0d7_KjU4 = (i2 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM4626getUnspecified0d7_KjU5 = (i2 & 32) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-19426557, i, -1, "androidx.compose.material3.IconButtonDefaults.filledTonalIconToggleButtonColors (IconButton.kt:900)");
        }
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = getDefaultFilledTonalIconToggleButtonColors$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6)).m2437copytNS2XkQ(jM4626getUnspecified0d7_KjU, jM2173contentColorForek8zF_U, jM4626getUnspecified0d7_KjU2, jM4626getUnspecified0d7_KjU3, jM4626getUnspecified0d7_KjU4, jM4626getUnspecified0d7_KjU5);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors getDefaultFilledTonalIconToggleButtonColors$material3_release(ColorScheme colorScheme) {
        IconToggleButtonColors defaultFilledTonalIconToggleButtonColorsCached = colorScheme.getDefaultFilledTonalIconToggleButtonColorsCached();
        if (defaultFilledTonalIconToggleButtonColorsCached != null) {
            return defaultFilledTonalIconToggleButtonColorsCached;
        }
        IconToggleButtonColors iconToggleButtonColors = new IconToggleButtonColors(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getUnselectedContainerColor()), ColorSchemeKt.m2172contentColorFor4WTKRHQ(colorScheme, ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getUnselectedContainerColor())), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getDisabledContainerColor()), FilledTonalIconButtonTokens.INSTANCE.getDisabledContainerOpacity(), 0.0f, 0.0f, 0.0f, 14, null), Color.m4589copywmQWz5c$default(ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getDisabledColor()), FilledTonalIconButtonTokens.INSTANCE.getDisabledOpacity(), 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getSelectedContainerColor()), ColorSchemeKt.fromToken(colorScheme, FilledTonalIconButtonTokens.INSTANCE.getToggleSelectedColor()), null);
        colorScheme.m90xa626b4be(iconToggleButtonColors);
        return iconToggleButtonColors;
    }

    public final IconButtonColors outlinedIconButtonColors(Composer composer, int i) {
        composer.startReplaceGroup(389287465);
        ComposerKt.sourceInformation(composer, "C(outlinedIconButtonColors)940@44790L11,940@44852L7,941@44906L7:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(389287465, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconButtonColors (IconButton.kt:938)");
        }
        ColorScheme colorScheme = MaterialTheme.INSTANCE.getColorScheme(composer, 6);
        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContentColor);
        ComposerKt.sourceInformationMarkerEnd(composer);
        IconButtonColors iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release = m2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release(colorScheme, ((Color) objConsume).m4600unboximpl());
        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localContentColor2);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM4600unboximpl = ((Color) objConsume2).m4600unboximpl();
        if (Color.m4591equalsimpl0(iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.getContentColor(), jM4600unboximpl)) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release;
        }
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.m2414copyjRlVdoo((5 & 1) != 0 ? iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.containerColor : 0L, (5 & 2) != 0 ? iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.contentColor : jM4600unboximpl, (5 & 4) != 0 ? iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.disabledContainerColor : 0L, (5 & 8) != 0 ? iconButtonColorsM2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release.disabledContentColor : Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors m2429outlinedIconButtonColorsro_MJ88(long j, long j2, long j3, long j4, Composer composer, int i, int i2) {
        long jM4600unboximpl;
        ComposerKt.sourceInformationMarkerStart(composer, -1030517545, "C(outlinedIconButtonColors)P(0:c#ui.graphics.Color,1:c#ui.graphics.Color,2:c#ui.graphics.Color,3:c#ui.graphics.Color)965@45873L7,970@46107L11,971@46182L7:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        if ((i2 & 2) != 0) {
            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localContentColor);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        } else {
            jM4600unboximpl = j2;
        }
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4589copywmQWz5c$default = (i2 & 8) != 0 ? Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null) : j4;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1030517545, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconButtonColors (IconButton.kt:970)");
        }
        ColorScheme colorScheme = MaterialTheme.INSTANCE.getColorScheme(composer, 6);
        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localContentColor2);
        ComposerKt.sourceInformationMarkerEnd(composer);
        IconButtonColors iconButtonColorsM2414copyjRlVdoo = m2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release(colorScheme, ((Color) objConsume2).m4600unboximpl()).m2414copyjRlVdoo(jM4626getUnspecified0d7_KjU, jM4600unboximpl, jM4626getUnspecified0d7_KjU2, jM4589copywmQWz5c$default);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconButtonColorsM2414copyjRlVdoo;
    }

    public final IconButtonColors m2421defaultOutlinedIconButtonColors4WTKRHQ$material3_release(ColorScheme colorScheme, long j) {
        IconButtonColors defaultOutlinedIconButtonColorsCached = colorScheme.getDefaultOutlinedIconButtonColorsCached();
        if (defaultOutlinedIconButtonColorsCached != null) {
            return defaultOutlinedIconButtonColorsCached;
        }
        IconButtonColors iconButtonColors = new IconButtonColors(Color.INSTANCE.m4625getTransparent0d7_KjU(), j, Color.INSTANCE.m4625getTransparent0d7_KjU(), Color.m4589copywmQWz5c$default(j, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), null);
        colorScheme.setDefaultOutlinedIconButtonColorsCached$material3_release(iconButtonColors);
        return iconButtonColors;
    }

    public final IconToggleButtonColors outlinedIconToggleButtonColors(Composer composer, int i) {
        composer.startReplaceGroup(-779749183);
        ComposerKt.sourceInformation(composer, "C(outlinedIconToggleButtonColors)1001@47390L7,1002@47433L11:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-779749183, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconToggleButtonColors (IconButton.kt:1000)");
        }
        ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localContentColor);
        ComposerKt.sourceInformationMarkerEnd(composer);
        long jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        IconToggleButtonColors iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release = m2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release(MaterialTheme.INSTANCE.getColorScheme(composer, 6), jM4600unboximpl);
        if (Color.m4591equalsimpl0(iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.getContentColor(), jM4600unboximpl)) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release;
        }
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.m2437copytNS2XkQ((53 & 1) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.containerColor : 0L, (53 & 2) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.contentColor : jM4600unboximpl, (53 & 4) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.disabledContainerColor : 0L, (53 & 8) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.disabledContentColor : Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), (53 & 16) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.checkedContainerColor : 0L, (53 & 32) != 0 ? iconToggleButtonColorsM2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release.checkedContentColor : 0L);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors m2430outlinedIconToggleButtonColors5tl4gsc(long j, long j2, long j3, long j4, long j5, long j6, Composer composer, int i, int i2) {
        long jM4600unboximpl;
        ComposerKt.sourceInformationMarkerStart(composer, 2130592709, "C(outlinedIconToggleButtonColors)P(2:c#ui.graphics.Color,3:c#ui.graphics.Color,4:c#ui.graphics.Color,5:c#ui.graphics.Color,0:c#ui.graphics.Color,1:c#ui.graphics.Color)1028@48650L7,1033@48932L38,1035@49025L11,1036@49106L7:IconButton.kt#uh7d8r");
        long jM4626getUnspecified0d7_KjU = (i2 & 1) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j;
        if ((i2 & 2) != 0) {
            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localContentColor);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4600unboximpl = ((Color) objConsume).m4600unboximpl();
        } else {
            jM4600unboximpl = j2;
        }
        long jM4626getUnspecified0d7_KjU2 = (i2 & 4) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j3;
        long jM4589copywmQWz5c$default = (i2 & 8) != 0 ? Color.m4589copywmQWz5c$default(jM4600unboximpl, 0.38f, 0.0f, 0.0f, 0.0f, 14, null) : j4;
        long jM4626getUnspecified0d7_KjU3 = (i2 & 16) != 0 ? Color.INSTANCE.m4626getUnspecified0d7_KjU() : j5;
        long jM2173contentColorForek8zF_U = (i2 & 32) != 0 ? ColorSchemeKt.m2173contentColorForek8zF_U(jM4626getUnspecified0d7_KjU3, composer, (i >> 12) & 14) : j6;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(2130592709, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconToggleButtonColors (IconButton.kt:1035)");
        }
        ColorScheme colorScheme = MaterialTheme.INSTANCE.getColorScheme(composer, 6);
        ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume2 = composer.consume(localContentColor2);
        ComposerKt.sourceInformationMarkerEnd(composer);
        IconToggleButtonColors iconToggleButtonColorsM2437copytNS2XkQ = m2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release(colorScheme, ((Color) objConsume2).m4600unboximpl()).m2437copytNS2XkQ(jM4626getUnspecified0d7_KjU, jM4600unboximpl, jM4626getUnspecified0d7_KjU2, jM4589copywmQWz5c$default, jM4626getUnspecified0d7_KjU3, jM2173contentColorForek8zF_U);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return iconToggleButtonColorsM2437copytNS2XkQ;
    }

    public final IconToggleButtonColors m2422defaultOutlinedIconToggleButtonColors4WTKRHQ$material3_release(ColorScheme colorScheme, long j) {
        IconToggleButtonColors defaultIconToggleButtonColorsCached = colorScheme.getDefaultIconToggleButtonColorsCached();
        if (defaultIconToggleButtonColorsCached != null) {
            return defaultIconToggleButtonColorsCached;
        }
        IconToggleButtonColors iconToggleButtonColors = new IconToggleButtonColors(Color.INSTANCE.m4625getTransparent0d7_KjU(), j, Color.INSTANCE.m4625getTransparent0d7_KjU(), Color.m4589copywmQWz5c$default(j, 0.38f, 0.0f, 0.0f, 0.0f, 14, null), ColorSchemeKt.fromToken(colorScheme, OutlinedIconButtonTokens.INSTANCE.getSelectedContainerColor()), ColorSchemeKt.m2172contentColorFor4WTKRHQ(colorScheme, ColorSchemeKt.fromToken(colorScheme, OutlinedIconButtonTokens.INSTANCE.getSelectedContainerColor())), null);
        colorScheme.setDefaultOutlinedIconToggleButtonColorsCached$material3_release(iconToggleButtonColors);
        return iconToggleButtonColors;
    }

    public final BorderStroke outlinedIconToggleButtonBorder(boolean z, boolean z2, Composer composer, int i) {
        composer.startReplaceGroup(1244729690);
        ComposerKt.sourceInformation(composer, "C(outlinedIconToggleButtonBorder)P(1)1082@51041L33:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1244729690, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconToggleButtonBorder (IconButton.kt:1078)");
        }
        if (z2) {
            if (ComposerKt.isTraceInProgress()) {
                ComposerKt.traceEventEnd();
            }
            composer.endReplaceGroup();
            return null;
        }
        BorderStroke borderStrokeOutlinedIconButtonBorder = outlinedIconButtonBorder(z, composer, (i & 14) | ((i >> 3) & 112));
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return borderStrokeOutlinedIconButtonBorder;
    }

    public final BorderStroke outlinedIconButtonBorder(boolean z, Composer composer, int i) {
        long jM4589copywmQWz5c$default;
        ComposerKt.sourceInformationMarkerStart(composer, -511461558, "C(outlinedIconButtonBorder)1100@51643L108:IconButton.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-511461558, i, -1, "androidx.compose.material3.IconButtonDefaults.outlinedIconButtonBorder (IconButton.kt:1091)");
        }
        if (z) {
            composer.startReplaceGroup(1186104514);
            ComposerKt.sourceInformation(composer, "1094@51433L7");
            ProvidableCompositionLocal<Color> localContentColor = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume = composer.consume(localContentColor);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4589copywmQWz5c$default = ((Color) objConsume).m4600unboximpl();
            composer.endReplaceGroup();
        } else {
            composer.startReplaceGroup(1186170420);
            ComposerKt.sourceInformation(composer, "1096@51496L7");
            ProvidableCompositionLocal<Color> localContentColor2 = ContentColorKt.getLocalContentColor();
            ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
            Object objConsume2 = composer.consume(localContentColor2);
            ComposerKt.sourceInformationMarkerEnd(composer);
            jM4589copywmQWz5c$default = Color.m4589copywmQWz5c$default(((Color) objConsume2).m4600unboximpl(), 0.12f, 0.0f, 0.0f, 0.0f, 14, null);
            composer.endReplaceGroup();
        }
        ComposerKt.sourceInformationMarkerStart(composer, 176816691, "CC(remember):IconButton.kt#9igjgp");
        boolean zChanged = composer.changed(jM4589copywmQWz5c$default);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = BorderStrokeKt.m549BorderStrokecXLIe8U(OutlinedIconButtonTokens.INSTANCE.m3720getUnselectedOutlineWidthD9Ej5fM(), jM4589copywmQWz5c$default);
            composer.updateRememberedValue(objRememberedValue);
        }
        BorderStroke borderStroke = (BorderStroke) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return borderStroke;
    }
}
