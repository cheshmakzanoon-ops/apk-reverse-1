package zendesk.messaging.android.internal;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import javax.inject.Singleton;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.android.internal.FileKtxKt;
import zendesk.messaging.android.internal.model.UploadFile;

@Singleton
@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0001\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0015\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0000¢\u0006\u0002\b\tR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/UploadFileResourceProvider;", "", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "getUploadFileFromIntent", "Lzendesk/messaging/android/internal/model/UploadFile;", "uri", "Landroid/net/Uri;", "getUploadFileFromIntent$zendesk_messaging_messaging_android", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UploadFileResourceProvider {
    private final Context context;

    public UploadFileResourceProvider(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.context = context;
    }

    public final UploadFile getUploadFileFromIntent$zendesk_messaging_messaging_android(Uri uri) {
        Intrinsics.checkNotNullParameter(uri, "uri");
        Cursor cursorQuery = this.context.getContentResolver().query(uri, null, null, null, null);
        if (cursorQuery != null) {
            cursorQuery.moveToFirst();
        }
        String string = cursorQuery != null ? cursorQuery.getString(cursorQuery.getColumnIndex("_display_name")) : null;
        if (string == null) {
            string = "";
        }
        String str = string;
        long j = cursorQuery != null ? cursorQuery.getLong(cursorQuery.getColumnIndex("_size")) : 0L;
        if (cursorQuery != null) {
            cursorQuery.close();
        }
        String mimeType = FileKtxKt.getMimeType(uri);
        String string2 = uri.toString();
        Intrinsics.checkNotNullExpressionValue(string2, "toString(...)");
        return new UploadFile(string2, str, j, mimeType);
    }
}
