package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.client.cache.Resource;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

public class FileResource implements Resource {
    private static final long serialVersionUID = 4132244415919043397L;
    private volatile boolean disposed = false;
    private final File file;

    public FileResource(File file) {
        this.file = file;
    }

    synchronized File getFile() {
        return this.file;
    }

    @Override
    public synchronized InputStream getInputStream() throws IOException {
        return new FileInputStream(this.file);
    }

    @Override
    public synchronized long length() {
        return this.file.length();
    }

    @Override
    public synchronized void dispose() {
        if (this.disposed) {
            return;
        }
        this.disposed = true;
        this.file.delete();
    }
}
