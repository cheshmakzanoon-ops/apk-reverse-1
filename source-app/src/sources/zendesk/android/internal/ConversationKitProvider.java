package zendesk.android.internal;

import android.content.Context;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.settings.internal.model.SunCoConfigDto;
import zendesk.android.settings.internal.model.WaitConfigDto;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitFactory;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.model.App;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.Integration;
import zendesk.conversationkit.android.model.RestRetryPolicy;
import zendesk.conversationkit.android.model.WaitTimeConfig;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J(\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0080@¢\u0006\u0004\b\u000b\u0010\fJ\u0019\u0010\r\u001a\u00020\u0006*\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\bH\u0000¢\u0006\u0002\b\u0010¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/internal/ConversationKitProvider;", "", "()V", "createConversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "conversationKitConfig", "Lzendesk/conversationkit/android/model/Config;", "integrationId", "", "context", "Landroid/content/Context;", "createConversationKit$zendesk_zendesk_android", "(Lzendesk/conversationkit/android/model/Config;Ljava/lang/String;Landroid/content/Context;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "toConversationKitConfig", "Lzendesk/android/settings/internal/model/SunCoConfigDto;", "settingsBaseUrl", "toConversationKitConfig$zendesk_zendesk_android", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKitProvider {
    public static final ConversationKitProvider INSTANCE = new ConversationKitProvider();

    private ConversationKitProvider() {
    }

    public final Object createConversationKit$zendesk_zendesk_android(Config config, String str, Context context, Continuation<? super ConversationKit> continuation) {
        return ConversationKitFactory.INSTANCE.from(context).create(ConversationKitSettings.INSTANCE.builder(str).build(), config, continuation);
    }

    public final Config toConversationKitConfig$zendesk_zendesk_android(SunCoConfigDto sunCoConfigDto, String settingsBaseUrl) {
        Integer queuePollingInterval;
        Intrinsics.checkNotNullParameter(sunCoConfigDto, "<this>");
        Intrinsics.checkNotNullParameter(settingsBaseUrl, "settingsBaseUrl");
        App app = new App(sunCoConfigDto.getApp().getId(), sunCoConfigDto.getApp().getStatus(), sunCoConfigDto.getApp().getName(), sunCoConfigDto.getApp().getSettings().isMultiConvoEnabled());
        String android = sunCoConfigDto.getBaseUrl().getAndroid();
        String id = sunCoConfigDto.getIntegration().getId();
        boolean canUserCreateMoreConversations = sunCoConfigDto.getIntegration().getCanUserCreateMoreConversations();
        boolean canUserSeeConversationList = sunCoConfigDto.getIntegration().getCanUserSeeConversationList();
        WaitConfigDto waitConfig = sunCoConfigDto.getIntegration().getWaitConfig();
        boolean waitTimeEnabled = waitConfig != null ? waitConfig.getWaitTimeEnabled() : false;
        WaitConfigDto waitConfig2 = sunCoConfigDto.getIntegration().getWaitConfig();
        boolean queuePositionEnabled = waitConfig2 != null ? waitConfig2.getQueuePositionEnabled() : false;
        WaitConfigDto waitConfig3 = sunCoConfigDto.getIntegration().getWaitConfig();
        boolean onlyDecreasingQueue = waitConfig3 != null ? waitConfig3.getOnlyDecreasingQueue() : false;
        WaitConfigDto waitConfig4 = sunCoConfigDto.getIntegration().getWaitConfig();
        Integer waitTimeOverride = waitConfig4 != null ? waitConfig4.getWaitTimeOverride() : null;
        WaitConfigDto waitConfig5 = sunCoConfigDto.getIntegration().getWaitConfig();
        return new Config(app, android, settingsBaseUrl, new Integration(id, canUserCreateMoreConversations, canUserSeeConversationList, new WaitTimeConfig(waitTimeEnabled, queuePositionEnabled, onlyDecreasingQueue, waitTimeOverride, (waitConfig5 == null || (queuePollingInterval = waitConfig5.getQueuePollingInterval()) == null) ? 60 : queuePollingInterval.intValue())), new RestRetryPolicy(sunCoConfigDto.getRestRetryPolicy().getIntervals().getRegular(), sunCoConfigDto.getRestRetryPolicy().getIntervals().getAggressive(), null, sunCoConfigDto.getRestRetryPolicy().getBackoffMultiplier(), sunCoConfigDto.getRestRetryPolicy().getMaxRetries(), 4, null));
    }
}
