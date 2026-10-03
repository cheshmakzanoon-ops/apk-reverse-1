package net.aihelp.core.net.mqtt.hawtdispatch.internal.util;

public class IntegerCounter {
    int counter;

    public IntegerCounter() {
    }

    public IntegerCounter(int i) {
        this.counter = i;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        return obj != null && getClass() == obj.getClass() && this.counter == ((IntegerCounter) obj).counter;
    }

    public int hashCode() {
        return 31 + this.counter;
    }

    public final int addAndGet(int i) {
        int i2 = this.counter + i;
        this.counter = i2;
        return i2;
    }

    public final int decrementAndGet() {
        int i = this.counter - 1;
        this.counter = i;
        return i;
    }

    public final int get() {
        return this.counter;
    }

    public final int getAndAdd(int i) {
        int i2 = this.counter;
        this.counter = i + i2;
        return i2;
    }

    public final int getAndDecrement() {
        int i = this.counter;
        this.counter = i - 1;
        return i;
    }

    public final int getAndIncrement() {
        int i = this.counter;
        this.counter = i + 1;
        return i;
    }

    public final int getAndSet(int i) {
        int i2 = this.counter;
        this.counter = i;
        return i2;
    }

    public final int incrementAndGet() {
        int i = this.counter + 1;
        this.counter = i;
        return i;
    }

    public int intValue() {
        return this.counter;
    }

    public final void set(int i) {
        this.counter = i;
    }

    public String toString() {
        return Integer.toString(this.counter);
    }
}
