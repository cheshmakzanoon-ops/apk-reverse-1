package net.aihelp.core.net.mqtt.hawtdispatch;

public interface CustomDispatchSource<Event, MergedEvent> extends DispatchSource {
    MergedEvent getData();

    void merge(Event event);
}
