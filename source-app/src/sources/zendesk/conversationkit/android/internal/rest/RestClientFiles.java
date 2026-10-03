package zendesk.conversationkit.android.internal.rest;

import java.io.File;
import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b`\u0018\u00002\u00020\u0001J\u0010\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H&J\b\u0010\u0006\u001a\u00020\u0003H&J\u0018\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u00052\u0006\u0010\u0004\u001a\u00020\u0005H&¨\u0006\n"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/RestClientFiles;", "", "cleanUpUpload", "", "name", "", "clearCache", "getUploadFileForUri", "Ljava/io/File;", "uri", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface RestClientFiles {
    void cleanUpUpload(String name);

    void clearCache();

    File getUploadFileForUri(String uri, String name);
}
