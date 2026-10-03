package net.aihelp.core.util.bus.event;

public class EventCenter<T> {
    private int code;
    private T event;

    public EventCenter() {
    }

    public EventCenter(int i) {
        this.code = i;
    }

    public EventCenter(T t) {
        this.event = t;
    }

    public EventCenter(int i, T t) {
        this.code = i;
        this.event = t;
    }

    public int getCode() {
        return this.code;
    }

    public void setCode(int i) {
        this.code = i;
    }

    public T getEvent() {
        return this.event;
    }

    public void setEvent(T t) {
        this.event = t;
    }
}
