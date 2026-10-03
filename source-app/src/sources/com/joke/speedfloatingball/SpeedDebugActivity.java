package com.joke.speedfloatingball;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

public class SpeedDebugActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LinearLayout linearLayout = new LinearLayout(this);
        linearLayout.setLayoutParams(new ViewGroup.LayoutParams(-1, -1));
        linearLayout.setOrientation(1);
        linearLayout.setGravity(17);
        linearLayout.setBackgroundColor(Color.parseColor("#101010"));
        TextView title = new TextView(this);
        title.setText("BmFloatSpeedLayout Demo");
        title.setTextColor(-1);
        title.setTextSize(2, 22.0f);
        linearLayout.addView(title);
        TextView tips = new TextView(this);
        LinearLayout.LayoutParams tipsParams = new LinearLayout.LayoutParams(-2, -2);
        tipsParams.topMargin = m0dp(12);
        tips.setLayoutParams(tipsParams);
        tips.setText("Open this page and the speed floating ball will show automatically.");
        tips.setTextColor(Color.parseColor("#CCCCCC"));
        tips.setTextSize(2, 14.0f);
        linearLayout.addView(tips);
        setContentView(linearLayout);
    }

    private int m0dp(int value) {
        return (int) ((value * getResources().getDisplayMetrics().density) + 0.5f);
    }
}
