package net.aihelp.core.p004ui.glide.load.model;

import java.util.Collections;
import java.util.Map;

public interface Headers {

    @Deprecated
    public static final Headers NONE = new Headers() {
        @Override
        public Map<String, String> getHeaders() {
            return Collections.emptyMap();
        }
    };
    public static final Headers DEFAULT = new LazyHeaders.Builder().build();

    Map<String, String> getHeaders();
}
