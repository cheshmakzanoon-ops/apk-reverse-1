package androidx.compose.foundation.text.input.internal;

import android.os.Build;
import android.view.inputmethod.EditorInfo;
import androidx.compose.foundation.text.handwriting.StylusHandwriting_androidKt;
import androidx.compose.p002ui.graphics.Fields;
import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.input.ImeAction;
import androidx.compose.ui.text.input.ImeOptions;
import androidx.compose.ui.text.input.KeyboardCapitalization;
import androidx.compose.ui.text.input.KeyboardType;
import androidx.compose.ui.text.input.PlatformImeOptions;
import androidx.core.view.inputmethod.EditorInfoCompat;
import kotlin.Metadata;

@Metadata(d1 = {"\u00008\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\r\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u000e\n\u0002\b\u0003\u001a\u0018\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0003H\u0002\u001a@\u0010\u0005\u001a\u00020\u0006*\u00020\u00072\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\r2\u0010\b\u0002\u0010\u000e\u001a\n\u0012\u0004\u0012\u00020\u0010\u0018\u00010\u000fH\u0000ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0013"}, d2 = {"hasFlag", "", "bits", "", "flag", "update", "", "Landroid/view/inputmethod/EditorInfo;", "text", "", "selection", "Landroidx/compose/ui/text/TextRange;", "imeOptions", "Landroidx/compose/ui/text/input/ImeOptions;", "contentMimeTypes", "", "", "update-pLxbY9I", "(Landroid/view/inputmethod/EditorInfo;Ljava/lang/CharSequence;JLandroidx/compose/ui/text/input/ImeOptions;[Ljava/lang/String;)V", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class EditorInfo_androidKt {
    private static final boolean hasFlag(int i, int i2) {
        return (i & i2) == i2;
    }

    public static void m1621updatepLxbY9I$default(EditorInfo editorInfo, CharSequence charSequence, long j, ImeOptions imeOptions, String[] strArr, int i, Object obj) {
        if ((i & 8) != 0) {
            strArr = null;
        }
        m1620updatepLxbY9I(editorInfo, charSequence, j, imeOptions, strArr);
    }

    public static final void m1620updatepLxbY9I(EditorInfo editorInfo, CharSequence charSequence, long j, ImeOptions imeOptions, String[] strArr) {
        String privateImeOptions;
        int i = imeOptions.getImeAction-eUduSuo();
        int i2 = 3;
        int i3 = 6;
        if (ImeAction.equals-impl0(i, ImeAction.Companion.getDefault-eUduSuo())) {
            if (!imeOptions.getSingleLine()) {
                i3 = 0;
            }
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getNone-eUduSuo())) {
            i3 = 1;
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getGo-eUduSuo())) {
            i3 = 2;
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getNext-eUduSuo())) {
            i3 = 5;
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getPrevious-eUduSuo())) {
            i3 = 7;
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getSearch-eUduSuo())) {
            i3 = 3;
        } else if (ImeAction.equals-impl0(i, ImeAction.Companion.getSend-eUduSuo())) {
            i3 = 4;
        } else if (!ImeAction.equals-impl0(i, ImeAction.Companion.getDone-eUduSuo())) {
            throw new IllegalStateException("invalid ImeAction".toString());
        }
        editorInfo.imeOptions = i3;
        PlatformImeOptions platformImeOptions = imeOptions.getPlatformImeOptions();
        if (platformImeOptions != null && (privateImeOptions = platformImeOptions.getPrivateImeOptions()) != null) {
            editorInfo.privateImeOptions = privateImeOptions;
        }
        if (Build.VERSION.SDK_INT >= 24) {
            LocaleListHelper.INSTANCE.setHintLocales(editorInfo, imeOptions.getHintLocales());
        }
        int i4 = imeOptions.getKeyboardType-PjHm6EE();
        if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getText-PjHm6EE())) {
            i2 = 1;
        } else if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getAscii-PjHm6EE())) {
            editorInfo.imeOptions |= Integer.MIN_VALUE;
            i2 = 1;
        } else if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getNumber-PjHm6EE())) {
            i2 = 2;
        } else if (!KeyboardType.equals-impl0(i4, KeyboardType.Companion.getPhone-PjHm6EE())) {
            if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getUri-PjHm6EE())) {
                i2 = 17;
            } else if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getEmail-PjHm6EE())) {
                i2 = 33;
            } else if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getPassword-PjHm6EE())) {
                i2 = 129;
            } else if (KeyboardType.equals-impl0(i4, KeyboardType.Companion.getNumberPassword-PjHm6EE())) {
                i2 = 18;
            } else {
                if (!KeyboardType.equals-impl0(i4, KeyboardType.Companion.getDecimal-PjHm6EE())) {
                    throw new IllegalStateException("Invalid Keyboard Type".toString());
                }
                i2 = 8194;
            }
        }
        editorInfo.inputType = i2;
        if (!imeOptions.getSingleLine() && hasFlag(editorInfo.inputType, 1)) {
            editorInfo.inputType |= Fields.RenderEffect;
            if (ImeAction.equals-impl0(imeOptions.getImeAction-eUduSuo(), ImeAction.Companion.getDefault-eUduSuo())) {
                editorInfo.imeOptions |= 1073741824;
            }
        }
        if (hasFlag(editorInfo.inputType, 1)) {
            int i5 = imeOptions.getCapitalization-IUNYP9k();
            if (KeyboardCapitalization.equals-impl0(i5, KeyboardCapitalization.Companion.getCharacters-IUNYP9k())) {
                editorInfo.inputType |= Fields.TransformOrigin;
            } else if (KeyboardCapitalization.equals-impl0(i5, KeyboardCapitalization.Companion.getWords-IUNYP9k())) {
                editorInfo.inputType |= Fields.Shape;
            } else if (KeyboardCapitalization.equals-impl0(i5, KeyboardCapitalization.Companion.getSentences-IUNYP9k())) {
                editorInfo.inputType |= Fields.Clip;
            }
            if (imeOptions.getAutoCorrect()) {
                editorInfo.inputType |= Fields.CompositingStrategy;
            }
        }
        editorInfo.initialSelStart = TextRange.getStart-impl(j);
        editorInfo.initialSelEnd = TextRange.getEnd-impl(j);
        EditorInfoCompat.setInitialSurroundingText(editorInfo, charSequence);
        if (strArr != null) {
            EditorInfoCompat.setContentMimeTypes(editorInfo, strArr);
        }
        editorInfo.imeOptions |= 33554432;
        if (StylusHandwriting_androidKt.isStylusHandwritingSupported() && !KeyboardType.equals-impl0(imeOptions.getKeyboardType-PjHm6EE(), KeyboardType.Companion.getPassword-PjHm6EE()) && !KeyboardType.equals-impl0(imeOptions.getKeyboardType-PjHm6EE(), KeyboardType.Companion.getNumberPassword-PjHm6EE())) {
            EditorInfoCompat.setStylusHandwritingEnabled(editorInfo, true);
            EditorInfoApi34.INSTANCE.setHandwritingGestures(editorInfo);
        } else {
            EditorInfoCompat.setStylusHandwritingEnabled(editorInfo, false);
        }
    }
}
