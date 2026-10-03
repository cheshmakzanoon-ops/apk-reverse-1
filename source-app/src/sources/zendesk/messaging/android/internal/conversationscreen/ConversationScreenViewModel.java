package zendesk.messaging.android.internal.conversationscreen;

import android.net.Uri;
import androidx.lifecycle.SavedStateHandle;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelKt;
import cz.msebera.android.httpclient.HttpStatus;
import j$.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.Job;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import net.aihelp.data.track.data.TrackType;
import okhttp3.internal.http2.Http2Connection;
import zendesk.android.Zendesk;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.internal.user.UserExtensionsKt;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Author;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageContent;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.NewMessagesDividerHandler;
import zendesk.messaging.android.internal.NewMessagesDividerHandlerKt;
import zendesk.messaging.android.internal.UploadFileResourceProvider;
import zendesk.messaging.android.internal.VisibleScreenTracker;
import zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService;
import zendesk.messaging.android.internal.extension.ZendeskKtxKt;
import zendesk.messaging.android.internal.model.LoadMoreStatus;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.model.TypingUser;
import zendesk.messaging.android.internal.model.UploadFile;
import zendesk.messaging.android.internal.proactivemessaging.ProactiveMessageEvent;
import zendesk.messaging.android.push.internal.NotificationBuilder;
import zendesk.p026ui.android.conversation.form.DisplayedField;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerType;

