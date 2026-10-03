package p000j$.util;

import java.util.NoSuchElementException;

public final class Optional<T> {
    private static final Optional EMPTY = new Optional();
    private final Object value;

    private Optional() {
        this.value = null;
    }

    public static Optional empty() {
        return EMPTY;
    }

    private Optional(Object obj) {
        this.value = Objects.requireNonNull(obj);
    }

    public static Optional m1720of(Object obj) {
        return new Optional(obj);
    }

    public static <T> Optional<T> ofNullable(T t) {
        return t == null ? empty() : m1720of(t);
    }

    public T get() {
        T t = (T) this.value;
        if (t != null) {
            return t;
        }
        throw new NoSuchElementException("No value present");
    }

    public boolean isPresent() {
        return this.value != null;
    }

    public T orElse(T t) {
        T t2 = (T) this.value;
        return t2 != null ? t2 : t;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof Optional) {
            return Objects.equals(this.value, ((Optional) obj).value);
        }
        return false;
    }

    public int hashCode() {
        return Objects.hashCode(this.value);
    }

    public String toString() {
        Object obj = this.value;
        if (obj != null) {
            return String.format("Optional[%s]", obj);
        }
        return "Optional.empty";
    }
}
