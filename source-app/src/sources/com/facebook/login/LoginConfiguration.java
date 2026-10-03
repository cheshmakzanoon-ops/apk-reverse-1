package com.facebook.login;

import androidx.constraintlayout.widget.ConstraintLayout;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u001e\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0010\"\n\u0002\b\u0004\u0018\u0000 \u000f2\u00020\u0001:\u0001\u000fB!\b\u0017\u0012\u000e\u0010\u0002\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0004¢\u0006\u0002\u0010\u0006B+\b\u0016\u0012\u0010\b\u0002\u0010\u0002\u001a\n\u0012\u0004\u0012\u00020\u0004\u0018\u00010\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0004¢\u0006\u0002\u0010\bR\u0011\u0010\u0007\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0005\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\nR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\f¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u0010"}, d2 = {"Lcom/facebook/login/LoginConfiguration;", "", "permissions", "", "", "nonce", "(Ljava/util/Collection;Ljava/lang/String;)V", "codeVerifier", "(Ljava/util/Collection;Ljava/lang/String;Ljava/lang/String;)V", "getCodeVerifier", "()Ljava/lang/String;", "getNonce", "", "getPermissions", "()Ljava/util/Set;", "Companion", "facebook-common_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class LoginConfiguration {
    public static final String OPENID = "openid";
    private final String codeVerifier;
    private final String nonce;
    private final Set<String> permissions;

    public LoginConfiguration(Collection<String> collection) {
        String str = null;
        this(collection, str, 2, str);
    }

    public final Set<String> getPermissions() {
        return this.permissions;
    }

    public final String getNonce() {
        return this.nonce;
    }

    public final String getCodeVerifier() {
        return this.codeVerifier;
    }

    public LoginConfiguration(Collection collection, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        if ((i & 2) != 0) {
            str = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(str, "randomUUID().toString()");
        }
        this(collection, str);
    }

    public LoginConfiguration(Collection<String> collection, String str) {
        this(collection, str, PKCEUtil.generateCodeVerifier());
        Intrinsics.checkNotNullParameter(str, "nonce");
        PKCEUtil pKCEUtil = PKCEUtil.INSTANCE;
    }

    public LoginConfiguration(Collection collection, String str, String str2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        collection = (i & 1) != 0 ? null : collection;
        if ((i & 2) != 0) {
            str = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(str, "randomUUID().toString()");
        }
        this(collection, str, str2);
    }

    public LoginConfiguration(Collection<String> collection, String str, String str2) {
        boolean z;
        Intrinsics.checkNotNullParameter(str, "nonce");
        Intrinsics.checkNotNullParameter(str2, "codeVerifier");
        NonceUtil nonceUtil = NonceUtil.INSTANCE;
        if (NonceUtil.isValidNonce(str)) {
            PKCEUtil pKCEUtil = PKCEUtil.INSTANCE;
            if (PKCEUtil.isValidCodeVerifier(str2)) {
                z = true;
            } else {
                z = false;
            }
        } else {
            z = false;
        }
        if (!z) {
            throw new IllegalArgumentException("Failed requirement.".toString());
        }
        HashSet hashSet = collection != null ? new HashSet(collection) : new HashSet();
        hashSet.add(OPENID);
        Set<String> setUnmodifiableSet = Collections.unmodifiableSet(hashSet);
        Intrinsics.checkNotNullExpressionValue(setUnmodifiableSet, "unmodifiableSet(permissions)");
        this.permissions = setUnmodifiableSet;
        this.nonce = str;
        this.codeVerifier = str2;
    }
}
