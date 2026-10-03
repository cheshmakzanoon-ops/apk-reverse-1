package com.google.common.base;

import java.util.Arrays;
import java.util.BitSet;

@ElementTypesAreNonnullByDefault
public abstract class CharMatcher implements Predicate<Character> {
    private static final int DISTINCT_CHARS = 65536;

    private static boolean isSmall(int i, int i2) {
        return i <= 1023 && i2 > i * 64;
    }

    public abstract boolean matches(char c);

    public static CharMatcher any() {
        return Any.INSTANCE;
    }

    public static CharMatcher none() {
        return None.INSTANCE;
    }

    public static CharMatcher whitespace() {
        return Whitespace.INSTANCE;
    }

    public static CharMatcher breakingWhitespace() {
        return BreakingWhitespace.INSTANCE;
    }

    public static CharMatcher ascii() {
        return Ascii.INSTANCE;
    }

    @Deprecated
    public static CharMatcher digit() {
        return Digit.INSTANCE;
    }

    @Deprecated
    public static CharMatcher javaDigit() {
        return JavaDigit.INSTANCE;
    }

    @Deprecated
    public static CharMatcher javaLetter() {
        return JavaLetter.INSTANCE;
    }

    @Deprecated
    public static CharMatcher javaLetterOrDigit() {
        return JavaLetterOrDigit.INSTANCE;
    }

    @Deprecated
    public static CharMatcher javaUpperCase() {
        return JavaUpperCase.INSTANCE;
    }

    @Deprecated
    public static CharMatcher javaLowerCase() {
        return JavaLowerCase.INSTANCE;
    }

    public static CharMatcher javaIsoControl() {
        return JavaIsoControl.INSTANCE;
    }

    @Deprecated
    public static CharMatcher invisible() {
        return Invisible.INSTANCE;
    }

    @Deprecated
    public static CharMatcher singleWidth() {
        return SingleWidth.INSTANCE;
    }

    public static CharMatcher m129is(char c) {
        return new C0345Is(c);
    }

    public static CharMatcher isNot(char c) {
        return new IsNot(c);
    }

    public static CharMatcher anyOf(CharSequence charSequence) {
        int length = charSequence.length();
        if (length == 0) {
            return none();
        }
        if (length == 1) {
            return m129is(charSequence.charAt(0));
        }
        if (length == 2) {
            return isEither(charSequence.charAt(0), charSequence.charAt(1));
        }
        return new AnyOf(charSequence);
    }

    public static CharMatcher noneOf(CharSequence charSequence) {
        return anyOf(charSequence).negate();
    }

    public static CharMatcher inRange(char c, char c2) {
        return new InRange(c, c2);
    }

    public static CharMatcher forPredicate(Predicate<? super Character> predicate) {
        return predicate instanceof CharMatcher ? (CharMatcher) predicate : new ForPredicate(predicate);
    }

    protected CharMatcher() {
    }

    public CharMatcher negate() {
        return new Negated(this);
    }

    public CharMatcher and(CharMatcher charMatcher) {
        return new And(this, charMatcher);
    }

    public CharMatcher mo130or(CharMatcher charMatcher) {
        return new C0346Or(this, charMatcher);
    }

    public CharMatcher precomputed() {
        return Platform.precomputeCharMatcher(this);
    }

    CharMatcher precomputedInternal() {
        String strConcat;
        BitSet bitSet = new BitSet();
        setBits(bitSet);
        int iCardinality = bitSet.cardinality();
        if (iCardinality * 2 <= DISTINCT_CHARS) {
            return precomputedPositive(iCardinality, bitSet, toString());
        }
        bitSet.flip(0, DISTINCT_CHARS);
        int i = DISTINCT_CHARS - iCardinality;
        final String string = toString();
        if (!string.endsWith(".negate()")) {
            strConcat = String.valueOf(string).concat(".negate()");
        } else {
            strConcat = string.substring(0, string.length() - 9);
        }
        return new NegatedFastMatcher(this, precomputedPositive(i, bitSet, strConcat)) {
            @Override
            public String toString() {
                return string;
            }
        };
    }

