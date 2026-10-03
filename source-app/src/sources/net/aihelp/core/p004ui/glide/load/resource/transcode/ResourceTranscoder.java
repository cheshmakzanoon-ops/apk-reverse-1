package net.aihelp.core.p004ui.glide.load.resource.transcode;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public interface ResourceTranscoder<Z, R> {
    String getId();

    Resource<R> transcode(Resource<Z> resource);
}
