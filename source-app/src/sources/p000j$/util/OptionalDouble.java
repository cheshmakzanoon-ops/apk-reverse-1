package p000j$.util;

import java.util.NoSuchElementException;

public final class OptionalDouble {
    private static final OptionalDouble EMPTY = new OptionalDouble();
    private final boolean isPresent;
    private final double value;

    private OptionalDouble() {
        this.isPresent = false;
        this.value = Double.NaN;
    }

    public static OptionalDouble empty() {
        return EMPTY;
    }

    private OptionalDouble(double d) {
        this.isPresent = true;
        this.value = d;
    }

    public static OptionalDouble m1721of(double d) {
        return new OptionalDouble(d);
    }

    public double getAsDouble() {
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
        if (!(obj instanceof OptionalDouble)) {
            return false;
        }
        OptionalDouble optionalDouble = (OptionalDouble) obj;
        boolean z = this.isPresent;
        if (z && optionalDouble.isPresent) {
            if (Double.compare(this.value, optionalDouble.value) == 0) {
                return true;
            }
        } else if (z == optionalDouble.isPresent) {
            return true;
        }
        return false;
    }

    public int hashCode() {
        if (this.isPresent) {
            return OptionalDouble$$ExternalSyntheticBackport0.m1722m(this.value);
        }
        return 0;
    }

    public String toString() {
        return this.isPresent ? String.format("OptionalDouble[%s]", Double.valueOf(this.value)) : "OptionalDouble.empty";
    }
}
