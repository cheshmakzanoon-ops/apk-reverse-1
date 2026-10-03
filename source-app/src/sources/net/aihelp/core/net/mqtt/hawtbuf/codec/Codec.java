package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public interface Codec<T> {
    T decode(DataInput dataInput) throws IOException;

    T deepCopy(T t);

    void encode(T t, DataOutput dataOutput) throws IOException;

    int estimatedSize(T t);

    int getFixedSize();

    boolean isDeepCopySupported();

    boolean isEstimatedSizeSupported();
}
