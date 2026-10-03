package ru.mopsicus.mobileinput;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Rect;
import android.graphics.Typeface;
import android.os.Build;
import android.text.Editable;
import android.text.SpannableString;
import android.text.TextPaint;
import android.text.TextWatcher;
import android.util.Log;
import android.util.SparseArray;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import com.sdkmanager.utils.Udid$;
import cz.msebera.android.httpclient.util.LangUtils;
import java.io.File;
import java.util.HashSet;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.core.net.mqtt.codec.DISCONNECT;
import net.aihelp.core.net.mqtt.codec.PINGREQ;
import net.aihelp.core.net.mqtt.codec.PINGRESP;
import net.aihelp.core.net.mqtt.codec.UNSUBACK;
import net.aihelp.data.model.rpa.msg.base.Message;
import net.aihelp.p007ui.helper.LogoutMqttHelper;
import okhttp3.internal.p011ws.WebSocketProtocol;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import ru.mopsicus.mobileinput.p012at.AtMethod;
import ru.mopsicus.mobileinput.p012at.AtUser;
import ru.mopsicus.mobileinput.p012at.KeyCodeDeleteHelper;

public class MobileInput {
    private static final String ANDROID_KEY_DOWN = "ANDROID_KEY_DOWN";
    private static final String CREATE = "CREATE_EDIT";
    private static final String DELETE_BUTTON = "DELETE_BUTTON";
    private static final String DELETE_MENTION = "DELETE_MENTION";
    private static final String IGNORE_CLICK = "IGNORE_CLICK";
    private static final String INSERT_MENTION = "INSERT_MENTION";
    private static final String INSERT_TEXT_SCROLL = "INSERT_TEXT_SCROLL";
    private static final String ON_FOCUS = "ON_FOCUS";
    private static final String ON_UNFOCUS = "ON_UNFOCUS";
    private static final String READY = "READY";
    private static final String REMOVE = "REMOVE_EDIT";
    private static final String RESET_MENTIONS = "RESET_MENTIONS";
    private static final String RETURN_PRESSED = "RETURN_PRESSED";
    private static final int RemoveComposeWhenInsert = 2;
    private static final String SET_BACKGROUND_COLOR = "SET_BACKGROUND_COLOR";
    private static final String SET_FOCUS = "SET_FOCUS";
    private static final String SET_HINTTEXT_COLOR = "SET_HINTTEXT_COLOR";
    private static final String SET_MAX_LINE = "SET_MAX_LINE";
    private static final String SET_RECT = "SET_RECT";
    private static final String SET_SELECTION = "SET_SELECTION";
    private static final String SET_TEXT = "SET_TEXT";
    private static final String SET_TEXT_COLOR = "SET_TEXT_COLOR";
    private static final String SET_VISIBLE = "SET_VISIBLE";
    private static final String TAG = "MobileInput";
    private static final String TEXT_CHANGE = "TEXT_CHANGE";
    private static final String TEXT_END_EDIT = "TEXT_END_EDIT";
    private static final int UseNewDeleteLogic = 1;
    private static SparseArray<MobileInput> mobileInputList;
    private AtMethod atMethod;
    private int characterLimit;

    private int f143id;
    private final RelativeLayout layout;
    private boolean isSettingText = false;
    private boolean isUnlockEmojiInput = false;
    private boolean inputFixIsOn = true;
    private boolean editIsFocus = false;
    private boolean isUnlockAt = false;
    private int flags = 0;
    private Typeface emojiTypeface = null;
    private boolean isHasLwEmoji = false;
    private int cursorPosition = 0;
    private boolean ignoreFocus = false;
    private EditText edit = null;

    private MobileInput(RelativeLayout relativeLayout) {
        this.layout = relativeLayout;
    }

    private void fixEditTextLineHeightImmediately(EditText editText) {
        if (Build.VERSION.SDK_INT >= 35) {
            try {
                Udid$.ExternalSyntheticApiModelOutline0.m$1(editText, false);
            } catch (NoSuchMethodError e) {
                Log.w(TAG, "setLocalePreferredLineHeightForMinimumUsed not available on this ROM.", e);
            }
        }
    }

    public static void processMessage(int i, String str) {
        if (mobileInputList == null) {
            mobileInputList = new SparseArray<>();
        }
        try {
            JSONObject jSONObject = new JSONObject(str);
            if (jSONObject.getString("msg").equals(CREATE)) {
                MobileInput mobileInput = new MobileInput(Plugin.layout);
                mobileInput.Create(i, jSONObject);
                mobileInputList.append(i, mobileInput);
            } else {
                MobileInput mobileInput2 = mobileInputList.get(i);
                if (mobileInput2 != null) {
                    mobileInput2.processData(jSONObject);
                }
            }
        } catch (JSONException e) {
            Plugin.common.sendError(Plugin.name, "RECEIVE_ERROR", e.getMessage());
        }
    }