    private static CharMatcher precomputedPositive(int i, BitSet bitSet, String str) {
        if (i == 0) {
            return none();
        }
        if (i == 1) {
            return m129is((char) bitSet.nextSetBit(0));
        }
        if (i == 2) {
            char cNextSetBit = (char) bitSet.nextSetBit(0);
            return isEither(cNextSetBit, (char) bitSet.nextSetBit(cNextSetBit + 1));
        }
        if (isSmall(i, bitSet.length())) {
            return SmallCharMatcher.from(bitSet, str);
        }
        return new BitSetMatcher(bitSet, str);
    }

    void setBits(BitSet bitSet) {
        for (int i = 65535; i >= 0; i--) {
            if (matches((char) i)) {
                bitSet.set(i);
            }
        }
    }

    public boolean matchesAnyOf(CharSequence charSequence) {
        return !matchesNoneOf(charSequence);
    }

    public boolean matchesAllOf(CharSequence charSequence) {
        for (int length = charSequence.length() - 1; length >= 0; length--) {
            if (!matches(charSequence.charAt(length))) {
                return false;
            }
        }
        return true;
    }

    public boolean matchesNoneOf(CharSequence charSequence) {
        return indexIn(charSequence) == -1;
    }

    public int indexIn(CharSequence charSequence) {
        return indexIn(charSequence, 0);
    }

    public int indexIn(CharSequence charSequence, int i) {
        int length = charSequence.length();
        Preconditions.checkPositionIndex(i, length);
        while (i < length) {
            if (matches(charSequence.charAt(i))) {
                return i;
            }
            i++;
        }
        return -1;
    }

    public int lastIndexIn(CharSequence charSequence) {
        for (int length = charSequence.length() - 1; length >= 0; length--) {
            if (matches(charSequence.charAt(length))) {
                return length;
            }
        }
        return -1;
    }

    public int countIn(CharSequence charSequence) {
        int i = 0;
        for (int i2 = 0; i2 < charSequence.length(); i2++) {
            if (matches(charSequence.charAt(i2))) {
                i++;
            }
        }
        return i;
    }

    public String removeFrom(CharSequence charSequence) {
        String string = charSequence.toString();
        int iIndexIn = indexIn(string);
        if (iIndexIn == -1) {
            return string;
        }
        char[] charArray = string.toCharArray();
        int i = 1;
        while (true) {
            iIndexIn++;
            while (iIndexIn != charArray.length) {
                if (matches(charArray[iIndexIn])) {
                    i++;
                } else {
                    charArray[iIndexIn - i] = charArray[iIndexIn];
                    iIndexIn++;
                }
            }
            return new String(charArray, 0, iIndexIn - i);
        }
    }

    public String retainFrom(CharSequence charSequence) {
        return negate().removeFrom(charSequence);
    }

    public String replaceFrom(CharSequence charSequence, char c) {
        String string = charSequence.toString();
        int iIndexIn = indexIn(string);
        if (iIndexIn == -1) {
            return string;
        }
        char[] charArray = string.toCharArray();
        charArray[iIndexIn] = c;
        while (true) {
            iIndexIn++;
            if (iIndexIn < charArray.length) {
                if (matches(charArray[iIndexIn])) {
                    charArray[iIndexIn] = c;
                }
            } else {
                return new String(charArray);
            }
        }
    }

    public String replaceFrom(CharSequence charSequence, CharSequence charSequence2) {
        int length = charSequence2.length();
        if (length == 0) {
            return removeFrom(charSequence);
        }
        int i = 0;
        if (length == 1) {
            return replaceFrom(charSequence, charSequence2.charAt(0));
        }
        String string = charSequence.toString();
        int iIndexIn = indexIn(string);
        if (iIndexIn == -1) {
            return string;
        }
        int length2 = string.length();
        StringBuilder sb = new StringBuilder(((length2 * 3) / 2) + 16);
        do {
            sb.append((CharSequence) string, i, iIndexIn);
            sb.append(charSequence2);
            i = iIndexIn + 1;
            iIndexIn = indexIn(string, i);
        } while (iIndexIn != -1);
        sb.append((CharSequence) string, i, length2);
        return sb.toString();
    }

