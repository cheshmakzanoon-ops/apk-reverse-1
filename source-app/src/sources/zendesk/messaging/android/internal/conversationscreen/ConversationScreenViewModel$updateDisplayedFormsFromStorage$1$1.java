package zendesk.messaging.android.internal.conversationscreen;

import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.MutableStateFlow;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.http2.Http2Connection;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {TrackType.TRACK_FORM_ACTION_SUBMITTED}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final String $id;
    int label;
    final ConversationScreenViewModel this$0;

    ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1(ConversationScreenViewModel conversationScreenViewModel, String str, Continuation<? super ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1> continuation) {
        super(2, continuation);
        this.this$0 = conversationScreenViewModel;
        this.$id = str;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1(this.this$0, this.$id, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object localStoredForms;
        Object value;
        ConversationScreenState conversationScreenState;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            localStoredForms = this.this$0.conversationScreenRepository.getLocalStoredForms(this.$id, this);
            if (localStoredForms == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            localStoredForms = obj;
        }
        Map map = (Map) localStoredForms;
        MutableStateFlow mutableStateFlow = this.this$0._conversationScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            conversationScreenState = (ConversationScreenState) value;
        } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : map, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        return Unit.INSTANCE;
    }
}
