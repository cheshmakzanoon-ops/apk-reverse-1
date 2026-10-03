package net.aihelp.core.p004ui.glide.load.resource.transcode;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class UnitTranscoder<Z> implements ResourceTranscoder<Z, Z> {
    private static final UnitTranscoder<?> UNIT_TRANSCODER = new UnitTranscoder<>();

    @Override
    public Resource<Z> transcode(Resource<Z> resource) {
        return resource;
    }

    public static <Z> ResourceTranscoder<Z, Z> get() {
        return UNIT_TRANSCODER;
    }

    @Override
    public String getId() {
        return "";
    }
}
