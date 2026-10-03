package zendesk.messaging.android.internal.conversationscreen.p020di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.UploadFileResourceProvider;

public final class ConversationScreenModule_ProvidesResourceProviderFactory implements Factory<UploadFileResourceProvider> {
    private final Provider<Context> contextProvider;
    private final ConversationScreenModule module;

    public ConversationScreenModule_ProvidesResourceProviderFactory(ConversationScreenModule conversationScreenModule, Provider<Context> provider) {
        this.module = conversationScreenModule;
        this.contextProvider = provider;
    }

    @Override
    public UploadFileResourceProvider get() {
        return providesResourceProvider(this.module, this.contextProvider.get());
    }

    public static ConversationScreenModule_ProvidesResourceProviderFactory create(ConversationScreenModule conversationScreenModule, Provider<Context> provider) {
        return new ConversationScreenModule_ProvidesResourceProviderFactory(conversationScreenModule, provider);
    }

    public static UploadFileResourceProvider providesResourceProvider(ConversationScreenModule conversationScreenModule, Context context) {
        return (UploadFileResourceProvider) Preconditions.checkNotNullFromProvides(conversationScreenModule.providesResourceProvider(context));
    }
}
