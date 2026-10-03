package zendesk.messaging.android.internal.conversationscreen;

import android.os.Bundle;
import androidx.lifecycle.AbstractSavedStateViewModelFactory;
import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.savedstate.SavedStateRegistryOwner;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.NewMessagesDividerHandler;
import zendesk.messaging.android.internal.UploadFileResourceProvider;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService;

@Metadata(m17d1 = {"\u0000t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001Bq\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\u0006\u0010\u0012\u001a\u00020\u0013\u0012\u0006\u0010\u0014\u001a\u00020\u0015\u0012\u0006\u0010\u0016\u001a\u00020\u0017\u0012\u0006\u0010\u0018\u001a\u00020\u0019\u0012\n\b\u0002\u0010\u001a\u001a\u0004\u0018\u00010\u001b¢\u0006\u0002\u0010\u001cJ5\u0010\u001d\u001a\u0002H\u001e\"\b\b\u0000\u0010\u001e*\u00020\u001f2\u0006\u0010 \u001a\u00020!2\f\u0010\"\u001a\b\u0012\u0004\u0012\u0002H\u001e0#2\u0006\u0010$\u001a\u00020%H\u0014¢\u0006\u0002\u0010&R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0016\u001a\u00020\u0017X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006'"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModelFactory;", "Landroidx/lifecycle/AbstractSavedStateViewModelFactory;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "messageLogEntryMapper", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;", "newMessagesDividerHandler", "Lzendesk/messaging/android/internal/NewMessagesDividerHandler;", "visibleScreenTracker", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "sdkCoroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "uploadFileResourceProvider", "Lzendesk/messaging/android/internal/UploadFileResourceProvider;", "conversationScreenRepository", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;", "typingEvents", "Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;", "conversationTitleProvider", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "waitTimeBannerService", "Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;", "owner", "Landroidx/savedstate/SavedStateRegistryOwner;", "defaultArgs", "Landroid/os/Bundle;", "(Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;Lzendesk/messaging/android/internal/NewMessagesDividerHandler;Lzendesk/messaging/android/internal/VisibleScreenTracker;Lkotlinx/coroutines/CoroutineScope;Lzendesk/messaging/android/internal/UploadFileResourceProvider;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;Lzendesk/messaging/android/internal/ConversationTitleProvider;Lzendesk/core/android/internal/app/FeatureFlagManager;Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;Landroidx/savedstate/SavedStateRegistryOwner;Landroid/os/Bundle;)V", "create", "T", "Landroidx/lifecycle/ViewModel;", "key", "", "modelClass", "Ljava/lang/Class;", "savedStateHandle", "Landroidx/lifecycle/SavedStateHandle;", "(Ljava/lang/String;Ljava/lang/Class;Landroidx/lifecycle/SavedStateHandle;)Landroidx/lifecycle/ViewModel;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenViewModelFactory extends AbstractSavedStateViewModelFactory {
    private final ConversationScreenRepository conversationScreenRepository;
    private final ConversationTitleProvider conversationTitleProvider;
    private final FeatureFlagManager featureFlagManager;
    private final MessageLogEntryMapper messageLogEntryMapper;
    private final MessagingSettings messagingSettings;
    private final NewMessagesDividerHandler newMessagesDividerHandler;
    private final CoroutineScope sdkCoroutineScope;
    private final ConversationTypingEvents typingEvents;
    private final UploadFileResourceProvider uploadFileResourceProvider;
    private final VisibleScreenTracker visibleScreenTracker;
    private final WaitTimeBannerService waitTimeBannerService;

    public ConversationScreenViewModelFactory(MessagingSettings messagingSettings, MessageLogEntryMapper messageLogEntryMapper, NewMessagesDividerHandler newMessagesDividerHandler, VisibleScreenTracker visibleScreenTracker, CoroutineScope coroutineScope, UploadFileResourceProvider uploadFileResourceProvider, ConversationScreenRepository conversationScreenRepository, ConversationTypingEvents conversationTypingEvents, ConversationTitleProvider conversationTitleProvider, FeatureFlagManager featureFlagManager, WaitTimeBannerService waitTimeBannerService, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(messagingSettings, messageLogEntryMapper, newMessagesDividerHandler, visibleScreenTracker, coroutineScope, uploadFileResourceProvider, conversationScreenRepository, conversationTypingEvents, conversationTitleProvider, featureFlagManager, waitTimeBannerService, savedStateRegistryOwner, (i & 4096) != 0 ? null : bundle);
    }

    public ConversationScreenViewModelFactory(MessagingSettings messagingSettings, MessageLogEntryMapper messageLogEntryMapper, NewMessagesDividerHandler newMessagesDividerHandler, VisibleScreenTracker visibleScreenTracker, CoroutineScope sdkCoroutineScope, UploadFileResourceProvider uploadFileResourceProvider, ConversationScreenRepository conversationScreenRepository, ConversationTypingEvents typingEvents, ConversationTitleProvider conversationTitleProvider, FeatureFlagManager featureFlagManager, WaitTimeBannerService waitTimeBannerService, SavedStateRegistryOwner owner, Bundle bundle) {
        super(owner, bundle);
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(messageLogEntryMapper, "messageLogEntryMapper");
        Intrinsics.checkNotNullParameter(newMessagesDividerHandler, "newMessagesDividerHandler");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        Intrinsics.checkNotNullParameter(sdkCoroutineScope, "sdkCoroutineScope");
        Intrinsics.checkNotNullParameter(uploadFileResourceProvider, "uploadFileResourceProvider");
        Intrinsics.checkNotNullParameter(conversationScreenRepository, "conversationScreenRepository");
        Intrinsics.checkNotNullParameter(typingEvents, "typingEvents");
        Intrinsics.checkNotNullParameter(conversationTitleProvider, "conversationTitleProvider");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        Intrinsics.checkNotNullParameter(waitTimeBannerService, "waitTimeBannerService");
        Intrinsics.checkNotNullParameter(owner, "owner");
        this.messagingSettings = messagingSettings;
        this.messageLogEntryMapper = messageLogEntryMapper;
        this.newMessagesDividerHandler = newMessagesDividerHandler;
        this.visibleScreenTracker = visibleScreenTracker;
        this.sdkCoroutineScope = sdkCoroutineScope;
        this.uploadFileResourceProvider = uploadFileResourceProvider;
        this.conversationScreenRepository = conversationScreenRepository;
        this.typingEvents = typingEvents;
        this.conversationTitleProvider = conversationTitleProvider;
        this.featureFlagManager = featureFlagManager;
        this.waitTimeBannerService = waitTimeBannerService;
    }

    protected <T extends ViewModel> T create(String key, Class<T> modelClass, SavedStateHandle savedStateHandle) {
        Intrinsics.checkNotNullParameter(key, "key");
        Intrinsics.checkNotNullParameter(modelClass, "modelClass");
        Intrinsics.checkNotNullParameter(savedStateHandle, "savedStateHandle");
        return new ConversationScreenViewModel(this.messagingSettings, this.messageLogEntryMapper, this.newMessagesDividerHandler, savedStateHandle, this.visibleScreenTracker, this.sdkCoroutineScope, this.uploadFileResourceProvider, this.conversationScreenRepository, this.typingEvents, this.conversationTitleProvider, this.featureFlagManager, this.waitTimeBannerService);
    }
}
