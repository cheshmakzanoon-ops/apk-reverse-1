package net.aihelp.core.p004ui.glide.load.resource;

import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class NullResourceEncoder<T> implements ResourceEncoder<T> {
    private static final NullResourceEncoder<?> NULL_ENCODER = new NullResourceEncoder<>();

    @Override
    public boolean encode(Resource<T> resource, OutputStream outputStream) {
        return false;
    }

    public static <T> NullResourceEncoder<T> get() {
        return (NullResourceEncoder<T>) NULL_ENCODER;
    }

    @Override
    public String getId() {
        return "";
    }
}
