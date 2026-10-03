package net.aihelp.p007ui.p009cs.middle.intent;

import net.aihelp.data.model.config.IntentEntity;

public interface IOnIntentViewEventListener {
    void onIntentSelected(IntentEntity intentEntity);

    void onIntentViewVisibilityChanged(int i);
}
