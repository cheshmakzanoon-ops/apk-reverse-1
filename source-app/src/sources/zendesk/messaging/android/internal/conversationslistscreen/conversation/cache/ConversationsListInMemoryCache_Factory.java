package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import dagger.internal.Factory;

public final class ConversationsListInMemoryCache_Factory implements Factory<ConversationsListInMemoryCache> {
    @Override
    public ConversationsListInMemoryCache get() {
        return newInstance();
    }

    public static ConversationsListInMemoryCache_Factory create() {
        return InstanceHolder.INSTANCE;
    }

    public static ConversationsListInMemoryCache newInstance() {
        return new ConversationsListInMemoryCache();
    }

    private static final class InstanceHolder {
        private static final ConversationsListInMemoryCache_Factory INSTANCE = new ConversationsListInMemoryCache_Factory();

        private InstanceHolder() {
        }
    }
}
