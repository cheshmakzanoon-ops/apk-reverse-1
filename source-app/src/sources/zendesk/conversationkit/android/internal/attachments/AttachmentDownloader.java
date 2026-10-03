package zendesk.conversationkit.android.internal.attachments;

import android.app.DownloadManager;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import java.io.Closeable;
import java.io.File;
import java.util.concurrent.TimeUnit;
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
import kotlinx.coroutines.DelayKt;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowKt;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus;
import zendesk.conversationkit.android.model.attachments.ProcessAttachmentStatus;
import zendesk.core.android.internal.FileKtxKt;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010\t\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 $2\u00020\u0001:\u0001$B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ \u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u0016\u001a\u00020\u00142\u0006\u0010\u0017\u001a\u00020\u0014H\u0002J*\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u00142\u0006\u0010\u001b\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\b\u0010\u001c\u001a\u0004\u0018\u00010\u0014H\u0002J(\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u001f\u001a\u00020\u00192\u0006\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u0016\u001a\u00020\u00142\u0006\u0010\u0017\u001a\u00020\u0014H\u0002J7\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\b\u0010\u001c\u001a\u0004\u0018\u00010\u00142\u0006\u0010\u0016\u001a\u00020\u00142\u0006\u0010\u0017\u001a\u00020\u0014H\u0000¢\u0006\u0002\b#R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u000b0\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000b0\r¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0010\u001a\n \u0012*\u0004\u0018\u00010\u00110\u0011X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006%"}, m18d2 = {"Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;", "", "context", "Landroid/content/Context;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "attachmentsDownloadReceiver", "Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;", "(Landroid/content/Context;Lkotlinx/coroutines/CoroutineScope;Lzendesk/conversationkit/android/internal/attachments/AttachmentsDownloadReceiver;)V", "_attachmentChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/conversationkit/android/internal/Action;", "attachmentChannel", "Lkotlinx/coroutines/flow/Flow;", "getAttachmentChannel", "()Lkotlinx/coroutines/flow/Flow;", "downloadManager", "Landroid/app/DownloadManager;", "kotlin.jvm.PlatformType", "constructFilename", "", "fileName", "messageId", "conversationId", "downloadFile", "", "url", "mimeType", "authorizationHeader", "enqueueAttachmentDownload", "", "downloadId", "processAttachment", "Lzendesk/conversationkit/android/model/attachments/ProcessAttachmentStatus;", "mediaUrl", "processAttachment$zendesk_conversationkit_conversationkit_android", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AttachmentDownloader {
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final long DOWNLOAD_TIMEOUT = TimeUnit.MINUTES.toMillis(1);
    private final Channel<Action> _attachmentChannel;
    private final Flow<Action> attachmentChannel;
    private final Context context;
    private final CoroutineScope coroutineScope;
    private final DownloadManager downloadManager;

    public AttachmentDownloader(Context context, CoroutineScope coroutineScope, AttachmentsDownloadReceiver attachmentsDownloadReceiver) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(attachmentsDownloadReceiver, "attachmentsDownloadReceiver");
        this.context = context;
        this.coroutineScope = coroutineScope;
        Channel<Action> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._attachmentChannel = channelChannel$default;
        this.attachmentChannel = FlowKt.merge(FlowKt.receiveAsFlow(channelChannel$default), attachmentsDownloadReceiver.getAttachmentChannel());
        this.downloadManager = (DownloadManager) context.getSystemService(DownloadManager.class);
    }

    public final Flow<Action> getAttachmentChannel() {
        return this.attachmentChannel;
    }

    public final ProcessAttachmentStatus m210xd0b463a2(String mediaUrl, String fileName, String authorizationHeader, String messageId, String conversationId) {
        Intrinsics.checkNotNullParameter(mediaUrl, "mediaUrl");
        Intrinsics.checkNotNullParameter(fileName, "fileName");
        Intrinsics.checkNotNullParameter(messageId, "messageId");
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        String strConstructFilename = constructFilename(fileName, messageId, conversationId);
        File fileDoesFileExistInSDKExternalStorage = FileKtxKt.doesFileExistInSDKExternalStorage(strConstructFilename, this.context);
        if (fileDoesFileExistInSDKExternalStorage == null) {
            Uri uri = Uri.parse(mediaUrl);
            Intrinsics.checkNotNullExpressionValue(uri, "parse(...)");
            enqueueAttachmentDownload(downloadFile(mediaUrl, FileKtxKt.getMimeType(uri), strConstructFilename, authorizationHeader), fileName, messageId, conversationId);
            return ProcessAttachmentStatus.AttachmentToBeDownloaded.INSTANCE;
        }
        return new ProcessAttachmentStatus.AttachmentAvailableInStorage(fileDoesFileExistInSDKExternalStorage);
    }

    private final String constructFilename(String fileName, String messageId, String conversationId) {
        return StringsKt.substringBeforeLast$default(fileName, ".", (String) null, 2, (Object) null) + ("_" + messageId + '_' + conversationId) + ("." + StringsKt.substringAfterLast$default(fileName, ".", (String) null, 2, (Object) null));
    }

    private final long downloadFile(String url, String mimeType, String fileName, String authorizationHeader) {
        DownloadManager.Request destinationInExternalFilesDir = new DownloadManager.Request(Uri.parse(url)).setMimeType(mimeType).setAllowedNetworkTypes(3).setNotificationVisibility(2).setTitle(fileName).setDestinationInExternalFilesDir(this.context, Environment.DIRECTORY_DOCUMENTS, fileName);
        if (authorizationHeader != null) {
            destinationInExternalFilesDir.addRequestHeader("Authorization", authorizationHeader);
        }
        return this.downloadManager.enqueue(destinationInExternalFilesDir);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.attachments.AttachmentDownloader$enqueueAttachmentDownload$1", m37f = "AttachmentDownloader.kt", m38i = {}, m39l = {148, TrackType.TRACK_FAQ_SEARCH_CONTENT}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10571 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final long $downloadId;
        final String $fileName;
        final String $messageId;
        Object L$0;
        int label;

        C10571(long j, String str, String str2, String str3, Continuation<? super C10571> continuation) {
            super(2, continuation);
            this.$downloadId = j;
            this.$fileName = str;
            this.$messageId = str2;
            this.$conversationId = str3;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return AttachmentDownloader.this.new C10571(this.$downloadId, this.$fileName, this.$messageId, this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10571) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Cursor cursorQuery;
            AttachmentDownloader attachmentDownloader;
            long j;
            String str;
            String str2;
            String str3;
            Closeable closeable;
            Throwable th;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            try {
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (DelayKt.delay(AttachmentDownloader.DOWNLOAD_TIMEOUT, this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 1) {
                        if (i != 2) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        closeable = (Closeable) this.L$0;
                        try {
                            ResultKt.throwOnFailure(obj);
                            Unit unit = Unit.INSTANCE;
                            CloseableKt.closeFinally(closeable, null);
                            return Unit.INSTANCE;
                        } catch (Throwable th2) {
                            th = th2;
                            try {
                                throw th;
                            } catch (Throwable th3) {
                                CloseableKt.closeFinally(closeable, th);
                                throw th3;
                            }
                        }
                    }
                    ResultKt.throwOnFailure(obj);
                }
                Cursor cursor = cursorQuery;
                if (cursor.moveToFirst()) {
                    int i2 = cursor.getInt(cursor.getColumnIndex("status"));
                    cursor.close();
                    if (i2 != 8 && i2 != 2) {
                        attachmentDownloader.downloadManager.remove(j);
                        Channel channel = attachmentDownloader._attachmentChannel;
                        Action.UpdateDownloadStatusAction updateDownloadStatusAction = new Action.UpdateDownloadStatusAction(new DownloadAttachmentStatus.DownloadAttachmentFailed(str, str2, str3));
                        this.L$0 = cursorQuery;
                        this.label = 2;
                        if (channel.send(updateDownloadStatusAction, this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                }
                closeable = cursorQuery;
                Unit unit2 = Unit.INSTANCE;
                CloseableKt.closeFinally(closeable, null);
                return Unit.INSTANCE;
            } catch (Throwable th4) {
                closeable = cursorQuery;
                th = th4;
                throw th;
            }
            cursorQuery = AttachmentDownloader.this.downloadManager.query(new DownloadManager.Query().setFilterById(this.$downloadId));
            attachmentDownloader = AttachmentDownloader.this;
            j = this.$downloadId;
            str = this.$fileName;
            str2 = this.$messageId;
            str3 = this.$conversationId;
        }
    }

    private final void enqueueAttachmentDownload(long downloadId, String fileName, String messageId, String conversationId) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10571(downloadId, fileName, messageId, conversationId, null), 3, null);
    }
}
