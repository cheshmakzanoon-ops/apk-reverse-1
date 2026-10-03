package net.aihelp.core.util.luban;

import java.io.IOException;
import java.io.InputStream;

public interface InputStreamProvider {
    void close();

    String getPath();

    InputStream open() throws IOException;
}
