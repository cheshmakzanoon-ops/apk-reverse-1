package zendesk.conversationkit.android.internal.rest;

import android.content.Context;
import android.net.Uri;
import android.util.Base64;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.FilesKt;
import kotlin.text.Charsets;
import okio.BufferedSink;
import okio.BufferedSource;
import okio.Okio;
import okio.Okio__JvmOkioKt;
import okio.Source;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0016J\b\u0010\t\u001a\u00020\u0006H\u0016J\b\u0010\n\u001a\u00020\u000bH\u0002J\u0010\u0010\f\u001a\u00020\u000b2\u0006\u0010\u0007\u001a\u00020\bH\u0002J\u0018\u0010\r\u001a\u00020\u000b2\u0006\u0010\u000e\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\bH\u0016R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/DefaultRestClientFiles;", "Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "cleanUpUpload", "", "name", "", "clearCache", "getCacheDir", "Ljava/io/File;", "getCacheFile", "getUploadFileForUri", "uri", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultRestClientFiles implements RestClientFiles {
    private final Context context;

    public DefaultRestClientFiles(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        this.context = context;
    }

    @Override
    public File getUploadFileForUri(String uri, String name) throws Exception {
        Source source;
        BufferedSource bufferedSourceBuffer;
        Intrinsics.checkNotNullParameter(uri, "uri");
        Intrinsics.checkNotNullParameter(name, "name");
        try {
            File cacheFile = getCacheFile(name);
            if (!cacheFile.exists()) {
                File parentFile = cacheFile.getParentFile();
                if (parentFile != null) {
                    parentFile.mkdirs();
                }
                cacheFile.createNewFile();
                InputStream inputStreamOpenInputStream = this.context.getContentResolver().openInputStream(Uri.parse(uri));
                if (inputStreamOpenInputStream != null && (source = Okio.source(inputStreamOpenInputStream)) != null && (bufferedSourceBuffer = Okio.buffer(source)) != null) {
                    BufferedSink bufferedSinkBuffer = Okio.buffer(Okio__JvmOkioKt.sink$default(cacheFile, false, 1, null));
                    bufferedSinkBuffer.writeAll(bufferedSourceBuffer);
                    bufferedSourceBuffer.close();
                    bufferedSinkBuffer.close();
                } else {
                    throw new IOException("Content resolver failed to find source for " + uri);
                }
            }
            return cacheFile;
        } catch (Exception e) {
            cleanUpUpload(name);
            throw e;
        }
    }

    @Override
    public void cleanUpUpload(String name) {
        Intrinsics.checkNotNullParameter(name, "name");
        getCacheFile(name).delete();
    }

    @Override
    public void clearCache() {
        FilesKt.deleteRecursively(getCacheDir());
    }

    private final File getCacheFile(String name) {
        byte[] bytes = name.getBytes(Charsets.UTF_8);
        Intrinsics.checkNotNullExpressionValue(bytes, "getBytes(...)");
        return new File(getCacheDir(), Base64.encodeToString(bytes, 8));
    }

    private final File getCacheDir() {
        return new File(this.context.getCacheDir().getPath() + File.pathSeparator + "upload_cache");
    }
}