    public String trimFrom(CharSequence charSequence) {
        int length = charSequence.length();
        int i = 0;
        while (i < length && matches(charSequence.charAt(i))) {
            i++;
        }
        int i2 = length - 1;
        while (i2 > i && matches(charSequence.charAt(i2))) {
            i2--;
        }
        return charSequence.subSequence(i, i2 + 1).toString();
    }

    public String trimLeadingFrom(CharSequence charSequence) {
        int length = charSequence.length();
        for (int i = 0; i < length; i++) {
            if (!matches(charSequence.charAt(i))) {
                return charSequence.subSequence(i, length).toString();
            }
        }
        return "";
    }

    public String trimTrailingFrom(CharSequence charSequence) {
        for (int length = charSequence.length() - 1; length >= 0; length--) {
            if (!matches(charSequence.charAt(length))) {
                return charSequence.subSequence(0, length + 1).toString();
            }
        }
        return "";
    }

    public String collapseFrom(CharSequence charSequence, char c) {
        int length = charSequence.length();
        int i = 0;
        while (i < length) {
            char cCharAt = charSequence.charAt(i);
            if (matches(cCharAt)) {
                if (cCharAt != c || (i != length - 1 && matches(charSequence.charAt(i + 1)))) {
                    StringBuilder sb = new StringBuilder(length);
                    sb.append(charSequence, 0, i);
                    sb.append(c);
                    return finishCollapseFrom(charSequence, i + 1, length, c, sb, true);
                }
                i++;
            }
            i++;
        }
        return charSequence.toString();
    }

    public String trimAndCollapseFrom(CharSequence charSequence, char c) {
        int length = charSequence.length();
        int i = length - 1;
        int i2 = 0;
        while (i2 < length && matches(charSequence.charAt(i2))) {
            i2++;
        }
        int i3 = i;
        while (i3 > i2 && matches(charSequence.charAt(i3))) {
            i3--;
        }
        if (i2 == 0 && i3 == i) {
            return collapseFrom(charSequence, c);
        }
        int i4 = i3 + 1;
        return finishCollapseFrom(charSequence, i2, i4, c, new StringBuilder(i4 - i2), false);
    }

    private String finishCollapseFrom(CharSequence charSequence, int i, int i2, char c, StringBuilder sb, boolean z) {
        while (i < i2) {
            char cCharAt = charSequence.charAt(i);
            if (!matches(cCharAt)) {
                sb.append(cCharAt);
                z = false;
            } else if (!z) {
                sb.append(c);
                z = true;
            }
            i++;
        }
        return sb.toString();
    }

    @Override
    @Deprecated
    public boolean apply(Character ch) {
        return matches(ch.charValue());
    }

    public String toString() {
        return super.toString();
    }

    public static String showCharacter(char c) {
        char[] cArr = new char[6];
        cArr[0] = '\\';
        cArr[1] = 'u';
        cArr[2] = 0;
        cArr[3] = 0;
        cArr[4] = 0;
        cArr[5] = 0;
        for (int i = 0; i < 4; i++) {
            cArr[5 - i] = "0123456789ABCDEF".charAt(c & 15);
            c = (char) (c >> 4);
        }
        return String.copyValueOf(cArr);
    }

    static abstract class FastMatcher extends CharMatcher {
        @Override
        public final CharMatcher precomputed() {
            return this;
        }

        FastMatcher() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public CharMatcher negate() {
            return new NegatedFastMatcher(this);
        }
    }

    static abstract class NamedFastMatcher extends FastMatcher {
        private final String description;

        NamedFastMatcher(String str) {
            this.description = (String) Preconditions.checkNotNull(str);
        }

        @Override
        public final String toString() {
            return this.description;
        }
    }

    static class NegatedFastMatcher extends Negated {
        @Override
        public final CharMatcher precomputed() {
            return this;
        }

        NegatedFastMatcher(CharMatcher charMatcher) {
            super(charMatcher);
        }
    }

    private static final class BitSetMatcher extends NamedFastMatcher {
        private final BitSet table;

