package androidx.compose.material3;

import androidx.autofill.HintConstants;
import androidx.compose.animation.core.AnimationConstants;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.EasingKt;
import androidx.compose.foundation.gestures.Orientation;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollConnection;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollSource;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.Velocity;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000H\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\u001a;\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2!\u0010\f\u001a\u001d\u0012\u0013\u0012\u00110\u0002¢\u0006\f\b\u000e\u0012\b\b\u000f\u0012\u0004\b\b(\u0010\u0012\u0004\u0012\u00020\u00110\rH\u0000\u001aA\u0010\u0012\u001a\u00020\t2\b\b\u0002\u0010\u0013\u001a\u00020\u00142\u0014\b\u0002\u0010\u0015\u001a\u000e\u0012\u0004\u0012\u00020\u0016\u0012\u0004\u0012\u00020\u00140\r2\b\b\u0002\u0010\u0017\u001a\u00020\u00162\b\b\u0002\u0010\u0018\u001a\u00020\u0014H\u0001¢\u0006\u0002\u0010\u0019\"\u0014\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001X\u0082\u0004¢\u0006\u0002\n\u0000\"\u0010\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0005¨\u0006\u001a"}, d2 = {"BottomSheetAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "", "DragHandleVerticalPadding", "Landroidx/compose/ui/unit/Dp;", "F", "ConsumeSwipeWithinBottomSheetBoundsNestedScrollConnection", "Landroidx/compose/ui/input/nestedscroll/NestedScrollConnection;", "sheetState", "Landroidx/compose/material3/SheetState;", "orientation", "Landroidx/compose/foundation/gestures/Orientation;", "onFling", "Lkotlin/Function1;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "velocity", "", "rememberSheetState", "skipPartiallyExpanded", "", "confirmValueChange", "Landroidx/compose/material3/SheetValue;", "initialValue", "skipHiddenState", "(ZLkotlin/jvm/functions/Function1;Landroidx/compose/material3/SheetValue;ZLandroidx/compose/runtime/Composer;II)Landroidx/compose/material3/SheetState;", "material3_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SheetDefaultsKt {
    private static final float DragHandleVerticalPadding = Dp.constructor-impl(22);
    private static final AnimationSpec<Float> BottomSheetAnimationSpec = AnimationSpecKt.tween$default(AnimationConstants.DefaultDurationMillis, 0, EasingKt.getFastOutSlowInEasing(), 2, null);

    public static final NestedScrollConnection ConsumeSwipeWithinBottomSheetBoundsNestedScrollConnection(final SheetState sheetState, final Orientation orientation, final Function1<? super Float, Unit> function1) {
        return new NestedScrollConnection() {
            @Override
            public long mo831onPreScrollOzD1aCk(long available, int source) {
                float fOffsetToFloat = offsetToFloat(available);
                if (fOffsetToFloat < 0.0f && NestedScrollSource.m5728equalsimpl0(source, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI())) {
                    return toOffset(sheetState.getAnchoredDraggableState$material3_release().dispatchRawDelta(fOffsetToFloat));
                }
                return Offset.INSTANCE.m4362getZeroF1C5BW0();
            }

            @Override
            public long mo829onPostScrollDzOQY0M(long consumed, long available, int source) {
                if (NestedScrollSource.m5728equalsimpl0(source, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI())) {
                    return toOffset(sheetState.getAnchoredDraggableState$material3_release().dispatchRawDelta(offsetToFloat(available)));
                }
                return Offset.INSTANCE.m4362getZeroF1C5BW0();
            }

            @Override
            public Object mo830onPreFlingQWom1Mo(long j, Continuation<? super Velocity> continuation) {
                float fVelocityToFloat = velocityToFloat(j);
                float fRequireOffset = sheetState.requireOffset();
                float fMinAnchor = sheetState.getAnchoredDraggableState$material3_release().getAnchors().minAnchor();
                if (fVelocityToFloat < 0.0f && fRequireOffset > fMinAnchor) {
                    function1.invoke(Boxing.boxFloat(fVelocityToFloat));
                } else {
                    j = Velocity.Companion.getZero-9UxMQ8M();
                }
                return Velocity.box-impl(j);
            }

            @Override
            public Object mo828onPostFlingRZ2iAVY(long j, long j2, Continuation<? super Velocity> continuation) {
                function1.invoke(Boxing.boxFloat(velocityToFloat(j2)));
                return Velocity.box-impl(j2);
            }

            private final long toOffset(float f) {
                float f2 = orientation == Orientation.Horizontal ? f : 0.0f;
                if (orientation != Orientation.Vertical) {
                    f = 0.0f;
                }
                return OffsetKt.Offset(f2, f);
            }

            private final float velocityToFloat(long j) {
                return orientation == Orientation.Horizontal ? Velocity.getX-impl(j) : Velocity.getY-impl(j);
            }

            private final float offsetToFloat(long j) {
                return orientation == Orientation.Horizontal ? Offset.m4346getXimpl(j) : Offset.m4347getYimpl(j);
            }
        };
    }

    public static final SheetState rememberSheetState(boolean z, Function1<? super SheetValue, Boolean> function1, SheetValue sheetValue, boolean z2, Composer composer, int i, int i2) {
        ComposerKt.sourceInformationMarkerStart(composer, 1032784200, "C(rememberSheetState)P(3)408@15981L7,420@16374L180,409@16000L554:SheetDefaults.kt#uh7d8r");
        final boolean z3 = (i2 & 1) != 0 ? false : z;
        final Function1<? super SheetValue, Boolean> function2 = (i2 & 2) != 0 ? new Function1<SheetValue, Boolean>() {
            public final Boolean invoke(SheetValue sheetValue2) {
                return true;
            }
        } : function1;
        final SheetValue sheetValue2 = (i2 & 4) != 0 ? SheetValue.Hidden : sheetValue;
        final boolean z4 = (i2 & 8) != 0 ? false : z2;
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1032784200, i, -1, "androidx.compose.material3.rememberSheetState (SheetDefaults.kt:407)");
        }
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        final Density density = (Density) objConsume;
        Object[] objArr = {Boolean.valueOf(z3), function2, Boolean.valueOf(z4)};
        Saver<SheetState, SheetValue> Saver = SheetState.INSTANCE.Saver(z3, function2, density, z4);
        ComposerKt.sourceInformationMarkerStart(composer, -349419818, "CC(remember):SheetDefaults.kt#9igjgp");
        boolean zChanged = ((((i & 14) ^ 6) > 4 && composer.changed(z3)) || (i & 6) == 4) | composer.changed(density) | ((((i & 896) ^ 384) > 256 && composer.changed(sheetValue2)) || (i & 384) == 256) | ((((i & 112) ^ 48) > 32 && composer.changed(function2)) || (i & 48) == 32) | ((((i & 7168) ^ 3072) > 2048 && composer.changed(z4)) || (i & 3072) == 2048);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = (Function0) new Function0<SheetState>() {
                {
                    super(0);
                }

                public final SheetState m2789invoke() {
                    return new SheetState(z3, density, sheetValue2, function2, z4);
                }
            };
            composer.updateRememberedValue(objRememberedValue);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        SheetState sheetState = (SheetState) RememberSaveableKt.m4142rememberSaveable(objArr, (Saver) Saver, (String) null, (Function0) objRememberedValue, composer, 0, 4);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return sheetState;
    }
}
