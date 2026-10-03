package net.aihelp.core.net.mqtt.codec;

import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.data.model.rpa.msg.base.Message;

public class MQTTFrame extends MessageSupport.HeaderBase {
    private static final Buffer[] NO_BUFFERS = new Buffer[0];
    public Buffer[] buffers;

    public MQTTFrame() {
        this.buffers = NO_BUFFERS;
    }

    public MQTTFrame(Buffer buffer) {
        this(new Buffer[]{buffer});
    }

    public MQTTFrame(Buffer[] bufferArr) {
        this.buffers = bufferArr;
    }

    public Buffer[] buffers() {
        return this.buffers;
    }

    public MQTTFrame buffers(Buffer... bufferArr) {
        this.buffers = bufferArr;
        return this;
    }

    public MQTTFrame buffer(Buffer buffer) {
        this.buffers = new Buffer[]{buffer};
        return this;
    }

    @Override
    public byte header() {
        return super.header();
    }

    @Override
    public MQTTFrame header(byte b) {
        return (MQTTFrame) super.header(b);
    }

    @Override
    public byte messageType() {
        return super.messageType();
    }

    @Override
    public MQTTFrame commandType(int i) {
        return (MQTTFrame) super.commandType(i);
    }

    @Override
    public boolean dup() {
        return super.dup();
    }

    @Override
    public MQTTFrame dup(boolean z) {
        return (MQTTFrame) super.dup(z);
    }

    @Override
    public QoS qos() {
        return super.qos();
    }

    @Override
    public MQTTFrame qos(QoS qoS) {
        return (MQTTFrame) super.qos(qoS);
    }

    @Override
    public boolean retain() {
        return super.retain();
    }

    @Override
    public MQTTFrame retain(boolean z) {
        return (MQTTFrame) super.retain(z);
    }

    public String toString() {
        String str;
        switch (messageType()) {
            case 1:
                str = "CONNECT";
                break;
            case 2:
                str = "CONNACK";
                break;
            case 3:
                str = "PUBLISH";
                break;
            case 4:
                str = "PUBACK";
                break;
            case 5:
                str = "PUBREC";
                break;
            case 6:
                str = "PUBREL";
                break;
            case 7:
                str = "PUBCOMP";
                break;
            case 8:
                str = "SUBSCRIBE";
                break;
            case 9:
                str = "SUBACK";
                break;
            case 10:
                str = "UNSUBSCRIBE";
                break;
            case 11:
                str = "UNSUBACK";
                break;
            case Message.TYPE_USER_VIDEO:
                str = "PINGREQ";
                break;
            case 13:
                str = "PINGRESP";
                break;
            case Message.TYPE_USER_FILE:
                str = "DISCONNECT";
                break;
            default:
                str = "unknown";
                break;
        }
        return "MQTTFrame { type: " + str + ", qos: " + qos() + ", dup:" + dup() + " }";
    }
}