        private BitSetMatcher(BitSet bitSet, String str) {
            super(str);
            this.table = bitSet.length() + 64 < bitSet.size() ? (BitSet) bitSet.clone() : bitSet;
        }

        @Override
        public boolean matches(char c) {
            return this.table.get(c);
        }

        @Override
        void setBits(BitSet bitSet) {
            bitSet.or(this.table);
        }
    }

    private static final class Any extends NamedFastMatcher {
        static final Any INSTANCE = new Any();

        @Override
        public boolean matches(char c) {
            return true;
        }

        private Any() {
            super("CharMatcher.any()");
        }

        @Override
        public int indexIn(CharSequence charSequence) {
            return charSequence.length() == 0 ? -1 : 0;
        }

        @Override
        public int indexIn(CharSequence charSequence, int i) {
            int length = charSequence.length();
            Preconditions.checkPositionIndex(i, length);
            if (i == length) {
                return -1;
            }
            return i;
        }

        @Override
        public int lastIndexIn(CharSequence charSequence) {
            return charSequence.length() - 1;
        }

        @Override
        public boolean matchesAllOf(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return true;
        }

        @Override
        public boolean matchesNoneOf(CharSequence charSequence) {
            return charSequence.length() == 0;
        }

        @Override
        public String removeFrom(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return "";
        }

        @Override
        public String replaceFrom(CharSequence charSequence, char c) {
            char[] cArr = new char[charSequence.length()];
            Arrays.fill(cArr, c);
            return new String(cArr);
        }

        @Override
        public String replaceFrom(CharSequence charSequence, CharSequence charSequence2) {
            StringBuilder sb = new StringBuilder(charSequence.length() * charSequence2.length());
            for (int i = 0; i < charSequence.length(); i++) {
                sb.append(charSequence2);
            }
            return sb.toString();
        }

        @Override
        public String collapseFrom(CharSequence charSequence, char c) {
            return charSequence.length() == 0 ? "" : String.valueOf(c);
        }

        @Override
        public String trimFrom(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return "";
        }

        @Override
        public int countIn(CharSequence charSequence) {
            return charSequence.length();
        }

        @Override
        public CharMatcher and(CharMatcher charMatcher) {
            return (CharMatcher) Preconditions.checkNotNull(charMatcher);
        }

        @Override
        public CharMatcher mo130or(CharMatcher charMatcher) {
            Preconditions.checkNotNull(charMatcher);
            return this;
        }

        @Override
        public CharMatcher negate() {
            return none();
        }
    }

    private static final class None extends NamedFastMatcher {
        static final None INSTANCE = new None();

        @Override
        public boolean matches(char c) {
            return false;
        }

        private None() {
            super("CharMatcher.none()");
        }

        @Override
        public int indexIn(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return -1;
        }

        @Override
        public int indexIn(CharSequence charSequence, int i) {
            Preconditions.checkPositionIndex(i, charSequence.length());
            return -1;
        }

        @Override
        public int lastIndexIn(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return -1;
        }

        @Override
        public boolean matchesAllOf(CharSequence charSequence) {
            return charSequence.length() == 0;
        }

        @Override
        public boolean matchesNoneOf(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return true;
        }

        @Override
        public String removeFrom(CharSequence charSequence) {
            return charSequence.toString();
        }

        @Override
        public String replaceFrom(CharSequence charSequence, char c) {
            return charSequence.toString();
        }

        @Override
        public String replaceFrom(CharSequence charSequence, CharSequence charSequence2) {
            Preconditions.checkNotNull(charSequence2);
            return charSequence.toString();
        }

        @Override
        public String collapseFrom(CharSequence charSequence, char c) {
            return charSequence.toString();
        }

        @Override
        public String trimFrom(CharSequence charSequence) {
            return charSequence.toString();
        }

        @Override
        public String trimLeadingFrom(CharSequence charSequence) {
            return charSequence.toString();
        }

        @Override
        public String trimTrailingFrom(CharSequence charSequence) {
            return charSequence.toString();
        }

        @Override
        public int countIn(CharSequence charSequence) {
            Preconditions.checkNotNull(charSequence);
            return 0;
        }

