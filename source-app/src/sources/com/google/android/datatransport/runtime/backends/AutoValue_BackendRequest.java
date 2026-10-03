package com.google.android.datatransport.runtime.backends;

import com.google.android.datatransport.runtime.EventInternal;
import java.util.Arrays;

final class AutoValue_BackendRequest extends BackendRequest {
    private final Iterable<EventInternal> events;
    private final byte[] extras;

    private AutoValue_BackendRequest(Iterable<EventInternal> iterable, byte[] bArr) {
        this.events = iterable;
        this.extras = bArr;
    }

    @Override
    public Iterable<EventInternal> getEvents() {
        return this.events;
    }

    @Override
    public byte[] getExtras() {
        return this.extras;
    }

    public String toString() {
        return "BackendRequest{events=" + this.events + ", extras=" + Arrays.toString(this.extras) + "}";
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof BackendRequest)) {
            return false;
        }
        BackendRequest backendRequest = (BackendRequest) obj;
        if (this.events.equals(backendRequest.getEvents())) {
            if (Arrays.equals(this.extras, backendRequest instanceof AutoValue_BackendRequest ? ((AutoValue_BackendRequest) backendRequest).extras : backendRequest.getExtras())) {
                return true;
            }
        }
        return false;
    }

    public int hashCode() {
        return ((this.events.hashCode() ^ 1000003) * 1000003) ^ Arrays.hashCode(this.extras);
    }

    static final class Builder extends BackendRequest.Builder {
        private Iterable<EventInternal> events;
        private byte[] extras;

        Builder() {
        }

        @Override
        public BackendRequest.Builder setEvents(Iterable<EventInternal> iterable) {
            if (iterable == null) {
                throw new NullPointerException("Null events");
            }
            this.events = iterable;
            return this;
        }

        @Override
        public BackendRequest.Builder setExtras(byte[] bArr) {
            this.extras = bArr;
            return this;
        }

        @Override
        public BackendRequest build() {
            String str;
            if (this.events != null) {
                str = "";
            } else {
                str = " events";
            }
            if (!str.isEmpty()) {
                throw new IllegalStateException("Missing required properties:" + str);
            }
            return new AutoValue_BackendRequest(this.events, this.extras);
        }
    }
}
