package androidx.compose.foundation.text.input.internal;

import kotlin.Metadata;

@Metadata(d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0080\b\u0018\u00002\u00020\u0001B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0015\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0011\u001a\u00020\u0012HÖ\u0001J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\t¨\u0006\u0015"}, d2 = {"Landroidx/compose/foundation/text/input/internal/SelectionWedgeAffinity;", "", "affinity", "Landroidx/compose/foundation/text/input/internal/WedgeAffinity;", "(Landroidx/compose/foundation/text/input/internal/WedgeAffinity;)V", "startAffinity", "endAffinity", "(Landroidx/compose/foundation/text/input/internal/WedgeAffinity;Landroidx/compose/foundation/text/input/internal/WedgeAffinity;)V", "getEndAffinity", "()Landroidx/compose/foundation/text/input/internal/WedgeAffinity;", "getStartAffinity", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SelectionWedgeAffinity {
    public static final int $stable = 0;
    private final WedgeAffinity endAffinity;
    private final WedgeAffinity startAffinity;

    public static SelectionWedgeAffinity copy$default(SelectionWedgeAffinity selectionWedgeAffinity, WedgeAffinity wedgeAffinity, WedgeAffinity wedgeAffinity2, int i, Object obj) {
        if ((i & 1) != 0) {
            wedgeAffinity = selectionWedgeAffinity.startAffinity;
        }
        if ((i & 2) != 0) {
            wedgeAffinity2 = selectionWedgeAffinity.endAffinity;
        }
        return selectionWedgeAffinity.copy(wedgeAffinity, wedgeAffinity2);
    }

    public final WedgeAffinity getStartAffinity() {
        return this.startAffinity;
    }

    public final WedgeAffinity getEndAffinity() {
        return this.endAffinity;
    }

    public final SelectionWedgeAffinity copy(WedgeAffinity startAffinity, WedgeAffinity endAffinity) {
        return new SelectionWedgeAffinity(startAffinity, endAffinity);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof SelectionWedgeAffinity)) {
            return false;
        }
        SelectionWedgeAffinity selectionWedgeAffinity = (SelectionWedgeAffinity) other;
        return this.startAffinity == selectionWedgeAffinity.startAffinity && this.endAffinity == selectionWedgeAffinity.endAffinity;
    }

    public int hashCode() {
        return (this.startAffinity.hashCode() * 31) + this.endAffinity.hashCode();
    }

    public String toString() {
        return "SelectionWedgeAffinity(startAffinity=" + this.startAffinity + ", endAffinity=" + this.endAffinity + ')';
    }

    public SelectionWedgeAffinity(WedgeAffinity wedgeAffinity, WedgeAffinity wedgeAffinity2) {
        this.startAffinity = wedgeAffinity;
        this.endAffinity = wedgeAffinity2;
    }

    public final WedgeAffinity getStartAffinity() {
        return this.startAffinity;
    }

    public final WedgeAffinity getEndAffinity() {
        return this.endAffinity;
    }

    public SelectionWedgeAffinity(WedgeAffinity wedgeAffinity) {
        this(wedgeAffinity, wedgeAffinity);
    }
}
