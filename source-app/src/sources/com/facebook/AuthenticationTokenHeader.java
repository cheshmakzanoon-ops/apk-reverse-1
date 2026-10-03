package com.facebook;

import android.os.Parcel;
import android.os.Parcelable;
import android.util.Base64;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.internal.Validate;
import com.facebook.share.internal.ShareConstants;
import java.nio.charset.Charset;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import org.json.JSONException;
import org.json.JSONObject;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\b\n\u0002\u0010\u0002\n\u0002\b\u0004\u0018\u0000 $2\u00020\u0001:\u0001$B\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u000f\b\u0010\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007B\u000f\b\u0010\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nB\u001f\b\u0017\u0012\u0006\u0010\u000b\u001a\u00020\u0003\u0012\u0006\u0010\f\u001a\u00020\u0003\u0012\u0006\u0010\r\u001a\u00020\u0003¢\u0006\u0002\u0010\u000eJ\b\u0010\u0013\u001a\u00020\u0014H\u0016J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0018H\u0096\u0002J\b\u0010\u0019\u001a\u00020\u0014H\u0016J\u0010\u0010\u001a\u001a\u00020\u00162\u0006\u0010\u001b\u001a\u00020\u0003H\u0002J\b\u0010\u001c\u001a\u00020\u0003H\u0007J\r\u0010\u001d\u001a\u00020\tH\u0000¢\u0006\u0002\b\u001eJ\b\u0010\u001f\u001a\u00020\u0003H\u0016J\u0018\u0010 \u001a\u00020!2\u0006\u0010\"\u001a\u00020\u00062\u0006\u0010#\u001a\u00020\u0014H\u0016R\u0011\u0010\u000b\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\r\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0010R\u0011\u0010\f\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0010¨\u0006%"}, d2 = {"Lcom/facebook/AuthenticationTokenHeader;", "Landroid/os/Parcelable;", "encodedHeaderString", "", "(Ljava/lang/String;)V", "parcel", "Landroid/os/Parcel;", "(Landroid/os/Parcel;)V", "jsonObject", "Lorg/json/JSONObject;", "(Lorg/json/JSONObject;)V", "alg", "typ", "kid", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getAlg", "()Ljava/lang/String;", "getKid", "getTyp", "describeContents", "", "equals", "", "other", "", "hashCode", "isValidHeader", "headerString", "toEnCodedString", "toJSONObject", "toJSONObject$facebook_core_release", "toString", "writeToParcel", "", "dest", "flags", "Companion", "facebook-core_release"}, k = 1, mv = {1, 5, 1}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class AuthenticationTokenHeader implements Parcelable {
    private final String alg;
    private final String kid;
    private final String typ;
    public static final Parcelable.Creator<AuthenticationTokenHeader> CREATOR = new Parcelable.Creator<AuthenticationTokenHeader>() {
        @Override
        public AuthenticationTokenHeader createFromParcel(Parcel source) {
            Intrinsics.checkNotNullParameter(source, ShareConstants.FEED_SOURCE_PARAM);
            return new AuthenticationTokenHeader(source);
        }

        @Override
        public AuthenticationTokenHeader[] newArray(int size) {
            return new AuthenticationTokenHeader[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    public final String getAlg() {
        return this.alg;
    }

    public final String getTyp() {
        return this.typ;
    }

    public final String getKid() {
        return this.kid;
    }

    public AuthenticationTokenHeader(String str) throws JSONException {
        Intrinsics.checkNotNullParameter(str, "encodedHeaderString");
        if (!isValidHeader(str)) {
            throw new IllegalArgumentException("Invalid Header".toString());
        }
        byte[] bArrDecode = Base64.decode(str, 0);
        Intrinsics.checkNotNullExpressionValue(bArrDecode, "decodedBytes");
        JSONObject jSONObject = new JSONObject(new String(bArrDecode, Charsets.UTF_8));
        String string = jSONObject.getString("alg");
        Intrinsics.checkNotNullExpressionValue(string, "jsonObj.getString(\"alg\")");
        this.alg = string;
        String string2 = jSONObject.getString("typ");
        Intrinsics.checkNotNullExpressionValue(string2, "jsonObj.getString(\"typ\")");
        this.typ = string2;
        String string3 = jSONObject.getString("kid");
        Intrinsics.checkNotNullExpressionValue(string3, "jsonObj.getString(\"kid\")");
        this.kid = string3;
    }

    public AuthenticationTokenHeader(Parcel parcel) {
        Intrinsics.checkNotNullParameter(parcel, "parcel");
        String string = parcel.readString();
        Validate validate = Validate.INSTANCE;
        this.alg = Validate.notNullOrEmpty(string, "alg");
        String string2 = parcel.readString();
        Validate validate2 = Validate.INSTANCE;
        this.typ = Validate.notNullOrEmpty(string2, "typ");
        String string3 = parcel.readString();
        Validate validate3 = Validate.INSTANCE;
        this.kid = Validate.notNullOrEmpty(string3, "kid");
    }

    public AuthenticationTokenHeader(JSONObject jSONObject) throws JSONException {
        Intrinsics.checkNotNullParameter(jSONObject, "jsonObject");
        String string = jSONObject.getString("alg");
        Intrinsics.checkNotNullExpressionValue(string, "jsonObject.getString(\"alg\")");
        this.alg = string;
        String string2 = jSONObject.getString("typ");
        Intrinsics.checkNotNullExpressionValue(string2, "jsonObject.getString(\"typ\")");
        this.typ = string2;
        String string3 = jSONObject.getString("kid");
        Intrinsics.checkNotNullExpressionValue(string3, "jsonObject.getString(\"kid\")");
        this.kid = string3;
    }

    public AuthenticationTokenHeader(String str, String str2, String str3) {
        Intrinsics.checkNotNullParameter(str, "alg");
        Intrinsics.checkNotNullParameter(str2, "typ");
        Intrinsics.checkNotNullParameter(str3, "kid");
        this.alg = str;
        this.typ = str2;
        this.kid = str3;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        Intrinsics.checkNotNullParameter(dest, "dest");
        dest.writeString(this.alg);
        dest.writeString(this.typ);
        dest.writeString(this.kid);
    }

    public String toString() {
        String string = toJSONObject$facebook_core_release().toString();
        Intrinsics.checkNotNullExpressionValue(string, "headerJsonObject.toString()");
        return string;
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AuthenticationTokenHeader)) {
            return false;
        }
        AuthenticationTokenHeader authenticationTokenHeader = (AuthenticationTokenHeader) other;
        return Intrinsics.areEqual(this.alg, authenticationTokenHeader.alg) && Intrinsics.areEqual(this.typ, authenticationTokenHeader.typ) && Intrinsics.areEqual(this.kid, authenticationTokenHeader.kid);
    }

    public int hashCode() {
        return ((((527 + this.alg.hashCode()) * 31) + this.typ.hashCode()) * 31) + this.kid.hashCode();
    }

    private final boolean isValidHeader(String headerString) {
        Validate validate = Validate.INSTANCE;
        Validate.notEmpty(headerString, "encodedHeaderString");
        byte[] bArrDecode = Base64.decode(headerString, 0);
        Intrinsics.checkNotNullExpressionValue(bArrDecode, "decodedBytes");
        try {
            JSONObject jSONObject = new JSONObject(new String(bArrDecode, Charsets.UTF_8));
            String strOptString = jSONObject.optString("alg");
            Intrinsics.checkNotNullExpressionValue(strOptString, "alg");
            boolean z = strOptString.length() > 0 && Intrinsics.areEqual(strOptString, "RS256");
            String strOptString2 = jSONObject.optString("kid");
            Intrinsics.checkNotNullExpressionValue(strOptString2, "jsonObj.optString(\"kid\")");
            boolean z2 = strOptString2.length() > 0;
            String strOptString3 = jSONObject.optString("typ");
            Intrinsics.checkNotNullExpressionValue(strOptString3, "jsonObj.optString(\"typ\")");
            return z && z2 && (strOptString3.length() > 0);
        } catch (JSONException unused) {
            return false;
        }
    }

    public final JSONObject toJSONObject$facebook_core_release() throws JSONException {
        JSONObject jSONObject = new JSONObject();
        jSONObject.put("alg", this.alg);
        jSONObject.put("typ", this.typ);
        jSONObject.put("kid", this.kid);
        return jSONObject;
    }

    public final String toEnCodedString() {
        String string = toString();
        Charset charset = Charsets.UTF_8;
        if (string == null) {
            throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
        }
        byte[] bytes = string.getBytes(charset);
        Intrinsics.checkNotNullExpressionValue(bytes, "(this as java.lang.String).getBytes(charset)");
        String strEncodeToString = Base64.encodeToString(bytes, 0);
        Intrinsics.checkNotNullExpressionValue(strEncodeToString, "encodeToString(claimsJsonString.toByteArray(), Base64.DEFAULT)");
        return strEncodeToString;
    }
}
