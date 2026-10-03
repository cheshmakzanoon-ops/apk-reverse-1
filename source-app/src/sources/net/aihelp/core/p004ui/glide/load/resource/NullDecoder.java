package net.aihelp.core.p004ui.glide.load.resource;

import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class NullDecoder<T, Z> implements ResourceDecoder<T, Z> {
    private static final NullDecoder<?, ?> NULL_DECODER = new NullDecoder<>();

    @Override
    public Resource<Z> decode(T t, int i, int i2) {
        return null;
    }

    public static <T, Z> NullDecoder<T, Z> get() {
        return (NullDecoder<T, Z>) NULL_DECODER;
    }

    @Override
    public String getId() {
        return "";
    }
}
