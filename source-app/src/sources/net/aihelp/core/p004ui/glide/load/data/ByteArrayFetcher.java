package net.aihelp.core.p004ui.glide.load.data;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Priority;

public class ByteArrayFetcher implements DataFetcher<InputStream> {
    private final byte[] bytes;

    private final String f85id;

    @Override
    public void cancel() {
    }

    @Override
    public void cleanup() {
    }

    public ByteArrayFetcher(byte[] bArr, String str) {
        this.bytes = bArr;
        this.f85id = str;
    }

    @Override
    public InputStream loadData(Priority priority) {
        return new ByteArrayInputStream(this.bytes);
    }

    @Override
    public String getId() {
        return this.f85id;
    }
}
