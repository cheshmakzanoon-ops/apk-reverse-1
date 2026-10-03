package zendesk.messaging.android.internal.conversationscreen.p020di;

import android.content.Context;
import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleOwnerKt;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.NewMessagesDividerHandler;
import zendesk.messaging.android.internal.UploadFileResourceProvider;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationscreen.ConversationTypingEvents;
import zendesk.messaging.android.internal.conversationscreen.MessageLogEntryMapper;
import zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService;

@Metadata(m17d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002Jj\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\b\u0010\u000f\u001a\u0004\u0018\u00010\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00162\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001cH\u0007J\u0010\u0010\u001d\u001a\u00020\u00142\u0006\u0010\u001e\u001a\u00020\u001fH\u0007¨\u0006 "}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/di/ConversationScreenModule;", "", "()V", "providesConversationViewModelFactory", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "messageLogEntryMapper", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;", "newMessagesDividerHandler", "Lzendesk/messaging/android/internal/NewMessagesDividerHandler;", "activity", "Landroidx/appcompat/app/AppCompatActivity;", "savedStateRegistryOwner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "sdkCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "uploadFileResourceProvider", "Lzendesk/messaging/android/internal/UploadFileResourceProvider;", "conversationScreenRepository", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;", "conversationTitleProvider", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "providesResourceProvider", "context", "Landroid/content/Context;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ConversationScreenModule {
    @Provides
    public final UploadFileResourceProvider providesResourceProvider(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        return new UploadFileResourceProvider(context);
    }

    @Provides
    public final ConversationScreenViewModelFactory providesConversationViewModelFactory(MessagingSettings messagingSettings, MessageLogEntryMapper messageLogEntryMapper, NewMessagesDividerHandler newMessagesDividerHandler, AppCompatActivity activity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle defaultArgs, CoroutineScope sdkCoroutineScope, UploadFileResourceProvider uploadFileResourceProvider, ConversationScreenRepository conversationScreenRepository, ConversationTitleProvider conversationTitleProvider, FeatureFlagManager featureFlagManager, ConversationKit conversationKit) {
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(messageLogEntryMapper, "messageLogEntryMapper");
        Intrinsics.checkNotNullParameter(newMessagesDividerHandler, "newMessagesDividerHandler");
        Intrinsics.checkNotNullParameter(activity, "activity");
        Intrinsics.checkNotNullParameter(savedStateRegistryOwner, "savedStateRegistryOwner");
        Intrinsics.checkNotNullParameter(sdkCoroutineScope, "sdkCoroutineScope");
        Intrinsics.checkNotNullParameter(uploadFileResourceProvider, "uploadFileResourceProvider");
        Intrinsics.checkNotNullParameter(conversationScreenRepository, "conversationScreenRepository");
        Intrinsics.checkNotNullParameter(conversationTitleProvider, "conversationTitleProvider");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        return new ConversationScreenViewModelFactory(messagingSettings, messageLogEntryMapper, newMessagesDividerHandler, VisibleScreenTracker.INSTANCE, sdkCoroutineScope, uploadFileResourceProvider, conversationScreenRepository, new ConversationTypingEvents(ProcessLifecycleEventObserver.INSTANCE.newInstance(), LifecycleOwnerKt.getLifecycleScope((LifecycleOwner) activity), VisibleScreenTracker.INSTANCE, sdkCoroutineScope), conversationTitleProvider, featureFlagManager, new WaitTimeBannerService(conversationKit, sdkCoroutineScope), savedStateRegistryOwner, defaultArgs);
    }
}
