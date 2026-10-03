package net.aihelp.core.net.mqtt.hawtdispatch;

import java.nio.channels.SelectableChannel;
import java.util.List;

public interface Dispatcher {
    DispatchQueue createQueue(String str);

    <Event, MergedEvent> CustomDispatchSource<Event, MergedEvent> createSource(EventAggregator<Event, MergedEvent> eventAggregator, DispatchQueue dispatchQueue);

    DispatchSource createSource(SelectableChannel selectableChannel, int i, DispatchQueue dispatchQueue);

    DispatchQueue getCurrentQueue();

    DispatchQueue getCurrentThreadQueue();

    DispatchQueue getGlobalQueue();

    DispatchQueue getGlobalQueue(DispatchPriority dispatchPriority);

    DispatchQueue[] getThreadQueues(DispatchPriority dispatchPriority);

    List<Metrics> metrics();

    void profile(boolean z);

    boolean profile();

    void restart();

    void shutdown();
}
