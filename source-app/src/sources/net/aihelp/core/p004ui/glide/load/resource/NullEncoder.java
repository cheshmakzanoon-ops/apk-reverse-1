package net.aihelp.core.p004ui.glide.load.resource;

import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.Encoder;

public class NullEncoder<T> implements Encoder<T> {
    private static final NullEncoder<?> NULL_ENCODER = new NullEncoder<>();

    @Override
    public boolean encode(T t, OutputStream outputStream) {
        return false;
    }

    public static <T> Encoder<T> get() {
        return NULL_ENCODER;
    }

    @Override
    public String getId() {
        return "";
    }
}
