package androidx.webkit.internal;

import j$.util.Objects;
import org.chromium.support_lib_boundary.WebMessagePayloadBoundaryInterface;

public class WebMessagePayloadAdapter implements WebMessagePayloadBoundaryInterface {
    private final byte[] mArrayBuffer;
    private final String mString;
    private final int mType;

    public WebMessagePayloadAdapter(String str) {
        this.mType = 0;
        this.mString = str;
        this.mArrayBuffer = null;
    }

    public WebMessagePayloadAdapter(byte[] bArr) {
        this.mType = 1;
        this.mString = null;
        this.mArrayBuffer = bArr;
    }

    public String[] getSupportedFeatures() {
        return new String[0];
    }

    public int getType() {
        return this.mType;
    }

    public String getAsString() {
        checkType(0);
        return this.mString;
    }

    public byte[] getAsArrayBuffer() {
        checkType(1);
        return (byte[]) Objects.requireNonNull(this.mArrayBuffer);
    }

    private void checkType(int i) {
        if (this.mType == i) {
            return;
        }
        throw new IllegalStateException("Expected " + i + ", but type is " + this.mType);
    }
}
