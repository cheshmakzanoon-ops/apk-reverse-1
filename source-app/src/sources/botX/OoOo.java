package botX;

import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.InsetDrawable;
import android.net.Uri;
import android.util.Base64;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.security.MessageDigest;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

public class OoOo {
    private static AlertDialog alert;
    private static TextView but;
    private static TextView but1;
    private static LinearLayout button;
    private static LinearLayout dialog;
    private static TextView message;
    private static int showTime = 2;
    private static TextView title;

    private static SecretKey generateKey(String str) throws Exception {
        MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
        byte[] bytes = str.getBytes("UTF-8");
        messageDigest.update(bytes, 0, bytes.length);
        return new SecretKeySpec(messageDigest.digest(), "AES");
    }

    public static String decrypt(String str, String str2) {
        try {
            SecretKeySpec secretKeySpec = (SecretKeySpec) generateKey(str2);
            Cipher cipher = Cipher.getInstance("AES");
            cipher.init(2, secretKeySpec);
            return new String(cipher.doFinal(Base64.decode(str, 0)));
        } catch (Exception e) {
            return "";
        }
    }

    private static LinearLayout.LayoutParams param() {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-1, -2);
        layoutParams.weight = 1.0f;
        return layoutParams;
    }

    private static void designTexts() {
        title.setPadding(5, 10, 0, 50);
        title.setGravity(17);
        title.setTextSize(18.0f);
        title.setTextColor(Color.parseColor("#FF00FF73"));
        title.setLayoutParams(param());
        message.setLayoutParams(param());
        message.setGravity(17);
        message.setPadding(5, 10, 0, 50);
        message.setTextSize(16.0f);
        message.setTextColor(Color.parseColor("#FFFFFFFF"));
        but.setTextSize(15.0f);
        but.setPadding(20, 0, 30, 0);
        but.setLayoutParams(param());
        but.setGravity(5);
        but.setTextColor(Color.parseColor("#FFFFFFFF"));
        but1.setTextSize(15.0f);
        but1.setPadding(20, 0, 30, 0);
        but1.setTextColor(Color.parseColor("#FFFFFFFF"));
    }

    private static void designLayouts() {
        button.setLayoutParams(param());
        button.setPadding(0, 10, 0, 0);
        dialog.setPadding(50, 50, 50, 50);
        dialog.setElevation(0.0f);
        dialog.setOrientation(1);
        dialog.setBackgroundDrawable(new GradientDrawable() {
            public GradientDrawable getIns(int i, String str) {
                setCornerRadius(i);
                setColor(Color.parseColor(str));
                return this;
            }
        }.getIns(30, "#FF000000"));
        dialog.setLayoutParams(param());
        alert.getWindow().setBackgroundDrawable(new InsetDrawable((Drawable) new ColorDrawable(0), 20));
    }

    public static void get(final Context context) {
        if (context.getSharedPreferences("", 0).getInt("ESAQgdHMD", 0) != showTime) {
            context.getSharedPreferences("", 0).edit().putInt("ESAQgdHMD", context.getSharedPreferences("", 0).getInt("ESAQgdHMD", 0) + 1).commit();
            alert = new AlertDialog.Builder(context).create();
            dialog = new LinearLayout(context);
            title = new TextView(context);
            message = new TextView(context);
            button = new LinearLayout(context);
            but = new TextView(context);
            but1 = new TextView(context);
            String strDecrypt = decrypt("ApBFn3h/uvUoC8k0zMmGz63f6txvy5AXC6Ywk5LfpzU=", "MOD BY MODSMANIAC.COM");
            String strDecrypt2 = decrypt("crv74zCKMOJQXARwgqyGYqf/xszsi8VZqBo/84bq4qpDgW+Q6VOpkcaAP0KW4wtW2lcQhTZ9Kb3lSmKbmFOdmw==", "Join Our Telegram Channel For Regular Updates! : -)");
            String strDecrypt3 = decrypt("ugLeDG+NQGh0N9qjt1weNw==", "CLOSE");
            String strDecrypt4 = decrypt("Ymo6grQgL24uhCb0cuXu7w==", "JOIN TELEGRAM");
            try {
                title.setTypeface(Typeface.createFromAsset(context.getAssets(), "title.ttf"), 1);
                message.setTypeface(Typeface.createFromAsset(context.getAssets(), "message.ttf"), 0);
                but.setTypeface(Typeface.createFromAsset(context.getAssets(), "button.ttf"), 0);
                but1.setTypeface(Typeface.createFromAsset(context.getAssets(), "button.ttf"), 0);
            } catch (Exception e) {
                title.setTypeface(Typeface.SANS_SERIF, 1);
                message.setTypeface(Typeface.SANS_SERIF, 0);
                but.setTypeface(Typeface.SANS_SERIF, 0);
                but1.setTypeface(Typeface.SANS_SERIF, 0);
            }
            designLayouts();
            designTexts();
            button.addView(but, 0);
            button.addView(but1, 1);
            dialog.addView(title, 0);
            dialog.addView(message, 1);
            dialog.addView(button, 2);
            alert.setView(dialog);
            but1.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    OoOo.alert.dismiss();
                    context.startActivity(new Intent("android.intent.action.VIEW", Uri.parse(OoOo.decrypt("8E/31FrGGot6lnXNZeUhLG1HUpE3D/lIPTyenjP3EIxSngf6v2qVag73VUZbQs2d", "https://telegram.me/ModsManiacDOTCOM"))));
                }
            });
            but.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    OoOo.alert.dismiss();
                }
            });
            title.setText(strDecrypt);
            message.setText(strDecrypt2);
            but.setText(strDecrypt3);
            but1.setText(strDecrypt4);
            alert.show();
        }
    }
}
