package net.aihelp.core.p004ui.glide.provider;

import java.io.File;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;

public class EmptyDataLoadProvider<T, Z> implements DataLoadProvider<T, Z> {
    private static final DataLoadProvider<?, ?> EMPTY_DATA_LOAD_PROVIDER = new EmptyDataLoadProvider();

    @Override
    public ResourceDecoder<File, Z> getCacheDecoder() {
        return null;
    }

    @Override
    public ResourceEncoder<Z> getEncoder() {
        return null;
    }

    @Override
    public ResourceDecoder<T, Z> getSourceDecoder() {
        return null;
    }

    @Override
    public Encoder<T> getSourceEncoder() {
        return null;
    }

    public static <T, Z> DataLoadProvider<T, Z> get() {
        return (DataLoadProvider<T, Z>) EMPTY_DATA_LOAD_PROVIDER;
    }
}
