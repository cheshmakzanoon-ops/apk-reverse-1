package zendesk.android.internal.proactivemessaging;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CancellationException;
import java.util.concurrent.TimeUnit;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.comparisons.ComparisonsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import zendesk.android.internal.frontendevents.analyticsevents.ProactiveMessagingAnalyticsManager;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.CampaignPathDto;
import zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.CtsResponseDto;
import zendesk.android.internal.proactivemessaging.model.Campaign;
import zendesk.android.internal.proactivemessaging.model.Path;
import zendesk.android.internal.proactivemessaging.model.Trigger;
import zendesk.android.internal.proactivemessaging.model.TriggerType;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule;
import zendesk.android.pageviewevents.PageView;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.ProactiveMessageStatus;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u000b\b\u0001\u0018\u0000 42\u00020\u0001:\u00014BO\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u000e\b\u0001\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000f\u0012\u0006\u0010\u0011\u001a\u00020\u0012¢\u0006\u0002\u0010\u0013J\u0010\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u0016H\u0002J\b\u0010 \u001a\u00020!H\u0002J\u0018\u0010\"\u001a\u00020!2\u0006\u0010\u001f\u001a\u00020\u0016H\u0080@¢\u0006\u0004\b#\u0010$J,\u0010%\u001a\u00020!2\u0006\u0010&\u001a\u00020'2\f\u0010(\u001a\b\u0012\u0004\u0012\u00020*0)2\u0006\u0010\u001f\u001a\u00020\u0016H\u0082@¢\u0006\u0002\u0010+J\u000e\u0010,\u001a\u00020\u001eH\u0082@¢\u0006\u0002\u0010-J\b\u0010.\u001a\u00020!H\u0002J\u001c\u0010/\u001a\u00020!2\f\u0010(\u001a\b\u0012\u0004\u0012\u00020*0)H\u0082@¢\u0006\u0002\u00100J\b\u00101\u001a\u00020!H\u0002J\b\u00102\u001a\u00020!H\u0002J\b\u00103\u001a\u00020!H\u0002R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u000e\u001a\b\u0012\u0004\u0012\u00020\u00100\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010\u0014\u001a\u0014\u0012\u0004\u0012\u00020\u0016\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00180\u00170\u00158\u0000X\u0081\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0019\u0010\u001a\u001a\u0004\b\u001b\u0010\u001cR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u00065"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/ProactiveMessagingManager;", "", "processLifecycleEventObserver", "Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "localeProvider", "Lzendesk/core/ui/android/internal/local/LocaleProvider;", "visitTypeProvider", "Lzendesk/android/internal/proactivemessaging/VisitTypeProvider;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "proactiveMessagingRepository", "Lzendesk/android/internal/proactivemessaging/ProactiveMessagingRepository;", MessagingComponentKt.CURRENT_TIME_PROVIDER, "Lkotlin/Function0;", "", "proactiveMessagingAnalyticsManager", "Lzendesk/android/internal/frontendevents/analyticsevents/ProactiveMessagingAnalyticsManager;", "(Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;Lkotlinx/coroutines/CoroutineScope;Lzendesk/core/ui/android/internal/local/LocaleProvider;Lzendesk/android/internal/proactivemessaging/VisitTypeProvider;Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/internal/proactivemessaging/ProactiveMessagingRepository;Lkotlin/jvm/functions/Function0;Lzendesk/android/internal/frontendevents/analyticsevents/ProactiveMessagingAnalyticsManager;)V", "evaluationStatesByPageView", "", "Lzendesk/android/pageviewevents/PageView;", "", "Lzendesk/android/internal/proactivemessaging/EvaluationState;", "getEvaluationStatesByPageView$zendesk_zendesk_android$annotations", "()V", "getEvaluationStatesByPageView$zendesk_zendesk_android", "()Ljava/util/Map;", "areAllJobsCompleted", "", "event", "clearAllTimers", "", "evaluate", "evaluate$zendesk_zendesk_android", "(Lzendesk/android/pageviewevents/PageView;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "evaluateTrigger", "trigger", "Lzendesk/android/internal/proactivemessaging/model/Trigger;", "evaluationResults", "", "Lzendesk/android/internal/proactivemessaging/EvaluationResult;", "(Lzendesk/android/internal/proactivemessaging/model/Trigger;Ljava/util/List;Lzendesk/android/pageviewevents/PageView;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "hasActiveConversations", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "pause", "reportToCts", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resume", "resumeAllTimers", "stopAllTimers", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveMessagingManager {
    private static final int CONVERSATIONS_PAGE_SIZE = 10;
    private static final String LOG_TAG = "PM-Manager";
    private final ConversationKit conversationKit;
    private final CoroutineScope coroutineScope;
    private final Function0<Long> currentTimeProvider;
    private final Map<PageView, List<EvaluationState>> evaluationStatesByPageView;
    private final LocaleProvider localeProvider;
    private final ProactiveMessagingRepository proactiveMessagingRepository;
    private final ProcessLifecycleEventObserver processLifecycleEventObserver;
    private final VisitTypeProvider visitTypeProvider;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[TriggerType.values().length];
            try {
                iArr[TriggerType.ON_PAGE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[TriggerType.LOAD_PAGE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[TriggerType.UNKNOWN.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingManager", m37f = "ProactiveMessagingManager.kt", m38i = {}, m39l = {103}, m40m = "hasActiveConversations", m41n = {}, m42s = {})
    static final class C09651 extends ContinuationImpl {
        int label;
        Object result;

        C09651(Continuation<? super C09651> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingManager.this.hasActiveConversations(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingManager", m37f = "ProactiveMessagingManager.kt", m38i = {0, 0, 1, 2, 3, 3}, m39l = {202, 208, 217, 222}, m40m = "reportToCts", m41n = {"this", "evaluationResults", "this", "this", "this", "proactiveMessage"}, m42s = {"L$0", "L$1", "L$0", "L$0", "L$0", "L$1"})
    static final class C09661 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C09661(Continuation<? super C09661> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ProactiveMessagingManager.this.reportToCts(null, this);
        }
    }

    public static void m200xc9fb0184() {
    }

    @Inject
    public ProactiveMessagingManager(ProcessLifecycleEventObserver processLifecycleEventObserver, CoroutineScope coroutineScope, LocaleProvider localeProvider, VisitTypeProvider visitTypeProvider, ConversationKit conversationKit, ProactiveMessagingRepository proactiveMessagingRepository, @Named(ProactiveMessagingModule.CURRENT_TIME_PROVIDER) Function0<Long> currentTimeProvider, ProactiveMessagingAnalyticsManager proactiveMessagingAnalyticsManager) {
        Intrinsics.checkNotNullParameter(processLifecycleEventObserver, "processLifecycleEventObserver");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(localeProvider, "localeProvider");
        Intrinsics.checkNotNullParameter(visitTypeProvider, "visitTypeProvider");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(proactiveMessagingRepository, "proactiveMessagingRepository");
        Intrinsics.checkNotNullParameter(currentTimeProvider, "currentTimeProvider");
        Intrinsics.checkNotNullParameter(proactiveMessagingAnalyticsManager, "proactiveMessagingAnalyticsManager");
        this.processLifecycleEventObserver = processLifecycleEventObserver;
        this.coroutineScope = coroutineScope;
        this.localeProvider = localeProvider;
        this.visitTypeProvider = visitTypeProvider;
        this.conversationKit = conversationKit;
        this.proactiveMessagingRepository = proactiveMessagingRepository;
        this.currentTimeProvider = currentTimeProvider;
        this.evaluationStatesByPageView = new LinkedHashMap();
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C09631(null), 3, null);
        proactiveMessagingAnalyticsManager.subscribe();
    }

    public final Map<PageView, List<EvaluationState>> getEvaluationStatesByPageView$zendesk_zendesk_android() {
        return this.evaluationStatesByPageView;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingManager$1", m37f = "ProactiveMessagingManager.kt", m38i = {}, m39l = {56}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09631 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C09631(Continuation<? super C09631> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ProactiveMessagingManager.this.new C09631(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09631) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<Boolean> flowIsInForeground = ProactiveMessagingManager.this.processLifecycleEventObserver.isInForeground();
                final ProactiveMessagingManager proactiveMessagingManager = ProactiveMessagingManager.this;
                this.label = 1;
                if (flowIsInForeground.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit(((Boolean) obj2).booleanValue(), (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(boolean z, Continuation<? super Unit> continuation) {
                        if (z) {
                            proactiveMessagingManager.resume();
                        } else {
                            proactiveMessagingManager.pause();
                        }
                        return Unit.INSTANCE;
                    }
                }, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final Object evaluate$zendesk_zendesk_android(PageView pageView, Continuation<? super Unit> continuation) throws Throwable {
        ProactiveMessagingManager$evaluate$1 proactiveMessagingManager$evaluate$1;
        ProactiveMessagingManager proactiveMessagingManager;
        ArrayList arrayList;
        ArrayList arrayList2;
        LinkedHashMap linkedHashMap;
        ProactiveMessagingManager proactiveMessagingManager2;
        PageView pageView2;
        Iterator it;
        Trigger trigger;
        Object obj;
        Trigger trigger2;
        List<EvaluationResult> list;
        if (continuation instanceof ProactiveMessagingManager$evaluate$1) {
            proactiveMessagingManager$evaluate$1 = (ProactiveMessagingManager$evaluate$1) continuation;
            if ((proactiveMessagingManager$evaluate$1.label & Integer.MIN_VALUE) != 0) {
                proactiveMessagingManager$evaluate$1.label -= Integer.MIN_VALUE;
            } else {
                proactiveMessagingManager$evaluate$1 = new ProactiveMessagingManager$evaluate$1(this, continuation);
            }
        } else {
            proactiveMessagingManager$evaluate$1 = new ProactiveMessagingManager$evaluate$1(this, continuation);
        }
        Object objHasActiveConversations = proactiveMessagingManager$evaluate$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = proactiveMessagingManager$evaluate$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objHasActiveConversations);
            Logger.m217d(LOG_TAG, String.valueOf(pageView), new Object[0]);
            if (areAllJobsCompleted(pageView)) {
                clearAllTimers();
                proactiveMessagingManager$evaluate$1.L$0 = this;
                proactiveMessagingManager$evaluate$1.L$1 = pageView;
                proactiveMessagingManager$evaluate$1.label = 1;
                objHasActiveConversations = hasActiveConversations(proactiveMessagingManager$evaluate$1);
                if (objHasActiveConversations == coroutine_suspended) {
                    return coroutine_suspended;
                }
                proactiveMessagingManager = this;
            } else {
                Logger.m217d(LOG_TAG, "Jobs are still running, returning early", new Object[0]);
                return Unit.INSTANCE;
            }
        } else {
            if (i == 1) {
                pageView = (PageView) proactiveMessagingManager$evaluate$1.L$1;
                proactiveMessagingManager = (ProactiveMessagingManager) proactiveMessagingManager$evaluate$1.L$0;
                ResultKt.throwOnFailure(objHasActiveConversations);
            } else if (i == 2) {
                pageView = (PageView) proactiveMessagingManager$evaluate$1.L$1;
                proactiveMessagingManager = (ProactiveMessagingManager) proactiveMessagingManager$evaluate$1.L$0;
                ResultKt.throwOnFailure(objHasActiveConversations);
                Iterable<Campaign> iterable = (Iterable) objHasActiveConversations;
                arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterable, 10));
                for (Campaign campaign : iterable) {
                    arrayList.add(new EvaluationResult(campaign, campaign.evaluate(pageView, proactiveMessagingManager.localeProvider.getLocale(), proactiveMessagingManager.visitTypeProvider.getVisitType$zendesk_zendesk_android()), pageView));
                }
                arrayList2 = new ArrayList();
                for (Object obj2 : arrayList) {
                    if (!((EvaluationResult) obj2).getSuccessfulPaths().isEmpty()) {
                        arrayList2.add(obj2);
                    }
                }
                linkedHashMap = new LinkedHashMap();
                for (Object obj3 : arrayList2) {
                    trigger = ((EvaluationResult) obj3).getCampaign().getTrigger();
                    obj = linkedHashMap.get(trigger);
                    if (obj == null) {
                        obj = (List) new ArrayList();
                        linkedHashMap.put(trigger, obj);
                    }
                    ((List) obj).add(obj3);
                }
                Iterator it2 = linkedHashMap.entrySet().iterator();
                proactiveMessagingManager2 = proactiveMessagingManager;
                pageView2 = pageView;
                it = it2;
            } else {
                if (i != 3) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                it = (Iterator) proactiveMessagingManager$evaluate$1.L$2;
                pageView2 = (PageView) proactiveMessagingManager$evaluate$1.L$1;
                proactiveMessagingManager2 = (ProactiveMessagingManager) proactiveMessagingManager$evaluate$1.L$0;
                ResultKt.throwOnFailure(objHasActiveConversations);
            }
            while (it.hasNext()) {
                Map.Entry entry = (Map.Entry) it.next();
                trigger2 = (Trigger) entry.getKey();
                list = (List) entry.getValue();
                proactiveMessagingManager$evaluate$1.L$0 = proactiveMessagingManager2;
                proactiveMessagingManager$evaluate$1.L$1 = pageView2;
                proactiveMessagingManager$evaluate$1.L$2 = it;
                proactiveMessagingManager$evaluate$1.label = 3;
                if (proactiveMessagingManager2.evaluateTrigger(trigger2, list, pageView2, proactiveMessagingManager$evaluate$1) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
        if (((Boolean) objHasActiveConversations).booleanValue()) {
            return Unit.INSTANCE;
        }
        ProactiveMessagingRepository proactiveMessagingRepository = proactiveMessagingManager.proactiveMessagingRepository;
        proactiveMessagingManager$evaluate$1.L$0 = proactiveMessagingManager;
        proactiveMessagingManager$evaluate$1.L$1 = pageView;
        proactiveMessagingManager$evaluate$1.label = 2;
        objHasActiveConversations = proactiveMessagingRepository.getCampaignsForEvaluation(proactiveMessagingManager$evaluate$1);
        if (objHasActiveConversations == coroutine_suspended) {
            return coroutine_suspended;
        }
        Iterable<Campaign> iterable2 = (Iterable) objHasActiveConversations;
        arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterable2, 10));
        while (r10.hasNext()) {
            arrayList.add(new EvaluationResult(campaign, campaign.evaluate(pageView, proactiveMessagingManager.localeProvider.getLocale(), proactiveMessagingManager.visitTypeProvider.getVisitType$zendesk_zendesk_android()), pageView));
        }
        arrayList2 = new ArrayList();
        while (r4.hasNext()) {
            if (!((EvaluationResult) obj2).getSuccessfulPaths().isEmpty()) {
                arrayList2.add(obj2);
            }
        }
        linkedHashMap = new LinkedHashMap();
        while (r10.hasNext()) {
            trigger = ((EvaluationResult) obj3).getCampaign().getTrigger();
            obj = linkedHashMap.get(trigger);
            if (obj == null) {
                obj = (List) new ArrayList();
                linkedHashMap.put(trigger, obj);
            }
            ((List) obj).add(obj3);
        }
        Iterator it3 = linkedHashMap.entrySet().iterator();
        proactiveMessagingManager2 = proactiveMessagingManager;
        pageView2 = pageView;
        it = it3;
        while (it.hasNext()) {
            Map.Entry entry2 = (Map.Entry) it.next();
            trigger2 = (Trigger) entry2.getKey();
            list = (List) entry2.getValue();
            proactiveMessagingManager$evaluate$1.L$0 = proactiveMessagingManager2;
            proactiveMessagingManager$evaluate$1.L$1 = pageView2;
            proactiveMessagingManager$evaluate$1.L$2 = it;
            proactiveMessagingManager$evaluate$1.label = 3;
            if (proactiveMessagingManager2.evaluateTrigger(trigger2, list, pageView2, proactiveMessagingManager$evaluate$1) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        return Unit.INSTANCE;
    }

    public final Object hasActiveConversations(Continuation<? super Boolean> continuation) throws Throwable {
        C09651 c09651;
        if (continuation instanceof C09651) {
            c09651 = (C09651) continuation;
            if ((c09651.label & Integer.MIN_VALUE) != 0) {
                c09651.label -= Integer.MIN_VALUE;
            } else {
                c09651 = new C09651(continuation);
            }
        } else {
            c09651 = new C09651(continuation);
        }
        Object conversations = c09651.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09651.label;
        boolean z = false;
        if (i == 0) {
            ResultKt.throwOnFailure(conversations);
            ConversationKit conversationKit = this.conversationKit;
            c09651.label = 1;
            conversations = conversationKit.getConversations(0, true, c09651);
            if (conversations == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(conversations);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) conversations;
        if (!(conversationKitResult instanceof ConversationKitResult.Failure)) {
            if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
                throw new NoWhenBranchMatchedException();
            }
            List listTake = CollectionsKt.take(CollectionsKt.sortedWith(((ConversationsPagination) ((ConversationKitResult.Success) conversationKitResult).getValue()).getConversations(), new Comparator() {
                @Override
                public final int compare(T t, T t2) {
                    return ComparisonsKt.compareValues(((Conversation) t2).getLastUpdatedAt(), ((Conversation) t).getLastUpdatedAt());
                }
            }), 10);
            if (!(listTake instanceof Collection) || !listTake.isEmpty()) {
                Iterator it = listTake.iterator();
                while (it.hasNext()) {
                    if (((Conversation) it.next()).getStatus() == ConversationStatus.ACTIVE) {
                        z = true;
                        break;
                    }
                }
            }
        }
        return Boxing.boxBoolean(z);
    }

    private final boolean areAllJobsCompleted(PageView event) {
        List<EvaluationState> list = this.evaluationStatesByPageView.get(event);
        if (list == null || !(!list.isEmpty())) {
            return true;
        }
        Iterator<T> it = this.evaluationStatesByPageView.keySet().iterator();
        boolean z = true;
        while (it.hasNext()) {
            List<EvaluationState> list2 = this.evaluationStatesByPageView.get((PageView) it.next());
            if (list2 != null) {
                Iterator<T> it2 = list2.iterator();
                while (it2.hasNext()) {
                    z = ((EvaluationState) it2.next()).getJob().isCompleted() && z;
                }
            }
        }
        return z;
    }

    public final Object evaluateTrigger(Trigger trigger, List<EvaluationResult> list, PageView pageView, Continuation<? super Unit> continuation) throws Throwable {
        int i = WhenMappings.$EnumSwitchMapping$0[trigger.getType().ordinal()];
        if (i == 1) {
            EvaluationState evaluationState = new EvaluationState(list, BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new ProactiveMessagingManager$evaluateTrigger$job$1(trigger, this, list, null), 3, null), this.currentTimeProvider.invoke().longValue(), 0L, 8, null);
            ArrayList arrayList = this.evaluationStatesByPageView.get(pageView);
            if (arrayList == null) {
                arrayList = new ArrayList();
            }
            arrayList.add(evaluationState);
            this.evaluationStatesByPageView.put(pageView, arrayList);
        } else {
            if (i == 2) {
                Object objReportToCts = reportToCts(list, continuation);
                return objReportToCts == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objReportToCts : Unit.INSTANCE;
            }
            if (i == 3) {
                Logger.m217d(LOG_TAG, "TriggerType UNKNOWN", new Object[0]);
            }
        }
        return Unit.INSTANCE;
    }

    private final void clearAllTimers() {
        stopAllTimers();
        this.evaluationStatesByPageView.clear();
    }

    public final void pause() {
        Logger.m217d(LOG_TAG, "Paused", new Object[0]);
        stopAllTimers();
    }

    private final void stopAllTimers() {
        Campaign campaign;
        Trigger trigger;
        Integer duration;
        Iterator<T> it = this.evaluationStatesByPageView.keySet().iterator();
        while (it.hasNext()) {
            List<EvaluationState> list = this.evaluationStatesByPageView.get((PageView) it.next());
            if (list != null) {
                for (EvaluationState evaluationState : list) {
                    long jLongValue = this.currentTimeProvider.invoke().longValue() - evaluationState.getStartTime();
                    TimeUnit timeUnit = TimeUnit.SECONDS;
                    EvaluationResult evaluationResult = (EvaluationResult) CollectionsKt.firstOrNull((List) evaluationState.getEvaluationResults());
                    evaluationState.setRemainingSeconds(TimeUnit.MILLISECONDS.toSeconds(timeUnit.toMillis((evaluationResult == null || (campaign = evaluationResult.getCampaign()) == null || (trigger = campaign.getTrigger()) == null || (duration = trigger.getDuration()) == null) ? 0L : duration.intValue()) - jLongValue));
                    Job.DefaultImpls.cancel$default(evaluationState.getJob(), (CancellationException) null, 1, (Object) null);
                }
            }
        }
    }

    public final void resume() {
        Logger.m217d(LOG_TAG, "Resumed", new Object[0]);
        resumeAllTimers();
    }

    private final void resumeAllTimers() {
        Iterator<T> it = this.evaluationStatesByPageView.keySet().iterator();
        while (it.hasNext()) {
            List<EvaluationState> list = this.evaluationStatesByPageView.get((PageView) it.next());
            if (list != null) {
                for (EvaluationState evaluationState : list) {
                    if (evaluationState.getRemainingSeconds() > 0) {
                        evaluationState.setJob(BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new ProactiveMessagingManager$resumeAllTimers$1$1$1(evaluationState, this, null), 3, null));
                    }
                }
            }
        }
    }

    public final Object reportToCts(List<EvaluationResult> list, Continuation<? super Unit> continuation) throws Throwable {
        C09661 c09661;
        ProactiveMessagingManager proactiveMessagingManager;
        ProactiveMessagingManager proactiveMessagingManager2;
        Iterable<EvaluationResult> iterable;
        Iterator it;
        ArrayList arrayList;
        C09661 c09662;
        ProactiveMessagingManager proactiveMessagingManager3;
        ArrayList arrayList2;
        Iterator<T> it2;
        ProactiveMessagingRepository proactiveMessagingRepository;
        Campaign campaign;
        CtsResponseDto ctsResponseDto;
        ProactiveMessage proactiveMessageBuildProactiveMessage;
        ConversationKit conversationKit;
        ProactiveMessage proactiveMessage;
        if (continuation instanceof C09661) {
            c09661 = (C09661) continuation;
            if ((c09661.label & Integer.MIN_VALUE) != 0) {
                c09661.label -= Integer.MIN_VALUE;
            } else {
                c09661 = new C09661(continuation);
            }
        } else {
            c09661 = new C09661(continuation);
        }
        Object objHasActiveConversations = c09661.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09661.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objHasActiveConversations);
            c09661.L$0 = this;
            c09661.L$1 = list;
            c09661.label = 1;
            objHasActiveConversations = hasActiveConversations(c09661);
            if (objHasActiveConversations == coroutine_suspended) {
                return coroutine_suspended;
            }
            proactiveMessagingManager = this;
        } else {
            if (i == 1) {
                list = (List) c09661.L$1;
                proactiveMessagingManager = (ProactiveMessagingManager) c09661.L$0;
                ResultKt.throwOnFailure(objHasActiveConversations);
            } else {
                if (i == 2) {
                    it = (Iterator) c09661.L$2;
                    iterable = (Iterable) c09661.L$1;
                    proactiveMessagingManager2 = (ProactiveMessagingManager) c09661.L$0;
                    ResultKt.throwOnFailure(objHasActiveConversations);
                    while (it.hasNext()) {
                        EvaluationResult evaluationResult = (EvaluationResult) it.next();
                        proactiveMessagingRepository = proactiveMessagingManager2.proactiveMessagingRepository;
                        campaign = evaluationResult.getCampaign();
                        c09661.L$0 = proactiveMessagingManager2;
                        c09661.L$1 = iterable;
                        c09661.L$2 = it;
                        c09661.label = 2;
                        if (proactiveMessagingRepository.updateFilterOutCampaigns(campaign, c09661) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                    arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterable, 10));
                    for (EvaluationResult evaluationResult2 : iterable) {
                        String campaignId = evaluationResult2.getCampaign().getCampaignId();
                        List<Path> successfulPaths = evaluationResult2.getSuccessfulPaths();
                        arrayList2 = new ArrayList(CollectionsKt.collectionSizeOrDefault(successfulPaths, 10));
                        it2 = successfulPaths.iterator();
                        while (it2.hasNext()) {
                            arrayList2.add(((Path) it2.next()).getPathId());
                        }
                        arrayList.add(new CampaignPathDto(campaignId, arrayList2, evaluationResult2.getCampaign().getVersion()));
                    }
                    ProactiveMessagingRepository proactiveMessagingRepository2 = proactiveMessagingManager2.proactiveMessagingRepository;
                    c09661.L$0 = proactiveMessagingManager2;
                    c09661.L$1 = null;
                    c09661.L$2 = null;
                    c09661.label = 3;
                    objHasActiveConversations = proactiveMessagingRepository2.getProactiveMessage(arrayList, c09661);
                    if (objHasActiveConversations == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    c09662 = c09661;
                    proactiveMessagingManager3 = proactiveMessagingManager2;
                    ctsResponseDto = (CtsResponseDto) objHasActiveConversations;
                    if ((ctsResponseDto != null ? ctsResponseDto.getJwt() : null) != null) {
                        conversationKit = proactiveMessagingManager3.conversationKit;
                        c09662.L$0 = proactiveMessagingManager3;
                        c09662.L$1 = proactiveMessageBuildProactiveMessage;
                        c09662.label = 4;
                        if (conversationKit.addProactiveMessage(proactiveMessageBuildProactiveMessage, c09662) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        proactiveMessage = proactiveMessageBuildProactiveMessage;
                    }
                    return Unit.INSTANCE;
                }
                if (i == 3) {
                    ProactiveMessagingManager proactiveMessagingManager4 = (ProactiveMessagingManager) c09661.L$0;
                    ResultKt.throwOnFailure(objHasActiveConversations);
                    C09661 c09663 = c09661;
                    proactiveMessagingManager3 = proactiveMessagingManager4;
                    c09662 = c09663;
                    ctsResponseDto = (CtsResponseDto) objHasActiveConversations;
                    if ((ctsResponseDto != null ? ctsResponseDto.getJwt() : null) != null && (proactiveMessageBuildProactiveMessage = proactiveMessagingManager3.proactiveMessagingRepository.buildProactiveMessage(ctsResponseDto.getJwt())) != null) {
                        conversationKit = proactiveMessagingManager3.conversationKit;
                        c09662.L$0 = proactiveMessagingManager3;
                        c09662.L$1 = proactiveMessageBuildProactiveMessage;
                        c09662.label = 4;
                        if (conversationKit.addProactiveMessage(proactiveMessageBuildProactiveMessage, c09662) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                        proactiveMessage = proactiveMessageBuildProactiveMessage;
                    }
                    return Unit.INSTANCE;
                }
                if (i != 4) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                proactiveMessage = (ProactiveMessage) c09661.L$1;
                proactiveMessagingManager3 = (ProactiveMessagingManager) c09661.L$0;
                ResultKt.throwOnFailure(objHasActiveConversations);
            }
            proactiveMessagingManager3.conversationKit.dispatchEvent(new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationWillDisplay(proactiveMessage)));
            return Unit.INSTANCE;
        }
        if (((Boolean) objHasActiveConversations).booleanValue()) {
            Logger.m217d(LOG_TAG, "User has an active conversation, can't report to CTS", new Object[0]);
            return Unit.INSTANCE;
        }
        List<EvaluationResult> list2 = list;
        proactiveMessagingManager2 = proactiveMessagingManager;
        iterable = list2;
        it = list2.iterator();
        while (it.hasNext()) {
            EvaluationResult evaluationResult3 = (EvaluationResult) it.next();
            proactiveMessagingRepository = proactiveMessagingManager2.proactiveMessagingRepository;
            campaign = evaluationResult3.getCampaign();
            c09661.L$0 = proactiveMessagingManager2;
            c09661.L$1 = iterable;
            c09661.L$2 = it;
            c09661.label = 2;
            if (proactiveMessagingRepository.updateFilterOutCampaigns(campaign, c09661) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(iterable, 10));
        while (r2.hasNext()) {
            String campaignId2 = evaluationResult2.getCampaign().getCampaignId();
            List<Path> successfulPaths2 = evaluationResult2.getSuccessfulPaths();
            arrayList2 = new ArrayList(CollectionsKt.collectionSizeOrDefault(successfulPaths2, 10));
            it2 = successfulPaths2.iterator();
            while (it2.hasNext()) {
                arrayList2.add(((Path) it2.next()).getPathId());
            }
            arrayList.add(new CampaignPathDto(campaignId2, arrayList2, evaluationResult2.getCampaign().getVersion()));
        }
        ProactiveMessagingRepository proactiveMessagingRepository3 = proactiveMessagingManager2.proactiveMessagingRepository;
        c09661.L$0 = proactiveMessagingManager2;
        c09661.L$1 = null;
        c09661.L$2 = null;
        c09661.label = 3;
        objHasActiveConversations = proactiveMessagingRepository3.getProactiveMessage(arrayList, c09661);
        if (objHasActiveConversations == coroutine_suspended) {
            return coroutine_suspended;
        }
        c09662 = c09661;
        proactiveMessagingManager3 = proactiveMessagingManager2;
        ctsResponseDto = (CtsResponseDto) objHasActiveConversations;
        if ((ctsResponseDto != null ? ctsResponseDto.getJwt() : null) != null) {
            conversationKit = proactiveMessagingManager3.conversationKit;
            c09662.L$0 = proactiveMessagingManager3;
            c09662.L$1 = proactiveMessageBuildProactiveMessage;
            c09662.label = 4;
            if (conversationKit.addProactiveMessage(proactiveMessageBuildProactiveMessage, c09662) == coroutine_suspended) {
                return coroutine_suspended;
            }
            proactiveMessage = proactiveMessageBuildProactiveMessage;
            proactiveMessagingManager3.conversationKit.dispatchEvent(new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationWillDisplay(proactiveMessage)));
        }
        return Unit.INSTANCE;
    }
}
