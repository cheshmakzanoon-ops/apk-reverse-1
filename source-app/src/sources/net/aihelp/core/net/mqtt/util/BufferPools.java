package net.aihelp.core.net.mqtt.util;

import java.util.HashMap;

public class BufferPools {
    private final HashMap<Integer, BufferPool> pools = new HashMap<>();

    public synchronized BufferPool getBufferPool(int i) {
        BufferPool bufferPool;
        bufferPool = this.pools.get(Integer.valueOf(i));
        if (bufferPool == null) {
            bufferPool = new BufferPool(i);
            this.pools.put(Integer.valueOf(i), bufferPool);
        }
        return bufferPool;
    }
}
