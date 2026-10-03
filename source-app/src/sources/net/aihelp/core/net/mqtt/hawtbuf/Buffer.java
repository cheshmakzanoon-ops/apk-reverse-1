package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import kotlin.UByte;

public class Buffer implements Comparable<Buffer> {
    public byte[] data;
    public int length;
    public int offset;

    public Buffer(ByteBuffer byteBuffer) {
        this(byteBuffer.array(), byteBuffer.arrayOffset() + byteBuffer.position(), byteBuffer.remaining());
    }

    public Buffer(Buffer buffer) {
        this(buffer.data, buffer.offset, buffer.length);
    }

    public Buffer(int i) {
        this(new byte[i]);
    }

    public Buffer(byte[] bArr) {
        this(bArr, 0, bArr.length);
    }

    public Buffer(byte[] bArr, int i, int i2) {
        this.data = bArr;
        this.offset = i;
        this.length = i2;
    }

    public String hex() {
        return HexSupport.toHexFromBuffer(this);
    }

    public final Buffer flip() {
        this.length = this.offset;
        this.offset = 0;
        return this;
    }

    public final Buffer moveHead(int i) {
        this.offset += i;
        this.length -= i;
        return this;
    }

    public final Buffer moveTail(int i) {
        this.length += i;
        return this;
    }

    public final Buffer clear() {
        this.length = this.data.length;
        this.offset = 0;
        return this;
    }

    public final Buffer slice(int i, int i2) {
        int i3 = i2 < 0 ? this.length + i2 : i2 - i;
        if (i3 < 0) {
            i3 = 0;
        }
        return new Buffer(this.data, this.offset + i, i3);
    }

    public final byte[] getData() {
        return this.data;
    }

    public final Buffer data(byte[] bArr) {
        this.data = bArr;
        return this;
    }

    public final int getLength() {
        return this.length;
    }

    public final int length() {
        return this.length;
    }

    public final Buffer length(int i) {
        this.length = i;
        return this;
    }

    public final int getOffset() {
        return this.offset;
    }

    public final Buffer offset(int i) {
        this.offset = i;
        return this;
    }

    public final Buffer deepCopy() {
        int i = this.length;
        byte[] bArr = new byte[i];
        System.arraycopy(this.data, this.offset, bArr, 0, i);
        return new Buffer(bArr);
    }

    public final Buffer compact() {
        return this.length != this.data.length ? new Buffer(toByteArray()) : this;
    }

    public final byte[] toByteArray() {
        byte[] bArr = this.data;
        int i = this.length;
        if (i == bArr.length) {
            return bArr;
        }
        byte[] bArr2 = new byte[i];
        System.arraycopy(bArr, this.offset, bArr2, 0, i);
        return bArr2;
    }

    public final byte get(int i) {
        return this.data[this.offset + i];
    }

    public final boolean equals(Buffer buffer) {
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length;
        if (i2 != buffer.length) {
            return false;
        }
        byte[] bArr2 = buffer.data;
        int i3 = buffer.offset;
        for (int i4 = 0; i4 < i2; i4++) {
            if (bArr2[i3 + i4] != bArr[i + i4]) {
                return false;
            }
        }
        return true;
    }

    public final BufferInputStream m131in() {
        return new BufferInputStream(this);
    }

    public final BufferOutputStream out() {
        return new BufferOutputStream(this);
    }

    public final BufferEditor bigEndianEditor() {
        return new BufferEditor.BigEndianBufferEditor(this);
    }

    public final BufferEditor littleEndianEditor() {
        return new BufferEditor.LittleEndianBufferEditor(this);
    }

    public final boolean isEmpty() {
        return this.length == 0;
    }

    public final boolean contains(byte b) {
        return indexOf(b, 0) >= 0;
    }

    public final int indexOf(byte b) {
        return indexOf(b, 0);
    }

    public final int indexOf(byte b, int i) {
        byte[] bArr = this.data;
        int i2 = this.offset;
        int i3 = this.length;
        while (i < i3) {
            if (bArr[i2 + i] == b) {
                return i;
            }
            i++;
        }
        return -1;
    }

    public final boolean startsWith(Buffer buffer) {
        return indexOf(buffer, 0) == 0;
    }

    public final int indexOf(Buffer buffer) {
        return indexOf(buffer, 0);
    }

    public final int indexOf(Buffer buffer, int i) {
        int i2 = this.length - buffer.length;
        while (i <= i2) {
            if (matches(buffer, i)) {
                return i;
            }
            i++;
        }
        return -1;
    }

    public final boolean containsAt(Buffer buffer, int i) {
        if (this.length - i < buffer.length) {
            return false;
        }
        return matches(buffer, i);
    }

    private final boolean matches(Buffer buffer, int i) {
        byte[] bArr = this.data;
        int i2 = this.offset;
        int i3 = buffer.length;
        byte[] bArr2 = buffer.data;
        int i4 = buffer.offset;
        for (int i5 = 0; i5 < i3; i5++) {
            if (bArr[i2 + i + i5] != bArr2[i4 + i5]) {
                return false;
            }
        }
        return true;
    }

    public final Buffer trim() {
        return trimFront().trimEnd();
    }

    public final Buffer trimEnd() {
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length;
        int i3 = (i + i2) - 1;
        int i4 = i3;
        while (i <= i4 && bArr[i4] <= 32) {
            i4--;
        }
        return i4 == i3 ? this : new Buffer(bArr, i, i2 - (i3 - i4));
    }

