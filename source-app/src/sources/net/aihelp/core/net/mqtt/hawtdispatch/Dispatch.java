package net.aihelp.core.net.mqtt.hawtdispatch;

import java.nio.channels.SelectableChannel;
import java.util.List;
import net.aihelp.core.net.mqtt.hawtdispatch.internal.DispatcherConfig;

public class Dispatch {
    private static final Dispatcher DISPATCHER = DispatcherConfig.getDefaultDispatcher();
    public static final DispatchPriority HIGH = DispatchPriority.HIGH;
    public static final DispatchPriority DEFAULT = DispatchPriority.DEFAULT;
    public static final DispatchPriority LOW = DispatchPriority.LOW;
    public static final Task NOOP = new Task() {
        @Override
        public void run() {
        }
    };

    public static DispatchQueue getGlobalQueue() {
        return DISPATCHER.getGlobalQueue();
    }

    public static DispatchQueue getGlobalQueue(DispatchPriority dispatchPriority) {
        return DISPATCHER.getGlobalQueue(dispatchPriority);
    }

    public static DispatchQueue createQueue(String str) {
        return DISPATCHER.createQueue(str);
    }

    public static DispatchQueue createQueue() {
        return DISPATCHER.createQueue(null);
    }

    public static DispatchQueue getCurrentQueue() {
        return DISPATCHER.getCurrentQueue();
    }

    public static DispatchSource createSource(SelectableChannel selectableChannel, int i, DispatchQueue dispatchQueue) {
        return DISPATCHER.createSource(selectableChannel, i, dispatchQueue);
    }

    public static <Event, MergedEvent> CustomDispatchSource<Event, MergedEvent> createSource(EventAggregator<Event, MergedEvent> eventAggregator, DispatchQueue dispatchQueue) {
        return DISPATCHER.createSource(eventAggregator, dispatchQueue);
    }

    public static DispatchQueue[] getThreadQueues(DispatchPriority dispatchPriority) {
        return DISPATCHER.getThreadQueues(dispatchPriority);
    }

    public static DispatchQueue getCurrentThreadQueue() {
        return DISPATCHER.getCurrentThreadQueue();
    }

    public static void profile(boolean z) {
        DISPATCHER.profile(z);
    }

    public static List<Metrics> metrics() {
        return DISPATCHER.metrics();
    }

    public static void shutdown() {
        DISPATCHER.shutdown();
    }

    public static void restart() {
        DISPATCHER.restart();
    }
}
