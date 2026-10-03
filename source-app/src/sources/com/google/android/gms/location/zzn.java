package com.google.android.gms.location;

import com.google.android.gms.common.internal.Preconditions;
import java.util.Comparator;

final class zzn implements Comparator<ActivityTransition> {
    zzn() {
    }

    @Override
    public final int compare(ActivityTransition activityTransition, ActivityTransition activityTransition2) {
        ActivityTransition activityTransition3 = activityTransition;
        ActivityTransition activityTransition4 = activityTransition2;
        Preconditions.checkNotNull(activityTransition3);
        Preconditions.checkNotNull(activityTransition4);
        int activityType = activityTransition3.getActivityType();
        int activityType2 = activityTransition4.getActivityType();
        if (activityType != activityType2) {
            return activityType >= activityType2 ? 1 : -1;
        }
        int transitionType = activityTransition3.getTransitionType();
        int transitionType2 = activityTransition4.getTransitionType();
        if (transitionType == transitionType2) {
            return 0;
        }
        return transitionType < transitionType2 ? -1 : 1;
    }
}