        @Override
        public CharMatcher and(CharMatcher charMatcher) {
            Preconditions.checkNotNull(charMatcher);
            return this;
        }

        @Override
        public CharMatcher mo130or(CharMatcher charMatcher) {
            return (CharMatcher) Preconditions.checkNotNull(charMatcher);
        }

        @Override
        public CharMatcher negate() {
            return any();
        }
    }

    static final class Whitespace extends NamedFastMatcher {
        static final int MULTIPLIER = 1682554634;
        static final String TABLE = "\u2002\u3000\r\u0085\u200a\u2005\u2000\u3000\u2029\u000b\u3000\u2008\u2003\u205f\u3000\u1680\t \u2006\u2001  \f\u2009\u3000\u2004\u3000\u3000\u2028\n \u3000";
        static final int SHIFT = Integer.numberOfLeadingZeros(31);
        static final Whitespace INSTANCE = new Whitespace();

        Whitespace() {
            super("CharMatcher.whitespace()");
        }

        @Override
        public boolean matches(char c) {
            return TABLE.charAt((MULTIPLIER * c) >>> SHIFT) == c;
        }

        @Override
        void setBits(BitSet bitSet) {
            for (int i = 0; i < 32; i++) {
                bitSet.set(TABLE.charAt(i));
            }
        }
    }

    private static final class BreakingWhitespace extends CharMatcher {
        static final CharMatcher INSTANCE = new BreakingWhitespace();

        @Override
        public boolean matches(char c) {
            if (c != ' ' && c != 133 && c != 5760) {
                if (c == 8199) {
                    return false;
                }
                if (c != 8287 && c != 12288 && c != 8232 && c != 8233) {
                    switch (c) {
                        case '\t':
                        case '\n':
                        case 11:
                        case '\f':
                        case '\r':
                            break;
                        default:
                            return c >= 8192 && c <= 8202;
                    }
                }
            }
            return true;
        }

        private BreakingWhitespace() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public String toString() {
            return "CharMatcher.breakingWhitespace()";
        }
    }

    private static final class Ascii extends NamedFastMatcher {
        static final Ascii INSTANCE = new Ascii();

        @Override
        public boolean matches(char c) {
            return c <= 127;
        }

        Ascii() {
            super("CharMatcher.ascii()");
        }
    }

    private static class RangesMatcher extends CharMatcher {
        private final String description;
        private final char[] rangeEnds;
        private final char[] rangeStarts;

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        RangesMatcher(String str, char[] cArr, char[] cArr2) {
            this.description = str;
            this.rangeStarts = cArr;
            this.rangeEnds = cArr2;
            Preconditions.checkArgument(cArr.length == cArr2.length);
            int i = 0;
            while (i < cArr.length) {
                Preconditions.checkArgument(cArr[i] <= cArr2[i]);
                int i2 = i + 1;
                if (i2 < cArr.length) {
                    Preconditions.checkArgument(cArr2[i] < cArr[i2]);
                }
                i = i2;
            }
        }

        @Override
        public boolean matches(char c) {
            int iBinarySearch = Arrays.binarySearch(this.rangeStarts, c);
            if (iBinarySearch >= 0) {
                return true;
            }
            int i = (~iBinarySearch) - 1;
            return i >= 0 && c <= this.rangeEnds[i];
        }

        @Override
        public String toString() {
            return this.description;
        }
    }

    private static final class Digit extends RangesMatcher {
        static final Digit INSTANCE = new Digit();
        private static final String ZEROES = "0٠۰߀०০੦૦୦௦౦೦൦෦๐໐༠၀႐០᠐᥆᧐᪀᪐᭐᮰᱀᱐꘠꣐꤀꧐꧰꩐꯰０";

        private static char[] zeroes() {
            return ZEROES.toCharArray();
        }

        private static char[] nines() {
            char[] cArr = new char[37];
            for (int i = 0; i < 37; i++) {
                cArr[i] = (char) (ZEROES.charAt(i) + '\t');
            }
            return cArr;
        }

        private Digit() {
            super("CharMatcher.digit()", zeroes(), nines());
        }
    }

