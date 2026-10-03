package net.aihelp.core.net.mqtt.tansport;

import java.io.IOException;

public interface ProtocolCodec {

    public enum BufferState {
        EMPTY,
        WAS_EMPTY,
        NOT_EMPTY,
        FULL
    }

    BufferState flush() throws IOException;

    boolean full();

    long getLastReadSize();

    long getLastWriteSize();

    int getReadBufferSize();

    long getReadCounter();

    int getWriteBufferSize();

    long getWriteCounter();

    Object read() throws IOException;

    void setTransport(Transport transport);

    void unread(byte[] bArr);

    BufferState write(Object obj) throws IOException;
}
