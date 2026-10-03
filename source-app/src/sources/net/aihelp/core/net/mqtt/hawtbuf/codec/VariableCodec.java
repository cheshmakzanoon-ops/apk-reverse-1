package net.aihelp.core.net.mqtt.hawtbuf.codec;

public abstract class VariableCodec<T> implements Codec<T> {
    @Override
    public int getFixedSize() {
        return -1;
    }

    @Override
    public boolean isDeepCopySupported() {
        return false;
    }

    @Override
    public boolean isEstimatedSizeSupported() {
        return false;
    }

    @Override
    public T deepCopy(T t) {
        throw new UnsupportedOperationException();
    }

    @Override
    public int estimatedSize(T t) {
        throw new UnsupportedOperationException();
    }
}
