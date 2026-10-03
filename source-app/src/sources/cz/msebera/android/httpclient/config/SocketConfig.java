package cz.msebera.android.httpclient.config;

import cz.msebera.android.httpclient.util.Args;

public class SocketConfig implements Cloneable {
    public static final SocketConfig DEFAULT = new Builder().build();
    private final boolean soKeepAlive;
    private final int soLinger;
    private final boolean soReuseAddress;
    private final int soTimeout;
    private final boolean tcpNoDelay;

    SocketConfig(int i, boolean z, int i2, boolean z2, boolean z3) {
        this.soTimeout = i;
        this.soReuseAddress = z;
        this.soLinger = i2;
        this.soKeepAlive = z2;
        this.tcpNoDelay = z3;
    }

    public int getSoTimeout() {
        return this.soTimeout;
    }

    public boolean isSoReuseAddress() {
        return this.soReuseAddress;
    }

    public int getSoLinger() {
        return this.soLinger;
    }

    public boolean isSoKeepAlive() {
        return this.soKeepAlive;
    }

    public boolean isTcpNoDelay() {
        return this.tcpNoDelay;
    }

    public SocketConfig m290clone() throws CloneNotSupportedException {
        return (SocketConfig) super.clone();
    }

    public String toString() {
        return "[soTimeout=" + this.soTimeout + ", soReuseAddress=" + this.soReuseAddress + ", soLinger=" + this.soLinger + ", soKeepAlive=" + this.soKeepAlive + ", tcpNoDelay=" + this.tcpNoDelay + "]";
    }

    public static Builder custom() {
        return new Builder();
    }

    public static Builder copy(SocketConfig socketConfig) {
        Args.notNull(socketConfig, "Socket config");
        return new Builder().setSoTimeout(socketConfig.getSoTimeout()).setSoReuseAddress(socketConfig.isSoReuseAddress()).setSoLinger(socketConfig.getSoLinger()).setSoKeepAlive(socketConfig.isSoKeepAlive()).setTcpNoDelay(socketConfig.isTcpNoDelay());
    }

    public static class Builder {
        private boolean soKeepAlive;
        private boolean soReuseAddress;
        private int soTimeout;
        private int soLinger = -1;
        private boolean tcpNoDelay = true;

        Builder() {
        }

        public Builder setSoTimeout(int i) {
            this.soTimeout = i;
            return this;
        }

        public Builder setSoReuseAddress(boolean z) {
            this.soReuseAddress = z;
            return this;
        }

        public Builder setSoLinger(int i) {
            this.soLinger = i;
            return this;
        }

        public Builder setSoKeepAlive(boolean z) {
            this.soKeepAlive = z;
            return this;
        }

        public Builder setTcpNoDelay(boolean z) {
            this.tcpNoDelay = z;
            return this;
        }

        public SocketConfig build() {
            return new SocketConfig(this.soTimeout, this.soReuseAddress, this.soLinger, this.soKeepAlive, this.tcpNoDelay);
        }
    }
}
