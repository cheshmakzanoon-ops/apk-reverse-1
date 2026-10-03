package net.aihelp.core.p004ui.glide.load;

import java.io.IOException;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public interface ResourceDecoder<T, Z> {
    Resource<Z> decode(T t, int i, int i2) throws IOException;

    String getId();
}
