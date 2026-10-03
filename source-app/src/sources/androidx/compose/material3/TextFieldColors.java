package androidx.compose.material3;

import androidx.compose.foundation.text.selection.TextSelectionColors;
import androidx.compose.p002ui.graphics.Color;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\bQ\n\u0002\u0010\u000b\n\u0002\b\f\n\u0002\u0010\b\n\u0002\b\u0014\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0007\u0018\u00002\u00020\u0001BÝ\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u000e\u0012\u0006\u0010\u000f\u001a\u00020\u0003\u0012\u0006\u0010\u0010\u001a\u00020\u0003\u0012\u0006\u0010\u0011\u001a\u00020\u0003\u0012\u0006\u0010\u0012\u001a\u00020\u0003\u0012\u0006\u0010\u0013\u001a\u00020\u0003\u0012\u0006\u0010\u0014\u001a\u00020\u0003\u0012\u0006\u0010\u0015\u001a\u00020\u0003\u0012\u0006\u0010\u0016\u001a\u00020\u0003\u0012\u0006\u0010\u0017\u001a\u00020\u0003\u0012\u0006\u0010\u0018\u001a\u00020\u0003\u0012\u0006\u0010\u0019\u001a\u00020\u0003\u0012\u0006\u0010\u001a\u001a\u00020\u0003\u0012\u0006\u0010\u001b\u001a\u00020\u0003\u0012\u0006\u0010\u001c\u001a\u00020\u0003\u0012\u0006\u0010\u001d\u001a\u00020\u0003\u0012\u0006\u0010\u001e\u001a\u00020\u0003\u0012\u0006\u0010\u001f\u001a\u00020\u0003\u0012\u0006\u0010 \u001a\u00020\u0003\u0012\u0006\u0010!\u001a\u00020\u0003\u0012\u0006\u0010\"\u001a\u00020\u0003\u0012\u0006\u0010#\u001a\u00020\u0003\u0012\u0006\u0010$\u001a\u00020\u0003\u0012\u0006\u0010%\u001a\u00020\u0003\u0012\u0006\u0010&\u001a\u00020\u0003\u0012\u0006\u0010'\u001a\u00020\u0003\u0012\u0006\u0010(\u001a\u00020\u0003\u0012\u0006\u0010)\u001a\u00020\u0003\u0012\u0006\u0010*\u001a\u00020\u0003\u0012\u0006\u0010+\u001a\u00020\u0003\u0012\u0006\u0010,\u001a\u00020\u0003\u0012\u0006\u0010-\u001a\u00020\u0003\u0012\u0006\u0010.\u001a\u00020\u0003¢\u0006\u0002\u0010/J-\u0010^\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bc\u0010dJÀ\u0003\u0010e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u00032\b\b\u0002\u0010\f\u001a\u00020\u00032\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\b\b\u0002\u0010\u000f\u001a\u00020\u00032\b\b\u0002\u0010\u0010\u001a\u00020\u00032\b\b\u0002\u0010\u0011\u001a\u00020\u00032\b\b\u0002\u0010\u0012\u001a\u00020\u00032\b\b\u0002\u0010\u0013\u001a\u00020\u00032\b\b\u0002\u0010\u0014\u001a\u00020\u00032\b\b\u0002\u0010\u0015\u001a\u00020\u00032\b\b\u0002\u0010\u0016\u001a\u00020\u00032\b\b\u0002\u0010\u0017\u001a\u00020\u00032\b\b\u0002\u0010\u0018\u001a\u00020\u00032\b\b\u0002\u0010\u0019\u001a\u00020\u00032\b\b\u0002\u0010\u001a\u001a\u00020\u00032\b\b\u0002\u0010\u001b\u001a\u00020\u00032\b\b\u0002\u0010\u001c\u001a\u00020\u00032\b\b\u0002\u0010\u001d\u001a\u00020\u00032\b\b\u0002\u0010\u001e\u001a\u00020\u00032\b\b\u0002\u0010\u001f\u001a\u00020\u00032\b\b\u0002\u0010 \u001a\u00020\u00032\b\b\u0002\u0010!\u001a\u00020\u00032\b\b\u0002\u0010\"\u001a\u00020\u00032\b\b\u0002\u0010#\u001a\u00020\u00032\b\b\u0002\u0010$\u001a\u00020\u00032\b\b\u0002\u0010%\u001a\u00020\u00032\b\b\u0002\u0010&\u001a\u00020\u00032\b\b\u0002\u0010'\u001a\u00020\u00032\b\b\u0002\u0010(\u001a\u00020\u00032\b\b\u0002\u0010)\u001a\u00020\u00032\b\b\u0002\u0010*\u001a\u00020\u00032\b\b\u0002\u0010+\u001a\u00020\u00032\b\b\u0002\u0010,\u001a\u00020\u00032\b\b\u0002\u0010-\u001a\u00020\u00032\b\b\u0002\u0010.\u001a\u00020\u0003ø\u0001\u0000¢\u0006\u0004\bf\u0010gJ\u001d\u0010\u000b\u001a\u00020\u00032\u0006\u0010a\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bh\u0010iJ\u0013\u0010j\u001a\u00020`2\b\u0010k\u001a\u0004\u0018\u00010\u0001H\u0096\u0002J\b\u0010l\u001a\u00020mH\u0016J-\u0010n\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bo\u0010dJ-\u0010p\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bq\u0010dJ-\u0010r\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bs\u0010dJ-\u0010t\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bu\u0010dJ-\u0010v\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\bw\u0010dJ-\u0010x\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\by\u0010dJ-\u0010z\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b{\u0010dJ-\u0010|\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b}\u0010dJ-\u0010~\u001a\u00020\u00032\u0006\u0010_\u001a\u00020`2\u0006\u0010a\u001a\u00020`2\u0006\u0010b\u001a\u00020`H\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u007f\u0010dJ%\u0010\u0080\u0001\u001a\u00020\u000e*\u0004\u0018\u00010\u000e2\u000e\u0010\u0081\u0001\u001a\t\u0012\u0004\u0012\u00020\u000e0\u0082\u0001H\u0000¢\u0006\u0003\b\u0083\u0001R\u0019\u0010\u000b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b0\u00101R\u0019\u0010\t\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b3\u00101R\u0019\u0010\u0011\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b4\u00101R\u0019\u0010\u001d\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b5\u00101R\u0019\u0010\u0015\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b6\u00101R\u0019\u0010!\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b7\u00101R\u0019\u0010)\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b8\u00101R\u0019\u0010-\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b9\u00101R\u0019\u0010%\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b:\u00101R\u0019\u0010\u0005\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b;\u00101R\u0019\u0010\u0019\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b<\u00101R\u0019\u0010\n\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b=\u00101R\u0019\u0010\f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b>\u00101R\u0019\u0010\u0012\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b?\u00101R\u0019\u0010\u001e\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b@\u00101R\u0019\u0010\u0016\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bA\u00101R\u0019\u0010\"\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bB\u00101R\u0019\u0010*\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bC\u00101R\u0019\u0010.\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bD\u00101R\u0019\u0010&\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bE\u00101R\u0019\u0010\u0006\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bF\u00101R\u0019\u0010\u001a\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bG\u00101R\u0019\u0010\u0007\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bH\u00101R\u0019\u0010\u000f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bI\u00101R\u0019\u0010\u001b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bJ\u00101R\u0019\u0010\u0013\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bK\u00101R\u0019\u0010\u001f\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bL\u00101R\u0019\u0010'\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bM\u00101R\u0019\u0010+\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bN\u00101R\u0019\u0010#\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bO\u00101R\u0019\u0010\u0002\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bP\u00101R\u0019\u0010\u0017\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bQ\u00101R\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\bR\u0010SR\u0019\u0010\b\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bT\u00101R\u0019\u0010\u0010\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bU\u00101R\u0019\u0010\u001c\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bV\u00101R\u0019\u0010\u0014\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bW\u00101R\u0019\u0010 \u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bX\u00101R\u0019\u0010(\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bY\u00101R\u0019\u0010,\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\bZ\u00101R\u0019\u0010$\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b[\u00101R\u0019\u0010\u0004\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b\\\u00101R\u0019\u0010\u0018\u001a\u00020\u0003ø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u00102\u001a\u0004\b]\u00101\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u0084\u0001"}, d2 = {"Landroidx/compose/material3/TextFieldColors;", "", "focusedTextColor", "Landroidx/compose/ui/graphics/Color;", "unfocusedTextColor", "disabledTextColor", "errorTextColor", "focusedContainerColor", "unfocusedContainerColor", "disabledContainerColor", "errorContainerColor", "cursorColor", "errorCursorColor", "textSelectionColors", "Landroidx/compose/foundation/text/selection/TextSelectionColors;", "focusedIndicatorColor", "unfocusedIndicatorColor", "disabledIndicatorColor", "errorIndicatorColor", "focusedLeadingIconColor", "unfocusedLeadingIconColor", "disabledLeadingIconColor", "errorLeadingIconColor", "focusedTrailingIconColor", "unfocusedTrailingIconColor", "disabledTrailingIconColor", "errorTrailingIconColor", "focusedLabelColor", "unfocusedLabelColor", "disabledLabelColor", "errorLabelColor", "focusedPlaceholderColor", "unfocusedPlaceholderColor", "disabledPlaceholderColor", "errorPlaceholderColor", "focusedSupportingTextColor", "unfocusedSupportingTextColor", "disabledSupportingTextColor", "errorSupportingTextColor", "focusedPrefixColor", "unfocusedPrefixColor", "disabledPrefixColor", "errorPrefixColor", "focusedSuffixColor", "unfocusedSuffixColor", "disabledSuffixColor", "errorSuffixColor", "(JJJJJJJJJJLandroidx/compose/foundation/text/selection/TextSelectionColors;JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getCursorColor-0d7_KjU", "()J", "J", "getDisabledContainerColor-0d7_KjU", "getDisabledIndicatorColor-0d7_KjU", "getDisabledLabelColor-0d7_KjU", "getDisabledLeadingIconColor-0d7_KjU", "getDisabledPlaceholderColor-0d7_KjU", "getDisabledPrefixColor-0d7_KjU", "getDisabledSuffixColor-0d7_KjU", "getDisabledSupportingTextColor-0d7_KjU", "getDisabledTextColor-0d7_KjU", "getDisabledTrailingIconColor-0d7_KjU", "getErrorContainerColor-0d7_KjU", "getErrorCursorColor-0d7_KjU", "getErrorIndicatorColor-0d7_KjU", "getErrorLabelColor-0d7_KjU", "getErrorLeadingIconColor-0d7_KjU", "getErrorPlaceholderColor-0d7_KjU", "getErrorPrefixColor-0d7_KjU", "getErrorSuffixColor-0d7_KjU", "getErrorSupportingTextColor-0d7_KjU", "getErrorTextColor-0d7_KjU", "getErrorTrailingIconColor-0d7_KjU", "getFocusedContainerColor-0d7_KjU", "getFocusedIndicatorColor-0d7_KjU", "getFocusedLabelColor-0d7_KjU", "getFocusedLeadingIconColor-0d7_KjU", "getFocusedPlaceholderColor-0d7_KjU", "getFocusedPrefixColor-0d7_KjU", "getFocusedSuffixColor-0d7_KjU", "getFocusedSupportingTextColor-0d7_KjU", "getFocusedTextColor-0d7_KjU", "getFocusedTrailingIconColor-0d7_KjU", "getTextSelectionColors", "()Landroidx/compose/foundation/text/selection/TextSelectionColors;", "getUnfocusedContainerColor-0d7_KjU", "getUnfocusedIndicatorColor-0d7_KjU", "getUnfocusedLabelColor-0d7_KjU", "getUnfocusedLeadingIconColor-0d7_KjU", "getUnfocusedPlaceholderColor-0d7_KjU", "getUnfocusedPrefixColor-0d7_KjU", "getUnfocusedSuffixColor-0d7_KjU", "getUnfocusedSupportingTextColor-0d7_KjU", "getUnfocusedTextColor-0d7_KjU", "getUnfocusedTrailingIconColor-0d7_KjU", "containerColor", "enabled", "", "isError", "focused", "containerColor-XeAY9LY$material3_release", "(ZZZ)J", "copy", "copy-ejIjP34", "(JJJJJJJJJJLandroidx/compose/foundation/text/selection/TextSelectionColors;JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ)Landroidx/compose/material3/TextFieldColors;", "cursorColor-vNxB06k$material3_release", "(Z)J", "equals", "other", "hashCode", "", "indicatorColor", "indicatorColor-XeAY9LY$material3_release", "labelColor", "labelColor-XeAY9LY$material3_release", "leadingIconColor", "leadingIconColor-XeAY9LY$material3_release", "placeholderColor", "placeholderColor-XeAY9LY$material3_release", "prefixColor", "prefixColor-XeAY9LY$material3_release", "suffixColor", "suffixColor-XeAY9LY$material3_release", "supportingTextColor", "supportingTextColor-XeAY9LY$material3_release", "textColor", "textColor-XeAY9LY$material3_release", "trailingIconColor", "trailingIconColor-XeAY9LY$material3_release", "takeOrElse", "block", "Lkotlin/Function0;", "takeOrElse$material3_release", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TextFieldColors {
    public static final int $stable = 0;
    private final long cursorColor;
    private final long disabledContainerColor;
    private final long disabledIndicatorColor;
    private final long disabledLabelColor;
    private final long disabledLeadingIconColor;
    private final long disabledPlaceholderColor;
    private final long disabledPrefixColor;
    private final long disabledSuffixColor;
    private final long disabledSupportingTextColor;
    private final long disabledTextColor;
    private final long disabledTrailingIconColor;
    private final long errorContainerColor;
    private final long errorCursorColor;
    private final long errorIndicatorColor;
    private final long errorLabelColor;
    private final long errorLeadingIconColor;
    private final long errorPlaceholderColor;
    private final long errorPrefixColor;
    private final long errorSuffixColor;
    private final long errorSupportingTextColor;
    private final long errorTextColor;
    private final long errorTrailingIconColor;
    private final long focusedContainerColor;
    private final long focusedIndicatorColor;
    private final long focusedLabelColor;
    private final long focusedLeadingIconColor;
    private final long focusedPlaceholderColor;
    private final long focusedPrefixColor;
    private final long focusedSuffixColor;
    private final long focusedSupportingTextColor;
    private final long focusedTextColor;
    private final long focusedTrailingIconColor;
    private final TextSelectionColors textSelectionColors;
    private final long unfocusedContainerColor;
    private final long unfocusedIndicatorColor;
    private final long unfocusedLabelColor;
    private final long unfocusedLeadingIconColor;
    private final long unfocusedPlaceholderColor;
    private final long unfocusedPrefixColor;
    private final long unfocusedSuffixColor;
    private final long unfocusedSupportingTextColor;
    private final long unfocusedTextColor;
    private final long unfocusedTrailingIconColor;

    public TextFieldColors(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, TextSelectionColors textSelectionColors, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36, long j37, long j38, long j39, long j40, long j41, long j42, DefaultConstructorMarker defaultConstructorMarker) {
        this(j, j2, j3, j4, j5, j6, j7, j8, j9, j10, textSelectionColors, j11, j12, j13, j14, j15, j16, j17, j18, j19, j20, j21, j22, j23, j24, j25, j26, j27, j28, j29, j30, j31, j32, j33, j34, j35, j36, j37, j38, j39, j40, j41, j42);
    }

    private TextFieldColors(long j, long j2, long j3, long j4, long j5, long j6, long j7, long j8, long j9, long j10, TextSelectionColors textSelectionColors, long j11, long j12, long j13, long j14, long j15, long j16, long j17, long j18, long j19, long j20, long j21, long j22, long j23, long j24, long j25, long j26, long j27, long j28, long j29, long j30, long j31, long j32, long j33, long j34, long j35, long j36, long j37, long j38, long j39, long j40, long j41, long j42) {
        this.focusedTextColor = j;
        this.unfocusedTextColor = j2;
        this.disabledTextColor = j3;
        this.errorTextColor = j4;
        this.focusedContainerColor = j5;
        this.unfocusedContainerColor = j6;
        this.disabledContainerColor = j7;
        this.errorContainerColor = j8;
        this.cursorColor = j9;
        this.errorCursorColor = j10;
        this.textSelectionColors = textSelectionColors;
        this.focusedIndicatorColor = j11;
        this.unfocusedIndicatorColor = j12;
        this.disabledIndicatorColor = j13;
        this.errorIndicatorColor = j14;
        this.focusedLeadingIconColor = j15;
        this.unfocusedLeadingIconColor = j16;
        this.disabledLeadingIconColor = j17;
        this.errorLeadingIconColor = j18;
        this.focusedTrailingIconColor = j19;
        this.unfocusedTrailingIconColor = j20;
        this.disabledTrailingIconColor = j21;
        this.errorTrailingIconColor = j22;
        this.focusedLabelColor = j23;
        this.unfocusedLabelColor = j24;
        this.disabledLabelColor = j25;
        this.errorLabelColor = j26;
        this.focusedPlaceholderColor = j27;
        this.unfocusedPlaceholderColor = j28;
        this.disabledPlaceholderColor = j29;
        this.errorPlaceholderColor = j30;
        this.focusedSupportingTextColor = j31;
        this.unfocusedSupportingTextColor = j32;
        this.disabledSupportingTextColor = j33;
        this.errorSupportingTextColor = j34;
        this.focusedPrefixColor = j35;
        this.unfocusedPrefixColor = j36;
        this.disabledPrefixColor = j37;
        this.errorPrefixColor = j38;
        this.focusedSuffixColor = j39;
        this.unfocusedSuffixColor = j40;
        this.disabledSuffixColor = j41;
        this.errorSuffixColor = j42;
    }

    public final long getFocusedTextColor() {
        return this.focusedTextColor;
    }

    public final long getUnfocusedTextColor() {
        return this.unfocusedTextColor;
    }

    public final long getDisabledTextColor() {
        return this.disabledTextColor;
    }

    public final long getErrorTextColor() {
        return this.errorTextColor;
    }

    public final long getFocusedContainerColor() {
        return this.focusedContainerColor;
    }

    public final long getUnfocusedContainerColor() {
        return this.unfocusedContainerColor;
    }

    public final long getDisabledContainerColor() {
        return this.disabledContainerColor;
    }

    public final long getErrorContainerColor() {
        return this.errorContainerColor;
    }

    public final long getCursorColor() {
        return this.cursorColor;
    }

    public final long getErrorCursorColor() {
        return this.errorCursorColor;
    }

    public final TextSelectionColors getTextSelectionColors() {
        return this.textSelectionColors;
    }

    public final long getFocusedIndicatorColor() {
        return this.focusedIndicatorColor;
    }

    public final long getUnfocusedIndicatorColor() {
        return this.unfocusedIndicatorColor;
    }

    public final long getDisabledIndicatorColor() {
        return this.disabledIndicatorColor;
    }

    public final long getErrorIndicatorColor() {
        return this.errorIndicatorColor;
    }

    public final long getFocusedLeadingIconColor() {
        return this.focusedLeadingIconColor;
    }

    public final long getUnfocusedLeadingIconColor() {
        return this.unfocusedLeadingIconColor;
    }

    public final long getDisabledLeadingIconColor() {
        return this.disabledLeadingIconColor;
    }

    public final long getErrorLeadingIconColor() {
        return this.errorLeadingIconColor;
    }

    public final long getFocusedTrailingIconColor() {
        return this.focusedTrailingIconColor;
    }

    public final long getUnfocusedTrailingIconColor() {
        return this.unfocusedTrailingIconColor;
    }

    public final long getDisabledTrailingIconColor() {
        return this.disabledTrailingIconColor;
    }

    public final long getErrorTrailingIconColor() {
        return this.errorTrailingIconColor;
    }

    public final long getFocusedLabelColor() {
        return this.focusedLabelColor;
    }

    public final long getUnfocusedLabelColor() {
        return this.unfocusedLabelColor;
    }

    public final long getDisabledLabelColor() {
        return this.disabledLabelColor;
    }

    public final long getErrorLabelColor() {
        return this.errorLabelColor;
    }

    public final long getFocusedPlaceholderColor() {
        return this.focusedPlaceholderColor;
    }

    public final long getUnfocusedPlaceholderColor() {
        return this.unfocusedPlaceholderColor;
    }

    public final long getDisabledPlaceholderColor() {
        return this.disabledPlaceholderColor;
    }

    public final long getErrorPlaceholderColor() {
        return this.errorPlaceholderColor;
    }

    public final long getFocusedSupportingTextColor() {
        return this.focusedSupportingTextColor;
    }

    public final long getUnfocusedSupportingTextColor() {
        return this.unfocusedSupportingTextColor;
    }

    public final long getDisabledSupportingTextColor() {
        return this.disabledSupportingTextColor;
    }

    public final long getErrorSupportingTextColor() {
        return this.errorSupportingTextColor;
    }

    public final long getFocusedPrefixColor() {
        return this.focusedPrefixColor;
    }

    public final long getUnfocusedPrefixColor() {
        return this.unfocusedPrefixColor;
    }

    public final long getDisabledPrefixColor() {
        return this.disabledPrefixColor;
    }

    public final long getErrorPrefixColor() {
        return this.errorPrefixColor;
    }

    public final long getFocusedSuffixColor() {
        return this.focusedSuffixColor;
    }

    public final long getUnfocusedSuffixColor() {
        return this.unfocusedSuffixColor;
    }

    public final long getDisabledSuffixColor() {
        return this.disabledSuffixColor;
    }

    public final long getErrorSuffixColor() {
        return this.errorSuffixColor;
    }

    public final TextFieldColors m2938copyejIjP34(long focusedTextColor, long unfocusedTextColor, long disabledTextColor, long errorTextColor, long focusedContainerColor, long unfocusedContainerColor, long disabledContainerColor, long errorContainerColor, long cursorColor, long errorCursorColor, TextSelectionColors textSelectionColors, long focusedIndicatorColor, long unfocusedIndicatorColor, long disabledIndicatorColor, long errorIndicatorColor, long focusedLeadingIconColor, long unfocusedLeadingIconColor, long disabledLeadingIconColor, long errorLeadingIconColor, long focusedTrailingIconColor, long unfocusedTrailingIconColor, long disabledTrailingIconColor, long errorTrailingIconColor, long focusedLabelColor, long unfocusedLabelColor, long disabledLabelColor, long errorLabelColor, long focusedPlaceholderColor, long unfocusedPlaceholderColor, long disabledPlaceholderColor, long errorPlaceholderColor, long focusedSupportingTextColor, long unfocusedSupportingTextColor, long disabledSupportingTextColor, long errorSupportingTextColor, long focusedPrefixColor, long unfocusedPrefixColor, long disabledPrefixColor, long errorPrefixColor, long focusedSuffixColor, long unfocusedSuffixColor, long disabledSuffixColor, long errorSuffixColor) {
        return new TextFieldColors(focusedTextColor != 16 ? focusedTextColor : this.focusedTextColor, unfocusedTextColor != 16 ? unfocusedTextColor : this.unfocusedTextColor, disabledTextColor != 16 ? disabledTextColor : this.disabledTextColor, errorTextColor != 16 ? errorTextColor : this.errorTextColor, focusedContainerColor != 16 ? focusedContainerColor : this.focusedContainerColor, unfocusedContainerColor != 16 ? unfocusedContainerColor : this.unfocusedContainerColor, disabledContainerColor != 16 ? disabledContainerColor : this.disabledContainerColor, errorContainerColor != 16 ? errorContainerColor : this.errorContainerColor, cursorColor != 16 ? cursorColor : this.cursorColor, errorCursorColor != 16 ? errorCursorColor : this.errorCursorColor, takeOrElse$material3_release(textSelectionColors, new Function0<TextSelectionColors>() {
            {
                super(0);
            }

            public final TextSelectionColors m2991invoke() {
                return this.this$0.getTextSelectionColors();
            }
        }), focusedIndicatorColor != 16 ? focusedIndicatorColor : this.focusedIndicatorColor, unfocusedIndicatorColor != 16 ? unfocusedIndicatorColor : this.unfocusedIndicatorColor, disabledIndicatorColor != 16 ? disabledIndicatorColor : this.disabledIndicatorColor, errorIndicatorColor != 16 ? errorIndicatorColor : this.errorIndicatorColor, focusedLeadingIconColor != 16 ? focusedLeadingIconColor : this.focusedLeadingIconColor, unfocusedLeadingIconColor != 16 ? unfocusedLeadingIconColor : this.unfocusedLeadingIconColor, disabledLeadingIconColor != 16 ? disabledLeadingIconColor : this.disabledLeadingIconColor, errorLeadingIconColor != 16 ? errorLeadingIconColor : this.errorLeadingIconColor, focusedTrailingIconColor != 16 ? focusedTrailingIconColor : this.focusedTrailingIconColor, unfocusedTrailingIconColor != 16 ? unfocusedTrailingIconColor : this.unfocusedTrailingIconColor, disabledTrailingIconColor != 16 ? disabledTrailingIconColor : this.disabledTrailingIconColor, errorTrailingIconColor != 16 ? errorTrailingIconColor : this.errorTrailingIconColor, focusedLabelColor != 16 ? focusedLabelColor : this.focusedLabelColor, unfocusedLabelColor != 16 ? unfocusedLabelColor : this.unfocusedLabelColor, disabledLabelColor != 16 ? disabledLabelColor : this.disabledLabelColor, errorLabelColor != 16 ? errorLabelColor : this.errorLabelColor, focusedPlaceholderColor != 16 ? focusedPlaceholderColor : this.focusedPlaceholderColor, unfocusedPlaceholderColor != 16 ? unfocusedPlaceholderColor : this.unfocusedPlaceholderColor, disabledPlaceholderColor != 16 ? disabledPlaceholderColor : this.disabledPlaceholderColor, errorPlaceholderColor != 16 ? errorPlaceholderColor : this.errorPlaceholderColor, focusedSupportingTextColor != 16 ? focusedSupportingTextColor : this.focusedSupportingTextColor, unfocusedSupportingTextColor != 16 ? unfocusedSupportingTextColor : this.unfocusedSupportingTextColor, disabledSupportingTextColor != 16 ? disabledSupportingTextColor : this.disabledSupportingTextColor, errorSupportingTextColor != 16 ? errorSupportingTextColor : this.errorSupportingTextColor, focusedPrefixColor != 16 ? focusedPrefixColor : this.focusedPrefixColor, unfocusedPrefixColor != 16 ? unfocusedPrefixColor : this.unfocusedPrefixColor, disabledPrefixColor != 16 ? disabledPrefixColor : this.disabledPrefixColor, errorPrefixColor != 16 ? errorPrefixColor : this.errorPrefixColor, focusedSuffixColor != 16 ? focusedSuffixColor : this.focusedSuffixColor, unfocusedSuffixColor != 16 ? unfocusedSuffixColor : this.unfocusedSuffixColor, disabledSuffixColor != 16 ? disabledSuffixColor : this.disabledSuffixColor, errorSuffixColor != 16 ? errorSuffixColor : this.errorSuffixColor, null);
    }

    public final TextSelectionColors takeOrElse$material3_release(TextSelectionColors textSelectionColors, Function0<TextSelectionColors> function0) {
        return textSelectionColors == null ? (TextSelectionColors) function0.invoke() : textSelectionColors;
    }

    public final long m2984leadingIconColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledLeadingIconColor;
        }
        if (isError) {
            return this.errorLeadingIconColor;
        }
        if (focused) {
            return this.focusedLeadingIconColor;
        }
        return this.unfocusedLeadingIconColor;
    }

    public final long m2990trailingIconColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledTrailingIconColor;
        }
        if (isError) {
            return this.errorTrailingIconColor;
        }
        if (focused) {
            return this.focusedTrailingIconColor;
        }
        return this.unfocusedTrailingIconColor;
    }

    public final long m2982indicatorColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledIndicatorColor;
        }
        if (isError) {
            return this.errorIndicatorColor;
        }
        if (focused) {
            return this.focusedIndicatorColor;
        }
        return this.unfocusedIndicatorColor;
    }

    public final long m2937containerColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledContainerColor;
        }
        if (isError) {
            return this.errorContainerColor;
        }
        if (focused) {
            return this.focusedContainerColor;
        }
        return this.unfocusedContainerColor;
    }

    public final long m2985placeholderColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledPlaceholderColor;
        }
        if (isError) {
            return this.errorPlaceholderColor;
        }
        if (focused) {
            return this.focusedPlaceholderColor;
        }
        return this.unfocusedPlaceholderColor;
    }

    public final long m2983labelColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledLabelColor;
        }
        if (isError) {
            return this.errorLabelColor;
        }
        if (focused) {
            return this.focusedLabelColor;
        }
        return this.unfocusedLabelColor;
    }

    public final long m2989textColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledTextColor;
        }
        if (isError) {
            return this.errorTextColor;
        }
        if (focused) {
            return this.focusedTextColor;
        }
        return this.unfocusedTextColor;
    }

    public final long m2988supportingTextColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledSupportingTextColor;
        }
        if (isError) {
            return this.errorSupportingTextColor;
        }
        if (focused) {
            return this.focusedSupportingTextColor;
        }
        return this.unfocusedSupportingTextColor;
    }

    public final long m2986prefixColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledPrefixColor;
        }
        if (isError) {
            return this.errorPrefixColor;
        }
        if (focused) {
            return this.focusedPrefixColor;
        }
        return this.unfocusedPrefixColor;
    }

    public final long m2987suffixColorXeAY9LY$material3_release(boolean enabled, boolean isError, boolean focused) {
        if (!enabled) {
            return this.disabledSuffixColor;
        }
        if (isError) {
            return this.errorSuffixColor;
        }
        if (focused) {
            return this.focusedSuffixColor;
        }
        return this.unfocusedSuffixColor;
    }

    public final long m2939cursorColorvNxB06k$material3_release(boolean isError) {
        return isError ? this.errorCursorColor : this.cursorColor;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (other == null || !(other instanceof TextFieldColors)) {
            return false;
        }
        TextFieldColors textFieldColors = (TextFieldColors) other;
        return Color.m4591equalsimpl0(this.focusedTextColor, textFieldColors.focusedTextColor) && Color.m4591equalsimpl0(this.unfocusedTextColor, textFieldColors.unfocusedTextColor) && Color.m4591equalsimpl0(this.disabledTextColor, textFieldColors.disabledTextColor) && Color.m4591equalsimpl0(this.errorTextColor, textFieldColors.errorTextColor) && Color.m4591equalsimpl0(this.focusedContainerColor, textFieldColors.focusedContainerColor) && Color.m4591equalsimpl0(this.unfocusedContainerColor, textFieldColors.unfocusedContainerColor) && Color.m4591equalsimpl0(this.disabledContainerColor, textFieldColors.disabledContainerColor) && Color.m4591equalsimpl0(this.errorContainerColor, textFieldColors.errorContainerColor) && Color.m4591equalsimpl0(this.cursorColor, textFieldColors.cursorColor) && Color.m4591equalsimpl0(this.errorCursorColor, textFieldColors.errorCursorColor) && Intrinsics.areEqual(this.textSelectionColors, textFieldColors.textSelectionColors) && Color.m4591equalsimpl0(this.focusedIndicatorColor, textFieldColors.focusedIndicatorColor) && Color.m4591equalsimpl0(this.unfocusedIndicatorColor, textFieldColors.unfocusedIndicatorColor) && Color.m4591equalsimpl0(this.disabledIndicatorColor, textFieldColors.disabledIndicatorColor) && Color.m4591equalsimpl0(this.errorIndicatorColor, textFieldColors.errorIndicatorColor) && Color.m4591equalsimpl0(this.focusedLeadingIconColor, textFieldColors.focusedLeadingIconColor) && Color.m4591equalsimpl0(this.unfocusedLeadingIconColor, textFieldColors.unfocusedLeadingIconColor) && Color.m4591equalsimpl0(this.disabledLeadingIconColor, textFieldColors.disabledLeadingIconColor) && Color.m4591equalsimpl0(this.errorLeadingIconColor, textFieldColors.errorLeadingIconColor) && Color.m4591equalsimpl0(this.focusedTrailingIconColor, textFieldColors.focusedTrailingIconColor) && Color.m4591equalsimpl0(this.unfocusedTrailingIconColor, textFieldColors.unfocusedTrailingIconColor) && Color.m4591equalsimpl0(this.disabledTrailingIconColor, textFieldColors.disabledTrailingIconColor) && Color.m4591equalsimpl0(this.errorTrailingIconColor, textFieldColors.errorTrailingIconColor) && Color.m4591equalsimpl0(this.focusedLabelColor, textFieldColors.focusedLabelColor) && Color.m4591equalsimpl0(this.unfocusedLabelColor, textFieldColors.unfocusedLabelColor) && Color.m4591equalsimpl0(this.disabledLabelColor, textFieldColors.disabledLabelColor) && Color.m4591equalsimpl0(this.errorLabelColor, textFieldColors.errorLabelColor) && Color.m4591equalsimpl0(this.focusedPlaceholderColor, textFieldColors.focusedPlaceholderColor) && Color.m4591equalsimpl0(this.unfocusedPlaceholderColor, textFieldColors.unfocusedPlaceholderColor) && Color.m4591equalsimpl0(this.disabledPlaceholderColor, textFieldColors.disabledPlaceholderColor) && Color.m4591equalsimpl0(this.errorPlaceholderColor, textFieldColors.errorPlaceholderColor) && Color.m4591equalsimpl0(this.focusedSupportingTextColor, textFieldColors.focusedSupportingTextColor) && Color.m4591equalsimpl0(this.unfocusedSupportingTextColor, textFieldColors.unfocusedSupportingTextColor) && Color.m4591equalsimpl0(this.disabledSupportingTextColor, textFieldColors.disabledSupportingTextColor) && Color.m4591equalsimpl0(this.errorSupportingTextColor, textFieldColors.errorSupportingTextColor) && Color.m4591equalsimpl0(this.focusedPrefixColor, textFieldColors.focusedPrefixColor) && Color.m4591equalsimpl0(this.unfocusedPrefixColor, textFieldColors.unfocusedPrefixColor) && Color.m4591equalsimpl0(this.disabledPrefixColor, textFieldColors.disabledPrefixColor) && Color.m4591equalsimpl0(this.errorPrefixColor, textFieldColors.errorPrefixColor) && Color.m4591equalsimpl0(this.focusedSuffixColor, textFieldColors.focusedSuffixColor) && Color.m4591equalsimpl0(this.unfocusedSuffixColor, textFieldColors.unfocusedSuffixColor) && Color.m4591equalsimpl0(this.disabledSuffixColor, textFieldColors.disabledSuffixColor) && Color.m4591equalsimpl0(this.errorSuffixColor, textFieldColors.errorSuffixColor);
    }

    public int hashCode() {
        return (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((Color.m4597hashCodeimpl(this.focusedTextColor) * 31) + Color.m4597hashCodeimpl(this.unfocusedTextColor)) * 31) + Color.m4597hashCodeimpl(this.disabledTextColor)) * 31) + Color.m4597hashCodeimpl(this.errorTextColor)) * 31) + Color.m4597hashCodeimpl(this.focusedContainerColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedContainerColor)) * 31) + Color.m4597hashCodeimpl(this.disabledContainerColor)) * 31) + Color.m4597hashCodeimpl(this.errorContainerColor)) * 31) + Color.m4597hashCodeimpl(this.cursorColor)) * 31) + Color.m4597hashCodeimpl(this.errorCursorColor)) * 31) + this.textSelectionColors.hashCode()) * 31) + Color.m4597hashCodeimpl(this.focusedIndicatorColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedIndicatorColor)) * 31) + Color.m4597hashCodeimpl(this.disabledIndicatorColor)) * 31) + Color.m4597hashCodeimpl(this.errorIndicatorColor)) * 31) + Color.m4597hashCodeimpl(this.focusedLeadingIconColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedLeadingIconColor)) * 31) + Color.m4597hashCodeimpl(this.disabledLeadingIconColor)) * 31) + Color.m4597hashCodeimpl(this.errorLeadingIconColor)) * 31) + Color.m4597hashCodeimpl(this.focusedTrailingIconColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedTrailingIconColor)) * 31) + Color.m4597hashCodeimpl(this.disabledTrailingIconColor)) * 31) + Color.m4597hashCodeimpl(this.errorTrailingIconColor)) * 31) + Color.m4597hashCodeimpl(this.focusedLabelColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedLabelColor)) * 31) + Color.m4597hashCodeimpl(this.disabledLabelColor)) * 31) + Color.m4597hashCodeimpl(this.errorLabelColor)) * 31) + Color.m4597hashCodeimpl(this.focusedPlaceholderColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedPlaceholderColor)) * 31) + Color.m4597hashCodeimpl(this.disabledPlaceholderColor)) * 31) + Color.m4597hashCodeimpl(this.errorPlaceholderColor)) * 31) + Color.m4597hashCodeimpl(this.focusedSupportingTextColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedSupportingTextColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSupportingTextColor)) * 31) + Color.m4597hashCodeimpl(this.errorSupportingTextColor)) * 31) + Color.m4597hashCodeimpl(this.focusedPrefixColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedPrefixColor)) * 31) + Color.m4597hashCodeimpl(this.disabledPrefixColor)) * 31) + Color.m4597hashCodeimpl(this.errorPrefixColor)) * 31) + Color.m4597hashCodeimpl(this.focusedSuffixColor)) * 31) + Color.m4597hashCodeimpl(this.unfocusedSuffixColor)) * 31) + Color.m4597hashCodeimpl(this.disabledSuffixColor)) * 31) + Color.m4597hashCodeimpl(this.errorSuffixColor);
    }
}
