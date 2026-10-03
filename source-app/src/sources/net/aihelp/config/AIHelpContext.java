package net.aihelp.config;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicBoolean;
import net.aihelp.utils.LocaleUtil;

public class AIHelpContext {
    private static AIHelpContext INSTANCE;
    private static final Object lock = new Object();
    public static AtomicBoolean successfullyInit = new AtomicBoolean(false);
    private Context context;

    private AIHelpContext() {
    }

    public static AIHelpContext getInstance() {
        if (INSTANCE == null) {
            synchronized (lock) {
                if (INSTANCE == null) {
                    INSTANCE = new AIHelpContext();
                }
            }
        }
        return INSTANCE;
    }

    public void setContext(Context context) {
        synchronized (lock) {
            this.context = context;
        }
    }

    public Context getContext() {
        return this.context;
    }

    public static Context createContextWithLocale(Context context, String str) {
        Locale currentLocale = LocaleUtil.getCurrentLocale(str);
        Resources resources = context.getResources();
        Configuration configuration = new Configuration(resources.getConfiguration());
        configuration.setLocale(currentLocale);
        Context contextCreateConfigurationContext = context.createConfigurationContext(configuration);
        if (contextCreateConfigurationContext != null) {
            return contextCreateConfigurationContext;
        }
        configuration.locale = currentLocale;
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
        return context;
    }

    public static Context getLocaleUpdatedContext(Context context, String str) {
        Locale currentLocale = LocaleUtil.getCurrentLocale(str);
        Resources resources = context.getResources();
        Configuration configuration = new Configuration(resources.getConfiguration());
        configuration.locale = currentLocale;
        resources.updateConfiguration(configuration, resources.getDisplayMetrics());
        return context;
    }
}
