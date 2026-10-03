package net.aihelp.core.p004ui.glide.load.data;

import net.aihelp.core.p004ui.glide.Priority;

public interface DataFetcher<T> {
    void cancel();

    void cleanup();

    String getId();

    T loadData(Priority priority) throws Exception;
}
