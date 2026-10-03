package zendesk.android.internal.frontendevents;

import java.util.UUID;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.track.data.TrackType;
import retrofit2.HttpException;
import retrofit2.Response;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.extension.DateTimeExt;
import zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveCampaignAnalyticsDTO;
import zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveMessageAnalyticsEvent;
import zendesk.android.internal.frontendevents.pageviewevents.model.PageViewDto;
import zendesk.android.internal.frontendevents.pageviewevents.model.PageViewEventDto;
import zendesk.android.internal.network.NetworkData;
import zendesk.android.internal.p013di.ZendeskComponentConfig;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.pageviewevents.PageView;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.logger.Logger;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0001\u0018\u0000 \u001a2\u00020\u0001:\u0001\u001aB7\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r¢\u0006\u0002\u0010\u000eJ\"\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u00120\u00102\u0006\u0010\u0013\u001a\u00020\u0014H\u0086@¢\u0006\u0002\u0010\u0015J\u0016\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u0010\u0019R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001b"}, m18d2 = {"Lzendesk/android/internal/frontendevents/FrontendEventsRepository;", "", "frontendEventsApi", "Lzendesk/android/internal/frontendevents/FrontendEventsApi;", "zendeskComponentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "frontendEventsStorage", "Lzendesk/android/internal/frontendevents/FrontendEventsStorage;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "networkData", "Lzendesk/android/internal/network/NetworkData;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "(Lzendesk/android/internal/frontendevents/FrontendEventsApi;Lzendesk/android/internal/di/ZendeskComponentConfig;Lzendesk/android/internal/frontendevents/FrontendEventsStorage;Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/internal/network/NetworkData;Lzendesk/core/ui/android/internal/local/LocaleProvider;)V", "sendPageViewEvent", "Lzendesk/android/ZendeskResult;", "", "", "pageTitle", "Lzendesk/android/pageviewevents/PageView;", "(Lzendesk/android/pageviewevents/PageView;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "sendProactiveMessagingAnalyticsEvent", "proactiveCampaign", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "(Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FrontendEventsRepository {
    private static final String CHANNEL = "mobile-sdk";
    private static final String CLIENT_ID = "383F2407-53F9-475B-87BD-6D2F1CE12105";
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String LOG_TAG = "FrontendEventsRepository";
    private static final String ZENDESK_SDK_VERSION = "Zendesk-SDK/";
    private final ConversationKit conversationKit;
    private final FrontendEventsApi frontendEventsApi;
    private final FrontendEventsStorage frontendEventsStorage;
    private final LocaleProvider localeProvider;
    private final NetworkData networkData;
    private final ZendeskComponentConfig zendeskComponentConfig;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.frontendevents.FrontendEventsRepository", m37f = "FrontendEventsRepository.kt", m38i = {0, 0, 1, 1, 1}, m39l = {35, 36, TrackType.TRACK_DURATION_CUSTOMER_SERVICE}, m40m = "sendPageViewEvent", m41n = {"this", "pageTitle", "this", "pageTitle", FrontendEventsStorage.KEY_SUID}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2"})
    static final class C09511 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09511(Continuation<? super C09511> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FrontendEventsRepository.this.sendPageViewEvent(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.frontendevents.FrontendEventsRepository", m37f = "FrontendEventsRepository.kt", m38i = {0, 0, 1, 1, 1}, m39l = {67, 68, 79}, m40m = "sendProactiveMessagingAnalyticsEvent", m41n = {"this", "proactiveCampaign", "this", "proactiveCampaign", FrontendEventsStorage.KEY_SUID}, m42s = {"L$0", "L$1", "L$0", "L$1", "L$2"})
    static final class C09521 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09521(Continuation<? super C09521> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FrontendEventsRepository.this.sendProactiveMessagingAnalyticsEvent(null, this);
        }
    }

    @Inject
    public FrontendEventsRepository(FrontendEventsApi frontendEventsApi, ZendeskComponentConfig zendeskComponentConfig, FrontendEventsStorage frontendEventsStorage, ConversationKit conversationKit, NetworkData networkData, LocaleProvider localeProvider) {
        Intrinsics.checkNotNullParameter(frontendEventsApi, "frontendEventsApi");
        Intrinsics.checkNotNullParameter(zendeskComponentConfig, "zendeskComponentConfig");
        Intrinsics.checkNotNullParameter(frontendEventsStorage, "frontendEventsStorage");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(networkData, "networkData");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        this.frontendEventsApi = frontendEventsApi;
        this.zendeskComponentConfig = zendeskComponentConfig;
        this.frontendEventsStorage = frontendEventsStorage;
        this.conversationKit = conversationKit;
        this.networkData = networkData;
        this.localeProvider = localeProvider;
    }

    public final Object sendPageViewEvent(PageView pageView, Continuation<? super ZendeskResult<Unit, ? extends Throwable>> continuation) {
        C09511 c09511;
        FrontendEventsRepository frontendEventsRepository;
        String str;
        FrontendEventsRepository frontendEventsRepository2;
        PageView pageView2;
        String str2;
        Response response;
        if (continuation instanceof C09511) {
            c09511 = (C09511) continuation;
            if ((c09511.label & Integer.MIN_VALUE) != 0) {
                c09511.label -= Integer.MIN_VALUE;
            } else {
                c09511 = new C09511(continuation);
            }
        } else {
            c09511 = new C09511(continuation);
        }
        Object suid = c09511.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09511.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(suid);
                FrontendEventsStorage frontendEventsStorage = this.frontendEventsStorage;
                c09511.L$0 = this;
                c09511.L$1 = pageView;
                c09511.label = 1;
                suid = frontendEventsStorage.getSUID(c09511);
                if (suid == coroutine_suspended) {
                    return coroutine_suspended;
                }
                frontendEventsRepository = this;
            } else {
                if (i == 1) {
                    pageView = (PageView) c09511.L$1;
                    frontendEventsRepository = (FrontendEventsRepository) c09511.L$0;
                    ResultKt.throwOnFailure(suid);
                } else if (i == 2) {
                    String str3 = (String) c09511.L$2;
                    pageView2 = (PageView) c09511.L$1;
                    frontendEventsRepository2 = (FrontendEventsRepository) c09511.L$0;
                    ResultKt.throwOnFailure(suid);
                    str = str3;
                    str2 = (String) suid;
                    String url = pageView2.getUrl();
                    if (str2 == null) {
                        str2 = "";
                    }
                    String str4 = str2;
                    String str5 = ZENDESK_SDK_VERSION + frontendEventsRepository2.zendeskComponentConfig.getVersionName();
                    String strCurrentIso8601UtcTimestamp = DateTimeExt.INSTANCE.currentIso8601UtcTimestamp();
                    String pageTitle = pageView2.getPageTitle();
                    String languageTag = frontendEventsRepository2.localeProvider.getLocale().toLanguageTag();
                    Intrinsics.checkNotNullExpressionValue(languageTag, "toLanguageTag(...)");
                    PageViewEventDto pageViewEventDto = new PageViewEventDto(url, str4, CHANNEL, str5, strCurrentIso8601UtcTimestamp, str, new PageViewDto(pageTitle, languageTag, frontendEventsRepository2.networkData.userAgent()));
                    FrontendEventsApi frontendEventsApi = frontendEventsRepository2.frontendEventsApi;
                    c09511.L$0 = null;
                    c09511.L$1 = null;
                    c09511.L$2 = null;
                    c09511.label = 3;
                    suid = frontendEventsApi.sendPageViewEvent(CLIENT_ID, pageViewEventDto, c09511);
                    if (suid == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(suid);
                }
                response = (Response) suid;
                if (response.isSuccessful()) {
                    return new ZendeskResult.Success(Unit.INSTANCE);
                }
                return new ZendeskResult.Failure(new HttpException(response));
            }
            String str6 = (String) suid;
            ConversationKit conversationKit = frontendEventsRepository.conversationKit;
            c09511.L$0 = frontendEventsRepository;
            c09511.L$1 = pageView;
            c09511.L$2 = str6;
            c09511.label = 2;
            Object clientId = conversationKit.getClientId(c09511);
            if (clientId == coroutine_suspended) {
                return coroutine_suspended;
            }
            str = str6;
            suid = clientId;
            frontendEventsRepository2 = frontendEventsRepository;
            pageView2 = pageView;
            str2 = (String) suid;
            String url2 = pageView2.getUrl();
            if (str2 == null) {
                str2 = "";
            }
            String str7 = str2;
            String str8 = ZENDESK_SDK_VERSION + frontendEventsRepository2.zendeskComponentConfig.getVersionName();
            String strCurrentIso8601UtcTimestamp2 = DateTimeExt.INSTANCE.currentIso8601UtcTimestamp();
            String pageTitle2 = pageView2.getPageTitle();
            String languageTag2 = frontendEventsRepository2.localeProvider.getLocale().toLanguageTag();
            Intrinsics.checkNotNullExpressionValue(languageTag2, "toLanguageTag(...)");
            PageViewEventDto pageViewEventDto2 = new PageViewEventDto(url2, str7, CHANNEL, str8, strCurrentIso8601UtcTimestamp2, str, new PageViewDto(pageTitle2, languageTag2, frontendEventsRepository2.networkData.userAgent()));
            FrontendEventsApi frontendEventsApi2 = frontendEventsRepository2.frontendEventsApi;
            c09511.L$0 = null;
            c09511.L$1 = null;
            c09511.L$2 = null;
            c09511.label = 3;
            suid = frontendEventsApi2.sendPageViewEvent(CLIENT_ID, pageViewEventDto2, c09511);
            if (suid == coroutine_suspended) {
                return coroutine_suspended;
            }
            response = (Response) suid;
            if (response.isSuccessful()) {
                return new ZendeskResult.Success(Unit.INSTANCE);
            }
            return new ZendeskResult.Failure(new HttpException(response));
        } catch (Exception e) {
            return new ZendeskResult.Failure(e);
        }
    }

    public final Object sendProactiveMessagingAnalyticsEvent(ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO, Continuation<? super Unit> continuation) throws Throwable {
        C09521 c09521;
        FrontendEventsRepository frontendEventsRepository;
        ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO2;
        String str;
        FrontendEventsRepository frontendEventsRepository2;
        String str2;
        String str3;
        ProactiveMessageAnalyticsEvent proactiveMessageAnalyticsEvent;
        FrontendEventsApi frontendEventsApi;
        if (continuation instanceof C09521) {
            c09521 = (C09521) continuation;
            if ((c09521.label & Integer.MIN_VALUE) != 0) {
                c09521.label -= Integer.MIN_VALUE;
            } else {
                c09521 = new C09521(continuation);
            }
        } else {
            c09521 = new C09521(continuation);
        }
        Object suid = c09521.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09521.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(suid);
                FrontendEventsStorage frontendEventsStorage = this.frontendEventsStorage;
                c09521.L$0 = this;
                c09521.L$1 = proactiveCampaignAnalyticsDTO;
                c09521.label = 1;
                suid = frontendEventsStorage.getSUID(c09521);
                if (suid == coroutine_suspended) {
                    return coroutine_suspended;
                }
                frontendEventsRepository = this;
            } else {
                if (i == 1) {
                    proactiveCampaignAnalyticsDTO = (ProactiveCampaignAnalyticsDTO) c09521.L$1;
                    frontendEventsRepository = (FrontendEventsRepository) c09521.L$0;
                    ResultKt.throwOnFailure(suid);
                } else if (i == 2) {
                    String str4 = (String) c09521.L$2;
                    ProactiveCampaignAnalyticsDTO proactiveCampaignAnalyticsDTO3 = (ProactiveCampaignAnalyticsDTO) c09521.L$1;
                    frontendEventsRepository2 = (FrontendEventsRepository) c09521.L$0;
                    ResultKt.throwOnFailure(suid);
                    str = str4;
                    proactiveCampaignAnalyticsDTO2 = proactiveCampaignAnalyticsDTO3;
                    str2 = (String) suid;
                    if (str2 == null) {
                        str3 = "";
                    } else {
                        str3 = str2;
                    }
                    String strCurrentIso8601UtcTimestamp = DateTimeExt.INSTANCE.currentIso8601UtcTimestamp();
                    String str5 = ZENDESK_SDK_VERSION + frontendEventsRepository2.zendeskComponentConfig.getVersionName();
                    String string = UUID.randomUUID().toString();
                    Intrinsics.checkNotNull(string);
                    proactiveMessageAnalyticsEvent = new ProactiveMessageAnalyticsEvent(str3, CHANNEL, str5, strCurrentIso8601UtcTimestamp, str, string, proactiveCampaignAnalyticsDTO2);
                    frontendEventsApi = frontendEventsRepository2.frontendEventsApi;
                    c09521.L$0 = null;
                    c09521.L$1 = null;
                    c09521.L$2 = null;
                    c09521.label = 3;
                    if (frontendEventsApi.sendProactiveCampaignAnalyticsEvent(CLIENT_ID, proactiveMessageAnalyticsEvent, c09521) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(suid);
                }
                return Unit.INSTANCE;
            }
            String str6 = (String) suid;
            ConversationKit conversationKit = frontendEventsRepository.conversationKit;
            c09521.L$0 = frontendEventsRepository;
            c09521.L$1 = proactiveCampaignAnalyticsDTO;
            c09521.L$2 = str6;
            c09521.label = 2;
            Object clientId = conversationKit.getClientId(c09521);
            if (clientId == coroutine_suspended) {
                return coroutine_suspended;
            }
            proactiveCampaignAnalyticsDTO2 = proactiveCampaignAnalyticsDTO;
            str = str6;
            suid = clientId;
            frontendEventsRepository2 = frontendEventsRepository;
            str2 = (String) suid;
            if (str2 == null) {
                str3 = "";
            } else {
                str3 = str2;
            }
            String strCurrentIso8601UtcTimestamp2 = DateTimeExt.INSTANCE.currentIso8601UtcTimestamp();
            String str7 = ZENDESK_SDK_VERSION + frontendEventsRepository2.zendeskComponentConfig.getVersionName();
            String string2 = UUID.randomUUID().toString();
            Intrinsics.checkNotNull(string2);
            proactiveMessageAnalyticsEvent = new ProactiveMessageAnalyticsEvent(str3, CHANNEL, str7, strCurrentIso8601UtcTimestamp2, str, string2, proactiveCampaignAnalyticsDTO2);
            frontendEventsApi = frontendEventsRepository2.frontendEventsApi;
            c09521.L$0 = null;
            c09521.L$1 = null;
            c09521.L$2 = null;
            c09521.label = 3;
            if (frontendEventsApi.sendProactiveCampaignAnalyticsEvent(CLIENT_ID, proactiveMessageAnalyticsEvent, c09521) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        } catch (Exception e) {
            Logger.m218e(LOG_TAG, "Failed to send analytics event", e, new Object[0]);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\b"}, m18d2 = {"Lzendesk/android/internal/frontendevents/FrontendEventsRepository$Companion;", "", "()V", "CHANNEL", "", "CLIENT_ID", "LOG_TAG", "ZENDESK_SDK_VERSION", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
