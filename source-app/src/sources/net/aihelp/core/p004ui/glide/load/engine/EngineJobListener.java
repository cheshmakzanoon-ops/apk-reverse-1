package net.aihelp.core.p004ui.glide.load.engine;

import net.aihelp.core.p004ui.glide.load.Key;

interface EngineJobListener {
    void onEngineJobCancelled(EngineJob engineJob, Key key);

    void onEngineJobComplete(Key key, EngineResource<?> engineResource);
}
