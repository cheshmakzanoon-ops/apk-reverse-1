package zendesk.messaging.android.internal.conversationscreen;

import androidx.compose.animation.core.ComplexDouble$;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Field;
import zendesk.conversationkit.android.model.Message;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.UploadFile;

@Metadata(m17d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0013\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0012\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0012\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&¨\u0006'"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "", "()V", "CheckPollingStatus", "FormFocusChanged", "HideDeniedPermission", "LoadMoreMessages", "PersistComposerText", "PostbackBannerDismissed", "ResendFailedMessage", "RetryConnection", "RetryLoadConversation", "SeeLatestViewClicked", "SendActivityData", "SendFormResponse", "SendPostbackMessage", "SendTextMessage", "ShowDeniedPermission", "UploadFiles", "UploadFilesForRestoredUris", "ViewAttachment", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$CheckPollingStatus;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$FormFocusChanged;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$HideDeniedPermission;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$LoadMoreMessages;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$PersistComposerText;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$PostbackBannerDismissed;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ResendFailedMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$RetryConnection;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$RetryLoadConversation;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SeeLatestViewClicked;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendActivityData;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendFormResponse;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendPostbackMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendTextMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ShowDeniedPermission;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$UploadFiles;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$UploadFilesForRestoredUris;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ViewAttachment;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ConversationScreenAction {
    public ConversationScreenAction(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ConversationScreenAction() {
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B7\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00070\u0006\u0012\u0006\u0010\b\u001a\u00020\u0003¢\u0006\u0002\u0010\tJ\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u0011\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0015\u0010\u0012\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00070\u0006HÆ\u0003J\t\u0010\u0013\u001a\u00020\u0003HÆ\u0003J?\u0010\u0014\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\u0014\b\u0002\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00070\u00062\b\b\u0002\u0010\b\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0007HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u001d\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\u00070\u0006¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000b¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendTextMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "textMessage", "", "payload", "metadata", "", "", "conversationId", "(Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "getPayload", "getTextMessage", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendTextMessage extends ConversationScreenAction {
        private final String conversationId;
        private final Map<String, Object> metadata;
        private final String payload;
        private final String textMessage;

        public static SendTextMessage copy$default(SendTextMessage sendTextMessage, String str, String str2, Map map, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = sendTextMessage.textMessage;
            }
            if ((i & 2) != 0) {
                str2 = sendTextMessage.payload;
            }
            if ((i & 4) != 0) {
                map = sendTextMessage.metadata;
            }
            if ((i & 8) != 0) {
                str3 = sendTextMessage.conversationId;
            }
            return sendTextMessage.copy(str, str2, map, str3);
        }

        public final String getTextMessage() {
            return this.textMessage;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final Map<String, Object> component3() {
            return this.metadata;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final SendTextMessage copy(String textMessage, String payload, Map<String, ? extends Object> metadata, String conversationId) {
            Intrinsics.checkNotNullParameter(textMessage, "textMessage");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendTextMessage(textMessage, payload, metadata, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendTextMessage)) {
                return false;
            }
            SendTextMessage sendTextMessage = (SendTextMessage) other;
            return Intrinsics.areEqual(this.textMessage, sendTextMessage.textMessage) && Intrinsics.areEqual(this.payload, sendTextMessage.payload) && Intrinsics.areEqual(this.metadata, sendTextMessage.metadata) && Intrinsics.areEqual(this.conversationId, sendTextMessage.conversationId);
        }

        public int hashCode() {
            int iHashCode = this.textMessage.hashCode() * 31;
            String str = this.payload;
            return ((((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.metadata.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "SendTextMessage(textMessage=" + this.textMessage + ", payload=" + this.payload + ", metadata=" + this.metadata + ", conversationId=" + this.conversationId + ')';
        }

        public final String getTextMessage() {
            return this.textMessage;
        }

        public final String getPayload() {
            return this.payload;
        }

        public SendTextMessage(String str, String str2, Map map, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? MapsKt.emptyMap() : map, str3);
        }

        public final Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public SendTextMessage(String textMessage, String str, Map<String, ? extends Object> metadata, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(textMessage, "textMessage");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.textMessage = textMessage;
            this.payload = str;
            this.metadata = metadata;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0006HÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$UploadFiles;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "uploads", "", "Lzendesk/messaging/android/internal/model/UploadFile;", "conversationId", "", "(Ljava/util/List;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getUploads", "()Ljava/util/List;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UploadFiles extends ConversationScreenAction {
        private final String conversationId;
        private final List<UploadFile> uploads;

        public static UploadFiles copy$default(UploadFiles uploadFiles, List list, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                list = uploadFiles.uploads;
            }
            if ((i & 2) != 0) {
                str = uploadFiles.conversationId;
            }
            return uploadFiles.copy(list, str);
        }

        public final List<UploadFile> component1() {
            return this.uploads;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final UploadFiles copy(List<UploadFile> uploads, String conversationId) {
            Intrinsics.checkNotNullParameter(uploads, "uploads");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new UploadFiles(uploads, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof UploadFiles)) {
                return false;
            }
            UploadFiles uploadFiles = (UploadFiles) other;
            return Intrinsics.areEqual(this.uploads, uploadFiles.uploads) && Intrinsics.areEqual(this.conversationId, uploadFiles.conversationId);
        }

        public int hashCode() {
            return (this.uploads.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "UploadFiles(uploads=" + this.uploads + ", conversationId=" + this.conversationId + ')';
        }

        public final List<UploadFile> getUploads() {
            return this.uploads;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public UploadFiles(List<UploadFile> uploads, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(uploads, "uploads");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.uploads = uploads;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$UploadFilesForRestoredUris;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UploadFilesForRestoredUris extends ConversationScreenAction {
        private final String conversationId;

        public static UploadFilesForRestoredUris copy$default(UploadFilesForRestoredUris uploadFilesForRestoredUris, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = uploadFilesForRestoredUris.conversationId;
            }
            return uploadFilesForRestoredUris.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final UploadFilesForRestoredUris copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new UploadFilesForRestoredUris(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UploadFilesForRestoredUris) && Intrinsics.areEqual(this.conversationId, ((UploadFilesForRestoredUris) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "UploadFilesForRestoredUris(conversationId=" + this.conversationId + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public UploadFilesForRestoredUris(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ResendFailedMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "failedMessage", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFailedMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ResendFailedMessage extends ConversationScreenAction {
        private final String conversationId;
        private final Message failedMessage;

        public static ResendFailedMessage copy$default(ResendFailedMessage resendFailedMessage, Message message, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                message = resendFailedMessage.failedMessage;
            }
            if ((i & 2) != 0) {
                str = resendFailedMessage.conversationId;
            }
            return resendFailedMessage.copy(message, str);
        }

        public final Message getFailedMessage() {
            return this.failedMessage;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ResendFailedMessage copy(Message failedMessage, String conversationId) {
            Intrinsics.checkNotNullParameter(failedMessage, "failedMessage");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ResendFailedMessage(failedMessage, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ResendFailedMessage)) {
                return false;
            }
            ResendFailedMessage resendFailedMessage = (ResendFailedMessage) other;
            return Intrinsics.areEqual(this.failedMessage, resendFailedMessage.failedMessage) && Intrinsics.areEqual(this.conversationId, resendFailedMessage.conversationId);
        }

        public int hashCode() {
            return (this.failedMessage.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "ResendFailedMessage(failedMessage=" + this.failedMessage + ", conversationId=" + this.conversationId + ')';
        }

        public final Message getFailedMessage() {
            return this.failedMessage;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public ResendFailedMessage(Message failedMessage, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(failedMessage, "failedMessage");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.failedMessage = failedMessage;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u000f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0006HÆ\u0003J\t\u0010\u0012\u001a\u00020\bHÆ\u0003J-\u0010\u0013\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\bHÖ\u0001R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendFormResponse;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "fields", "", "Lzendesk/conversationkit/android/model/Field;", "formMessageContainer", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "conversationId", "", "(Ljava/util/List;Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFields", "()Ljava/util/List;", "getFormMessageContainer", "()Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendFormResponse extends ConversationScreenAction {
        private final String conversationId;
        private final List<Field> fields;
        private final MessageLogEntry.FormMessageContainer formMessageContainer;

        public static SendFormResponse copy$default(SendFormResponse sendFormResponse, List list, MessageLogEntry.FormMessageContainer formMessageContainer, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                list = sendFormResponse.fields;
            }
            if ((i & 2) != 0) {
                formMessageContainer = sendFormResponse.formMessageContainer;
            }
            if ((i & 4) != 0) {
                str = sendFormResponse.conversationId;
            }
            return sendFormResponse.copy(list, formMessageContainer, str);
        }

        public final List<Field> component1() {
            return this.fields;
        }

        public final MessageLogEntry.FormMessageContainer getFormMessageContainer() {
            return this.formMessageContainer;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final SendFormResponse copy(List<? extends Field> fields, MessageLogEntry.FormMessageContainer formMessageContainer, String conversationId) {
            Intrinsics.checkNotNullParameter(fields, "fields");
            Intrinsics.checkNotNullParameter(formMessageContainer, "formMessageContainer");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendFormResponse(fields, formMessageContainer, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendFormResponse)) {
                return false;
            }
            SendFormResponse sendFormResponse = (SendFormResponse) other;
            return Intrinsics.areEqual(this.fields, sendFormResponse.fields) && Intrinsics.areEqual(this.formMessageContainer, sendFormResponse.formMessageContainer) && Intrinsics.areEqual(this.conversationId, sendFormResponse.conversationId);
        }

        public int hashCode() {
            return (((this.fields.hashCode() * 31) + this.formMessageContainer.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "SendFormResponse(fields=" + this.fields + ", formMessageContainer=" + this.formMessageContainer + ", conversationId=" + this.conversationId + ')';
        }

        public final List<Field> getFields() {
            return this.fields;
        }

        public final MessageLogEntry.FormMessageContainer getFormMessageContainer() {
            return this.formMessageContainer;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public SendFormResponse(List<? extends Field> fields, MessageLogEntry.FormMessageContainer formMessageContainer, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(fields, "fields");
            Intrinsics.checkNotNullParameter(formMessageContainer, "formMessageContainer");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.fields = fields;
            this.formMessageContainer = formMessageContainer;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendActivityData;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "conversationId", "", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;)V", "getActivityData", "()Lzendesk/conversationkit/android/model/ActivityData;", "getConversationId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendActivityData extends ConversationScreenAction {
        private final ActivityData activityData;
        private final String conversationId;

        public static SendActivityData copy$default(SendActivityData sendActivityData, ActivityData activityData, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                activityData = sendActivityData.activityData;
            }
            if ((i & 2) != 0) {
                str = sendActivityData.conversationId;
            }
            return sendActivityData.copy(activityData, str);
        }

        public final ActivityData getActivityData() {
            return this.activityData;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final SendActivityData copy(ActivityData activityData, String conversationId) {
            Intrinsics.checkNotNullParameter(activityData, "activityData");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendActivityData(activityData, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendActivityData)) {
                return false;
            }
            SendActivityData sendActivityData = (SendActivityData) other;
            return this.activityData == sendActivityData.activityData && Intrinsics.areEqual(this.conversationId, sendActivityData.conversationId);
        }

        public int hashCode() {
            return (this.activityData.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "SendActivityData(activityData=" + this.activityData + ", conversationId=" + this.conversationId + ')';
        }

        public final ActivityData getActivityData() {
            return this.activityData;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public SendActivityData(ActivityData activityData, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(activityData, "activityData");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.activityData = activityData;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$RetryConnection;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RetryConnection extends ConversationScreenAction {
        public static final RetryConnection INSTANCE = new RetryConnection();

        private RetryConnection() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ShowDeniedPermission;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ShowDeniedPermission extends ConversationScreenAction {
        public static final ShowDeniedPermission INSTANCE = new ShowDeniedPermission();

        private ShowDeniedPermission() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$HideDeniedPermission;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class HideDeniedPermission extends ConversationScreenAction {
        public static final HideDeniedPermission INSTANCE = new HideDeniedPermission();

        private HideDeniedPermission() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SeeLatestViewClicked;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SeeLatestViewClicked extends ConversationScreenAction {
        public static final SeeLatestViewClicked INSTANCE = new SeeLatestViewClicked();

        private SeeLatestViewClicked() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$PersistComposerText;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "conversationId", "", "composerText", "(Ljava/lang/String;Ljava/lang/String;)V", "getComposerText", "()Ljava/lang/String;", "getConversationId", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PersistComposerText extends ConversationScreenAction {
        private final String composerText;
        private final String conversationId;

        public static PersistComposerText copy$default(PersistComposerText persistComposerText, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = persistComposerText.conversationId;
            }
            if ((i & 2) != 0) {
                str2 = persistComposerText.composerText;
            }
            return persistComposerText.copy(str, str2);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final String getComposerText() {
            return this.composerText;
        }

        public final PersistComposerText copy(String conversationId, String composerText) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(composerText, "composerText");
            return new PersistComposerText(conversationId, composerText);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof PersistComposerText)) {
                return false;
            }
            PersistComposerText persistComposerText = (PersistComposerText) other;
            return Intrinsics.areEqual(this.conversationId, persistComposerText.conversationId) && Intrinsics.areEqual(this.composerText, persistComposerText.composerText);
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + this.composerText.hashCode();
        }

        public String toString() {
            return "PersistComposerText(conversationId=" + this.conversationId + ", composerText=" + this.composerText + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final String getComposerText() {
            return this.composerText;
        }

        public PersistComposerText(String conversationId, String composerText) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(composerText, "composerText");
            this.conversationId = conversationId;
            this.composerText = composerText;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0006\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$LoadMoreMessages;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "conversationId", "", "beforeTimestamp", "", "(Ljava/lang/String;D)V", "getBeforeTimestamp", "()D", "getConversationId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMoreMessages extends ConversationScreenAction {
        private final double beforeTimestamp;
        private final String conversationId;

        public static LoadMoreMessages copy$default(LoadMoreMessages loadMoreMessages, String str, double d, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loadMoreMessages.conversationId;
            }
            if ((i & 2) != 0) {
                d = loadMoreMessages.beforeTimestamp;
            }
            return loadMoreMessages.copy(str, d);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public final LoadMoreMessages copy(String conversationId, double beforeTimestamp) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new LoadMoreMessages(conversationId, beforeTimestamp);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMoreMessages)) {
                return false;
            }
            LoadMoreMessages loadMoreMessages = (LoadMoreMessages) other;
            return Intrinsics.areEqual(this.conversationId, loadMoreMessages.conversationId) && Double.compare(this.beforeTimestamp, loadMoreMessages.beforeTimestamp) == 0;
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.beforeTimestamp);
        }

        public String toString() {
            return "LoadMoreMessages(conversationId=" + this.conversationId + ", beforeTimestamp=" + this.beforeTimestamp + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public LoadMoreMessages(String conversationId, double d) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
            this.beforeTimestamp = d;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$RetryLoadConversation;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RetryLoadConversation extends ConversationScreenAction {
        public static final RetryLoadConversation INSTANCE = new RetryLoadConversation();

        private RetryLoadConversation() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J'\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\bR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\b¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$SendPostbackMessage;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "conversationId", "", "actionId", "text", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getActionId", "()Ljava/lang/String;", "getConversationId", "getText", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendPostbackMessage extends ConversationScreenAction {
        private final String actionId;
        private final String conversationId;
        private final String text;

        public static SendPostbackMessage copy$default(SendPostbackMessage sendPostbackMessage, String str, String str2, String str3, int i, Object obj) {
            if ((i & 1) != 0) {
                str = sendPostbackMessage.conversationId;
            }
            if ((i & 2) != 0) {
                str2 = sendPostbackMessage.actionId;
            }
            if ((i & 4) != 0) {
                str3 = sendPostbackMessage.text;
            }
            return sendPostbackMessage.copy(str, str2, str3);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final String getActionId() {
            return this.actionId;
        }

        public final String getText() {
            return this.text;
        }

        public final SendPostbackMessage copy(String conversationId, String actionId, String text) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            Intrinsics.checkNotNullParameter(text, "text");
            return new SendPostbackMessage(conversationId, actionId, text);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendPostbackMessage)) {
                return false;
            }
            SendPostbackMessage sendPostbackMessage = (SendPostbackMessage) other;
            return Intrinsics.areEqual(this.conversationId, sendPostbackMessage.conversationId) && Intrinsics.areEqual(this.actionId, sendPostbackMessage.actionId) && Intrinsics.areEqual(this.text, sendPostbackMessage.text);
        }

        public int hashCode() {
            return (((this.conversationId.hashCode() * 31) + this.actionId.hashCode()) * 31) + this.text.hashCode();
        }

        public String toString() {
            return "SendPostbackMessage(conversationId=" + this.conversationId + ", actionId=" + this.actionId + ", text=" + this.text + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final String getActionId() {
            return this.actionId;
        }

        public final String getText() {
            return this.text;
        }

        public SendPostbackMessage(String conversationId, String actionId, String text) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            Intrinsics.checkNotNullParameter(text, "text");
            this.conversationId = conversationId;
            this.actionId = actionId;
            this.text = text;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$PostbackBannerDismissed;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PostbackBannerDismissed extends ConversationScreenAction {
        public static final PostbackBannerDismissed INSTANCE = new PostbackBannerDismissed();

        private PostbackBannerDismissed() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0006\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\u0007\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\b\u001a\u00020\u00032\b\u0010\t\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010\u000b\u001a\u00020\fHÖ\u0001J\t\u0010\r\u001a\u00020\u000eHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0002\u0010\u0005¨\u0006\u000f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$FormFocusChanged;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "isFocused", "", "(Z)V", "()Z", "component1", "copy", "equals", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FormFocusChanged extends ConversationScreenAction {
        private final boolean isFocused;

        public static FormFocusChanged copy$default(FormFocusChanged formFocusChanged, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                z = formFocusChanged.isFocused;
            }
            return formFocusChanged.copy(z);
        }

        public final boolean getIsFocused() {
            return this.isFocused;
        }

        public final FormFocusChanged copy(boolean isFocused) {
            return new FormFocusChanged(isFocused);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FormFocusChanged) && this.isFocused == ((FormFocusChanged) other).isFocused;
        }

        public int hashCode() {
            return UByte$$ExternalSyntheticBackport0.m30m(this.isFocused);
        }

        public String toString() {
            return "FormFocusChanged(isFocused=" + this.isFocused + ')';
        }

        public final boolean isFocused() {
            return this.isFocused;
        }

        public FormFocusChanged(boolean z) {
            super(null);
            this.isFocused = z;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$ViewAttachment;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "message", "Lzendesk/conversationkit/android/model/Message;", "(Lzendesk/conversationkit/android/model/Message;)V", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ViewAttachment extends ConversationScreenAction {
        private final Message message;

        public static ViewAttachment copy$default(ViewAttachment viewAttachment, Message message, int i, Object obj) {
            if ((i & 1) != 0) {
                message = viewAttachment.message;
            }
            return viewAttachment.copy(message);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final ViewAttachment copy(Message message) {
            Intrinsics.checkNotNullParameter(message, "message");
            return new ViewAttachment(message);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ViewAttachment) && Intrinsics.areEqual(this.message, ((ViewAttachment) other).message);
        }

        public int hashCode() {
            return this.message.hashCode();
        }

        public String toString() {
            return "ViewAttachment(message=" + this.message + ')';
        }

        public final Message getMessage() {
            return this.message;
        }

        public ViewAttachment(Message message) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            this.message = message;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction$CheckPollingStatus;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenAction;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CheckPollingStatus extends ConversationScreenAction {
        public static final CheckPollingStatus INSTANCE = new CheckPollingStatus();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CheckPollingStatus)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -1575307891;
        }

        public String toString() {
            return "CheckPollingStatus";
        }

        private CheckPollingStatus() {
            super(null);
        }
    }
}
