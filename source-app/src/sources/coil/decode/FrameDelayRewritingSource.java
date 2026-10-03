package coil.decode;

import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.UByte;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;
import okio.Buffer;
import okio.ByteString;
import okio.ForwardingSource;
import okio.Source;

@Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0003\b\u0000\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0002J\u0018\u0010\u000b\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\bH\u0016J\u0010\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\r\u001a\u00020\bH\u0002J\u0018\u0010\u0010\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\bH\u0002R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, d2 = {"Lcoil/decode/FrameDelayRewritingSource;", "Lokio/ForwardingSource;", "delegate", "Lokio/Source;", "(Lokio/Source;)V", "buffer", "Lokio/Buffer;", "indexOf", "", "bytes", "Lokio/ByteString;", "read", "sink", "byteCount", "request", "", "write", "Companion", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class FrameDelayRewritingSource extends ForwardingSource {
    private static final int DEFAULT_FRAME_DELAY = 10;
    private static final int FRAME_DELAY_START_MARKER_SIZE_BYTES = 4;
    private static final int MINIMUM_FRAME_DELAY = 2;
    private final Buffer buffer;
    private static final Companion Companion = new Companion(null);
    private static final ByteString FRAME_DELAY_START_MARKER = ByteString.Companion.decodeHex("0021F904");

    public FrameDelayRewritingSource(Source source) {
        super(source);
        this.buffer = new Buffer();
    }

    public long read(Buffer sink, long byteCount) {
        request(byteCount);
        if (this.buffer.size() == 0) {
            return byteCount == 0 ? 0L : -1L;
        }
        long jWrite = 0;
        while (true) {
            long jIndexOf = indexOf(FRAME_DELAY_START_MARKER);
            if (jIndexOf == -1) {
                break;
            }
            jWrite += write(sink, jIndexOf + ((long) 4));
            if (request(5L) && this.buffer.getByte(4L) == 0 && (((UByte.constructor-impl(this.buffer.getByte(2L)) & 255) << 8) | (UByte.constructor-impl(this.buffer.getByte(1L)) & 255)) < 2) {
                sink.writeByte(this.buffer.getByte(0L));
                sink.writeByte(10);
                sink.writeByte(0);
                this.buffer.skip(3L);
            }
        }
        if (jWrite < byteCount) {
            jWrite += write(sink, byteCount - jWrite);
        }
        if (jWrite == 0) {
            return -1L;
        }
        return jWrite;
    }

    private final long indexOf(ByteString bytes) {
        long jIndexOf = -1;
        while (true) {
            jIndexOf = this.buffer.indexOf(bytes.getByte(0), jIndexOf + 1);
            if (jIndexOf == -1 || (request(bytes.size()) && this.buffer.rangeEquals(jIndexOf, bytes))) {
                break;
            }
        }
        return jIndexOf;
    }

    private final long write(Buffer sink, long byteCount) {
        return RangesKt.coerceAtLeast(this.buffer.read(sink, byteCount), 0L);
    }

    private final boolean request(long byteCount) {
        if (this.buffer.size() >= byteCount) {
            return true;
        }
        long size = byteCount - this.buffer.size();
        return super.read(this.buffer, size) == size;
    }

    @Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\t"}, d2 = {"Lcoil/decode/FrameDelayRewritingSource$Companion;", "", "()V", "DEFAULT_FRAME_DELAY", "", "FRAME_DELAY_START_MARKER", "Lokio/ByteString;", "FRAME_DELAY_START_MARKER_SIZE_BYTES", "MINIMUM_FRAME_DELAY", "coil-gif_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
