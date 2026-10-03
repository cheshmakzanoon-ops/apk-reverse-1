package androidx.compose.material3;

import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0080\b\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u001d\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\t\u0010\u000b\u001a\u00020\u0004HÂ\u0003J\t\u0010\f\u001a\u00020\u0006HÂ\u0003J\u0016\u0010\r\u001a\u00020\bHÂ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ1\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\b\u0010\u0013\u001a\u00020\u0002H\u0016J\u0013\u0010\u0014\u001a\u00020\u00062\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u001aHÖ\u0001J\u0010\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u0002H\u0016J\f\u0010\u001e\u001a\u00020\u001c*\u00020\u001fH\u0016R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0007\u001a\u00020\bX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\nR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006 "}, d2 = {"Landroidx/compose/material3/ClockDialModifier;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/material3/ClockDialNode;", "state", "Landroidx/compose/material3/AnalogTimePickerState;", "autoSwitchToMinute", "", "selection", "Landroidx/compose/material3/TimePickerSelectionMode;", "(Landroidx/compose/material3/AnalogTimePickerState;ZILkotlin/jvm/internal/DefaultConstructorMarker;)V", "I", "component1", "component2", "component3", "component3-yecRtBI", "()I", "copy", "copy-e8ubxrI", "(Landroidx/compose/material3/AnalogTimePickerState;ZI)Landroidx/compose/material3/ClockDialModifier;", "create", "equals", "other", "", "hashCode", "", "toString", "", "update", "", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ClockDialModifier extends ModifierNodeElement<ClockDialNode> {
    public static final int $stable = 0;
    private final boolean autoSwitchToMinute;
    private final int selection;
    private final AnalogTimePickerState state;

    public ClockDialModifier(AnalogTimePickerState analogTimePickerState, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(analogTimePickerState, z, i);
    }

    private final AnalogTimePickerState getState() {
        return this.state;
    }

    private final boolean getAutoSwitchToMinute() {
        return this.autoSwitchToMinute;
    }

    private final int getSelection() {
        return this.selection;
    }

    public static ClockDialModifier m2123copye8ubxrI$default(ClockDialModifier clockDialModifier, AnalogTimePickerState analogTimePickerState, boolean z, int i, int i2, Object obj) {
        if ((i2 & 1) != 0) {
            analogTimePickerState = clockDialModifier.state;
        }
        if ((i2 & 2) != 0) {
            z = clockDialModifier.autoSwitchToMinute;
        }
        if ((i2 & 4) != 0) {
            i = clockDialModifier.selection;
        }
        return clockDialModifier.m2124copye8ubxrI(analogTimePickerState, z, i);
    }

    public final ClockDialModifier m2124copye8ubxrI(AnalogTimePickerState state, boolean autoSwitchToMinute, int selection) {
        return new ClockDialModifier(state, autoSwitchToMinute, selection, null);
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ClockDialModifier)) {
            return false;
        }
        ClockDialModifier clockDialModifier = (ClockDialModifier) other;
        return Intrinsics.areEqual(this.state, clockDialModifier.state) && this.autoSwitchToMinute == clockDialModifier.autoSwitchToMinute && TimePickerSelectionMode.m3083equalsimpl0(this.selection, clockDialModifier.selection);
    }

    @Override
    public int hashCode() {
        return (((this.state.hashCode() * 31) + UByte$.ExternalSyntheticBackport0.m(this.autoSwitchToMinute)) * 31) + TimePickerSelectionMode.m3084hashCodeimpl(this.selection);
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
    }

    public String toString() {
        return "ClockDialModifier(state=" + this.state + ", autoSwitchToMinute=" + this.autoSwitchToMinute + ", selection=" + ((Object) TimePickerSelectionMode.m3085toStringimpl(this.selection)) + ')';
    }

    private ClockDialModifier(AnalogTimePickerState analogTimePickerState, boolean z, int i) {
        this.state = analogTimePickerState;
        this.autoSwitchToMinute = z;
        this.selection = i;
    }

    @Override
    public ClockDialNode getNode() {
        return new ClockDialNode(this.state, this.autoSwitchToMinute, this.selection, null);
    }

    @Override
    public void update(ClockDialNode node) {
        node.m2125updateNodee8ubxrI(this.state, this.autoSwitchToMinute, this.selection);
    }
}