    public final Buffer trimFront() {
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length + i;
        int i3 = i;
        while (i3 < i2 && bArr[i3] <= 32) {
            i3++;
        }
        return i3 == i ? this : new Buffer(bArr, i3, this.length - (i3 - i));
    }

    public final Buffer buffer() {
        return new Buffer(this);
    }

    public final AsciiBuffer ascii() {
        return new AsciiBuffer(this);
    }

    public final UTF8Buffer utf8() {
        return new UTF8Buffer(this);
    }

    public final Buffer[] split(byte b) {
        ArrayList arrayList = new ArrayList();
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length + i;
        int i3 = i;
        while (i < i2) {
            if (bArr[i] == b) {
                if (i3 < i) {
                    arrayList.add(new Buffer(bArr, i3, i - i3));
                }
                i3 = i + 1;
            }
            i++;
        }
        if (i3 < i) {
            arrayList.add(new Buffer(bArr, i3, i - i3));
        }
        return (Buffer[]) arrayList.toArray(new Buffer[arrayList.size()]);
    }

    public void reset() {
        this.offset = 0;
        this.length = this.data.length;
    }

    public int hashCode() {
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length;
        byte[] bArr2 = new byte[4];
        for (int i3 = 0; i3 < i2; i3++) {
            int i4 = i3 % 4;
            bArr2[i4] = (byte) (bArr2[i4] ^ bArr[i + i3]);
        }
        return (bArr2[0] << 24) | (bArr2[1] << 16) | (bArr2[2] << 8) | bArr2[3];
    }

    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj == null || obj.getClass() != Buffer.class) {
            return false;
        }
        return equals((Buffer) obj);
    }

    @Override
    public int compareTo(Buffer buffer) {
        if (this == buffer) {
            return 0;
        }
        byte[] bArr = this.data;
        int i = this.offset;
        int i2 = this.length;
        int i3 = buffer.length;
        int i4 = buffer.offset;
        byte[] bArr2 = buffer.data;
        int iMin = Math.min(i2, i3);
        if (i == i4) {
            int i5 = iMin + i;
            while (i < i5) {
                int i6 = bArr[i] & UByte.MAX_VALUE;
                int i7 = bArr2[i] & UByte.MAX_VALUE;
                if (i6 != i7) {
                    return i6 - i7;
                }
                i++;
            }
        } else {
            while (true) {
                int i8 = iMin - 1;
                if (iMin != 0) {
                    int i9 = i + 1;
                    int i10 = bArr[i] & UByte.MAX_VALUE;
                    int i11 = i4 + 1;
                    int i12 = bArr2[i4] & UByte.MAX_VALUE;
                    if (i10 != i12) {
                        return i10 - i12;
                    }
                    i = i9;
                    iMin = i8;
                    i4 = i11;
                }
            }
        }
        return i2 - i3;
    }

    public void writeTo(DataOutput dataOutput) throws IOException {
        dataOutput.write(this.data, this.offset, this.length);
    }

    public void writeTo(OutputStream outputStream) throws IOException {
        outputStream.write(this.data, this.offset, this.length);
    }

    public void readFrom(DataInput dataInput) throws IOException {
        dataInput.readFully(this.data, this.offset, this.length);
    }

    public int readFrom(InputStream inputStream) throws IOException {
        return inputStream.read(this.data, this.offset, this.length);
    }

    public static String string(Buffer buffer) {
        if (buffer == null) {
            return null;
        }
        return buffer.toString();
    }

    public static final Buffer join(List<Buffer> list, Buffer buffer) {
        if (list.isEmpty()) {
            return new Buffer(buffer.data, 0, 0);
        }
        Iterator<Buffer> it = list.iterator();
        int i = 0;
        while (it.hasNext()) {
            i += it.next().length;
        }
        int size = i + (buffer.length * (list.size() - 1));
        byte[] bArr = new byte[size];
        int i2 = 0;
        for (Buffer buffer2 : list) {
            if (i2 != 0) {
                System.arraycopy(buffer.data, buffer.offset, bArr, i2, buffer.length);
                i2 += buffer.length;
            }
            System.arraycopy(buffer2.data, buffer2.offset, bArr, i2, buffer2.length);
            i2 += buffer2.length;
        }
        return new Buffer(bArr, 0, size);
    }

    public ByteBuffer toByteBuffer() {
        return ByteBuffer.wrap(this.data, this.offset, this.length);
    }

    public static AsciiBuffer ascii(String str) {
        return AsciiBuffer.ascii(str);
    }

    public static AsciiBuffer ascii(Buffer buffer) {
        return AsciiBuffer.ascii(buffer);
    }

    public static UTF8Buffer utf8(String str) {
        return UTF8Buffer.utf8(str);
    }

    public static UTF8Buffer utf8(Buffer buffer) {
        return UTF8Buffer.utf8(buffer);
    }

    public String toString() {
        int i = this.length;
        for (int i2 = 0; i2 < i; i2++) {
            int i3 = this.data[this.offset + i2] & UByte.MAX_VALUE;
            if ((i3 > 126 || i3 < 32) && i3 != 10) {
                if (!((i3 == 10) | (i3 == 13) | (i3 == 27))) {
                    return "hex: " + HexSupport.toHexFromBuffer(this);
                }
            }
        }
        return "ascii: " + ascii();
    }
}
