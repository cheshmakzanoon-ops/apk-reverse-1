package com.google.common.collect;

@ElementTypesAreNonnullByDefault
public enum BoundType {
    OPEN(false),
    CLOSED(true);

    final boolean inclusive;

    BoundType(boolean z) {
        this.inclusive = z;
    }

    static BoundType forBoolean(boolean z) {
        return z ? CLOSED : OPEN;
    }
}
