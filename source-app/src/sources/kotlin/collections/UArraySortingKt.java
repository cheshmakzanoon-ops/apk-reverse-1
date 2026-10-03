package kotlin.collections;

import kotlin.Metadata;
import kotlin.UByte;
import kotlin.UByteArray;
import kotlin.UIntArray;
import kotlin.ULongArray;
import kotlin.UShort;
import kotlin.UShortArray;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u00000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0010\u001a*\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0006\u0010\u0007\u001a*\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\b2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\t\u0010\n\u001a*\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u000b2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\f\u0010\r\u001a*\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u000e2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010\u001a*\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014\u001a*\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\b2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0015\u0010\u0016\u001a*\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u000b2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018\u001a*\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u000e2\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u0001H\u0003ø\u0001\u0000¢\u0006\u0004\b\u0019\u0010\u001a\u001a*\u0010\u001b\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u001c\u001a\u00020\u00012\u0006\u0010\u001d\u001a\u00020\u0001H\u0001ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u0014\u001a*\u0010\u001b\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\b2\u0006\u0010\u001c\u001a\u00020\u00012\u0006\u0010\u001d\u001a\u00020\u0001H\u0001ø\u0001\u0000¢\u0006\u0004\b\u001f\u0010\u0016\u001a*\u0010\u001b\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u000b2\u0006\u0010\u001c\u001a\u00020\u00012\u0006\u0010\u001d\u001a\u00020\u0001H\u0001ø\u0001\u0000¢\u0006\u0004\b \u0010\u0018\u001a*\u0010\u001b\u001a\u00020\u00122\u0006\u0010\u0002\u001a\u00020\u000e2\u0006\u0010\u001c\u001a\u00020\u00012\u0006\u0010\u001d\u001a\u00020\u0001H\u0001ø\u0001\u0000¢\u0006\u0004\b!\u0010\u001a\u0082\u0002\u0004\n\u0002\b\u0019¨\u0006\""}, m18d2 = {"partition", "", "array", "Lkotlin/UByteArray;", "left", "right", "partition-4UcCI2c", "([BII)I", "Lkotlin/UIntArray;", "partition-oBK06Vg", "([III)I", "Lkotlin/ULongArray;", "partition--nroSd4", "([JII)I", "Lkotlin/UShortArray;", "partition-Aa5vz7o", "([SII)I", "quickSort", "", "quickSort-4UcCI2c", "([BII)V", "quickSort-oBK06Vg", "([III)V", "quickSort--nroSd4", "([JII)V", "quickSort-Aa5vz7o", "([SII)V", "sortArray", "fromIndex", "toIndex", "sortArray-4UcCI2c", "sortArray-oBK06Vg", "sortArray--nroSd4", "sortArray-Aa5vz7o", "kotlin-stdlib"}, m19k = 2, m20mv = {1, 8, 0}, m22xi = 48)
public final class UArraySortingKt {
    private static final int m752partition4UcCI2c(byte[] bArr, int i, int i2) {
        int i3;
        byte bM372getw2LRezQ = UByteArray.m372getw2LRezQ(bArr, (i + i2) / 2);
        while (i <= i2) {
            while (true) {
                int iM372getw2LRezQ = UByteArray.m372getw2LRezQ(bArr, i) & UByte.MAX_VALUE;
                i3 = bM372getw2LRezQ & UByte.MAX_VALUE;
                if (Intrinsics.compare(iM372getw2LRezQ, i3) >= 0) {
                    break;
                }
                i++;
            }
            while (Intrinsics.compare(UByteArray.m372getw2LRezQ(bArr, i2) & UByte.MAX_VALUE, i3) > 0) {
                i2--;
            }
            if (i <= i2) {
                byte bM372getw2LRezQ2 = UByteArray.m372getw2LRezQ(bArr, i);
                UByteArray.m377setVurrAj0(bArr, i, UByteArray.m372getw2LRezQ(bArr, i2));
                UByteArray.m377setVurrAj0(bArr, i2, bM372getw2LRezQ2);
                i++;
                i2--;
            }
        }
        return i;
    }

    private static final void m756quickSort4UcCI2c(byte[] bArr, int i, int i2) {
        int iM752partition4UcCI2c = m752partition4UcCI2c(bArr, i, i2);
        int i3 = iM752partition4UcCI2c - 1;
        if (i < i3) {
            m756quickSort4UcCI2c(bArr, i, i3);
        }
        if (iM752partition4UcCI2c < i2) {
            m756quickSort4UcCI2c(bArr, iM752partition4UcCI2c, i2);
        }
    }

