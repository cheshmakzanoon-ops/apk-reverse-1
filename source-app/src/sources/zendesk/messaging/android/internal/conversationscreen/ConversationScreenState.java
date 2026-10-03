package zendesk.messaging.android.internal.conversationscreen;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.internal.http2.Http2Connection;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.messaging.android.internal.model.LoadMoreStatus;
import zendesk.messaging.android.internal.model.MessageLogEntry;
import zendesk.messaging.android.internal.model.MessagingTheme;
import zendesk.messaging.android.internal.model.TypingUser;
import zendesk.p026ui.android.conversation.form.DisplayedForm;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerType;

@Metadata(m17d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010%\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\bH\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001BÇ\u0002\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0005\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0005\u0012\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e\u0012\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u0010\u0012\b\b\u0002\u0010\u0011\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u0012\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u0013\u001a\u00020\u0005\u0012\u0014\b\u0002\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00160\u0015\u0012\b\b\u0002\u0010\u0017\u001a\u00020\u0018\u0012\b\b\u0002\u0010\u0019\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u001a\u001a\u00020\u001b\u0012\b\b\u0002\u0010\u001c\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u001d\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u001e\u001a\u00020\u000e\u0012\b\b\u0002\u0010\u001f\u001a\u00020 \u0012\b\b\u0002\u0010!\u001a\u00020\u000e\u0012\u0014\b\u0002\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020#0\u0015\u0012\b\b\u0002\u0010$\u001a\u00020\u000e\u0012\b\b\u0002\u0010%\u001a\u00020\u0005\u0012\u000e\b\u0002\u0010&\u001a\b\u0012\u0004\u0012\u00020\u00050\t\u0012\n\b\u0002\u0010'\u001a\u0004\u0018\u00010\u0005\u0012\b\b\u0002\u0010(\u001a\u00020)\u0012\b\b\u0002\u0010*\u001a\u00020\u000e\u0012\b\b\u0002\u0010+\u001a\u00020\u0005¢\u0006\u0002\u0010,J\t\u0010R\u001a\u00020\u0003HÆ\u0003J\t\u0010S\u001a\u00020\u000eHÆ\u0003J\t\u0010T\u001a\u00020\u0005HÆ\u0003J\u0015\u0010U\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00160\u0015HÆ\u0003J\t\u0010V\u001a\u00020\u0018HÆ\u0003J\t\u0010W\u001a\u00020\u000eHÆ\u0003J\t\u0010X\u001a\u00020\u001bHÆ\u0003J\t\u0010Y\u001a\u00020\u000eHÆ\u0003J\t\u0010Z\u001a\u00020\u000eHÆ\u0003J\t\u0010[\u001a\u00020\u000eHÆ\u0003J\t\u0010\\\u001a\u00020 HÆ\u0003J\t\u0010]\u001a\u00020\u0005HÆ\u0003J\t\u0010^\u001a\u00020\u000eHÆ\u0003J\u0015\u0010_\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020#0\u0015HÆ\u0003J\t\u0010`\u001a\u00020\u000eHÆ\u0003J\t\u0010a\u001a\u00020\u0005HÆ\u0003J\u000f\u0010b\u001a\b\u0012\u0004\u0012\u00020\u00050\tHÆ\u0003J\u000b\u0010c\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010d\u001a\u00020)HÆ\u0003J\t\u0010e\u001a\u00020\u000eHÆ\u0003J\t\u0010f\u001a\u00020\u0005HÆ\u0003J\t\u0010g\u001a\u00020\u0005HÆ\u0003J\t\u0010h\u001a\u00020\u0005HÆ\u0003J\u000f\u0010i\u001a\b\u0012\u0004\u0012\u00020\n0\tHÆ\u0003J\u000b\u0010j\u001a\u0004\u0018\u00010\fHÆ\u0003J\t\u0010k\u001a\u00020\u000eHÆ\u0003J\u000b\u0010l\u001a\u0004\u0018\u00010\u0010HÆ\u0003J\t\u0010m\u001a\u00020\u000eHÆ\u0003JË\u0002\u0010n\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\u00052\u000e\b\u0002\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f2\b\b\u0002\u0010\r\u001a\u00020\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u000e2\b\b\u0002\u0010\u0012\u001a\u00020\u000e2\b\b\u0002\u0010\u0013\u001a\u00020\u00052\u0014\b\u0002\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00160\u00152\b\b\u0002\u0010\u0017\u001a\u00020\u00182\b\b\u0002\u0010\u0019\u001a\u00020\u000e2\b\b\u0002\u0010\u001a\u001a\u00020\u001b2\b\b\u0002\u0010\u001c\u001a\u00020\u000e2\b\b\u0002\u0010\u001d\u001a\u00020\u000e2\b\b\u0002\u0010\u001e\u001a\u00020\u000e2\b\b\u0002\u0010\u001f\u001a\u00020 2\b\b\u0002\u0010!\u001a\u00020\u000e2\u0014\b\u0002\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020#0\u00152\b\b\u0002\u0010$\u001a\u00020\u000e2\b\b\u0002\u0010%\u001a\u00020\u00052\u000e\b\u0002\u0010&\u001a\b\u0012\u0004\u0012\u00020\u00050\t2\n\b\u0002\u0010'\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010(\u001a\u00020)2\b\b\u0002\u0010*\u001a\u00020\u000e2\b\b\u0002\u0010+\u001a\u00020\u0005HÆ\u0001J\u0013\u0010o\u001a\u00020\u000e2\b\u0010p\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010q\u001a\u00020rHÖ\u0001J\t\u0010s\u001a\u00020\u0005HÖ\u0001R\u0011\u0010+\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b-\u0010.R\u0013\u0010'\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b/\u0010.R\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b0\u00101R\u0011\u0010\u0012\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b2\u00101R\u0011\u0010\u0013\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b3\u0010.R\u0013\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\b\n\u0000\u001a\u0004\b4\u00105R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\b\n\u0000\u001a\u0004\b6\u00107R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b8\u0010.R\u0011\u0010\u0011\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b9\u00101R\u0011\u0010\u001e\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u00101R\u0011\u0010*\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b*\u00101R\u0011\u0010\u001a\u001a\u00020\u001b¢\u0006\b\n\u0000\u001a\u0004\b:\u0010;R\u001d\u0010\u0014\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00160\u0015¢\u0006\b\n\u0000\u001a\u0004\b<\u0010=R\u001d\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020#0\u0015¢\u0006\b\n\u0000\u001a\u0004\b>\u0010=R\u0017\u0010\b\u001a\b\u0012\u0004\u0012\u00020\n0\t¢\u0006\b\n\u0000\u001a\u0004\b?\u0010@R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\bA\u0010BR\u0011\u0010%\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\bC\u0010.R\u0017\u0010&\u001a\b\u0012\u0004\u0012\u00020\u00050\t¢\u0006\b\n\u0000\u001a\u0004\bD\u0010@R\u0011\u0010!\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bE\u00101R\u0011\u0010\u001c\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bF\u00101R\u0011\u0010\u001d\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bG\u00101R\u0011\u0010\u0019\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bH\u00101R\u0011\u0010$\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bI\u00101R\u0011\u0010\u001f\u001a\u00020 ¢\u0006\b\n\u0000\u001a\u0004\bJ\u0010KR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\bL\u0010.R\u0011\u0010\u0007\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\bM\u0010.R\u0011\u0010\u0017\u001a\u00020\u0018¢\u0006\b\n\u0000\u001a\u0004\bN\u0010OR\u0011\u0010(\u001a\u00020)¢\u0006\b\n\u0000\u001a\u0004\bP\u0010Q¨\u0006t"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenState;", "", "messagingTheme", "Lzendesk/messaging/android/internal/model/MessagingTheme;", "title", "", "description", "toolbarImageUrl", "messageLog", "", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "blockChatInput", "", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "gallerySupported", "cameraSupported", "composerText", "mapOfDisplayedForms", "", "Lzendesk/ui/android/conversation/form/DisplayedForm;", "typingUser", "Lzendesk/messaging/android/internal/model/TypingUser;", "showDeniedPermission", "loadMoreStatus", "Lzendesk/messaging/android/internal/model/LoadMoreStatus;", "shouldAnnounceMessage", "shouldSeeLatestViewVisible", "isAttachmentsEnabled", "status", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenStatus;", "scrollToTheBottom", "mapOfDisplayedPostbackStatuses", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenPostbackStatus;", "showPostbackErrorBanner", "postbackErrorText", "restoredUris", "authorizationToken", "waitTimeBannerType", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "isFormFocused", "accessibilityTitle", "(Lzendesk/messaging/android/internal/model/MessagingTheme;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/model/Conversation;ZLzendesk/conversationkit/android/ConnectionStatus;ZZLjava/lang/String;Ljava/util/Map;Lzendesk/messaging/android/internal/model/TypingUser;ZLzendesk/messaging/android/internal/model/LoadMoreStatus;ZZZLzendesk/messaging/android/internal/conversationscreen/ConversationScreenStatus;ZLjava/util/Map;ZLjava/lang/String;Ljava/util/List;Ljava/lang/String;Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;ZLjava/lang/String;)V", "getAccessibilityTitle", "()Ljava/lang/String;", "getAuthorizationToken", "getBlockChatInput", "()Z", "getCameraSupported", "getComposerText", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getDescription", "getGallerySupported", "getLoadMoreStatus", "()Lzendesk/messaging/android/internal/model/LoadMoreStatus;", "getMapOfDisplayedForms", "()Ljava/util/Map;", "getMapOfDisplayedPostbackStatuses", "getMessageLog", "()Ljava/util/List;", "getMessagingTheme", "()Lzendesk/messaging/android/internal/model/MessagingTheme;", "getPostbackErrorText", "getRestoredUris", "getScrollToTheBottom", "getShouldAnnounceMessage", "getShouldSeeLatestViewVisible", "getShowDeniedPermission", "getShowPostbackErrorBanner", "getStatus", "()Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenStatus;", "getTitle", "getToolbarImageUrl", "getTypingUser", "()Lzendesk/messaging/android/internal/model/TypingUser;", "getWaitTimeBannerType", "()Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component16", "component17", "component18", "component19", "component2", "component20", "component21", "component22", "component23", "component24", "component25", "component26", "component27", "component28", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationScreenState {
    private final String accessibilityTitle;
    private final String authorizationToken;
    private final boolean blockChatInput;
    private final boolean cameraSupported;
    private final String composerText;
    private final ConnectionStatus connectionStatus;
    private final Conversation conversation;
    private final String description;
    private final boolean gallerySupported;
    private final boolean isAttachmentsEnabled;
    private final boolean isFormFocused;
    private final LoadMoreStatus loadMoreStatus;
    private final Map<String, DisplayedForm> mapOfDisplayedForms;
    private final Map<String, ConversationScreenPostbackStatus> mapOfDisplayedPostbackStatuses;
    private final List<MessageLogEntry> messageLog;
    private final MessagingTheme messagingTheme;
    private final String postbackErrorText;
    private final List<String> restoredUris;
    private final boolean scrollToTheBottom;
    private final boolean shouldAnnounceMessage;
    private final boolean shouldSeeLatestViewVisible;
    private final boolean showDeniedPermission;
    private final boolean showPostbackErrorBanner;
    private final ConversationScreenStatus status;
    private final String title;
    private final String toolbarImageUrl;
    private final TypingUser typingUser;
    private final WaitTimeBannerType waitTimeBannerType;

    public ConversationScreenState() {
        this(null, null, null, null, null, null, false, null, false, false, null, null, null, false, null, false, false, false, null, false, null, false, null, null, null, null, false, null, 268435455, null);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final boolean getCameraSupported() {
        return this.cameraSupported;
    }

    public final String getComposerText() {
        return this.composerText;
    }

    public final Map<String, DisplayedForm> component12() {
        return this.mapOfDisplayedForms;
    }

    public final TypingUser getTypingUser() {
        return this.typingUser;
    }

    public final boolean getShowDeniedPermission() {
        return this.showDeniedPermission;
    }

    public final LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final boolean getShouldAnnounceMessage() {
        return this.shouldAnnounceMessage;
    }

    public final boolean getShouldSeeLatestViewVisible() {
        return this.shouldSeeLatestViewVisible;
    }

    public final boolean getIsAttachmentsEnabled() {
        return this.isAttachmentsEnabled;
    }

    public final ConversationScreenStatus getStatus() {
        return this.status;
    }

    public final String getTitle() {
        return this.title;
    }

    public final boolean getScrollToTheBottom() {
        return this.scrollToTheBottom;
    }

    public final Map<String, ConversationScreenPostbackStatus> component21() {
        return this.mapOfDisplayedPostbackStatuses;
    }

    public final boolean getShowPostbackErrorBanner() {
        return this.showPostbackErrorBanner;
    }

    public final String getPostbackErrorText() {
        return this.postbackErrorText;
    }

    public final List<String> component24() {
        return this.restoredUris;
    }

    public final String getAuthorizationToken() {
        return this.authorizationToken;
    }

    public final WaitTimeBannerType getWaitTimeBannerType() {
        return this.waitTimeBannerType;
    }

    public final boolean getIsFormFocused() {
        return this.isFormFocused;
    }

    public final String getAccessibilityTitle() {
        return this.accessibilityTitle;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getToolbarImageUrl() {
        return this.toolbarImageUrl;
    }

    public final List<MessageLogEntry> component5() {
        return this.messageLog;
    }

    public final Conversation getConversation() {
        return this.conversation;
    }

    public final boolean getBlockChatInput() {
        return this.blockChatInput;
    }

    public final ConnectionStatus getConnectionStatus() {
        return this.connectionStatus;
    }

    public final boolean getGallerySupported() {
        return this.gallerySupported;
    }

    public final ConversationScreenState copy(MessagingTheme messagingTheme, String title, String description, String toolbarImageUrl, List<? extends MessageLogEntry> messageLog, Conversation conversation, boolean blockChatInput, ConnectionStatus connectionStatus, boolean gallerySupported, boolean cameraSupported, String composerText, Map<String, DisplayedForm> mapOfDisplayedForms, TypingUser typingUser, boolean showDeniedPermission, LoadMoreStatus loadMoreStatus, boolean shouldAnnounceMessage, boolean shouldSeeLatestViewVisible, boolean isAttachmentsEnabled, ConversationScreenStatus status, boolean scrollToTheBottom, Map<String, ConversationScreenPostbackStatus> mapOfDisplayedPostbackStatuses, boolean showPostbackErrorBanner, String postbackErrorText, List<String> restoredUris, String authorizationToken, WaitTimeBannerType waitTimeBannerType, boolean isFormFocused, String accessibilityTitle) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(toolbarImageUrl, "toolbarImageUrl");
        Intrinsics.checkNotNullParameter(messageLog, "messageLog");
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForms, "mapOfDisplayedForms");
        Intrinsics.checkNotNullParameter(typingUser, "typingUser");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(mapOfDisplayedPostbackStatuses, "mapOfDisplayedPostbackStatuses");
        Intrinsics.checkNotNullParameter(postbackErrorText, "postbackErrorText");
        Intrinsics.checkNotNullParameter(restoredUris, "restoredUris");
        Intrinsics.checkNotNullParameter(waitTimeBannerType, "waitTimeBannerType");
        Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
        return new ConversationScreenState(messagingTheme, title, description, toolbarImageUrl, messageLog, conversation, blockChatInput, connectionStatus, gallerySupported, cameraSupported, composerText, mapOfDisplayedForms, typingUser, showDeniedPermission, loadMoreStatus, shouldAnnounceMessage, shouldSeeLatestViewVisible, isAttachmentsEnabled, status, scrollToTheBottom, mapOfDisplayedPostbackStatuses, showPostbackErrorBanner, postbackErrorText, restoredUris, authorizationToken, waitTimeBannerType, isFormFocused, accessibilityTitle);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationScreenState)) {
            return false;
        }
        ConversationScreenState conversationScreenState = (ConversationScreenState) other;
        return Intrinsics.areEqual(this.messagingTheme, conversationScreenState.messagingTheme) && Intrinsics.areEqual(this.title, conversationScreenState.title) && Intrinsics.areEqual(this.description, conversationScreenState.description) && Intrinsics.areEqual(this.toolbarImageUrl, conversationScreenState.toolbarImageUrl) && Intrinsics.areEqual(this.messageLog, conversationScreenState.messageLog) && Intrinsics.areEqual(this.conversation, conversationScreenState.conversation) && this.blockChatInput == conversationScreenState.blockChatInput && this.connectionStatus == conversationScreenState.connectionStatus && this.gallerySupported == conversationScreenState.gallerySupported && this.cameraSupported == conversationScreenState.cameraSupported && Intrinsics.areEqual(this.composerText, conversationScreenState.composerText) && Intrinsics.areEqual(this.mapOfDisplayedForms, conversationScreenState.mapOfDisplayedForms) && Intrinsics.areEqual(this.typingUser, conversationScreenState.typingUser) && this.showDeniedPermission == conversationScreenState.showDeniedPermission && this.loadMoreStatus == conversationScreenState.loadMoreStatus && this.shouldAnnounceMessage == conversationScreenState.shouldAnnounceMessage && this.shouldSeeLatestViewVisible == conversationScreenState.shouldSeeLatestViewVisible && this.isAttachmentsEnabled == conversationScreenState.isAttachmentsEnabled && this.status == conversationScreenState.status && this.scrollToTheBottom == conversationScreenState.scrollToTheBottom && Intrinsics.areEqual(this.mapOfDisplayedPostbackStatuses, conversationScreenState.mapOfDisplayedPostbackStatuses) && this.showPostbackErrorBanner == conversationScreenState.showPostbackErrorBanner && Intrinsics.areEqual(this.postbackErrorText, conversationScreenState.postbackErrorText) && Intrinsics.areEqual(this.restoredUris, conversationScreenState.restoredUris) && Intrinsics.areEqual(this.authorizationToken, conversationScreenState.authorizationToken) && Intrinsics.areEqual(this.waitTimeBannerType, conversationScreenState.waitTimeBannerType) && this.isFormFocused == conversationScreenState.isFormFocused && Intrinsics.areEqual(this.accessibilityTitle, conversationScreenState.accessibilityTitle);
    }

    public int hashCode() {
        int iHashCode = ((((((((this.messagingTheme.hashCode() * 31) + this.title.hashCode()) * 31) + this.description.hashCode()) * 31) + this.toolbarImageUrl.hashCode()) * 31) + this.messageLog.hashCode()) * 31;
        Conversation conversation = this.conversation;
        int iHashCode2 = (((iHashCode + (conversation == null ? 0 : conversation.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.blockChatInput)) * 31;
        ConnectionStatus connectionStatus = this.connectionStatus;
        int iHashCode3 = (((((((((((((((((((((((((((((((((iHashCode2 + (connectionStatus == null ? 0 : connectionStatus.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.gallerySupported)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.cameraSupported)) * 31) + this.composerText.hashCode()) * 31) + this.mapOfDisplayedForms.hashCode()) * 31) + this.typingUser.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showDeniedPermission)) * 31) + this.loadMoreStatus.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldAnnounceMessage)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldSeeLatestViewVisible)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isAttachmentsEnabled)) * 31) + this.status.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.scrollToTheBottom)) * 31) + this.mapOfDisplayedPostbackStatuses.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.showPostbackErrorBanner)) * 31) + this.postbackErrorText.hashCode()) * 31) + this.restoredUris.hashCode()) * 31;
        String str = this.authorizationToken;
        return ((((((iHashCode3 + (str != null ? str.hashCode() : 0)) * 31) + this.waitTimeBannerType.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isFormFocused)) * 31) + this.accessibilityTitle.hashCode();
    }

    public String toString() {
        return "ConversationScreenState(messagingTheme=" + this.messagingTheme + ", title=" + this.title + ", description=" + this.description + ", toolbarImageUrl=" + this.toolbarImageUrl + ", messageLog=" + this.messageLog + ", conversation=" + this.conversation + ", blockChatInput=" + this.blockChatInput + ", connectionStatus=" + this.connectionStatus + ", gallerySupported=" + this.gallerySupported + ", cameraSupported=" + this.cameraSupported + ", composerText=" + this.composerText + ", mapOfDisplayedForms=" + this.mapOfDisplayedForms + ", typingUser=" + this.typingUser + ", showDeniedPermission=" + this.showDeniedPermission + ", loadMoreStatus=" + this.loadMoreStatus + ", shouldAnnounceMessage=" + this.shouldAnnounceMessage + ", shouldSeeLatestViewVisible=" + this.shouldSeeLatestViewVisible + ", isAttachmentsEnabled=" + this.isAttachmentsEnabled + ", status=" + this.status + ", scrollToTheBottom=" + this.scrollToTheBottom + ", mapOfDisplayedPostbackStatuses=" + this.mapOfDisplayedPostbackStatuses + ", showPostbackErrorBanner=" + this.showPostbackErrorBanner + ", postbackErrorText=" + this.postbackErrorText + ", restoredUris=" + this.restoredUris + ", authorizationToken=" + this.authorizationToken + ", waitTimeBannerType=" + this.waitTimeBannerType + ", isFormFocused=" + this.isFormFocused + ", accessibilityTitle=" + this.accessibilityTitle + ')';
    }

    public ConversationScreenState(MessagingTheme messagingTheme, String title, String description, String toolbarImageUrl, List<? extends MessageLogEntry> messageLog, Conversation conversation, boolean z, ConnectionStatus connectionStatus, boolean z2, boolean z3, String composerText, Map<String, DisplayedForm> mapOfDisplayedForms, TypingUser typingUser, boolean z4, LoadMoreStatus loadMoreStatus, boolean z5, boolean z6, boolean z7, ConversationScreenStatus status, boolean z8, Map<String, ConversationScreenPostbackStatus> mapOfDisplayedPostbackStatuses, boolean z9, String postbackErrorText, List<String> restoredUris, String str, WaitTimeBannerType waitTimeBannerType, boolean z10, String accessibilityTitle) {
        Intrinsics.checkNotNullParameter(messagingTheme, "messagingTheme");
        Intrinsics.checkNotNullParameter(title, "title");
        Intrinsics.checkNotNullParameter(description, "description");
        Intrinsics.checkNotNullParameter(toolbarImageUrl, "toolbarImageUrl");
        Intrinsics.checkNotNullParameter(messageLog, "messageLog");
        Intrinsics.checkNotNullParameter(composerText, "composerText");
        Intrinsics.checkNotNullParameter(mapOfDisplayedForms, "mapOfDisplayedForms");
        Intrinsics.checkNotNullParameter(typingUser, "typingUser");
        Intrinsics.checkNotNullParameter(loadMoreStatus, "loadMoreStatus");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(mapOfDisplayedPostbackStatuses, "mapOfDisplayedPostbackStatuses");
        Intrinsics.checkNotNullParameter(postbackErrorText, "postbackErrorText");
        Intrinsics.checkNotNullParameter(restoredUris, "restoredUris");
        Intrinsics.checkNotNullParameter(waitTimeBannerType, "waitTimeBannerType");
        Intrinsics.checkNotNullParameter(accessibilityTitle, "accessibilityTitle");
        this.messagingTheme = messagingTheme;
        this.title = title;
        this.description = description;
        this.toolbarImageUrl = toolbarImageUrl;
        this.messageLog = messageLog;
        this.conversation = conversation;
        this.blockChatInput = z;
        this.connectionStatus = connectionStatus;
        this.gallerySupported = z2;
        this.cameraSupported = z3;
        this.composerText = composerText;
        this.mapOfDisplayedForms = mapOfDisplayedForms;
        this.typingUser = typingUser;
        this.showDeniedPermission = z4;
        this.loadMoreStatus = loadMoreStatus;
        this.shouldAnnounceMessage = z5;
        this.shouldSeeLatestViewVisible = z6;
        this.isAttachmentsEnabled = z7;
        this.status = status;
        this.scrollToTheBottom = z8;
        this.mapOfDisplayedPostbackStatuses = mapOfDisplayedPostbackStatuses;
        this.showPostbackErrorBanner = z9;
        this.postbackErrorText = postbackErrorText;
        this.restoredUris = restoredUris;
        this.authorizationToken = str;
        this.waitTimeBannerType = waitTimeBannerType;
        this.isFormFocused = z10;
        this.accessibilityTitle = accessibilityTitle;
    }

    public ConversationScreenState(MessagingTheme messagingTheme, String str, String str2, String str3, List list, Conversation conversation, boolean z, ConnectionStatus connectionStatus, boolean z2, boolean z3, String str4, Map map, TypingUser typingUser, boolean z4, LoadMoreStatus loadMoreStatus, boolean z5, boolean z6, boolean z7, ConversationScreenStatus conversationScreenStatus, boolean z8, Map map2, boolean z9, String str5, List list2, String str6, WaitTimeBannerType waitTimeBannerType, boolean z10, String str7, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? MessagingTheme.INSTANCE.getDEFAULT() : messagingTheme, (i & 2) != 0 ? "" : str, (i & 4) != 0 ? "" : str2, (i & 8) != 0 ? "" : str3, (i & 16) != 0 ? CollectionsKt.emptyList() : list, (i & 32) != 0 ? null : conversation, (i & 64) != 0 ? false : z, (i & 128) != 0 ? null : connectionStatus, (i & 256) != 0 ? true : z2, (i & 512) == 0 ? z3 : true, (i & 1024) != 0 ? "" : str4, (i & 2048) != 0 ? new LinkedHashMap() : map, (i & 4096) != 0 ? TypingUser.None.INSTANCE : typingUser, (i & 8192) != 0 ? false : z4, (i & 16384) != 0 ? LoadMoreStatus.NONE : loadMoreStatus, (i & 32768) != 0 ? false : z5, (i & 65536) != 0 ? false : z6, (i & 131072) != 0 ? false : z7, (i & 262144) != 0 ? ConversationScreenStatus.IDLE : conversationScreenStatus, (i & 524288) != 0 ? false : z8, (i & 1048576) != 0 ? new LinkedHashMap() : map2, (i & 2097152) != 0 ? false : z9, (i & 4194304) != 0 ? "" : str5, (i & 8388608) != 0 ? CollectionsKt.emptyList() : list2, (i & Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE) != 0 ? null : str6, (i & 33554432) != 0 ? WaitTimeBannerType.Cleared.INSTANCE : waitTimeBannerType, (i & 67108864) != 0 ? false : z10, (i & 134217728) != 0 ? "" : str7);
    }

    public final MessagingTheme getMessagingTheme() {
        return this.messagingTheme;
    }

    public final String getTitle() {
        return this.title;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getToolbarImageUrl() {
        return this.toolbarImageUrl;
    }

    public final List<MessageLogEntry> getMessageLog() {
        return this.messageLog;
    }

    public final Conversation getConversation() {
        return this.conversation;
    }

    public final boolean getBlockChatInput() {
        return this.blockChatInput;
    }

    public final ConnectionStatus getConnectionStatus() {
        return this.connectionStatus;
    }

    public final boolean getGallerySupported() {
        return this.gallerySupported;
    }

    public final boolean getCameraSupported() {
        return this.cameraSupported;
    }

    public final String getComposerText() {
        return this.composerText;
    }

    public final Map<String, DisplayedForm> getMapOfDisplayedForms() {
        return this.mapOfDisplayedForms;
    }

    public final TypingUser getTypingUser() {
        return this.typingUser;
    }

    public final boolean getShowDeniedPermission() {
        return this.showDeniedPermission;
    }

    public final LoadMoreStatus getLoadMoreStatus() {
        return this.loadMoreStatus;
    }

    public final boolean getShouldAnnounceMessage() {
        return this.shouldAnnounceMessage;
    }

    public final boolean getShouldSeeLatestViewVisible() {
        return this.shouldSeeLatestViewVisible;
    }

    public final boolean isAttachmentsEnabled() {
        return this.isAttachmentsEnabled;
    }

    public final ConversationScreenStatus getStatus() {
        return this.status;
    }

    public final boolean getScrollToTheBottom() {
        return this.scrollToTheBottom;
    }

    public final Map<String, ConversationScreenPostbackStatus> getMapOfDisplayedPostbackStatuses() {
        return this.mapOfDisplayedPostbackStatuses;
    }

    public final boolean getShowPostbackErrorBanner() {
        return this.showPostbackErrorBanner;
    }

    public final String getPostbackErrorText() {
        return this.postbackErrorText;
    }

    public final List<String> getRestoredUris() {
        return this.restoredUris;
    }

    public final String getAuthorizationToken() {
        return this.authorizationToken;
    }

    public final WaitTimeBannerType getWaitTimeBannerType() {
        return this.waitTimeBannerType;
    }

    public final boolean isFormFocused() {
        return this.isFormFocused;
    }

    public final String getAccessibilityTitle() {
        return this.accessibilityTitle;
    }
}