    private static final class JavaDigit extends CharMatcher {
        static final JavaDigit INSTANCE = new JavaDigit();

        private JavaDigit() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public boolean matches(char c) {
            return Character.isDigit(c);
        }

        @Override
        public String toString() {
            return "CharMatcher.javaDigit()";
        }
    }

    private static final class JavaLetter extends CharMatcher {
        static final JavaLetter INSTANCE = new JavaLetter();

        private JavaLetter() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public boolean matches(char c) {
            return Character.isLetter(c);
        }

        @Override
        public String toString() {
            return "CharMatcher.javaLetter()";
        }
    }

    private static final class JavaLetterOrDigit extends CharMatcher {
        static final JavaLetterOrDigit INSTANCE = new JavaLetterOrDigit();

        private JavaLetterOrDigit() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public boolean matches(char c) {
            return Character.isLetterOrDigit(c);
        }

        @Override
        public String toString() {
            return "CharMatcher.javaLetterOrDigit()";
        }
    }

    private static final class JavaUpperCase extends CharMatcher {
        static final JavaUpperCase INSTANCE = new JavaUpperCase();

        private JavaUpperCase() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public boolean matches(char c) {
            return Character.isUpperCase(c);
        }

        @Override
        public String toString() {
            return "CharMatcher.javaUpperCase()";
        }
    }

    private static final class JavaLowerCase extends CharMatcher {
        static final JavaLowerCase INSTANCE = new JavaLowerCase();

        private JavaLowerCase() {
        }

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        @Override
        public boolean matches(char c) {
            return Character.isLowerCase(c);
        }

        @Override
        public String toString() {
            return "CharMatcher.javaLowerCase()";
        }
    }

    private static final class JavaIsoControl extends NamedFastMatcher {
        static final JavaIsoControl INSTANCE = new JavaIsoControl();

        @Override
        public boolean matches(char c) {
            return c <= 31 || (c >= 127 && c <= 159);
        }

        private JavaIsoControl() {
            super("CharMatcher.javaIsoControl()");
        }
    }

    private static final class Invisible extends RangesMatcher {
        static final Invisible INSTANCE = new Invisible();
        private static final String RANGE_ENDS = "  \u00ad\u0605\u061c\u06dd\u070f\u0891\u08e2\u1680\u180e\u200f \u2064\u206f\u3000\uf8ff\ufeff\ufffb";
        private static final String RANGE_STARTS = "\u0000\u007f\u00ad\u0600\u061c\u06dd\u070f\u0890\u08e2\u1680\u180e\u2000\u2028\u205f\u2066\u3000\ud800\ufeff\ufff9";

        private Invisible() {
            super("CharMatcher.invisible()", RANGE_STARTS.toCharArray(), RANGE_ENDS.toCharArray());
        }
    }

    private static final class SingleWidth extends RangesMatcher {
        static final SingleWidth INSTANCE = new SingleWidth();

        private SingleWidth() {
            super("CharMatcher.singleWidth()", "\u0000־א׳\u0600ݐ\u0e00Ḁ℀ﭐﹰ｡".toCharArray(), "ӹ־ת״ۿݿ\u0e7f₯℺\ufdff\ufeffￜ".toCharArray());
        }
    }

    private static class Negated extends CharMatcher {
        final CharMatcher original;

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        Negated(CharMatcher charMatcher) {
            this.original = (CharMatcher) Preconditions.checkNotNull(charMatcher);
        }

        @Override
        public boolean matches(char c) {
            return !this.original.matches(c);
        }

        @Override
        public boolean matchesAllOf(CharSequence charSequence) {
            return this.original.matchesNoneOf(charSequence);
        }

        @Override
        public boolean matchesNoneOf(CharSequence charSequence) {
            return this.original.matchesAllOf(charSequence);
        }

        @Override
        public int countIn(CharSequence charSequence) {
            return charSequence.length() - this.original.countIn(charSequence);
        }

        @Override
        void setBits(BitSet bitSet) {
            BitSet bitSet2 = new BitSet();
            this.original.setBits(bitSet2);
            bitSet2.flip(0, CharMatcher.DISTINCT_CHARS);
            bitSet.or(bitSet2);
        }

