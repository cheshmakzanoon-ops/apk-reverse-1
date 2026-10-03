package androidx.compose.foundation;

import androidx.compose.p002ui.node.ModifierNodeElement;
import androidx.compose.p002ui.platform.InspectorInfo;
import androidx.compose.p002ui.semantics.Role;
import kotlin.Metadata;
import kotlin.UByte$;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001BI\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\u000e\u0010\t\u001a\n\u0012\u0004\u0012\u00020\u000b\u0018\u00010\n\u0012\b\u0010\f\u001a\u0004\u0018\u00010\b\u0012\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000b0\n¢\u0006\u0002\u0010\u000eJ\b\u0010\u000f\u001a\u00020\u0002H\u0016J\u0013\u0010\u0010\u001a\u00020\u00042\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012H\u0096\u0002J\b\u0010\u0013\u001a\u00020\u0014H\u0016J\u0010\u0010\u0015\u001a\u00020\u000b2\u0006\u0010\u0016\u001a\u00020\u0002H\u0016J\f\u0010\u0017\u001a\u00020\u000b*\u00020\u0018H\u0016R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\f\u001a\u0004\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\t\u001a\n\u0012\u0004\u0012\u00020\u000b\u0018\u00010\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0019"}, d2 = {"Landroidx/compose/foundation/ClickableSemanticsElement;", "Landroidx/compose/ui/node/ModifierNodeElement;", "Landroidx/compose/foundation/ClickableSemanticsNode;", "enabled", "", "role", "Landroidx/compose/ui/semantics/Role;", "onLongClickLabel", "", "onLongClick", "Lkotlin/Function0;", "", "onClickLabel", "onClick", "(ZLandroidx/compose/ui/semantics/Role;Ljava/lang/String;Lkotlin/jvm/functions/Function0;Ljava/lang/String;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/internal/DefaultConstructorMarker;)V", "create", "equals", "other", "", "hashCode", "", "update", "node", "inspectableProperties", "Landroidx/compose/ui/platform/InspectorInfo;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class ClickableSemanticsElement extends ModifierNodeElement<ClickableSemanticsNode> {
    private final boolean enabled;
    private final Function0<Unit> onClick;
    private final String onClickLabel;
    private final Function0<Unit> onLongClick;
    private final String onLongClickLabel;
    private final Role role;

    public ClickableSemanticsElement(boolean z, Role role, String str, Function0 function0, String str2, Function0 function1, DefaultConstructorMarker defaultConstructorMarker) {
        this(z, role, str, function0, str2, function1);
    }

    @Override
    public void inspectableProperties(InspectorInfo inspectorInfo) {
    }

    private ClickableSemanticsElement(boolean z, Role role, String str, Function0<Unit> function0, String str2, Function0<Unit> function1) {
        this.enabled = z;
        this.role = role;
        this.onLongClickLabel = str;
        this.onLongClick = function0;
        this.onClickLabel = str2;
        this.onClick = function1;
    }

    @Override
    public ClickableSemanticsNode getNode() {
        return new ClickableSemanticsNode(this.enabled, this.onClickLabel, this.role, this.onClick, this.onLongClickLabel, this.onLongClick, null);
    }

    @Override
    public void update(ClickableSemanticsNode node) {
        node.m566updateUMe6uN4(this.enabled, this.onClickLabel, this.role, this.onClick, this.onLongClickLabel, this.onLongClick);
    }

    @Override
    public int hashCode() {
        int iM = UByte$.ExternalSyntheticBackport0.m(this.enabled) * 31;
        Role role = this.role;
        int iHashCode = (iM + (role != null ? role.hashCode() : 0)) * 31;
        String str = this.onLongClickLabel;
        int iHashCode2 = (iHashCode + (str != null ? str.hashCode() : 0)) * 31;
        Function0<Unit> function0 = this.onLongClick;
        int iHashCode3 = (iHashCode2 + (function0 != null ? function0.hashCode() : 0)) * 31;
        String str2 = this.onClickLabel;
        return ((iHashCode3 + (str2 != null ? str2.hashCode() : 0)) * 31) + this.onClick.hashCode();
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ClickableSemanticsElement)) {
            return false;
        }
        ClickableSemanticsElement clickableSemanticsElement = (ClickableSemanticsElement) other;
        return this.enabled == clickableSemanticsElement.enabled && Intrinsics.areEqual(this.role, clickableSemanticsElement.role) && Intrinsics.areEqual(this.onLongClickLabel, clickableSemanticsElement.onLongClickLabel) && this.onLongClick == clickableSemanticsElement.onLongClick && Intrinsics.areEqual(this.onClickLabel, clickableSemanticsElement.onClickLabel) && this.onClick == clickableSemanticsElement.onClick;
    }
}
