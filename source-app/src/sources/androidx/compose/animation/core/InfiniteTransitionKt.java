package androidx.compose.animation.core;

import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.State;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.jvm.internal.FloatCompanionObject;

@Metadata(d1 = {"\u00004\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a\r\u0010\u0000\u001a\u00020\u0001H\u0007¢\u0006\u0002\u0010\u0002\u001a\u0017\u0010\u0000\u001a\u00020\u00012\b\b\u0002\u0010\u0003\u001a\u00020\u0004H\u0007¢\u0006\u0002\u0010\u0005\u001a5\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007*\u00020\u00012\u0006\u0010\t\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\b2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\fH\u0007¢\u0006\u0002\u0010\r\u001a?\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007*\u00020\u00012\u0006\u0010\t\u001a\u00020\b2\u0006\u0010\n\u001a\u00020\b2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\b0\f2\b\b\u0002\u0010\u0003\u001a\u00020\u0004H\u0007¢\u0006\u0002\u0010\u000e\u001aY\u0010\u000f\u001a\b\u0012\u0004\u0012\u0002H\u00100\u0007\"\u0004\b\u0000\u0010\u0010\"\b\b\u0001\u0010\u0011*\u00020\u0012*\u00020\u00012\u0006\u0010\t\u001a\u0002H\u00102\u0006\u0010\n\u001a\u0002H\u00102\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u0002H\u0010\u0012\u0004\u0012\u0002H\u00110\u00142\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u0002H\u00100\fH\u0007¢\u0006\u0002\u0010\u0015\u001ac\u0010\u000f\u001a\b\u0012\u0004\u0012\u0002H\u00100\u0007\"\u0004\b\u0000\u0010\u0010\"\b\b\u0001\u0010\u0011*\u00020\u0012*\u00020\u00012\u0006\u0010\t\u001a\u0002H\u00102\u0006\u0010\n\u001a\u0002H\u00102\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u0002H\u0010\u0012\u0004\u0012\u0002H\u00110\u00142\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u0002H\u00100\f2\b\b\u0002\u0010\u0003\u001a\u00020\u0004H\u0007¢\u0006\u0002\u0010\u0016¨\u0006\u0017"}, d2 = {"rememberInfiniteTransition", "Landroidx/compose/animation/core/InfiniteTransition;", "(Landroidx/compose/runtime/Composer;I)Landroidx/compose/animation/core/InfiniteTransition;", "label", "", "(Ljava/lang/String;Landroidx/compose/runtime/Composer;II)Landroidx/compose/animation/core/InfiniteTransition;", "animateFloat", "Landroidx/compose/runtime/State;", "", "initialValue", "targetValue", "animationSpec", "Landroidx/compose/animation/core/InfiniteRepeatableSpec;", "(Landroidx/compose/animation/core/InfiniteTransition;FFLandroidx/compose/animation/core/InfiniteRepeatableSpec;Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "(Landroidx/compose/animation/core/InfiniteTransition;FFLandroidx/compose/animation/core/InfiniteRepeatableSpec;Ljava/lang/String;Landroidx/compose/runtime/Composer;II)Landroidx/compose/runtime/State;", "animateValue", "T", "V", "Landroidx/compose/animation/core/AnimationVector;", "typeConverter", "Landroidx/compose/animation/core/TwoWayConverter;", "(Landroidx/compose/animation/core/InfiniteTransition;Ljava/lang/Object;Ljava/lang/Object;Landroidx/compose/animation/core/TwoWayConverter;Landroidx/compose/animation/core/InfiniteRepeatableSpec;Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "(Landroidx/compose/animation/core/InfiniteTransition;Ljava/lang/Object;Ljava/lang/Object;Landroidx/compose/animation/core/TwoWayConverter;Landroidx/compose/animation/core/InfiniteRepeatableSpec;Ljava/lang/String;Landroidx/compose/runtime/Composer;II)Landroidx/compose/runtime/State;", "animation-core_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class InfiniteTransitionKt {
    public static final InfiniteTransition rememberInfiniteTransition(String str, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 1013651573, "C(rememberInfiniteTransition)45@1981L38,46@2043L5:InfiniteTransition.kt#pdpnli");
        if ((i2 & 1) != 0) {
            str = "InfiniteTransition";
        }
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1013651573, i, -1, "androidx.compose.animation.core.rememberInfiniteTransition (InfiniteTransition.kt:44)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, -1916602784, "CC(remember):InfiniteTransition.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new InfiniteTransition(str);
            composer.updateRememberedValue(objRememberedValue);
        }
        InfiniteTransition infiniteTransition = (InfiniteTransition) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        infiniteTransition.run$animation_core_release(composer, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return infiniteTransition;
    }

    public static final <T, V extends androidx.compose.animation.core.AnimationVector> androidx.compose.runtime.State<T> animateValue(

    public static final State<Float> animateFloat(InfiniteTransition infiniteTransition, float f, float f2, InfiniteRepeatableSpec<Float> infiniteRepeatableSpec, String str, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, -644770905, "C(animateFloat)P(1,3)316@12588L84:InfiniteTransition.kt#pdpnli");
        String str2 = (i2 & 8) != 0 ? "FloatAnimation" : str;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-644770905, i, -1, "androidx.compose.animation.core.animateFloat (InfiniteTransition.kt:316)");
        }
        int i3 = i << 3;
        State<Float> stateAnimateValue = animateValue(infiniteTransition, Float.valueOf(f), Float.valueOf(f2), VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE), infiniteRepeatableSpec, str2, composer, (i & 1022) | (57344 & i3) | (i3 & 458752), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAnimateValue;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "rememberInfiniteTransition APIs now have a new label parameter added.")
    public static final InfiniteTransition rememberInfiniteTransition(Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -840193660, "C(rememberInfiniteTransition)324@12880L48:InfiniteTransition.kt#pdpnli");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-840193660, i, -1, "androidx.compose.animation.core.rememberInfiniteTransition (InfiniteTransition.kt:323)");
        }
        InfiniteTransition infiniteTransitionRememberInfiniteTransition = rememberInfiniteTransition("InfiniteTransition", composer, 6, 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return infiniteTransitionRememberInfiniteTransition;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "animateValue APIs now have a new label parameter added.")
    public static final State animateValue(InfiniteTransition infiniteTransition, Object obj, Object obj2, TwoWayConverter twoWayConverter, InfiniteRepeatableSpec infiniteRepeatableSpec, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1695411770, "C(animateValue)P(1,2,3)338@13274L202:InfiniteTransition.kt#pdpnli");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1695411770, i, -1, "androidx.compose.animation.core.animateValue (InfiniteTransition.kt:337)");
        }
        int i2 = (i >> 3) & 8;
        State stateAnimateValue = animateValue(infiniteTransition, obj, obj2, twoWayConverter, infiniteRepeatableSpec, "ValueAnimation", composer, (i & 14) | 196608 | (i2 << 3) | (i & 112) | (i2 << 6) | (i & 896) | (i & 7168) | (i & 57344), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAnimateValue;
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "animateFloat APIs now have a new label parameter added.")
    public static final State animateFloat(InfiniteTransition infiniteTransition, float f, float f2, InfiniteRepeatableSpec infiniteRepeatableSpec, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 469472752, "C(animateFloat)P(1,2)357@13770L155:InfiniteTransition.kt#pdpnli");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(469472752, i, -1, "androidx.compose.animation.core.animateFloat (InfiniteTransition.kt:356)");
        }
        State<Float> stateAnimateFloat = animateFloat(infiniteTransition, f, f2, infiniteRepeatableSpec, "FloatAnimation", composer, (i & 14) | 24576 | (i & 112) | (i & 896) | (i & 7168), 0);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAnimateFloat;
    }
}
