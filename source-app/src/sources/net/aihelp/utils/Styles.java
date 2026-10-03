package net.aihelp.utils;

import android.R;
import android.app.Activity;
import android.app.UiModeManager;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.StateListDrawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.core.graphics.drawable.DrawableCompat;
import androidx.core.view.ViewCompat;
import androidx.vectordrawable.graphics.drawable.VectorDrawableCompat;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.data.model.faq.FaqContentEntity;

public class Styles {
    public static int argb(double d, float f, float f2, float f3) {
        return (((int) ((d * 255.0d) + 0.5d)) << 24) | (((int) ((f * 255.0f) + 0.5f)) << 16) | (((int) ((f2 * 255.0f) + 0.5f)) << 8) | ((int) ((f3 * 255.0f) + 0.5f));
    }

    public static void reRenderTextView(TextView textView, String str) {
        reRenderTextView(textView, str, true);
    }

    public static void reRenderTextView(TextView textView, String str, boolean z) {
        reRenderTextView(textView, str, Color.parseColor(CustomConfig.CommonSetting.textColor), z, 15);
    }

    public static void reRenderTextView(TextView textView, String str, float f) {
        reRenderTextView(textView, str, getColorWithAlpha(CustomConfig.CommonSetting.textColor, f));
    }

    public static void reRenderTextView(TextView textView, String str, int i) {
        reRenderTextView(textView, str, i, true, 15);
    }

    public static void reRenderTextView(TextView textView, String str, int i, boolean z, int i2) {
        if (textView != null) {
            textView.setVisibility(z ? 0 : 8);
            textView.setText(str);
            textView.setTextColor(i);
            textView.setTextSize(i2);
            if (textView instanceof EditText) {
                EditText editText = (EditText) textView;
                editText.setText("");
                editText.setHint(str);
                editText.setHintTextColor(getColorWithAlpha(getHexColor(i), 0.3499999940395355d));
            }
        }
    }

    public static StateListDrawable getClickableDrawableForList() {
        return getClickableDrawable(getColorWithAlpha(CustomConfig.CommonSetting.upperBackgroundColor, CustomConfig.CommonSetting.upperBackgroundAlpha), 0, 0);
    }

