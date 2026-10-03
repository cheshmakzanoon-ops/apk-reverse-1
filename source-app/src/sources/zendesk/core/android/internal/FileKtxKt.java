package zendesk.core.android.internal;

import android.content.Context;
import android.net.Uri;
import android.os.Environment;
import android.webkit.MimeTypeMap;
import java.io.File;
import java.util.Locale;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(m17d1 = {"\u0000\u001e\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u0014\u0010\u0003\u001a\u0004\u0018\u00010\u0004*\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0006\u001a\n\u0010\u0007\u001a\u00020\u0001*\u00020\u0001\u001a\n\u0010\b\u001a\u00020\u0001*\u00020\t\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u000e\u0010\u0002\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"FILE_NAME_QUERY_PARAMETER", "", "URL_WHITE_SPACE_DELIMITER", "doesFileExistInSDKExternalStorage", "Ljava/io/File;", "context", "Landroid/content/Context;", "getFileName", "getMimeType", "Landroid/net/Uri;", "zendesk.core_core-utilities"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class FileKtxKt {
    private static final String FILE_NAME_QUERY_PARAMETER = "name";
    private static final String URL_WHITE_SPACE_DELIMITER = "%20";

    public static final String getMimeType(Uri uri) {
        Intrinsics.checkNotNullParameter(uri, "<this>");
        String fileExtensionFromUrl = MimeTypeMap.getFileExtensionFromUrl(uri.toString());
        Intrinsics.checkNotNullExpressionValue(fileExtensionFromUrl, "getFileExtensionFromUrl(...)");
        String lowerCase = fileExtensionFromUrl.toLowerCase(Locale.ROOT);
        Intrinsics.checkNotNullExpressionValue(lowerCase, "toLowerCase(...)");
        String mimeTypeFromExtension = MimeTypeMap.getSingleton().getMimeTypeFromExtension(lowerCase);
        if (mimeTypeFromExtension != null) {
            String lowerCase2 = mimeTypeFromExtension.toLowerCase(Locale.ROOT);
            Intrinsics.checkNotNullExpressionValue(lowerCase2, "toLowerCase(...)");
            if (lowerCase2 != null) {
                return lowerCase2;
            }
        }
        return "";
    }

    public static final File doesFileExistInSDKExternalStorage(String str, Context context) {
        Intrinsics.checkNotNullParameter(str, "<this>");
        Intrinsics.checkNotNullParameter(context, "context");
        File file = new File(context.getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), str);
        if (file.exists()) {
            return file;
        }
        return null;
    }

    public static final String getFileName(String str) {
        Intrinsics.checkNotNullParameter(str, "<this>");
        String strReplace$default = StringsKt.replace$default(StringsKt.substringAfterLast$default(str, "/", (String) null, 2, (Object) null), URL_WHITE_SPACE_DELIMITER, " ", false, 4, (Object) null);
        try {
            String queryParameter = Uri.parse(str).getQueryParameter(FILE_NAME_QUERY_PARAMETER);
            if (queryParameter == null) {
                queryParameter = strReplace$default;
            }
            Intrinsics.checkNotNull(queryParameter);
            return queryParameter;
        } catch (NullPointerException unused) {
            return strReplace$default;
        }
    }
}
