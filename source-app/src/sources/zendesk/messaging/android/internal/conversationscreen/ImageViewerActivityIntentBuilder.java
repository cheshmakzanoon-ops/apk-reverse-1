package zendesk.messaging.android.internal.conversationscreen;

import android.content.Context;
import android.content.Intent;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0006\u0010\t\u001a\u00020\bJ\u000e\u0010\n\u001a\u00020\u00002\u0006\u0010\u000b\u001a\u00020\fJ\u000e\u0010\r\u001a\u00020\u00002\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\u00002\u0006\u0010\u0011\u001a\u00020\u0005R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ImageViewerActivityIntentBuilder;", "", "context", "Landroid/content/Context;", "credentials", "", "(Landroid/content/Context;Ljava/lang/String;)V", "intent", "Landroid/content/Intent;", "build", "withFlags", "flags", "", "withPrivateAttachmentFlag", "isPrivateAttachment", "", "withUri", "uri", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageViewerActivityIntentBuilder {
    private final Intent intent;

    public ImageViewerActivityIntentBuilder(Context context, String credentials) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(credentials, "credentials");
        Intent intent = new Intent(context, (Class<?>) ImageViewerActivity.class);
        this.intent = intent;
        ImageViewerActivityKt.setCredentials(intent, credentials);
    }

    public final ImageViewerActivityIntentBuilder withFlags(int flags) {
        this.intent.setFlags(flags);
        return this;
    }

    public final ImageViewerActivityIntentBuilder withUri(String uri) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        ImageViewerActivityKt.setUri(this.intent, uri);
        return this;
    }

    public final ImageViewerActivityIntentBuilder withPrivateAttachmentFlag(boolean isPrivateAttachment) {
        ImageViewerActivityKt.setPrivateAttachmentFlag(this.intent, isPrivateAttachment);
        return this;
    }

    public final Intent getIntent() {
        return this.intent;
    }
}
