package cz.msebera.android.httpclient.impl.client.cache;

import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

public class FailureCacheValue {
    private final long creationTimeInNanos = System.nanoTime();
    private final int errorCount;
    private final String key;

    public FailureCacheValue(String str, int i) {
        this.key = str;
        this.errorCount = i;
    }

    public long getCreationTimeInNanos() {
        return this.creationTimeInNanos;
    }

    public String getKey() {
        return this.key;
    }

    public int getErrorCount() {
        return this.errorCount;
    }

    public String toString() {
        return "[entry creationTimeInNanos=" + this.creationTimeInNanos + "; key=" + this.key + "; errorCount=" + this.errorCount + AbstractJsonLexerKt.END_LIST;
    }
}
