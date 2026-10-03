package zendesk.messaging.android.internal;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.webkit.MimeTypeMap;
import androidx.core.content.FileProvider;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.StringCompanionObject;
import zendesk.messaging.android.internal.model.UploadFile;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 \u00122\u00020\u0001:\u0001\u0012B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0002J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\nJ\u0010\u0010\u000b\u001a\u0004\u0018\u00010\n2\u0006\u0010\u0005\u001a\u00020\u0006J\u0010\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00020\rH\u0002J\u0010\u0010\u000f\u001a\u00020\r2\u0006\u0010\u0005\u001a\u00020\u0006H\u0002J\u0016\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\t\u001a\u00020\n¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/AttachmentFileResolver;", "", "()V", "createTemporaryFile", "Ljava/io/File;", "context", "Landroid/content/Context;", "createUploadFileFromUri", "Lzendesk/messaging/android/internal/model/UploadFile;", "uri", "Landroid/net/Uri;", "createUriToCapturePhoto", "generateFilePrefix", "", "timeStamp", "getAuthorityProvider", "grantPersistentMediaAccess", "", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AttachmentFileResolver {
    public static final String SIMPLE_DATE_FORMAT = "yyyyMMdd_HHmmss";
    public static final String TEMP_FILE_PREFIX = "JPEG_%s_";
    public static final String TEMP_FILE_SUFFIX = ".jpg";

    public final Uri createUriToCapturePhoto(Context context) throws IOException {
        Intrinsics.checkNotNullParameter(context, "context");
        File fileCreateTemporaryFile = createTemporaryFile(context);
        return FileProvider.getUriForFile(context.getApplicationContext(), getAuthorityProvider(context), fileCreateTemporaryFile);
    }

    private final File createTemporaryFile(Context context) throws IOException {
        String str = new SimpleDateFormat(SIMPLE_DATE_FORMAT, Locale.getDefault()).format(new Date());
        Intrinsics.checkNotNull(str);
        File fileCreateTempFile = File.createTempFile(generateFilePrefix(str), TEMP_FILE_SUFFIX, context.getCacheDir());
        fileCreateTempFile.createNewFile();
        fileCreateTempFile.deleteOnExit();
        Intrinsics.checkNotNullExpressionValue(fileCreateTempFile, "apply(...)");
        return fileCreateTempFile;
    }

    private final String getAuthorityProvider(Context context) {
        return context.getPackageName() + ".zendesk.messaging.provider";
    }

    private final String generateFilePrefix(String timeStamp) {
        StringCompanionObject stringCompanionObject = StringCompanionObject.INSTANCE;
        String str = String.format(TEMP_FILE_PREFIX, Arrays.copyOf(new Object[]{timeStamp}, 1));
        Intrinsics.checkNotNullExpressionValue(str, "format(...)");
        return str;
    }

    public final void grantPersistentMediaAccess(Context context, Uri uri) {
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(uri, "uri");
        ContentResolver contentResolver = context.getContentResolver();
        if (contentResolver != null) {
            contentResolver.takePersistableUriPermission(uri, 1);
        }
    }

    public final UploadFile createUploadFileFromUri(Context context, Uri uri) {
        String str;
        Intrinsics.checkNotNullParameter(context, "context");
        Intrinsics.checkNotNullParameter(uri, "uri");
        ContentResolver contentResolver = context.getContentResolver();
        Cursor cursorQuery = contentResolver != null ? contentResolver.query(uri, null, null, null, null) : null;
        if (cursorQuery != null) {
            cursorQuery.moveToFirst();
        }
        String string = cursorQuery != null ? cursorQuery.getString(cursorQuery.getColumnIndex("_display_name")) : null;
        String str2 = string == null ? "" : string;
        long j = cursorQuery != null ? cursorQuery.getLong(cursorQuery.getColumnIndex("_size")) : 0L;
        if (cursorQuery != null) {
            cursorQuery.close();
        }
        String fileExtensionFromUrl = MimeTypeMap.getFileExtensionFromUrl(str2);
        Intrinsics.checkNotNullExpressionValue(fileExtensionFromUrl, "getFileExtensionFromUrl(...)");
        String lowerCase = fileExtensionFromUrl.toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
        String mimeTypeFromExtension = MimeTypeMap.getSingleton().getMimeTypeFromExtension(lowerCase);
        if (mimeTypeFromExtension != null) {
            String lowerCase2 = mimeTypeFromExtension.toLowerCase(Locale.ROOT);
            Intrinsics.checkNotNullExpressionValue(lowerCase2, "toLowerCase(...)");
            if (lowerCase2 == null) {
                str = "";
            } else {
                str = lowerCase2;
            }
        } else {
            str = "";
        }
        String string2 = uri.toString();
        Intrinsics.checkNotNullExpressionValue(string2, "toString(...)");
        return new UploadFile(string2, str2, j, str);
    }
}
