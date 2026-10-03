package androidx.compose.p002ui.layout;

import androidx.autofill.HintConstants;
import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0082\b\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u008c\u0001\u0012A\u0010\u0003\u001a=\u0012\u0004\u0012\u00020\u0005\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\t\u0012\u0013\u0012\u00110\n¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0004¢\u0006\u0002\b\r\u0012\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00110\u000f\u0012.\b\u0002\u0010\u0012\u001a(\u0012\u0004\u0012\u00020\u0014\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u0016\u0012\u0004\u0012\u00020\u00110\u0013¢\u0006\u0002\b\r¢\u0006\u0002\u0010\u0017JD\u0010\u001c\u001a=\u0012\u0004\u0012\u00020\u0005\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\t\u0012\u0013\u0012\u00110\n¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0004¢\u0006\u0002\b\rHÆ\u0003J\u0015\u0010\u001d\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00110\u000fHÆ\u0003J/\u0010\u001e\u001a(\u0012\u0004\u0012\u00020\u0014\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u0016\u0012\u0004\u0012\u00020\u00110\u0013¢\u0006\u0002\b\rHÆ\u0003J\u0094\u0001\u0010\u001f\u001a\u00020\u00002C\b\u0002\u0010\u0003\u001a=\u0012\u0004\u0012\u00020\u0005\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\t\u0012\u0013\u0012\u00110\n¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0004¢\u0006\u0002\b\r2\u0014\b\u0002\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00110\u000f2.\b\u0002\u0010\u0012\u001a(\u0012\u0004\u0012\u00020\u0014\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u0016\u0012\u0004\u0012\u00020\u00110\u0013¢\u0006\u0002\b\rHÆ\u0001J\b\u0010 \u001a\u00020\u0002H\u0016J\u0013\u0010!\u001a\u00020\u00112\b\u0010\"\u001a\u0004\u0018\u00010#HÖ\u0003J\t\u0010$\u001a\u00020%HÖ\u0001J\t\u0010&\u001a\u00020'HÖ\u0001J\u0010\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020\u0002H\u0016J\f\u0010+\u001a\u00020)*\u00020,H\u0016RL\u0010\u0003\u001a=\u0012\u0004\u0012\u00020\u0005\u0012\u0013\u0012\u00110\u0006¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\t\u0012\u0013\u0012\u00110\n¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u000b\u0012\u0004\u0012\u00020\f0\u0004¢\u0006\u0002\b\r¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u001d\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\u00110\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u001aR7\u0010\u0012\u001a(\u0012\u0004\u0012\u00020\u0014\u0012\u0013\u0012\u00110\u0015¢\u0006\f\b\u0007\u0012\b\b\b\u0012\u0004\b\b(\u0016\u0012\u0004\u0012\u00020\u00110\u0013¢\u0006\u0002\b\r¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u001b¨\u0006-"}, d2 = {"Landroidx/compose/ui/layout/ApproachLayoutElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/ui/layout/ApproachLayoutModifierNodeImpl;", "approachMeasure", "Lkotlin/Function3;", "Landroidx/compose/ui/layout/ApproachMeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "measurable", "Landroidx/compose/ui/unit/Constraints;", "constraints", "Landroidx/compose/ui/layout/MeasureResult;", "Lkotlin/ExtensionFunctionType;", "isMeasurementApproachInProgress", "Lkotlin/Function1;", "Landroidx/compose/ui/unit/IntSize;", "", "isPlacementApproachInProgress", "Lkotlin/Function2;", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "Landroidx/compose/ui/layout/LayoutCoordinates;", "lookaheadCoordinates", "(Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function2;)V", "getApproachMeasure", "()Lkotlin/jvm/functions/Function3;", "()Lkotlin/jvm/functions/Function1;", "()Lkotlin/jvm/functions/Function2;", "component1", "component2", "component3", "copy", "create", "equals", "other", "", "hashCode", "", "toString", "", "update", "", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ApproachLayoutElement extends ModifierNodeElement<ApproachLayoutModifierNodeImpl> {
    private final Function3<ApproachMeasureScope, Measurable, Constraints, MeasureResult> approachMeasure;
    private final Function1<IntSize, Boolean> isMeasurementApproachInProgress;
    private final Function2<Placeable.PlacementScope, LayoutCoordinates, Boolean> isPlacementApproachInProgress;

    public static ApproachLayoutElement copy$default(ApproachLayoutElement approachLayoutElement, Function3 function3, Function1 function1, Function2 function2, int i, Object obj) {
        if ((i & 1) != 0) {
            function3 = approachLayoutElement.approachMeasure;
        }
        if ((i & 2) != 0) {
            function1 = approachLayoutElement.isMeasurementApproachInProgress;
        }
        if ((i & 4) != 0) {
            function2 = approachLayoutElement.isPlacementApproachInProgress;
        }
        return approachLayoutElement.copy(function3, function1, function2);
    }

    public final Function3<ApproachMeasureScope, Measurable, Constraints, MeasureResult> component1() {
        return this.approachMeasure;
    }

    public final Function1<IntSize, Boolean> component2() {
        return this.isMeasurementApproachInProgress;
    }

    public final Function2<Placeable.PlacementScope, LayoutCoordinates, Boolean> component3() {
        return this.isPlacementApproachInProgress;
    }

    public final ApproachLayoutElement copy(Function3<? super ApproachMeasureScope, ? super Measurable, ? super Constraints, ? extends MeasureResult> approachMeasure, Function1<? super IntSize, Boolean> isMeasurementApproachInProgress, Function2<? super Placeable.PlacementScope, ? super LayoutCoordinates, Boolean> isPlacementApproachInProgress) {
        return new ApproachLayoutElement(approachMeasure, isMeasurementApproachInProgress, isPlacementApproachInProgress);
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ApproachLayoutElement)) {
            return false;
        }
        ApproachLayoutElement approachLayoutElement = (ApproachLayoutElement) other;
        return Intrinsics.areEqual(this.approachMeasure, approachLayoutElement.approachMeasure) && Intrinsics.areEqual(this.isMeasurementApproachInProgress, approachLayoutElement.isMeasurementApproachInProgress) && Intrinsics.areEqual(this.isPlacementApproachInProgress, approachLayoutElement.isPlacementApproachInProgress);
    }

    @Override
    public int hashCode() {
        return (((this.approachMeasure.hashCode() * 31) + this.isMeasurementApproachInProgress.hashCode()) * 31) + this.isPlacementApproachInProgress.hashCode();
    }

    public String toString() {
        return "ApproachLayoutElement(approachMeasure=" + this.approachMeasure + ", isMeasurementApproachInProgress=" + this.isMeasurementApproachInProgress + ", isPlacementApproachInProgress=" + this.isPlacementApproachInProgress + ')';
    }

    public final Function3<ApproachMeasureScope, Measurable, Constraints, MeasureResult> getApproachMeasure() {
        return this.approachMeasure;
    }

    public final Function1<IntSize, Boolean> isMeasurementApproachInProgress() {
        return this.isMeasurementApproachInProgress;
    }

    public final Function2<Placeable.PlacementScope, LayoutCoordinates, Boolean> isPlacementApproachInProgress() {
        return this.isPlacementApproachInProgress;
    }

    public ApproachLayoutElement(Function3 function3, Function1 function1, Function2 function2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(function3, function1, (i & 4) != 0 ? LookaheadScopeKt.defaultPlacementApproachInProgress : function2);
    }

    public ApproachLayoutElement(Function3<? super ApproachMeasureScope, ? super Measurable, ? super Constraints, ? extends MeasureResult> function3, Function1<? super IntSize, Boolean> function1, Function2<? super Placeable.PlacementScope, ? super LayoutCoordinates, Boolean> function2) {
        this.approachMeasure = function3;
        this.isMeasurementApproachInProgress = function1;
        this.isPlacementApproachInProgress = function2;
    }

    @Override
    public ApproachLayoutModifierNodeImpl getNode() {
        return new ApproachLayoutModifierNodeImpl(this.approachMeasure, this.isMeasurementApproachInProgress, this.isPlacementApproachInProgress);
    }

    @Override
    public void update(ApproachLayoutModifierNodeImpl node) {
        node.setMeasureBlock(this.approachMeasure);
        node.setMeasurementApproachInProgress(this.isMeasurementApproachInProgress);
        node.setPlacementApproachInProgress(this.isPlacementApproachInProgress);
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
        inspectorInfo.setName("approachLayout");
        inspectorInfo.getProperties().set("approachMeasure", this.approachMeasure);
        inspectorInfo.getProperties().set("isMeasurementApproachInProgress", this.isMeasurementApproachInProgress);
        inspectorInfo.getProperties().set("isPlacementApproachInProgress", this.isPlacementApproachInProgress);
    }
}
