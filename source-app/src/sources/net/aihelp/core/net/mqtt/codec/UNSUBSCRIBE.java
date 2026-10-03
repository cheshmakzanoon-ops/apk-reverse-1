package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import java.util.ArrayList;
import java.util.Arrays;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class UNSUBSCRIBE extends MessageSupport.HeaderBase implements MessageSupport.Message, MessageSupport.Acked {
    public static final UTF8Buffer[] NO_TOPICS = new UTF8Buffer[0];
    public static final byte TYPE = 10;
    private short messageId;
    private UTF8Buffer[] topics = NO_TOPICS;

    @Override
    public byte messageType() {
        return (byte) 10;
    }

    public UNSUBSCRIBE() {
        qos(QoS.AT_LEAST_ONCE);
    }

    @Override
    public UNSUBSCRIBE mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        header(mQTTFrame.header());
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        this.messageId = dataByteArrayInputStream.readShort();
        ArrayList arrayList = new ArrayList();
        while (dataByteArrayInputStream.available() > 0) {
            arrayList.add(MessageSupport.readUTF(dataByteArrayInputStream));
        }
        this.topics = (UTF8Buffer[]) arrayList.toArray(new UTF8Buffer[arrayList.size()]);
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream();
            if (qos() != QoS.AT_MOST_ONCE) {
                dataByteArrayOutputStream.writeShort(this.messageId);
            }
            for (UTF8Buffer uTF8Buffer : this.topics) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, uTF8Buffer);
            }
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.header(header());
            mQTTFrame.commandType(10);
            return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    @Override
    public boolean dup() {
        return super.dup();
    }

    @Override
    public UNSUBSCRIBE dup(boolean z) {
        return (UNSUBSCRIBE) super.dup(z);
    }

    @Override
    public QoS qos() {
        return super.qos();
    }

    @Override
    public short messageId() {
        return this.messageId;
    }

    @Override
    public UNSUBSCRIBE messageId(short s) {
        this.messageId = s;
        return this;
    }

    public UTF8Buffer[] topics() {
        return this.topics;
    }

    public UNSUBSCRIBE topics(UTF8Buffer[] uTF8BufferArr) {
        this.topics = uTF8BufferArr;
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("UNSUBSCRIBE{dup=");
        sb.append(dup());
        sb.append(", qos=");
        sb.append(qos());
        sb.append(", messageId=");
        sb.append((int) this.messageId);
        sb.append(", topics=");
        UTF8Buffer[] uTF8BufferArr = this.topics;
        sb.append(uTF8BufferArr == null ? null : Arrays.asList(uTF8BufferArr));
        sb.append(AbstractJsonLexerKt.END_OBJ);
        return sb.toString();
    }
}
