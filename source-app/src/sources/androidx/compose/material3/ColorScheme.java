package androidx.compose.material3;

import androidx.compose.p002ui.graphics.Color;
import androidx.compose.p002ui.graphics.Fields;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000¸\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b)\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\"\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b2\n\u0002\u0010\u000e\n\u0000\b\u0007\u0018\u00002\u00020\u0001Bï\u0001\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0003\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\u0006\u0010\u000f\u001a\u00020\u0003\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\u0006\u0010\u0012\u001a\u00020\u0003\u0012\u0006\u0010\u0013\u001a\u00020\u0003\u0012\u0006\u0010\u0014\u001a\u00020\u0003\u0012\u0006\u0010\u0015\u001a\u00020\u0003\u0012\u0006\u0010\u0016\u001a\u00020\u0003\u0012\u0006\u0010\u0017\u001a\u00020\u0003\u0012\u0006\u0010\u0018\u001a\u00020\u0003\u0012\u0006\u0010\u0019\u001a\u00020\u0003\u0012\u0006\u0010\u001a\u001a\u00020\u0003\u0012\u0006\u0010\u001b\u001a\u00020\u0003\u0012\u0006\u0010\u001c\u001a\u00020\u0003\u0012\u0006\u0010\u001d\u001a\u00020\u0003\u0012\u0006\u0010\u001e\u001a\u00020\u0003\u0012\u0006\u0010\u001f\u001a\u00020\u0003¢\u0006\u0002\u0010 B¥\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0003\u0012\u0006\u0010\u000e\u001a\u00020\u0003\u0012\u0006\u0010\u000f\u001a\u00020\u0003\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\u0006\u0010\u0012\u001a\u00020\u0003\u0012\u0006\u0010\u0013\u001a\u00020\u0003\u0012\u0006\u0010\u0014\u001a\u00020\u0003\u0012\u0006\u0010\u0015\u001a\u00020\u0003\u0012\u0006\u0010\u0016\u001a\u00020\u0003\u0012\u0006\u0010\u0017\u001a\u00020\u0003\u0012\u0006\u0010\u0018\u001a\u00020\u0003\u0012\u0006\u0010\u0019\u001a\u00020\u0003\u0012\u0006\u0010\u001a\u001a\u00020\u0003\u0012\u0006\u0010\u001b\u001a\u00020\u0003\u0012\u0006\u0010\u001c\u001a\u00020\u0003\u0012\u0006\u0010\u001d\u001a\u00020\u0003\u0012\u0006\u0010\u001e\u001a\u00020\u0003\u0012\u0006\u0010\u001f\u001a\u00020\u0003\u0012\u0006\u0010!\u001a\u00020\u0003\u0012\u0006\u0010\"\u001a\u00020\u0003\u0012\u0006\u0010#\u001a\u00020\u0003\u0012\u0006\u0010$\u001a\u00020\u0003\u0012\u0006\u0010%\u001a\u00020\u0003\u0012\u0006\u0010&\u001a\u00020\u0003\u0012\u0006\u0010'\u001a\u00020\u0003¢\u0006\u0002\u0010(J·\u0002\u0010\u008f\u0002\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\b\b\u0002\u0010\r\u001a\u00020\u00032\b\b\u0002\u0010\u000e\u001a\u00020\u00032\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u00032\b\b\u0002\u0010\u0013\u001a\u00020\u00032\b\b\u0002\u0010\u0014\u001a\u00020\u00032\b\b\u0002\u0010\u0015\u001a\u00020\u00032\b\b\u0002\u0010\u0016\u001a\u00020\u00032\b\b\u0002\u0010\u0017\u001a\u00020\u00032\b\b\u0002\u0010\u0018\u001a\u00020\u00032\b\b\u0002\u0010\u0019\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u00032\b\b\u0002\u0010\u001b\u001a\u00020\u00032\b\b\u0002\u0010\u001c\u001a\u00020\u00032\b\b\u0002\u0010\u001d\u001a\u00020\u00032\b\b\u0002\u0010\u001e\u001a\u00020\u00032\b\b\u0002\u0010\u001f\u001a\u00020\u0003H\u0007ø\u0001\u0000¢\u0006\u0006\b\u0090\u0002\u0010\u0091\u0002Jû\u0002\u0010\u008f\u0002\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\b\b\u0002\u0010\r\u001a\u00020\u00032\b\b\u0002\u0010\u000e\u001a\u00020\u00032\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u00032\b\b\u0002\u0010\u0013\u001a\u00020\u00032\b\b\u0002\u0010\u0014\u001a\u00020\u00032\b\b\u0002\u0010\u0015\u001a\u00020\u00032\b\b\u0002\u0010\u0016\u001a\u00020\u00032\b\b\u0002\u0010\u0017\u001a\u00020\u00032\b\b\u0002\u0010\u0018\u001a\u00020\u00032\b\b\u0002\u0010\u0019\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u00032\b\b\u0002\u0010\u001b\u001a\u00020\u00032\b\b\u0002\u0010\u001c\u001a\u00020\u00032\b\b\u0002\u0010\u001d\u001a\u00020\u00032\b\b\u0002\u0010\u001e\u001a\u00020\u00032\b\b\u0002\u0010\u001f\u001a\u00020\u00032\b\b\u0002\u0010!\u001a\u00020\u00032\b\b\u0002\u0010\"\u001a\u00020\u00032\b\b\u0002\u0010#\u001a\u00020\u00032\b\b\u0002\u0010$\u001a\u00020\u00032\b\b\u0002\u0010%\u001a\u00020\u00032\b\b\u0002\u0010&\u001a\u00020\u00032\b\b\u0002\u0010'\u001a\u00020\u0003ø\u0001\u0000¢\u0006\u0006\b\u0092\u0002\u0010\u0093\u0002J\n\u0010\u0094\u0002\u001a\u00030\u0095\u0002H\u0016R\u0019\u0010\u0010\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010+\u001a\u0004\b)\u0010*R\u001c\u0010,\u001a\u0004\u0018\u00010-X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b.\u0010/\"\u0004\b0\u00101R\u001c\u00102\u001a\u0004\u0018\u000103X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b4\u00105\"\u0004\b6\u00107R\u001c\u00108\u001a\u0004\u0018\u000109X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b:\u0010;\"\u0004\b<\u0010=R\"\u0010>\u001a\u0004\u0018\u00010?X\u0080\u000e¢\u0006\u0014\n\u0000\u0012\u0004\b@\u0010A\u001a\u0004\bB\u0010C\"\u0004\bD\u0010ER\u001c\u0010F\u001a\u0004\u0018\u00010GX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bH\u0010I\"\u0004\bJ\u0010KR\"\u0010L\u001a\u0004\u0018\u00010MX\u0080\u000e¢\u0006\u0014\n\u0000\u0012\u0004\bN\u0010A\u001a\u0004\bO\u0010P\"\u0004\bQ\u0010RR\u001c\u0010S\u001a\u0004\u0018\u00010-X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bT\u0010/\"\u0004\bU\u00101R\u001c\u0010V\u001a\u0004\u0018\u000103X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bW\u00105\"\u0004\bX\u00107R\u001c\u0010Y\u001a\u0004\u0018\u000109X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bZ\u0010;\"\u0004\b[\u0010=R\u001c\u0010\\\u001a\u0004\u0018\u00010]X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b^\u0010_\"\u0004\b`\u0010aR\u001c\u0010b\u001a\u0004\u0018\u00010-X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bc\u0010/\"\u0004\bd\u00101R\u001c\u0010e\u001a\u0004\u0018\u00010fX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bg\u0010h\"\u0004\bi\u0010jR\u001c\u0010k\u001a\u0004\u0018\u00010lX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bm\u0010n\"\u0004\bo\u0010pR\u001c\u0010q\u001a\u0004\u0018\u00010rX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bs\u0010t\"\u0004\bu\u0010vR\u001c\u0010w\u001a\u0004\u0018\u000103X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\bx\u00105\"\u0004\by\u00107R\u001c\u0010z\u001a\u0004\u0018\u00010lX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b{\u0010n\"\u0004\b|\u0010pR\u001c\u0010}\u001a\u0004\u0018\u00010rX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b~\u0010t\"\u0004\b\u007f\u0010vR\u001f\u0010\u0080\u0001\u001a\u0004\u0018\u00010]X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b\u0081\u0001\u0010_\"\u0005\b\u0082\u0001\u0010aR\u001f\u0010\u0083\u0001\u001a\u0004\u0018\u00010lX\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b\u0084\u0001\u0010n\"\u0005\b\u0085\u0001\u0010pR\u001f\u0010\u0086\u0001\u001a\u0004\u0018\u00010rX\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b\u0087\u0001\u0010t\"\u0005\b\u0088\u0001\u0010vR\u001f\u0010\u0089\u0001\u001a\u0004\u0018\u00010]X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b\u008a\u0001\u0010_\"\u0005\b\u008b\u0001\u0010aR&\u0010\u008c\u0001\u001a\u0004\u0018\u00010?X\u0080\u000e¢\u0006\u0017\n\u0000\u0012\u0005\b\u008d\u0001\u0010A\u001a\u0005\b\u008e\u0001\u0010C\"\u0005\b\u008f\u0001\u0010ER&\u0010\u0090\u0001\u001a\u0004\u0018\u00010?X\u0080\u000e¢\u0006\u0017\n\u0000\u0012\u0005\b\u0091\u0001\u0010A\u001a\u0005\b\u0092\u0001\u0010C\"\u0005\b\u0093\u0001\u0010ER\"\u0010\u0094\u0001\u001a\u0005\u0018\u00010\u0095\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\b\u0096\u0001\u0010\u0097\u0001\"\u0006\b\u0098\u0001\u0010\u0099\u0001R\"\u0010\u009a\u0001\u001a\u0005\u0018\u00010\u009b\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\b\u009c\u0001\u0010\u009d\u0001\"\u0006\b\u009e\u0001\u0010\u009f\u0001R\"\u0010 \u0001\u001a\u0005\u0018\u00010¡\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\b¢\u0001\u0010£\u0001\"\u0006\b¤\u0001\u0010¥\u0001R\u001f\u0010¦\u0001\u001a\u0004\u0018\u000103X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b§\u0001\u00105\"\u0005\b¨\u0001\u00107R\u001f\u0010©\u0001\u001a\u0004\u0018\u000109X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\bª\u0001\u0010;\"\u0005\b«\u0001\u0010=R\u001f\u0010¬\u0001\u001a\u0004\u0018\u00010lX\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b\u00ad\u0001\u0010n\"\u0005\b®\u0001\u0010pR\u001f\u0010¯\u0001\u001a\u0004\u0018\u00010rX\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\b°\u0001\u0010t\"\u0005\b±\u0001\u0010vR\"\u0010²\u0001\u001a\u0005\u0018\u00010³\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\b´\u0001\u0010µ\u0001\"\u0006\b¶\u0001\u0010·\u0001R\"\u0010¸\u0001\u001a\u0005\u0018\u00010¹\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\bº\u0001\u0010»\u0001\"\u0006\b¼\u0001\u0010½\u0001R)\u0010¾\u0001\u001a\u0005\u0018\u00010¿\u0001X\u0080\u000e¢\u0006\u0019\n\u0000\u0012\u0005\bÀ\u0001\u0010A\u001a\u0006\bÁ\u0001\u0010Â\u0001\"\u0006\bÃ\u0001\u0010Ä\u0001R)\u0010Å\u0001\u001a\u0005\u0018\u00010Æ\u0001X\u0080\u000e¢\u0006\u0019\n\u0000\u0012\u0005\bÇ\u0001\u0010A\u001a\u0006\bÈ\u0001\u0010É\u0001\"\u0006\bÊ\u0001\u0010Ë\u0001R\"\u0010Ì\u0001\u001a\u0005\u0018\u00010Í\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\bÎ\u0001\u0010Ï\u0001\"\u0006\bÐ\u0001\u0010Ñ\u0001R\u001f\u0010Ò\u0001\u001a\u0004\u0018\u00010-X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\bÓ\u0001\u0010/\"\u0005\bÔ\u0001\u00101R\"\u0010Õ\u0001\u001a\u0005\u0018\u00010Ö\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\b×\u0001\u0010Ø\u0001\"\u0006\bÙ\u0001\u0010Ú\u0001R\u001f\u0010Û\u0001\u001a\u0004\u0018\u000103X\u0080\u000e¢\u0006\u0010\n\u0000\u001a\u0005\bÜ\u0001\u00105\"\u0005\bÝ\u0001\u00107R\"\u0010Þ\u0001\u001a\u0005\u0018\u00010³\u0001X\u0080\u000e¢\u0006\u0012\n\u0000\u001a\u0006\bß\u0001\u0010µ\u0001\"\u0006\bà\u0001\u0010·\u0001R)\u0010á\u0001\u001a\u0005\u0018\u00010â\u0001X\u0080\u000e¢\u0006\u0019\n\u0000\u0012\u0005\bã\u0001\u0010A\u001a\u0006\bä\u0001\u0010å\u0001\"\u0006\bæ\u0001\u0010ç\u0001R&\u0010è\u0001\u001a\u0004\u0018\u00010?X\u0080\u000e¢\u0006\u0017\n\u0000\u0012\u0005\bé\u0001\u0010A\u001a\u0005\bê\u0001\u0010C\"\u0005\bë\u0001\u0010ER\u001a\u0010\u0019\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bì\u0001\u0010*R\u001a\u0010\u001b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bí\u0001\u0010*R\u001a\u0010\u0018\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bî\u0001\u0010*R\u001a\u0010\u0007\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bï\u0001\u0010*R\u001a\u0010\u0017\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bð\u0001\u0010*R\u001a\u0010\u0011\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bñ\u0001\u0010*R\u001a\u0010\u001a\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bò\u0001\u0010*R\u001a\u0010\u001c\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bó\u0001\u0010*R\u001a\u0010\u0004\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bô\u0001\u0010*R\u001a\u0010\u0006\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bõ\u0001\u0010*R\u001a\u0010\t\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bö\u0001\u0010*R\u001a\u0010\u000b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b÷\u0001\u0010*R\u001a\u0010\u0013\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bø\u0001\u0010*R\u001a\u0010\u0015\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bù\u0001\u0010*R\u001a\u0010\r\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bú\u0001\u0010*R\u001a\u0010\u000f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bû\u0001\u0010*R\u001a\u0010\u001d\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bü\u0001\u0010*R\u001a\u0010\u001e\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bý\u0001\u0010*R\u001a\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bþ\u0001\u0010*R\u001a\u0010\u0005\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\bÿ\u0001\u0010*R\u001a\u0010\u001f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0080\u0002\u0010*R\u001a\u0010\b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0081\u0002\u0010*R\u001a\u0010\n\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0082\u0002\u0010*R\u001a\u0010\u0012\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0083\u0002\u0010*R\u001a\u0010!\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0084\u0002\u0010*R\u001a\u0010#\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0085\u0002\u0010*R\u001a\u0010$\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0086\u0002\u0010*R\u001a\u0010%\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0087\u0002\u0010*R\u001a\u0010&\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0088\u0002\u0010*R\u001a\u0010'\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u0089\u0002\u0010*R\u001a\u0010\"\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u008a\u0002\u0010*R\u001a\u0010\u0016\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u008b\u0002\u0010*R\u001a\u0010\u0014\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u008c\u0002\u0010*R\u001a\u0010\f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u008d\u0002\u0010*R\u001a\u0010\u000e\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\u000b\n\u0002\u0010+\u001a\u0005\b\u008e\u0002\u0010*\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0096\u0002"}, d2 = {"Landroidx/compose/material3/ColorScheme;", "", "primary", "Landroidx/compose/ui/graphics/Color;", "onPrimary", "primaryContainer", "onPrimaryContainer", "inversePrimary", "secondary", "onSecondary", "secondaryContainer", "onSecondaryContainer", "tertiary", "onTertiary", "tertiaryContainer", "onTertiaryContainer", "background", "onBackground", "surface", "onSurface", "surfaceVariant", "onSurfaceVariant", "surfaceTint", "inverseSurface", "inverseOnSurface", "error", "onError", "errorContainer", "onErrorContainer", "outline", "outlineVariant", "scrim", "(JJJJJJJJJJJJJJJJJJJJJJJJJJJJJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "surfaceBright", "surfaceDim", "surfaceContainer", "surfaceContainerHigh", "surfaceContainerHighest", "surfaceContainerLow", "surfaceContainerLowest", "(JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getBackground-0d7_KjU", "()J", "J", "defaultAssistChipColorsCached", "Landroidx/compose/material3/ChipColors;", "getDefaultAssistChipColorsCached$material3_release", "()Landroidx/compose/material3/ChipColors;", "setDefaultAssistChipColorsCached$material3_release", "(Landroidx/compose/material3/ChipColors;)V", "defaultButtonColorsCached", "Landroidx/compose/material3/ButtonColors;", "getDefaultButtonColorsCached$material3_release", "()Landroidx/compose/material3/ButtonColors;", "setDefaultButtonColorsCached$material3_release", "(Landroidx/compose/material3/ButtonColors;)V", "defaultCardColorsCached", "Landroidx/compose/material3/CardColors;", "getDefaultCardColorsCached$material3_release", "()Landroidx/compose/material3/CardColors;", "setDefaultCardColorsCached$material3_release", "(Landroidx/compose/material3/CardColors;)V", "defaultCenterAlignedTopAppBarColorsCached", "Landroidx/compose/material3/TopAppBarColors;", "getDefaultCenterAlignedTopAppBarColorsCached$material3_release$annotations", "()V", "getDefaultCenterAlignedTopAppBarColorsCached$material3_release", "()Landroidx/compose/material3/TopAppBarColors;", "setDefaultCenterAlignedTopAppBarColorsCached$material3_release", "(Landroidx/compose/material3/TopAppBarColors;)V", "defaultCheckboxColorsCached", "Landroidx/compose/material3/CheckboxColors;", "getDefaultCheckboxColorsCached$material3_release", "()Landroidx/compose/material3/CheckboxColors;", "setDefaultCheckboxColorsCached$material3_release", "(Landroidx/compose/material3/CheckboxColors;)V", "defaultDatePickerColorsCached", "Landroidx/compose/material3/DatePickerColors;", "getDefaultDatePickerColorsCached$material3_release$annotations", "getDefaultDatePickerColorsCached$material3_release", "()Landroidx/compose/material3/DatePickerColors;", "setDefaultDatePickerColorsCached$material3_release", "(Landroidx/compose/material3/DatePickerColors;)V", "defaultElevatedAssistChipColorsCached", "getDefaultElevatedAssistChipColorsCached$material3_release", "setDefaultElevatedAssistChipColorsCached$material3_release", "defaultElevatedButtonColorsCached", "getDefaultElevatedButtonColorsCached$material3_release", "setDefaultElevatedButtonColorsCached$material3_release", "defaultElevatedCardColorsCached", "getDefaultElevatedCardColorsCached$material3_release", "setDefaultElevatedCardColorsCached$material3_release", "defaultElevatedFilterChipColorsCached", "Landroidx/compose/material3/SelectableChipColors;", "getDefaultElevatedFilterChipColorsCached$material3_release", "()Landroidx/compose/material3/SelectableChipColors;", "setDefaultElevatedFilterChipColorsCached$material3_release", "(Landroidx/compose/material3/SelectableChipColors;)V", "defaultElevatedSuggestionChipColorsCached", "getDefaultElevatedSuggestionChipColorsCached$material3_release", "setDefaultElevatedSuggestionChipColorsCached$material3_release", "defaultExpressiveNavigationBarItemColorsCached", "Landroidx/compose/material3/NavigationItemColors;", "getDefaultExpressiveNavigationBarItemColorsCached$material3_release", "()Landroidx/compose/material3/NavigationItemColors;", "setDefaultExpressiveNavigationBarItemColorsCached$material3_release", "(Landroidx/compose/material3/NavigationItemColors;)V", "defaultFilledIconButtonColorsCached", "Landroidx/compose/material3/IconButtonColors;", "getDefaultFilledIconButtonColorsCached$material3_release", "()Landroidx/compose/material3/IconButtonColors;", "setDefaultFilledIconButtonColorsCached$material3_release", "(Landroidx/compose/material3/IconButtonColors;)V", "defaultFilledIconToggleButtonColorsCached", "Landroidx/compose/material3/IconToggleButtonColors;", "getDefaultFilledIconToggleButtonColorsCached$material3_release", "()Landroidx/compose/material3/IconToggleButtonColors;", "setDefaultFilledIconToggleButtonColorsCached$material3_release", "(Landroidx/compose/material3/IconToggleButtonColors;)V", "defaultFilledTonalButtonColorsCached", "getDefaultFilledTonalButtonColorsCached$material3_release", "setDefaultFilledTonalButtonColorsCached$material3_release", "defaultFilledTonalIconButtonColorsCached", "getDefaultFilledTonalIconButtonColorsCached$material3_release", "setDefaultFilledTonalIconButtonColorsCached$material3_release", "defaultFilledTonalIconToggleButtonColorsCached", "getDefaultFilledTonalIconToggleButtonColorsCached$material3_release", "setDefaultFilledTonalIconToggleButtonColorsCached$material3_release", "defaultFilterChipColorsCached", "getDefaultFilterChipColorsCached$material3_release", "setDefaultFilterChipColorsCached$material3_release", "defaultIconButtonColorsCached", "getDefaultIconButtonColorsCached$material3_release", "setDefaultIconButtonColorsCached$material3_release", "defaultIconToggleButtonColorsCached", "getDefaultIconToggleButtonColorsCached$material3_release", "setDefaultIconToggleButtonColorsCached$material3_release", "defaultInputChipColorsCached", "getDefaultInputChipColorsCached$material3_release", "setDefaultInputChipColorsCached$material3_release", "defaultLargeTopAppBarColorsCached", "getDefaultLargeTopAppBarColorsCached$material3_release$annotations", "getDefaultLargeTopAppBarColorsCached$material3_release", "setDefaultLargeTopAppBarColorsCached$material3_release", "defaultMediumTopAppBarColorsCached", "getDefaultMediumTopAppBarColorsCached$material3_release$annotations", "getDefaultMediumTopAppBarColorsCached$material3_release", "setDefaultMediumTopAppBarColorsCached$material3_release", "defaultMenuItemColorsCached", "Landroidx/compose/material3/MenuItemColors;", "getDefaultMenuItemColorsCached$material3_release", "()Landroidx/compose/material3/MenuItemColors;", "setDefaultMenuItemColorsCached$material3_release", "(Landroidx/compose/material3/MenuItemColors;)V", "defaultNavigationBarItemColorsCached", "Landroidx/compose/material3/NavigationBarItemColors;", "getDefaultNavigationBarItemColorsCached$material3_release", "()Landroidx/compose/material3/NavigationBarItemColors;", "setDefaultNavigationBarItemColorsCached$material3_release", "(Landroidx/compose/material3/NavigationBarItemColors;)V", "defaultNavigationRailItemColorsCached", "Landroidx/compose/material3/NavigationRailItemColors;", "getDefaultNavigationRailItemColorsCached$material3_release", "()Landroidx/compose/material3/NavigationRailItemColors;", "setDefaultNavigationRailItemColorsCached$material3_release", "(Landroidx/compose/material3/NavigationRailItemColors;)V", "defaultOutlinedButtonColorsCached", "getDefaultOutlinedButtonColorsCached$material3_release", "setDefaultOutlinedButtonColorsCached$material3_release", "defaultOutlinedCardColorsCached", "getDefaultOutlinedCardColorsCached$material3_release", "setDefaultOutlinedCardColorsCached$material3_release", "defaultOutlinedIconButtonColorsCached", "getDefaultOutlinedIconButtonColorsCached$material3_release", "setDefaultOutlinedIconButtonColorsCached$material3_release", "defaultOutlinedIconToggleButtonColorsCached", "getDefaultOutlinedIconToggleButtonColorsCached$material3_release", "setDefaultOutlinedIconToggleButtonColorsCached$material3_release", "defaultOutlinedTextFieldColorsCached", "Landroidx/compose/material3/TextFieldColors;", "getDefaultOutlinedTextFieldColorsCached$material3_release", "()Landroidx/compose/material3/TextFieldColors;", "setDefaultOutlinedTextFieldColorsCached$material3_release", "(Landroidx/compose/material3/TextFieldColors;)V", "defaultRadioButtonColorsCached", "Landroidx/compose/material3/RadioButtonColors;", "getDefaultRadioButtonColorsCached$material3_release", "()Landroidx/compose/material3/RadioButtonColors;", "setDefaultRadioButtonColorsCached$material3_release", "(Landroidx/compose/material3/RadioButtonColors;)V", "defaultRichTooltipColorsCached", "Landroidx/compose/material3/RichTooltipColors;", "getDefaultRichTooltipColorsCached$material3_release$annotations", "getDefaultRichTooltipColorsCached$material3_release", "()Landroidx/compose/material3/RichTooltipColors;", "setDefaultRichTooltipColorsCached$material3_release", "(Landroidx/compose/material3/RichTooltipColors;)V", "defaultSegmentedButtonColorsCached", "Landroidx/compose/material3/SegmentedButtonColors;", "getDefaultSegmentedButtonColorsCached$material3_release$annotations", "getDefaultSegmentedButtonColorsCached$material3_release", "()Landroidx/compose/material3/SegmentedButtonColors;", "setDefaultSegmentedButtonColorsCached$material3_release", "(Landroidx/compose/material3/SegmentedButtonColors;)V", "defaultSliderColorsCached", "Landroidx/compose/material3/SliderColors;", "getDefaultSliderColorsCached$material3_release", "()Landroidx/compose/material3/SliderColors;", "setDefaultSliderColorsCached$material3_release", "(Landroidx/compose/material3/SliderColors;)V", "defaultSuggestionChipColorsCached", "getDefaultSuggestionChipColorsCached$material3_release", "setDefaultSuggestionChipColorsCached$material3_release", "defaultSwitchColorsCached", "Landroidx/compose/material3/SwitchColors;", "getDefaultSwitchColorsCached$material3_release", "()Landroidx/compose/material3/SwitchColors;", "setDefaultSwitchColorsCached$material3_release", "(Landroidx/compose/material3/SwitchColors;)V", "defaultTextButtonColorsCached", "getDefaultTextButtonColorsCached$material3_release", "setDefaultTextButtonColorsCached$material3_release", "defaultTextFieldColorsCached", "getDefaultTextFieldColorsCached$material3_release", "setDefaultTextFieldColorsCached$material3_release", "defaultTimePickerColorsCached", "Landroidx/compose/material3/TimePickerColors;", "getDefaultTimePickerColorsCached$material3_release$annotations", "getDefaultTimePickerColorsCached$material3_release", "()Landroidx/compose/material3/TimePickerColors;", "setDefaultTimePickerColorsCached$material3_release", "(Landroidx/compose/material3/TimePickerColors;)V", "defaultTopAppBarColorsCached", "getDefaultTopAppBarColorsCached$material3_release$annotations", "getDefaultTopAppBarColorsCached$material3_release", "setDefaultTopAppBarColorsCached$material3_release", "getError-0d7_KjU", "getErrorContainer-0d7_KjU", "getInverseOnSurface-0d7_KjU", "getInversePrimary-0d7_KjU", "getInverseSurface-0d7_KjU", "getOnBackground-0d7_KjU", "getOnError-0d7_KjU", "getOnErrorContainer-0d7_KjU", "getOnPrimary-0d7_KjU", "getOnPrimaryContainer-0d7_KjU", "getOnSecondary-0d7_KjU", "getOnSecondaryContainer-0d7_KjU", "getOnSurface-0d7_KjU", "getOnSurfaceVariant-0d7_KjU", "getOnTertiary-0d7_KjU", "getOnTertiaryContainer-0d7_KjU", "getOutline-0d7_KjU", "getOutlineVariant-0d7_KjU", "getPrimary-0d7_KjU", "getPrimaryContainer-0d7_KjU", "getScrim-0d7_KjU", "getSecondary-0d7_KjU", "getSecondaryContainer-0d7_KjU", "getSurface-0d7_KjU", "getSurfaceBright-0d7_KjU", "getSurfaceContainer-0d7_KjU", "getSurfaceContainerHigh-0d7_KjU", "getSurfaceContainerHighest-0d7_KjU", "getSurfaceContainerLow-0d7_KjU", "getSurfaceContainerLowest-0d7_KjU", "getSurfaceDim-0d7_KjU", "getSurfaceTint-0d7_KjU", "getSurfaceVariant-0d7_KjU", "getTertiary-0d7_KjU", "getTertiaryContainer-0d7_KjU", "copy", "copy-G1PFc-w", "(JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ)Landroidx/compose/material3/ColorScheme;", "copy-C-Xl9yA", "(JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ)Landroidx/compose/material3/ColorScheme;", "toString", "", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ColorScheme {
    public static final int $stable = 0;
    private final long background;
    private ChipColors defaultAssistChipColorsCached;
    private ButtonColors defaultButtonColorsCached;
    private CardColors defaultCardColorsCached;
    private TopAppBarColors defaultCenterAlignedTopAppBarColorsCached;
    private CheckboxColors defaultCheckboxColorsCached;
    private DatePickerColors defaultDatePickerColorsCached;
    private ChipColors defaultElevatedAssistChipColorsCached;
    private ButtonColors defaultElevatedButtonColorsCached;
    private CardColors defaultElevatedCardColorsCached;
    private SelectableChipColors defaultElevatedFilterChipColorsCached;
    private ChipColors defaultElevatedSuggestionChipColorsCached;
    private NavigationItemColors defaultExpressiveNavigationBarItemColorsCached;
    private IconButtonColors defaultFilledIconButtonColorsCached;
    private IconToggleButtonColors defaultFilledIconToggleButtonColorsCached;
    private ButtonColors defaultFilledTonalButtonColorsCached;
    private IconButtonColors defaultFilledTonalIconButtonColorsCached;
    private IconToggleButtonColors defaultFilledTonalIconToggleButtonColorsCached;
    private SelectableChipColors defaultFilterChipColorsCached;
    private IconButtonColors defaultIconButtonColorsCached;
    private IconToggleButtonColors defaultIconToggleButtonColorsCached;
    private SelectableChipColors defaultInputChipColorsCached;
    private TopAppBarColors defaultLargeTopAppBarColorsCached;
    private TopAppBarColors defaultMediumTopAppBarColorsCached;
    private MenuItemColors defaultMenuItemColorsCached;
    private NavigationBarItemColors defaultNavigationBarItemColorsCached;
    private NavigationRailItemColors defaultNavigationRailItemColorsCached;
    private ButtonColors defaultOutlinedButtonColorsCached;
    private CardColors defaultOutlinedCardColorsCached;
    private IconButtonColors defaultOutlinedIconButtonColorsCached;
    private IconToggleButtonColors defaultOutlinedIconToggleButtonColorsCached;
    private TextFieldColors defaultOutlinedTextFieldColorsCached;
    private RadioButtonColors defaultRadioButtonColorsCached;
    private RichTooltipColors defaultRichTooltipColorsCached;
    private SegmentedButtonColors defaultSegmentedButtonColorsCached;
    private SliderColors defaultSliderColorsCached;
    private ChipColors defaultSuggestionChipColorsCached;
    private SwitchColors defaultSwitchColorsCached;
    private ButtonColors defaultTextButtonColorsCached;
    private TextFieldColors defaultTextFieldColorsCached;
    private TimePickerColors defaultTimePickerColorsCached;
    private TopAppBarColors defaultTopAppBarColorsCached;
    private final long error;
    private final long errorContainer;
    private final long inverseOnSurface;
    private final long inversePrimary;
    private final long inverseSurface;
    private final long onBackground;
    private final long onError;
    private final long onErrorContainer;
    private final long onPrimary;
    private final long onPrimaryContainer;
    private final long onSecondary;
    private final long onSecondaryContainer;
    private final long onSurface;
    private final long onSurfaceVariant;
    private final long onTertiary;
    private final long onTertiaryContainer;
    private final long outline;
    private final long outlineVariant;
    private final long primary;
    private final long primaryContainer;
    private final long scrim;
    private final long secondary;
    private final long secondaryContainer;
    private final long surface;
    private final long surfaceBright;
    private final long surfaceContainer;
    private final long surfaceContainerHigh;
    private final long surfaceContainerHighest;
    private final long surfaceContainerLow;
    private final long surfaceContainerLowest;
    private final long surfaceDim;
    private final long surfaceTint;
    private final long surfaceVariant;
    private final long tertiary;
    private final long tertiaryContainer;

    public ColorScheme(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15, j16, j17, j18, j19, j20, j21, j22, j23, j24, j25, j26, j27, j28, j29, j30, j31, j32, j33, j34, j35, j36);
    }

    @Deprecated(level = DeprecationLevel.WARNING, message = "Use constructor with additional 'surfaceContainer' roles.", replaceWith = @ReplaceWith(expression = "ColorScheme(primary,\nonPrimary,\nprimaryContainer,\nonPrimaryContainer,\ninversePrimary,\nsecondary,\nonSecondary,\nsecondaryContainer,\nonSecondaryContainer,\ntertiary,\nonTertiary,\ntertiaryContainer,\nonTertiaryContainer,\nbackground,\nonBackground,\nsurface,\nonSurface,\nsurfaceVariant,\nonSurfaceVariant,\nsurfaceTint,\ninverseSurface,\ninverseOnSurface,\nerror,\nonError,\nerrorContainer,\nonErrorContainer,\noutline,\noutlineVariant,\nscrim,\nsurfaceBright,\nsurfaceDim,\nsurfaceContainer,\nsurfaceContainerHigh,\nsurfaceContainerHighest,\nsurfaceContainerLow,\nsurfaceContainerLowest,)", imports = {}))
    public ColorScheme(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15, j16, j17, j18, j19, j20, j21, j22, j23, j24, j25, j26, j27, j28, j29);
    }

    public static void m83x47b39765() {
    }

    public static void getDefaultDatePickerColorsCached$material3_release$annotations() {
    }

    public static void m84xb8636ff9() {
    }

    public static void m85xe7680889() {
    }

    public static void getDefaultRichTooltipColorsCached$material3_release$annotations() {
    }

    public static void m86xc0225afb() {
    }

    public static void getDefaultTimePickerColorsCached$material3_release$annotations() {
    }

    public static void getDefaultTopAppBarColorsCached$material3_release$annotations() {
    }

    private ColorScheme(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36) {
        this.primary = j;
        this.onPrimary = j2;
        this.primaryContainer = j3;
        this.onPrimaryContainer = j4;
        this.inversePrimary = j5;
        this.secondary = j6;
        this.onSecondary = j7;
        this.secondaryContainer = j8;
        this.onSecondaryContainer = j9;
        this.tertiary = j10;
        this.onTertiary = j11;
        this.tertiaryContainer = j12;
        this.onTertiaryContainer = j13;
        this.background = j14;
        this.onBackground = j15;
        this.surface = j16;
        this.onSurface = j17;
        this.surfaceVariant = j18;
        this.onSurfaceVariant = j19;
        this.surfaceTint = j20;
        this.inverseSurface = j21;
        this.inverseOnSurface = j22;
        this.error = j23;
        this.onError = j24;
        this.errorContainer = j25;
        this.onErrorContainer = j26;
        this.outline = j27;
        this.outlineVariant = j28;
        this.scrim = j29;
        this.surfaceBright = j30;
        this.surfaceDim = j31;
        this.surfaceContainer = j32;
        this.surfaceContainerHigh = j33;
        this.surfaceContainerHighest = j34;
        this.surfaceContainerLow = j35;
        this.surfaceContainerLowest = j36;
    }

    public final long getPrimary() {
        return this.primary;
    }

    public final long getOnPrimary() {
        return this.onPrimary;
    }

    public final long getPrimaryContainer() {
        return this.primaryContainer;
    }

    public final long getOnPrimaryContainer() {
        return this.onPrimaryContainer;
    }

    public final long getInversePrimary() {
        return this.inversePrimary;
    }

    public final long getSecondary() {
        return this.secondary;
    }

    public final long getOnSecondary() {
        return this.onSecondary;
    }

    public final long getSecondaryContainer() {
        return this.secondaryContainer;
    }

    public final long getOnSecondaryContainer() {
        return this.onSecondaryContainer;
    }

    public final long getTertiary() {
        return this.tertiary;
    }

    public final long getOnTertiary() {
        return this.onTertiary;
    }

    public final long getTertiaryContainer() {
        return this.tertiaryContainer;
    }

    public final long getOnTertiaryContainer() {
        return this.onTertiaryContainer;
    }

    public final long getBackground() {
        return this.background;
    }

    public final long getOnBackground() {
        return this.onBackground;
    }

    public final long getSurface() {
        return this.surface;
    }

    public final long getOnSurface() {
        return this.onSurface;
    }

    public final long getSurfaceVariant() {
        return this.surfaceVariant;
    }

    public final long getOnSurfaceVariant() {
        return this.onSurfaceVariant;
    }

    public final long getSurfaceTint() {
        return this.surfaceTint;
    }

    public final long getInverseSurface() {
        return this.inverseSurface;
    }

    public final long getInverseOnSurface() {
        return this.inverseOnSurface;
    }

    public final long getError() {
        return this.error;
    }

    public final long getOnError() {
        return this.onError;
    }

    public final long getErrorContainer() {
        return this.errorContainer;
    }

    public final long getOnErrorContainer() {
        return this.onErrorContainer;
    }

    public final long getOutline() {
        return this.outline;
    }

    public final long getOutlineVariant() {
        return this.outlineVariant;
    }

    public final long getScrim() {
        return this.scrim;
    }

    public final long getSurfaceBright() {
        return this.surfaceBright;
    }

    public final long getSurfaceDim() {
        return this.surfaceDim;
    }

    public final long getSurfaceContainer() {
        return this.surfaceContainer;
    }

    public final long getSurfaceContainerHigh() {
        return this.surfaceContainerHigh;
    }

    public final long getSurfaceContainerHighest() {
        return this.surfaceContainerHighest;
    }

    public final long getSurfaceContainerLow() {
        return this.surfaceContainerLow;
    }

    public final long getSurfaceContainerLowest() {
        return this.surfaceContainerLowest;
    }

    private ColorScheme(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29) {
        this(j, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15, j16, j17, j18, j19, j20, j21, j22, j23, j24, j25, j26, j27, j28, j29, Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), Color.INSTANCE.m4626getUnspecified0d7_KjU(), null);
    }

    public static ColorScheme m2131copyCXl9yA$default(ColorScheme colorScheme, long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36, int i, int i2, Object obj) {
        return colorScheme.m2133copyCXl9yA((i & 1) != 0 ? colorScheme.primary : j, (i & 2) != 0 ? colorScheme.onPrimary : j2, (i & 4) != 0 ? colorScheme.primaryContainer : j3, (i & 8) != 0 ? colorScheme.onPrimaryContainer : j4, (i & 16) != 0 ? colorScheme.inversePrimary : j5, (i & 32) != 0 ? colorScheme.secondary : j6, (i & 64) != 0 ? colorScheme.onSecondary : j7, (i & Fields.SpotShadowColor) != 0 ? colorScheme.secondaryContainer : j8, (i & Fields.RotationX) != 0 ? colorScheme.onSecondaryContainer : j9, (i & Fields.RotationY) != 0 ? colorScheme.tertiary : j10, (i & Fields.RotationZ) != 0 ? colorScheme.onTertiary : j11, (i & Fields.CameraDistance) != 0 ? colorScheme.tertiaryContainer : j12, (i & Fields.TransformOrigin) != 0 ? colorScheme.onTertiaryContainer : j13, (i & Fields.Shape) != 0 ? colorScheme.background : j14, (i & Fields.Clip) != 0 ? colorScheme.onBackground : j15, (i & Fields.CompositingStrategy) != 0 ? colorScheme.surface : j16, (i & 65536) != 0 ? colorScheme.onSurface : j17, (i & Fields.RenderEffect) != 0 ? colorScheme.surfaceVariant : j18, (i & 262144) != 0 ? colorScheme.onSurfaceVariant : j19, (i & 524288) != 0 ? colorScheme.surfaceTint : j20, (i & 1048576) != 0 ? colorScheme.inverseSurface : j21, (i & 2097152) != 0 ? colorScheme.inverseOnSurface : j22, (i & 4194304) != 0 ? colorScheme.error : j23, (i & 8388608) != 0 ? colorScheme.onError : j24, (i & 16777216) != 0 ? colorScheme.errorContainer : j25, (i & 33554432) != 0 ? colorScheme.onErrorContainer : j26, (i & 67108864) != 0 ? colorScheme.outline : j27, (i & 134217728) != 0 ? colorScheme.outlineVariant : j28, (i & 268435456) != 0 ? colorScheme.scrim : j29, (i & 536870912) != 0 ? colorScheme.surfaceBright : j30, (i & 1073741824) != 0 ? colorScheme.surfaceDim : j31, (i & Integer.MIN_VALUE) != 0 ? colorScheme.surfaceContainer : j32, (i2 & 1) != 0 ? colorScheme.surfaceContainerHigh : j33, (i2 & 2) != 0 ? colorScheme.surfaceContainerHighest : j34, (i2 & 4) != 0 ? colorScheme.surfaceContainerLow : j35, (i2 & 8) != 0 ? colorScheme.surfaceContainerLowest : j36);
    }

    public final ColorScheme m2133copyCXl9yA(long primary, long onPrimary, long primaryContainer, long onPrimaryContainer, long inversePrimary, long secondary, long onSecondary, long secondaryContainer, long onSecondaryContainer, long tertiary, long onTertiary, long tertiaryContainer, long onTertiaryContainer, long background, long onBackground, long surface, long onSurface, long surfaceVariant, long onSurfaceVariant, long surfaceTint, long inverseSurface, long inverseOnSurface, long error, long onError, long errorContainer, long onErrorContainer, long outline, long outlineVariant, long scrim, long surfaceBright, long surfaceDim, long surfaceContainer, long surfaceContainerHigh, long surfaceContainerHighest, long surfaceContainerLow, long surfaceContainerLowest) {
        return new ColorScheme(primary, onPrimary, primaryContainer, onPrimaryContainer, inversePrimary, secondary, onSecondary, secondaryContainer, onSecondaryContainer, tertiary, onTertiary, tertiaryContainer, onTertiaryContainer, background, onBackground, surface, onSurface, surfaceVariant, onSurfaceVariant, surfaceTint, inverseSurface, inverseOnSurface, error, onError, errorContainer, onErrorContainer, outline, outlineVariant, scrim, surfaceBright, surfaceDim, surfaceContainer, surfaceContainerHigh, surfaceContainerHighest, surfaceContainerLow, surfaceContainerLowest, null);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "Maintained for binary compatibility. Use overload with additional surface roles instead")
    public final ColorScheme m2134copyG1PFcw(long primary, long onPrimary, long primaryContainer, long onPrimaryContainer, long inversePrimary, long secondary, long onSecondary, long secondaryContainer, long onSecondaryContainer, long tertiary, long onTertiary, long tertiaryContainer, long onTertiaryContainer, long background, long onBackground, long surface, long onSurface, long surfaceVariant, long onSurfaceVariant, long surfaceTint, long inverseSurface, long inverseOnSurface, long error, long onError, long errorContainer, long onErrorContainer, long outline, long outlineVariant, long scrim) {
        return m2131copyCXl9yA$default(this, primary, onPrimary, primaryContainer, onPrimaryContainer, inversePrimary, secondary, onSecondary, secondaryContainer, onSecondaryContainer, tertiary, onTertiary, tertiaryContainer, onTertiaryContainer, background, onBackground, surface, onSurface, surfaceVariant, onSurfaceVariant, surfaceTint, inverseSurface, inverseOnSurface, error, onError, errorContainer, onErrorContainer, outline, outlineVariant, scrim, 0L, 0L, 0L, 0L, 0L, 0L, 0L, -536870912, 15, null);
    }

    public String toString() {
        return "ColorScheme(primary=" + ((Object) Color.m4598toStringimpl(this.primary)) + "onPrimary=" + ((Object) Color.m4598toStringimpl(this.onPrimary)) + "primaryContainer=" + ((Object) Color.m4598toStringimpl(this.primaryContainer)) + "onPrimaryContainer=" + ((Object) Color.m4598toStringimpl(this.onPrimaryContainer)) + "inversePrimary=" + ((Object) Color.m4598toStringimpl(this.inversePrimary)) + "secondary=" + ((Object) Color.m4598toStringimpl(this.secondary)) + "onSecondary=" + ((Object) Color.m4598toStringimpl(this.onSecondary)) + "secondaryContainer=" + ((Object) Color.m4598toStringimpl(this.secondaryContainer)) + "onSecondaryContainer=" + ((Object) Color.m4598toStringimpl(this.onSecondaryContainer)) + "tertiary=" + ((Object) Color.m4598toStringimpl(this.tertiary)) + "onTertiary=" + ((Object) Color.m4598toStringimpl(this.onTertiary)) + "tertiaryContainer=" + ((Object) Color.m4598toStringimpl(this.tertiaryContainer)) + "onTertiaryContainer=" + ((Object) Color.m4598toStringimpl(this.onTertiaryContainer)) + "background=" + ((Object) Color.m4598toStringimpl(this.background)) + "onBackground=" + ((Object) Color.m4598toStringimpl(this.onBackground)) + "surface=" + ((Object) Color.m4598toStringimpl(this.surface)) + "onSurface=" + ((Object) Color.m4598toStringimpl(this.onSurface)) + "surfaceVariant=" + ((Object) Color.m4598toStringimpl(this.surfaceVariant)) + "onSurfaceVariant=" + ((Object) Color.m4598toStringimpl(this.onSurfaceVariant)) + "surfaceTint=" + ((Object) Color.m4598toStringimpl(this.surfaceTint)) + "inverseSurface=" + ((Object) Color.m4598toStringimpl(this.inverseSurface)) + "inverseOnSurface=" + ((Object) Color.m4598toStringimpl(this.inverseOnSurface)) + "error=" + ((Object) Color.m4598toStringimpl(this.error)) + "onError=" + ((Object) Color.m4598toStringimpl(this.onError)) + "errorContainer=" + ((Object) Color.m4598toStringimpl(this.errorContainer)) + "onErrorContainer=" + ((Object) Color.m4598toStringimpl(this.onErrorContainer)) + "outline=" + ((Object) Color.m4598toStringimpl(this.outline)) + "outlineVariant=" + ((Object) Color.m4598toStringimpl(this.outlineVariant)) + "scrim=" + ((Object) Color.m4598toStringimpl(this.scrim)) + "surfaceBright=" + ((Object) Color.m4598toStringimpl(this.surfaceBright)) + "surfaceDim=" + ((Object) Color.m4598toStringimpl(this.surfaceDim)) + "surfaceContainer=" + ((Object) Color.m4598toStringimpl(this.surfaceContainer)) + "surfaceContainerHigh=" + ((Object) Color.m4598toStringimpl(this.surfaceContainerHigh)) + "surfaceContainerHighest=" + ((Object) Color.m4598toStringimpl(this.surfaceContainerHighest)) + "surfaceContainerLow=" + ((Object) Color.m4598toStringimpl(this.surfaceContainerLow)) + "surfaceContainerLowest=" + ((Object) Color.m4598toStringimpl(this.surfaceContainerLowest)) + ')';
    }

    public final ButtonColors getDefaultButtonColorsCached() {
        return this.defaultButtonColorsCached;
    }

    public final void setDefaultButtonColorsCached$material3_release(ButtonColors buttonColors) {
        this.defaultButtonColorsCached = buttonColors;
    }

    public final ButtonColors getDefaultElevatedButtonColorsCached() {
        return this.defaultElevatedButtonColorsCached;
    }

    public final void setDefaultElevatedButtonColorsCached$material3_release(ButtonColors buttonColors) {
        this.defaultElevatedButtonColorsCached = buttonColors;
    }

    public final ButtonColors getDefaultFilledTonalButtonColorsCached() {
        return this.defaultFilledTonalButtonColorsCached;
    }

    public final void setDefaultFilledTonalButtonColorsCached$material3_release(ButtonColors buttonColors) {
        this.defaultFilledTonalButtonColorsCached = buttonColors;
    }

    public final ButtonColors getDefaultOutlinedButtonColorsCached() {
        return this.defaultOutlinedButtonColorsCached;
    }

    public final void setDefaultOutlinedButtonColorsCached$material3_release(ButtonColors buttonColors) {
        this.defaultOutlinedButtonColorsCached = buttonColors;
    }

    public final ButtonColors getDefaultTextButtonColorsCached() {
        return this.defaultTextButtonColorsCached;
    }

    public final void setDefaultTextButtonColorsCached$material3_release(ButtonColors buttonColors) {
        this.defaultTextButtonColorsCached = buttonColors;
    }

    public final CardColors getDefaultCardColorsCached() {
        return this.defaultCardColorsCached;
    }

    public final void setDefaultCardColorsCached$material3_release(CardColors cardColors) {
        this.defaultCardColorsCached = cardColors;
    }

    public final CardColors getDefaultElevatedCardColorsCached() {
        return this.defaultElevatedCardColorsCached;
    }

    public final void setDefaultElevatedCardColorsCached$material3_release(CardColors cardColors) {
        this.defaultElevatedCardColorsCached = cardColors;
    }

    public final CardColors getDefaultOutlinedCardColorsCached() {
        return this.defaultOutlinedCardColorsCached;
    }

    public final void setDefaultOutlinedCardColorsCached$material3_release(CardColors cardColors) {
        this.defaultOutlinedCardColorsCached = cardColors;
    }

    public final ChipColors getDefaultAssistChipColorsCached() {
        return this.defaultAssistChipColorsCached;
    }

    public final void setDefaultAssistChipColorsCached$material3_release(ChipColors chipColors) {
        this.defaultAssistChipColorsCached = chipColors;
    }

    public final ChipColors getDefaultElevatedAssistChipColorsCached() {
        return this.defaultElevatedAssistChipColorsCached;
    }

    public final void setDefaultElevatedAssistChipColorsCached$material3_release(ChipColors chipColors) {
        this.defaultElevatedAssistChipColorsCached = chipColors;
    }

    public final ChipColors getDefaultSuggestionChipColorsCached() {
        return this.defaultSuggestionChipColorsCached;
    }

    public final void setDefaultSuggestionChipColorsCached$material3_release(ChipColors chipColors) {
        this.defaultSuggestionChipColorsCached = chipColors;
    }

    public final ChipColors getDefaultElevatedSuggestionChipColorsCached() {
        return this.defaultElevatedSuggestionChipColorsCached;
    }

    public final void setDefaultElevatedSuggestionChipColorsCached$material3_release(ChipColors chipColors) {
        this.defaultElevatedSuggestionChipColorsCached = chipColors;
    }

    public final SelectableChipColors getDefaultFilterChipColorsCached() {
        return this.defaultFilterChipColorsCached;
    }

    public final void setDefaultFilterChipColorsCached$material3_release(SelectableChipColors selectableChipColors) {
        this.defaultFilterChipColorsCached = selectableChipColors;
    }

    public final SelectableChipColors getDefaultElevatedFilterChipColorsCached() {
        return this.defaultElevatedFilterChipColorsCached;
    }

    public final void setDefaultElevatedFilterChipColorsCached$material3_release(SelectableChipColors selectableChipColors) {
        this.defaultElevatedFilterChipColorsCached = selectableChipColors;
    }

    public final SelectableChipColors getDefaultInputChipColorsCached() {
        return this.defaultInputChipColorsCached;
    }

    public final void setDefaultInputChipColorsCached$material3_release(SelectableChipColors selectableChipColors) {
        this.defaultInputChipColorsCached = selectableChipColors;
    }

    public final TopAppBarColors getDefaultTopAppBarColorsCached() {
        return this.defaultTopAppBarColorsCached;
    }

    public final void setDefaultTopAppBarColorsCached$material3_release(TopAppBarColors topAppBarColors) {
        this.defaultTopAppBarColorsCached = topAppBarColors;
    }

    public final TopAppBarColors getDefaultCenterAlignedTopAppBarColorsCached() {
        return this.defaultCenterAlignedTopAppBarColorsCached;
    }

    public final void setDefaultCenterAlignedTopAppBarColorsCached$material3_release(TopAppBarColors topAppBarColors) {
        this.defaultCenterAlignedTopAppBarColorsCached = topAppBarColors;
    }

    public final TopAppBarColors getDefaultMediumTopAppBarColorsCached() {
        return this.defaultMediumTopAppBarColorsCached;
    }

    public final void setDefaultMediumTopAppBarColorsCached$material3_release(TopAppBarColors topAppBarColors) {
        this.defaultMediumTopAppBarColorsCached = topAppBarColors;
    }

    public final TopAppBarColors getDefaultLargeTopAppBarColorsCached() {
        return this.defaultLargeTopAppBarColorsCached;
    }

    public final void setDefaultLargeTopAppBarColorsCached$material3_release(TopAppBarColors topAppBarColors) {
        this.defaultLargeTopAppBarColorsCached = topAppBarColors;
    }

    public final CheckboxColors getDefaultCheckboxColorsCached() {
        return this.defaultCheckboxColorsCached;
    }

    public final void setDefaultCheckboxColorsCached$material3_release(CheckboxColors checkboxColors) {
        this.defaultCheckboxColorsCached = checkboxColors;
    }

    public final DatePickerColors getDefaultDatePickerColorsCached() {
        return this.defaultDatePickerColorsCached;
    }

    public final void setDefaultDatePickerColorsCached$material3_release(DatePickerColors datePickerColors) {
        this.defaultDatePickerColorsCached = datePickerColors;
    }

    public final IconButtonColors getDefaultIconButtonColorsCached() {
        return this.defaultIconButtonColorsCached;
    }

    public final void setDefaultIconButtonColorsCached$material3_release(IconButtonColors iconButtonColors) {
        this.defaultIconButtonColorsCached = iconButtonColors;
    }

    public final IconToggleButtonColors getDefaultIconToggleButtonColorsCached() {
        return this.defaultIconToggleButtonColorsCached;
    }

    public final void setDefaultIconToggleButtonColorsCached$material3_release(IconToggleButtonColors iconToggleButtonColors) {
        this.defaultIconToggleButtonColorsCached = iconToggleButtonColors;
    }

    public final IconButtonColors getDefaultFilledIconButtonColorsCached() {
        return this.defaultFilledIconButtonColorsCached;
    }

    public final void setDefaultFilledIconButtonColorsCached$material3_release(IconButtonColors iconButtonColors) {
        this.defaultFilledIconButtonColorsCached = iconButtonColors;
    }

    public final IconToggleButtonColors getDefaultFilledIconToggleButtonColorsCached() {
        return this.defaultFilledIconToggleButtonColorsCached;
    }

    public final void setDefaultFilledIconToggleButtonColorsCached$material3_release(IconToggleButtonColors iconToggleButtonColors) {
        this.defaultFilledIconToggleButtonColorsCached = iconToggleButtonColors;
    }

    public final IconButtonColors getDefaultFilledTonalIconButtonColorsCached() {
        return this.defaultFilledTonalIconButtonColorsCached;
    }

    public final void setDefaultFilledTonalIconButtonColorsCached$material3_release(IconButtonColors iconButtonColors) {
        this.defaultFilledTonalIconButtonColorsCached = iconButtonColors;
    }

    public final IconToggleButtonColors getDefaultFilledTonalIconToggleButtonColorsCached() {
        return this.defaultFilledTonalIconToggleButtonColorsCached;
    }

    public final void m90xa626b4be(IconToggleButtonColors iconToggleButtonColors) {
        this.defaultFilledTonalIconToggleButtonColorsCached = iconToggleButtonColors;
    }

    public final IconButtonColors getDefaultOutlinedIconButtonColorsCached() {
        return this.defaultOutlinedIconButtonColorsCached;
    }

    public final void setDefaultOutlinedIconButtonColorsCached$material3_release(IconButtonColors iconButtonColors) {
        this.defaultOutlinedIconButtonColorsCached = iconButtonColors;
    }

    public final IconToggleButtonColors getDefaultOutlinedIconToggleButtonColorsCached() {
        return this.defaultOutlinedIconToggleButtonColorsCached;
    }

    public final void setDefaultOutlinedIconToggleButtonColorsCached$material3_release(IconToggleButtonColors iconToggleButtonColors) {
        this.defaultOutlinedIconToggleButtonColorsCached = iconToggleButtonColors;
    }

    public final MenuItemColors getDefaultMenuItemColorsCached() {
        return this.defaultMenuItemColorsCached;
    }

    public final void setDefaultMenuItemColorsCached$material3_release(MenuItemColors menuItemColors) {
        this.defaultMenuItemColorsCached = menuItemColors;
    }

    public final NavigationBarItemColors getDefaultNavigationBarItemColorsCached() {
        return this.defaultNavigationBarItemColorsCached;
    }

    public final void setDefaultNavigationBarItemColorsCached$material3_release(NavigationBarItemColors navigationBarItemColors) {
        this.defaultNavigationBarItemColorsCached = navigationBarItemColors;
    }

    public final NavigationRailItemColors getDefaultNavigationRailItemColorsCached() {
        return this.defaultNavigationRailItemColorsCached;
    }

    public final void setDefaultNavigationRailItemColorsCached$material3_release(NavigationRailItemColors navigationRailItemColors) {
        this.defaultNavigationRailItemColorsCached = navigationRailItemColors;
    }

    public final NavigationItemColors getDefaultExpressiveNavigationBarItemColorsCached() {
        return this.defaultExpressiveNavigationBarItemColorsCached;
    }

    public final void m89x8a7577ad(NavigationItemColors navigationItemColors) {
        this.defaultExpressiveNavigationBarItemColorsCached = navigationItemColors;
    }

    public final RadioButtonColors getDefaultRadioButtonColorsCached() {
        return this.defaultRadioButtonColorsCached;
    }

    public final void setDefaultRadioButtonColorsCached$material3_release(RadioButtonColors radioButtonColors) {
        this.defaultRadioButtonColorsCached = radioButtonColors;
    }

    public final SegmentedButtonColors getDefaultSegmentedButtonColorsCached() {
        return this.defaultSegmentedButtonColorsCached;
    }

    public final void setDefaultSegmentedButtonColorsCached$material3_release(SegmentedButtonColors segmentedButtonColors) {
        this.defaultSegmentedButtonColorsCached = segmentedButtonColors;
    }

    public final SliderColors getDefaultSliderColorsCached() {
        return this.defaultSliderColorsCached;
    }

    public final void setDefaultSliderColorsCached$material3_release(SliderColors sliderColors) {
        this.defaultSliderColorsCached = sliderColors;
    }

    public final SwitchColors getDefaultSwitchColorsCached() {
        return this.defaultSwitchColorsCached;
    }

    public final void setDefaultSwitchColorsCached$material3_release(SwitchColors switchColors) {
        this.defaultSwitchColorsCached = switchColors;
    }

    public final TextFieldColors getDefaultOutlinedTextFieldColorsCached() {
        return this.defaultOutlinedTextFieldColorsCached;
    }

    public final void setDefaultOutlinedTextFieldColorsCached$material3_release(TextFieldColors textFieldColors) {
        this.defaultOutlinedTextFieldColorsCached = textFieldColors;
    }

    public final TextFieldColors getDefaultTextFieldColorsCached() {
        return this.defaultTextFieldColorsCached;
    }

    public final void setDefaultTextFieldColorsCached$material3_release(TextFieldColors textFieldColors) {
        this.defaultTextFieldColorsCached = textFieldColors;
    }

    public final TimePickerColors getDefaultTimePickerColorsCached() {
        return this.defaultTimePickerColorsCached;
    }

    public final void setDefaultTimePickerColorsCached$material3_release(TimePickerColors timePickerColors) {
        this.defaultTimePickerColorsCached = timePickerColors;
    }

    public final RichTooltipColors getDefaultRichTooltipColorsCached() {
        return this.defaultRichTooltipColorsCached;
    }

    public final void setDefaultRichTooltipColorsCached$material3_release(RichTooltipColors richTooltipColors) {
        this.defaultRichTooltipColorsCached = richTooltipColors;
    }
}
