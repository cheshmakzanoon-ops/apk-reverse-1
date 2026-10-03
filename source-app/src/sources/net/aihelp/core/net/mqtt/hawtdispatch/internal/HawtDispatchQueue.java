package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.util.LinkedList;
import net.aihelp.core.net.mqtt.hawtdispatch.DispatchQueue;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public interface HawtDispatchQueue extends DispatchQueue {
    HawtDispatcher getDispatcher();

    LinkedList<Task> getSourceQueue();

    @Override
    HawtDispatchQueue getTargetQueue();

    GlobalDispatchQueue isGlobalDispatchQueue();

    SerialDispatchQueue isSerialDispatchQueue();

    ThreadDispatchQueue isThreadDispatchQueue();

    public final class CC {
    }
}