        @Override
        public CharMatcher negate() {
            return this.original;
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.original);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 9);
            sb.append(strValueOf);
            sb.append(".negate()");
            return sb.toString();
        }
    }

    private static final class And extends CharMatcher {
        final CharMatcher first;
        final CharMatcher second;

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        And(CharMatcher charMatcher, CharMatcher charMatcher2) {
            this.first = (CharMatcher) Preconditions.checkNotNull(charMatcher);
            this.second = (CharMatcher) Preconditions.checkNotNull(charMatcher2);
        }

        @Override
        public boolean matches(char c) {
            return this.first.matches(c) && this.second.matches(c);
        }

        @Override
        void setBits(BitSet bitSet) {
            BitSet bitSet2 = new BitSet();
            this.first.setBits(bitSet2);
            BitSet bitSet3 = new BitSet();
            this.second.setBits(bitSet3);
            bitSet2.and(bitSet3);
            bitSet.or(bitSet2);
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.first);
            String strValueOf2 = String.valueOf(this.second);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 19 + String.valueOf(strValueOf2).length());
            sb.append("CharMatcher.and(");
            sb.append(strValueOf);
            sb.append(", ");
            sb.append(strValueOf2);
            sb.append(")");
            return sb.toString();
        }
    }

    private static final class C0346Or extends CharMatcher {
        final CharMatcher first;
        final CharMatcher second;

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        C0346Or(CharMatcher charMatcher, CharMatcher charMatcher2) {
            this.first = (CharMatcher) Preconditions.checkNotNull(charMatcher);
            this.second = (CharMatcher) Preconditions.checkNotNull(charMatcher2);
        }

        @Override
        void setBits(BitSet bitSet) {
            this.first.setBits(bitSet);
            this.second.setBits(bitSet);
        }

        @Override
        public boolean matches(char c) {
            return this.first.matches(c) || this.second.matches(c);
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.first);
            String strValueOf2 = String.valueOf(this.second);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 18 + String.valueOf(strValueOf2).length());
            sb.append("CharMatcher.or(");
            sb.append(strValueOf);
            sb.append(", ");
            sb.append(strValueOf2);
            sb.append(")");
            return sb.toString();
        }
    }

    private static final class C0345Is extends FastMatcher {
        private final char match;

        C0345Is(char c) {
            this.match = c;
        }

        @Override
        public boolean matches(char c) {
            return c == this.match;
        }

        @Override
        public String replaceFrom(CharSequence charSequence, char c) {
            return charSequence.toString().replace(this.match, c);
        }

        @Override
        public CharMatcher and(CharMatcher charMatcher) {
            return charMatcher.matches(this.match) ? this : none();
        }

        @Override
        public CharMatcher mo130or(CharMatcher charMatcher) {
            return charMatcher.matches(this.match) ? charMatcher : super.mo130or(charMatcher);
        }

        @Override
        public CharMatcher negate() {
            return isNot(this.match);
        }

        @Override
        void setBits(BitSet bitSet) {
            bitSet.set(this.match);
        }

        @Override
        public String toString() {
            String strShowCharacter = CharMatcher.showCharacter(this.match);
            StringBuilder sb = new StringBuilder(String.valueOf(strShowCharacter).length() + 18);
            sb.append("CharMatcher.is('");
            sb.append(strShowCharacter);
            sb.append("')");
            return sb.toString();
        }
    }

    private static final class IsNot extends FastMatcher {
        private final char match;

        IsNot(char c) {
            this.match = c;
        }

        @Override
        public boolean matches(char c) {
            return c != this.match;
        }

        @Override
        public CharMatcher and(CharMatcher charMatcher) {
            return charMatcher.matches(this.match) ? super.and(charMatcher) : charMatcher;
        }

        @Override
        public CharMatcher mo130or(CharMatcher charMatcher) {
            return charMatcher.matches(this.match) ? any() : this;
        }

        @Override
        void setBits(BitSet bitSet) {
            bitSet.set(0, this.match);
            bitSet.set(this.match + 1, CharMatcher.DISTINCT_CHARS);
        }

        @Override
        public CharMatcher negate() {
            return m129is(this.match);
        }

        @Override
        public String toString() {
            String strShowCharacter = CharMatcher.showCharacter(this.match);
            StringBuilder sb = new StringBuilder(String.valueOf(strShowCharacter).length() + 21);
            sb.append("CharMatcher.isNot('");
            sb.append(strShowCharacter);
            sb.append("')");
            return sb.toString();
        }
    }

    private static IsEither isEither(char c, char c2) {
        return new IsEither(c, c2);
    }

    private static final class IsEither extends FastMatcher {
        private final char match1;
        private final char match2;

        IsEither(char c, char c2) {
            this.match1 = c;
            this.match2 = c2;
        }

        @Override
        public boolean matches(char c) {
            return c == this.match1 || c == this.match2;
        }

        @Override
        void setBits(BitSet bitSet) {
            bitSet.set(this.match1);
            bitSet.set(this.match2);
        }

        @Override
        public String toString() {
            String strShowCharacter = CharMatcher.showCharacter(this.match1);
            String strShowCharacter2 = CharMatcher.showCharacter(this.match2);
            StringBuilder sb = new StringBuilder(String.valueOf(strShowCharacter).length() + 21 + String.valueOf(strShowCharacter2).length());
            sb.append("CharMatcher.anyOf(\"");
            sb.append(strShowCharacter);
            sb.append(strShowCharacter2);
            sb.append("\")");
            return sb.toString();
        }
    }

    private static final class AnyOf extends CharMatcher {
        private final char[] chars;

        @Override
        @Deprecated
        public boolean apply(Character ch) {
            return super.apply(ch);
        }

        public AnyOf(CharSequence charSequence) {
            char[] charArray = charSequence.toString().toCharArray();
            this.chars = charArray;
            Arrays.sort(charArray);
        }

        @Override
        public boolean matches(char c) {
            return Arrays.binarySearch(this.chars, c) >= 0;
        }

        @Override
        void setBits(BitSet bitSet) {
            for (char c : this.chars) {
                bitSet.set(c);
            }
        }

        @Override
        public String toString() {
            StringBuilder sb = new StringBuilder("CharMatcher.anyOf(\"");
            for (char c : this.chars) {
                sb.append(CharMatcher.showCharacter(c));
            }
            sb.append("\")");
            return sb.toString();
        }
    }

    private static final class InRange extends FastMatcher {
        private final char endInclusive;
        private final char startInclusive;

        InRange(char c, char c2) {
            Preconditions.checkArgument(c2 >= c);
            this.startInclusive = c;
            this.endInclusive = c2;
        }

        @Override
        public boolean matches(char c) {
            return this.startInclusive <= c && c <= this.endInclusive;
        }

        @Override
        void setBits(BitSet bitSet) {
            bitSet.set(this.startInclusive, this.endInclusive + 1);
        }

        @Override
        public String toString() {
            String strShowCharacter = CharMatcher.showCharacter(this.startInclusive);
            String strShowCharacter2 = CharMatcher.showCharacter(this.endInclusive);
            StringBuilder sb = new StringBuilder(String.valueOf(strShowCharacter).length() + 27 + String.valueOf(strShowCharacter2).length());
            sb.append("CharMatcher.inRange('");
            sb.append(strShowCharacter);
            sb.append("', '");
            sb.append(strShowCharacter2);
            sb.append("')");
            return sb.toString();
        }
    }

    private static final class ForPredicate extends CharMatcher {
        private final Predicate<? super Character> predicate;

        ForPredicate(Predicate<? super Character> predicate) {
            this.predicate = (Predicate) Preconditions.checkNotNull(predicate);
        }

        @Override
        public boolean matches(char c) {
            return this.predicate.apply(Character.valueOf(c));
        }

        @Override
        public boolean apply(Character ch) {
            return this.predicate.apply(Preconditions.checkNotNull(ch));
        }

        @Override
        public String toString() {
            String strValueOf = String.valueOf(this.predicate);
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 26);
            sb.append("CharMatcher.forPredicate(");
            sb.append(strValueOf);
            sb.append(")");
            return sb.toString();
        }
    }
}
