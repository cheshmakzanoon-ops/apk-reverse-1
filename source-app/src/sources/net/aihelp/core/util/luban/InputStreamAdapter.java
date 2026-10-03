package net.aihelp.core.util.luban;

import java.io.IOException;
import java.io.InputStream;

public abstract class InputStreamAdapter implements InputStreamProvider {
    private InputStream inputStream;

    public abstract InputStream openInternal() throws IOException;

    @Override
    public InputStream open() throws IOException {
        close();
        InputStream inputStreamOpenInternal = openInternal();
        this.inputStream = inputStreamOpenInternal;
        return inputStreamOpenInternal;
    }

    @Override
    public void close() {
        InputStream inputStream = this.inputStream;
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException unused) {
            } finally {
                this.inputStream = null;
            }
        }
    }
}
