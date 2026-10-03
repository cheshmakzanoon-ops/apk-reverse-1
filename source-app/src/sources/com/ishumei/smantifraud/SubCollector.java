package com.ishumei.smantifraud;

import java.util.Map;

public abstract class SubCollector {
    public final long timeout;

    public SubCollector(long j) {
        this.timeout = j;
    }

    public abstract Map<String, Object> collect();
}
