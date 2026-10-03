package net.aihelp.core.net.http;

import java.io.File;
import java.io.IOException;
import okhttp3.MediaType;
import okhttp3.RequestBody;
import okhttp3.internal.Util;
import okio.BufferedSink;
import okio.Okio;
import okio.Source;

public class FileProgressRequestBody extends RequestBody {
    private static final int SEGMENT_SIZE = 2048;
    protected File file;
    protected ProgressListener listener;
    private MediaType mediaType;

    public interface ProgressListener {
        void onProgress(int i, boolean z);
    }

    public FileProgressRequestBody(MediaType mediaType, File file, ProgressListener progressListener) {
        this.mediaType = mediaType;
        this.file = file;
        this.listener = progressListener;
    }

    @Override
    public long contentLength() {
        return this.file.length();
    }

    @Override
    public MediaType getContentType() {
        return this.mediaType;
    }

    @Override
    public void writeTo(BufferedSink bufferedSink) throws IOException {
        Source source = null;
        try {
            source = Okio.source(this.file);
            long j = 0;
            while (true) {
                long j2 = source.read(bufferedSink.getBufferField(), 2048L);
                if (j2 != -1) {
                    j += j2;
                    bufferedSink.flush();
                    ProgressListener progressListener = this.listener;
                    if (progressListener != null) {
                        progressListener.onProgress((int) ((100 * j) / contentLength()), j == contentLength());
                    }
                } else {
                    Util.closeQuietly(source);
                    return;
                }
            }
        } catch (Throwable th) {
            Util.closeQuietly(source);
            throw th;
        }
    }
}
