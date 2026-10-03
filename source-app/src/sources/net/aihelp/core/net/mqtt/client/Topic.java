package net.aihelp.core.net.mqtt.client;

import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class Topic {
    private final UTF8Buffer name;
    private final QoS qos;

    public Topic(String str, QoS qoS) {
        this(new UTF8Buffer(str), qoS);
    }

    public Topic(UTF8Buffer uTF8Buffer, QoS qoS) {
        this.name = uTF8Buffer;
        this.qos = qoS;
    }

    public UTF8Buffer name() {
        return this.name;
    }

    public QoS qos() {
        return this.qos;
    }

    public boolean equals(Object obj) {
        if (obj == null || obj.getClass() != getClass()) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        Topic topic = (Topic) obj;
        UTF8Buffer uTF8Buffer = this.name;
        if (uTF8Buffer == null ? topic.name == null : uTF8Buffer.equals((Buffer) topic.name)) {
            return this.qos == topic.qos;
        }
        return false;
    }

    public int hashCode() {
        UTF8Buffer uTF8Buffer = this.name;
        int iHashCode = (uTF8Buffer != null ? uTF8Buffer.hashCode() : 0) * 31;
        QoS qoS = this.qos;
        return iHashCode + (qoS != null ? qoS.hashCode() : 0);
    }

    public String toString() {
        return "{ name=" + this.name + ", qos=" + this.qos + " }";
    }
}
