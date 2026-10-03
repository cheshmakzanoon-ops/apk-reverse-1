package androidx.compose.material.ripple;

import androidx.compose.foundation.Indication;
import androidx.compose.foundation.IndicationInstance;
import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.p002ui.graphics.Color;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Dp;
import kotlin.Deprecated;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Deprecated(message = "Replaced by the new RippleNode implementation")
@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b!\u0018\u00002\u00020\u0001B#\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\u0002\u0010\tJ\u0013\u0010\u000b\u001a\u00020\u00032\b\u0010\f\u001a\u0004\u0018\u00010\rH\u0096\u0002J\b\u0010\u000e\u001a\u00020\u000fH\u0016J\u0015\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u0013H\u0007¢\u0006\u0002\u0010\u0014JF\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\f\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\u00180\u0007H'ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001aR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0004\u001a\u00020\u0005X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\n\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001b"}, d2 = {"Landroidx/compose/material/ripple/Ripple;", "Landroidx/compose/foundation/Indication;", "bounded", "", "radius", "Landroidx/compose/ui/unit/Dp;", "color", "Landroidx/compose/runtime/State;", "Landroidx/compose/ui/graphics/Color;", "(ZFLandroidx/compose/runtime/State;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "F", "equals", "other", "", "hashCode", "", "rememberUpdatedInstance", "Landroidx/compose/foundation/IndicationInstance;", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "(Landroidx/compose/foundation/interaction/InteractionSource;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/IndicationInstance;", "rememberUpdatedRippleInstance", "Landroidx/compose/material/ripple/RippleIndicationInstance;", "rippleAlpha", "Landroidx/compose/material/ripple/RippleAlpha;", "rememberUpdatedRippleInstance-942rkJo", "(Landroidx/compose/foundation/interaction/InteractionSource;ZFLandroidx/compose/runtime/State;Landroidx/compose/runtime/State;Landroidx/compose/runtime/Composer;I)Landroidx/compose/material/ripple/RippleIndicationInstance;", "material-ripple_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class Ripple implements Indication {
    public static final int $stable = 0;
    private final boolean bounded;
    private final State<Color> color;
    private final float radius;

    public Ripple(boolean z, float f, State state, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, f, state);
    }

    public abstract RippleIndicationInstance mo1964rememberUpdatedRippleInstance942rkJo(InteractionSource interactionSource, boolean z, float f, State<Color> state, State<RippleAlpha> state2, Composer composer, int i);

    private Ripple(boolean z, float f, State<Color> state) {
        this.bounded = z;
        this.radius = f;
        this.color = state;
    }

    @Override
    @Deprecated(message = "Super method is deprecated")
    public final IndicationInstance rememberUpdatedInstance(InteractionSource interactionSource, Composer composer, int i) {
        long jMo1966defaultColorWaAFU9c;
        composer.startReplaceGroup(988743187);
        ComposerKt.sourceInformation(composer, "C(rememberUpdatedInstance)197@9514L7,198@9542L221,207@9856L13,207@9829L41,209@9895L155,217@10104L491,217@10060L535:Ripple.kt#vhb33q");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(988743187, i, -1, "androidx.compose.material.ripple.Ripple.rememberUpdatedInstance (Ripple.kt:196)");
        }
        ProvidableCompositionLocal<RippleTheme> localRippleTheme = RippleThemeKt.getLocalRippleTheme();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localRippleTheme);
        ComposerKt.sourceInformationMarkerEnd(composer);
        RippleTheme rippleTheme = (RippleTheme) objConsume;
        if (this.color.getValue().m4600unboximpl() != 16) {
            composer.startReplaceGroup(-303571590);
            composer.endReplaceGroup();
            jMo1966defaultColorWaAFU9c = this.color.getValue().m4600unboximpl();
        } else {
            composer.startReplaceGroup(-303521246);
            ComposerKt.sourceInformation(composer, "203@9725L14");
            jMo1966defaultColorWaAFU9c = rippleTheme.mo1966defaultColorWaAFU9c(composer, 0);
            composer.endReplaceGroup();
        }
        State<Color> stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(Color.m4580boximpl(jMo1966defaultColorWaAFU9c), composer, 0);
        State<RippleAlpha> stateRememberUpdatedState2 = SnapshotStateKt.rememberUpdatedState(rippleTheme.rippleAlpha(composer, 0), composer, 0);
        int i2 = i & 14;
        RippleIndicationInstance rippleIndicationInstanceMo1964rememberUpdatedRippleInstance942rkJo = mo1964rememberUpdatedRippleInstance942rkJo(interactionSource, this.bounded, this.radius, stateRememberUpdatedState, stateRememberUpdatedState2, composer, i2 | ((i << 12) & 458752));
        ComposerKt.sourceInformationMarkerStart(composer, -9776216, "CC(remember):Ripple.kt#9igjgp");
        boolean zChangedInstance = composer.changedInstance(rippleIndicationInstanceMo1964rememberUpdatedRippleInstance942rkJo) | (((i2 ^ 6) > 4 && composer.changed(interactionSource)) || (i & 6) == 4);
        Ripple$rememberUpdatedInstance$1$1 ripple$rememberUpdatedInstance$1$1RememberedValue = composer.rememberedValue();
        if (zChangedInstance || ripple$rememberUpdatedInstance$1$1RememberedValue == Composer.INSTANCE.getEmpty()) {
            ripple$rememberUpdatedInstance$1$1RememberedValue = new Ripple$rememberUpdatedInstance$1$1(interactionSource, rippleIndicationInstanceMo1964rememberUpdatedRippleInstance942rkJo, null);
            composer.updateRememberedValue(ripple$rememberUpdatedInstance$1$1RememberedValue);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(rippleIndicationInstanceMo1964rememberUpdatedRippleInstance942rkJo, interactionSource, (Function2) ripple$rememberUpdatedInstance$1$1RememberedValue, composer, (i << 3) & 112);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceGroup();
        return rippleIndicationInstanceMo1964rememberUpdatedRippleInstance942rkJo;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Ripple)) {
            return false;
        }
        Ripple ripple = (Ripple) other;
        return this.bounded == ripple.bounded && Dp.equals-impl0(this.radius, ripple.radius) && Intrinsics.areEqual(this.color, ripple.color);
    }

    public int hashCode() {
        return (((UByte$.ExternalSyntheticBackport0.m(this.bounded) * 31) + Dp.hashCode-impl(this.radius)) * 31) + this.color.hashCode();
    }
}
