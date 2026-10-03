package net.aihelp.core.net.mqtt.hawtbuf;

import java.io.DataInput;
import java.io.IOException;
import java.io.InputStream;
import java.io.UTFDataFormatException;
import kotlin.UByte;
import net.aihelp.data.model.rpa.msg.base.Message;
import okio.Utf8;

public final class DataByteArrayInputStream extends InputStream implements DataInput {
    private byte[] buf;
    protected AbstractVarIntSupport helper;
    private int length;
    private int offset;
    private int pos;

    public DataByteArrayInputStream(byte[] bArr) {
        this.helper = new AbstractVarIntSupport() {
            @Override
            protected byte readByte() throws IOException {
                return DataByteArrayInputStream.this.readByte();
            }

            @Override
            protected void writeByte(int i) throws IOException {
                throw new UnsupportedOperationException();
            }
        };
        restart(bArr);
    }

    public DataByteArrayInputStream(Buffer buffer) {
        this.helper = new AbstractVarIntSupport() {
            @Override
            protected byte readByte() throws IOException {
                return DataByteArrayInputStream.this.readByte();
            }

            @Override
            protected void writeByte(int i) throws IOException {
                throw new UnsupportedOperationException();
            }
        };
        restart(buffer);
    }

    public void restart(Buffer buffer) {
        this.buf = buffer.getData();
        int offset = buffer.getOffset();
        this.offset = offset;
        this.pos = offset;
        this.length = buffer.getLength();
    }

    public void restart(int i) {
        byte[] bArr = this.buf;
        if (bArr == null || bArr.length < i) {
            this.buf = new byte[i];
        }
        restart(this.buf);
        this.length = i;
    }

    public DataByteArrayInputStream() {
        this(new byte[0]);
    }

    public int size() {
        return this.pos - this.offset;
    }

    public byte[] getRawData() {
        return this.buf;
    }

    public Buffer readBuffer(int i) {
        int i2 = this.offset;
        int i3 = this.length;
        int i4 = i2 + i3;
        int i5 = this.pos;
        if (i5 > i4) {
            return null;
        }
        if (i5 + i > i4) {
            i = i3 - i5;
        }
        Buffer buffer = new Buffer(this.buf, this.pos, i);
        this.pos += i;
        return buffer;
    }

    public void restart(byte[] bArr) {
        this.buf = bArr;
        this.pos = 0;
        this.length = bArr.length;
    }

    public void restart() {
        this.pos = 0;
        this.length = this.buf.length;
    }

    @Override
    public int read() {
        int i = this.pos;
        if (i >= this.offset + this.length) {
            return -1;
        }
        byte[] bArr = this.buf;
        this.pos = i + 1;
        return bArr[i] & UByte.MAX_VALUE;
    }

    @Override
    public int read(byte[] bArr, int i, int i2) {
        bArr.getClass();
        int i3 = this.offset;
        int i4 = this.length;
        int i5 = i3 + i4;
        int i6 = this.pos;
        if (i6 >= i5) {
            return -1;
        }
        if (i6 + i2 > i5) {
            i2 = i4 - i6;
        }
        if (i2 <= 0) {
            return 0;
        }
        System.arraycopy(this.buf, i6, bArr, i, i2);
        this.pos += i2;
        return i2;
    }

    @Override
    public int available() {
        return (this.offset + this.length) - this.pos;
    }

    @Override
    public void readFully(byte[] bArr) {
        read(bArr, 0, bArr.length);
    }

    @Override
    public void readFully(byte[] bArr, int i, int i2) {
        read(bArr, i, i2);
    }

    public int skip(int i) {
        return skipBytes(i);
    }

    @Override
    public int skipBytes(int i) {
        int i2 = this.offset + this.length;
        int i3 = this.pos;
        if (i3 + i > i2) {
            i = i2 - i3;
        }
        if (i < 0) {
            return 0;
        }
        this.pos = i3 + i;
        return i;
    }

    @Override
    public boolean readBoolean() {
        return read() != 0;
    }

    @Override
    public byte readByte() {
        return (byte) read();
    }

    @Override
    public int readUnsignedByte() {
        return read();
    }

    @Override
    public short readShort() {
        return (short) ((read() << 8) + read());
    }

    @Override
    public int readUnsignedShort() {
        return (read() << 8) + read();
    }

    @Override
    public char readChar() {
        return (char) ((read() << 8) + read());
    }

    @Override
    public int readInt() {
        return (read() << 24) + (read() << 16) + (read() << 8) + read();
    }