    private static final int m753partitionAa5vz7o(short[] sArr, int i, int i2) {
        int i3;
        short sM635getMh2AYeg = UShortArray.m635getMh2AYeg(sArr, (i + i2) / 2);
        while (i <= i2) {
            while (true) {
                int iM635getMh2AYeg = UShortArray.m635getMh2AYeg(sArr, i) & UShort.MAX_VALUE;
                i3 = sM635getMh2AYeg & UShort.MAX_VALUE;
                if (Intrinsics.compare(iM635getMh2AYeg, i3) >= 0) {
                    break;
                }
                i++;
            }
            while (Intrinsics.compare(UShortArray.m635getMh2AYeg(sArr, i2) & UShort.MAX_VALUE, i3) > 0) {
                i2--;
            }
            if (i <= i2) {
                short sM635getMh2AYeg2 = UShortArray.m635getMh2AYeg(sArr, i);
                UShortArray.m640set01HTLdE(sArr, i, UShortArray.m635getMh2AYeg(sArr, i2));
                UShortArray.m640set01HTLdE(sArr, i2, sM635getMh2AYeg2);
                i++;
                i2--;
            }
        }
        return i;
    }

    private static final void m757quickSortAa5vz7o(short[] sArr, int i, int i2) {
        int iM753partitionAa5vz7o = m753partitionAa5vz7o(sArr, i, i2);
        int i3 = iM753partitionAa5vz7o - 1;
        if (i < i3) {
            m757quickSortAa5vz7o(sArr, i, i3);
        }
        if (iM753partitionAa5vz7o < i2) {
            m757quickSortAa5vz7o(sArr, iM753partitionAa5vz7o, i2);
        }
    }

    private static final int m754partitionoBK06Vg(int[] iArr, int i, int i2) {
        int iM451getpVg5ArA = UIntArray.m451getpVg5ArA(iArr, (i + i2) / 2);
        while (i <= i2) {
            while (Integer.compare(UIntArray.m451getpVg5ArA(iArr, i) ^ Integer.MIN_VALUE, iM451getpVg5ArA ^ Integer.MIN_VALUE) < 0) {
                i++;
            }
            while (Integer.compare(UIntArray.m451getpVg5ArA(iArr, i2) ^ Integer.MIN_VALUE, iM451getpVg5ArA ^ Integer.MIN_VALUE) > 0) {
                i2--;
            }
            if (i <= i2) {
                int iM451getpVg5ArA2 = UIntArray.m451getpVg5ArA(iArr, i);
                UIntArray.m456setVXSXFK8(iArr, i, UIntArray.m451getpVg5ArA(iArr, i2));
                UIntArray.m456setVXSXFK8(iArr, i2, iM451getpVg5ArA2);
                i++;
                i2--;
            }
        }
        return i;
    }

    private static final void m758quickSortoBK06Vg(int[] iArr, int i, int i2) {
        int iM754partitionoBK06Vg = m754partitionoBK06Vg(iArr, i, i2);
        int i3 = iM754partitionoBK06Vg - 1;
        if (i < i3) {
            m758quickSortoBK06Vg(iArr, i, i3);
        }
        if (iM754partitionoBK06Vg < i2) {
            m758quickSortoBK06Vg(iArr, iM754partitionoBK06Vg, i2);
        }
    }

    private static final int m751partitionnroSd4(long[] jArr, int i, int i2) {
        long jM530getsVKNKU = ULongArray.m530getsVKNKU(jArr, (i + i2) / 2);
        while (i <= i2) {
            while (Long.compare(ULongArray.m530getsVKNKU(jArr, i) ^ Long.MIN_VALUE, jM530getsVKNKU ^ Long.MIN_VALUE) < 0) {
                i++;
            }
            while (Long.compare(ULongArray.m530getsVKNKU(jArr, i2) ^ Long.MIN_VALUE, jM530getsVKNKU ^ Long.MIN_VALUE) > 0) {
                i2--;
            }
            if (i <= i2) {
                long jM530getsVKNKU2 = ULongArray.m530getsVKNKU(jArr, i);
                ULongArray.m535setk8EXiF4(jArr, i, ULongArray.m530getsVKNKU(jArr, i2));
                ULongArray.m535setk8EXiF4(jArr, i2, jM530getsVKNKU2);
                i++;
                i2--;
            }
        }
        return i;
    }

    private static final void m755quickSortnroSd4(long[] jArr, int i, int i2) {
        int iM751partitionnroSd4 = m751partitionnroSd4(jArr, i, i2);
        int i3 = iM751partitionnroSd4 - 1;
        if (i < i3) {
            m755quickSortnroSd4(jArr, i, i3);
        }
        if (iM751partitionnroSd4 < i2) {
            m755quickSortnroSd4(jArr, iM751partitionnroSd4, i2);
        }
    }

    public static final void m760sortArray4UcCI2c(byte[] array, int i, int i2) {
        Intrinsics.checkNotNullParameter(array, "array");
        m756quickSort4UcCI2c(array, i, i2 - 1);
    }

    public static final void m761sortArrayAa5vz7o(short[] array, int i, int i2) {
        Intrinsics.checkNotNullParameter(array, "array");
        m757quickSortAa5vz7o(array, i, i2 - 1);
    }

    public static final void m762sortArrayoBK06Vg(int[] array, int i, int i2) {
        Intrinsics.checkNotNullParameter(array, "array");
        m758quickSortoBK06Vg(array, i, i2 - 1);
    }

    public static final void m759sortArraynroSd4(long[] array, int i, int i2) {
        Intrinsics.checkNotNullParameter(array, "array");
        m755quickSortnroSd4(array, i, i2 - 1);
    }
}