    public static StateListDrawable getClickableDrawableForButton() {
        int color = Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor);
        return getClickableDrawable(color, color, 8);
    }

    public static StateListDrawable getClickableDrawable(int i, int i2, int i3) {
        StateListDrawable stateListDrawable = new StateListDrawable();
        stateListDrawable.addState(new int[]{R.attr.state_pressed}, getDrawable(getColorWithAlpha(isLightColor(i) ? -16777216 : -1, 0.1d), i3));
        stateListDrawable.addState(new int[]{-16842919}, getDrawable(i2, i3));
        return stateListDrawable;
    }

    public static Drawable getClickableDrawable(Context context, String str, int i, boolean z) {
        StateListDrawable stateListDrawable = new StateListDrawable();
        int drawableId = ResResolver.getDrawableId(str);
        if (drawableId != 0) {
            VectorDrawableCompat vectorDrawableCompatCreate = VectorDrawableCompat.create(context.getResources(), drawableId, (Resources.Theme) null);
            if (vectorDrawableCompatCreate != null) {
                DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate).mutate(), getColorWithAlpha(i, 1.0d));
            }
            stateListDrawable.addState(new int[]{-16842919}, vectorDrawableCompatCreate);
            if (z) {
                VectorDrawableCompat vectorDrawableCompatCreate2 = VectorDrawableCompat.create(context.getResources(), drawableId, (Resources.Theme) null);
                if (vectorDrawableCompatCreate2 != null) {
                    DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate2).mutate(), getColorWithAlpha(i, 0.699999988079071d));
                }
                stateListDrawable.addState(new int[]{R.attr.state_pressed}, vectorDrawableCompatCreate2);
            }
        }
        return stateListDrawable;
    }

    public static ColorStateList getClickableTextColor(String str) {
        return getClickableTextColor(Color.parseColor(str));
    }

    public static ColorStateList getClickableTextColor(int i) {
        return new ColorStateList(new int[][]{new int[]{R.attr.state_pressed}, new int[0]}, new int[]{getColorWithAlpha(i, 0.800000011920929d), getColorWithAlpha(i, 1.0d)});
    }

    public static void loadIcon(ImageView imageView, String str) {
        loadIcon(imageView, str, true);
    }

    public static void loadIcon(ImageView imageView, String str, boolean z) {
        loadIcon(imageView, str, z, "aihelp_svg_ic_placeholder");
    }

    public static void loadIcon(ImageView imageView, String str, boolean z, String str2) {
        if (imageView != null) {
            try {
                imageView.setVisibility(z ? 0 : 8);
                Context context = imageView.getContext();
                if ((context instanceof Activity) && ((Activity) context).isFinishing()) {
                    TLog.m138d("You cannot start a load for a destroyed activity, interrupt current invoke.");
                    return;
                }
                if (!TextUtils.isEmpty(str)) {
                    Glide.with(context).load(DomainSupportHelper.getAdjustedUrl(str)).placeholder(AppCompatResources.getDrawable(context, ResResolver.getDrawableId(str2))).into(imageView);
                    if (context.getResources().getConfiguration().getLayoutDirection() == 1) {
                        imageView.setScaleX(-1.0f);
                        return;
                    }
                    return;
                }
                imageView.setImageDrawable(AppCompatResources.getDrawable(context, ResResolver.getDrawableId(str2)));
            } catch (Exception unused) {
            }
        }
    }

    public static void reRenderImageView(ImageView imageView, String str, boolean z) {
        reRenderImageView(imageView, str, Color.parseColor(CustomConfig.CommonSetting.interactElementTextColor), z);
    }

    public static void reRenderImageView(ImageView imageView, String str) {
        reRenderImageView(imageView, str, false);
    }

    public static void reRenderImageView(ImageView imageView, String str, int i) {
        reRenderImageView(imageView, str, i, false);
    }

    public static void reRenderImageView(ImageView imageView, String str, int i, boolean z) {
        try {
            int drawableId = ResResolver.getDrawableId(str);
            if (imageView == null || drawableId == 0) {
                return;
            }
            Context context = imageView.getContext();
            if ((context instanceof Activity) && ((Activity) context).isFinishing()) {
                TLog.m138d("You cannot start a load for a destroyed activity, interrupt current invoke.");
                return;
            }
            imageView.setImageDrawable(getClickableDrawable(context, str, i, z));
            if (context.getResources().getConfiguration().getLayoutDirection() == 1) {
                imageView.setScaleX(-1.0f);
            }
        } catch (Exception unused) {
        }
    }

    public static boolean isLandscape() {
        return CustomConfig.CommonSetting.isLandscape;
    }

    public static int getScreenWidth(Context context) {
        int i = context.getResources().getDisplayMetrics().widthPixels;
        int i2 = context.getResources().getDisplayMetrics().heightPixels;
        return isLandscape() ? Math.max(i, i2) : Math.min(i, i2);
    }

    public static int getScreenHeight(Context context) {
        int i = context.getResources().getDisplayMetrics().widthPixels;
        int i2 = context.getResources().getDisplayMetrics().heightPixels;
        return isLandscape() ? Math.min(i, i2) : Math.max(i, i2);
    }

    public static int getColorFromAttr(Context context, int i) {
        TypedArray typedArrayObtainStyledAttributes = context.getTheme().obtainStyledAttributes(new int[]{i});
        int color = typedArrayObtainStyledAttributes.getColor(0, -1);
        typedArrayObtainStyledAttributes.recycle();
        return color;
    }

    public static int getColor(Context context, int i) {
        return context.getResources().getColor(i);
    }

    public static String getHexColor(Context context, int i) {
        return getHexColor(getColor(context, i));
    }

    public static String getHexColor(int i) {
        return String.format("#%06X", Integer.valueOf(i & 16777215));
    }

    public static boolean isLightColor(int i) {
        return 1.0d - ((((((double) Color.red(i)) * 0.299d) + (((double) Color.green(i)) * 0.587d)) + (((double) Color.blue(i)) * 0.114d)) / 255.0d) < 0.5d;
    }

    public static int getColor(String str) {
        return getColorWithAlpha(str, 1.0d);
    }

    public static int getColorWithAlpha(int i, double d) {
        try {
            return argb(d, ((16711680 & i) >> 16) / 255.0f, ((65280 & i) >> 8) / 255.0f, (i & 255) / 255.0f);
        } catch (Exception unused) {
            return -1;
        }
    }

    public static int getColorWithAlpha(String str, double d) {
        return getColorWithAlpha(Color.parseColor(str), d);
    }

    public static int[] getColorRGB(String str) {
        int color = Color.parseColor(str);
        return new int[]{(16711680 & color) >> 16, (65280 & color) >> 8, color & 255};
    }

    public static void setColorFilter(Context context, Drawable drawable, int i) {
        if (drawable != null) {
            drawable.setColorFilter(getColor(context, i), PorterDuff.Mode.SRC_ATOP);
        }
    }

    public static void setColorFilter(Drawable drawable, int i) {
        if (drawable != null) {
            drawable.setColorFilter(i, PorterDuff.Mode.SRC_ATOP);
        }
    }

    public static int dpToPx(Context context, float f) {
        if (context == null) {
            return 0;
        }
        return (int) (f * context.getResources().getDisplayMetrics().density);
    }

    public static int px2dp(Context context, float f) {
        return (int) ((f / context.getResources().getDisplayMetrics().density) + 0.5f);
    }

    public static StateListDrawable makeSelector(Context context) {
        StateListDrawable stateListDrawable = new StateListDrawable();
        VectorDrawableCompat vectorDrawableCompatCreate = VectorDrawableCompat.create(context.getResources(), ResResolver.getDrawableId("aihelp_svg_ic_bill_checked"), (Resources.Theme) null);
        if (vectorDrawableCompatCreate != null) {
            DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate).mutate(), getColor(CustomConfig.CommonSetting.interactElementTextColor));
        }
        VectorDrawableCompat vectorDrawableCompatCreate2 = VectorDrawableCompat.create(context.getResources(), ResResolver.getDrawableId("aihelp_svg_ic_bill_unchecked"), (Resources.Theme) null);
        if (vectorDrawableCompatCreate2 != null) {
            DrawableCompat.setTint(DrawableCompat.wrap(vectorDrawableCompatCreate2).mutate(), getColorWithAlpha(CustomConfig.CommonSetting.textColor, 0.3d));
        }
        stateListDrawable.addState(new int[]{R.attr.state_checked}, vectorDrawableCompatCreate);
        stateListDrawable.addState(new int[0], vectorDrawableCompatCreate2);
        return stateListDrawable;
    }

    public static Drawable getDrawable(int i, int i2) {
        GradientDrawable gradientDrawable = new GradientDrawable();
        gradientDrawable.setCornerRadius(i2);
        gradientDrawable.setColor(i);
        return gradientDrawable;
    }

    public static Drawable getDrawableWithCorner(int i, int i2, int i3, int i4, int i5) {
        GradientDrawable gradientDrawable = new GradientDrawable();
        float f = i2;
        float f2 = i3;
        float f3 = i4;
        float f4 = i5;
        gradientDrawable.setCornerRadii(new float[]{f, f, f2, f2, f3, f3, f4, f4});
        gradientDrawable.setColor(i);
        return gradientDrawable;
    }

    public static Drawable getDrawableWithStroke(Context context, int i) {
        GradientDrawable gradientDrawable = new GradientDrawable();
        gradientDrawable.mutate();
        gradientDrawable.setCornerRadius(i);
        gradientDrawable.setColor(0);
        gradientDrawable.setStroke(dpToPx(context, 1.0f), getColor(CustomConfig.CommonSetting.interactElementTextColor));
        return gradientDrawable;
    }

    public static void setGradientBackground(View view, int i, int i2, GradientDrawable.Orientation orientation) {
        ViewCompat.setBackground(view, new GradientDrawable(orientation, new int[]{i, i2}));
    }

    public static FaqContentEntity getFAQWithHighlightedSearchTerms(Context context, FaqContentEntity faqContentEntity, String str) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        String faqTitle = faqContentEntity.getFaqTitle();
        String faqContent = faqContentEntity.getFaqContent();
        String str2 = CustomConfig.CommonSetting.highlightedColor;
        String str3 = ">" + faqContent + "<";
        String str4 = ">" + faqTitle + "<";
        Pattern patternCompile = Pattern.compile(">[^<]+<");
        Matcher matcher = patternCompile.matcher(str4);
        String strReplace = str4;
        while (matcher.find()) {
            String strSubstring = str4.substring(matcher.start(), matcher.end());
            strReplace = strReplace.replace(strSubstring, strSubstring.replaceAll("(?i)(" + str + ")", "<span style=\"color: " + str2 + "\"></span>"));
        }
        Matcher matcher2 = patternCompile.matcher(str3);
        String strReplace2 = str3;
        while (matcher2.find()) {
            String strSubstring2 = str3.substring(matcher2.start(), matcher2.end());
            strReplace2 = strReplace2.replace(strSubstring2, strSubstring2.replaceAll("(?i)(" + str + ")", "<span style=\"color: " + str2 + "\">$1</span>"));
        }
        return new FaqContentEntity(faqContentEntity.getSecId(), strReplace.substring(1, strReplace.length() - 1), faqContentEntity.getFaqKeywords(), faqContentEntity.getFaqMainId(), faqContentEntity.getFaqDisplayId(), faqContentEntity.getFaqContentId(), strReplace2.substring(1, strReplace2.length() - 1), faqContentEntity.isHelpful(), faqContentEntity.getSearchTerm());
    }

    public static String getNoTemplateFaqContent(String str) {
        StringBuilder sb = new StringBuilder();
        String str2 = ">" + str + "<";
        Matcher matcher = Pattern.compile(">[^<]+").matcher(str2);
        while (matcher.find()) {
            String strReplace = matcher.toMatchResult().group().replace(">", "").replace("<", "");
            if (!strReplace.trim().contains("body {") && !TextUtils.isEmpty(strReplace.trim())) {
                sb.append(strReplace);
            }
        }
        if (TextUtils.isEmpty(sb.toString())) {
            sb.append(str2);
        }
        return sb.toString();
    }

    public static int getRandomColor() {
        Random random = new Random();
        int iNextInt = 0;
        int iNextInt2 = 0;
        int iNextInt3 = 0;
        for (int i = 0; i < 2; i++) {
            iNextInt = (iNextInt * 16) + random.nextInt(16);
            iNextInt2 = (iNextInt2 * 16) + random.nextInt(16);
            iNextInt3 = (iNextInt3 * 16) + random.nextInt(16);
        }
        return Color.rgb(iNextInt, iNextInt2, iNextInt3);
    }

    public static boolean isNightMode(Context context) {
        return ((UiModeManager) context.getSystemService("uimode")).getNightMode() == 2;
    }

    public static boolean isLayoutRtl(View view) {
        return view != null && ViewCompat.getLayoutDirection(view) == 1;
    }
}
