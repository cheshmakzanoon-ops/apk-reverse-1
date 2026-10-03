package net.aihelp.core.net.mqtt.util;

public class BufferPool extends ThreadLocalPool<byte[]> {
    private final int bufferSize;

    public BufferPool(int i) {
        this.bufferSize = i;
    }

    @Override
    public byte[] create() {
        return new byte[this.bufferSize];
    }

    public int getBufferSize() {
        return this.bufferSize;
    }
}
