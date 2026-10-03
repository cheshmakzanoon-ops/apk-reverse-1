package p000j$.util;

import java.util.NoSuchElementException;

public final class OptionalLong {
    private static final OptionalLong EMPTY = new OptionalLong();
    private final boolean isPresent;
    private final long value;

    private OptionalLong() {
        this.isPresent = false;
        this.value = 0L;
    }

    public static OptionalLong empty() {
        return EMPTY;
    }

    private OptionalLong(long j) {
        this.isPresent = true;
        this.value = j;
    }

    public static OptionalLong m1724of(long j) {
        return new OptionalLong(j);
    }

    public long getAsLong() {
        if (!this.isPresent) {
            throw new NoSuchElementException("No value present");
        }
        return this.value;
    }

    public boolean isPresent() {
        return this.isPresent;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof OptionalLong)) {
            return false;
        }
        OptionalLong optionalLong = (OptionalLong) obj;
        boolean z = this.isPresent;
        if (z && optionalLong.isPresent) {
            if (this.value == optionalLong.value) {
                return true;
            }
        } else if (z == optionalLong.isPresent) {
            return true;
        }
        return false;
    }

    public int hashCode() {
        if (this.isPresent) {
            return OptionalLong$$ExternalSyntheticBackport0.m1725m(this.value);
        }
        return 0;
    }

    public String toString() {
        return this.isPresent ? String.format("OptionalLong[%s]", Long.valueOf(this.value)) : "OptionalLong.empty";
    }
}
