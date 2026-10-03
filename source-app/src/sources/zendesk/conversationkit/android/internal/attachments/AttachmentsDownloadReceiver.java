package zendesk.conversationkit.android.internal.attachments;

import android.app.DownloadManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import androidx.core.content.ContextCompat;
import java.io.File;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.CloseableKt;
import kotlin.text.StringsKt;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus;
import zendesk.core.android.internal.FileKtxKt;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 $2\u00020\u0001:\u0001$B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J \u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00132\u0006\u0010\u0015\u001a\u00020\u0013H\u0002J(\u0010\u0016\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00132\u0006\u0010\u0015\u001a\u00020\u00132\u0006\u0010\u0017\u001a\u00020\u0018H\u0002J\u0018\u0010\u0019\u001a\u00020\u00112\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u0017\u001a\u00020\u0018H\u0002J\u001a\u0010\u001c\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u00182\b\u0010\u001d\u001a\u0004\u0018\u00010\u001eH\u0016J\u0015\u0010\u001f\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0018H\u0000¢\u0006\u0002\b J\u0010\u0010!\u001a\u00020\u00132\u0006\u0010\u0012\u001a\u00020\u0013H\u0002J\u0015\u0010\"\u001a\u00020\u00112\u0006\u0010\u0017\u001a\u00020\u0018H\u0000¢\u0006\u0002\b#R\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00070\t¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082.¢\u0006\u0002\n\u0000R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006%"}, m18d2 = {"Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;", "Landroid/content/BroadcastReceiver;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lkotlinx/coroutines/CoroutineScope;)V", "_attachmentChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/conversationkit/android/internal/Action;", "attachmentChannel", "Lkotlinx/coroutines/flow/Flow;", "getAttachmentChannel", "()Lkotlinx/coroutines/flow/Flow;", "downloadManager", "Landroid/app/DownloadManager;", "isReceiverRegistered", "", "dispatchDownloadFailed", "", "filePath", "", "messageId", "conversationId", "dispatchDownloadSuccessful", "context", "Landroid/content/Context;", "handleDownloadingFileByStatus", "downloadId", "", "onReceive", "intent", "Landroid/content/Intent;", "registerAttachmentsReceiver", "registerAttachmentsReceiver$zendesk_conversationkit_conversationkit_android", "retrieveFilename", "unregisterAttachmentsReceiver", "unregisterAttachmentsReceiver$zendesk_conversationkit_conversationkit_android", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AttachmentsDownloadReceiver extends BroadcastReceiver {
    private static final String LOG_TAG = "AttachmentsDownloadReceiver";
    private final Channel<Action> _attachmentChannel;
    private final Flow<Action> attachmentChannel;
    private final CoroutineScope coroutineScope;
    private DownloadManager downloadManager;
    private boolean isReceiverRegistered;

    public AttachmentsDownloadReceiver(CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.coroutineScope = coroutineScope;
        Channel<Action> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._attachmentChannel = channelChannel$default;
        this.attachmentChannel = FlowKt.receiveAsFlow(channelChannel$default);
    }

    public final Flow<Action> getAttachmentChannel() {
        return this.attachmentChannel;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Intrinsics.checkNotNullParameter(context, "context");
        Object systemService = context.getSystemService((Class<Object>) DownloadManager.class);
        Intrinsics.checkNotNull(systemService);
        this.downloadManager = (DownloadManager) systemService;
        if (intent != null) {
            handleDownloadingFileByStatus(intent.getLongExtra("extra_download_id", -1L), context);
        }
    }

    public final void m211xe53b14cc(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        if (this.isReceiverRegistered) {
            return;
        }
        ContextCompat.registerReceiver(context, this, new IntentFilter("android.intent.action.DOWNLOAD_COMPLETE"), 2);
        this.isReceiverRegistered = true;
    }

    public final void m212xa9906493(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        if (this.isReceiverRegistered) {
            try {
                context.unregisterReceiver(this);
                this.isReceiverRegistered = false;
            } catch (IllegalArgumentException e) {
                Logger.m218e(LOG_TAG, "Failed to unregister AttachmentsDownloadReceiver", e, new Object[0]);
            }
        }
    }

    private final void handleDownloadingFileByStatus(long downloadId, Context context) {
        DownloadManager downloadManager = this.downloadManager;
        if (downloadManager == null) {
            Intrinsics.throwUninitializedPropertyAccessException("downloadManager");
            downloadManager = null;
        }
        Cursor cursorQuery = downloadManager.query(new DownloadManager.Query().setFilterById(downloadId));
        try {
            Cursor cursor = cursorQuery;
            if (cursor.moveToFirst()) {
                int i = cursor.getInt(cursor.getColumnIndex("status"));
                String string = cursor.getString(cursor.getColumnIndex("title"));
                cursor.close();
                Intrinsics.checkNotNull(string);
                String strSubstringAfterLast$default = StringsKt.substringAfterLast$default(StringsKt.substringBeforeLast$default(string, "_", (String) null, 2, (Object) null), "_", (String) null, 2, (Object) null);
                String strSubstringBeforeLast$default = StringsKt.substringBeforeLast$default(StringsKt.substringAfterLast$default(string, "_", (String) null, 2, (Object) null), ".", (String) null, 2, (Object) null);
                if (i == 8) {
                    dispatchDownloadSuccessful(string, strSubstringAfterLast$default, strSubstringBeforeLast$default, context);
                } else {
                    dispatchDownloadFailed(string, strSubstringAfterLast$default, strSubstringBeforeLast$default);
                }
            }
            Unit unit = Unit.INSTANCE;
            CloseableKt.closeFinally(cursorQuery, null);
        } catch (Throwable th) {
            try {
                throw th;
            } catch (Throwable th2) {
                CloseableKt.closeFinally(cursorQuery, th);
                throw th2;
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.attachments.AttachmentsDownloadReceiver$dispatchDownloadFailed$1", m37f = "AttachmentsDownloadReceiver.kt", m38i = {}, m39l = {TrackType.TRACK_ENTRANCE_CLICK_FAQ}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10581 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final String $filePath;
        final String $messageId;
        int label;

        C10581(String str, String str2, String str3, Continuation<? super C10581> continuation) {
            super(2, continuation);
            this.$filePath = str;
            this.$messageId = str2;
            this.$conversationId = str3;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return AttachmentsDownloadReceiver.this.new C10581(this.$filePath, this.$messageId, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10581) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (AttachmentsDownloadReceiver.this._attachmentChannel.send(new Action.UpdateDownloadStatusAction(new DownloadAttachmentStatus.DownloadAttachmentFailed(AttachmentsDownloadReceiver.this.retrieveFilename(this.$filePath), this.$messageId, this.$conversationId)), this) == coroutine_suspended) {
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

    private final void dispatchDownloadFailed(String filePath, String messageId, String conversationId) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10581(filePath, messageId, conversationId, null), 3, null);
    }

    private final void dispatchDownloadSuccessful(String filePath, String messageId, String conversationId, Context context) {
        File fileDoesFileExistInSDKExternalStorage = FileKtxKt.doesFileExistInSDKExternalStorage(filePath, context);
        if (fileDoesFileExistInSDKExternalStorage != null) {
            BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new AttachmentsDownloadReceiver$dispatchDownloadSuccessful$1$1(this, fileDoesFileExistInSDKExternalStorage, filePath, messageId, conversationId, null), 3, null);
        }
    }

    public final String retrieveFilename(String filePath) {
        return StringsKt.substringBeforeLast$default(StringsKt.substringBeforeLast$default(filePath, "_", (String) null, 2, (Object) null), "_", (String) null, 2, (Object) null) + ("." + StringsKt.substringAfterLast$default(filePath, ".", (String) null, 2, (Object) null));
    }
}