    @Override
    public long readLong() {
        byte[] bArr = this.buf;
        int i = this.pos;
        int i2 = i + 1;
        this.pos = i2;
        long j = ((long) bArr[i]) << 56;
        int i3 = i + 2;
        this.pos = i3;
        long j2 = j + (((long) (bArr[i2] & UByte.MAX_VALUE)) << 48);
        int i4 = i + 3;
        this.pos = i4;
        long j3 = j2 + (((long) (bArr[i3] & UByte.MAX_VALUE)) << 40);
        int i5 = i + 4;
        this.pos = i5;
        long j4 = j3 + (((long) (bArr[i4] & UByte.MAX_VALUE)) << 32);
        int i6 = i + 5;
        this.pos = i6;
        long j5 = j4 + (((long) (bArr[i5] & UByte.MAX_VALUE)) << 24);
        int i7 = i + 6;
        this.pos = i7;
        long j6 = j5 + ((long) ((bArr[i6] & UByte.MAX_VALUE) << 16));
        int i8 = i + 7;
        this.pos = i8;
        long j7 = j6 + ((long) ((bArr[i7] & UByte.MAX_VALUE) << 8));
        this.pos = i + 8;
        return j7 + ((long) (bArr[i8] & UByte.MAX_VALUE));
    }

    @Override
    public float readFloat() throws IOException {
        return Float.intBitsToFloat(readInt());
    }

    @Override
    public double readDouble() throws IOException {
        return Double.longBitsToDouble(readLong());
    }

    @Override
    public String readLine() {
        int i;
        int i2 = this.pos;
        while (this.pos < this.offset + this.length && (i = read()) != 10) {
            if (i == 13) {
                int i3 = read();
                if (i3 != 10 && i3 != -1) {
                    this.pos--;
                    break;
                }
                break;
                break;
            }
        }
        return new String(this.buf, i2, this.pos);
    }

    @Override
    public String readUTF() throws IOException {
        int i;
        int i2;
        int unsignedShort = readUnsignedShort();
        char[] cArr = new char[unsignedShort];
        int i3 = this.pos + unsignedShort;
        int i4 = 0;
        while (true) {
            int i5 = this.pos;
            if (i5 >= i3 || (i2 = this.buf[i5] & UByte.MAX_VALUE) > 127) {
                break;
            }
            this.pos = i5 + 1;
            cArr[i4] = (char) i2;
            i4++;
        }
        while (true) {
            int i6 = this.pos;
            if (i6 < i3) {
                byte[] bArr = this.buf;
                byte b = bArr[i6];
                int i7 = b & UByte.MAX_VALUE;
                switch (i7 >> 4) {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                    case 7:
                        this.pos = i6 + 1;
                        cArr[i4] = (char) i7;
                        i4++;
                        break;
                    case 8:
                    case 9:
                    case 10:
                    case 11:
                    default:
                        throw new UTFDataFormatException("bad string");
                    case Message.TYPE_USER_VIDEO:
                    case 13:
                        int i8 = i6 + 2;
                        this.pos = i8;
                        if (i8 > i3) {
                            throw new UTFDataFormatException("bad string");
                        }
                        byte b2 = bArr[i6 + 1];
                        if ((b2 & 192) != 128) {
                            throw new UTFDataFormatException("bad string");
                        }
                        i = i4 + 1;
                        cArr[i4] = (char) ((b2 & Utf8.REPLACEMENT_BYTE) | ((b & 31) << 6));
                        break;
                        break;
                    case Message.TYPE_USER_FILE:
                        int i9 = i6 + 3;
                        this.pos = i9;
                        if (i9 > i3) {
                            throw new UTFDataFormatException("bad string");
                        }
                        byte b3 = bArr[i6 + 1];
                        byte b4 = bArr[i6 + 2];
                        if ((b3 & 192) != 128 || (b4 & 192) != 128) {
                            throw new UTFDataFormatException("bad string");
                        }
                        i = i4 + 1;
                        cArr[i4] = (char) ((b4 & Utf8.REPLACEMENT_BYTE) | ((b & 15) << 12) | ((b3 & Utf8.REPLACEMENT_BYTE) << 6));
                        break;
                        break;
                }
                i4 = i;
            } else {
                return new String(cArr, 0, i4);
            }
        }
    }

    public int getPos() {
        return this.pos;
    }

    public void setPos(int i) {
        this.pos = i;
    }

    public int getLength() {
        return this.length;
    }

    public void setLength(int i) {
        this.length = i;
    }

    public int readVarInt() throws IOException {
        return this.helper.readVarInt();
    }

    public long readVarLong() throws IOException {
        return this.helper.readVarLong();
    }

    public int readVarSignedInt() throws IOException {
        return this.helper.readVarSignedInt();
    }

    public long readVarSignedLong() throws IOException {
        return this.helper.readVarSignedLong();
    }
}