@Metadata(m17d1 = {"\u0000¤\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 Á\u00012\u00020\u0001:\u0002Á\u0001Bg\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\t\u001a\u00020\b\u0012\u0006\u0010\u000b\u001a\u00020\n\u0012\u0006\u0010\r\u001a\u00020\f\u0012\u0006\u0010\u000f\u001a\u00020\u000e\u0012\u0006\u0010\u0011\u001a\u00020\u0010\u0012\u0006\u0010\u0013\u001a\u00020\u0012\u0012\u0006\u0010\u0015\u001a\u00020\u0014\u0012\u0006\u0010\u0017\u001a\u00020\u0016\u0012\u0006\u0010\u0019\u001a\u00020\u0018¢\u0006\u0004\b\u001a\u0010\u001bJ\u000f\u0010\u001d\u001a\u00020\u001cH\u0002¢\u0006\u0004\b\u001d\u0010\u001eJ\u000f\u0010\u001f\u001a\u00020\u001cH\u0002¢\u0006\u0004\b\u001f\u0010\u001eJ\u000f\u0010 \u001a\u00020\u001cH\u0002¢\u0006\u0004\b \u0010\u001eJ\u0019\u0010#\u001a\u00020\u001c2\b\u0010\"\u001a\u0004\u0018\u00010!H\u0002¢\u0006\u0004\b#\u0010$J\u0017\u0010'\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020%H\u0002¢\u0006\u0004\b'\u0010(J\u000f\u0010)\u001a\u00020\u001cH\u0002¢\u0006\u0004\b)\u0010\u001eJ\u0017\u0010*\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020%H\u0002¢\u0006\u0004\b*\u0010(J\u0017\u0010,\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020+H\u0002¢\u0006\u0004\b,\u0010-J\u0017\u00100\u001a\u00020\u001c2\u0006\u0010/\u001a\u00020.H\u0002¢\u0006\u0004\b0\u00101J\u0017\u00102\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!H\u0002¢\u0006\u0004\b2\u0010$J\u0017\u00103\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!H\u0002¢\u0006\u0004\b3\u0010$J\u0017\u00106\u001a\u00020\u001c2\u0006\u00105\u001a\u000204H\u0002¢\u0006\u0004\b6\u00107J\u000f\u00108\u001a\u00020\u001cH\u0002¢\u0006\u0004\b8\u0010\u001eJ\u0017\u0010:\u001a\u00020\u001c2\u0006\u0010&\u001a\u000209H\u0002¢\u0006\u0004\b:\u0010;J\u000f\u0010<\u001a\u00020\u001cH\u0002¢\u0006\u0004\b<\u0010\u001eJ)\u0010?\u001a\u00020\u001c*\u00020\f2\f\u0010?\u001a\b\u0012\u0004\u0012\u00020>0=2\u0006\u0010\"\u001a\u00020!H\u0002¢\u0006\u0004\b?\u0010@J/\u0010E\u001a\u00020\u001c2\n\b\u0002\u0010A\u001a\u0004\u0018\u00010!2\u0006\u0010C\u001a\u00020B2\n\b\u0002\u0010D\u001a\u0004\u0018\u00010!H\u0002¢\u0006\u0004\bE\u0010FJ\u0019\u0010I\u001a\u00020\u001c2\b\b\u0002\u0010H\u001a\u00020GH\u0002¢\u0006\u0004\bI\u0010JJ\u001a\u0010L\u001a\u00020\u001c2\b\b\u0002\u0010K\u001a\u00020GH\u0082@¢\u0006\u0004\bL\u0010MJ\u000f\u0010N\u001a\u00020\u001cH\u0002¢\u0006\u0004\bN\u0010\u001eJ\u0017\u0010P\u001a\u00020\u001c2\u0006\u0010O\u001a\u00020GH\u0002¢\u0006\u0004\bP\u0010JJG\u0010Y\u001a\u00020Q2\u0006\u0010R\u001a\u00020Q2\u0006\u0010T\u001a\u00020S2\u0006\u0010U\u001a\u00020G2\b\u0010V\u001a\u0004\u0018\u00010!2\b\b\u0002\u0010W\u001a\u00020!2\n\b\u0002\u0010C\u001a\u0004\u0018\u00010XH\u0002¢\u0006\u0004\bY\u0010ZJ5\u0010`\u001a\u00020!2\b\u0010[\u001a\u0004\u0018\u00010!2\b\u0010]\u001a\u0004\u0018\u00010\\2\b\u0010^\u001a\u0004\u0018\u00010!2\u0006\u0010_\u001a\u00020!H\u0002¢\u0006\u0004\b`\u0010aJ+\u0010e\u001a\u00020!2\b\u0010b\u001a\u0004\u0018\u00010!2\b\u0010c\u001a\u0004\u0018\u00010!2\u0006\u0010d\u001a\u00020!H\u0002¢\u0006\u0004\be\u0010fJ5\u0010g\u001a\u00020!2\b\u0010[\u001a\u0004\u0018\u00010!2\b\u0010]\u001a\u0004\u0018\u00010\\2\b\u0010^\u001a\u0004\u0018\u00010!2\u0006\u0010_\u001a\u00020!H\u0002¢\u0006\u0004\bg\u0010aJ\u0018\u0010j\u001a\u00020\u001c2\u0006\u0010i\u001a\u00020hH\u0082@¢\u0006\u0004\bj\u0010kJ\u0017\u0010l\u001a\u00020Q2\u0006\u0010R\u001a\u00020QH\u0002¢\u0006\u0004\bl\u0010mJ\u0017\u0010n\u001a\u00020Q2\u0006\u0010R\u001a\u00020QH\u0002¢\u0006\u0004\bn\u0010mJ \u0010o\u001a\u00020Q2\u0006\u0010R\u001a\u00020Q2\u0006\u0010\"\u001a\u00020!H\u0082@¢\u0006\u0004\bo\u0010pJ\u0018\u0010q\u001a\u00020S2\u0006\u0010\"\u001a\u00020!H\u0082@¢\u0006\u0004\bq\u0010rJ \u0010s\u001a\u00020Q2\u0006\u0010R\u001a\u00020Q2\u0006\u0010\"\u001a\u00020!H\u0082@¢\u0006\u0004\bs\u0010pJ \u0010t\u001a\u00020Q2\u0006\u0010R\u001a\u00020Q2\u0006\u0010\"\u001a\u00020!H\u0082@¢\u0006\u0004\bt\u0010pJ\u0017\u0010u\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020%H\u0002¢\u0006\u0004\bu\u0010(J\u0011\u0010w\u001a\u0004\u0018\u00010vH\u0002¢\u0006\u0004\bw\u0010xJ\u0017\u0010z\u001a\u00020G2\u0006\u0010y\u001a\u00020SH\u0002¢\u0006\u0004\bz\u0010{J&\u0010\u007f\u001a\u00020\u001c2\u0006\u0010}\u001a\u00020|2\u0006\u0010\"\u001a\u00020!2\u0006\u0010~\u001a\u00020!¢\u0006\u0005\b\u007f\u0010\u0080\u0001J \u0010\u0083\u0001\u001a\u00020\u001c2\u000e\u0010\u0082\u0001\u001a\t\u0012\u0005\u0012\u00030\u0081\u00010=¢\u0006\u0006\b\u0083\u0001\u0010\u0084\u0001J\u000f\u0010\u0085\u0001\u001a\u00020\u001c¢\u0006\u0005\b\u0085\u0001\u0010\u001eJ\u0017\u0010\u0086\u0001\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!¢\u0006\u0005\b\u0086\u0001\u0010$J\u0017\u0010\u0087\u0001\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!¢\u0006\u0005\b\u0087\u0001\u0010$J\u0017\u0010\u0088\u0001\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!¢\u0006\u0005\b\u0088\u0001\u0010$J\u0019\u0010\u008a\u0001\u001a\u00020\u001c2\u0007\u0010i\u001a\u00030\u0089\u0001¢\u0006\u0006\b\u008a\u0001\u0010\u008b\u0001J\u000f\u0010\u008c\u0001\u001a\u00020\u001c¢\u0006\u0005\b\u008c\u0001\u0010\u001eJ\u0012\u0010\"\u001a\u00020!H\u0080@¢\u0006\u0006\b\u008d\u0001\u0010\u008e\u0001J\u001c\u0010\u0093\u0001\u001a\u00020\u001c2\b\u0010\u0090\u0001\u001a\u00030\u008f\u0001H\u0000¢\u0006\u0006\b\u0091\u0001\u0010\u0092\u0001J\u0011\u0010\u0094\u0001\u001a\u00020\u001cH\u0017¢\u0006\u0005\b\u0094\u0001\u0010\u001eJ\u0017\u0010\u0095\u0001\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020!¢\u0006\u0005\b\u0095\u0001\u0010$J\u0017\u0010\u0097\u0001\u001a\t\u0012\u0004\u0012\u00020\u001c0\u0096\u0001¢\u0006\u0006\b\u0097\u0001\u0010\u0098\u0001R\u0015\u0010\u0003\u001a\u00020\u00028\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0003\u0010\u0099\u0001R\u0015\u0010\u0005\u001a\u00020\u00048\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0005\u0010\u009a\u0001R\u0015\u0010\u0007\u001a\u00020\u00068\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0007\u0010\u009b\u0001R\u0015\u0010\t\u001a\u00020\b8\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\t\u0010\u009c\u0001R\u0015\u0010\u000b\u001a\u00020\n8\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u000b\u0010\u009d\u0001R\u0015\u0010\r\u001a\u00020\f8\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\r\u0010\u009e\u0001R\u0015\u0010\u000f\u001a\u00020\u000e8\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u000f\u0010\u009f\u0001R\u0015\u0010\u0011\u001a\u00020\u00108\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0011\u0010 \u0001R\u0015\u0010\u0013\u001a\u00020\u00128\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0013\u0010¡\u0001R\u0015\u0010\u0015\u001a\u00020\u00148\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0015\u0010¢\u0001R\u0015\u0010\u0017\u001a\u00020\u00168\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0017\u0010£\u0001R\u0015\u0010\u0019\u001a\u00020\u00188\u0002X\u0082\u0004¢\u0006\u0007\n\u0005\b\u0019\u0010¤\u0001R\u001f\u0010§\u0001\u001a\n\u0012\u0005\u0012\u00030¦\u00010¥\u00018\u0002X\u0082\u0004¢\u0006\b\n\u0006\b§\u0001\u0010¨\u0001R$\u0010©\u0001\u001a\n\u0012\u0005\u0012\u00030¦\u00010\u0096\u00018\u0006¢\u0006\u0010\n\u0006\b©\u0001\u0010ª\u0001\u001a\u0006\b«\u0001\u0010\u0098\u0001R\u0019\u0010\"\u001a\u0004\u0018\u00010!8\u0002@\u0002X\u0082\u000e¢\u0006\u0007\n\u0005\b\"\u0010¬\u0001R\u001b\u0010\u00ad\u0001\u001a\u0004\u0018\u00010v8\u0002@\u0002X\u0082\u000e¢\u0006\b\n\u0006\b\u00ad\u0001\u0010®\u0001R\u0019\u0010¯\u0001\u001a\u00020G8\u0002@\u0002X\u0082\u000e¢\u0006\b\n\u0006\b¯\u0001\u0010°\u0001R\u0019\u0010±\u0001\u001a\u00020G8\u0002@\u0002X\u0082\u000e¢\u0006\b\n\u0006\b±\u0001\u0010°\u0001R\u0019\u0010²\u0001\u001a\u00020G8\u0002@\u0002X\u0082\u000e¢\u0006\b\n\u0006\b²\u0001\u0010°\u0001R\u0018\u0010´\u0001\u001a\u00030³\u00018\u0002X\u0082\u0004¢\u0006\b\n\u0006\b´\u0001\u0010µ\u0001R\u001e\u0010·\u0001\u001a\t\u0012\u0004\u0012\u00020Q0¶\u00018\u0002X\u0082\u0004¢\u0006\b\n\u0006\b·\u0001\u0010¸\u0001R#\u0010º\u0001\u001a\t\u0012\u0004\u0012\u00020Q0¹\u00018\u0006¢\u0006\u0010\n\u0006\bº\u0001\u0010»\u0001\u001a\u0006\b¼\u0001\u0010½\u0001R\u001c\u0010¿\u0001\u001a\u0005\u0018\u00010¾\u00018\u0002@\u0002X\u0082\u000e¢\u0006\b\n\u0006\b¿\u0001\u0010À\u0001¨\u0006Â\u0001"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel;", "Landroidx/lifecycle/ViewModel;", "Lzendesk/android/messaging/model/MessagingSettings;", "messagingSettings", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;", "messageLogEntryMapper", "Lzendesk/messaging/android/internal/NewMessagesDividerHandler;", "newMessagesDividerHandler", "Landroidx/lifecycle/SavedStateHandle;", "savedStateHandle", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "visibleScreenTracker", "Lkotlinx/coroutines/CoroutineScope;", "sdkCoroutineScope", "Lzendesk/messaging/android/internal/UploadFileResourceProvider;", "uploadFileResourceProvider", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;", "conversationScreenRepository", "Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;", "conversationTypingEvents", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "conversationTitleProvider", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "featureFlagManager", "Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;", "waitTimeBannerService", "<init>", "(Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;Lzendesk/messaging/android/internal/NewMessagesDividerHandler;Landroidx/lifecycle/SavedStateHandle;Lzendesk/messaging/android/internal/VisibleScreenTracker;Lkotlinx/coroutines/CoroutineScope;Lzendesk/messaging/android/internal/UploadFileResourceProvider;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;Lzendesk/messaging/android/internal/ConversationTitleProvider;Lzendesk/core/android/internal/app/FeatureFlagManager;Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;)V", "", "setupWaitTimeBannerService", "()V", "resumeConversationKitConnection", "collectChannelEvents", "", "conversationId", "updateDisplayedFormsFromStorage", "(Ljava/lang/String;)V", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdated;", "conversationKitEvent", "handleConversationUpdated", "(Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdated;)V", "proactiveMessagingInitialization", "analyticsProactiveMessageReplayedTo", "Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "handleConnectionStatusChanged", "(Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;)V", "Lzendesk/conversationkit/android/ConversationKitEvent$OpenWebViewMessageReceived;", "openWebViewMessageReceived", "handleMessageWebViewReceived", "(Lzendesk/conversationkit/android/ConversationKitEvent$OpenWebViewMessageReceived;)V", "handleMessageReceived", "handleMessageUpdated", "Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;", "activityEventReceived", "handleActivityEventReceived", "(Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;)V", "handlePostbackFailure", "Lzendesk/conversationkit/android/ConversationKitEvent$PostbackSuccess;", "handlePostbackSuccess", "(Lzendesk/conversationkit/android/ConversationKitEvent$PostbackSuccess;)V", "collectTypingEvents", "", "Lzendesk/messaging/android/internal/model/UploadFile;", "uploadFiles", "(Lkotlinx/coroutines/CoroutineScope;Ljava/util/List;Ljava/lang/String;)V", "actionId", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;", "status", "text", "updatePostbackMessageStatus", "(Ljava/lang/String;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;Ljava/lang/String;)V", "", "forcedScrolling", "showLoadingAndRefreshState", "(Z)V", "shouldScroll", "refreshState", "(ZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateProactiveParams", "isRevoked", "updateUserAccessRevokedState", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "conversationScreenState", "Lzendesk/conversationkit/android/model/Conversation;", "conversation", "scrollToBottom", "authorizationToken", "composerText", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenStatus;", "conversationState", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;Lzendesk/conversationkit/android/model/Conversation;ZLjava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenStatus;)Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "displayName", "j$/time/LocalDateTime", "createdAt", "lastBusinessParticipantName", "settingsTitle", "provideConversationTitle", "(Ljava/lang/String;Lj$/time/LocalDateTime;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "customIconUrl", "lastBusinessAvatarUrl", "settingsLogoUrl", "provideConversationIconUrl", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;", "provideAccessibilityTitle", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$LoadMoreMessages;", "conversationScreenAction", "loadMoreMessages", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$LoadMoreMessages;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "showDeniedPermission", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;)Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "hideDeniedPermission", "showLoadMoreMessagesProgressBar", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUpdatedConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "hideLoadMoreMessagesProgressBar", "failedLoadMoreMessagesProgressBar", "updateNewMessagesDividerDate", "", "withReferralInfo", "()Ljava/lang/Integer;", "updatedConversation", "shouldConversationScrollToBottom", "(Lzendesk/conversationkit/android/model/Conversation;)Z", "Lzendesk/ui/android/conversation/form/DisplayedField;", "field", "formId", "updateListOfStoredForm", "(Lzendesk/ui/android/conversation/form/DisplayedField;Ljava/lang/String;Ljava/lang/String;)V", "Landroid/net/Uri;", "uriList", "saveRestoredUris", "(Ljava/util/List;)V", "clearTypingUser", "subscribeTypingEventsToLifecycle", "onTyping", "onSendMessage", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "dispatchAction", "(Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;)V", "clearNewMessagesDivider", "conversationId$zendesk_messaging_messaging_android", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "newTheme", "refreshTheme$zendesk_messaging_messaging_android", "(Lzendesk/messaging/android/internal/model/MessagingTheme;)V", "refreshTheme", "onCleared", "loadConversation", "Lkotlinx/coroutines/flow/Flow;", "startPolling", "()Lkotlinx/coroutines/flow/Flow;", "Lzendesk/android/messaging/model/MessagingSettings;", "Lzendesk/messaging/android/internal/conversationscreen/MessageLogEntryMapper;", "Lzendesk/messaging/android/internal/NewMessagesDividerHandler;", "Landroidx/lifecycle/SavedStateHandle;", "Lzendesk/messaging/android/internal/VisibleScreenTracker;", "Lkotlinx/coroutines/CoroutineScope;", "Lzendesk/messaging/android/internal/UploadFileResourceProvider;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenRepository;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationTypingEvents;", "Lzendesk/messaging/android/internal/ConversationTitleProvider;", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "_eventsChannel", "Lkotlinx/coroutines/channels/Channel;", "eventsChannel", "Lkotlinx/coroutines/flow/Flow;", "getEventsChannel", "Ljava/lang/String;", "proactiveNotificationId", "Ljava/lang/Integer;", "hasSentProactiveReferral", "Z", "hasRepliedToProactiveMessage", "userAccessHasBeenRevoked", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "eventListener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "Lkotlinx/coroutines/flow/MutableStateFlow;", "_conversationScreenStateFlow", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lkotlinx/coroutines/flow/StateFlow;", "conversationScreenStateFlow", "Lkotlinx/coroutines/flow/StateFlow;", "getConversationScreenStateFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "Lkotlinx/coroutines/Job;", "refreshStateJob", "Lkotlinx/coroutines/Job;", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenViewModel extends ViewModel {
    private static final Companion Companion = new Companion(null);
    private static final String HAS_REPLIED_TO_PROACTIVE_MESSAGE = "HAS_REPLIED_TO_PROACTIVE_MESSAGE";
    private static final String HAS_SENT_PROACTIVE_REFERRAL_DATA = "HAS_SENT_PROACTIVE_REFERRAL_DATA";
    private static final String KEY_USER_ACCESS_REVOKED = "KEY_USER_ACCESS_REVOKED";
    private static final String LOG_TAG = "ConversationScreenVM";
    private static final String RESTORED_URIS_KEY = "RESTORED_URIS_KEY";
    private final MutableStateFlow<ConversationScreenState> _conversationScreenStateFlow;
    private final Channel<ConversationScreenEvent> _eventsChannel;
    private String conversationId;
    private final ConversationScreenRepository conversationScreenRepository;
    private final StateFlow<ConversationScreenState> conversationScreenStateFlow;
    private final ConversationTitleProvider conversationTitleProvider;
    private final ConversationTypingEvents conversationTypingEvents;
    private final ConversationKitEventListener eventListener;
    private final Flow<ConversationScreenEvent> eventsChannel;
    private final FeatureFlagManager featureFlagManager;
    private boolean hasRepliedToProactiveMessage;
    private boolean hasSentProactiveReferral;
    private final MessageLogEntryMapper messageLogEntryMapper;
    private final MessagingSettings messagingSettings;
    private final NewMessagesDividerHandler newMessagesDividerHandler;
    private Integer proactiveNotificationId;
    private Job refreshStateJob;
    private final SavedStateHandle savedStateHandle;
    private final CoroutineScope sdkCoroutineScope;
    private final UploadFileResourceProvider uploadFileResourceProvider;
    private boolean userAccessHasBeenRevoked;
    private final VisibleScreenTracker visibleScreenTracker;
    private final WaitTimeBannerService waitTimeBannerService;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[LoadMoreStatus.values().length];
            try {
                iArr[LoadMoreStatus.LOADING.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[LoadMoreStatus.FAILED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[LoadMoreStatus.NONE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel", m37f = "ConversationScreenViewModel.kt", m38i = {0, 0}, m39l = {1188}, m40m = "failedLoadMoreMessagesProgressBar", m41n = {"this", "conversationScreenState"}, m42s = {"L$0", "L$1"})
    static final class C13501 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C13501(Continuation<? super C13501> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenViewModel.this.failedLoadMoreMessagesProgressBar(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel", m37f = "ConversationScreenViewModel.kt", m38i = {0, 0}, m39l = {1161}, m40m = "hideLoadMoreMessagesProgressBar", m41n = {"this", "conversationScreenState"}, m42s = {"L$0", "L$1"})
    static final class C13531 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C13531(Continuation<? super C13531> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenViewModel.this.hideLoadMoreMessagesProgressBar(null, null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel", m37f = "ConversationScreenViewModel.kt", m38i = {0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4}, m39l = {1072, 1078, 1079, 1085, 1088}, m40m = "loadMoreMessages", m41n = {"this", "conversationId", "beforeTimestamp", "this", "conversationId", "$this$update$iv", "prevValue$iv", "beforeTimestamp", "this", "conversationId", "this", "conversationId", "$this$update$iv", "prevValue$iv", "this", "conversationId", "$this$update$iv", "prevValue$iv"}, m42s = {"L$0", "L$1", "D$0", "L$0", "L$1", "L$2", "L$3", "D$0", "L$0", "L$1", "L$0", "L$1", "L$2", "L$3", "L$0", "L$1", "L$2", "L$3"})
    static final class C13541 extends ContinuationImpl {
        double D$0;
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        int label;
        Object result;

        C13541(Continuation<? super C13541> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenViewModel.this.loadMoreMessages(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel", m37f = "ConversationScreenViewModel.kt", m38i = {0, 0, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2}, m39l = {849, 861, 874}, m40m = "refreshState", m41n = {"this", "shouldScroll", "this", "conversation", "shouldScroll", "this", "conversation", "composerText", "$this$update$iv", "prevValue$iv", "it", "shouldScroll"}, m42s = {"L$0", "Z$0", "L$0", "L$1", "Z$0", "L$0", "L$1", "L$2", "L$3", "L$4", "L$5", "Z$0"})
    static final class C13551 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        Object L$3;
        Object L$4;
        Object L$5;
        Object L$6;
        boolean Z$0;
        int label;
        Object result;

        C13551(Continuation<? super C13551> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenViewModel.this.refreshState(false, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel", m37f = "ConversationScreenViewModel.kt", m38i = {0, 0}, m39l = {1126}, m40m = "showLoadMoreMessagesProgressBar", m41n = {"this", "conversationScreenState"}, m42s = {"L$0", "L$1"})
    static final class C13581 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C13581(Continuation<? super C13581> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationScreenViewModel.this.showLoadMoreMessagesProgressBar(null, null, this);
        }
    }

    public ConversationScreenViewModel(MessagingSettings messagingSettings, MessageLogEntryMapper messageLogEntryMapper, NewMessagesDividerHandler newMessagesDividerHandler, SavedStateHandle savedStateHandle, VisibleScreenTracker visibleScreenTracker, CoroutineScope sdkCoroutineScope, UploadFileResourceProvider uploadFileResourceProvider, ConversationScreenRepository conversationScreenRepository, ConversationTypingEvents conversationTypingEvents, ConversationTitleProvider conversationTitleProvider, FeatureFlagManager featureFlagManager, WaitTimeBannerService waitTimeBannerService) {
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(messageLogEntryMapper, "messageLogEntryMapper");
        Intrinsics.checkNotNullParameter(newMessagesDividerHandler, "newMessagesDividerHandler");
        Intrinsics.checkNotNullParameter(savedStateHandle, "savedStateHandle");
        Intrinsics.checkNotNullParameter(visibleScreenTracker, "visibleScreenTracker");
        Intrinsics.checkNotNullParameter(sdkCoroutineScope, "sdkCoroutineScope");
        Intrinsics.checkNotNullParameter(uploadFileResourceProvider, "uploadFileResourceProvider");
        Intrinsics.checkNotNullParameter(conversationScreenRepository, "conversationScreenRepository");
        Intrinsics.checkNotNullParameter(conversationTypingEvents, "conversationTypingEvents");
        Intrinsics.checkNotNullParameter(conversationTitleProvider, "conversationTitleProvider");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        Intrinsics.checkNotNullParameter(waitTimeBannerService, "waitTimeBannerService");
        this.messagingSettings = messagingSettings;
        this.messageLogEntryMapper = messageLogEntryMapper;
        this.newMessagesDividerHandler = newMessagesDividerHandler;
        this.savedStateHandle = savedStateHandle;
        this.visibleScreenTracker = visibleScreenTracker;
        this.sdkCoroutineScope = sdkCoroutineScope;
        this.uploadFileResourceProvider = uploadFileResourceProvider;
        this.conversationScreenRepository = conversationScreenRepository;
        this.conversationTypingEvents = conversationTypingEvents;
        this.conversationTitleProvider = conversationTitleProvider;
        this.featureFlagManager = featureFlagManager;
        this.waitTimeBannerService = waitTimeBannerService;
        Boolean bool = false;
        Channel<ConversationScreenEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._eventsChannel = channelChannel$default;
        this.eventsChannel = FlowKt.merge(FlowKt.receiveAsFlow(channelChannel$default), waitTimeBannerService.getEventsChannel());
        this.conversationId = (String) savedStateHandle.getLiveData(ConversationFragment.ARG_CONVERSATION_ID).getValue();
        this.proactiveNotificationId = (Integer) savedStateHandle.getLiveData(NotificationBuilder.PROACTIVE_NOTIFICATION_ID).getValue();
        Boolean bool2 = (Boolean) savedStateHandle.getLiveData(HAS_SENT_PROACTIVE_REFERRAL_DATA, bool).getValue();
        this.hasSentProactiveReferral = (bool2 == null ? bool : bool2).booleanValue();
        Boolean bool3 = (Boolean) savedStateHandle.getLiveData(HAS_REPLIED_TO_PROACTIVE_MESSAGE, bool).getValue();
        this.hasRepliedToProactiveMessage = (bool3 == null ? bool : bool3).booleanValue();
        Boolean bool4 = (Boolean) savedStateHandle.getLiveData(KEY_USER_ACCESS_REVOKED, bool).getValue();
        this.userAccessHasBeenRevoked = (bool4 != null ? bool4 : false).booleanValue();
        ConversationKitEventListener conversationKitEventListener = new ConversationKitEventListener() {
            @Override
            public final void onEvent(ConversationKitEvent conversationKitEvent) {
                ConversationScreenViewModel.eventListener$lambda$2(this.f$0, conversationKitEvent);
            }
        };
        this.eventListener = conversationKitEventListener;
        String title = messagingSettings.getTitle();
        String description = messagingSettings.getDescription();
        String logoUrl = messagingSettings.getLogoUrl();
        List list = (List) savedStateHandle.get(RESTORED_URIS_KEY);
        MutableStateFlow<ConversationScreenState> MutableStateFlow = StateFlowKt.MutableStateFlow(new ConversationScreenState(null, title, description, logoUrl, null, null, false, null, false, false, null, null, null, false, null, false, false, messagingSettings.getHipaaAttachmentFlag(), null, true, null, false, null, list == null ? CollectionsKt.emptyList() : list, null, null, false, null, 259391473, null));
        this._conversationScreenStateFlow = MutableStateFlow;
        this.conversationScreenStateFlow = FlowKt.asStateFlow(MutableStateFlow);
        resumeConversationKitConnection();
        proactiveMessagingInitialization();
        updateProactiveParams();
        conversationScreenRepository.updateUserAccessHasBeenRevoked(this.userAccessHasBeenRevoked);
        conversationScreenRepository.addEventListener(conversationKitEventListener);
        showLoadingAndRefreshState(true);
        collectChannelEvents();
        collectTypingEvents();
        updateDisplayedFormsFromStorage(this.conversationId);
        if (featureFlagManager.getEnableWaitTimeBanner()) {
            setupWaitTimeBannerService();
        }
    }

    public final Flow<ConversationScreenEvent> getEventsChannel() {
        return this.eventsChannel;
    }

    public static final void eventListener$lambda$2(ConversationScreenViewModel this$0, ConversationKitEvent conversationKitEvent) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        ConversationScreenState value2;
        ConversationScreenState conversationScreenState2;
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(conversationKitEvent, "conversationKitEvent");
        if (conversationKitEvent instanceof ConversationKitEvent.ConversationUpdated) {
            this$0.handleConversationUpdated((ConversationKitEvent.ConversationUpdated) conversationKitEvent);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.ConnectionStatusChanged) {
            this$0.handleConnectionStatusChanged((ConversationKitEvent.ConnectionStatusChanged) conversationKitEvent);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.OpenWebViewMessageReceived) {
            this$0.handleMessageWebViewReceived((ConversationKitEvent.OpenWebViewMessageReceived) conversationKitEvent);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.MessageReceived) {
            this$0.handleMessageReceived(((ConversationKitEvent.MessageReceived) conversationKitEvent).getConversationId());
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.MessageUpdated) {
            this$0.handleMessageUpdated(((ConversationKitEvent.MessageUpdated) conversationKitEvent).getConversationId());
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.ActivityEventReceived) {
            this$0.handleActivityEventReceived((ConversationKitEvent.ActivityEventReceived) conversationKitEvent);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.UserAccessRevoked) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this$0._conversationScreenStateFlow;
            do {
                value2 = mutableStateFlow.getValue();
                conversationScreenState2 = value2;
            } while (!mutableStateFlow.compareAndSet(value2, conversationScreenState2.copy((267911167 & 1) != 0 ? conversationScreenState2.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState2.title : null, (267911167 & 4) != 0 ? conversationScreenState2.description : null, (267911167 & 8) != 0 ? conversationScreenState2.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState2.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState2.conversation : null, (267911167 & 64) != 0 ? conversationScreenState2.blockChatInput : true, (267911167 & 128) != 0 ? conversationScreenState2.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState2.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState2.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState2.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState2.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState2.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState2.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState2.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState2.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState2.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState2.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState2.status : ConversationScreenStatus.FAILED, (267911167 & 524288) != 0 ? conversationScreenState2.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState2.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState2.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState2.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState2.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState2.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState2.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState2.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState2.accessibilityTitle : null)));
            this$0.updateUserAccessRevokedState(true);
            Logger.m217d(LOG_TAG, "User access has been revoked", new Object[0]);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.PostbackFailure) {
            this$0.handlePostbackFailure();
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.PostbackSuccess) {
            this$0.handlePostbackSuccess((ConversationKitEvent.PostbackSuccess) conversationKitEvent);
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.UserUpdated) {
            if (this$0.userAccessHasBeenRevoked) {
                this$0.updateUserAccessRevokedState(false);
                showLoadingAndRefreshState$default(this$0, false, 1, null);
            }
            MutableStateFlow<ConversationScreenState> mutableStateFlow2 = this$0._conversationScreenStateFlow;
            do {
                value = mutableStateFlow2.getValue();
                conversationScreenState = value;
            } while (!mutableStateFlow2.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : UserExtensionsKt.getAuthorization(((ConversationKitEvent.UserUpdated) conversationKitEvent).getUser()), (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
            return;
        }
        if (conversationKitEvent instanceof ConversationKitEvent.OpenFileAttachment) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this$0), null, null, new ConversationScreenViewModel$eventListener$1$3(conversationKitEvent, this$0, null), 3, null);
            return;
        }
        Logger.m217d(LOG_TAG, conversationKitEvent.getClass().getSimpleName() + " received.", new Object[0]);
    }

    public final StateFlow<ConversationScreenState> getConversationScreenStateFlow() {
        return this.conversationScreenStateFlow;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$setupWaitTimeBannerService$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {213, 214}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13571 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        int label;

        C13571(Continuation<? super C13571> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13571(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13571) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            WaitTimeBannerService waitTimeBannerService;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                waitTimeBannerService = ConversationScreenViewModel.this.waitTimeBannerService;
                this.L$0 = waitTimeBannerService;
                this.label = 1;
                obj = ConversationScreenViewModel.this.conversationId$zendesk_messaging_messaging_android(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    waitTimeBannerService = (WaitTimeBannerService) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            waitTimeBannerService.subscribe((String) obj);
            Flow<WaitTimeBannerType> waitTimeBannerState = ConversationScreenViewModel.this.waitTimeBannerService.getWaitTimeBannerState();
            final ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
            this.L$0 = null;
            this.label = 2;
            if (waitTimeBannerState.collect(new FlowCollector() {
                @Override
                public Object emit(Object obj2, Continuation continuation) {
                    return emit((WaitTimeBannerType) obj2, (Continuation<? super Unit>) continuation);
                }

                public final Object emit(WaitTimeBannerType waitTimeBannerType, Continuation<? super Unit> continuation) {
                    Object value;
                    ConversationScreenState conversationScreenState;
                    MutableStateFlow mutableStateFlow = conversationScreenViewModel._conversationScreenStateFlow;
                    do {
                        value = mutableStateFlow.getValue();
                        conversationScreenState = (ConversationScreenState) value;
                    } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : waitTimeBannerType, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
                    return Unit.INSTANCE;
                }
            }, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
    }

    private final void setupWaitTimeBannerService() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13571(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$resumeConversationKitConnection$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {223}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13561 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13561(Continuation<? super C13561> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13561(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13561) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.resume(this) == coroutine_suspended) {
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

    private final void resumeConversationKitConnection() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13561(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$collectChannelEvents$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {231}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13361 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13361(Continuation<? super C13361> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13361(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13361) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<ConversationScreenRepositoryEvent> eventsChannel = ConversationScreenViewModel.this.conversationScreenRepository.getEventsChannel();
                final ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
                this.label = 1;
                if (eventsChannel.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit((ConversationScreenRepositoryEvent) obj2, (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(ConversationScreenRepositoryEvent conversationScreenRepositoryEvent, Continuation<? super Unit> continuation) {
                        if ((conversationScreenRepositoryEvent instanceof ConversationScreenRepositoryEvent.UpdateProactiveReferralData) && conversationScreenViewModel.proactiveNotificationId != null && !conversationScreenViewModel.hasSentProactiveReferral) {
                            conversationScreenViewModel.hasSentProactiveReferral = true;
                            conversationScreenViewModel.savedStateHandle.set(ConversationScreenViewModel.HAS_SENT_PROACTIVE_REFERRAL_DATA, Boxing.boxBoolean(true));
                            conversationScreenViewModel.updateProactiveParams();
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

    private final void collectChannelEvents() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13361(null), 3, null);
    }

    private final void updateDisplayedFormsFromStorage(String conversationId) {
        if (conversationId != null) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new ConversationScreenViewModel$updateDisplayedFormsFromStorage$1$1(this, conversationId, null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$updateListOfStoredForm$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {272, 277}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13611 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final DisplayedField $field;
        final String $formId;
        int label;

        C13611(DisplayedField displayedField, String str, String str2, Continuation<? super C13611> continuation) {
            super(2, continuation);
            this.$field = displayedField;
            this.$conversationId = str;
            this.$formId = str2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13611(this.$field, this.$conversationId, this.$formId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13611) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object localStoredForms;
            Map map;
            MutableStateFlow mutableStateFlow;
            Object value;
            ConversationScreenState conversationScreenState;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i != 0) {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                    localStoredForms = obj;
                }
                map = (Map) localStoredForms;
                mutableStateFlow = ConversationScreenViewModel.this._conversationScreenStateFlow;
                do {
                    value = mutableStateFlow.getValue();
                    conversationScreenState = (ConversationScreenState) value;
                } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : map, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (ConversationScreenViewModel.this.conversationScreenRepository.updateLocalStoredForm(this.$field, this.$conversationId, this.$formId, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            this.label = 2;
            localStoredForms = ConversationScreenViewModel.this.conversationScreenRepository.getLocalStoredForms(this.$conversationId, this);
            if (localStoredForms == coroutine_suspended) {
                return coroutine_suspended;
            }
            map = (Map) localStoredForms;
            mutableStateFlow = ConversationScreenViewModel.this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = (ConversationScreenState) value;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : map, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
            return Unit.INSTANCE;
        }
    }

    public final void updateListOfStoredForm(DisplayedField field, String conversationId, String formId) {
        Intrinsics.checkNotNullParameter(field, "field");
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        Intrinsics.checkNotNullParameter(formId, "formId");
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13611(field, conversationId, formId, null), 3, null);
    }

    public final void saveRestoredUris(List<? extends Uri> uriList) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        Intrinsics.checkNotNullParameter(uriList, "uriList");
        List<? extends Uri> list = uriList;
        ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(list, 10));
        Iterator<T> it = list.iterator();
        while (it.hasNext()) {
            arrayList.add(((Uri) it.next()).toString());
        }
        ArrayList arrayList2 = arrayList;
        MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            conversationScreenState = value;
        } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : arrayList2, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        this.savedStateHandle.set(RESTORED_URIS_KEY, arrayList2);
    }

    private final void handleConversationUpdated(ConversationKitEvent.ConversationUpdated conversationKitEvent) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        Logger.m217d(LOG_TAG, "ConversationUpdated received for the conversation with id " + conversationKitEvent.getConversation().getId(), new Object[0]);
        String id = conversationKitEvent.getConversation().getId();
        Conversation conversation = this._conversationScreenStateFlow.getValue().getConversation();
        if (Intrinsics.areEqual(id, conversation != null ? conversation.getId() : null)) {
            updateNewMessagesDividerDate(conversationKitEvent);
            analyticsProactiveMessageReplayedTo(conversationKitEvent);
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = value;
            } while (!mutableStateFlow.compareAndSet(value, conversationState$default(this, conversationScreenState, conversationKitEvent.getConversation(), shouldConversationScrollToBottom(conversationKitEvent.getConversation()), conversationScreenState.getAuthorizationToken(), null, null, 48, null)));
        }
    }

    private final void proactiveMessagingInitialization() {
        DefaultMessaging defaultMessaging = ZendeskKtxKt.defaultMessaging(Zendesk.INSTANCE);
        if (defaultMessaging != null) {
            defaultMessaging.handleProactiveMessageEvent$zendesk_messaging_messaging_android(this.proactiveNotificationId, ProactiveMessageEvent.CONVERSATION_OPENED);
        }
    }

    private final void analyticsProactiveMessageReplayedTo(ConversationKitEvent.ConversationUpdated conversationKitEvent) {
        int size;
        List<Message> messages;
        Integer num = this.proactiveNotificationId;
        if (num != null) {
            int iIntValue = num.intValue();
            if (this.hasRepliedToProactiveMessage) {
                return;
            }
            Conversation conversation = this._conversationScreenStateFlow.getValue().getConversation();
            if (conversation == null || (messages = conversation.getMessages()) == null) {
                size = 0;
            } else {
                ArrayList arrayList = new ArrayList();
                for (Object obj : messages) {
                    if (((Message) obj).isAuthoredBy(conversationKitEvent.getConversation().getMyself())) {
                        arrayList.add(obj);
                    }
                }
                size = arrayList.size();
            }
            List<Message> messages2 = conversationKitEvent.getConversation().getMessages();
            ArrayList arrayList2 = new ArrayList();
            for (Object obj2 : messages2) {
                if (((Message) obj2).isAuthoredBy(conversationKitEvent.getConversation().getMyself())) {
                    arrayList2.add(obj2);
                }
            }
            if (arrayList2.size() > size) {
                DefaultMessaging defaultMessaging = ZendeskKtxKt.defaultMessaging(Zendesk.INSTANCE);
                if (defaultMessaging != null) {
                    defaultMessaging.handleProactiveMessageEvent$zendesk_messaging_messaging_android(Integer.valueOf(iIntValue), ProactiveMessageEvent.REPLIED_TO);
                }
                this.hasRepliedToProactiveMessage = true;
                this.savedStateHandle.set(HAS_REPLIED_TO_PROACTIVE_MESSAGE, true);
            }
        }
    }

    private final void handleConnectionStatusChanged(ConversationKitEvent.ConnectionStatusChanged conversationKitEvent) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        Logger.m217d(LOG_TAG, "ConnectionStatusChanged received with value " + conversationKitEvent.getConnectionStatus(), new Object[0]);
        MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            conversationScreenState = value;
        } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : conversationKitEvent.getConnectionStatus(), (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        ConversationScreenStatus status = this.conversationScreenStateFlow.getValue().getStatus();
        if (conversationKitEvent.getConnectionStatus() != ConnectionStatus.CONNECTED_REALTIME || status == ConversationScreenStatus.LOADING || status == ConversationScreenStatus.FAILED) {
            return;
        }
        Job job = this.refreshStateJob;
        if (job == null || (job != null && job.isCompleted())) {
            this.refreshStateJob = BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13512(null), 3, null);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$handleConnectionStatusChanged$2", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {376, 387}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13512 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13512(Continuation<? super C13512> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13512(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13512) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Conversation conversation;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.refreshState$default(ConversationScreenViewModel.this, false, this, 1, null) == coroutine_suspended) {
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
            if (((ConversationScreenState) ConversationScreenViewModel.this._conversationScreenStateFlow.getValue()).getLoadMoreStatus() == LoadMoreStatus.FAILED && (conversation = ((ConversationScreenState) ConversationScreenViewModel.this._conversationScreenStateFlow.getValue()).getConversation()) != null) {
                ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
                ConversationScreenAction.LoadMoreMessages loadMoreMessages = new ConversationScreenAction.LoadMoreMessages(conversation.getId(), ((Message) CollectionsKt.first((List) conversation.getMessages())).getBeforeTimestamp());
                this.label = 2;
                if (conversationScreenViewModel.loadMoreMessages(loadMoreMessages, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$handleMessageWebViewReceived$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {HttpStatus.SC_FORBIDDEN}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13521 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationKitEvent.OpenWebViewMessageReceived $openWebViewMessageReceived;
        int label;
        final ConversationScreenViewModel this$0;

        C13521(ConversationKitEvent.OpenWebViewMessageReceived openWebViewMessageReceived, ConversationScreenViewModel conversationScreenViewModel, Continuation<? super C13521> continuation) {
            super(2, continuation);
            this.$openWebViewMessageReceived = openWebViewMessageReceived;
            this.this$0 = conversationScreenViewModel;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C13521(this.$openWebViewMessageReceived, this.this$0, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13521) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                MessageActionSize messageActionSizeValueOf = MessageActionSize.valueOf(this.$openWebViewMessageReceived.getSize().name());
                this.label = 1;
                if (this.this$0._eventsChannel.send(new ConversationScreenEvent.LaunchConversationExtension(this.$openWebViewMessageReceived.getUrl(), messageActionSizeValueOf, this.$openWebViewMessageReceived.getConversationId()), this) == coroutine_suspended) {
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

    private final void handleMessageWebViewReceived(ConversationKitEvent.OpenWebViewMessageReceived openWebViewMessageReceived) {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13521(openWebViewMessageReceived, this, null), 3, null);
    }

    private final void handleMessageReceived(String conversationId) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        if (this.visibleScreenTracker.m228x7fb2d242(conversationId)) {
            dispatchAction(new ConversationScreenAction.SendActivityData(ActivityData.CONVERSATION_READ, conversationId));
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = value;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : true, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        }
    }

    private final void handleMessageUpdated(String conversationId) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        if (this.visibleScreenTracker.m228x7fb2d242(conversationId)) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = value;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        }
    }

    private final void handleActivityEventReceived(ConversationKitEvent.ActivityEventReceived activityEventReceived) {
        TypingUser.None user;
        Conversation conversation;
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        ActivityData activityData = activityEventReceived.getActivityEvent().getActivityData();
        String conversationId = activityEventReceived.getActivityEvent().getConversationId();
        String userAvatarUrl = activityEventReceived.getActivityEvent().getUserAvatarUrl();
        if ((activityData == ActivityData.TYPING_START) && userAvatarUrl != null) {
            user = new TypingUser.User(userAvatarUrl);
        } else {
            user = TypingUser.None.INSTANCE;
        }
        if (Intrinsics.areEqual(this._conversationScreenStateFlow.getValue().getTypingUser(), user) || (conversation = this._conversationScreenStateFlow.getValue().getConversation()) == null || !Intrinsics.areEqual(conversation.getId(), conversationId)) {
            return;
        }
        MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            conversationScreenState = value;
        } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : this.messageLogEntryMapper.map(conversation, this.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), user, LoadMoreStatus.NONE, conversationScreenState.getAuthorizationToken()), (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : user, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
    }

    public final void clearTypingUser() {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        TypingUser.None none;
        Conversation conversation = this._conversationScreenStateFlow.getValue().getConversation();
        if (conversation != null) {
            TypingUser.None none2 = TypingUser.None.INSTANCE;
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = value;
                none = none2;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : this.messageLogEntryMapper.map(conversation, this.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), none, LoadMoreStatus.NONE, conversationScreenState.getAuthorizationToken()), (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : none, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
        }
    }

    private final void handlePostbackFailure() {
        updatePostbackMessageStatus$default(this, null, ConversationScreenPostbackStatus.FAILED, null, 5, null);
    }

    private final void handlePostbackSuccess(ConversationKitEvent.PostbackSuccess conversationKitEvent) {
        updatePostbackMessageStatus$default(this, conversationKitEvent.getActionId(), ConversationScreenPostbackStatus.SUCCESS, null, 4, null);
    }

    public final void subscribeTypingEventsToLifecycle(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.conversationTypingEvents.subscribeTypingEventsToLifecycle(conversationId);
    }

    public final void onTyping(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.conversationTypingEvents.onTyping(conversationId);
    }

    public final void onSendMessage(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.conversationTypingEvents.onSendMessage(conversationId);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$collectTypingEvents$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {536}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13371 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13371(Continuation<? super C13371> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13371(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13371) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<ConversationTypingEvent> typingEventChannel = ConversationScreenViewModel.this.conversationTypingEvents.getTypingEventChannel();
                final ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
                this.label = 1;
                if (typingEventChannel.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit((ConversationTypingEvent) obj2, (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(ConversationTypingEvent conversationTypingEvent, Continuation<? super Unit> continuation) {
                        if (conversationTypingEvent instanceof ConversationTypingEvent.TypingStart) {
                            conversationScreenViewModel.dispatchAction(new ConversationScreenAction.SendActivityData(ActivityData.TYPING_START, ((ConversationTypingEvent.TypingStart) conversationTypingEvent).getConversationId()));
                        } else if (conversationTypingEvent instanceof ConversationTypingEvent.TypingStop) {
                            conversationScreenViewModel.dispatchAction(new ConversationScreenAction.SendActivityData(ActivityData.TYPING_STOP, ((ConversationTypingEvent.TypingStop) conversationTypingEvent).getConversationId()));
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

    private final void collectTypingEvents() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13371(null), 3, null);
    }

    public final void dispatchAction(ConversationScreenAction conversationScreenAction) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenState;
        ConversationScreenState value2;
        ConversationScreenState conversationScreenState2;
        ConversationScreenState value3;
        ConversationScreenState value4;
        ConversationScreenState value5;
        ConversationScreenState conversationScreenState3;
        Intrinsics.checkNotNullParameter(conversationScreenAction, "conversationScreenAction");
        List list = null;
        Object[] objArr = 0;
        if (conversationScreenAction instanceof ConversationScreenAction.SendTextMessage) {
            ConversationScreenAction.SendTextMessage sendTextMessage = (ConversationScreenAction.SendTextMessage) conversationScreenAction;
            String conversationId = sendTextMessage.getConversationId();
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13391(Message.Companion.create$default(Message.INSTANCE, new MessageContent.Text(sendTextMessage.getTextMessage(), list, 2, (DefaultConstructorMarker) (objArr == true ? 1 : 0)), null, sendTextMessage.getMetadata(), sendTextMessage.getPayload(), 2, null), conversationId, null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.ResendFailedMessage) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13452(conversationScreenAction, ((ConversationScreenAction.ResendFailedMessage) conversationScreenAction).getConversationId(), null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.SendFormResponse) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13463(conversationScreenAction, ((ConversationScreenAction.SendFormResponse) conversationScreenAction).getConversationId(), null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.UploadFiles) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13474(conversationScreenAction, ((ConversationScreenAction.UploadFiles) conversationScreenAction).getConversationId(), null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.SendActivityData) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13485(conversationScreenAction, ((ConversationScreenAction.SendActivityData) conversationScreenAction).getConversationId(), null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.RetryConnection) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C13496(null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.FormFocusChanged) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
            do {
                value5 = mutableStateFlow.getValue();
                conversationScreenState3 = value5;
            } while (!mutableStateFlow.compareAndSet(value5, conversationScreenState3.copy((267911167 & 1) != 0 ? conversationScreenState3.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState3.title : null, (267911167 & 4) != 0 ? conversationScreenState3.description : null, (267911167 & 8) != 0 ? conversationScreenState3.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState3.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState3.conversation : null, (267911167 & 64) != 0 ? conversationScreenState3.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState3.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState3.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState3.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState3.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState3.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState3.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState3.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState3.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState3.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState3.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState3.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState3.status : null, (267911167 & 524288) != 0 ? conversationScreenState3.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState3.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState3.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState3.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState3.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState3.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState3.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState3.isFormFocused : ((ConversationScreenAction.FormFocusChanged) conversationScreenAction).isFocused(), (267911167 & 134217728) != 0 ? conversationScreenState3.accessibilityTitle : null)));
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.HideDeniedPermission) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow2 = this._conversationScreenStateFlow;
            do {
                value4 = mutableStateFlow2.getValue();
            } while (!mutableStateFlow2.compareAndSet(value4, hideDeniedPermission(value4)));
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.ShowDeniedPermission) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow3 = this._conversationScreenStateFlow;
            do {
                value3 = mutableStateFlow3.getValue();
            } while (!mutableStateFlow3.compareAndSet(value3, showDeniedPermission(value3)));
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.PersistComposerText) {
            ConversationScreenAction.PersistComposerText persistComposerText = (ConversationScreenAction.PersistComposerText) conversationScreenAction;
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C134010(persistComposerText.getConversationId(), persistComposerText.getComposerText(), null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.LoadMoreMessages) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C134111(conversationScreenAction, null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.RetryLoadConversation) {
            showLoadingAndRefreshState$default(this, false, 1, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.SeeLatestViewClicked) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow4 = this._conversationScreenStateFlow;
            do {
                value2 = mutableStateFlow4.getValue();
                conversationScreenState2 = value2;
            } while (!mutableStateFlow4.compareAndSet(value2, conversationScreenState2.copy((267911167 & 1) != 0 ? conversationScreenState2.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState2.title : null, (267911167 & 4) != 0 ? conversationScreenState2.description : null, (267911167 & 8) != 0 ? conversationScreenState2.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState2.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState2.conversation : null, (267911167 & 64) != 0 ? conversationScreenState2.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState2.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState2.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState2.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState2.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState2.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState2.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState2.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState2.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState2.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState2.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState2.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState2.status : null, (267911167 & 524288) != 0 ? conversationScreenState2.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState2.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState2.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState2.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState2.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState2.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState2.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState2.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState2.accessibilityTitle : null)));
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.SendPostbackMessage) {
            ConversationScreenAction.SendPostbackMessage sendPostbackMessage = (ConversationScreenAction.SendPostbackMessage) conversationScreenAction;
            String actionId = sendPostbackMessage.getActionId();
            updatePostbackMessageStatus(actionId, ConversationScreenPostbackStatus.LOADING, sendPostbackMessage.getText());
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C134213(conversationScreenAction, actionId, null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.PostbackBannerDismissed) {
            MutableStateFlow<ConversationScreenState> mutableStateFlow5 = this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow5.getValue();
                conversationScreenState = value;
            } while (!mutableStateFlow5.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.UploadFilesForRestoredUris) {
            BuildersKt__Builders_commonKt.launch$default(this.sdkCoroutineScope, null, null, new C134315(conversationScreenAction, null), 3, null);
            return;
        }
        if (conversationScreenAction instanceof ConversationScreenAction.ViewAttachment) {
            BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C134416(conversationScreenAction, null), 3, null);
        } else if ((conversationScreenAction instanceof ConversationScreenAction.CheckPollingStatus) && this.featureFlagManager.getEnableWaitTimeBanner()) {
            this.waitTimeBannerService.checkPollingStatus();
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {576, 581}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13391 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final Message $message;
        int label;

        C13391(Message message, String str, Continuation<? super C13391> continuation) {
            super(2, continuation);
            this.$message = message;
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13391(this.$message, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13391) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            MutableStateFlow mutableStateFlow;
            Object value;
            ConversationScreenState conversationScreenState;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i != 0) {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                mutableStateFlow = ConversationScreenViewModel.this._conversationScreenStateFlow;
                do {
                    value = mutableStateFlow.getValue();
                    conversationScreenState = (ConversationScreenState) value;
                } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : true, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (ConversationScreenViewModel.this.conversationScreenRepository.sendMessage(this.$message, this.$conversationId, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            this.label = 2;
            if (ConversationScreenViewModel.this.conversationScreenRepository.updateComposerText(this.$conversationId, "", this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            mutableStateFlow = ConversationScreenViewModel.this._conversationScreenStateFlow;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = (ConversationScreenState) value;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : true, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$2", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {598}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13452 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final ConversationScreenAction $conversationScreenAction;
        int label;

        C13452(ConversationScreenAction conversationScreenAction, String str, Continuation<? super C13452> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13452(this.$conversationScreenAction, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13452) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.sendMessage(((ConversationScreenAction.ResendFailedMessage) this.$conversationScreenAction).getFailedMessage(), this.$conversationId, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$3", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {621, 609}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13463 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final ConversationScreenAction $conversationScreenAction;
        Object L$0;
        int label;

        C13463(ConversationScreenAction conversationScreenAction, String str, Continuation<? super C13463> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13463(this.$conversationScreenAction, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13463) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            ConversationScreenRepository conversationScreenRepository;
            Message messageCopy;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                conversationScreenRepository = ConversationScreenViewModel.this.conversationScreenRepository;
                if (((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFormMessageContainer().getMessage().getStatus() instanceof MessageStatus.Failed) {
                    Message message = ((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFormMessageContainer().getMessage();
                    messageCopy = message.copy((2021 & 1) != 0 ? message.id : null, (2021 & 2) != 0 ? message.author : null, (2021 & 4) != 0 ? message.status : null, (2021 & 8) != 0 ? message.created : null, (2021 & 16) != 0 ? message.received : null, (2021 & 32) != 0 ? message.beforeTimestamp : 0.0d, (2021 & 64) != 0 ? message.content : new MessageContent.FormResponse(((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFormMessageContainer().getId(), ((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFields()), (2021 & 128) != 0 ? message.metadata : null, (2021 & 256) != 0 ? message.sourceId : null, (2021 & 512) != 0 ? message.localId : null, (2021 & 1024) != 0 ? message.payload : null);
                } else {
                    this.L$0 = conversationScreenRepository;
                    this.label = 1;
                    if (ConversationScreenViewModel.this.conversationScreenRepository.removeStoredForm(this.$conversationId, ((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFormMessageContainer().getId(), this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                }
                this.L$0 = null;
                this.label = 2;
                if (conversationScreenRepository.sendMessage(messageCopy, this.$conversationId, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                return Unit.INSTANCE;
            }
            if (i == 1) {
                conversationScreenRepository = (ConversationScreenRepository) this.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
            messageCopy = Message.Companion.create$default(Message.INSTANCE, new MessageContent.FormResponse(((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFormMessageContainer().getId(), ((ConversationScreenAction.SendFormResponse) this.$conversationScreenAction).getFields()), null, null, null, 14, null);
            this.L$0 = null;
            this.label = 2;
            if (conversationScreenRepository.sendMessage(messageCopy, this.$conversationId, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$4", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13474 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final ConversationScreenAction $conversationScreenAction;
        private Object L$0;
        int label;

        C13474(ConversationScreenAction conversationScreenAction, String str, Continuation<? super C13474> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C13474 c13474 = ConversationScreenViewModel.this.new C13474(this.$conversationScreenAction, this.$conversationId, continuation);
            c13474.L$0 = obj;
            return c13474;
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13474) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationScreenViewModel.this.uploadFiles((CoroutineScope) this.L$0, ((ConversationScreenAction.UploadFiles) this.$conversationScreenAction).getUploads(), this.$conversationId);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$5", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {649}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13485 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final ConversationScreenAction $conversationScreenAction;
        int label;

        C13485(ConversationScreenAction conversationScreenAction, String str, Continuation<? super C13485> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13485(this.$conversationScreenAction, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13485) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.sendActivityData(((ConversationScreenAction.SendActivityData) this.$conversationScreenAction).getActivityData(), this.$conversationId, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$6", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {658}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13496 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13496(Continuation<? super C13496> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13496(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13496) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.resume(this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$10", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {681}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C134010 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final String $updatedText;
        int label;

        C134010(String str, String str2, Continuation<? super C134010> continuation) {
            super(2, continuation);
            this.$conversationId = str;
            this.$updatedText = str2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C134010(this.$conversationId, this.$updatedText, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C134010) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.persistComposerText(this.$conversationId, this.$updatedText, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$11", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {690}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C134111 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationScreenAction $conversationScreenAction;
        int label;

        C134111(ConversationScreenAction conversationScreenAction, Continuation<? super C134111> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C134111(this.$conversationScreenAction, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C134111) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.loadMoreMessages((ConversationScreenAction.LoadMoreMessages) this.$conversationScreenAction, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$13", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {712}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C134213 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $actionId;
        final ConversationScreenAction $conversationScreenAction;
        int label;

        C134213(ConversationScreenAction conversationScreenAction, String str, Continuation<? super C134213> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
            this.$actionId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C134213(this.$conversationScreenAction, this.$actionId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C134213) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.conversationScreenRepository.sendPostbackMessage(((ConversationScreenAction.SendPostbackMessage) this.$conversationScreenAction).getConversationId(), this.$actionId, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$15", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C134315 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationScreenAction $conversationScreenAction;
        private Object L$0;
        int label;

        C134315(ConversationScreenAction conversationScreenAction, Continuation<? super C134315> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            C134315 c134315 = ConversationScreenViewModel.this.new C134315(this.$conversationScreenAction, continuation);
            c134315.L$0 = obj;
            return c134315;
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C134315) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
                ConversationScreenViewModel.this.savedStateHandle.set(ConversationScreenViewModel.RESTORED_URIS_KEY, CollectionsKt.emptyList());
                List<String> restoredUris = ConversationScreenViewModel.this.getConversationScreenStateFlow().getValue().getRestoredUris();
                ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
                ArrayList arrayList = new ArrayList(CollectionsKt.collectionSizeOrDefault(restoredUris, 10));
                for (String str : restoredUris) {
                    UploadFileResourceProvider uploadFileResourceProvider = conversationScreenViewModel.uploadFileResourceProvider;
                    Uri uri = Uri.parse(str);
                    Intrinsics.checkNotNullExpressionValue(uri, "parse(...)");
                    arrayList.add(uploadFileResourceProvider.getUploadFileFromIntent$zendesk_messaging_messaging_android(uri));
                }
                ConversationScreenViewModel.this.uploadFiles(coroutineScope, arrayList, ((ConversationScreenAction.UploadFilesForRestoredUris) this.$conversationScreenAction).getConversationId());
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$dispatchAction$16", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {740, 739}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C134416 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationScreenAction $conversationScreenAction;
        Object L$0;
        int label;

        C134416(ConversationScreenAction conversationScreenAction, Continuation<? super C134416> continuation) {
            super(2, continuation);
            this.$conversationScreenAction = conversationScreenAction;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C134416(this.$conversationScreenAction, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C134416) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            ConversationScreenRepository conversationScreenRepository;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                conversationScreenRepository = ConversationScreenViewModel.this.conversationScreenRepository;
                this.L$0 = conversationScreenRepository;
                this.label = 1;
                obj = ConversationScreenViewModel.this.conversationId$zendesk_messaging_messaging_android(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    conversationScreenRepository = (ConversationScreenRepository) this.L$0;
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            this.L$0 = null;
            this.label = 2;
            if (conversationScreenRepository.downloadAttachment((String) obj, ((ConversationScreenAction.ViewAttachment) this.$conversationScreenAction).getMessage(), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
    }

    public final void uploadFiles(CoroutineScope coroutineScope, List<UploadFile> list, String str) {
        int i = 0;
        for (Object obj : list) {
            int i2 = i + 1;
            if (i < 0) {
                CollectionsKt.throwIndexOverflow();
            }
            UploadFile uploadFile = (UploadFile) obj;
            BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new ConversationScreenViewModel$uploadFiles$1$1(this, Message.Companion.create$default(Message.INSTANCE, new MessageContent.FileUpload(uploadFile.getUri(), uploadFile.getName(), uploadFile.getSize(), uploadFile.getMimeType()), null, null, null, 14, null), str, null), 3, null);
            i = i2;
        }
    }

    static void updatePostbackMessageStatus$default(ConversationScreenViewModel conversationScreenViewModel, String str, ConversationScreenPostbackStatus conversationScreenPostbackStatus, String str2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        conversationScreenViewModel.updatePostbackMessageStatus(str, conversationScreenPostbackStatus, str2);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$updatePostbackMessageStatus$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {792}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13621 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $actionId;
        final ConversationScreenPostbackStatus $status;
        final String $text;
        int label;

        C13621(String str, ConversationScreenPostbackStatus conversationScreenPostbackStatus, String str2, Continuation<? super C13621> continuation) {
            super(2, continuation);
            this.$actionId = str;
            this.$status = conversationScreenPostbackStatus;
            this.$text = str2;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13621(this.$actionId, this.$status, this.$text, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13621) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object objM258x110fd018;
            Object value;
            ConversationScreenState conversationScreenState;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationScreenState value2 = ConversationScreenViewModel.this.getConversationScreenStateFlow().getValue();
                StringBuilder sb = new StringBuilder("Postback state change, ");
                String str = this.$actionId;
                if (str == null) {
                    str = "";
                }
                sb.append(str);
                sb.append(' ');
                sb.append(this.$status);
                Logger.m217d(ConversationScreenViewModel.LOG_TAG, sb.toString(), new Object[0]);
                this.label = 1;
                objM258x110fd018 = ConversationScreenViewModel.this.messageLogEntryMapper.m258x110fd018(value2.getMapOfDisplayedPostbackStatuses(), value2.getMessageLog(), this.$status, this.$actionId, this);
                if (objM258x110fd018 == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
                objM258x110fd018 = obj;
            }
            MessageLogEntryMapper.MessageLogEntryUpdatedPostback messageLogEntryUpdatedPostback = (MessageLogEntryMapper.MessageLogEntryUpdatedPostback) objM258x110fd018;
            MutableStateFlow mutableStateFlow = ConversationScreenViewModel.this._conversationScreenStateFlow;
            String str2 = this.$text;
            ConversationScreenViewModel conversationScreenViewModel = ConversationScreenViewModel.this;
            do {
                value = mutableStateFlow.getValue();
                conversationScreenState = (ConversationScreenState) value;
            } while (!mutableStateFlow.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : messageLogEntryUpdatedPostback.getMessageLogEntryList(), (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : messageLogEntryUpdatedPostback.getUpdatedPostbackStatuses(), (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : messageLogEntryUpdatedPostback.getShowBanner(), (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : str2 == null ? conversationScreenViewModel.getConversationScreenStateFlow().getValue().getPostbackErrorText() : str2, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null)));
            return Unit.INSTANCE;
        }
    }

    private final void updatePostbackMessageStatus(String actionId, ConversationScreenPostbackStatus status, String text) {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13621(actionId, status, text, null), 3, null);
    }

    static void showLoadingAndRefreshState$default(ConversationScreenViewModel conversationScreenViewModel, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        conversationScreenViewModel.showLoadingAndRefreshState(z);
    }

    private final void showLoadingAndRefreshState(boolean forcedScrolling) {
        ConversationScreenState value;
        ConversationScreenState conversationScreenStateCopy;
        MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        do {
            value = mutableStateFlow.getValue();
            ConversationScreenState conversationScreenState = value;
            if (forcedScrolling) {
                List list = null;
                Conversation conversation = null;
                boolean z = true;
                ConnectionStatus connectionStatus = null;
                boolean z2 = false;
                boolean z3 = false;
                String str = null;
                Map map = null;
                TypingUser typingUser = null;
                boolean z4 = false;
                LoadMoreStatus loadMoreStatus = null;
                boolean z5 = false;
                boolean z6 = false;
                boolean z7 = false;
                Map map2 = null;
                boolean z8 = false;
                String str2 = null;
                conversationScreenStateCopy = new ConversationScreenState(conversationScreenState.getMessagingTheme(), this.messagingSettings.getTitle(), this.messagingSettings.getDescription(), this.messagingSettings.getLogoUrl(), list, conversation, z, connectionStatus, z2, z3, str, map, typingUser, z4, loadMoreStatus, z5, z6, conversationScreenState.isAttachmentsEnabled(), ConversationScreenStatus.LOADING, z7, map2, z8, str2, conversationScreenState.getRestoredUris(), conversationScreenState.getAuthorizationToken(), null, false, null, 242876336, null);
            } else {
                conversationScreenStateCopy = conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : true, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : ConversationScreenStatus.LOADING, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null);
            }
        } while (!mutableStateFlow.compareAndSet(value, conversationScreenStateCopy));
        Job job = this.refreshStateJob;
        if (job != null) {
            Job.DefaultImpls.cancel$default(job, (CancellationException) null, 1, (Object) null);
        }
        this.refreshStateJob = BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13592(forcedScrolling, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$showLoadingAndRefreshState$2", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {838}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13592 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final boolean $forcedScrolling;
        int label;

        C13592(boolean z, Continuation<? super C13592> continuation) {
            super(2, continuation);
            this.$forcedScrolling = z;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13592(this.$forcedScrolling, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13592) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (ConversationScreenViewModel.this.refreshState(this.$forcedScrolling, this) == coroutine_suspended) {
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

    public final java.lang.Object refreshState(boolean r39, kotlin.coroutines.Continuation<? super kotlin.Unit> r40) {
        throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel.refreshState(boolean, kotlin.coroutines.Continuation):java.lang.Object");
    }

    static Object refreshState$default(ConversationScreenViewModel conversationScreenViewModel, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            z = false;
        }
        return conversationScreenViewModel.refreshState(z, continuation);
    }

    public final void updateProactiveParams() {
        this.conversationScreenRepository.updateProactiveParams(this.proactiveNotificationId, withReferralInfo());
    }

    private final void updateUserAccessRevokedState(boolean isRevoked) {
        this.savedStateHandle.set(KEY_USER_ACCESS_REVOKED, Boolean.valueOf(isRevoked));
        this.userAccessHasBeenRevoked = isRevoked;
        this.conversationScreenRepository.updateUserAccessHasBeenRevoked(isRevoked);
    }

    static ConversationScreenState conversationState$default(ConversationScreenViewModel conversationScreenViewModel, ConversationScreenState conversationScreenState, Conversation conversation, boolean z, String str, String str2, ConversationScreenStatus conversationScreenStatus, int i, Object obj) {
        if ((i & 16) != 0) {
            str2 = "";
        }
        String str3 = str2;
        if ((i & 32) != 0) {
            conversationScreenStatus = null;
        }
        return conversationScreenViewModel.conversationState(conversationScreenState, conversation, z, str, str3, conversationScreenStatus);
    }

    private final ConversationScreenState conversationState(ConversationScreenState conversationScreenState, Conversation conversation, boolean scrollToBottom, String authorizationToken, String composerText, ConversationScreenStatus status) {
        boolean z;
        Author authorMostRecentAuthorThatIsNotMySelf = ConversationHelperKt.mostRecentAuthorThatIsNotMySelf(conversation);
        List<MessageLogEntry> map = this.messageLogEntryMapper.map(conversation, this.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), conversationScreenState.getTypingUser(), LoadMoreStatus.NONE, authorizationToken);
        Message message = (Message) CollectionsKt.lastOrNull((List) conversation.getMessages());
        if ((message != null ? message.getContent() : null) instanceof MessageContent.Form) {
            MessageContent content = message.getContent();
            Intrinsics.checkNotNull(content, "null cannot be cast to non-null type zendesk.conversationkit.android.model.MessageContent.Form");
            if (((MessageContent.Form) content).getBlockChatInput()) {
                z = true;
            } else {
                z = false;
            }
        } else {
            z = false;
        }
        ConversationScreenState conversationScreenStateCopy = conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : provideConversationTitle(conversation.getDisplayName(), conversation.getCreatedAt(), authorMostRecentAuthorThatIsNotMySelf != null ? authorMostRecentAuthorThatIsNotMySelf.getDisplayName() : null, this.messagingSettings.getTitle()), (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : provideConversationIconUrl(conversation.getIconUrl(), authorMostRecentAuthorThatIsNotMySelf != null ? authorMostRecentAuthorThatIsNotMySelf.getAvatarUrl() : null, this.messagingSettings.getLogoUrl()), (267911167 & 16) != 0 ? conversationScreenState.messageLog : map, (267911167 & 32) != 0 ? conversationScreenState.conversation : conversation, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : z, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : conversationScreenState.getConnectionStatus(), (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : composerText, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : conversationScreenState.getTypingUser(), (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : conversationScreenState.getLoadMoreStatus(), (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : NewMessagesDividerHandlerKt.hasNewInboundMessages(conversation), (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : status == null ? conversationScreenState.getStatus() : status, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : scrollToBottom, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : authorizationToken, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : provideAccessibilityTitle(conversation.getDisplayName(), conversation.getCreatedAt(), authorMostRecentAuthorThatIsNotMySelf != null ? authorMostRecentAuthorThatIsNotMySelf.getDisplayName() : null, this.messagingSettings.getTitle()));
        Logger.m217d(LOG_TAG, "Creating a new conversationState", new Object[0]);
        return conversationScreenStateCopy;
    }

    private final String provideConversationTitle(String displayName, LocalDateTime createdAt, String lastBusinessParticipantName, String settingsTitle) {
        if (!this.messagingSettings.isMultiConversationsEnabled()) {
            return settingsTitle;
        }
        ConversationTitleProvider conversationTitleProvider = this.conversationTitleProvider;
        if (lastBusinessParticipantName == null) {
            lastBusinessParticipantName = settingsTitle;
        }
        return conversationTitleProvider.resolveTitle(displayName, createdAt, lastBusinessParticipantName);
    }

    private final String provideConversationIconUrl(String customIconUrl, String lastBusinessAvatarUrl, String settingsLogoUrl) {
        if (this.messagingSettings.isMultiConversationsEnabled()) {
            if (customIconUrl != null) {
                return customIconUrl;
            }
            if (lastBusinessAvatarUrl != null) {
                return lastBusinessAvatarUrl;
            }
        }
        return settingsLogoUrl;
    }

    private final String provideAccessibilityTitle(String displayName, LocalDateTime createdAt, String lastBusinessParticipantName, String settingsTitle) {
        if (!this.messagingSettings.isMultiConversationsEnabled()) {
            return settingsTitle;
        }
        ConversationTitleProvider conversationTitleProvider = this.conversationTitleProvider;
        if (lastBusinessParticipantName == null) {
            lastBusinessParticipantName = settingsTitle;
        }
        return conversationTitleProvider.resolveAccessibilityHeaderTitle(displayName, createdAt, lastBusinessParticipantName);
    }

    public final java.lang.Object loadMoreMessages(zendesk.messaging.android.internal.conversationscreen.ConversationScreenAction.LoadMoreMessages r18, kotlin.coroutines.Continuation<? super kotlin.Unit> r19) {
        throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel.loadMoreMessages(zendesk.messaging.android.internal.conversationscreen.ConversationScreenAction$LoadMoreMessages, kotlin.coroutines.Continuation):java.lang.Object");
    }

    private final ConversationScreenState showDeniedPermission(ConversationScreenState conversationScreenState) {
        return conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : true, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null);
    }

    private final ConversationScreenState hideDeniedPermission(ConversationScreenState conversationScreenState) {
        return conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null);
    }

    public final Object showLoadMoreMessagesProgressBar(ConversationScreenState conversationScreenState, String str, Continuation<? super ConversationScreenState> continuation) throws Throwable {
        C13581 c13581;
        ConversationScreenState conversationScreenState2;
        ConversationScreenViewModel conversationScreenViewModel;
        if (continuation instanceof C13581) {
            c13581 = (C13581) continuation;
            if ((c13581.label & Integer.MIN_VALUE) != 0) {
                c13581.label -= Integer.MIN_VALUE;
            } else {
                c13581 = new C13581(continuation);
            }
        } else {
            c13581 = new C13581(continuation);
        }
        Object obj = c13581.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13581.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c13581.L$0 = this;
            c13581.L$1 = conversationScreenState;
            c13581.label = 1;
            Object updatedConversation = getUpdatedConversation(str, c13581);
            if (updatedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenState2 = conversationScreenState;
            obj = updatedConversation;
            conversationScreenViewModel = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ConversationScreenState conversationScreenState3 = (ConversationScreenState) c13581.L$1;
            conversationScreenViewModel = (ConversationScreenViewModel) c13581.L$0;
            ResultKt.throwOnFailure(obj);
            conversationScreenState2 = conversationScreenState3;
        }
        Conversation conversation = (Conversation) obj;
        return conversationScreenState2.copy((267911167 & 1) != 0 ? conversationScreenState2.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState2.title : null, (267911167 & 4) != 0 ? conversationScreenState2.description : null, (267911167 & 8) != 0 ? conversationScreenState2.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState2.messageLog : conversationScreenViewModel.messageLogEntryMapper.map(conversation, conversationScreenViewModel.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), conversationScreenState2.getTypingUser(), LoadMoreStatus.LOADING, conversationScreenState2.getAuthorizationToken()), (267911167 & 32) != 0 ? conversationScreenState2.conversation : null, (267911167 & 64) != 0 ? conversationScreenState2.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState2.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState2.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState2.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState2.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState2.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState2.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState2.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState2.loadMoreStatus : LoadMoreStatus.LOADING, (267911167 & 32768) != 0 ? conversationScreenState2.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState2.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState2.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState2.status : null, (267911167 & 524288) != 0 ? conversationScreenState2.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState2.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState2.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState2.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState2.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState2.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState2.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState2.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState2.accessibilityTitle : null);
    }

    public final Object getUpdatedConversation(String str, Continuation<? super Conversation> continuation) {
        Conversation conversation = this._conversationScreenStateFlow.getValue().getConversation();
        return conversation == null ? this.conversationScreenRepository.getRemoteConversation(str, continuation) : conversation;
    }

    public final Object hideLoadMoreMessagesProgressBar(ConversationScreenState conversationScreenState, String str, Continuation<? super ConversationScreenState> continuation) throws Throwable {
        C13531 c13531;
        ConversationScreenState conversationScreenState2;
        ConversationScreenViewModel conversationScreenViewModel;
        if (continuation instanceof C13531) {
            c13531 = (C13531) continuation;
            if ((c13531.label & Integer.MIN_VALUE) != 0) {
                c13531.label -= Integer.MIN_VALUE;
            } else {
                c13531 = new C13531(continuation);
            }
        } else {
            c13531 = new C13531(continuation);
        }
        Object obj = c13531.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13531.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c13531.L$0 = this;
            c13531.L$1 = conversationScreenState;
            c13531.label = 1;
            Object updatedConversation = getUpdatedConversation(str, c13531);
            if (updatedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenState2 = conversationScreenState;
            obj = updatedConversation;
            conversationScreenViewModel = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ConversationScreenState conversationScreenState3 = (ConversationScreenState) c13531.L$1;
            conversationScreenViewModel = (ConversationScreenViewModel) c13531.L$0;
            ResultKt.throwOnFailure(obj);
            conversationScreenState2 = conversationScreenState3;
        }
        Conversation conversation = (Conversation) obj;
        return conversationScreenState2.copy((267911167 & 1) != 0 ? conversationScreenState2.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState2.title : null, (267911167 & 4) != 0 ? conversationScreenState2.description : null, (267911167 & 8) != 0 ? conversationScreenState2.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState2.messageLog : conversationScreenViewModel.messageLogEntryMapper.map(conversation, conversationScreenViewModel.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), conversationScreenState2.getTypingUser(), LoadMoreStatus.NONE, conversationScreenState2.getAuthorizationToken()), (267911167 & 32) != 0 ? conversationScreenState2.conversation : null, (267911167 & 64) != 0 ? conversationScreenState2.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState2.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState2.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState2.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState2.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState2.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState2.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState2.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState2.loadMoreStatus : LoadMoreStatus.NONE, (267911167 & 32768) != 0 ? conversationScreenState2.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState2.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState2.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState2.status : null, (267911167 & 524288) != 0 ? conversationScreenState2.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState2.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState2.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState2.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState2.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState2.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState2.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState2.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState2.accessibilityTitle : null);
    }

    public final Object failedLoadMoreMessagesProgressBar(ConversationScreenState conversationScreenState, String str, Continuation<? super ConversationScreenState> continuation) throws Throwable {
        C13501 c13501;
        ConversationScreenState conversationScreenState2;
        ConversationScreenViewModel conversationScreenViewModel;
        if (continuation instanceof C13501) {
            c13501 = (C13501) continuation;
            if ((c13501.label & Integer.MIN_VALUE) != 0) {
                c13501.label -= Integer.MIN_VALUE;
            } else {
                c13501 = new C13501(continuation);
            }
        } else {
            c13501 = new C13501(continuation);
        }
        Object obj = c13501.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c13501.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            c13501.L$0 = this;
            c13501.L$1 = conversationScreenState;
            c13501.label = 1;
            Object updatedConversation = getUpdatedConversation(str, c13501);
            if (updatedConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationScreenState2 = conversationScreenState;
            obj = updatedConversation;
            conversationScreenViewModel = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ConversationScreenState conversationScreenState3 = (ConversationScreenState) c13501.L$1;
            conversationScreenViewModel = (ConversationScreenViewModel) c13501.L$0;
            ResultKt.throwOnFailure(obj);
            conversationScreenState2 = conversationScreenState3;
        }
        Conversation conversation = (Conversation) obj;
        return conversationScreenState2.copy((267911167 & 1) != 0 ? conversationScreenState2.messagingTheme : null, (267911167 & 2) != 0 ? conversationScreenState2.title : null, (267911167 & 4) != 0 ? conversationScreenState2.description : null, (267911167 & 8) != 0 ? conversationScreenState2.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState2.messageLog : conversationScreenViewModel.messageLogEntryMapper.map(conversation, conversationScreenViewModel.newMessagesDividerHandler.getNewMessageDividerDate(conversation.getId()), conversationScreenState2.getTypingUser(), LoadMoreStatus.FAILED, conversationScreenState2.getAuthorizationToken()), (267911167 & 32) != 0 ? conversationScreenState2.conversation : null, (267911167 & 64) != 0 ? conversationScreenState2.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState2.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState2.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState2.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState2.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState2.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState2.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState2.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState2.loadMoreStatus : LoadMoreStatus.FAILED, (267911167 & 32768) != 0 ? conversationScreenState2.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState2.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState2.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState2.status : null, (267911167 & 524288) != 0 ? conversationScreenState2.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState2.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState2.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState2.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState2.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState2.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState2.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState2.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState2.accessibilityTitle : null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$clearNewMessagesDivider$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {1208}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13351 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        int label;

        C13351(Continuation<? super C13351> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationScreenViewModel.this.new C13351(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13351) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            NewMessagesDividerHandler newMessagesDividerHandler;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                NewMessagesDividerHandler newMessagesDividerHandler2 = ConversationScreenViewModel.this.newMessagesDividerHandler;
                this.L$0 = newMessagesDividerHandler2;
                this.label = 1;
                Object objConversationId$zendesk_messaging_messaging_android = ConversationScreenViewModel.this.conversationId$zendesk_messaging_messaging_android(this);
                if (objConversationId$zendesk_messaging_messaging_android == coroutine_suspended) {
                    return coroutine_suspended;
                }
                newMessagesDividerHandler = newMessagesDividerHandler2;
                obj = objConversationId$zendesk_messaging_messaging_android;
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                newMessagesDividerHandler = (NewMessagesDividerHandler) this.L$0;
                ResultKt.throwOnFailure(obj);
            }
            newMessagesDividerHandler.clearNewMessageDividerDate((String) obj);
            return Unit.INSTANCE;
        }
    }

    public final void clearNewMessagesDivider() {
        BuildersKt__Builders_commonKt.launch$default(ViewModelKt.getViewModelScope(this), null, null, new C13351(null), 3, null);
    }

    private final void updateNewMessagesDividerDate(ConversationKitEvent.ConversationUpdated conversationKitEvent) {
        if (this.visibleScreenTracker.hasVisibleScreen$zendesk_messaging_messaging_android()) {
            return;
        }
        this.newMessagesDividerHandler.updateNewMessageDividerDate(conversationKitEvent.getConversation());
    }

    public final Object conversationId$zendesk_messaging_messaging_android(Continuation<? super String> continuation) {
        final MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        return FlowKt.first(new Flow<String>() {

            @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            public static final class C13382<T> implements FlowCollector {
                final FlowCollector $this_unsafeFlow;

                @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$conversationId$$inlined$mapNotNull$1$2", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {TrackType.TRACK_DURATION_HELP_CENTER}, m40m = "emit", m41n = {}, m42s = {})
                public static final class AnonymousClass1 extends ContinuationImpl {
                    Object L$0;
                    int label;
                    Object result;

                    public AnonymousClass1(Continuation continuation) {
                        super(continuation);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) {
                        this.result = obj;
                        this.label |= Integer.MIN_VALUE;
                        return C13382.this.emit(null, this);
                    }
                }

                public C13382(FlowCollector flowCollector) {
                    this.$this_unsafeFlow = flowCollector;
                }

                @Override
                public final Object emit(Object obj, Continuation continuation) throws Throwable {
                    AnonymousClass1 anonymousClass1;
                    if (continuation instanceof AnonymousClass1) {
                        anonymousClass1 = (AnonymousClass1) continuation;
                        if ((anonymousClass1.label & Integer.MIN_VALUE) != 0) {
                            anonymousClass1.label -= Integer.MIN_VALUE;
                        } else {
                            anonymousClass1 = new AnonymousClass1(continuation);
                        }
                    } else {
                        anonymousClass1 = new AnonymousClass1(continuation);
                    }
                    Object obj2 = anonymousClass1.result;
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = anonymousClass1.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj2);
                        FlowCollector flowCollector = this.$this_unsafeFlow;
                        Conversation conversation = ((ConversationScreenState) obj).getConversation();
                        String id = conversation != null ? conversation.getId() : null;
                        if (id != null) {
                            anonymousClass1.label = 1;
                            if (flowCollector.emit(id, anonymousClass1) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj2);
                    }
                    return Unit.INSTANCE;
                }
            }

            @Override
            public Object collect(FlowCollector<? super String> flowCollector, Continuation continuation2) {
                Object objCollect = mutableStateFlow.collect(new C13382(flowCollector), continuation2);
                return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
            }
        }, continuation);
    }

    private final Integer withReferralInfo() {
        if (this.hasSentProactiveReferral) {
            return null;
        }
        return this.proactiveNotificationId;
    }

    public final void refreshTheme$zendesk_messaging_messaging_android(MessagingTheme newTheme) {
        Intrinsics.checkNotNullParameter(newTheme, "newTheme");
        if (Intrinsics.areEqual(this._conversationScreenStateFlow.getValue().getMessagingTheme(), newTheme)) {
            return;
        }
        MutableStateFlow<ConversationScreenState> mutableStateFlow = this._conversationScreenStateFlow;
        while (true) {
            ConversationScreenState value = mutableStateFlow.getValue();
            ConversationScreenState conversationScreenState = value;
            MutableStateFlow<ConversationScreenState> mutableStateFlow2 = mutableStateFlow;
            if (mutableStateFlow2.compareAndSet(value, conversationScreenState.copy((267911167 & 1) != 0 ? conversationScreenState.messagingTheme : newTheme, (267911167 & 2) != 0 ? conversationScreenState.title : null, (267911167 & 4) != 0 ? conversationScreenState.description : null, (267911167 & 8) != 0 ? conversationScreenState.toolbarImageUrl : null, (267911167 & 16) != 0 ? conversationScreenState.messageLog : null, (267911167 & 32) != 0 ? conversationScreenState.conversation : null, (267911167 & 64) != 0 ? conversationScreenState.blockChatInput : false, (267911167 & 128) != 0 ? conversationScreenState.connectionStatus : null, (267911167 & 256) != 0 ? conversationScreenState.gallerySupported : false, (267911167 & 512) != 0 ? conversationScreenState.cameraSupported : false, (267911167 & 1024) != 0 ? conversationScreenState.composerText : null, (267911167 & 2048) != 0 ? conversationScreenState.mapOfDisplayedForms : null, (267911167 & 4096) != 0 ? conversationScreenState.typingUser : null, (267911167 & 8192) != 0 ? conversationScreenState.showDeniedPermission : false, (267911167 & 16384) != 0 ? conversationScreenState.loadMoreStatus : null, (267911167 & 32768) != 0 ? conversationScreenState.shouldAnnounceMessage : false, (267911167 & 65536) != 0 ? conversationScreenState.shouldSeeLatestViewVisible : false, (267911167 & 131072) != 0 ? conversationScreenState.isAttachmentsEnabled : false, (267911167 & 262144) != 0 ? conversationScreenState.status : null, (267911167 & 524288) != 0 ? conversationScreenState.scrollToTheBottom : false, (267911167 & 1048576) != 0 ? conversationScreenState.mapOfDisplayedPostbackStatuses : null, (267911167 & 2097152) != 0 ? conversationScreenState.showPostbackErrorBanner : false, (267911167 & 4194304) != 0 ? conversationScreenState.postbackErrorText : null, (267911167 & 8388608) != 0 ? conversationScreenState.restoredUris : null, (267911167 & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? conversationScreenState.authorizationToken : null, (267911167 & 33554432) != 0 ? conversationScreenState.waitTimeBannerType : null, (267911167 & 67108864) != 0 ? conversationScreenState.isFormFocused : false, (267911167 & 134217728) != 0 ? conversationScreenState.accessibilityTitle : null))) {
                return;
            } else {
                mutableStateFlow = mutableStateFlow2;
            }
        }
    }

    public void onCleared() {
        super.onCleared();
        this.conversationScreenRepository.removeEventListener(this.eventListener);
        if (this.featureFlagManager.getEnableWaitTimeBanner()) {
            this.waitTimeBannerService.unsubscribe();
        }
    }

    public final void loadConversation(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        this.conversationId = conversationId;
        showLoadingAndRefreshState(true);
        this.waitTimeBannerService.unsubscribe();
        this.waitTimeBannerService.subscribe(conversationId);
    }

    private final boolean shouldConversationScrollToBottom(Conversation updatedConversation) {
        boolean z;
        int i = WhenMappings.$EnumSwitchMapping$0[this._conversationScreenStateFlow.getValue().getLoadMoreStatus().ordinal()];
        if (i == 1 || i == 2) {
            z = true;
        } else {
            if (i != 3) {
                throw new NoWhenBranchMatchedException();
            }
            z = false;
        }
        if (updatedConversation.getMessages().isEmpty()) {
            return this._conversationScreenStateFlow.getValue().getScrollToTheBottom();
        }
        return !z && ((Message) CollectionsKt.last((List) updatedConversation.getMessages())).isAuthoredBy(updatedConversation.getMyself());
    }

    public final Flow<Unit> startPolling() {
        return FlowKt.m1845catch(this.waitTimeBannerService.pollingWithRetries(), new C13601(null));
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/flow/FlowCollector;", "cause", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$startPolling$1", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13601 extends SuspendLambda implements Function3<FlowCollector<? super Unit>, Throwable, Continuation<? super Unit>, Object> {
        Object L$0;
        int label;

        C13601(Continuation<? super C13601> continuation) {
            super(3, continuation);
        }

        @Override
        public final Object invoke(FlowCollector<? super Unit> flowCollector, Throwable th, Continuation<? super Unit> continuation) {
            C13601 c13601 = new C13601(continuation);
            c13601.L$0 = th;
            return c13601.invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Logger.m218e(ConversationScreenViewModel.LOG_TAG, "Error polling for wait time banner", (Throwable) this.L$0, new Object[0]);
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0005\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenViewModel$Companion;", "", "()V", ConversationScreenViewModel.HAS_REPLIED_TO_PROACTIVE_MESSAGE, "", ConversationScreenViewModel.HAS_SENT_PROACTIVE_REFERRAL_DATA, ConversationScreenViewModel.KEY_USER_ACCESS_REVOKED, "LOG_TAG", ConversationScreenViewModel.RESTORED_URIS_KEY, "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
