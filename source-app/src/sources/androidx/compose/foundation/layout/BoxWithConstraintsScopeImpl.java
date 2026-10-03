package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0082\b\u0018\u00002\u00020\u00012\u00020\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\t\u0010\u0015\u001a\u00020\u0004HÂ\u0003J\u0016\u0010\u0016\u001a\u00020\u0006HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\tJ'\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00042\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001aJ\u0013\u0010\u001b\u001a\u00020\u001c2\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eHÖ\u0003J\t\u0010\u001f\u001a\u00020 HÖ\u0001J\t\u0010!\u001a\u00020\"HÖ\u0001J\u0015\u0010#\u001a\u00020$*\u00020$2\u0006\u0010%\u001a\u00020&H\u0097\u0001J\r\u0010'\u001a\u00020$*\u00020$H\u0097\u0001R\u001c\u0010\u0005\u001a\u00020\u0006X\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\n\u001a\u0004\b\b\u0010\tR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u000b\u001a\u00020\f8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\f8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u000eR\u001a\u0010\u0011\u001a\u00020\f8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u000eR\u001a\u0010\u0013\u001a\u00020\f8VX\u0096\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u0014\u0010\u000e\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006("}, d2 = {"Landroidx/compose/foundation/layout/BoxWithConstraintsScopeImpl;", "Landroidx/compose/foundation/layout/BoxWithConstraintsScope;", "Landroidx/compose/foundation/layout/BoxScope;", "density", "Landroidx/compose/ui/unit/Density;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "(Landroidx/compose/ui/unit/Density;JLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getConstraints-msEJaDk", "()J", "J", "maxHeight", "Landroidx/compose/ui/unit/Dp;", "getMaxHeight-D9Ej5fM", "()F", "maxWidth", "getMaxWidth-D9Ej5fM", "minHeight", "getMinHeight-D9Ej5fM", "minWidth", "getMinWidth-D9Ej5fM", "component1", "component2", "component2-msEJaDk", "copy", "copy-0kLqBqw", "(Landroidx/compose/ui/unit/Density;J)Landroidx/compose/foundation/layout/BoxWithConstraintsScopeImpl;", "equals", "", "other", "", "hashCode", "", "toString", "", "align", "Landroidx/compose/ui/Modifier;", "alignment", "Landroidx/compose/ui/Alignment;", "matchParentSize", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class BoxWithConstraintsScopeImpl implements BoxWithConstraintsScope, BoxScope {
    private final BoxScopeInstance $$delegate_0;
    private final long constraints;
    private final Density density;

    public BoxWithConstraintsScopeImpl(Density density, long j, DefaultConstructorMarker defaultConstructorMarker) {
        this(density, j);
    }

    private final Density getDensity() {
        return this.density;
    }

    public static BoxWithConstraintsScopeImpl m946copy0kLqBqw$default(BoxWithConstraintsScopeImpl boxWithConstraintsScopeImpl, Density density, long j, int i, Object obj) {
        if ((i & 1) != 0) {
            density = boxWithConstraintsScopeImpl.density;
        }
        if ((i & 2) != 0) {
            j = boxWithConstraintsScopeImpl.constraints;
        }
        return boxWithConstraintsScopeImpl.m948copy0kLqBqw(density, j);
    }

    @Override
    public Modifier align(Modifier modifier, Alignment alignment) {
        return this.$$delegate_0.align(modifier, alignment);
    }

    public final long getConstraints() {
        return this.constraints;
    }

    public final BoxWithConstraintsScopeImpl m948copy0kLqBqw(Density density, long constraints) {
        return new BoxWithConstraintsScopeImpl(density, constraints, null);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof BoxWithConstraintsScopeImpl)) {
            return false;
        }
        BoxWithConstraintsScopeImpl boxWithConstraintsScopeImpl = (BoxWithConstraintsScopeImpl) other;
        return Intrinsics.areEqual(this.density, boxWithConstraintsScopeImpl.density) && Constraints.equals-impl0(this.constraints, boxWithConstraintsScopeImpl.constraints);
    }

    public int hashCode() {
        return (this.density.hashCode() * 31) + Constraints.hashCode-impl(this.constraints);
    }

    @Override
    public Modifier matchParentSize(Modifier modifier) {
        return this.$$delegate_0.matchParentSize(modifier);
    }

    public String toString() {
        return "BoxWithConstraintsScopeImpl(density=" + this.density + ", constraints=" + ((Object) Constraints.toString-impl(this.constraints)) + ')';
    }

    private BoxWithConstraintsScopeImpl(Density density, long j) {
        this.density = density;
        this.constraints = j;
        this.$$delegate_0 = BoxScopeInstance.INSTANCE;
    }

    @Override
    public long mo941getConstraintsmsEJaDk() {
        return this.constraints;
    }

    @Override
    public float mo945getMinWidthD9Ej5fM() {
        return this.density.toDp-u2uoSUM(Constraints.getMinWidth-impl(mo941getConstraintsmsEJaDk()));
    }

    @Override
    public float mo943getMaxWidthD9Ej5fM() {
        return Constraints.getHasBoundedWidth-impl(mo941getConstraintsmsEJaDk()) ? this.density.toDp-u2uoSUM(Constraints.getMaxWidth-impl(mo941getConstraintsmsEJaDk())) : Dp.Companion.getInfinity-D9Ej5fM();
    }

    @Override
    public float mo944getMinHeightD9Ej5fM() {
        return this.density.toDp-u2uoSUM(Constraints.getMinHeight-impl(mo941getConstraintsmsEJaDk()));
    }

    @Override
    public float mo942getMaxHeightD9Ej5fM() {
        return Constraints.getHasBoundedHeight-impl(mo941getConstraintsmsEJaDk()) ? this.density.toDp-u2uoSUM(Constraints.getMaxHeight-impl(mo941getConstraintsmsEJaDk())) : Dp.Companion.getInfinity-D9Ej5fM();
    }
}
