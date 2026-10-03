package net.aihelp.core.util.bus.meta;

import net.aihelp.core.util.bus.SubscriberMethod;

public interface SubscriberInfo {
    Class<?> getSubscriberClass();

    SubscriberMethod[] getSubscriberMethods();

    SubscriberInfo getSuperSubscriberInfo();

    boolean shouldCheckSuperclass();
}
