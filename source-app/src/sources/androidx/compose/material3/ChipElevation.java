package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.foundation.interaction.DragInteraction;
import androidx.compose.foundation.interaction.FocusInteraction;
import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.Interaction;
import androidx.compose.foundation.interaction.InteractionSource;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.snapshots.SnapshotStateList;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\b\u0007\u0018\u00002\u00020\u0001B5\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\tJ#\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00030\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0003¢\u0006\u0002\u0010\u0018J\u0013\u0010\u0019\u001a\u00020\u00152\b\u0010\u001a\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010\u001b\u001a\u00020\u001cH\u0016J%\u0010\u001d\u001a\b\u0012\u0004\u0012\u00020\u00030\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0001¢\u0006\u0004\b\u001e\u0010\u0018R\u0019\u0010\b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\n\u0010\u000bR\u0019\u0010\u0007\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\r\u0010\u000bR\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\u000e\u0010\u000bR\u0019\u0010\u0005\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\u000f\u0010\u000bR\u0019\u0010\u0006\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\u0010\u0010\u000bR\u0019\u0010\u0004\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\f\u001a\u0004\b\u0011\u0010\u000b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001f²\u0006\f\u0010 \u001a\u0004\u0018\u00010!X\u008a\u008e\u0002"}, d2 = {"Landroidx/compose/material3/ChipElevation;", "", "elevation", "Landroidx/compose/ui/unit/Dp;", "pressedElevation", "focusedElevation", "hoveredElevation", "draggedElevation", "disabledElevation", "(FFFFFFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getDisabledElevation-D9Ej5fM", "()F", "F", "getDraggedElevation-D9Ej5fM", "getElevation-D9Ej5fM", "getFocusedElevation-D9Ej5fM", "getHoveredElevation-D9Ej5fM", "getPressedElevation-D9Ej5fM", "animateElevation", "Landroidx/compose/runtime/State;", "enabled", "", "interactionSource", "Landroidx/compose/foundation/interaction/InteractionSource;", "(ZLandroidx/compose/foundation/interaction/InteractionSource;Landroidx/compose/runtime/Composer;I)Landroidx/compose/runtime/State;", "equals", "other", "hashCode", "", "shadowElevation", "shadowElevation$material3_release", "material3_release", "lastInteraction", "Landroidx/compose/foundation/interaction/Interaction;"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ChipElevation {
    public static final int $stable = 0;
    private final float disabledElevation;
    private final float draggedElevation;
    private final float elevation;
    private final float focusedElevation;
    private final float hoveredElevation;
    private final float pressedElevation;

    public ChipElevation(float f, float f2, float f3, float f4, float f5, float f6, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, f2, f3, f4, f5, f6);
    }

    private ChipElevation(float f, float f2, float f3, float f4, float f5, float f6) {
        this.elevation = f;
        this.pressedElevation = f2;
        this.focusedElevation = f3;
        this.hoveredElevation = f4;
        this.draggedElevation = f5;
        this.disabledElevation = f6;
    }

    public final float getElevation() {
        return this.elevation;
    }

    public final float getPressedElevation() {
        return this.pressedElevation;
    }

    public final float getFocusedElevation() {
        return this.focusedElevation;
    }

    public final float getHoveredElevation() {
        return this.hoveredElevation;
    }

    public final float getDraggedElevation() {
        return this.draggedElevation;
    }

    public final float getDisabledElevation() {
        return this.disabledElevation;
    }

    public final State<Dp> shadowElevation$material3_release(boolean z, InteractionSource interactionSource, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, 1881877139, "C(shadowElevation)2172@104887L74:Chip.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(1881877139, i, -1, "androidx.compose.material3.ChipElevation.shadowElevation (Chip.kt:2171)");
        }
        State<Dp> stateAnimateElevation = animateElevation(z, interactionSource, composer, i & 1022);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAnimateElevation;
    }

    private final State<Dp> animateElevation(boolean z, InteractionSource interactionSource, Composer composer, int i) {
        float f;
        ComposerKt.sourceInformationMarkerStart(composer, -2071499570, "C(animateElevation)2180@105136L46,2181@105214L47,2182@105304L1473,2182@105270L1507,2234@107332L51,2236@107416L514,2236@107393L537:Chip.kt#uh7d8r");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-2071499570, i, -1, "androidx.compose.material3.ChipElevation.animateElevation (Chip.kt:2179)");
        }
        ComposerKt.sourceInformationMarkerStart(composer, 363854634, "CC(remember):Chip.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = SnapshotStateKt.mutableStateListOf();
            composer.updateRememberedValue(objRememberedValue);
        }
        SnapshotStateList snapshotStateList = (SnapshotStateList) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 363857131, "CC(remember):Chip.kt#9igjgp");
        Object objRememberedValue2 = composer.rememberedValue();
        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
            composer.updateRememberedValue(objRememberedValue2);
        }
        MutableState mutableState = (MutableState) objRememberedValue2;
        ComposerKt.sourceInformationMarkerEnd(composer);
        ComposerKt.sourceInformationMarkerStart(composer, 363861437, "CC(remember):Chip.kt#9igjgp");
        boolean z2 = true;
        boolean z3 = (((i & 112) ^ 48) > 32 && composer.changed(interactionSource)) || (i & 48) == 32;
        Object objRememberedValue3 = composer.rememberedValue();
        if (z3 || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue3 = (Function2) new ChipElevation$animateElevation$1$1(interactionSource, snapshotStateList, null);
            composer.updateRememberedValue(objRememberedValue3);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(interactionSource, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue3, composer, (i >> 3) & 14);
        Interaction interaction = (Interaction) CollectionsKt.lastOrNull(snapshotStateList);
        if (!z) {
            f = this.disabledElevation;
        } else if (interaction instanceof PressInteraction.Press) {
            f = this.pressedElevation;
        } else if (interaction instanceof HoverInteraction.Enter) {
            f = this.hoveredElevation;
        } else if (interaction instanceof FocusInteraction.Focus) {
            f = this.focusedElevation;
        } else {
            f = interaction instanceof DragInteraction.Start ? this.draggedElevation : this.elevation;
        }
        float f2 = f;
        ComposerKt.sourceInformationMarkerStart(composer, 363924911, "CC(remember):Chip.kt#9igjgp");
        Object objRememberedValue4 = composer.rememberedValue();
        if (objRememberedValue4 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue4 = new Animatable(Dp.box-impl(f2), VectorConvertersKt.getVectorConverter(Dp.Companion), null, null, 12, null);
            composer.updateRememberedValue(objRememberedValue4);
        }
        Animatable animatable = (Animatable) objRememberedValue4;
        ComposerKt.sourceInformationMarkerEnd(composer);
        Dp dp = Dp.box-impl(f2);
        ComposerKt.sourceInformationMarkerStart(composer, 363928062, "CC(remember):Chip.kt#9igjgp");
        boolean zChangedInstance = composer.changedInstance(animatable) | composer.changed(f2);
        if ((((i & 14) ^ 6) <= 4 || !composer.changed(z)) && (i & 6) != 4) {
            z2 = false;
        }
        boolean zChangedInstance2 = zChangedInstance | z2 | composer.changedInstance(interaction);
        Object objRememberedValue5 = composer.rememberedValue();
        if (zChangedInstance2 || objRememberedValue5 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue5 = (Function2) new ChipElevation$animateElevation$2$1(animatable, f2, z, interaction, mutableState, null);
            composer.updateRememberedValue(objRememberedValue5);
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        EffectsKt.LaunchedEffect(dp, (Function2<? super CoroutineScope, ? super Continuation<? super Unit>, ? extends Object>) objRememberedValue5, composer, 0);
        State<Dp> stateAsState = animatable.asState();
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return stateAsState;
    }

    public static final Interaction animateElevation$lambda$2(MutableState<Interaction> mutableState) {
        return mutableState.getValue();
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (other == null || !(other instanceof ChipElevation)) {
            return false;
        }
        ChipElevation chipElevation = (ChipElevation) other;
        return Dp.equals-impl0(this.elevation, chipElevation.elevation) && Dp.equals-impl0(this.pressedElevation, chipElevation.pressedElevation) && Dp.equals-impl0(this.focusedElevation, chipElevation.focusedElevation) && Dp.equals-impl0(this.hoveredElevation, chipElevation.hoveredElevation) && Dp.equals-impl0(this.disabledElevation, chipElevation.disabledElevation);
    }

    public int hashCode() {
        return (((((((Dp.hashCode-impl(this.elevation) * 31) + Dp.hashCode-impl(this.pressedElevation)) * 31) + Dp.hashCode-impl(this.focusedElevation)) * 31) + Dp.hashCode-impl(this.hoveredElevation)) * 31) + Dp.hashCode-impl(this.disabledElevation);
    }
}