    private void processData(JSONObject jSONObject) {
        byte b;
        try {
            String string = jSONObject.getString("msg");
            switch (string.hashCode()) {
                case -2067291199:
                    if (!string.equals(SET_RECT)) {
                        b = -1;
                    } else {
                        b = 3;
                    }
                    break;
                case -2067230966:
                    if (!string.equals(SET_TEXT)) {
                        b = -1;
                    } else {
                        b = 2;
                    }
                    break;
                case -1973273020:
                    if (!string.equals(INSERT_MENTION)) {
                        b = -1;
                    } else {
                        b = DISCONNECT.TYPE;
                    }
                    break;
                case -1751973547:
                    if (!string.equals(SET_VISIBLE)) {
                        b = -1;
                    } else {
                        b = 6;
                    }
                    break;
                case -1213583537:
                    if (!string.equals(SET_BACKGROUND_COLOR)) {
                        b = -1;
                    } else {
                        b = PINGREQ.TYPE;
                    }
                    break;
                case -625804101:
                    if (!string.equals(IGNORE_CLICK)) {
                        b = -1;
                    } else {
                        b = 0;
                    }
                    break;
                case 327698043:
                    if (!string.equals(SET_FOCUS)) {
                        b = -1;
                    } else {
                        b = 4;
                    }
                    break;
                case 376667500:
                    if (!string.equals(SET_MAX_LINE)) {
                        b = -1;
                    } else {
                        b = 10;
                    }
                    break;
                case 401988242:
                    if (!string.equals(ANDROID_KEY_DOWN)) {
                        b = -1;
                    } else {
                        b = 8;
                    }
                    break;
                case 550582734:
                    if (!string.equals(SET_TEXT_COLOR)) {
                        b = -1;
                    } else {
                        b = UNSUBACK.TYPE;
                    }
                    break;
                case 695783855:
                    if (!string.equals(SET_SELECTION)) {
                        b = -1;
                    } else {
                        b = 9;
                    }
                    break;
                case 912947270:
                    if (!string.equals(DELETE_BUTTON)) {
                        b = -1;
                    } else {
                        b = 5;
                    }
                    break;
                case 1709614489:
                    if (!string.equals(INSERT_TEXT_SCROLL)) {
                        b = -1;
                    } else {
                        b = 7;
                    }
                    break;
                case 1740012821:
                    if (!string.equals(SET_HINTTEXT_COLOR)) {
                        b = -1;
                    } else {
                        b = PINGRESP.TYPE;
                    }
                    break;
                case 1888511205:
                    if (!string.equals(REMOVE)) {
                        b = -1;
                    } else {
                        b = 1;
                    }
                    break;
                case 2059075801:
                    if (!string.equals(RESET_MENTIONS)) {
                        b = -1;
                    } else {
                        b = 15;
                    }
                    break;
                default:
                    b = -1;
                    break;
            }
            switch (b) {
                case 0:
                    SetIgnoreFocus(jSONObject.getBoolean("param"));
                    break;
                case 1:
                    Remove();
                    break;
                case 2:
                    SetText(jSONObject.getString("text"));
                    break;
                case 3:
                    SetRect(jSONObject);
                    break;
                case 4:
                    SetFocus(jSONObject.getBoolean("is_focus"));
                    break;
                case 5:
                    deleteCharacterAtCursor();
                    break;
                case 6:
                    SetVisible(jSONObject.getBoolean("is_visible"));
                    break;
                case 7:
                    insertTextAndScroll(jSONObject.getString("text"));
                    break;
                case 8:
                    OnForceAndroidKeyDown(jSONObject.getString("key"));
                    break;
                case 9:
                    SetSelection(jSONObject.getInt("start"), jSONObject.getInt("end"));
                    break;
                case 10:
                    SetMaxLines(jSONObject.getInt("line"));
                    break;
                case 11:
                    SetTextColor(jSONObject);
                    break;
                case Message.TYPE_USER_VIDEO:
                    SetBackgroundColor(jSONObject);
                    break;
                case 13:
                    SetHintTextColor(jSONObject);
                    break;
                case Message.TYPE_USER_FILE:
                    InsertMention(jSONObject);
                    break;
                case WebSocketProtocol.B0_MASK_OPCODE:
                    ResetMentions(jSONObject);
                    break;
            }
        } catch (JSONException e) {
            Plugin.common.sendError(Plugin.name, "PROCESS_ERROR", e.getMessage());
        }
    }

    private int calculateColor(double d) {
        return (int) Math.round(d * 255.0d);
    }

