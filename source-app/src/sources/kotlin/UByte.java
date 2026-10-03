package kotlin;

import kotlin.jvm.JvmInline;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.UIntRange;
import kotlin.ranges.URangesKt;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000n\n\u0002\u0018\u0002\n\u0002\u0010\u000f\n\u0000\n\u0002\u0010\u0005\n\u0002\b\t\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0002\u0010\u0000\n\u0002\b!\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0010\u0006\n\u0002\b\u0003\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\n\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u000e\b\u0087@\u0018\u0000 v2\b\u0012\u0004\u0012\u00020\u00000\u0001:\u0001vB\u0014\b\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000¢\u0006\u0004\b\u0004\u0010\u0005J\u001b\u0010\b\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\u0000H\u0087\fø\u0001\u0000¢\u0006\u0004\b\n\u0010\u000bJ\u001b\u0010\f\u001a\u00020\r2\u0006\u0010\t\u001a\u00020\u0000H\u0097\nø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ\u001b\u0010\f\u001a\u00020\r2\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u001b\u0010\f\u001a\u00020\r2\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u0014\u0010\u0015J\u001b\u0010\f\u001a\u00020\r2\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018J\u0016\u0010\u0019\u001a\u00020\u0000H\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u0005J\u001b\u0010\u001b\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u000fJ\u001b\u0010\u001b\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u001d\u0010\u0012J\u001b\u0010\u001b\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001fJ\u001b\u0010\u001b\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\b \u0010\u0018J\u001a\u0010!\u001a\u00020\"2\b\u0010\t\u001a\u0004\u0018\u00010#HÖ\u0003¢\u0006\u0004\b$\u0010%J\u001b\u0010&\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\bø\u0001\u0000¢\u0006\u0004\b'\u0010\u000fJ\u001b\u0010&\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\bø\u0001\u0000¢\u0006\u0004\b(\u0010\u0012J\u001b\u0010&\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\bø\u0001\u0000¢\u0006\u0004\b)\u0010\u001fJ\u001b\u0010&\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\bø\u0001\u0000¢\u0006\u0004\b*\u0010\u0018J\u0010\u0010+\u001a\u00020\rHÖ\u0001¢\u0006\u0004\b,\u0010-J\u0016\u0010.\u001a\u00020\u0000H\u0087\nø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b/\u0010\u0005J\u0016\u00100\u001a\u00020\u0000H\u0087\bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b1\u0010\u0005J\u001b\u00102\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b3\u0010\u000fJ\u001b\u00102\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\b4\u0010\u0012J\u001b\u00102\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\b5\u0010\u001fJ\u001b\u00102\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\b6\u0010\u0018J\u001b\u00107\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\u0000H\u0087\bø\u0001\u0000¢\u0006\u0004\b8\u0010\u000bJ\u001b\u00107\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\bø\u0001\u0000¢\u0006\u0004\b9\u0010\u0012J\u001b\u00107\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\bø\u0001\u0000¢\u0006\u0004\b:\u0010\u001fJ\u001b\u00107\u001a\u00020\u00162\u0006\u0010\t\u001a\u00020\u0016H\u0087\bø\u0001\u0000¢\u0006\u0004\b;\u0010<J\u001b\u0010=\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\u0000H\u0087\fø\u0001\u0000¢\u0006\u0004\b>\u0010\u000bJ\u001b\u0010?\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\b@\u0010\u000fJ\u001b\u0010?\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\bA\u0010\u0012J\u001b\u0010?\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\bB\u0010\u001fJ\u001b\u0010?\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\bC\u0010\u0018J\u001b\u0010D\u001a\u00020E2\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\bF\u0010GJ\u001b\u0010H\u001a\u00020E2\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\bI\u0010GJ\u001b\u0010J\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\bK\u0010\u000fJ\u001b\u0010J\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\bL\u0010\u0012J\u001b\u0010J\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\bM\u0010\u001fJ\u001b\u0010J\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\bN\u0010\u0018J\u001b\u0010O\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0000H\u0087\nø\u0001\u0000¢\u0006\u0004\bP\u0010\u000fJ\u001b\u0010O\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0010H\u0087\nø\u0001\u0000¢\u0006\u0004\bQ\u0010\u0012J\u001b\u0010O\u001a\u00020\u00132\u0006\u0010\t\u001a\u00020\u0013H\u0087\nø\u0001\u0000¢\u0006\u0004\bR\u0010\u001fJ\u001b\u0010O\u001a\u00020\u00102\u0006\u0010\t\u001a\u00020\u0016H\u0087\nø\u0001\u0000¢\u0006\u0004\bS\u0010\u0018J\u0010\u0010T\u001a\u00020\u0003H\u0087\b¢\u0006\u0004\bU\u0010\u0005J\u0010\u0010V\u001a\u00020WH\u0087\b¢\u0006\u0004\bX\u0010YJ\u0010\u0010Z\u001a\u00020[H\u0087\b¢\u0006\u0004\b\\\u0010]J\u0010\u0010^\u001a\u00020\rH\u0087\b¢\u0006\u0004\b_\u0010-J\u0010\u0010`\u001a\u00020aH\u0087\b¢\u0006\u0004\bb\u0010cJ\u0010\u0010d\u001a\u00020eH\u0087\b¢\u0006\u0004\bf\u0010gJ\u000f\u0010h\u001a\u00020iH\u0016¢\u0006\u0004\bj\u0010kJ\u0016\u0010l\u001a\u00020\u0000H\u0087\bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bm\u0010\u0005J\u0016\u0010n\u001a\u00020\u0010H\u0087\bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bo\u0010-J\u0016\u0010p\u001a\u00020\u0013H\u0087\bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bq\u0010cJ\u0016\u0010r\u001a\u00020\u0016H\u0087\bø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bs\u0010gJ\u001b\u0010t\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\u0000H\u0087\fø\u0001\u0000¢\u0006\u0004\bu\u0010\u000bR\u0016\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0006\u0010\u0007\u0088\u0001\u0002\u0092\u0001\u00020\u0003ø\u0001\u0000\u0082\u0002\b\n\u0002\b\u0019\n\u0002\b!¨\u0006w"}, m18d2 = {"Lkotlin/UByte;", "", Bayeux.KEY_DATA, "", "constructor-impl", "(B)B", "getData$annotations", "()V", "and", "other", "and-7apg3OU", "(BB)B", "compareTo", "", "compareTo-7apg3OU", "(BB)I", "Lkotlin/UInt;", "compareTo-WZ4Q5Ns", "(BI)I", "Lkotlin/ULong;", "compareTo-VKZWuLQ", "(BJ)I", "Lkotlin/UShort;", "compareTo-xj2QHRw", "(BS)I", "dec", "dec-w2LRezQ", "div", "div-7apg3OU", "div-WZ4Q5Ns", "div-VKZWuLQ", "(BJ)J", "div-xj2QHRw", "equals", "", "", "equals-impl", "(BLjava/lang/Object;)Z", "floorDiv", "floorDiv-7apg3OU", "floorDiv-WZ4Q5Ns", "floorDiv-VKZWuLQ", "floorDiv-xj2QHRw", "hashCode", "hashCode-impl", "(B)I", "inc", "inc-w2LRezQ", "inv", "inv-w2LRezQ", "minus", "minus-7apg3OU", "minus-WZ4Q5Ns", "minus-VKZWuLQ", "minus-xj2QHRw", "mod", "mod-7apg3OU", "mod-WZ4Q5Ns", "mod-VKZWuLQ", "mod-xj2QHRw", "(BS)S", "or", "or-7apg3OU", "plus", "plus-7apg3OU", "plus-WZ4Q5Ns", "plus-VKZWuLQ", "plus-xj2QHRw", "rangeTo", "Lkotlin/ranges/UIntRange;", "rangeTo-7apg3OU", "(BB)Lkotlin/ranges/UIntRange;", "rangeUntil", "rangeUntil-7apg3OU", "rem", "rem-7apg3OU", "rem-WZ4Q5Ns", "rem-VKZWuLQ", "rem-xj2QHRw", "times", "times-7apg3OU", "times-WZ4Q5Ns", "times-VKZWuLQ", "times-xj2QHRw", "toByte", "toByte-impl", "toDouble", "", "toDouble-impl", "(B)D", "toFloat", "", "toFloat-impl", "(B)F", "toInt", "toInt-impl", "toLong", "", "toLong-impl", "(B)J", "toShort", "", "toShort-impl", "(B)S", "toString", "", "toString-impl", "(B)Ljava/lang/String;", "toUByte", "toUByte-w2LRezQ", "toUInt", "toUInt-pVg5ArA", "toULong", "toULong-s-VKNKU", "toUShort", "toUShort-Mh2AYeg", "xor", "xor-7apg3OU", "Companion", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
@JvmInline
public final class UByte implements Comparable<UByte> {

    public static final Companion INSTANCE = new Companion(null);
    public static final byte MAX_VALUE = -1;
    public static final byte MIN_VALUE = 0;
    public static final int SIZE_BITS = 8;
    public static final int SIZE_BYTES = 1;
    private final byte data;

    public static final UByte m308boximpl(byte b) {
        return new UByte(b);
    }

    public static byte m314constructorimpl(byte b) {
        return b;
    }

    public static boolean m320equalsimpl(byte b, Object obj) {
        return (obj instanceof UByte) && b == ((UByte) obj).getData();
    }

    public static final boolean m321equalsimpl0(byte b, byte b2) {
        return b == b2;
    }

    public static void getData$annotations() {
    }

    public static int m326hashCodeimpl(byte b) {
        return b;
    }

    private static final byte m352toByteimpl(byte b) {
        return b;
    }

    private static final double m353toDoubleimpl(byte b) {
        return b & MAX_VALUE;
    }

    private static final float m354toFloatimpl(byte b) {
        return b & MAX_VALUE;
    }

    private static final int m355toIntimpl(byte b) {
        return b & MAX_VALUE;
    }

    private static final long m356toLongimpl(byte b) {
        return ((long) b) & 255;
    }

    private static final short m357toShortimpl(byte b) {
        return (short) (b & 255);
    }

    private static final byte m359toUBytew2LRezQ(byte b) {
        return b;
    }

    public boolean equals(Object obj) {
        return m320equalsimpl(this.data, obj);
    }

    public int hashCode() {
        return m326hashCodeimpl(this.data);
    }

    public final byte getData() {
        return this.data;
    }

    @Override
    public int compareTo(UByte uByte) {
        return Intrinsics.compare(getData() & MAX_VALUE, uByte.getData() & MAX_VALUE);
    }

    private UByte(byte b) {
        this.data = b;
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0016\u0010\u0003\u001a\u00020\u0004X\u0086Tø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0005R\u0016\u0010\u0006\u001a\u00020\u0004X\u0086Tø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u0005R\u000e\u0010\u0007\u001a\u00020\bX\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\t\u001a\u00020\bX\u0086T¢\u0006\u0002\n\u0000\u0082\u0002\b\n\u0002\b\u0019\n\u0002\b!¨\u0006\n"}, m18d2 = {"Lkotlin/UByte$Companion;", "", "()V", "MAX_VALUE", "Lkotlin/UByte;", "B", "MIN_VALUE", "SIZE_BITS", "", "SIZE_BYTES", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }

    private int m309compareTo7apg3OU(byte b) {
        return Intrinsics.compare(getData() & MAX_VALUE, b & MAX_VALUE);
    }

    private static int m310compareTo7apg3OU(byte b, byte b2) {
        return Intrinsics.compare(b & MAX_VALUE, b2 & MAX_VALUE);
    }

    private static final int m313compareToxj2QHRw(byte b, short s) {
        return Intrinsics.compare(b & MAX_VALUE, s & UShort.MAX_VALUE);
    }

    private static final int m312compareToWZ4Q5Ns(byte b, int i) {
        return Integer.compare(UInt.m391constructorimpl(b & MAX_VALUE) ^ Integer.MIN_VALUE, i ^ Integer.MIN_VALUE);
    }

    private static final int m311compareToVKZWuLQ(byte b, long j) {
        return Long.compare(ULong.m470constructorimpl(((long) b) & 255) ^ Long.MIN_VALUE, j ^ Long.MIN_VALUE);
    }

    private static final int m338plus7apg3OU(byte b, byte b2) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) + UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m341plusxj2QHRw(byte b, short s) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) + UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m340plusWZ4Q5Ns(byte b, int i) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) + i);
    }

    private static final long m339plusVKZWuLQ(byte b, long j) {
        return ULong.m470constructorimpl(ULong.m470constructorimpl(((long) b) & 255) + j);
    }

    private static final int m329minus7apg3OU(byte b, byte b2) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) - UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m332minusxj2QHRw(byte b, short s) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) - UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m331minusWZ4Q5Ns(byte b, int i) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) - i);
    }

    private static final long m330minusVKZWuLQ(byte b, long j) {
        return ULong.m470constructorimpl(ULong.m470constructorimpl(((long) b) & 255) - j);
    }

    private static final int m348times7apg3OU(byte b, byte b2) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) * UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m351timesxj2QHRw(byte b, short s) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) * UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m350timesWZ4Q5Ns(byte b, int i) {
        return UInt.m391constructorimpl(UInt.m391constructorimpl(b & MAX_VALUE) * i);
    }

    private static final long m349timesVKZWuLQ(byte b, long j) {
        return ULong.m470constructorimpl(ULong.m470constructorimpl(((long) b) & 255) * j);
    }

    private static final int m316div7apg3OU(byte b, byte b2) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m319divxj2QHRw(byte b, short s) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m318divWZ4Q5Ns(byte b, int i) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), i);
    }

    private static final long m317divVKZWuLQ(byte b, long j) {
        return UByte$$ExternalSyntheticBackport0.m$1(ULong.m470constructorimpl(((long) b) & 255), j);
    }

    private static final int m344rem7apg3OU(byte b, byte b2) {
        return UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m347remxj2QHRw(byte b, short s) {
        return UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m346remWZ4Q5Ns(byte b, int i) {
        return UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), i);
    }

    private static final long m345remVKZWuLQ(byte b, long j) {
        return UByte$$ExternalSyntheticBackport0.m31m(ULong.m470constructorimpl(((long) b) & 255), j);
    }

    private static final int m322floorDiv7apg3OU(byte b, byte b2) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final int m325floorDivxj2QHRw(byte b, short s) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(s & UShort.MAX_VALUE));
    }

    private static final int m324floorDivWZ4Q5Ns(byte b, int i) {
        return UByte$$ExternalSyntheticBackport0.m26m(UInt.m391constructorimpl(b & MAX_VALUE), i);
    }

    private static final long m323floorDivVKZWuLQ(byte b, long j) {
        return UByte$$ExternalSyntheticBackport0.m$1(ULong.m470constructorimpl(((long) b) & 255), j);
    }

    private static final byte m333mod7apg3OU(byte b, byte b2) {
        return m314constructorimpl((byte) UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE)));
    }

    private static final short m336modxj2QHRw(byte b, short s) {
        return UShort.m577constructorimpl((short) UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(s & UShort.MAX_VALUE)));
    }

    private static final int m335modWZ4Q5Ns(byte b, int i) {
        return UByte$$ExternalSyntheticBackport0.m$1(UInt.m391constructorimpl(b & MAX_VALUE), i);
    }

    private static final long m334modVKZWuLQ(byte b, long j) {
        return UByte$$ExternalSyntheticBackport0.m31m(ULong.m470constructorimpl(((long) b) & 255), j);
    }

    private static final byte m327incw2LRezQ(byte b) {
        return m314constructorimpl((byte) (b + 1));
    }

    private static final byte m315decw2LRezQ(byte b) {
        return m314constructorimpl((byte) (b - 1));
    }

    private static final UIntRange m342rangeTo7apg3OU(byte b, byte b2) {
        return new UIntRange(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE), null);
    }

    private static final UIntRange m343rangeUntil7apg3OU(byte b, byte b2) {
        return URangesKt.m1584untilJ1ME1BU(UInt.m391constructorimpl(b & MAX_VALUE), UInt.m391constructorimpl(b2 & MAX_VALUE));
    }

    private static final byte m307and7apg3OU(byte b, byte b2) {
        return m314constructorimpl((byte) (b & b2));
    }

    private static final byte m337or7apg3OU(byte b, byte b2) {
        return m314constructorimpl((byte) (b | b2));
    }

    private static final byte m363xor7apg3OU(byte b, byte b2) {
        return m314constructorimpl((byte) (b ^ b2));
    }

    private static final byte m328invw2LRezQ(byte b) {
        return m314constructorimpl((byte) (~b));
    }

    private static final short m362toUShortMh2AYeg(byte b) {
        return UShort.m577constructorimpl((short) (b & 255));
    }

    private static final int m360toUIntpVg5ArA(byte b) {
        return UInt.m391constructorimpl(b & MAX_VALUE);
    }

    private static final long m361toULongsVKNKU(byte b) {
        return ULong.m470constructorimpl(((long) b) & 255);
    }

    public static String m358toStringimpl(byte b) {
        return String.valueOf(b & MAX_VALUE);
    }

    public String toString() {
        return m358toStringimpl(this.data);
    }
}
