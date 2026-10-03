package com.google.accompanist.placeholder;

import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.InfiniteRepeatableSpec;
import androidx.compose.animation.core.InfiniteTransition;
import androidx.compose.animation.core.InfiniteTransitionKt;
import androidx.compose.animation.core.MutableTransitionState;
import androidx.compose.animation.core.Transition;
import androidx.compose.animation.core.TransitionKt;
import androidx.compose.animation.core.TwoWayConverter;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotMutationPolicy;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.draw.DrawModifierKt;
import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.geometry.SizeKt;
import androidx.compose.ui.graphics.AndroidPaint_androidKt;
import androidx.compose.ui.graphics.Canvas;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.Outline;
import androidx.compose.ui.graphics.Paint;
import androidx.compose.ui.graphics.Shape;
import androidx.compose.ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.node.Ref;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.profileinstaller.ProfileVerifier;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.FloatCompanionObject;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u000b¢\u0006\u0004\b\u0002\u0010\u0003"}, d2 = {"<anonymous>", "Landroidx/compose/ui/Modifier;", "invoke", "(Landroidx/compose/ui/Modifier;Landroidx/compose/runtime/Composer;I)Landroidx/compose/ui/Modifier;"}, k = 3, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class PlaceholderKt$placeholder$4 extends Lambda implements Function3<Modifier, Composer, Integer, Modifier> {
    final long $color;
    final Function3<Transition.Segment<Boolean>, Composer, Integer, FiniteAnimationSpec<Float>> $contentFadeTransitionSpec;
    final PlaceholderHighlight $highlight;
    final Function3<Transition.Segment<Boolean>, Composer, Integer, FiniteAnimationSpec<Float>> $placeholderFadeTransitionSpec;
    final Shape $shape;
    final boolean $visible;

    PlaceholderKt$placeholder$4(Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function3, Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function4, PlaceholderHighlight placeholderHighlight, boolean z, long j, Shape shape) {
        super(3);
        this.$placeholderFadeTransitionSpec = function3;
        this.$contentFadeTransitionSpec = function4;
        this.$highlight = placeholderHighlight;
        this.$visible = z;
        this.$color = j;
        this.$shape = shape;
    }

    public Object invoke(Object obj, Object obj2, Object obj3) {
        return invoke((Modifier) obj, (Composer) obj2, ((Number) obj3).intValue());
    }

    public final Modifier invoke(Modifier modifier, Composer composer, int i) {
        int i2;
        MutableState mutableState;
        Intrinsics.checkNotNullParameter(modifier, "$this$composed");
        composer.startReplaceableGroup(-1214629560);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1214629560, i, -1, "com.google.accompanist.placeholder.placeholder.<anonymous> (Placeholder.kt:120)");
        }
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.Companion.getEmpty()) {
            objRememberedValue = new Ref();
            composer.updateRememberedValue(objRememberedValue);
        }
        composer.endReplaceableGroup();
        final Ref ref = (Ref) objRememberedValue;
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue2 = composer.rememberedValue();
        if (objRememberedValue2 == Composer.Companion.getEmpty()) {
            objRememberedValue2 = new Ref();
            composer.updateRememberedValue(objRememberedValue2);
        }
        composer.endReplaceableGroup();
        final Ref ref2 = (Ref) objRememberedValue2;
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue3 = composer.rememberedValue();
        if (objRememberedValue3 == Composer.Companion.getEmpty()) {
            objRememberedValue3 = new Ref();
            composer.updateRememberedValue(objRememberedValue3);
        }
        composer.endReplaceableGroup();
        final Ref ref3 = (Ref) objRememberedValue3;
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue4 = composer.rememberedValue();
        if (objRememberedValue4 == Composer.Companion.getEmpty()) {
            objRememberedValue4 = SnapshotStateKt.mutableStateOf$default(Float.valueOf(0.0f), (SnapshotMutationPolicy) null, 2, (Object) null);
            composer.updateRememberedValue(objRememberedValue4);
        }
        composer.endReplaceableGroup();
        MutableState mutableState2 = (MutableState) objRememberedValue4;
        boolean z = this.$visible;
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue5 = composer.rememberedValue();
        if (objRememberedValue5 == Composer.Companion.getEmpty()) {
            objRememberedValue5 = new MutableTransitionState(Boolean.valueOf(z));
            composer.updateRememberedValue(objRememberedValue5);
        }
        composer.endReplaceableGroup();
        MutableTransitionState mutableTransitionState = (MutableTransitionState) objRememberedValue5;
        mutableTransitionState.setTargetState(Boolean.valueOf(this.$visible));
        Transition transitionUpdateTransition = TransitionKt.updateTransition(mutableTransitionState, "placeholder_crossfade", composer, MutableTransitionState.$stable | 48, 0);
        Function3<Transition.Segment<Boolean>, Composer, Integer, FiniteAnimationSpec<Float>> function3 = this.$placeholderFadeTransitionSpec;
        composer.startReplaceableGroup(-1338768149);
        ComposerKt.sourceInformation(composer, "C(animateFloat)P(2)933@37134L78:Transition.kt#pdpnli");
        TwoWayConverter vectorConverter = VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE);
        composer.startReplaceableGroup(-142660079);
        ComposerKt.sourceInformation(composer, "C(animateValue)P(3,2)851@33724L32,852@33779L31,853@33835L23,855@33871L89:Transition.kt#pdpnli");
        boolean zBooleanValue = ((Boolean) transitionUpdateTransition.getCurrentState()).booleanValue();
        composer.startReplaceableGroup(-2085173843);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2085173843, 0, -1, "com.google.accompanist.placeholder.placeholder.<anonymous>.<anonymous> (Placeholder.kt:138)");
        }
        float f = zBooleanValue ? 1.0f : 0.0f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        Float fValueOf = Float.valueOf(f);
        boolean zBooleanValue2 = ((Boolean) transitionUpdateTransition.getTargetState()).booleanValue();
        composer.startReplaceableGroup(-2085173843);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2085173843, 0, -1, "com.google.accompanist.placeholder.placeholder.<anonymous>.<anonymous> (Placeholder.kt:138)");
        }
        float f2 = zBooleanValue2 ? 1.0f : 0.0f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        final State stateCreateTransitionAnimation = TransitionKt.createTransitionAnimation(transitionUpdateTransition, fValueOf, Float.valueOf(f2), (FiniteAnimationSpec) function3.invoke(transitionUpdateTransition.getSegment(), composer, 0), vectorConverter, "placeholder_fade", composer, ProfileVerifier.CompilationStatus.f97xf2722a21);
        composer.endReplaceableGroup();
        composer.endReplaceableGroup();
        Function3<Transition.Segment<Boolean>, Composer, Integer, FiniteAnimationSpec<Float>> function4 = this.$contentFadeTransitionSpec;
        composer.startReplaceableGroup(-1338768149);
        ComposerKt.sourceInformation(composer, "C(animateFloat)P(2)933@37134L78:Transition.kt#pdpnli");
        TwoWayConverter vectorConverter2 = VectorConvertersKt.getVectorConverter(FloatCompanionObject.INSTANCE);
        composer.startReplaceableGroup(-142660079);
        ComposerKt.sourceInformation(composer, "C(animateValue)P(3,2)851@33724L32,852@33779L31,853@33835L23,855@33871L89:Transition.kt#pdpnli");
        boolean zBooleanValue3 = ((Boolean) transitionUpdateTransition.getCurrentState()).booleanValue();
        composer.startReplaceableGroup(992792551);
        if (ComposerKt.isTraceInProgress()) {
            i2 = 0;
            ComposerKt.traceEventStart(992792551, 0, -1, "com.google.accompanist.placeholder.placeholder.<anonymous>.<anonymous> (Placeholder.kt:143)");
        } else {
            i2 = 0;
        }
        float f3 = zBooleanValue3 ? 0.0f : 1.0f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        Float fValueOf2 = Float.valueOf(f3);
        boolean zBooleanValue4 = ((Boolean) transitionUpdateTransition.getTargetState()).booleanValue();
        composer.startReplaceableGroup(992792551);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(992792551, i2, -1, "com.google.accompanist.placeholder.placeholder.<anonymous>.<anonymous> (Placeholder.kt:143)");
        }
        float f4 = zBooleanValue4 ? 0.0f : 1.0f;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        final State stateCreateTransitionAnimation2 = TransitionKt.createTransitionAnimation(transitionUpdateTransition, fValueOf2, Float.valueOf(f4), (FiniteAnimationSpec) function4.invoke(transitionUpdateTransition.getSegment(), composer, Integer.valueOf(i2)), vectorConverter2, "content_fade", composer, ProfileVerifier.CompilationStatus.f97xf2722a21);
        composer.endReplaceableGroup();
        composer.endReplaceableGroup();
        PlaceholderHighlight placeholderHighlight = this.$highlight;
        InfiniteRepeatableSpec<Float> animationSpec = placeholderHighlight != null ? placeholderHighlight.getAnimationSpec() : null;
        composer.startReplaceableGroup(804161798);
        if (animationSpec == null || (!this.$visible && invoke$lambda$9(stateCreateTransitionAnimation) < 0.01f)) {
            mutableState = mutableState2;
        } else {
            mutableState = mutableState2;
            invoke$lambda$5(mutableState, ((Number) InfiniteTransitionKt.animateFloat(InfiniteTransitionKt.rememberInfiniteTransition(composer, i2), 0.0f, 1.0f, animationSpec, composer, InfiniteTransition.$stable | 432 | (InfiniteRepeatableSpec.$stable << 9)).getValue()).floatValue());
        }
        composer.endReplaceableGroup();
        composer.startReplaceableGroup(-492369756);
        ComposerKt.sourceInformation(composer, "CC(remember):Composables.kt#9igjgp");
        Object objRememberedValue6 = composer.rememberedValue();
        if (objRememberedValue6 == Composer.Companion.getEmpty()) {
            objRememberedValue6 = AndroidPaint_androidKt.Paint();
            composer.updateRememberedValue(objRememberedValue6);
        }
        composer.endReplaceableGroup();
        final Paint paint = (Paint) objRememberedValue6;
        Color color = Color.box-impl(this.$color);
        final Shape shape = this.$shape;
        final PlaceholderHighlight placeholderHighlight2 = this.$highlight;
        final long j = this.$color;
        composer.startReplaceableGroup(1618982084);
        ComposerKt.sourceInformation(composer, "CC(remember)P(1,2,3):Composables.kt#9igjgp");
        boolean zChanged = composer.changed(color) | composer.changed(shape) | composer.changed(placeholderHighlight2);
        Object objRememberedValue7 = composer.rememberedValue();
        if (zChanged || objRememberedValue7 == Composer.Companion.getEmpty()) {
            final MutableState mutableState3 = mutableState;
            objRememberedValue7 = DrawModifierKt.drawWithContent(modifier, new Function1<ContentDrawScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((ContentDrawScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(ContentDrawScope contentDrawScope) {
                    Intrinsics.checkNotNullParameter(contentDrawScope, "$this$drawWithContent");
                    float fInvoke$lambda$11 = PlaceholderKt$placeholder$4.invoke$lambda$11(stateCreateTransitionAnimation2);
                    if (0.01f <= fInvoke$lambda$11 && fInvoke$lambda$11 <= 0.99f) {
                        paint.setAlpha(PlaceholderKt$placeholder$4.invoke$lambda$11(stateCreateTransitionAnimation2));
                        DrawScope drawScope = (DrawScope) contentDrawScope;
                        Paint paint2 = paint;
                        Canvas canvas = drawScope.getDrawContext().getCanvas();
                        canvas.saveLayer(SizeKt.toRect-uvyYCjk(drawScope.getSize-NH-jbRc()), paint2);
                        contentDrawScope.drawContent();
                        canvas.restore();
                    } else if (PlaceholderKt$placeholder$4.invoke$lambda$11(stateCreateTransitionAnimation2) >= 0.99f) {
                        contentDrawScope.drawContent();
                    }
                    float fInvoke$lambda$9 = PlaceholderKt$placeholder$4.invoke$lambda$9(stateCreateTransitionAnimation);
                    if (0.01f <= fInvoke$lambda$9 && fInvoke$lambda$9 <= 0.99f) {
                        paint.setAlpha(PlaceholderKt$placeholder$4.invoke$lambda$9(stateCreateTransitionAnimation));
                        DrawScope drawScope2 = (DrawScope) contentDrawScope;
                        Paint paint3 = paint;
                        Ref<Outline> ref4 = ref3;
                        Shape shape2 = shape;
                        long j2 = j;
                        PlaceholderHighlight placeholderHighlight3 = placeholderHighlight2;
                        Ref<LayoutDirection> ref5 = ref2;
                        Ref<Size> ref6 = ref;
                        MutableState<Float> mutableState4 = mutableState3;
                        Canvas canvas2 = drawScope2.getDrawContext().getCanvas();
                        canvas2.saveLayer(SizeKt.toRect-uvyYCjk(drawScope2.getSize-NH-jbRc()), paint3);
                        ref4.setValue(PlaceholderKt.m2597drawPlaceholderhpmOzss(drawScope2, shape2, j2, placeholderHighlight3, PlaceholderKt$placeholder$4.invoke$lambda$4(mutableState4), (Outline) ref4.getValue(), (LayoutDirection) ref5.getValue(), (Size) ref6.getValue()));
                        canvas2.restore();
                    } else if (PlaceholderKt$placeholder$4.invoke$lambda$9(stateCreateTransitionAnimation) >= 0.99f) {
                        ref3.setValue(PlaceholderKt.m2597drawPlaceholderhpmOzss((DrawScope) contentDrawScope, shape, j, placeholderHighlight2, PlaceholderKt$placeholder$4.invoke$lambda$4(mutableState3), (Outline) ref3.getValue(), (LayoutDirection) ref2.getValue(), (Size) ref.getValue()));
                    }
                    ref.setValue(Size.box-impl(contentDrawScope.getSize-NH-jbRc()));
                    ref2.setValue(contentDrawScope.getLayoutDirection());
                }
            });
            composer.updateRememberedValue(objRememberedValue7);
        }
        composer.endReplaceableGroup();
        Modifier modifier2 = (Modifier) objRememberedValue7;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        composer.endReplaceableGroup();
        return modifier2;
    }

    public static final float invoke$lambda$4(MutableState<Float> mutableState) {
        return ((Number) ((State) mutableState).getValue()).floatValue();
    }

    private static final void invoke$lambda$5(MutableState<Float> mutableState, float f) {
        mutableState.setValue(Float.valueOf(f));
    }

    public static final float invoke$lambda$9(State<Float> state) {
        return ((Number) state.getValue()).floatValue();
    }

    public static final float invoke$lambda$11(State<Float> state) {
        return ((Number) state.getValue()).floatValue();
    }
}
