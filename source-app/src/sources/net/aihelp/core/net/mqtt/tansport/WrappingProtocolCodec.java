package net.aihelp.core.net.mqtt.tansport;

public interface WrappingProtocolCodec extends ProtocolCodec {
    ProtocolCodec getNext();

    void setNext(ProtocolCodec protocolCodec);
}
