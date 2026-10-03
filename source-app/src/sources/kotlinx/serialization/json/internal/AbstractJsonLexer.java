package kotlinx.serialization.json.internal;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.ArrayList;
import java.util.List;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;

@Metadata(m17d1 = {"\u0000r\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\r\n\u0002\b\n\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0010\u0005\n\u0000\n\u0002\u0010\f\n\u0000\n\u0002\u0010\t\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u0001\n\u0002\b\u0016\n\u0002\u0018\u0002\n\u0002\b\u0014\b \u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0014\u001a\u00020\u00042\u0006\u0010\u0015\u001a\u00020\u0004H\u0002J\u0018\u0010\u0016\u001a\u00020\u00042\u0006\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u0004H\u0002J\u0018\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u001a\u001a\u00020\u0004H\u0002J\u0018\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u00042\u0006\u0010\u001e\u001a\u00020\u0004H\u0014J\b\u0010\u001f\u001a\u00020 H&J\u0006\u0010!\u001a\u00020 J\u0010\u0010!\u001a\u00020 2\u0006\u0010\"\u001a\u00020\u0004H\u0003J\u0006\u0010#\u001a\u00020 J\u0018\u0010$\u001a\u00020\u001c2\u0006\u0010%\u001a\u00020\u000f2\u0006\u0010\u0018\u001a\u00020\u0004H\u0002J\b\u0010&\u001a\u00020\u000fH&J\b\u0010'\u001a\u00020(H&J\u000e\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020(J\u0010\u0010'\u001a\u00020\u001c2\u0006\u0010)\u001a\u00020*H\u0016J\u0006\u0010+\u001a\u00020,J\u0006\u0010-\u001a\u00020\u000fJ \u0010-\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0015\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u0004H\u0005J3\u0010.\u001a\u00020\u001c2\u0006\u0010/\u001a\u00020 2!\u00100\u001a\u001d\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b2\u0012\b\b3\u0012\u0004\b\b(4\u0012\u0004\u0012\u00020\u001c01H\u0016J\u0006\u00105\u001a\u00020\u000fJ\u0006\u00106\u001a\u00020\u000fJ\u0018\u00107\u001a\u00020\u000f2\u0006\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0003\u001a\u00020\u0004H\u0002J\u0006\u00108\u001a\u00020\u001cJ\b\u00109\u001a\u00020\u001cH\u0016J\u0006\u0010:\u001a\u00020\u001cJ\u001f\u0010;\u001a\u00020<2\u0006\u0010=\u001a\u00020(2\b\b\u0002\u0010>\u001a\u00020 H\u0000¢\u0006\u0002\b?J\"\u0010;\u001a\u00020<2\u0006\u0010@\u001a\u00020\u000f2\b\b\u0002\u0010A\u001a\u00020\u00042\b\b\u0002\u0010B\u001a\u00020\u000fJ\u000e\u0010C\u001a\u00020\u001c2\u0006\u0010D\u001a\u00020\u000fJ\u0018\u0010E\u001a\u00020\u00042\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0003\u001a\u00020\u0004H\u0002J\u0018\u0010F\u001a\u00020\u00042\u0006\u0010G\u001a\u00020*2\u0006\u0010\u001a\u001a\u00020\u0004H\u0016J\u0018\u0010H\u001a\u00020 2\u0006\u0010/\u001a\u00020 2\u0006\u0010G\u001a\u00020*H\u0002J\u0006\u0010I\u001a\u00020 J\u0010\u0010J\u001a\u00020 2\u0006\u0010K\u001a\u00020*H\u0004J\u001a\u0010L\u001a\u0004\u0018\u00010\u000f2\u0006\u0010M\u001a\u00020\u000f2\u0006\u0010/\u001a\u00020 H&J\u0006\u0010N\u001a\u00020(J\u0010\u0010O\u001a\u0004\u0018\u00010\u000f2\u0006\u0010/\u001a\u00020 J\u0010\u0010P\u001a\u00020\u00042\u0006\u0010A\u001a\u00020\u0004H&J1\u0010Q\u001a\u00020\u001c2\u0006\u0010R\u001a\u00020 2\b\b\u0002\u0010A\u001a\u00020\u00042\f\u0010@\u001a\b\u0012\u0004\u0012\u00020\u000f0SH\u0080\bø\u0001\u0000¢\u0006\u0002\bTJ\u000e\u0010U\u001a\u00020\u001c2\u0006\u0010V\u001a\u00020 J\b\u0010W\u001a\u00020\u0004H\u0016J\u0018\u0010X\u001a\u00020\u000f2\u0006\u0010\u001a\u001a\u00020\u00042\u0006\u0010Y\u001a\u00020\u0004H\u0016J\b\u0010Z\u001a\u00020\u000fH\u0002J\b\u0010[\u001a\u00020\u000fH\u0016J\b\u0010\\\u001a\u00020 H&J\u0010\u0010]\u001a\u00020 2\b\b\u0002\u0010^\u001a\u00020 J\u0010\u0010_\u001a\u00020\u001c2\u0006\u0010)\u001a\u00020*H\u0004J\b\u0010`\u001a\u00020 H\u0002J\"\u0010a\u001a\u0002Hb\"\u0004\b\u0000\u0010b2\f\u0010c\u001a\b\u0012\u0004\u0012\u0002Hb0SH\u0082\b¢\u0006\u0002\u0010dJC\u0010e\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u00042\u0006\u0010\u001e\u001a\u00020\u00042\u0006\u0010f\u001a\u00020 2!\u00100\u001a\u001d\u0012\u0013\u0012\u00110\u000f¢\u0006\f\b2\u0012\b\b3\u0012\u0004\b\b(4\u0012\u0004\u0012\u00020\u001c01H\u0002R\u0012\u0010\u0003\u001a\u00020\u00048\u0000@\u0000X\u0081\u000e¢\u0006\u0002\n\u0000R\u001e\u0010\u0005\u001a\u00060\u0006j\u0002`\u0007X\u0084\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u0010\u0010\f\u001a\u00020\r8\u0006X\u0087\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010\u0010\u001a\u00020\u0011X¤\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013\u0082\u0002\u0007\n\u0005\b\u009920\u0001¨\u0006g"}, m18d2 = {"Lkotlinx/serialization/json/internal/AbstractJsonLexer;", "", "()V", "currentPosition", "", "escapedString", "Ljava/lang/StringBuilder;", "Lkotlin/text/StringBuilder;", "getEscapedString", "()Ljava/lang/StringBuilder;", "setEscapedString", "(Ljava/lang/StringBuilder;)V", ClientCookie.PATH_ATTR, "Lkotlinx/serialization/json/internal/JsonPath;", "peekedString", "", "source", "", "getSource", "()Ljava/lang/CharSequence;", "appendEsc", "startPosition", "appendEscape", "lastPosition", "current", "appendHex", "startPos", "appendRange", "", "fromIndex", "toIndex", "canConsumeValue", "", "consumeBoolean", "start", "consumeBooleanLenient", "consumeBooleanLiteral", "literalSuffix", "consumeKeyString", "consumeNextToken", "", "expected", "", "consumeNumericLiteral", "", "consumeString", "consumeStringChunked", "isLenient", "consumeChunk", "Lkotlin/Function1;", "Lkotlin/ParameterName;", "name", "stringChunk", "consumeStringLenient", "consumeStringLenientNotNull", "decodedString", "discardPeeked", "ensureHaveChars", "expectEof", "fail", "", "expectedToken", "wasConsumed", "fail$kotlinx_serialization_json", "message", "position", "hint", "failOnUnknownKey", "key", "fromHexChar", "indexOf", "char", "insideString", "isNotEof", "isValidValueStart", "c", "peekLeadingMatchingValue", "keyToMatch", "peekNextToken", "peekString", "prefetchOrEof", "require", "condition", "Lkotlin/Function0;", "require$kotlinx_serialization_json", "skipElement", "allowLenientStrings", "skipWhitespaces", "substring", "endPos", "takePeeked", "toString", "tryConsumeComma", "tryConsumeNull", "doConsume", "unexpectedToken", "wasUnquotedString", "withPositionRollback", "T", "action", "(Lkotlin/jvm/functions/Function0;)Ljava/lang/Object;", "writeRange", "currentChunkHasEscape", "kotlinx-serialization-json"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class AbstractJsonLexer {
    public int currentPosition;
    private String peekedString;
    public final JsonPath path = new JsonPath();
    private StringBuilder escapedString = new StringBuilder();

    public abstract boolean canConsumeValue();

    public abstract String consumeKeyString();

    public abstract byte consumeNextToken();

    public void ensureHaveChars() {
    }

    protected abstract CharSequence getSource();

    protected final boolean isValidValueStart(char c) {
        return !(c == '}' || c == ']' || c == ':' || c == ',');
    }

    public abstract String peekLeadingMatchingValue(String keyToMatch, boolean isLenient);

    public abstract int prefetchOrEof(int position);

    public abstract boolean tryConsumeComma();

    public final boolean isNotEof() {
        return peekNextToken() != 10;
    }

    public final void expectEof() {
        if (consumeNextToken() == 10) {
            return;
        }
        fail$default(this, "Expected EOF after parsing, but had " + getSource().charAt(this.currentPosition - 1) + " instead", 0, null, 6, null);
        throw new KotlinNothingValueException();
    }

    protected final StringBuilder getEscapedString() {
        return this.escapedString;
    }

    protected final void setEscapedString(StringBuilder sb) {
        Intrinsics.checkNotNullParameter(sb, "<set-?>");
        this.escapedString = sb;
    }

    public final byte consumeNextToken(byte expected) {
        byte bConsumeNextToken = consumeNextToken();
        if (bConsumeNextToken == expected) {
            return bConsumeNextToken;
        }
        fail$kotlinx_serialization_json$default(this, expected, false, 2, null);
        throw new KotlinNothingValueException();
    }

    public void consumeNextToken(char expected) {
        ensureHaveChars();
        CharSequence source = getSource();
        int i = this.currentPosition;
        while (true) {
            int iPrefetchOrEof = prefetchOrEof(i);
            if (iPrefetchOrEof != -1) {
                int i2 = iPrefetchOrEof + 1;
                char cCharAt = source.charAt(iPrefetchOrEof);
                if (cCharAt != ' ' && cCharAt != '\n' && cCharAt != '\r' && cCharAt != '\t') {
                    this.currentPosition = i2;
                    if (cCharAt == expected) {
                        return;
                    } else {
                        unexpectedToken(expected);
                    }
                }
                i = i2;
            } else {
                this.currentPosition = iPrefetchOrEof;
                unexpectedToken(expected);
                return;
            }
        }
    }

    protected final void unexpectedToken(char expected) {
        int i = this.currentPosition;
        if (i > 0 && expected == '\"') {
            try {
                this.currentPosition = i - 1;
                String strConsumeStringLenient = consumeStringLenient();
                this.currentPosition = i;
                if (Intrinsics.areEqual(strConsumeStringLenient, AbstractJsonLexerKt.NULL)) {
                    fail("Expected string literal but 'null' literal was found", this.currentPosition - 1, AbstractJsonLexerKt.coerceInputValuesHint);
                    throw new KotlinNothingValueException();
                }
            } catch (Throwable th) {
                this.currentPosition = i;
                throw th;
            }
        }
        fail$kotlinx_serialization_json$default(this, AbstractJsonLexerKt.charToTokenClass(expected), false, 2, null);
        throw new KotlinNothingValueException();
    }

    public static Void fail$kotlinx_serialization_json$default(AbstractJsonLexer abstractJsonLexer, byte b, boolean z, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: fail");
        }
        if ((i & 2) != 0) {
            z = true;
        }
        return abstractJsonLexer.fail$kotlinx_serialization_json(b, z);
    }

    public final Void fail$kotlinx_serialization_json(byte expectedToken, boolean wasConsumed) {
        String str = AbstractJsonLexerKt.tokenDescription(expectedToken);
        int i = wasConsumed ? this.currentPosition - 1 : this.currentPosition;
        fail$default(this, "Expected " + str + ", but had '" + ((this.currentPosition == getSource().length() || i < 0) ? "EOF" : String.valueOf(getSource().charAt(i))) + "' instead", i, null, 4, null);
        throw new KotlinNothingValueException();
    }

    public final byte peekNextToken() {
        CharSequence source = getSource();
        int i = this.currentPosition;
        while (true) {
            int iPrefetchOrEof = prefetchOrEof(i);
            if (iPrefetchOrEof != -1) {
                char cCharAt = source.charAt(iPrefetchOrEof);
                if (cCharAt != ' ' && cCharAt != '\n' && cCharAt != '\r' && cCharAt != '\t') {
                    this.currentPosition = iPrefetchOrEof;
                    return AbstractJsonLexerKt.charToTokenClass(cCharAt);
                }
                i = iPrefetchOrEof + 1;
            } else {
                this.currentPosition = iPrefetchOrEof;
                return (byte) 10;
            }
        }
    }

    public static boolean tryConsumeNull$default(AbstractJsonLexer abstractJsonLexer, boolean z, int i, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: tryConsumeNull");
        }
        if ((i & 1) != 0) {
            z = true;
        }
        return abstractJsonLexer.tryConsumeNull(z);
    }

    public final boolean tryConsumeNull(boolean doConsume) {
        int iPrefetchOrEof = prefetchOrEof(skipWhitespaces());
        int length = getSource().length() - iPrefetchOrEof;
        if (length < 4 || iPrefetchOrEof == -1) {
            return false;
        }
        for (int i = 0; i < 4; i++) {
            if (AbstractJsonLexerKt.NULL.charAt(i) != getSource().charAt(iPrefetchOrEof + i)) {
                return false;
            }
        }
        if (length > 4 && AbstractJsonLexerKt.charToTokenClass(getSource().charAt(iPrefetchOrEof + 4)) == 0) {
            return false;
        }
        if (!doConsume) {
            return true;
        }
        this.currentPosition = iPrefetchOrEof + 4;
        return true;
    }

    public int skipWhitespaces() {
        int iPrefetchOrEof;
        char cCharAt;
        int i = this.currentPosition;
        while (true) {
            iPrefetchOrEof = prefetchOrEof(i);
            if (iPrefetchOrEof == -1 || !((cCharAt = getSource().charAt(iPrefetchOrEof)) == ' ' || cCharAt == '\n' || cCharAt == '\r' || cCharAt == '\t')) {
                break;
            }
            i = iPrefetchOrEof + 1;
        }
        this.currentPosition = iPrefetchOrEof;
        return iPrefetchOrEof;
    }

    public final String peekString(boolean isLenient) {
        String strConsumeString;
        byte bPeekNextToken = peekNextToken();
        if (isLenient) {
            if (bPeekNextToken != 1 && bPeekNextToken != 0) {
                return null;
            }
            strConsumeString = consumeStringLenient();
        } else {
            if (bPeekNextToken != 1) {
                return null;
            }
            strConsumeString = consumeString();
        }
        this.peekedString = strConsumeString;
        return strConsumeString;
    }

    public final void discardPeeked() {
        this.peekedString = null;
    }

    public int indexOf(char c, int startPos) {
        return StringsKt.indexOf$default(getSource(), c, startPos, false, 4, (Object) null);
    }

    public String substring(int startPos, int endPos) {
        return getSource().subSequence(startPos, endPos).toString();
    }

    private final boolean insideString(boolean isLenient, char c) {
        if (isLenient) {
            if (AbstractJsonLexerKt.charToTokenClass(c) == 0) {
                return true;
            }
        } else if (c != '\"') {
            return true;
        }
        return false;
    }

    public void consumeStringChunked(boolean isLenient, Function1<? super String, Unit> consumeChunk) {
        int i;
        int iPrefetchOrEof;
        Intrinsics.checkNotNullParameter(consumeChunk, "consumeChunk");
        byte bPeekNextToken = peekNextToken();
        if (!isLenient || bPeekNextToken == 0) {
            if (!isLenient) {
                consumeNextToken('\"');
            }
            int i2 = this.currentPosition;
            char cCharAt = getSource().charAt(i2);
            boolean z = false;
            int i3 = i2;
            while (insideString(isLenient, cCharAt)) {
                if (isLenient || cCharAt != '\\') {
                    int i4 = i3 + 1;
                    i = i2;
                    iPrefetchOrEof = i4;
                } else {
                    iPrefetchOrEof = prefetchOrEof(appendEscape(i2, i3));
                    z = true;
                    i = iPrefetchOrEof;
                }
                if (iPrefetchOrEof >= getSource().length()) {
                    writeRange(i, iPrefetchOrEof, z, consumeChunk);
                    int iPrefetchOrEof2 = prefetchOrEof(iPrefetchOrEof);
                    if (iPrefetchOrEof2 == -1) {
                        fail$default(this, "EOF", iPrefetchOrEof2, null, 4, null);
                        throw new KotlinNothingValueException();
                    }
                    z = false;
                    i2 = iPrefetchOrEof2;
                    i3 = i2;
                } else {
                    int i5 = i;
                    i3 = iPrefetchOrEof;
                    i2 = i5;
                }
                cCharAt = getSource().charAt(i3);
            }
            writeRange(i2, i3, z, consumeChunk);
            this.currentPosition = i3;
            if (isLenient) {
                return;
            }
            consumeNextToken('\"');
        }
    }

    private final void writeRange(int fromIndex, int toIndex, boolean currentChunkHasEscape, Function1<? super String, Unit> consumeChunk) {
        if (currentChunkHasEscape) {
            consumeChunk.invoke(decodedString(fromIndex, toIndex));
        } else {
            consumeChunk.invoke(substring(fromIndex, toIndex));
        }
    }

    public final String consumeString() {
        if (this.peekedString != null) {
            return takePeeked();
        }
        return consumeKeyString();
    }

    protected final String consumeString(CharSequence source, int startPosition, int current) {
        String strDecodedString;
        int iPrefetchOrEof;
        Intrinsics.checkNotNullParameter(source, "source");
        char cCharAt = source.charAt(current);
        boolean z = false;
        while (cCharAt != '\"') {
            if (cCharAt == '\\') {
                iPrefetchOrEof = prefetchOrEof(appendEscape(startPosition, current));
                if (iPrefetchOrEof == -1) {
                    fail$default(this, "Unexpected EOF", iPrefetchOrEof, null, 4, null);
                    throw new KotlinNothingValueException();
                }
            } else {
                current++;
                if (current >= source.length()) {
                    appendRange(startPosition, current);
                    iPrefetchOrEof = prefetchOrEof(current);
                    if (iPrefetchOrEof == -1) {
                        fail$default(this, "Unexpected EOF", iPrefetchOrEof, null, 4, null);
                        throw new KotlinNothingValueException();
                    }
                } else {
                    continue;
                }
                cCharAt = source.charAt(current);
            }
            z = true;
            startPosition = iPrefetchOrEof;
            current = startPosition;
            cCharAt = source.charAt(current);
        }
        if (!z) {
            strDecodedString = substring(startPosition, current);
        } else {
            strDecodedString = decodedString(startPosition, current);
        }
        this.currentPosition = current + 1;
        return strDecodedString;
    }

    private final int appendEscape(int lastPosition, int current) {
        appendRange(lastPosition, current);
        return appendEsc(current + 1);
    }

    private final String decodedString(int lastPosition, int currentPosition) {
        appendRange(lastPosition, currentPosition);
        String string = this.escapedString.toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        this.escapedString.setLength(0);
        return string;
    }

    private final String takePeeked() {
        String str = this.peekedString;
        Intrinsics.checkNotNull(str);
        this.peekedString = null;
        return str;
    }

    public final String consumeStringLenientNotNull() {
        String strConsumeStringLenient = consumeStringLenient();
        if (!Intrinsics.areEqual(strConsumeStringLenient, AbstractJsonLexerKt.NULL) || !wasUnquotedString()) {
            return strConsumeStringLenient;
        }
        fail$default(this, "Unexpected 'null' value instead of string literal", 0, null, 6, null);
        throw new KotlinNothingValueException();
    }

    private final boolean wasUnquotedString() {
        return getSource().charAt(this.currentPosition - 1) != '\"';
    }

    public final String consumeStringLenient() {
        String strDecodedString;
        if (this.peekedString != null) {
            return takePeeked();
        }
        int iSkipWhitespaces = skipWhitespaces();
        if (iSkipWhitespaces >= getSource().length() || iSkipWhitespaces == -1) {
            fail$default(this, "EOF", iSkipWhitespaces, null, 4, null);
            throw new KotlinNothingValueException();
        }
        byte bCharToTokenClass = AbstractJsonLexerKt.charToTokenClass(getSource().charAt(iSkipWhitespaces));
        if (bCharToTokenClass == 1) {
            return consumeString();
        }
        if (bCharToTokenClass != 0) {
            fail$default(this, "Expected beginning of the string, but got " + getSource().charAt(iSkipWhitespaces), 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        boolean z = false;
        while (AbstractJsonLexerKt.charToTokenClass(getSource().charAt(iSkipWhitespaces)) == 0) {
            iSkipWhitespaces++;
            if (iSkipWhitespaces >= getSource().length()) {
                appendRange(this.currentPosition, iSkipWhitespaces);
                int iPrefetchOrEof = prefetchOrEof(iSkipWhitespaces);
                if (iPrefetchOrEof == -1) {
                    this.currentPosition = iSkipWhitespaces;
                    return decodedString(0, 0);
                }
                iSkipWhitespaces = iPrefetchOrEof;
                z = true;
            }
        }
        if (!z) {
            strDecodedString = substring(this.currentPosition, iSkipWhitespaces);
        } else {
            strDecodedString = decodedString(this.currentPosition, iSkipWhitespaces);
        }
        this.currentPosition = iSkipWhitespaces;
        return strDecodedString;
    }

    protected void appendRange(int fromIndex, int toIndex) {
        this.escapedString.append(getSource(), fromIndex, toIndex);
    }

    private final int appendEsc(int startPosition) {
        int iPrefetchOrEof = prefetchOrEof(startPosition);
        if (iPrefetchOrEof == -1) {
            fail$default(this, "Expected escape sequence to continue, got EOF", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        int i = iPrefetchOrEof + 1;
        char cCharAt = getSource().charAt(iPrefetchOrEof);
        if (cCharAt == 'u') {
            return appendHex(getSource(), i);
        }
        char cEscapeToChar = AbstractJsonLexerKt.escapeToChar(cCharAt);
        if (cEscapeToChar == 0) {
            fail$default(this, "Invalid escaped char '" + cCharAt + '\'', 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        this.escapedString.append(cEscapeToChar);
        return i;
    }

    private final int appendHex(CharSequence source, int startPos) {
        int i = startPos + 4;
        if (i >= source.length()) {
            this.currentPosition = startPos;
            ensureHaveChars();
            if (this.currentPosition + 4 >= source.length()) {
                fail$default(this, "Unexpected EOF during unicode escape", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            return appendHex(source, this.currentPosition);
        }
        this.escapedString.append((char) ((fromHexChar(source, startPos) << 12) + (fromHexChar(source, startPos + 1) << 8) + (fromHexChar(source, startPos + 2) << 4) + fromHexChar(source, startPos + 3)));
        return i;
    }

    public static void require$kotlinx_serialization_json$default(AbstractJsonLexer abstractJsonLexer, boolean z, int i, Function0 message, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: require");
        }
        if ((i2 & 2) != 0) {
            i = abstractJsonLexer.currentPosition;
        }
        int i3 = i;
        Intrinsics.checkNotNullParameter(message, "message");
        if (z) {
            return;
        }
        fail$default(abstractJsonLexer, (String) message.invoke(), i3, null, 4, null);
        throw new KotlinNothingValueException();
    }

    public final void require$kotlinx_serialization_json(boolean condition, int position, Function0<String> message) {
        Intrinsics.checkNotNullParameter(message, "message");
        if (condition) {
            return;
        }
        fail$default(this, message.invoke(), position, null, 4, null);
        throw new KotlinNothingValueException();
    }

    private final int fromHexChar(CharSequence source, int currentPosition) {
        char cCharAt = source.charAt(currentPosition);
        if ('0' <= cCharAt && cCharAt < ':') {
            return cCharAt - '0';
        }
        if ('a' <= cCharAt && cCharAt < 'g') {
            return cCharAt - 'W';
        }
        if ('A' <= cCharAt && cCharAt < 'G') {
            return cCharAt - '7';
        }
        fail$default(this, "Invalid toHexChar char '" + cCharAt + "' in unicode escape", 0, null, 6, null);
        throw new KotlinNothingValueException();
    }

    public final void skipElement(boolean allowLenientStrings) {
        ArrayList arrayList = new ArrayList();
        byte bPeekNextToken = peekNextToken();
        if (bPeekNextToken != 8 && bPeekNextToken != 6) {
            consumeStringLenient();
            return;
        }
        while (true) {
            byte bPeekNextToken2 = peekNextToken();
            if (bPeekNextToken2 != 1) {
                if (bPeekNextToken2 == 8 || bPeekNextToken2 == 6) {
                    arrayList.add(Byte.valueOf(bPeekNextToken2));
                } else if (bPeekNextToken2 == 9) {
                    if (((Number) CollectionsKt.last((List) arrayList)).byteValue() != 8) {
                        throw JsonExceptionsKt.JsonDecodingException(this.currentPosition, "found ] instead of } at path: " + this.path, getSource());
                    }
                    CollectionsKt.removeLast(arrayList);
                } else if (bPeekNextToken2 == 7) {
                    if (((Number) CollectionsKt.last((List) arrayList)).byteValue() != 6) {
                        throw JsonExceptionsKt.JsonDecodingException(this.currentPosition, "found } instead of ] at path: " + this.path, getSource());
                    }
                    CollectionsKt.removeLast(arrayList);
                } else if (bPeekNextToken2 == 10) {
                    fail$default(this, "Unexpected end of input due to malformed JSON during ignoring unknown keys", 0, null, 6, null);
                    throw new KotlinNothingValueException();
                }
                consumeNextToken();
                if (arrayList.size() == 0) {
                    return;
                }
            } else if (allowLenientStrings) {
                consumeStringLenient();
            } else {
                consumeKeyString();
            }
        }
    }

    public String toString() {
        return "JsonReader(source='" + ((Object) getSource()) + "', currentPosition=" + this.currentPosition + ')';
    }

    public final void failOnUnknownKey(String key) {
        Intrinsics.checkNotNullParameter(key, "key");
        fail("Encountered an unknown key '" + key + '\'', StringsKt.lastIndexOf$default((CharSequence) substring(0, this.currentPosition), key, 0, false, 6, (Object) null), AbstractJsonLexerKt.ignoreUnknownKeysHint);
        throw new KotlinNothingValueException();
    }

    public static Void fail$default(AbstractJsonLexer abstractJsonLexer, String str, int i, String str2, int i2, Object obj) {
        if (obj != null) {
            throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: fail");
        }
        if ((i2 & 2) != 0) {
            i = abstractJsonLexer.currentPosition;
        }
        if ((i2 & 4) != 0) {
            str2 = "";
        }
        return abstractJsonLexer.fail(str, i, str2);
    }

    public final Void fail(String message, int position, String hint) {
        String str;
        Intrinsics.checkNotNullParameter(message, "message");
        Intrinsics.checkNotNullParameter(hint, "hint");
        if (hint.length() == 0) {
            str = "";
        } else {
            str = "\n" + hint;
        }
        throw JsonExceptionsKt.JsonDecodingException(position, message + " at path: " + this.path.getPath() + str, getSource());
    }

    public final long consumeNumericLiteral() {
        boolean z;
        boolean z2;
        int iPrefetchOrEof = prefetchOrEof(skipWhitespaces());
        if (iPrefetchOrEof >= getSource().length() || iPrefetchOrEof == -1) {
            fail$default(this, "EOF", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        if (getSource().charAt(iPrefetchOrEof) == '\"') {
            iPrefetchOrEof++;
            if (iPrefetchOrEof == getSource().length()) {
                fail$default(this, "EOF", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            z = true;
        } else {
            z = false;
        }
        int i = iPrefetchOrEof;
        long j = 0;
        long j2 = 0;
        boolean z3 = false;
        boolean z4 = false;
        loop0: while (true) {
            z2 = false;
            while (true) {
                if (i == getSource().length()) {
                    break loop0;
                }
                char cCharAt = getSource().charAt(i);
                if ((cCharAt == 'e' || cCharAt == 'E') && !z3) {
                    if (i == iPrefetchOrEof) {
                        fail$default(this, "Unexpected symbol " + cCharAt + " in numeric literal", 0, null, 6, null);
                        throw new KotlinNothingValueException();
                    }
                    i++;
                    z3 = true;
                } else if (cCharAt != '-' || !z3) {
                    if (cCharAt != '+' || !z3) {
                        if (cCharAt != '-') {
                            if (AbstractJsonLexerKt.charToTokenClass(cCharAt) != 0) {
                                break loop0;
                            }
                            i++;
                            int i2 = cCharAt - '0';
                            if (i2 < 0 || i2 >= 10) {
                                fail$default(this, "Unexpected symbol '" + cCharAt + "' in numeric literal", 0, null, 6, null);
                                throw new KotlinNothingValueException();
                            }
                            if (z3) {
                                j2 = (j2 * ((long) 10)) + ((long) i2);
                            } else {
                                j = (j * ((long) 10)) - ((long) i2);
                                if (j > 0) {
                                    fail$default(this, "Numeric value overflow", 0, null, 6, null);
                                    throw new KotlinNothingValueException();
                                }
                            }
                        } else {
                            if (i != iPrefetchOrEof) {
                                fail$default(this, "Unexpected symbol '-' in numeric literal", 0, null, 6, null);
                                throw new KotlinNothingValueException();
                            }
                            i++;
                            z4 = true;
                        }
                    } else {
                        if (i == iPrefetchOrEof) {
                            fail$default(this, "Unexpected symbol '+' in numeric literal", 0, null, 6, null);
                            throw new KotlinNothingValueException();
                        }
                        i++;
                    }
                }
                z2 = true;
            }
            if (i == iPrefetchOrEof) {
                fail$default(this, "Unexpected symbol '-' in numeric literal", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            i++;
        }
        boolean z5 = i != iPrefetchOrEof;
        if (iPrefetchOrEof == i || (z4 && iPrefetchOrEof == i - 1)) {
            fail$default(this, "Expected numeric literal", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        if (z) {
            if (!z5) {
                fail$default(this, "EOF", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            if (getSource().charAt(i) != '\"') {
                fail$default(this, "Expected closing quotation mark", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            i++;
        }
        this.currentPosition = i;
        if (z3) {
            double dConsumeNumericLiteral$calculateExponent = j * consumeNumericLiteral$calculateExponent(j2, z2);
            if (dConsumeNumericLiteral$calculateExponent > 9.223372036854776E18d || dConsumeNumericLiteral$calculateExponent < -9.223372036854776E18d) {
                fail$default(this, "Numeric value overflow", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            if (Math.floor(dConsumeNumericLiteral$calculateExponent) != dConsumeNumericLiteral$calculateExponent) {
                fail$default(this, "Can't convert " + dConsumeNumericLiteral$calculateExponent + " to Long", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            j = (long) dConsumeNumericLiteral$calculateExponent;
        }
        if (z4) {
            return j;
        }
        if (j != Long.MIN_VALUE) {
            return -j;
        }
        fail$default(this, "Numeric value overflow", 0, null, 6, null);
        throw new KotlinNothingValueException();
    }

    private static final double consumeNumericLiteral$calculateExponent(long j, boolean z) {
        if (!z) {
            return Math.pow(10.0d, -j);
        }
        if (z) {
            return Math.pow(10.0d, j);
        }
        throw new NoWhenBranchMatchedException();
    }

    public final boolean consumeBoolean() {
        return consumeBoolean(skipWhitespaces());
    }

    public final boolean consumeBooleanLenient() {
        boolean z;
        int iSkipWhitespaces = skipWhitespaces();
        if (iSkipWhitespaces == getSource().length()) {
            fail$default(this, "EOF", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        if (getSource().charAt(iSkipWhitespaces) == '\"') {
            iSkipWhitespaces++;
            z = true;
        } else {
            z = false;
        }
        boolean zConsumeBoolean = consumeBoolean(iSkipWhitespaces);
        if (z) {
            if (this.currentPosition == getSource().length()) {
                fail$default(this, "EOF", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            if (getSource().charAt(this.currentPosition) != '\"') {
                fail$default(this, "Expected closing quotation mark", 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
            this.currentPosition++;
        }
        return zConsumeBoolean;
    }

    private final boolean consumeBoolean(int start) {
        int iPrefetchOrEof = prefetchOrEof(start);
        if (iPrefetchOrEof >= getSource().length() || iPrefetchOrEof == -1) {
            fail$default(this, "EOF", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        int i = iPrefetchOrEof + 1;
        int iCharAt = getSource().charAt(iPrefetchOrEof) | ' ';
        if (iCharAt == 102) {
            consumeBooleanLiteral("alse", i);
            return false;
        }
        if (iCharAt == 116) {
            consumeBooleanLiteral("rue", i);
            return true;
        }
        fail$default(this, "Expected valid boolean literal prefix, but had '" + consumeStringLenient() + '\'', 0, null, 6, null);
        throw new KotlinNothingValueException();
    }

    private final void consumeBooleanLiteral(String literalSuffix, int current) {
        if (getSource().length() - current < literalSuffix.length()) {
            fail$default(this, "Unexpected end of boolean literal", 0, null, 6, null);
            throw new KotlinNothingValueException();
        }
        int length = literalSuffix.length();
        for (int i = 0; i < length; i++) {
            if (literalSuffix.charAt(i) != (getSource().charAt(current + i) | ' ')) {
                fail$default(this, "Expected valid boolean literal prefix, but had '" + consumeStringLenient() + '\'', 0, null, 6, null);
                throw new KotlinNothingValueException();
            }
        }
        this.currentPosition = current + literalSuffix.length();
    }

    private final <T> T withPositionRollback(Function0<? extends T> action) {
        int i = this.currentPosition;
        try {
            return action.invoke();
        } finally {
            this.currentPosition = i;
        }
    }
}
