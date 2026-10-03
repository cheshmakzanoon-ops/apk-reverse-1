package net.aihelp.core.p004ui.glide.request;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public interface ResourceCallback {
    void onException(Exception exc);

    void onResourceReady(Resource<?> resource);
}