    private int GetColor(JSONObject jSONObject) {
        try {
            return Color.argb(calculateColor(jSONObject.getDouble("color_a")), calculateColor(jSONObject.getDouble("color_r")), calculateColor(jSONObject.getDouble("color_g")), calculateColor(jSONObject.getDouble("color_b")));
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    private void SetTextColor(JSONObject jSONObject) {
        EditText editText = this.edit;
        if (editText != null) {
            editText.setTextColor(GetColor(jSONObject));
        }
    }

    private void SetBackgroundColor(JSONObject jSONObject) {
        EditText editText = this.edit;
        if (editText != null) {
            editText.setBackgroundColor(GetColor(jSONObject));
        }
    }

    private void SetHintTextColor(JSONObject jSONObject) {
        EditText editText = this.edit;
        if (editText != null) {
            editText.setHintTextColor(GetColor(jSONObject));
        }
    }

    private void InsertMention(JSONObject jSONObject) {
        try {
            String string = jSONObject.getString("text");
            int iGetColor = GetColor(jSONObject);
            int i = jSONObject.getInt("offset");
            int i2 = jSONObject.getInt("index");
            Log.d("Unity", "InsertMention " + string + " " + i);
            AtUser atUser = new AtUser(string, iGetColor, i2);
            int selectionStart = this.edit.getSelectionStart();
            int selectionEnd = this.edit.getSelectionEnd();
            Editable text = this.edit.getText();
            if (i > 0 && selectionStart > 0 && selectionEnd > 0) {
                selectionStart = Math.max(0, selectionStart - i);
                selectionEnd = selectionStart + i;
            }
            if (IsFunctionOpen(2)) {
                Log.d("Unity", "RemoveComposeWhenInsertMention");
                ((InputMethodManager) this.edit.getContext().getSystemService("input_method")).restartInput(this.edit);
            }
            text.replace(selectionStart, selectionEnd, this.atMethod.newSpannable(atUser));
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    public void OnMentionDelete(int i) {
        Log.d("Unity", "OnMentionDelete " + i);
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("msg", DELETE_MENTION);
            jSONObject.put("index", i);
            sendData(jSONObject);
        } catch (JSONException unused) {
        }
    }

    private void ResetMentions(JSONObject jSONObject) {
        try {
            Editable text = this.edit.getText();
            JSONArray jSONArray = jSONObject.getJSONArray("list");
            Log.d("Unity", "list =>" + jSONArray.length());
            HashSet hashSet = new HashSet();
            for (int i = 0; i < jSONArray.length(); i++) {
                JSONObject jSONObject2 = jSONArray.getJSONObject(i);
                String string = jSONObject2.getString("text");
                int iGetColor = GetColor(jSONObject2);
                String string2 = text.toString();
                int i2 = jSONObject2.getInt("index");
                Log.d("Unity", "mentionTxt => " + string);
                for (int iIndexOf = string2.indexOf(string); iIndexOf != -1; iIndexOf = string2.indexOf(string, iIndexOf + 1)) {
                    if (!hashSet.contains(Integer.valueOf(iIndexOf))) {
                        hashSet.add(Integer.valueOf(iIndexOf));
                        text.replace(iIndexOf, string.length() + iIndexOf, this.atMethod.newSpannable(new AtUser(string, iGetColor, i2)));
                        break;
                    }
                }
            }
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    private void Create(int i, JSONObject jSONObject) {
        int i2;
        String str;
        byte b;
        String str2;
        int i3;
        byte b2;
        byte b3;
        int i4;
        int i5;
        int iCeil;
        this.f143id = i;
        try {
            String string = jSONObject.getString("placeholder");
            double d = jSONObject.getDouble("font_size");
            double d2 = jSONObject.getDouble("x") * ((double) this.layout.getWidth());
            double d3 = jSONObject.getDouble("y") * ((double) this.layout.getHeight());
            double d4 = jSONObject.getDouble("width") * ((double) this.layout.getWidth());
            double d5 = jSONObject.getDouble("height") * ((double) this.layout.getHeight());
            this.characterLimit = jSONObject.getInt("character_limit");
            int i6 = (int) (jSONObject.getDouble("text_color_r") * 255.0d);
            int i7 = (int) (jSONObject.getDouble("text_color_g") * 255.0d);
            int i8 = (int) (jSONObject.getDouble("text_color_b") * 255.0d);
            int i9 = (int) (jSONObject.getDouble("text_color_a") * 255.0d);
            int i10 = (int) (jSONObject.getDouble("back_color_r") * 255.0d);
            int i11 = (int) (jSONObject.getDouble("back_color_g") * 255.0d);
            int i12 = (int) (jSONObject.getDouble("back_color_b") * 255.0d);
            int i13 = (int) (jSONObject.getDouble("back_color_a") * 255.0d);
            int i14 = (int) (jSONObject.getDouble("placeholder_color_r") * 255.0d);
            int i15 = (int) (jSONObject.getDouble("placeholder_color_g") * 255.0d);
            int i16 = (int) (jSONObject.getDouble("placeholder_color_b") * 255.0d);
            int i17 = (int) (jSONObject.getDouble("placeholder_color_a") * 255.0d);
            String string2 = jSONObject.getString("content_type");
            String strOptString = jSONObject.optString("input_type");
            String strOptString2 = jSONObject.optString("keyboard_type");
            String string3 = jSONObject.getString("return_key_type");
            String string4 = jSONObject.getString("align");
            String string5 = jSONObject.getString("font");
            String string6 = jSONObject.getString("font_dir");
            String str3 = string6 == null ? "" : string6;
            boolean z = jSONObject.getBoolean("multiline");
            this.isUnlockEmojiInput = jSONObject.getBoolean("isUnlockEmojiInput");
            this.inputFixIsOn = jSONObject.getBoolean("inputFixIsOn");
            this.isUnlockAt = jSONObject.getBoolean("isUnlockAt");
            this.flags = jSONObject.getInt("functionFlags");
            int i18 = (int) jSONObject.getDouble("maxLine");
            if (this.isUnlockAt) {
                this.edit = new CustomEditText(Plugin.activity.getApplicationContext());
                AtMethod atMethod = new AtMethod();
                this.atMethod = atMethod;
                atMethod.init(this.edit);
                ((CustomEditText) this.edit).useNewDeleteLogic = IsFunctionOpen(1);
            } else {
                this.edit = new EditText(Plugin.activity.getApplicationContext());
            }
            fixEditTextLineHeightImmediately(this.edit);
            if (Build.VERSION.SDK_INT >= 29) {
                Udid$.ExternalSyntheticApiModelOutline0.m(this.edit, false);
            }
            this.edit.setSingleLine(!z);
            this.edit.setId(this.f143id);
            this.edit.setText("");
            this.edit.setHint(string);
            this.edit.setLayoutDirection(0);
            Rect rect = new Rect((int) d2, (int) d3, (int) (d2 + d4), (int) (d3 + d5));
            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(rect.width(), rect.height());
            layoutParams.setMargins(rect.left, rect.top, 0, 0);
            this.edit.setLayoutParams(layoutParams);
            this.edit.setPadding(0, 0, 0, 0);
            switch (string2) {
                case "Standard":
                case "Alphanumeric":
                    i2 = 16385;
                    break;
                case "Autocorrected":
                    i2 = 49153;
                    break;
                case "IntegerNumber":
                    i2 = 2;
                    break;
                case "DecimalNumber":
                    i2 = 8194;
                    break;
                case "Name":
                    i2 = 97;
                    break;
                case "EmailAddress":
                    i2 = 33;
                    break;
                case "Password":
                    i2 = 129;
                    break;
                case "Pin":
                    i2 = 3;
                    break;
                case "Custom":
                    switch (strOptString2.hashCode()) {
                        case -1822469688:
                            str = strOptString2;
                            if (!str.equals("Search")) {
                                b = -1;
                            } else {
                                b = 8;
                            }
                            break;
                        case -1813183603:
                            str = strOptString2;
                            if (!str.equals("Social")) {
                                b = -1;
                            } else {
                                b = 7;
                            }
                            break;
                        case -1806535749:
                            str = strOptString2;
                            if (!str.equals("ASCIICapable")) {
                                b = -1;
                            } else {
                                b = 0;
                            }
                            break;
                        case -1215479707:
                            str = strOptString2;
                            if (!str.equals("PhonePad")) {
                                b = -1;
                            } else {
                                b = 4;
                            }
                            break;
                        case -906611496:
                            str = strOptString2;
                            if (!str.equals("EmailAddress")) {
                                b = -1;
                            } else {
                                b = 6;
                            }
                            break;
                        case -745710643:
                            str2 = strOptString2;
                            if (!str2.equals("NumbersAndPunctuation")) {
                                str = str2;
                                b = -1;
                            } else {
                                str = str2;
                                b = 1;
                            }
                            break;
                        case -641086358:
                            str2 = strOptString2;
                            if (!str2.equals("NumberPad")) {
                                str = str2;
                                b = -1;
                            } else {
                                str = str2;
                                b = 3;
                            }
                            break;
                        case -56994800:
                            str2 = strOptString2;
                            if (!str2.equals("NamePhonePad")) {
                                str = str2;
                                b = -1;
                            } else {
                                str = str2;
                                b = 5;
                            }
                            break;
                        case 84303:
                            str2 = strOptString2;
                            if (!str2.equals("URL")) {
                                str = str2;
                                b = -1;
                            } else {
                                str = str2;
                                b = 2;
                            }
                            break;
                        default:
                            str = strOptString2;
                            b = -1;
                            break;
                    }
                    switch (b) {
                        case 0:
                            i3 = 524289;
                            break;
                        case 1:
                            i3 = 12290;
                            break;
                        case 2:
                            i3 = 524305;
                            break;
                        case 3:
                            i3 = 2;
                            break;
                        case 4:
                            i3 = 3;
                            break;
                        case 5:
                            i3 = 97;
                            break;
                        case 6:
                            i3 = 33;
                            break;
                        case 7:
                            i3 = 48;
                            break;
                        case 8:
                            i3 = 12321;
                            break;
                        default:
                            i3 = 1;
                            break;
                    }
                    int iHashCode = strOptString.hashCode();
                    if (iHashCode != 1231951771) {
                        if (iHashCode != 1281629883) {
                            if (iHashCode == 1377272541 && strOptString.equals("Standard")) {
                                b2 = 0;
                            } else {
                                b2 = -1;
                            }
                        } else if (strOptString.equals("Password")) {
                            b2 = 2;
                        } else {
                            b2 = -1;
                        }
                    } else if (strOptString.equals("AutoCorrect")) {
                        b2 = 1;
                    } else {
                        b2 = -1;
                    }
                    if (b2 != 1) {
                        if (b2 == 2) {
                            i2 = (str != "NumbersAndPunctuation" && str != "NumberPad" && str != "PhonePad") ? i3 | 129 : i3 | 16;
                        } else {
                            i2 = i3;
                        }
                        break;
                    } else {
                        i2 = 32768 | i3;
                        break;
                    }
                    break;
                default:
                    i2 = 1;
                    break;
            }
            if (z) {
                this.edit.setInputType(i2 | 147456);
                this.edit.setRawInputType(1);
            } else {
                this.edit.setInputType(i2);
            }
            switch (string4.hashCode()) {
                case -2068157527:
                    if (!string4.equals("UpperLeft")) {
                        b3 = -1;
                    } else {
                        b3 = 0;
                    }
                    break;
                case -1086833733:
                    if (!string4.equals("LowerRight")) {
                        b3 = -1;
                    } else {
                        b3 = 16;
                    }
                    break;
                case -913702425:
                    if (!string4.equals("TopRight")) {
                        b3 = -1;
                    } else {
                        b3 = 5;
                    }
                    break;
                case -476863894:
                    if (!string4.equals("MiddleCenter")) {
                        b3 = -1;
                    } else {
                        b3 = 8;
                    }
                    break;
                case 84277:
                    if (!string4.equals("Top")) {
                        b3 = -1;
                    } else {
                        b3 = 3;
                    }
                    break;
                case 2364455:
                    if (!string4.equals("Left")) {
                        b3 = -1;
                    } else {
                        b3 = 7;
                    }
                    break;
                case 78959100:
                    if (!string4.equals("Right")) {
                        b3 = -1;
                    } else {
                        b3 = UNSUBACK.TYPE;
                    }
                    break;
                case 234981014:
                    if (!string4.equals("LowerCenter")) {
                        b3 = -1;
                    } else {
                        b3 = DISCONNECT.TYPE;
                    }
                    break;
                case 310672626:
                    if (!string4.equals("BottomLeft")) {
                        b3 = -1;
                    } else {
                        b3 = PINGRESP.TYPE;
                    }
                    break;
                case 317287098:
                    if (!string4.equals("UpperRight")) {
                        b3 = -1;
                    } else {
                        b3 = 4;
                    }
                    break;
                case 524532444:
                    if (!string4.equals("TopLeft")) {
                        b3 = -1;
                    } else {
                        b3 = 1;
                    }
                    break;
                case 813053815:
                    if (!string4.equals("UpperCenter")) {
                        b3 = -1;
                    } else {
                        b3 = 2;
                    }
                    break;
                case 1046577809:
                    if (!string4.equals("BottomRight")) {
                        b3 = -1;
                    } else {
                        b3 = 17;
                    }
                    break;
                case 1175189340:
                    if (!string4.equals("MiddleLeft")) {
                        b3 = -1;
                    } else {
                        b3 = 6;
                    }
                    break;
                case 1488778888:
                    if (!string4.equals("LowerLeft")) {
                        b3 = -1;
                    } else {
                        b3 = PINGREQ.TYPE;
                    }
                    break;
                case 1995605579:
                    if (!string4.equals("Bottom")) {
                        b3 = -1;
                    } else {
                        b3 = 15;
                    }
                    break;
                case 2014820469:
                    if (!string4.equals("Center")) {
                        b3 = -1;
                    } else {
                        b3 = 9;
                    }
                    break;
                case 2076792167:
                    if (!string4.equals("MiddleRight")) {
                        b3 = -1;
                    } else {
                        b3 = 10;
                    }
                    break;
                default:
                    b3 = -1;
                    break;
            }
            switch (b3) {
                case 0:
                case 1:
                    i4 = 51;
                    break;
                case 2:
                case 3:
                    i4 = 49;
                    break;
                case 4:
                case 5:
                    i4 = 53;
                    break;
                case 6:
                case 7:
                    i4 = 19;
                    break;
                case 8:
                case 9:
                    i4 = 17;
                    break;
                case 10:
                case 11:
                    i4 = 21;
                    break;
                case Message.TYPE_USER_VIDEO:
                case 13:
                    i4 = 83;
                    break;
                case Message.TYPE_USER_FILE:
                case WebSocketProtocol.B0_MASK_OPCODE:
                    i4 = 81;
                    break;
                case 16:
                case LangUtils.HASH_SEED:
                    i4 = 85;
                    break;
                default:
                    i4 = 0;
                    break;
            }
            if (string3.equals("Next")) {
                i5 = 268435461;
            } else if (string3.equals("Done")) {
                i5 = 268435462;
            } else if (string3.equals("Search")) {
                i5 = 268435459;
            } else {
                i5 = string3.equals("Send") ? 268435460 : 268435456;
            }
            this.edit.setImeOptions(i5);
            this.edit.setGravity(i4);
            this.edit.setTextColor(Color.argb(i9, i6, i7, i8));
            this.edit.setBackgroundColor(Color.argb(i13, i10, i11, i12));
            this.edit.setHintTextColor(Color.argb(i17, i14, i15, i16));
            this.edit.invalidate();
            if (!string5.equals("default")) {
                try {
                    this.edit.setTypeface(Typeface.createFromAsset(Plugin.activity.getAssets(), String.format("%s.ttf", string5)));
                } catch (Exception e) {
                    this.edit.setTypeface(Typeface.SANS_SERIF);
                    Log.e(TAG, "MobileInput an error occurred", e);
                }
            } else {
                this.edit.setTypeface(Typeface.SANS_SERIF);
            }
            if (!str3.isEmpty()) {
                String strExtractAssetPath = extractAssetPath(str3);
                if (strExtractAssetPath == null || strExtractAssetPath.isEmpty()) {
                    String str4 = str3;
                    File file = new File(str4);
                    if (file.exists() && file.isFile()) {
                        this.emojiTypeface = Typeface.createFromFile(file);
                    } else {
                        Log.e(TAG, String.format("MobileInput the font file %s is not in dir %s", string5, str4));
                    }
                } else {
                    this.emojiTypeface = Typeface.createFromAsset(Plugin.activity.getAssets(), strExtractAssetPath.replace("/assets/", ""));
                    this.edit.setTypeface(Typeface.SANS_SERIF);
                }
            }
            this.edit.setTextSize(0, (float) d);
            this.edit.setOnFocusChangeListener(new View.OnFocusChangeListener() {
                @Override
                public void onFocusChange(View view, boolean z2) {
                    MobileInput.this.editIsFocus = z2;
                    if (!z2) {
                        JSONObject jSONObject2 = new JSONObject();
                        try {
                            jSONObject2.put("msg", MobileInput.TEXT_END_EDIT);
                            jSONObject2.put("text", this.GetText());
                        } catch (JSONException unused) {
                        }
                        MobileInput.this.sendData(jSONObject2);
                    }
                    MobileInput.this.SetFocus(z2);
                    JSONObject jSONObject3 = new JSONObject();
                    try {
                        jSONObject3.put("msg", z2 ? MobileInput.ON_FOCUS : MobileInput.ON_UNFOCUS);
                    } catch (JSONException unused2) {
                    }
                    MobileInput.this.sendData(jSONObject3);
                    if (z2) {
                        return;
                    }
                    MobileInput mobileInput = MobileInput.this;
                    mobileInput.cursorPosition = mobileInput.edit.getSelectionStart();
                }
            });
            this.edit.setMaxLines(i18);
            this.edit.addTextChangedListener(new C09252());
            this.edit.setOnEditorActionListener(new TextView.OnEditorActionListener() {
                @Override
                public boolean onEditorAction(TextView textView, int i19, KeyEvent keyEvent) {
                    if (i19 != 6 && i19 != 5 && i19 != 3 && i19 != 4) {
                        return false;
                    }
                    JSONObject jSONObject2 = new JSONObject();
                    try {
                        jSONObject2.put("msg", MobileInput.RETURN_PRESSED);
                    } catch (JSONException unused) {
                    }
                    MobileInput.this.sendData(jSONObject2);
                    return true;
                }
            });
            this.edit.setOnKeyListener(new View.OnKeyListener() {
                @Override
                public boolean onKey(View view, int i19, KeyEvent keyEvent) {
                    if (i19 != 66 || keyEvent.getAction() != 1) {
                        if (!MobileInput.this.isUnlockAt || i19 != 67 || keyEvent.getAction() != 0) {
                            return false;
                        }
                        boolean zOnDelDown = KeyCodeDeleteHelper.onDelDown(((EditText) view).getText());
                        if (zOnDelDown) {
                            Iterator<Integer> it = KeyCodeDeleteHelper.deleteMentions.iterator();
                            while (it.hasNext()) {
                                MobileInput.this.OnMentionDelete(it.next().intValue());
                            }
                        }
                        return zOnDelDown;
                    }
                    JSONObject jSONObject2 = new JSONObject();
                    try {
                        jSONObject2.put("msg", MobileInput.RETURN_PRESSED);
                    } catch (JSONException unused) {
                    }
                    MobileInput.this.sendData(jSONObject2);
                    return true;
                }
            });
            if (this.isUnlockAt) {
                ((CustomEditText) this.edit).setOnSelectionChangeListener(new CustomEditText.OnSelectionChangeListener() {
                    @Override
                    public void onSelectionChanged(int i19, int i20) {
                        MobileInput.this.NotifySelectionChange(i19, i20);
                    }
                });
            }
            this.layout.addView(this.edit);
            JSONObject jSONObject2 = new JSONObject();
            try {
                TextPaint paint = this.edit.getPaint();
                if (paint != null) {
                    iCeil = (int) Math.ceil(paint.getFontMetrics().bottom - paint.getFontMetrics().top);
                } else {
                    Plugin.common.sendError(Plugin.name, "UMI获取文本高度失败！获取不到EditorText对应的Paint");
                    iCeil = 42;
                }
                jSONObject2.put("charHeight", Integer.toString(iCeil));
                jSONObject2.put("msg", READY);
            } catch (JSONException unused) {
            }
            sendData(jSONObject2);
        } catch (JSONException e2) {
            Plugin.common.sendError(Plugin.name, "CREATE_ERROR", e2.getMessage());
        }
    }

    class C09252 implements TextWatcher {
        @Override
        public void beforeTextChanged(CharSequence charSequence, int i, int i2, int i3) {
        }

        C09252() {
        }

        @Override
        public void afterTextChanged(Editable editable) {
            if (MobileInput.this.isSettingText) {
                return;
            }
            if (!MobileInput.this.editIsFocus || MobileInput.this.isHasLwEmoji) {
                if (MobileInput.this.isUnlockAt) {
                    MobileInput.this.applyEmojiFontNew(editable);
                } else {
                    MobileInput.this.applyEmojiFont(editable);
                }
            }
            final JSONObject jSONObject = new JSONObject();
            if (MobileInput.this.characterLimit > 0 && editable.length() >= MobileInput.this.characterLimit + 1) {
                editable.delete(editable.length() - 1, editable.length());
                MobileInput.this.edit.setText(editable);
                MobileInput.this.edit.setSelection(editable.length());
            }
            try {
                jSONObject.put("msg", MobileInput.TEXT_CHANGE);
                jSONObject.put("text", editable.toString());
                jSONObject.put("selectionStart", MobileInput.this.edit.getSelectionStart());
                jSONObject.put("selectionEnd", MobileInput.this.edit.getSelectionEnd());
            } catch (JSONException unused) {
            }
            MobileInput.this.edit.post(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.m2100lambda$afterTextChanged$0$rumopsicusmobileinputMobileInput$2(jSONObject);
                }
            });
        }

        void m2100lambda$afterTextChanged$0$rumopsicusmobileinputMobileInput$2(JSONObject jSONObject) {
            int lineCount = MobileInput.this.edit.getLineCount();
            Log.d("行数", "最终行数：" + lineCount);
            try {
                jSONObject.put("lineCount", Integer.toString(lineCount));
                MobileInput mobileInput = MobileInput.this;
                mobileInput.cursorPosition = mobileInput.edit.getSelectionStart();
                MobileInput.this.sendData(jSONObject);
            } catch (JSONException unused) {
            }
        }

        @Override
        public void onTextChanged(CharSequence charSequence, int i, int i2, int i3) {
            String string = charSequence.toString();
            if (i3 > 0) {
                Matcher matcher = Pattern.compile("[\\uE000-\\uEFFF]").matcher(string.subSequence(i, i3 + i).toString());
                MobileInput.this.isHasLwEmoji = matcher.find();
            }
        }
    }

    private void SettingTextNotChange(SpannableString spannableString) {
        this.isSettingText = true;
        this.edit.setText(spannableString);
        this.isSettingText = false;
    }

    private void deleteCharacterAtCursor() {
        if (this.cursorPosition > 0) {
            Editable text = this.edit.getText();
            if (!this.isUnlockAt || !KeyCodeDeleteHelper.onDelDown(this.edit.getText())) {
                text.delete(getStartOfPreviousCharacter(text, this.cursorPosition), this.cursorPosition);
                return;
            }
            Iterator<Integer> it = KeyCodeDeleteHelper.deleteMentions.iterator();
            while (it.hasNext()) {
                OnMentionDelete(it.next().intValue());
            }
        }
    }

    public void logWithStackTrace(String str, String str2) {
        StackTraceElement[] stackTrace = new Throwable().getStackTrace();
        StringBuilder sb = new StringBuilder();
        sb.append(str2);
        sb.append("\n");
        for (int i = 1; i < stackTrace.length; i++) {
            sb.append("\tat ");
            sb.append(stackTrace[i].toString());
            sb.append("\n");
        }
        Log.e(str, sb.toString());
    }

    public void logWithStack(String str) {
        StackTraceElement[] stackTrace = new Exception().getStackTrace();
        StringBuilder sb = new StringBuilder("📌 [LogWithStack] ");
        sb.append(str);
        sb.append("\n");
        for (StackTraceElement stackTraceElement : stackTrace) {
            sb.append("\tat ");
            sb.append(stackTraceElement.toString());
            sb.append("\n");
        }
        System.out.println(sb.toString());
    }

    private int getStartOfPreviousCharacter(Editable editable, int i) {
        if (i <= 0) {
            return 0;
        }
        return Math.max(i - Character.charCount(Character.codePointBefore(editable, i)), 0);
    }

    private void insertTextAndScroll(String str) {
        int selectionStart;
        if (!this.inputFixIsOn) {
            selectionStart = this.edit.getSelectionStart();
            if (selectionStart < 0 || selectionStart > this.edit.getText().length()) {
                selectionStart = this.edit.getText().length();
            }
        } else {
            selectionStart = this.cursorPosition;
        }
        String string = this.edit.getText().toString();
        String str2 = string.substring(0, selectionStart) + str + string.substring(selectionStart);
        if (this.isUnlockAt) {
            Editable text = this.edit.getText();
            SpannableString spannableString = new SpannableString(str);
            spannableString.setSpan(new CustomTypefaceSpan(this.emojiTypeface), 0, spannableString.length(), 33);
            text.insert(selectionStart, spannableString);
        } else {
            this.edit.setText(str2);
        }
        int length = selectionStart + str.length();
        this.edit.setSelection(length);
        this.cursorPosition = length;
    }

    public void applyEmojiFont(Editable editable) {
        if (this.emojiTypeface == null || !this.isUnlockEmojiInput) {
            return;
        }
        int selectionStart = this.edit.getSelectionStart();
        SpannableString spannableString = new SpannableString(editable);
        Matcher matcher = Pattern.compile("[\\uE000-\\uEFFF]").matcher(editable);
        while (matcher.find()) {
            spannableString.setSpan(new CustomTypefaceSpan(this.emojiTypeface), matcher.start(), matcher.end(), 33);
        }
        SettingTextNotChange(spannableString);
        this.edit.setSelection(selectionStart);
        this.isHasLwEmoji = false;
    }

    public void applyEmojiFontNew(Editable editable) {
        if (this.emojiTypeface == null || !this.isUnlockEmojiInput) {
            return;
        }
        int selectionStart = this.edit.getSelectionStart();
        Matcher matcher = Pattern.compile("[\\uE000-\\uEFFF]").matcher(editable);
        while (matcher.find()) {
            editable.setSpan(new CustomTypefaceSpan(this.emojiTypeface), matcher.start(), matcher.end(), 33);
        }
        this.edit.setSelection(selectionStart);
        this.isHasLwEmoji = false;
    }

    private void SetSelection(int i, int i2) {
        int length = this.edit.getText().length();
        int iMax = Math.max(0, Math.min(i, length));
        this.edit.setSelection(iMax, Math.max(iMax, Math.min(i2, length)));
    }

    public void NotifySelectionChange(int i, int i2) {
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("msg", SET_SELECTION);
            jSONObject.put("start", i);
            jSONObject.put("end", i2);
            sendData(jSONObject);
        } catch (JSONException unused) {
        }
    }

    private void SetMaxLines(int i) {
        this.edit.setMaxLines(i);
    }

    public static String extractAssetPath(String str) {
        int iIndexOf = str.indexOf("!");
        if (iIndexOf != -1) {
            return str.substring(iIndexOf + 1);
        }
        return null;
    }

    private void Remove() {
        EditText editText = this.edit;
        if (editText != null) {
            this.layout.removeView(editText);
        }
        this.edit = null;
    }

    private void SetText(String str) {
        EditText editText = this.edit;
        if (editText != null) {
            editText.setText(str);
        }
    }

    public String GetText() {
        EditText editText = this.edit;
        if (editText != null) {
            return editText.getText().toString();
        }
        return "";
    }

    private boolean isFocused() {
        EditText editText = this.edit;
        if (editText != null) {
            return editText.isFocused();
        }
        return false;
    }

    public void SetIgnoreFocus(boolean z) {
        this.ignoreFocus = z;
    }

    public void SetFocus(boolean z) {
        if (this.ignoreFocus && z) {
            JSONObject jSONObject = new JSONObject();
            try {
                jSONObject.put("msg", z ? ON_FOCUS : ON_UNFOCUS);
            } catch (JSONException unused) {
            }
            sendData(jSONObject);
            z = false;
        }
        EditText editText = this.edit;
        if (editText == null) {
            return;
        }
        if (z) {
            editText.requestFocus();
        } else {
            editText.clearFocus();
        }
        if (!z) {
            for (int i = 0; i < mobileInputList.size(); i++) {
                if (mobileInputList.get(mobileInputList.keyAt(i)).isFocused()) {
                    return;
                }
            }
        }
        showKeyboard(z);
    }

    private void SetRect(JSONObject jSONObject) {
        try {
            double d = jSONObject.getDouble("x") * ((double) this.layout.getWidth());
            double d2 = jSONObject.getDouble("y") * ((double) this.layout.getHeight());
            Rect rect = new Rect((int) d, (int) d2, (int) (d + (jSONObject.getDouble("width") * ((double) this.layout.getWidth()))), (int) (d2 + (jSONObject.getDouble("height") * ((double) this.layout.getHeight()))));
            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(rect.width(), rect.height());
            layoutParams.setMargins(rect.left, rect.top, 0, 0);
            this.edit.setLayoutParams(layoutParams);
        } catch (JSONException unused) {
        }
    }

    private void SetVisible(boolean z) {
        EditText editText = this.edit;
        if (editText == null) {
            return;
        }
        editText.setEnabled(z);
        this.edit.setVisibility(z ? 0 : 4);
        if (z) {
            this.edit.invalidate();
            this.edit.requestLayout();
        }
    }

    private boolean IsFunctionOpen(int i) {
        return ((1 << i) & this.flags) != 0;
    }

    private void OnForceAndroidKeyDown(String str) {
        int i;
        if (isFocused()) {
            if (str.equalsIgnoreCase("backspace")) {
                i = 67;
            } else if (str.equalsIgnoreCase("enter")) {
                i = 66;
            } else if (str.equals("0")) {
                i = 7;
            } else if (str.equals("1")) {
                i = 8;
            } else if (str.equals("2")) {
                i = 9;
            } else if (str.equals("3")) {
                i = 10;
            } else if (str.equals("4")) {
                i = 11;
            } else if (str.equals(LogoutMqttHelper.LOGOUT_TYPE_FAQ_DISPLAY)) {
                i = 12;
            } else if (str.equals(LogoutMqttHelper.LOGOUT_TYPE_ACTION_DISPLAY)) {
                i = 13;
            } else if (str.equals(LogoutMqttHelper.LOGOUT_TYPE_FORM_GOTO_PAGE)) {
                i = 14;
            } else if (str.equals(LogoutMqttHelper.LOGOUT_TYPE_FORM_SUBMIT)) {
                i = 15;
            } else {
                i = str.equals("9") ? 16 : -1;
            }
            if (i > 0) {
                this.edit.onKeyDown(i, new KeyEvent(0, i));
            }
        }
    }

    private void showKeyboard(boolean z) {
        Activity activity = Plugin.activity;
        Activity activity2 = Plugin.activity;
        InputMethodManager inputMethodManager = (InputMethodManager) activity.getSystemService("input_method");
        View decorView = Plugin.activity.getWindow().getDecorView();
        if (z) {
            inputMethodManager.showSoftInput(this.edit, 2);
            return;
        }
        this.edit.clearFocus();
        decorView.clearFocus();
        inputMethodManager.hideSoftInputFromWindow(this.edit.getWindowToken(), 0);
    }

    public void sendData(JSONObject jSONObject) {
        try {
            jSONObject.put("id", this.f143id);
        } catch (JSONException unused) {
        }
        Plugin.common.sendData(Plugin.name, jSONObject.toString());
    }
}
