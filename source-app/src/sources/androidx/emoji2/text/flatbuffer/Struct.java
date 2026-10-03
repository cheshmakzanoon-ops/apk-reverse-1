package androidx.emoji2.text.flatbuffer;

import java.nio.ByteBuffer;

public class Struct {

    protected ByteBuffer f94bb;
    protected int bb_pos;

    protected void __reset(int i, ByteBuffer byteBuffer) {
        this.f94bb = byteBuffer;
        if (byteBuffer != null) {
            this.bb_pos = i;
        } else {
            this.bb_pos = 0;
        }
    }

    public void __reset() {
        __reset(0, null);
    }
}
