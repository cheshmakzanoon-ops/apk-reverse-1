package zendesk.android.internal.proactivemessaging;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import net.aihelp.data.track.data.TrackType;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.CampaignPathDto;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.CtsRequestDto;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.CtsResponseDto;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessageJwtDecoder;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessageResponse;
import zendesk.android.internal.proactivemessaging.model.Campaign;
import zendesk.android.internal.proactivemessaging.model.Frequency;
import zendesk.android.internal.proactivemessaging.model.IntegrationType;
import zendesk.android.internal.proactivemessaging.model.Status;
import zendesk.android.settings.internal.SettingsRepository;
import zendesk.android.settings.internal.model.SettingsDto;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.logger.Logger;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000f\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010!\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\b\u0001\u0018\u0000 02\u00020\u0001:\u00010B/\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b¢\u0006\u0002\u0010\fJ\u0010\u0010\u001e\u001a\u0004\u0018\u00010\u001f2\u0006\u0010 \u001a\u00020\u0018J\u0010\u0010!\u001a\u0004\u0018\u00010\u000f2\u0006\u0010\"\u001a\u00020\u0018J\u0014\u0010#\u001a\b\u0012\u0004\u0012\u00020\u000f0\u000eH\u0086@¢\u0006\u0002\u0010$J\u0014\u0010%\u001a\b\u0012\u0004\u0012\u00020\u000f0\u000eH\u0082@¢\u0006\u0002\u0010$J\u001e\u0010&\u001a\u0004\u0018\u00010'2\f\u0010(\u001a\b\u0012\u0004\u0012\u00020)0\u000eH\u0086@¢\u0006\u0002\u0010*J\u000e\u0010+\u001a\u00020,H\u0082@¢\u0006\u0002\u0010$J\u0016\u0010-\u001a\u00020,2\u0006\u0010.\u001a\u00020\u000fH\u0086@¢\u0006\u0002\u0010/R*\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u000f0\u000e8\u0000@\u0000X\u0081.¢\u0006\u0014\n\u0000\u0012\u0004\b\u0010\u0010\u0011\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R*\u0010\u0016\u001a\b\u0012\u0004\u0012\u00020\u00180\u00178\u0000@\u0000X\u0081\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b\u0019\u0010\u0011\u001a\u0004\b\u001a\u0010\u0013\"\u0004\b\u001b\u0010\u0015R\u000e\u0010\u001c\u001a\u00020\u001dX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u00061"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/ProactiveMessagingRepository;", "", "settingsRepository", "Lzendesk/android/settings/internal/SettingsRepository;", "storage", "Lzendesk/android/internal/proactivemessaging/ProactiveMessagingStorage;", "proactiveMessageJwtDecoder", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessageJwtDecoder;", "proactiveMessagingService", "Lzendesk/android/internal/proactivemessaging/ProactiveMessagingService;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lzendesk/android/settings/internal/SettingsRepository;Lzendesk/android/internal/proactivemessaging/ProactiveMessagingStorage;Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessageJwtDecoder;Lzendesk/android/internal/proactivemessaging/ProactiveMessagingService;Lkotlinx/coroutines/CoroutineScope;)V", "campaigns", "", "Lzendesk/android/internal/proactivemessaging/model/Campaign;", "getCampaigns$zendesk_zendesk_android$annotations", "()V", "getCampaigns$zendesk_zendesk_android", "()Ljava/util/List;", "setCampaigns$zendesk_zendesk_android", "(Ljava/util/List;)V", "filterOutCampaigns", "", "", "getFilterOutCampaigns$zendesk_zendesk_android$annotations", "getFilterOutCampaigns$zendesk_zendesk_android", "setFilterOutCampaigns$zendesk_zendesk_android", "initialiseCampaignsJob", "Lkotlinx/coroutines/Job;", "buildProactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "jwt", "getCampaign", "campaignId", "getCampaignsForEvaluation", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getLiveCampaigns", "getProactiveMessage", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CtsResponseDto;", "campaignPaths", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/CampaignPathDto;", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "initializeFilterOutCampaigns", "", "updateFilterOutCampaigns", "campaign", "(Lzendesk/android/internal/proactivemessaging/model/Campaign;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveMessagingRepository {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String LOG_TAG = "PM-Repository";
    public List<Campaign> campaigns;
    private List<String> filterOutCampaigns;
    private final Job initialiseCampaignsJob;
    private final ProactiveMessageJwtDecoder proactiveMessageJwtDecoder;
    private final ProactiveMessagingService proactiveMessagingService;
    private final SettingsRepository settingsRepository;
    private final ProactiveMessagingStorage storage;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository", m37f = "ProactiveMessagingRepository.kt", m38i = {0}, m39l = {82}, m40m = "getCampaignsForEvaluation", m41n = {"this"}, m42s = {"L$0"})
    static final class C09671 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09671(Continuation<? super C09671> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingRepository.this.getCampaignsForEvaluation(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository", m37f = "ProactiveMessagingRepository.kt", m38i = {0}, m39l = {58, 64}, m40m = "getLiveCampaigns", m41n = {"this"}, m42s = {"L$0"})
    static final class C09681 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09681(Continuation<? super C09681> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingRepository.this.getLiveCampaigns(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository", m37f = "ProactiveMessagingRepository.kt", m38i = {}, m39l = {100}, m40m = "getProactiveMessage", m41n = {}, m42s = {})
    static final class C09691 extends ContinuationImpl {
        int label;
        Object result;

        C09691(Continuation<? super C09691> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingRepository.this.getProactiveMessage(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository", m37f = "ProactiveMessagingRepository.kt", m38i = {0, 0, 1, 1}, m39l = {49, 51, TrackType.TRACK_DURATION_USER_WAITING}, m40m = "initializeFilterOutCampaigns", m41n = {"this", "availableOnlyOnceCampaigns", "this", "availableOnlyOnceCampaigns"}, m42s = {"L$0", "L$1", "L$0", "L$1"})
    static final class C09701 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09701(Continuation<? super C09701> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingRepository.this.initializeFilterOutCampaigns(this);
        }
    }

    public static void getCampaigns$zendesk_zendesk_android$annotations() {
    }

    public static void getFilterOutCampaigns$zendesk_zendesk_android$annotations() {
    }

    @Inject
    public ProactiveMessagingRepository(SettingsRepository settingsRepository, ProactiveMessagingStorage storage, ProactiveMessageJwtDecoder proactiveMessageJwtDecoder, ProactiveMessagingService proactiveMessagingService, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(settingsRepository, "settingsRepository");
        Intrinsics.checkNotNullParameter(storage, "storage");
        Intrinsics.checkNotNullParameter(proactiveMessageJwtDecoder, "proactiveMessageJwtDecoder");
        Intrinsics.checkNotNullParameter(proactiveMessagingService, "proactiveMessagingService");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.settingsRepository = settingsRepository;
        this.storage = storage;
        this.proactiveMessageJwtDecoder = proactiveMessageJwtDecoder;
        this.proactiveMessagingService = proactiveMessagingService;
        this.filterOutCampaigns = new ArrayList();
        this.initialiseCampaignsJob = BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new ProactiveMessagingRepository$initialiseCampaignsJob$1(this, null), 3, null);
    }

    public final List<Campaign> getCampaigns$zendesk_zendesk_android() {
        List<Campaign> list = this.campaigns;
        if (list != null) {
            return list;
        }
        Intrinsics.throwUninitializedPropertyAccessException("campaigns");
        return null;
    }

    public final void setCampaigns$zendesk_zendesk_android(List<Campaign> list) {
        Intrinsics.checkNotNullParameter(list, "<set-?>");
        this.campaigns = list;
    }

    public final List<String> getFilterOutCampaigns$zendesk_zendesk_android() {
        return this.filterOutCampaigns;
    }

    public final void setFilterOutCampaigns$zendesk_zendesk_android(List<String> list) {
        Intrinsics.checkNotNullParameter(list, "<set-?>");
        this.filterOutCampaigns = list;
    }

    public final java.lang.Object initializeFilterOutCampaigns(kotlin.coroutines.Continuation<? super kotlin.Unit> r11) {
        throw new UnsupportedOperationException("Method not decompiled: zendesk.android.internal.proactivemessaging.ProactiveMessagingRepository.initializeFilterOutCampaigns(kotlin.coroutines.Continuation):java.lang.Object");
    }

    public final Object getLiveCampaigns(Continuation<? super List<Campaign>> continuation) throws Throwable {
        C09681 c09681;
        ProactiveMessagingRepository proactiveMessagingRepository;
        ArrayList arrayList;
        ArrayList arrayList2;
        ArrayList arrayList3;
        if (continuation instanceof C09681) {
            c09681 = (C09681) continuation;
            if ((c09681.label & Integer.MIN_VALUE) != 0) {
                c09681.label -= Integer.MIN_VALUE;
            } else {
                c09681 = new C09681(continuation);
            }
        } else {
            c09681 = new C09681(continuation);
        }
        Object objFetchSettings$zendesk_zendesk_android = c09681.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09681.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(objFetchSettings$zendesk_zendesk_android);
                SettingsRepository settingsRepository = this.settingsRepository;
                c09681.L$0 = this;
                c09681.label = 1;
                objFetchSettings$zendesk_zendesk_android = settingsRepository.fetchSettings$zendesk_zendesk_android(c09681);
                if (objFetchSettings$zendesk_zendesk_android == coroutine_suspended) {
                    return coroutine_suspended;
                }
                proactiveMessagingRepository = this;
            } else {
                if (i == 1) {
                    proactiveMessagingRepository = (ProactiveMessagingRepository) c09681.L$0;
                    ResultKt.throwOnFailure(objFetchSettings$zendesk_zendesk_android);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(objFetchSettings$zendesk_zendesk_android);
                }
                arrayList = new ArrayList();
                for (Object obj : (Iterable) objFetchSettings$zendesk_zendesk_android) {
                    if (((Campaign) obj).getStatus() == Status.LIVE) {
                        arrayList.add(obj);
                    }
                }
                arrayList2 = new ArrayList();
                for (Object obj2 : arrayList) {
                    if (((Campaign) obj2).getIntegration().getType() == IntegrationType.ANDROID) {
                        arrayList2.add(obj2);
                    }
                }
                arrayList3 = new ArrayList();
                for (Object obj3 : arrayList2) {
                    if (((Campaign) obj3).getSchedule().getFrequency() == Frequency.UNKNOWN) {
                        arrayList3.add(obj3);
                    }
                }
                return arrayList3;
            }
            ZendeskResult zendeskResult = (ZendeskResult) objFetchSettings$zendesk_zendesk_android;
            if (zendeskResult instanceof ZendeskResult.Failure) {
                return CollectionsKt.emptyList();
            }
            if (!(zendeskResult instanceof ZendeskResult.Success)) {
                throw new NoWhenBranchMatchedException();
            }
            String integrationId = ((SettingsDto) ((ZendeskResult.Success) zendeskResult).getValue()).getNativeMessaging().getIntegrationId();
            if (integrationId != null) {
                ProactiveMessagingService proactiveMessagingService = proactiveMessagingRepository.proactiveMessagingService;
                c09681.L$0 = null;
                c09681.label = 2;
                objFetchSettings$zendesk_zendesk_android = proactiveMessagingService.getCampaigns(integrationId, c09681);
                if (objFetchSettings$zendesk_zendesk_android == coroutine_suspended) {
                    return coroutine_suspended;
                }
                arrayList = new ArrayList();
                while (r6.hasNext()) {
                    if (((Campaign) obj).getStatus() == Status.LIVE) {
                        arrayList.add(obj);
                    }
                }
                arrayList2 = new ArrayList();
                while (r0.hasNext()) {
                    if (((Campaign) obj2).getIntegration().getType() == IntegrationType.ANDROID) {
                        arrayList2.add(obj2);
                    }
                }
                arrayList3 = new ArrayList();
                while (r6.hasNext()) {
                    if (((Campaign) obj3).getSchedule().getFrequency() == Frequency.UNKNOWN) {
                        arrayList3.add(obj3);
                    }
                }
                return arrayList3;
            }
            return CollectionsKt.emptyList();
        } catch (Exception e) {
            Logger.m218e(LOG_TAG, "Failed to get campaigns", e, new Object[0]);
            return CollectionsKt.emptyList();
        }
    }

    public final Object getCampaignsForEvaluation(Continuation<? super List<Campaign>> continuation) throws Throwable {
        C09671 c09671;
        ProactiveMessagingRepository proactiveMessagingRepository;
        if (continuation instanceof C09671) {
            c09671 = (C09671) continuation;
            if ((c09671.label & Integer.MIN_VALUE) != 0) {
                c09671.label -= Integer.MIN_VALUE;
            } else {
                c09671 = new C09671(continuation);
            }
        } else {
            c09671 = new C09671(continuation);
        }
        Object obj = c09671.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09671.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Job job = this.initialiseCampaignsJob;
            c09671.L$0 = this;
            c09671.label = 1;
            if (job.join(c09671) == coroutine_suspended) {
                return coroutine_suspended;
            }
            proactiveMessagingRepository = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            proactiveMessagingRepository = (ProactiveMessagingRepository) c09671.L$0;
            ResultKt.throwOnFailure(obj);
        }
        List<Campaign> campaigns$zendesk_zendesk_android = proactiveMessagingRepository.getCampaigns$zendesk_zendesk_android();
        ArrayList arrayList = new ArrayList();
        for (Object obj2 : campaigns$zendesk_zendesk_android) {
            if (!proactiveMessagingRepository.filterOutCampaigns.contains(((Campaign) obj2).getCampaignId())) {
                arrayList.add(obj2);
            }
        }
        return arrayList;
    }

    public final Object updateFilterOutCampaigns(Campaign campaign, Continuation<? super Unit> continuation) {
        if (campaign.getSchedule().getFrequency() == Frequency.ONCE_PER_SESSION) {
            this.filterOutCampaigns.add(campaign.getCampaignId());
        } else if (campaign.getSchedule().getFrequency() == Frequency.SEND_ONCE) {
            this.filterOutCampaigns.add(campaign.getCampaignId());
            Object objAddSendOnceCampaign = this.storage.addSendOnceCampaign(campaign.getCampaignId(), continuation);
            return objAddSendOnceCampaign == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objAddSendOnceCampaign : Unit.INSTANCE;
        }
        return Unit.INSTANCE;
    }

    public final Object getProactiveMessage(List<CampaignPathDto> list, Continuation<? super CtsResponseDto> continuation) throws Throwable {
        C09691 c09691;
        if (continuation instanceof C09691) {
            c09691 = (C09691) continuation;
            if ((c09691.label & Integer.MIN_VALUE) != 0) {
                c09691.label -= Integer.MIN_VALUE;
            } else {
                c09691 = new C09691(continuation);
            }
        } else {
            c09691 = new C09691(continuation);
        }
        Object proactiveMessage = c09691.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09691.label;
        try {
            if (i == 0) {
                ResultKt.throwOnFailure(proactiveMessage);
                ProactiveMessagingService proactiveMessagingService = this.proactiveMessagingService;
                CtsRequestDto ctsRequestDto = new CtsRequestDto(list);
                c09691.label = 1;
                proactiveMessage = proactiveMessagingService.getProactiveMessage(ctsRequestDto, c09691);
                if (proactiveMessage == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(proactiveMessage);
            }
            return (CtsResponseDto) proactiveMessage;
        } catch (Exception e) {
            Logger.m218e(LOG_TAG, "Failed to get proactive message", e, new Object[0]);
            return null;
        }
    }

    public final Campaign getCampaign(String campaignId) {
        Object next;
        Intrinsics.checkNotNullParameter(campaignId, "campaignId");
        Iterator<T> it = getCampaigns$zendesk_zendesk_android().iterator();
        while (it.hasNext()) {
            next = it.next();
            if (Intrinsics.areEqual(((Campaign) next).getCampaignId(), campaignId)) {
                return (Campaign) next;
            }
        }
        next = null;
        return (Campaign) next;
    }

    public final ProactiveMessage buildProactiveMessage(String jwt) {
        List<zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessage> messages;
        zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessage proactiveMessage;
        Intrinsics.checkNotNullParameter(jwt, "jwt");
        try {
            ProactiveMessageResponse proactiveMessageResponseDecode = this.proactiveMessageJwtDecoder.decode(jwt);
            if (proactiveMessageResponseDecode != null && (messages = proactiveMessageResponseDecode.getMessages()) != null && (proactiveMessage = (zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessage) CollectionsKt.firstOrNull((List) messages)) != null) {
                String displayName = proactiveMessage.getAuthor().getDisplayName();
                String text = proactiveMessage.getContent().getText();
                String id = proactiveMessageResponseDecode.getCampaign().getId();
                Campaign campaign = getCampaign(proactiveMessageResponseDecode.getCampaign().getId());
                return new ProactiveMessage(0, displayName, text, id, campaign != null ? campaign.getVersion() : 0, jwt, 1, (DefaultConstructorMarker) null);
            }
            ProactiveMessagingRepository proactiveMessagingRepository = this;
            Logger.m219e(LOG_TAG, "Proactive message response doesn't contain enough information", new Object[0]);
            return null;
        } catch (Exception e) {
            Logger.m218e(LOG_TAG, "Failed to build local notification", e, new Object[0]);
            return null;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/ProactiveMessagingRepository$Companion;", "", "()V", "LOG_TAG", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
