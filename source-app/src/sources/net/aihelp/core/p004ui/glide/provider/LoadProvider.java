package net.aihelp.core.p004ui.glide.provider;

import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;

public interface LoadProvider<A, T, Z, R> extends DataLoadProvider<T, Z> {
    ModelLoader<A, T> getModelLoader();

    ResourceTranscoder<Z, R> getTranscoder();
}
