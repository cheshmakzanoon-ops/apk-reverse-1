package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelKt;
import java.util.Collection;
import java.util.List;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.p011ws.WebSocketProtocol;
import zendesk.guidekit.android.GuideKit;
import zendesk.guidekit.android.exception.RestrictedArticleException;
import zendesk.guidekit.android.model.GuideArticle;
import zendesk.guidekit.android.model.GuideArticleUrl;
import zendesk.guidekit.android.model.GuideLocale;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.mapper.ArticleAttachmentItemMapperKt;
import zendesk.messaging.android.internal.model.MessagingTheme;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0000\u0018\u0000 \u001e2\u00020\u0001:\u0001\u001eB\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0002J\u000e\u0010\u0018\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0019J\u0010\u0010\u001a\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u001bH\u0002J\f\u0010\u001c\u001a\u00020\u001d*\u00020\u0005H\u0002R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\u00050\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00050\r¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0017\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u000b0\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModel;", "Landroidx/lifecycle/ViewModel;", "guideKit", "Lzendesk/guidekit/android/GuideKit;", "initialState", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;", "(Lzendesk/guidekit/android/GuideKit;Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerState;)V", "_articleViewerState", "Lkotlinx/coroutines/flow/MutableStateFlow;", "_eventsChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerEvent;", "articleViewerState", "Lkotlinx/coroutines/flow/StateFlow;", "getArticleViewerState", "()Lkotlinx/coroutines/flow/StateFlow;", "eventsChannel", "Lkotlinx/coroutines/flow/Flow;", "getEventsChannel", "()Lkotlinx/coroutines/flow/Flow;", "loadGuideArticle", "", "action", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$Load;", "process", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction;", "updateTheme", "Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerAction$RefreshTheme;", "shouldUpdateBackStack", "", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class GuideArticleViewerViewModel extends ViewModel {
    private static final Companion Companion = new Companion(null);
    private static final String LOG_TAG = "GuideArticleVM";
    private final MutableStateFlow<GuideArticleViewerState> _articleViewerState;
    private final Channel<GuideArticleViewerEvent> _eventsChannel;
    private final StateFlow<GuideArticleViewerState> articleViewerState;
    private final Flow<GuideArticleViewerEvent> eventsChannel;
    private final GuideKit guideKit;

    public GuideArticleViewerViewModel(GuideKit guideKit, GuideArticleViewerState.Idle idle, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(guideKit, (i & 2) != 0 ? new GuideArticleViewerState.Idle(CollectionsKt.emptyList(), "", MessagingTheme.INSTANCE.getDEFAULT()) : idle);
    }

    public GuideArticleViewerViewModel(GuideKit guideKit, GuideArticleViewerState initialState) {
        Intrinsics.checkNotNullParameter(guideKit, "guideKit");
        Intrinsics.checkNotNullParameter(initialState, "initialState");
        this.guideKit = guideKit;
        MutableStateFlow<GuideArticleViewerState> MutableStateFlow = StateFlowKt.MutableStateFlow(initialState);
        this._articleViewerState = MutableStateFlow;
        this.articleViewerState = FlowKt.asStateFlow(MutableStateFlow);
        Channel<GuideArticleViewerEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._eventsChannel = channelChannel$default;
        this.eventsChannel = FlowKt.receiveAsFlow(channelChannel$default);
    }

    public final StateFlow<GuideArticleViewerState> getArticleViewerState() {
        return this.articleViewerState;
    }

    public final Flow<GuideArticleViewerEvent> getEventsChannel() {
        return this.eventsChannel;
    }

    public final void process(GuideArticleViewerAction action) {
        GuideArticleViewerState value;
        Intrinsics.checkNotNullParameter(action, "action");
        if (Intrinsics.areEqual(action, GuideArticleViewerAction.Back.INSTANCE)) {
            String str = (String) CollectionsKt.lastOrNull((List) this.articleViewerState.getValue().getBackStack());
            if (str == null) {
                BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14302(null), 3, null);
                return;
            }
            List listDropLast = CollectionsKt.dropLast(this.articleViewerState.getValue().getBackStack(), 1);
            MutableStateFlow<GuideArticleViewerState> mutableStateFlow = this._articleViewerState;
            do {
                value = mutableStateFlow.getValue();
            } while (!mutableStateFlow.compareAndSet(value, new GuideArticleViewerState.Idle(listDropLast, str, value.getMessagingTheme())));
            process(new GuideArticleViewerAction.Load(str));
            return;
        }
        if (action instanceof GuideArticleViewerAction.Load) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14313(action, null), 3, null);
            return;
        }
        if (action instanceof GuideArticleViewerAction.RefreshTheme) {
            updateTheme((GuideArticleViewerAction.RefreshTheme) action);
            return;
        }
        if (Intrinsics.areEqual(action, GuideArticleViewerAction.Reload.INSTANCE)) {
            process(new GuideArticleViewerAction.Load(this.articleViewerState.getValue().getUrl()));
        } else if (action instanceof GuideArticleViewerAction.OpenAttachment) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14324(action, null), 3, null);
        } else if (Intrinsics.areEqual(action, GuideArticleViewerAction.Share.INSTANCE)) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14335(null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$process$2", m37f = "GuideArticleViewerViewModel.kt", m38i = {}, m39l = {65}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14302 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14302(Continuation<? super C14302> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerViewModel.this.new C14302(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14302) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (GuideArticleViewerViewModel.this._eventsChannel.send(GuideArticleViewerEvent.Close.INSTANCE, this) == coroutine_suspended) {
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

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$process$3", m37f = "GuideArticleViewerViewModel.kt", m38i = {}, m39l = {72, 87}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14313 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final GuideArticleViewerAction $action;
        int label;

        C14313(GuideArticleViewerAction guideArticleViewerAction, Continuation<? super C14313> continuation) {
            super(2, continuation);
            this.$action = guideArticleViewerAction;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerViewModel.this.new C14313(this.$action, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14313) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            GuideArticleViewerState guideArticleViewerState;
            GuideArticleViewerAction.Load load;
            List<String> backStack;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = GuideArticleViewerViewModel.this.guideKit.isValidGuideUrl(((GuideArticleViewerAction.Load) this.$action).getUrl(), this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            if (((Boolean) obj).booleanValue()) {
                MutableStateFlow mutableStateFlow = GuideArticleViewerViewModel.this._articleViewerState;
                GuideArticleViewerAction guideArticleViewerAction = this.$action;
                GuideArticleViewerViewModel guideArticleViewerViewModel = GuideArticleViewerViewModel.this;
                do {
                    value = mutableStateFlow.getValue();
                    guideArticleViewerState = (GuideArticleViewerState) value;
                    load = (GuideArticleViewerAction.Load) guideArticleViewerAction;
                    boolean zAreEqual = Intrinsics.areEqual(guideArticleViewerState.getUrl(), load.getUrl());
                    if (guideArticleViewerViewModel.shouldUpdateBackStack(guideArticleViewerState) && !zAreEqual) {
                        backStack = CollectionsKt.plus((Collection<? extends String>) guideArticleViewerState.getBackStack(), guideArticleViewerState.getUrl());
                    } else {
                        backStack = guideArticleViewerState.getBackStack();
                    }
                } while (!mutableStateFlow.compareAndSet(value, new GuideArticleViewerState.Loading(backStack, load.getUrl(), guideArticleViewerState.getMessagingTheme())));
                GuideArticleViewerViewModel.this.loadGuideArticle((GuideArticleViewerAction.Load) this.$action);
            } else {
                this.label = 2;
                if (GuideArticleViewerViewModel.this._eventsChannel.send(new GuideArticleViewerEvent.LoadUrlInBrowser(((GuideArticleViewerAction.Load) this.$action).getUrl()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$process$4", m37f = "GuideArticleViewerViewModel.kt", m38i = {}, m39l = {102}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14324 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final GuideArticleViewerAction $action;
        int label;

        C14324(GuideArticleViewerAction guideArticleViewerAction, Continuation<? super C14324> continuation) {
            super(2, continuation);
            this.$action = guideArticleViewerAction;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerViewModel.this.new C14324(this.$action, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14324) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (GuideArticleViewerViewModel.this._eventsChannel.send(new GuideArticleViewerEvent.LoadUrlInBrowser(((GuideArticleViewerAction.OpenAttachment) this.$action).getAttachment().getContentUrl()), this) == coroutine_suspended) {
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

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$process$5", m37f = "GuideArticleViewerViewModel.kt", m38i = {}, m39l = {108}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14335 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14335(Continuation<? super C14335> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerViewModel.this.new C14335(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14335) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (GuideArticleViewerViewModel.this._eventsChannel.send(new GuideArticleViewerEvent.ShareUrl(GuideArticleViewerViewModel.this.getArticleViewerState().getValue().getUrl()), this) == coroutine_suspended) {
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

    private final void updateTheme(GuideArticleViewerAction.RefreshTheme action) {
        GuideArticleViewerState value;
        if (Intrinsics.areEqual(action.getTheme(), this.articleViewerState.getValue().getMessagingTheme())) {
            return;
        }
        MutableStateFlow<GuideArticleViewerState> mutableStateFlow = this._articleViewerState;
        do {
            value = mutableStateFlow.getValue();
        } while (!mutableStateFlow.compareAndSet(value, GuideArticleViewerState.sealedCopy$default(value, null, null, action.getTheme(), 3, null)));
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$loadGuideArticle$1", m37f = "GuideArticleViewerViewModel.kt", m38i = {1}, m39l = {125, WebSocketProtocol.PAYLOAD_SHORT, 142}, m40m = "invokeSuspend", m41n = {"articleLink"}, m42s = {"L$0"})
    static final class C14291 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final GuideArticleViewerAction.Load $action;
        Object L$0;
        int label;

        C14291(GuideArticleViewerAction.Load load, Continuation<? super C14291> continuation) {
            super(2, continuation);
            this.$action = load;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return GuideArticleViewerViewModel.this.new C14291(this.$action, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14291) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            GuideArticleViewerState guideArticleViewerState;
            Object objMo2112getGuideArticleLinkgIAlus;
            GuideArticleUrl guideArticleUrl;
            Object objMo2111getArticleBWLJW6A;
            GuideArticle guideArticle;
            MutableStateFlow mutableStateFlow;
            Object value2;
            GuideArticleViewerState guideArticleViewerState2;
            List<String> backStack;
            String url;
            String title;
            String str;
            String htmlBody;
            String str2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    objMo2112getGuideArticleLinkgIAlus = GuideArticleViewerViewModel.this.guideKit.mo2112getGuideArticleLinkgIAlus(this.$action.getUrl(), this);
                    if (objMo2112getGuideArticleLinkgIAlus == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i == 1) {
                        ResultKt.throwOnFailure(obj);
                        objMo2112getGuideArticleLinkgIAlus = ((Result) obj).getValue();
                    } else if (i == 2) {
                        guideArticleUrl = (GuideArticleUrl) this.L$0;
                        ResultKt.throwOnFailure(obj);
                        objMo2111getArticleBWLJW6A = ((Result) obj).getValue();
                        ResultKt.throwOnFailure(objMo2111getArticleBWLJW6A);
                        guideArticle = (GuideArticle) objMo2111getArticleBWLJW6A;
                        mutableStateFlow = GuideArticleViewerViewModel.this._articleViewerState;
                        do {
                            value2 = mutableStateFlow.getValue();
                            guideArticleViewerState2 = (GuideArticleViewerState) value2;
                            backStack = guideArticleViewerState2.getBackStack();
                            url = guideArticleViewerState2.getUrl();
                            title = guideArticle.getTitle();
                            if (title == null) {
                                str = "";
                            } else {
                                str = title;
                            }
                            htmlBody = guideArticle.getHtmlBody();
                            if (htmlBody == null) {
                                str2 = "";
                            } else {
                                str2 = htmlBody;
                            }
                        } while (!mutableStateFlow.compareAndSet(value2, new GuideArticleViewerState.SuccessGuideArticle(backStack, url, str, str2, ArticleAttachmentItemMapperKt.toArticleAttachmentList(guideArticle.getAttachments()), guideArticleViewerState2.getMessagingTheme())));
                        this.L$0 = null;
                        this.label = 3;
                        if (GuideArticleViewerViewModel.this.guideKit.mo2113sendArticleStatsViewBWLJW6A(guideArticleUrl.getUrl(), guideArticleUrl.getArticleId(), GuideLocale.INSTANCE.toGuideLocale(guideArticle.getLocale()), this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 3) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                        ((Result) obj).getValue();
                    }
                    return Unit.INSTANCE;
                }
                ResultKt.throwOnFailure(objMo2112getGuideArticleLinkgIAlus);
                guideArticleUrl = (GuideArticleUrl) objMo2112getGuideArticleLinkgIAlus;
                this.L$0 = guideArticleUrl;
                this.label = 2;
                objMo2111getArticleBWLJW6A = GuideArticleViewerViewModel.this.guideKit.mo2111getArticleBWLJW6A(this.$action.getUrl(), guideArticleUrl.getArticleId(), guideArticleUrl.getLocale(), this);
                if (objMo2111getArticleBWLJW6A == coroutine_suspended) {
                    return coroutine_suspended;
                }
                ResultKt.throwOnFailure(objMo2111getArticleBWLJW6A);
                guideArticle = (GuideArticle) objMo2111getArticleBWLJW6A;
                mutableStateFlow = GuideArticleViewerViewModel.this._articleViewerState;
                do {
                    value2 = mutableStateFlow.getValue();
                    guideArticleViewerState2 = (GuideArticleViewerState) value2;
                    backStack = guideArticleViewerState2.getBackStack();
                    url = guideArticleViewerState2.getUrl();
                    title = guideArticle.getTitle();
                    if (title == null) {
                        str = "";
                    } else {
                        str = title;
                    }
                    htmlBody = guideArticle.getHtmlBody();
                    if (htmlBody == null) {
                        str2 = "";
                    } else {
                        str2 = htmlBody;
                    }
                } while (!mutableStateFlow.compareAndSet(value2, new GuideArticleViewerState.SuccessGuideArticle(backStack, url, str, str2, ArticleAttachmentItemMapperKt.toArticleAttachmentList(guideArticle.getAttachments()), guideArticleViewerState2.getMessagingTheme())));
                this.L$0 = null;
                this.label = 3;
                if (GuideArticleViewerViewModel.this.guideKit.mo2113sendArticleStatsViewBWLJW6A(guideArticleUrl.getUrl(), guideArticleUrl.getArticleId(), GuideLocale.INSTANCE.toGuideLocale(guideArticle.getLocale()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (RestrictedArticleException unused) {
                BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(GuideArticleViewerViewModel.this), null, null, new AnonymousClass2(GuideArticleViewerViewModel.this, this.$action, null), 3, null);
            } catch (Exception e) {
                Logger.m218e(GuideArticleViewerViewModel.LOG_TAG, "Failed to load a guide article link", e, new Object[0]);
                MutableStateFlow mutableStateFlow2 = GuideArticleViewerViewModel.this._articleViewerState;
                do {
                    value = mutableStateFlow2.getValue();
                    guideArticleViewerState = (GuideArticleViewerState) value;
                } while (!mutableStateFlow2.compareAndSet(value, new GuideArticleViewerState.Error(guideArticleViewerState.getBackStack(), guideArticleViewerState.getUrl(), guideArticleViewerState.getMessagingTheme())));
            }
            return Unit.INSTANCE;
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModel$loadGuideArticle$1$2", m37f = "GuideArticleViewerViewModel.kt", m38i = {}, m39l = {149, TrackType.TRACK_FAQ_CHECKED}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            final GuideArticleViewerAction.Load $action;
            int label;
            final GuideArticleViewerViewModel this$0;

            AnonymousClass2(GuideArticleViewerViewModel guideArticleViewerViewModel, GuideArticleViewerAction.Load load, Continuation<? super AnonymousClass2> continuation) {
                super(2, continuation);
                this.this$0 = guideArticleViewerViewModel;
                this.$action = load;
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass2(this.this$0, this.$action, continuation);
            }

            @Override
            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return ((AnonymousClass2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (this.this$0._eventsChannel.send(new GuideArticleViewerEvent.LoadUrlInBrowser(this.$action.getUrl()), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i == 1) {
                        ResultKt.throwOnFailure(obj);
                    } else {
                        if (i != 2) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    return Unit.INSTANCE;
                }
                if (this.this$0.getArticleViewerState().getValue().getBackStack().isEmpty()) {
                    this.label = 2;
                    if (this.this$0._eventsChannel.send(GuideArticleViewerEvent.Close.INSTANCE, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    this.this$0.process(GuideArticleViewerAction.Back.INSTANCE);
                }
                return Unit.INSTANCE;
            }
        }
    }

    public final void loadGuideArticle(GuideArticleViewerAction.Load action) {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C14291(action, null), 3, null);
    }

    public final boolean shouldUpdateBackStack(GuideArticleViewerState guideArticleViewerState) {
        return guideArticleViewerState instanceof GuideArticleViewerState.SuccessGuideArticle;
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/guidearticleviewer/GuideArticleViewerViewModel$Companion;", "", "()V", "LOG_TAG", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
