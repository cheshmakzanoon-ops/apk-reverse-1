package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import java.util.ArrayList;
import java.util.Arrays;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.client.Topic;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;

public class SUBSCRIBE extends MessageSupport.HeaderBase implements MessageSupport.Message, MessageSupport.Acked {
    public static final Topic[] NO_TOPICS = new Topic[0];
    public static final byte TYPE = 8;
    private short messageId;
    private Topic[] topics = NO_TOPICS;

    @Override
    public byte messageType() {
        return (byte) 8;
    }

    public SUBSCRIBE() {
        qos(QoS.AT_LEAST_ONCE);
    }

    @Override
    public SUBSCRIBE mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        header(mQTTFrame.header());
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        if (qos() != QoS.AT_MOST_ONCE) {
            this.messageId = dataByteArrayInputStream.readShort();
        }
        ArrayList arrayList = new ArrayList();
        while (dataByteArrayInputStream.available() > 0) {
            arrayList.add(new Topic(MessageSupport.readUTF(dataByteArrayInputStream), QoS.values()[dataByteArrayInputStream.readByte()]));
        }
        this.topics = (Topic[]) arrayList.toArray(new Topic[arrayList.size()]);
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream();
            if (qos() != QoS.AT_MOST_ONCE) {
                dataByteArrayOutputStream.writeShort(this.messageId);
            }
            for (Topic topic : this.topics) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, topic.name());
                dataByteArrayOutputStream.writeByte(topic.qos().ordinal());
            }
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.header(header());
            mQTTFrame.commandType(8);
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
    public SUBSCRIBE dup(boolean z) {
        return (SUBSCRIBE) super.dup(z);
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
    public SUBSCRIBE messageId(short s) {
        this.messageId = s;
        return this;
    }

    public Topic[] topics() {
        return this.topics;
    }

    public SUBSCRIBE topics(Topic[] topicArr) {
        if (topicArr != null) {
            this.topics = topicArr;
        }
        return this;
    }

    public String toString() {
        StringBuilder sb = new StringBuilder("SUBSCRIBE{dup=");
        sb.append(dup());
        sb.append(", qos=");
        sb.append(qos());
        sb.append(", messageId=");
        sb.append((int) this.messageId);
        sb.append(", topics=");
        Topic[] topicArr = this.topics;
        sb.append(topicArr == null ? null : Arrays.asList(topicArr));
        sb.append(AbstractJsonLexerKt.END_OBJ);
        return sb.toString();
    }
}
