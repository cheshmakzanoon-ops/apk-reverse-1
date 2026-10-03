package com.google.common.hash;

import com.google.common.base.Preconditions;
import com.google.errorprone.annotations.Immutable;
import java.io.Serializable;
import java.nio.ByteBuffer;
import javax.annotation.CheckForNull;

@Immutable
@ElementTypesAreNonnullByDefault
final class SipHashFunction extends AbstractHashFunction implements Serializable {
    static final HashFunction SIP_HASH_24 = new SipHashFunction(2, 4, 506097522914230528L, 1084818905618843912L);
    private static final long serialVersionUID = 0;

    private final int f136c;

    private final int f137d;

    private final long f138k0;

    private final long f139k1;

    @Override
    public int bits() {
        return 64;
    }

    SipHashFunction(int i, int i2, long j, long j2) {
        Preconditions.checkArgument(i > 0, "The number of SipRound iterations (c=%s) during Compression must be positive.", i);
        Preconditions.checkArgument(i2 > 0, "The number of SipRound iterations (d=%s) during Finalization must be positive.", i2);
        this.f136c = i;
        this.f137d = i2;
        this.f138k0 = j;
        this.f139k1 = j2;
    }

    @Override
    public Hasher newHasher() {
        return new SipHasher(this.f136c, this.f137d, this.f138k0, this.f139k1);
    }

    public String toString() {
        int i = this.f136c;
        int i2 = this.f137d;
        long j = this.f138k0;
        long j2 = this.f139k1;
        StringBuilder sb = new StringBuilder(81);
        sb.append("Hashing.sipHash");
        sb.append(i);
        sb.append(i2);
        sb.append("(");
        sb.append(j);
        sb.append(", ");
        sb.append(j2);
        sb.append(")");
        return sb.toString();
    }

    public boolean equals(@CheckForNull Object obj) {
        if (!(obj instanceof SipHashFunction)) {
            return false;
        }
        SipHashFunction sipHashFunction = (SipHashFunction) obj;
        return this.f136c == sipHashFunction.f136c && this.f137d == sipHashFunction.f137d && this.f138k0 == sipHashFunction.f138k0 && this.f139k1 == sipHashFunction.f139k1;
    }

    public int hashCode() {
        return (int) ((((long) ((getClass().hashCode() ^ this.f136c) ^ this.f137d)) ^ this.f138k0) ^ this.f139k1);
    }

    private static final class SipHasher extends AbstractStreamingHasher {
        private static final int CHUNK_SIZE = 8;

        private long f140b;

        private final int f141c;

        private final int f142d;
        private long finalM;

        private long f143v0;

        private long f144v1;

        private long f145v2;

        private long f146v3;

        SipHasher(int i, int i2, long j, long j2) {
            super(8);
            this.f140b = 0L;
            this.finalM = 0L;
            this.f141c = i;
            this.f142d = i2;
            this.f143v0 = 8317987319222330741L ^ j;
            this.f144v1 = 7237128888997146477L ^ j2;
            this.f145v2 = 7816392313619706465L ^ j;
            this.f146v3 = 8387220255154660723L ^ j2;
        }

        @Override
        protected void process(ByteBuffer byteBuffer) {
            this.f140b += 8;
            processM(byteBuffer.getLong());
        }

        @Override
        protected void processRemaining(ByteBuffer byteBuffer) {
            this.f140b += (long) byteBuffer.remaining();
            int i = 0;
            while (byteBuffer.hasRemaining()) {
                this.finalM ^= (((long) byteBuffer.get()) & 255) << i;
                i += 8;
            }
        }

        @Override
        protected HashCode makeHash() {
            long j = this.finalM ^ (this.f140b << 56);
            this.finalM = j;
            processM(j);
            this.f145v2 ^= 255;
            sipRound(this.f142d);
            return HashCode.fromLong(((this.f143v0 ^ this.f144v1) ^ this.f145v2) ^ this.f146v3);
        }

        private void processM(long j) {
            this.f146v3 ^= j;
            sipRound(this.f141c);
            this.f143v0 = j ^ this.f143v0;
        }

        private void sipRound(int i) {
            for (int i2 = 0; i2 < i; i2++) {
                long j = this.f143v0;
                long j2 = this.f144v1;
                this.f143v0 = j + j2;
                this.f145v2 += this.f146v3;
                this.f144v1 = Long.rotateLeft(j2, 13);
                long jRotateLeft = Long.rotateLeft(this.f146v3, 16);
                long j3 = this.f144v1;
                long j4 = this.f143v0;
                this.f144v1 = j3 ^ j4;
                this.f146v3 = jRotateLeft ^ this.f145v2;
                long jRotateLeft2 = Long.rotateLeft(j4, 32);
                long j5 = this.f145v2;
                long j6 = this.f144v1;
                this.f145v2 = j5 + j6;
                this.f143v0 = jRotateLeft2 + this.f146v3;
                this.f144v1 = Long.rotateLeft(j6, 17);
                long jRotateLeft3 = Long.rotateLeft(this.f146v3, 21);
                long j7 = this.f144v1;
                long j8 = this.f145v2;
                this.f144v1 = j7 ^ j8;
                this.f146v3 = jRotateLeft3 ^ this.f143v0;
                this.f145v2 = Long.rotateLeft(j8, 32);
            }
        }
    }
}
