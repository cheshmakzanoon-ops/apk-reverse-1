package zendesk.android.internal.frontendevents.analyticsevents;

import java.util.UUID;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.Triple;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.internal.frontendevents.FrontendEventsRepository;
import zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveCampaignAnalyticsAction;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.model.ProactiveMessageStatus;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\b\u0001\u0018\u00002\u00020\u0001B\u001f\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0006\u0010\u000b\u001a\u00020\fR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/android/internal/frontendevents/analyticsevents/ProactiveMessagingAnalyticsManager;", "", "frontendEventsRepository", "Lzendesk/android/internal/frontendevents/FrontendEventsRepository;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "(Lzendesk/android/internal/frontendevents/FrontendEventsRepository;Lkotlinx/coroutines/CoroutineScope;Lzendesk/conversationkit/android/ConversationKit;)V", "visitorId", "", "subscribe", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveMessagingAnalyticsManager {
    private final ConversationKit conversationKit;
    private final CoroutineScope coroutineScope;
    private final FrontendEventsRepository frontendEventsRepository;
    private final String visitorId;

    @Inject
    public ProactiveMessagingAnalyticsManager(FrontendEventsRepository frontendEventsRepository, CoroutineScope coroutineScope, ConversationKit conversationKit) {
        Intrinsics.checkNotNullParameter(frontendEventsRepository, "frontendEventsRepository");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        this.frontendEventsRepository = frontendEventsRepository;
        this.coroutineScope = coroutineScope;
        this.conversationKit = conversationKit;
        String string = UUID.randomUUID().toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        this.visitorId = string;
    }

    public final void subscribe() {
        this.conversationKit.addEventListener(new ConversationKitEventListener() {
            @Override
            public final void onEvent(ConversationKitEvent conversationKitEvent) {
                ProactiveMessagingAnalyticsManager.subscribe$lambda$0(this.f$0, conversationKitEvent);
            }
        });
    }

    public static final void subscribe$lambda$0(ProactiveMessagingAnalyticsManager this$0, ConversationKitEvent event) {
        Triple triple;
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(event, "event");
        if (event instanceof ConversationKitEvent.ProactiveMessageStatusChanged) {
            ProactiveMessageStatus status = ((ConversationKitEvent.ProactiveMessageStatusChanged) event).getStatus();
            if (status instanceof ProactiveMessageStatus.NotificationHasBeenDisplayed) {
                ProactiveMessageStatus.NotificationHasBeenDisplayed notificationHasBeenDisplayed = (ProactiveMessageStatus.NotificationHasBeenDisplayed) status;
                triple = new Triple(ProactiveCampaignAnalyticsAction.SENT, notificationHasBeenDisplayed.getProactiveMessage().getCampaignId(), Integer.valueOf(notificationHasBeenDisplayed.getProactiveMessage().getCampaignVersion()));
            } else if (status instanceof ProactiveMessageStatus.ConversationHasBeenRepliedTo) {
                ProactiveMessageStatus.ConversationHasBeenRepliedTo conversationHasBeenRepliedTo = (ProactiveMessageStatus.ConversationHasBeenRepliedTo) status;
                triple = new Triple(ProactiveCampaignAnalyticsAction.REPLIED_TO, conversationHasBeenRepliedTo.getProactiveMessage().getCampaignId(), Integer.valueOf(conversationHasBeenRepliedTo.getProactiveMessage().getCampaignVersion()));
            } else if (status instanceof ProactiveMessageStatus.NotificationHasBeenClicked) {
                ProactiveMessageStatus.NotificationHasBeenClicked notificationHasBeenClicked = (ProactiveMessageStatus.NotificationHasBeenClicked) status;
                triple = new Triple(ProactiveCampaignAnalyticsAction.OPENED, notificationHasBeenClicked.getProactiveMessage().getCampaignId(), Integer.valueOf(notificationHasBeenClicked.getProactiveMessage().getCampaignVersion()));
            } else {
                triple = null;
            }
            if (triple != null) {
                ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction = (ProactiveCampaignAnalyticsAction) triple.component1();
                BuildersKt__Builders_commonKt.launch$default(this$0.coroutineScope, null, null, new ProactiveMessagingAnalyticsManager$subscribe$1$1(this$0, (String) triple.component2(), proactiveCampaignAnalyticsAction, ((Number) triple.component3()).intValue(), null), 3, null);
            }
        }
    }
}
