package zendesk.messaging.android.internal.p023di;

import android.content.Context;
import dagger.BindsInstance;
import dagger.Component;
import j$.time.LocalDateTime;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.ZendeskCredentials;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di.ConversationExtensionFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideArticleFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideArticleViewerModule;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di.GuideKitModule;
import zendesk.messaging.android.internal.conversationscreen.p020di.ConversationFragmentComponent;
import zendesk.messaging.android.internal.conversationscreen.p020di.ImageViewerComponent;
import zendesk.messaging.android.internal.conversationslistscreen.p022di.ConversationListFragmentComponent;
import zendesk.messaging.android.internal.rest.NetworkModule;
import zendesk.messaging.android.internal.validation.ConversationFieldManager;
import zendesk.messaging.android.internal.validation.p025di.ConversationFieldModule;

@Component(modules = {StorageModule.class, NetworkModule.class, ConversationFieldModule.class, CoroutineDispatchersModule.class, GuideKitModule.class, GuideArticleViewerModule.class, KotlinxSerializationModule.class, MessagingDateFormatModule.class})
@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\u0012J\b\u0010\u0002\u001a\u00020\u0003H&J\b\u0010\u0004\u001a\u00020\u0005H&J\b\u0010\u0006\u001a\u00020\u0007H&J\b\u0010\b\u001a\u00020\tH&J\b\u0010\n\u001a\u00020\u000bH&J\b\u0010\f\u001a\u00020\rH&J\b\u0010\u000e\u001a\u00020\u000fH'J\b\u0010\u0010\u001a\u00020\u0011H&¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/di/MessagingComponent;", "", "conversationExtensionFragmentComponent", "Lzendesk/messaging/android/internal/conversationscreen/conversationextension/di/ConversationExtensionFragmentComponent$Factory;", "conversationFieldManager", "Lzendesk/messaging/android/internal/validation/ConversationFieldManager;", "conversationFragmentComponent", "Lzendesk/messaging/android/internal/conversationscreen/di/ConversationFragmentComponent$Factory;", "conversationListFragmentComponent", "Lzendesk/messaging/android/internal/conversationslistscreen/di/ConversationListFragmentComponent$Factory;", "guideArticleFragmentComponent", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/di/GuideArticleFragmentComponent$Factory;", "imageViewerActivityComponent", "Lzendesk/messaging/android/internal/conversationscreen/di/ImageViewerComponent$Factory;", "mainDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "messagingActivityComponent", "Lzendesk/messaging/android/internal/di/MessagingActivityComponent$Factory;", "Factory", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@MessagingScope
public interface MessagingComponent {

    @Component.Factory
    @Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\bg\u0018\u00002\u00020\u0001J¯\u0001\u0010\u001d\u001a\u00020\u001c2\b\b\u0001\u0010\u0003\u001a\u00020\u00022\b\b\u0001\u0010\u0005\u001a\u00020\u00042\b\b\u0001\u0010\u0007\u001a\u00020\u00062\b\b\u0001\u0010\t\u001a\u00020\b2\b\b\u0001\u0010\u000b\u001a\u00020\n2$\b\u0001\u0010\u0010\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\r\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000f0\u000e\u0012\u0006\u0012\u0004\u0018\u00010\u00010\f2\b\b\u0001\u0010\u0012\u001a\u00020\u00112\b\b\u0001\u0010\u0014\u001a\u00020\u00132\b\b\u0001\u0010\u0015\u001a\u00020\u00132\b\b\u0001\u0010\u0017\u001a\u00020\u00162\u000e\b\u0001\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00190\u00182\u000e\b\u0001\u0010\u001b\u001a\b\u0012\u0004\u0012\u00020\u00060\u0018H&¢\u0006\u0004\b\u001d\u0010\u001e¨\u0006\u001f"}, m18d2 = {"Lzendesk/messaging/android/internal/di/MessagingComponent$Factory;", "", "Landroid/content/Context;", "context", "Lzendesk/android/ZendeskCredentials;", "zendeskCredentials", "", "baseUrl", "Lzendesk/android/messaging/model/MessagingSettings;", "messagingSettings", "Lzendesk/conversationkit/android/ConversationKit;", "conversationKit", "Lkotlin/Function2;", "Lzendesk/android/events/ZendeskEvent;", "Lkotlin/coroutines/Continuation;", "", "dispatchEvent", "Lkotlinx/coroutines/CoroutineScope;", "coroutineScope", "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_LIGHT_COLORS, MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/core/android/internal/app/FeatureFlagManager;", "featureFlagManager", "Lkotlin/Function0;", "j$/time/LocalDateTime", MessagingComponentKt.CURRENT_TIME_PROVIDER, MessagingComponentKt.ID_PROVIDER, "Lzendesk/messaging/android/internal/di/MessagingComponent;", "create", "(Landroid/content/Context;Lzendesk/android/ZendeskCredentials;Ljava/lang/String;Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/conversationkit/android/ConversationKit;Lkotlin/jvm/functions/Function2;Lkotlinx/coroutines/CoroutineScope;Lzendesk/android/messaging/model/UserColors;Lzendesk/android/messaging/model/UserColors;Lzendesk/core/android/internal/app/FeatureFlagManager;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function0;)Lzendesk/messaging/android/internal/di/MessagingComponent;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public interface Factory {
        MessagingComponent create(@BindsInstance Context context, @BindsInstance ZendeskCredentials zendeskCredentials, @BindsInstance @Named("baseUrl") String baseUrl, @BindsInstance MessagingSettings messagingSettings, @BindsInstance ConversationKit conversationKit, @BindsInstance Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ? extends Object> dispatchEvent, @BindsInstance CoroutineScope coroutineScope, @BindsInstance @Named(MessagingComponentKt.USER_LIGHT_COLORS) UserColors userLightColors, @BindsInstance @Named(MessagingComponentKt.USER_DARK_COLORS) UserColors userDarkColors, @BindsInstance FeatureFlagManager featureFlagManager, @BindsInstance @Named(MessagingComponentKt.CURRENT_TIME_PROVIDER) Function0<LocalDateTime> currentTimeProvider, @BindsInstance @Named(MessagingComponentKt.ID_PROVIDER) Function0<String> idProvider);
    }

    ConversationExtensionFragmentComponent.Factory conversationExtensionFragmentComponent();

    ConversationFieldManager conversationFieldManager();

    ConversationFragmentComponent.Factory conversationFragmentComponent();

    ConversationListFragmentComponent.Factory conversationListFragmentComponent();

    GuideArticleFragmentComponent.Factory guideArticleFragmentComponent();

    ImageViewerComponent.Factory imageViewerActivityComponent();

    @Named(CoroutineDispatchersModule.MAIN_DISPATCHER)
    CoroutineDispatcher mainDispatcher();

    MessagingActivityComponent.Factory messagingActivityComponent();
}
