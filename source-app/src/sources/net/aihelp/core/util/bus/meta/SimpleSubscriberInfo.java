package net.aihelp.core.util.bus.meta;

import net.aihelp.core.util.bus.SubscriberMethod;

public class SimpleSubscriberInfo extends AbstractSubscriberInfo {
    private final SubscriberMethodInfo[] methodInfos;

    public SimpleSubscriberInfo(Class cls, boolean z, SubscriberMethodInfo[] subscriberMethodInfoArr) {
        super(cls, null, z);
        this.methodInfos = subscriberMethodInfoArr;
    }

    @Override
    public synchronized SubscriberMethod[] getSubscriberMethods() {
        SubscriberMethod[] subscriberMethodArr;
        int length = this.methodInfos.length;
        subscriberMethodArr = new SubscriberMethod[length];
        for (int i = 0; i < length; i++) {
            SubscriberMethodInfo subscriberMethodInfo = this.methodInfos[i];
            subscriberMethodArr[i] = createSubscriberMethod(subscriberMethodInfo.methodName, subscriberMethodInfo.eventType, subscriberMethodInfo.threadMode, subscriberMethodInfo.priority, subscriberMethodInfo.sticky);
        }
        return subscriberMethodArr;
    }
}
