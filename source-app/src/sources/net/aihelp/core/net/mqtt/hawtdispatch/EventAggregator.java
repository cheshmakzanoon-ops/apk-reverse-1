package net.aihelp.core.net.mqtt.hawtdispatch;

public interface EventAggregator<Event, MergedEvent> {
    MergedEvent mergeEvent(MergedEvent mergedevent, Event event);

    MergedEvent mergeEvents(MergedEvent mergedevent, MergedEvent mergedevent2);
}
