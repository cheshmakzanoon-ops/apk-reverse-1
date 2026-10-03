package com.loopj.android.http;

import android.content.Context;
import com.ishumei.smantifraud.l111l11l11Ill;
import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.HttpEntity;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public abstract class FileAsyncHttpResponseHandler extends AsyncHttpResponseHandler {
    private static final String LOG_TAG = "FileAsyncHttpRH";
    protected final boolean append;
    protected final File file;
    protected File frontendFile;
    protected final boolean renameIfExists;

    public abstract void onFailure(int i, Header[] headerArr, Throwable th, File file);

    public abstract void onSuccess(int i, Header[] headerArr, File file);

    public FileAsyncHttpResponseHandler(File file) {
        this(file, false);
    }

    public FileAsyncHttpResponseHandler(File file, boolean z) {
        this(file, z, false);
    }

    public FileAsyncHttpResponseHandler(File file, boolean z, boolean z2) {
        this(file, z, z2, false);
    }

    public FileAsyncHttpResponseHandler(File file, boolean z, boolean z2, boolean z3) {
        super(z3);
        Utils.asserts(file != null, "File passed into FileAsyncHttpResponseHandler constructor must not be null");
        if (!file.isDirectory() && !file.getParentFile().isDirectory()) {
            Utils.asserts(file.getParentFile().mkdirs(), "Cannot create parent directories for requested File location");
        }
        if (file.isDirectory() && !file.mkdirs()) {
            AsyncHttpClient.log.mo382d(LOG_TAG, "Cannot create directories for requested Directory location, might not be a problem");
        }
        this.file = file;
        this.append = z;
        this.renameIfExists = z2;
    }

    public FileAsyncHttpResponseHandler(Context context) {
        this.file = getTemporaryFile(context);
        this.append = false;
        this.renameIfExists = false;
    }

    public boolean deleteTargetFile() {
        return getTargetFile() != null && getTargetFile().delete();
    }

    protected File getTemporaryFile(Context context) {
        Utils.asserts(context != null, "Tried creating temporary file without having Context");
        try {
            return File.createTempFile("temp_", "_handled", context.getCacheDir());
        } catch (IOException e) {
            AsyncHttpClient.log.mo385e(LOG_TAG, "Cannot create temporary file", e);
            return null;
        }
    }

    protected File getOriginalFile() {
        Utils.asserts(this.file != null, "Target file is null, fatal!");
        return this.file;
    }

    public File getTargetFile() {
        if (this.frontendFile == null) {
            this.frontendFile = getOriginalFile().isDirectory() ? getTargetFileByParsingURL() : getOriginalFile();
        }
        return this.frontendFile;
    }

    protected File getTargetFileByParsingURL() {
        String str;
        Utils.asserts(getOriginalFile().isDirectory(), "Target file is not a directory, cannot proceed");
        Utils.asserts(getRequestURI() != null, "RequestURI is null, cannot proceed");
        String string = getRequestURI().toString();
        String strSubstring = string.substring(string.lastIndexOf(47) + 1, string.length());
        File file = new File(getOriginalFile(), strSubstring);
        if (!file.exists() || !this.renameIfExists) {
            return file;
        }
        if (!strSubstring.contains(".")) {
            str = strSubstring + " (%d)";
        } else {
            str = strSubstring.substring(0, strSubstring.lastIndexOf(46)) + " (%d)" + strSubstring.substring(strSubstring.lastIndexOf(46), strSubstring.length());
        }
        int i = 0;
        while (true) {
            File file2 = new File(getOriginalFile(), String.format(str, Integer.valueOf(i)));
            if (!file2.exists()) {
                return file2;
            }
            i++;
        }
    }

    @Override
    public final void onFailure(int i, Header[] headerArr, byte[] bArr, Throwable th) {
        onFailure(i, headerArr, th, getTargetFile());
    }

    @Override
    public final void onSuccess(int i, Header[] headerArr, byte[] bArr) {
        onSuccess(i, headerArr, getTargetFile());
    }

    @Override
    protected byte[] getResponseData(HttpEntity httpEntity) throws IOException {
        if (httpEntity == null) {
            return null;
        }
        InputStream content = httpEntity.getContent();
        long contentLength = httpEntity.getContentLength();
        FileOutputStream fileOutputStream = new FileOutputStream(getTargetFile(), this.append);
        if (content == null) {
            return null;
        }
        try {
            byte[] bArr = new byte[l111l11l11Ill.l111l11111lIl];
            int i = 0;
            while (true) {
                int i2 = content.read(bArr);
                if (i2 == -1 || Thread.currentThread().isInterrupted()) {
                    break;
                }
                i += i2;
                fileOutputStream.write(bArr, 0, i2);
                sendProgressMessage(i, contentLength);
            }
            AsyncHttpClient.silentCloseInputStream(content);
            fileOutputStream.flush();
            AsyncHttpClient.silentCloseOutputStream(fileOutputStream);
            return null;
        } catch (Throwable th) {
            AsyncHttpClient.silentCloseInputStream(content);
            fileOutputStream.flush();
            AsyncHttpClient.silentCloseOutputStream(fileOutputStream);
            throw th;
        }
    }
}
