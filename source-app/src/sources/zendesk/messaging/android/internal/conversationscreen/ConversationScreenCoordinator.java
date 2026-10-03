package zendesk.messaging.android.internal.conversationscreen;

import android.os.Build;
import java.util.List;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.StateFlow;
import okhttp3.internal.http2.Http2Connection;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.MessagingDelegate;
import zendesk.android.messaging.UrlSource;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.AttachmentIntents;
import zendesk.messaging.android.internal.AttachmentIntentsLauncher;
import zendesk.messaging.android.internal.KnownUriSchemes;
import zendesk.messaging.android.internal.UriHandler;
import zendesk.messaging.android.internal.VisibleScreen;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.WebViewUriHandler;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.UploadFile;
import zendesk.messaging.android.internal.permissions.RuntimePermissionRequester;
import zendesk.p026ui.android.conversation.carousel.CarouselAction;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.ui.android.Renderer;

@Metadata(m17d1 = {"\u0000ä\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0014\b\u0000\u0018\u0000 e2\u00020\u0001:\u0001eB«\u0001\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0014\u0010\u0005\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0004\u0012\u00020\b0\u0006\u0012\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\b0\n\u0012\u0012\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\b0\u0006\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012\u0012\u0006\u0010\u0013\u001a\u00020\u0014\u0012\u0006\u0010\u0015\u001a\u00020\u0016\u0012\u0006\u0010\u0017\u001a\u00020\u0018\u0012\u0006\u0010\u0019\u001a\u00020\u001a\u0012\u0016\u0010\u001b\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\u001c\u0012\u0006\u0010\u001d\u001a\u00020\u001e\u0012\u0006\u0010\u001f\u001a\u00020 ¢\u0006\u0002\u0010!J\b\u0010F\u001a\u00020\bH\u0002J\r\u0010G\u001a\u00020\bH\u0000¢\u0006\u0002\bHJ\u001b\u0010I\u001a\u00020\b2\f\u0010J\u001a\b\u0012\u0004\u0012\u00020K00H\u0000¢\u0006\u0002\bLJ\r\u0010M\u001a\u00020\bH\u0000¢\u0006\u0002\bNJ$\u0010O\u001a\u00020\b2\u0006\u0010P\u001a\u00020\u00072\u0006\u0010Q\u001a\u00020R2\f\u0010S\u001a\b\u0012\u0004\u0012\u00020\b0\nJ\u0010\u0010T\u001a\u00020\bH\u0080@¢\u0006\u0004\bU\u0010VJ\r\u0010W\u001a\u00020\bH\u0000¢\u0006\u0002\bXJ\r\u0010Y\u001a\u00020\bH\u0000¢\u0006\u0002\bZJ\b\u0010[\u001a\u00020\bH\u0002J\u0018\u0010\\\u001a\u00020\b2\u0006\u0010]\u001a\u00020\u00072\u0006\u0010^\u001a\u00020\u0007H\u0002J\u0010\u0010_\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\u0018H\u0002J\u0016\u0010`\u001a\u00020\b2\u0006\u0010\u0017\u001a\u00020\u0018H\u0082@¢\u0006\u0002\u0010aJ\u001e\u0010b\u001a\u00020\b2\u0006\u0010c\u001a\u0002082\f\u0010d\u001a\b\u0012\u0004\u0012\u00020\b0\nH\u0002R\u000e\u0010\u001f\u001a\u00020 X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0011\u001a\u00020\u0012X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0017\u001a\u00020\u0018X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0019\u001a\u00020\u001aX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u000b\u001a\u000e\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u001c\u0010\u0005\u001a\u0010\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\"\u001a\u0012\u0012\u0004\u0012\u00020#\u0012\u0004\u0012\u00020\b0\u0006j\u0002`$X\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010%\u001a\"\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u00060&X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\u001b\u001a\u0012\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u0006j\u0002`\u001cX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010'\u001a\b\u0012\u0004\u0012\u00020\b0\nX\u0082\u0004¢\u0006\u0002\n\u0000RA\u0010(\u001a5\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012#\u0012!\u0012\u0013\u0012\u00110)¢\u0006\f\b*\u0012\b\b+\u0012\u0004\b\b(,\u0012\u0004\u0012\u00020\b0\u0006j\u0002`-0&X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010.\u001a\u000e\u0012\u0004\u0012\u00020)\u0012\u0004\u0012\u00020\b0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R>\u0010/\u001a2\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012 \u0012\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020100\u0012\u0004\u0012\u000202\u0012\u0004\u0012\u00020\b0&j\u0002`30&X\u0082\u0004¢\u0006\u0002\n\u0000R2\u00104\u001a&\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u001a\u0012\u0018\u0012\u0004\u0012\u000205\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0&j\u0002`60\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R*\u00107\u001a\u001e\u0012\u0004\u0012\u00020\u0018\u0012\u0014\u0012\u0012\u0012\u0004\u0012\u000208\u0012\u0004\u0012\u00020\b0\u0006j\u0002`90\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010:\u001a\"\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020;\u0012\u0004\u0012\u00020\b0\u00060&X\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010<\u001a\"\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020=\u0012\u0004\u0012\u00020\b0\u00060&X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010>\u001a\u0018\u0012\u0004\u0012\u00020\u0018\u0012\u000e\u0012\f\u0012\u0004\u0012\u00020\b0\nj\u0002`?0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010@\u001a\b\u0012\u0004\u0012\u00020\b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010A\u001a\b\u0012\u0004\u0012\u00020\b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R.\u0010B\u001a\"\u0012\u0004\u0012\u00020\u0018\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0\u00060&X\u0082\u0004¢\u0006\u0002\n\u0000R$\u0010C\u001a\u0018\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\u0007\u0012\u0004\u0012\u00020\b0&j\u0002`DX\u0082\u0004¢\u0006\u0002\n\u0000R\"\u0010E\u001a\u0016\u0012\u0006\u0012\u0004\u0018\u00010\u0007\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0\n0\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001d\u001a\u00020\u001eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenCoordinator;", "", "conversationScreenRenderer", "Lzendesk/ui/android/Renderer;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRendering;", "onBackButtonClicked", "Lkotlin/Function1;", "", "", "onDeniedPermissionActionClicked", "Lkotlin/Function0;", "onAttachMenuItemClicked", "", "uriHandler", "Lzendesk/messaging/android/internal/UriHandler;", "webViewUriHandler", "Lzendesk/messaging/android/internal/WebViewUriHandler;", "attachmentIntents", "Lzendesk/messaging/android/internal/AttachmentIntents;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "visibleScreenTracker", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "conversationScreenViewModel", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "onCopyTextAction", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCopyTextAction;", "permissionRequester", "Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;", "attachmentIntentLauncher", "Lzendesk/messaging/android/internal/AttachmentIntentsLauncher;", "(Lzendesk/ui/android/Renderer;Lkotlin/jvm/functions/Function1;Lkotlin/jvm/functions/Function0;Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/UriHandler;Lzendesk/messaging/android/internal/WebViewUriHandler;Lzendesk/messaging/android/internal/AttachmentIntents;Lkotlinx/coroutines/CoroutineScope;Lzendesk/messaging/android/internal/VisibleScreenTracker;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;Lzendesk/android/messaging/model/MessagingSettings;Lkotlin/jvm/functions/Function1;Lzendesk/messaging/android/internal/permissions/RuntimePermissionRequester;Lzendesk/messaging/android/internal/AttachmentIntentsLauncher;)V", "onCarouselAction", "Lzendesk/ui/android/conversation/carousel/CarouselAction;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnCarouselAction;", "onComposerTextChanged", "Lkotlin/Function2;", "onDeniedPermissionDismissed", "onFailedMessageClicked", "Lzendesk/conversationkit/android/model/Message;", "Lkotlin/ParameterName;", "name", "message", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFailedMessageClickedListener;", "onFileAttachmentClicked", "onFormCompletedProvider", "", "Lzendesk/conversationkit/android/model/Field;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormCompleted;", "onFormDisplayedFieldsChanged", "Lzendesk/ui/android/conversation/form/DisplayedField;", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormDisplayedFieldsChanged;", "onFormFocusChanged", "", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnFormFocusChangedListener;", "onLoadMoreMessages", "", "onReplyActionSelectedProvider", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "onRetryConnectionClicked", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnRetryConnectionClickedListener;", "onRetryLoadConversation", "onSeeLatestViewClicked", "onSendButtonClickedProvider", "onSendPostBackMessage", "Lzendesk/messaging/android/internal/conversationscreen/messagelog/OnSendPostbackMessage;", "onTyping", "capturePhoto", "clearNewMessagesDivider", "clearNewMessagesDivider$zendesk_messaging_messaging_android", "dispatchUploadFilesAction", "uploads", "Lzendesk/messaging/android/internal/model/UploadFile;", "dispatchUploadFilesAction$zendesk_messaging_messaging_android", "dispatchUploadFilesForRestoredUrisAction", "dispatchUploadFilesForRestoredUrisAction$zendesk_messaging_messaging_android", "handleUri", "uri", "urlSource", "Lzendesk/android/messaging/UrlSource;", "launchIntent", "init", "init$zendesk_messaging_messaging_android", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "launchCamera", "launchCamera$zendesk_messaging_messaging_android", "launchGallery", "launchGallery$zendesk_messaging_messaging_android", "openGallery", "sendPostbackMessage", "actionId", "text", "setupScreenEvents", "setupWithStore", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "showPermissionDialogIfNeeded", "isGranted", "action", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenCoordinator {
    private static final String LOG_TAG = "ConversationScreenCoordinator";
    private final AttachmentIntentsLauncher attachmentIntentLauncher;
    private final AttachmentIntents attachmentIntents;
    private final Renderer<ConversationScreenRendering> conversationScreenRenderer;
    private final ConversationScreenViewModel conversationScreenViewModel;
    private final CoroutineScope coroutineScope;
    private final MessagingSettings messagingSettings;
    private final Function1<Integer, Unit> onAttachMenuItemClicked;
    private final Function1<String, Unit> onBackButtonClicked;
    private final Function1<CarouselAction, Unit> onCarouselAction;
    private final Function2<ConversationScreenViewModel, String, Function1<String, Unit>> onComposerTextChanged;
    private final Function1<String, Unit> onCopyTextAction;
    private final Function0<Unit> onDeniedPermissionActionClicked;
    private final Function0<Unit> onDeniedPermissionDismissed;
    private final Function2<ConversationScreenViewModel, String, Function1<Message, Unit>> onFailedMessageClicked;
    private final Function1<Message, Unit> onFileAttachmentClicked;
    private final Function2<ConversationScreenViewModel, String, Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit>> onFormCompletedProvider;
    private final Function1<String, Function2<DisplayedField, String, Unit>> onFormDisplayedFieldsChanged;
    private final Function1<ConversationScreenViewModel, Function1<Boolean, Unit>> onFormFocusChanged;
    private final Function2<ConversationScreenViewModel, String, Function1<Double, Unit>> onLoadMoreMessages;
    private final Function2<ConversationScreenViewModel, String, Function1<MessageAction.Reply, Unit>> onReplyActionSelectedProvider;
    private final Function1<ConversationScreenViewModel, Function0<Unit>> onRetryConnectionClicked;
    private final Function0<Unit> onRetryLoadConversation;
    private final Function0<Unit> onSeeLatestViewClicked;
    private final Function2<ConversationScreenViewModel, String, Function1<String, Unit>> onSendButtonClickedProvider;
    private final Function2<String, String, Unit> onSendPostBackMessage;
    private final Function1<String, Function0<Unit>> onTyping;
    private final RuntimePermissionRequester permissionRequester;
    private final UriHandler uriHandler;
    private final VisibleScreenTracker visibleScreenTracker;
    private final WebViewUriHandler webViewUriHandler;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenCoordinator", m37f = "ConversationScreenCoordinator.kt", m38i = {}, m39l = {484}, m40m = "setupWithStore", m41n = {}, m42s = {})
    static final class C12961 extends ContinuationImpl {
        int label;
        Object result;

        C12961(Continuation<? super C12961> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenCoordinator.this.setupWithStore(null, this);
        }
    }

    public ConversationScreenCoordinator(Renderer<ConversationScreenRendering> conversationScreenRenderer, Function1<? super String, Unit> onBackButtonClicked, Function0<Unit> onDeniedPermissionActionClicked, Function1<? super Integer, Unit> onAttachMenuItemClicked, UriHandler uriHandler, WebViewUriHandler webViewUriHandler, AttachmentIntents attachmentIntents, CoroutineScope coroutineScope, VisibleScreenTracker visibleScreenTracker, ConversationScreenViewModel conversationScreenViewModel, MessagingSettings messagingSettings, Function1<? super String, Unit> onCopyTextAction, RuntimePermissionRequester permissionRequester, AttachmentIntentsLauncher attachmentIntentLauncher) {
        Intrinsics.checkNotNullParameter(conversationScreenRenderer, "conversationScreenRenderer");
        Intrinsics.checkNotNullParameter(onBackButtonClicked, "onBackButtonClicked");
        Intrinsics.checkNotNullParameter(onDeniedPermissionActionClicked, "onDeniedPermissionActionClicked");
        Intrinsics.checkNotNullParameter(onAttachMenuItemClicked, "onAttachMenuItemClicked");
        Intrinsics.checkNotNullParameter(uriHandler, "uriHandler");
        Intrinsics.checkNotNullParameter(webViewUriHandler, "webViewUriHandler");
        Intrinsics.checkNotNullParameter(attachmentIntents, "attachmentIntents");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        Intrinsics.checkNotNullParameter(conversationScreenViewModel, "conversationScreenViewModel");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(onCopyTextAction, "onCopyTextAction");
        Intrinsics.checkNotNullParameter(permissionRequester, "permissionRequester");
        Intrinsics.checkNotNullParameter(attachmentIntentLauncher, "attachmentIntentLauncher");
        this.conversationScreenRenderer = conversationScreenRenderer;
        this.onBackButtonClicked = onBackButtonClicked;
        this.onDeniedPermissionActionClicked = onDeniedPermissionActionClicked;
        this.onAttachMenuItemClicked = onAttachMenuItemClicked;
        this.uriHandler = uriHandler;
        this.webViewUriHandler = webViewUriHandler;
        this.attachmentIntents = attachmentIntents;
        this.coroutineScope = coroutineScope;
        this.visibleScreenTracker = visibleScreenTracker;
        this.conversationScreenViewModel = conversationScreenViewModel;
        this.messagingSettings = messagingSettings;
        this.onCopyTextAction = onCopyTextAction;
        this.permissionRequester = permissionRequester;
        this.attachmentIntentLauncher = attachmentIntentLauncher;
        this.onSendButtonClickedProvider = (Function2) new Function2<ConversationScreenViewModel, String, Function1<? super String, ? extends Unit>>() {
            {
                super(2);
            }

            @Override
            public final Function1<String, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                final ConversationScreenCoordinator conversationScreenCoordinator = this.this$0;
                return new Function1<String, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(String str2) {
                        invoke2(str2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(String textMessage) {
                        Intrinsics.checkNotNullParameter(textMessage, "textMessage");
                        String str2 = str;
                        if (str2 != null) {
                            ConversationScreenCoordinator conversationScreenCoordinator2 = conversationScreenCoordinator;
                            ConversationScreenViewModel conversationScreenViewModel2 = store;
                            conversationScreenCoordinator2.conversationScreenViewModel.onSendMessage(str2);
                            conversationScreenViewModel2.dispatchAction(new ConversationScreenAction.SendTextMessage(textMessage, null, null, str2, 6, null));
                        }
                    }
                };
            }
        };
        this.onReplyActionSelectedProvider = new Function2<ConversationScreenViewModel, String, Function1<? super MessageAction.Reply, ? extends Unit>>() {
            @Override
            public final Function1<MessageAction.Reply, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function1<MessageAction.Reply, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(MessageAction.Reply reply) {
                        invoke2(reply);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(MessageAction.Reply replyAction) {
                        Intrinsics.checkNotNullParameter(replyAction, "replyAction");
                        String str2 = str;
                        if (str2 != null) {
                            store.dispatchAction(new ConversationScreenAction.SendTextMessage(replyAction.getText(), replyAction.getPayload(), replyAction.getMetadata(), str2));
                        }
                    }
                };
            }
        };
        this.onFailedMessageClicked = new Function2<ConversationScreenViewModel, String, Function1<? super Message, ? extends Unit>>() {
            @Override
            public final Function1<Message, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function1<Message, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Message message) {
                        invoke2(message);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(Message failedMessage) {
                        Intrinsics.checkNotNullParameter(failedMessage, "failedMessage");
                        String str2 = str;
                        if (str2 != null) {
                            store.dispatchAction(new ConversationScreenAction.ResendFailedMessage(failedMessage, str2));
                        }
                    }
                };
            }
        };
        this.onRetryConnectionClicked = new Function1<ConversationScreenViewModel, Function0<? extends Unit>>() {
            @Override
            public final Function0<Unit> invoke(final ConversationScreenViewModel store) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        store.dispatchAction(ConversationScreenAction.RetryConnection.INSTANCE);
                    }
                };
            }
        };
        this.onFormCompletedProvider = new Function2<ConversationScreenViewModel, String, Function2<? super List<? extends Field>, ? super MessageLogEntry.FormMessageContainer, ? extends Unit>>() {
            @Override
            public final Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function2<List<? extends Field>, MessageLogEntry.FormMessageContainer, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(List<? extends Field> list, MessageLogEntry.FormMessageContainer formMessageContainer) {
                        invoke2(list, formMessageContainer);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(List<? extends Field> fields, MessageLogEntry.FormMessageContainer formMessageContainer) {
                        Intrinsics.checkNotNullParameter(fields, "fields");
                        Intrinsics.checkNotNullParameter(formMessageContainer, "formMessageContainer");
                        String str2 = str;
                        if (str2 != null) {
                            store.dispatchAction(new ConversationScreenAction.SendFormResponse(fields, formMessageContainer, str2));
                        }
                    }
                };
            }
        };
        this.onFormFocusChanged = new Function1<ConversationScreenViewModel, Function1<? super Boolean, ? extends Unit>>() {
            @Override
            public final Function1<Boolean, Unit> invoke(final ConversationScreenViewModel store) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function1<Boolean, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Boolean bool) {
                        invoke(bool.booleanValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(boolean z) {
                        store.dispatchAction(new ConversationScreenAction.FormFocusChanged(z));
                    }
                };
            }
        };
        this.onComposerTextChanged = new Function2<ConversationScreenViewModel, String, Function1<? super String, ? extends Unit>>() {
            @Override
            public final Function1<String, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function1<String, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(String str2) {
                        invoke2(str2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(String composerText) {
                        Intrinsics.checkNotNullParameter(composerText, "composerText");
                        String str2 = str;
                        if (str2 != null) {
                            store.dispatchAction(new ConversationScreenAction.PersistComposerText(str2, composerText));
                        }
                    }
                };
            }
        };
        this.onFormDisplayedFieldsChanged = (Function1) new Function1<String, Function2<? super DisplayedField, ? super String, ? extends Unit>>() {
            {
                super(1);
            }

            @Override
            public final Function2<DisplayedField, String, Unit> invoke(final String str) {
                final ConversationScreenCoordinator conversationScreenCoordinator = this.this$0;
                return new Function2<DisplayedField, String, Unit>() {
                    {
                        super(2);
                    }

                    @Override
                    public Unit invoke(DisplayedField displayedField, String str2) {
                        invoke2(displayedField, str2);
                        return Unit.INSTANCE;
                    }

                    public final void invoke2(DisplayedField displayedField, String formId) {
                        Intrinsics.checkNotNullParameter(displayedField, "displayedField");
                        Intrinsics.checkNotNullParameter(formId, "formId");
                        String str2 = str;
                        if (str2 != null) {
                            conversationScreenCoordinator.conversationScreenViewModel.updateListOfStoredForm(displayedField, str2, formId);
                        }
                    }
                };
            }
        };
        this.onTyping = (Function1) new Function1<String, Function0<? extends Unit>>() {
            {
                super(1);
            }

            @Override
            public final Function0<Unit> invoke(final String str) {
                final ConversationScreenCoordinator conversationScreenCoordinator = this.this$0;
                return new Function0<Unit>() {
                    {
                        super(0);
                    }

                    @Override
                    public Unit invoke() {
                        invoke2();
                        return Unit.INSTANCE;
                    }

                    public final void invoke2() {
                        if (str != null) {
                            conversationScreenCoordinator.conversationScreenViewModel.onTyping(str);
                        }
                    }
                };
            }
        };
        this.onDeniedPermissionDismissed = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                this.this$0.conversationScreenViewModel.dispatchAction(ConversationScreenAction.HideDeniedPermission.INSTANCE);
            }
        };
        this.onLoadMoreMessages = new Function2<ConversationScreenViewModel, String, Function1<? super Double, ? extends Unit>>() {
            @Override
            public final Function1<Double, Unit> invoke(final ConversationScreenViewModel store, final String str) {
                Intrinsics.checkNotNullParameter(store, "store");
                return new Function1<Double, Unit>() {
                    {
                        super(1);
                    }

                    @Override
                    public Unit invoke(Double d) {
                        invoke(d.doubleValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(double d) {
                        String str2 = str;
                        if (str2 != null) {
                            store.dispatchAction(new ConversationScreenAction.LoadMoreMessages(str2, d));
                        }
                    }
                };
            }
        };
        this.onSeeLatestViewClicked = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                this.this$0.conversationScreenViewModel.dispatchAction(ConversationScreenAction.SeeLatestViewClicked.INSTANCE);
            }
        };
        this.onCarouselAction = new Function1<CarouselAction, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(CarouselAction carouselAction) {
                invoke2(carouselAction);
                return Unit.INSTANCE;
            }

            public final void invoke2(CarouselAction action) {
                Intrinsics.checkNotNullParameter(action, "action");
                if (action instanceof CarouselAction.Link) {
                    Logger.m221i("ConversationScreenCoordinator", "CarouselAction.Link " + action + " clicked", new Object[0]);
                    this.this$0.uriHandler.onUriClicked(((CarouselAction.Link) action).getUrl(), UrlSource.CAROUSEL, false);
                    return;
                }
                if (action instanceof CarouselAction.Postback) {
                    String id = action.getId();
                    Logger.m221i("ConversationScreenCoordinator", "CarouselAction.Postback " + id + " clicked", new Object[0]);
                    this.this$0.sendPostbackMessage(id, action.getText());
                    return;
                }
                if (action instanceof CarouselAction.WebView) {
                    Logger.m221i("ConversationScreenCoordinator", "CarouselAction.WebView " + action + " clicked", new Object[0]);
                    CarouselAction.WebView webView = (CarouselAction.WebView) action;
                    this.this$0.webViewUriHandler.onWebViewUriClicked(webView.getUrl(), webView.getSize(), UrlSource.WEBVIEW_MESSAGE_ACTION);
                    return;
                }
                if (action instanceof CarouselAction.Unsupported) {
                    Logger.m221i("ConversationScreenCoordinator", "UnSupported " + action + " clicked", new Object[0]);
                    return;
                }
                Logger.m221i("ConversationScreenCoordinator", "UnSupported " + action + " clicked", new Object[0]);
            }
        };
        this.onSendPostBackMessage = new Function2<String, String, Unit>() {
            {
                super(2);
            }

            @Override
            public Unit invoke(String str, String str2) {
                invoke2(str, str2);
                return Unit.INSTANCE;
            }

            public final void invoke2(String actionId, String text) {
                Intrinsics.checkNotNullParameter(actionId, "actionId");
                Intrinsics.checkNotNullParameter(text, "text");
                Logger.m221i("ConversationScreenCoordinator", "Button Postback " + actionId + " clicked", new Object[0]);
                this.this$0.sendPostbackMessage(actionId, text);
            }
        };
        this.onRetryLoadConversation = new Function0<Unit>() {
            {
                super(0);
            }

            @Override
            public Unit invoke() {
                invoke2();
                return Unit.INSTANCE;
            }

            public final void invoke2() {
                this.this$0.conversationScreenViewModel.dispatchAction(ConversationScreenAction.RetryLoadConversation.INSTANCE);
            }
        };
        this.onFileAttachmentClicked = new Function1<Message, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Message message) {
                invoke2(message);
                return Unit.INSTANCE;
            }

            public final void invoke2(Message it) {
                Intrinsics.checkNotNullParameter(it, "it");
                MessagingDelegate delegate = Messaging.INSTANCE.getDelegate();
                MessageContent content = it.getContent();
                Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.File");
                if (delegate.shouldHandleUrl(((MessageContent.File) content).getMediaUrl(), UrlSource.FILE)) {
                    this.this$0.conversationScreenViewModel.dispatchAction(new ConversationScreenAction.ViewAttachment(it));
                }
            }
        };
    }

    public final Object init$zendesk_messaging_messaging_android(Continuation<? super Unit> continuation) throws Throwable {
        Object obj = setupWithStore(this.conversationScreenViewModel, continuation);
        return obj == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? obj : Unit.INSTANCE;
    }

    public final void launchCamera$zendesk_messaging_messaging_android() {
        if (this.attachmentIntents.shouldAskForCameraPermission()) {
            this.permissionRequester.launchSinglePermissionRequest("android.permission.CAMERA", new Function1<Boolean, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(boolean z) {
                    ConversationScreenCoordinator conversationScreenCoordinator = this.this$0;
                    final ConversationScreenCoordinator conversationScreenCoordinator2 = this.this$0;
                    conversationScreenCoordinator.showPermissionDialogIfNeeded(z, new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            conversationScreenCoordinator2.capturePhoto();
                        }
                    });
                }
            });
        } else {
            capturePhoto();
        }
    }

    public final void capturePhoto() {
        this.attachmentIntentLauncher.launchCamera(this.attachmentIntents.getCameraIntent(), new Function1<UploadFile, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(UploadFile uploadFile) {
                invoke2(uploadFile);
                return Unit.INSTANCE;
            }

            public final void invoke2(UploadFile capturedPhoto) {
                Intrinsics.checkNotNullParameter(capturedPhoto, "capturedPhoto");
                ConversationScreenCoordinator.this.dispatchUploadFilesAction$zendesk_messaging_messaging_android(CollectionsKt.listOf(capturedPhoto));
            }
        });
    }

    public final void launchGallery$zendesk_messaging_messaging_android() {
        if (Build.VERSION.SDK_INT <= 32) {
            this.permissionRequester.launchSinglePermissionRequest("android.permission.READ_EXTERNAL_STORAGE", new Function1<Boolean, Unit>() {
                {
                    super(1);
                }

                @Override
                public Unit invoke(Boolean bool) {
                    invoke(bool.booleanValue());
                    return Unit.INSTANCE;
                }

                public final void invoke(boolean z) {
                    ConversationScreenCoordinator conversationScreenCoordinator = this.this$0;
                    final ConversationScreenCoordinator conversationScreenCoordinator2 = this.this$0;
                    conversationScreenCoordinator.showPermissionDialogIfNeeded(z, new Function0<Unit>() {
                        {
                            super(0);
                        }

                        @Override
                        public Unit invoke() {
                            invoke2();
                            return Unit.INSTANCE;
                        }

                        public final void invoke2() {
                            conversationScreenCoordinator2.openGallery();
                        }
                    });
                }
            });
        } else {
            openGallery();
        }
    }

    public final void openGallery() {
        this.attachmentIntentLauncher.launchGallery(this.attachmentIntents.getAttachmentIntent(), new Function1<List<? extends UploadFile>, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(List<? extends UploadFile> list) {
                invoke2((List<UploadFile>) list);
                return Unit.INSTANCE;
            }

            public final void invoke2(List<UploadFile> selectedFiles) {
                Intrinsics.checkNotNullParameter(selectedFiles, "selectedFiles");
                ConversationScreenCoordinator.this.dispatchUploadFilesAction$zendesk_messaging_messaging_android(selectedFiles);
            }
        });
    }

    public final void showPermissionDialogIfNeeded(boolean isGranted, Function0<Unit> action) {
        if (!isGranted) {
            this.conversationScreenViewModel.dispatchAction(ConversationScreenAction.ShowDeniedPermission.INSTANCE);
        } else {
            this.conversationScreenViewModel.dispatchAction(ConversationScreenAction.HideDeniedPermission.INSTANCE);
            action.invoke();
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenCoordinator$handleUri$1", m37f = "ConversationScreenCoordinator.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12801 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function0<Unit> $launchIntent;
        final String $uri;
        final UrlSource $urlSource;
        int label;

        C12801(String str, Function0<Unit> function0, UrlSource urlSource, Continuation<? super C12801> continuation) {
            super(2, continuation);
            this.$uri = str;
            this.$launchIntent = function0;
            this.$urlSource = urlSource;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C12801(this.$uri, this.$launchIntent, this.$urlSource, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12801) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            if (StringsKt.startsWith$default(this.$uri, KnownUriSchemes.PHONE_NUMBER, false, 2, (Object) null) || StringsKt.startsWith$default(this.$uri, KnownUriSchemes.EMAIL, false, 2, (Object) null) || Messaging.INSTANCE.getDelegate().shouldHandleUrl(this.$uri, this.$urlSource) || this.$urlSource == UrlSource.IMAGE) {
                this.$launchIntent.invoke();
            } else {
                Logger.m221i(ConversationScreenCoordinator.LOG_TAG, "MessagingDelegate.shouldHandleUrl returned false, ignoring " + this.$uri + " from " + this.$urlSource, new Object[0]);
            }
            return Unit.INSTANCE;
        }
    }

    public final void handleUri(String uri, UrlSource urlSource, Function0<Unit> launchIntent) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(urlSource, "urlSource");
        Intrinsics.checkNotNullParameter(launchIntent, "launchIntent");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12801(uri, launchIntent, urlSource, null), 3, null);
    }

    public final void dispatchUploadFilesAction$zendesk_messaging_messaging_android(List<UploadFile> uploads) {
        Intrinsics.checkNotNullParameter(uploads, "uploads");
        Logger.m221i(LOG_TAG, "Sending conversation upload file event", new Object[0]);
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new ConversationScreenCoordinator$dispatchUploadFilesAction$1(uploads, this, null), 3, null);
    }

    public final void m229x49623ed2() {
        Logger.m221i(LOG_TAG, "Sending conversation upload restored file event", new Object[0]);
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C1279x3adbcc10(this, null), 3, null);
    }

    public final void clearNewMessagesDivider$zendesk_messaging_messaging_android() {
        this.conversationScreenViewModel.clearNewMessagesDivider();
    }

    public final Object setupWithStore(final ConversationScreenViewModel conversationScreenViewModel, Continuation<? super Unit> continuation) throws Throwable {
        C12961 c12961;
        if (continuation instanceof C12961) {
            c12961 = (C12961) continuation;
            if ((c12961.label & Integer.MIN_VALUE) != 0) {
                c12961.label -= Integer.MIN_VALUE;
            } else {
                c12961 = new C12961(continuation);
            }
        } else {
            c12961 = new C12961(continuation);
        }
        Object obj = c12961.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12961.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Logger.m221i(LOG_TAG, "Listening to Conversation Screen updates.", new Object[0]);
            setupScreenEvents(conversationScreenViewModel);
            StateFlow<ConversationScreenState> conversationScreenStateFlow = conversationScreenViewModel.getConversationScreenStateFlow();
            FlowCollector<? super ConversationScreenState> flowCollector = new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation2) {
                    return emit((ConversationScreenState) obj2, (Continuation<? super Unit>) continuation2);
                }

                public final Object emit(final ConversationScreenState conversationScreenState, Continuation<? super Unit> continuation2) {
                    Renderer renderer = ConversationScreenCoordinator.this.conversationScreenRenderer;
                    final ConversationScreenCoordinator conversationScreenCoordinator = ConversationScreenCoordinator.this;
                    final ConversationScreenViewModel conversationScreenViewModel2 = conversationScreenViewModel;
                    renderer.render(new Function1<ConversationScreenRendering, ConversationScreenRendering>() {
                        {
                            super(1);
                        }

                        @Override
                        public final ConversationScreenRendering invoke(ConversationScreenRendering currentRendering) {
                            Intrinsics.checkNotNullParameter(currentRendering, "currentRendering");
                            Conversation conversation = conversationScreenState.getConversation();
                            final String id = conversation != null ? conversation.getId() : null;
                            ConversationScreenRendering.Builder builderOnAttachMenuItemClicked = currentRendering.toBuilder().onSendButtonClicked((Function1) conversationScreenCoordinator.onSendButtonClickedProvider.invoke(conversationScreenViewModel2, id)).onAttachMenuItemClicked(conversationScreenCoordinator.onAttachMenuItemClicked);
                            final ConversationScreenCoordinator conversationScreenCoordinator2 = conversationScreenCoordinator;
                            ConversationScreenRendering.Builder builderOnCopyText = builderOnAttachMenuItemClicked.onBackButtonClicked(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    conversationScreenCoordinator2.onBackButtonClicked.invoke(id);
                                }
                            }).onFailedMessageClicked((Function1) conversationScreenCoordinator.onFailedMessageClicked.invoke(conversationScreenViewModel2, id)).onRetryConnectionButtonClicked((Function0) conversationScreenCoordinator.onRetryConnectionClicked.invoke(conversationScreenViewModel2)).onReplyActionSelected((Function1) conversationScreenCoordinator.onReplyActionSelectedProvider.invoke(conversationScreenViewModel2, id)).onUriClicked(conversationScreenCoordinator.uriHandler).onWebViewUriClicked(conversationScreenCoordinator.webViewUriHandler).onCarouselAction(conversationScreenCoordinator.onCarouselAction).onFormCompleted((Function2) conversationScreenCoordinator.onFormCompletedProvider.invoke(conversationScreenViewModel2, id)).onFormFocusChanged((Function1) conversationScreenCoordinator.onFormFocusChanged.invoke(conversationScreenViewModel2)).onFormDisplayedFieldsChanged((Function2) conversationScreenCoordinator.onFormDisplayedFieldsChanged.invoke(id)).onTyping((Function0) conversationScreenCoordinator.onTyping.invoke(id)).onDeniedPermissionActionClicked(conversationScreenCoordinator.onDeniedPermissionActionClicked).onDeniedPermissionDismissed(conversationScreenCoordinator.onDeniedPermissionDismissed).onMessageComposerTextChanged((Function1) conversationScreenCoordinator.onComposerTextChanged.invoke(conversationScreenViewModel2, id)).onLoadMoreMessages((Function1) conversationScreenCoordinator.onLoadMoreMessages.invoke(conversationScreenViewModel2, id)).onRetryLoadMoreClickedListener((Function1) conversationScreenCoordinator.onLoadMoreMessages.invoke(conversationScreenViewModel2, id)).onRetryLoadConversationClicked(conversationScreenCoordinator.onRetryLoadConversation).onSeeLatestClickedListener(conversationScreenCoordinator.onSeeLatestViewClicked).onSendPostbackMessage(conversationScreenCoordinator.onSendPostBackMessage).onCopyText(conversationScreenCoordinator.onCopyTextAction);
                            final ConversationScreenViewModel conversationScreenViewModel3 = conversationScreenViewModel2;
                            ConversationScreenRendering.Builder builderOnFileAttachmentClicked = builderOnCopyText.onPostbackFailedDismissedListener(new Function0<Unit>() {
                                {
                                    super(0);
                                }

                                @Override
                                public Unit invoke() {
                                    invoke2();
                                    return Unit.INSTANCE;
                                }

                                public final void invoke2() {
                                    conversationScreenViewModel3.dispatchAction(ConversationScreenAction.PostbackBannerDismissed.INSTANCE);
                                }
                            }).onFileAttachmentClicked(conversationScreenCoordinator.onFileAttachmentClicked);
                            final ConversationScreenCoordinator conversationScreenCoordinator3 = conversationScreenCoordinator;
                            final ConversationScreenState conversationScreenState2 = conversationScreenState;
                            return builderOnFileAttachmentClicked.state(new Function1<ConversationScreenState, ConversationScreenState>() {
                                {
                                    super(1);
                                }

                                @Override
                                public final ConversationScreenState invoke(ConversationScreenState it) {
                                    Intrinsics.checkNotNullParameter(it, "it");
                                    boolean zCanOpenCameraIntent = conversationScreenCoordinator3.attachmentIntents.canOpenCameraIntent();
                                    boolean zCanOpenAttachmentIntent = conversationScreenCoordinator3.attachmentIntents.canOpenAttachmentIntent();
                                    boolean hipaaAttachmentFlag = conversationScreenCoordinator3.messagingSettings.getHipaaAttachmentFlag();
                                    ConversationScreenState conversationScreenState3 = conversationScreenState2;
                                    return conversationScreenState3.copy((267911167 & 1) != 0 ? conversationScreenState3.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState3.title : null, (267911167 & 4) != 0 ? conversationScreenState3.description : null, (267911167 & 8) != 0 ? conversationScreenState3.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState3.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState3.conversation : null, (267911167 & 64) != 0 ? conversationScreenState3.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState3.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState3.gallerySupported : zCanOpenAttachmentIntent, (267911167 & 512) != 0 ? conversationScreenState3.cameraSupported : zCanOpenCameraIntent, (267911167 & 1024) != 0 ? conversationScreenState3.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState3.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState3.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState3.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState3.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState3.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState3.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState3.isAttachmentsEnabled : hipaaAttachmentFlag, (267911167 & 262144) != 0 ? conversationScreenState3.status : null, (267911167 & 524288) != 0 ? conversationScreenState3.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState3.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState3.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState3.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState3.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState3.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState3.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState3.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState3.accessibilityTitle : null);
                                }
                            }).build();
                        }
                    });
                    return Unit.INSTANCE;
                }
            };
            c12961.label = 1;
            if (conversationScreenStateFlow.collect(flowCollector, c12961) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        throw new KotlinNothingValueException();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenCoordinator$setupScreenEvents$1", m37f = "ConversationScreenCoordinator.kt", m38i = {}, m39l = {565}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12951 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationScreenViewModel $conversationScreenViewModel;
        int label;
        final ConversationScreenCoordinator this$0;

        C12951(ConversationScreenViewModel conversationScreenViewModel, ConversationScreenCoordinator conversationScreenCoordinator, Continuation<? super C12951> continuation) {
            super(2, continuation);
            this.$conversationScreenViewModel = conversationScreenViewModel;
            this.this$0 = conversationScreenCoordinator;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C12951(this.$conversationScreenViewModel, this.this$0, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12951) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = this.$conversationScreenViewModel.conversationId$zendesk_messaging_messaging_android(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            String str = (String) obj;
            this.$conversationScreenViewModel.subscribeTypingEventsToLifecycle(str);
            this.this$0.visibleScreenTracker.setShownScreen$zendesk_messaging_messaging_android(new VisibleScreen.ConversationScreen(str));
            this.$conversationScreenViewModel.dispatchAction(new ConversationScreenAction.SendActivityData(ActivityData.CONVERSATION_READ, str));
            this.$conversationScreenViewModel.dispatchAction(ConversationScreenAction.CheckPollingStatus.INSTANCE);
            return Unit.INSTANCE;
        }
    }

    private final void setupScreenEvents(ConversationScreenViewModel conversationScreenViewModel) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12951(conversationScreenViewModel, this, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenCoordinator$sendPostbackMessage$1", m37f = "ConversationScreenCoordinator.kt", m38i = {}, m39l = {583}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12941 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $actionId;
        final String $text;
        int label;

        C12941(String str, String str2, Continuation<? super C12941> continuation) {
            super(2, continuation);
            this.$actionId = str;
            this.$text = str2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenCoordinator.this.new C12941(this.$actionId, this.$text, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12941) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = ConversationScreenCoordinator.this.conversationScreenViewModel.conversationId$zendesk_messaging_messaging_android(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            ConversationScreenCoordinator.this.conversationScreenViewModel.dispatchAction(new ConversationScreenAction.SendPostbackMessage((String) obj, this.$actionId, this.$text));
            return Unit.INSTANCE;
        }
    }

    public final void sendPostbackMessage(String actionId, String text) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12941(actionId, text, null), 3, null);
    }
}
