package androidx.activity.compose;

import androidx.activity.result.ActivityResultRegistry;
import androidx.activity.result.ActivityResultRegistryOwner;
import androidx.activity.result.contract.ActivityResultContract;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.EffectsKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import androidx.compose.runtime.saveable.RememberSaveableKt;
import androidx.compose.runtime.saveable.Saver;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\u001aM\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00030\u0001\"\u0004\b\u0000\u0010\u0002\"\u0004\b\u0001\u0010\u00032\u0012\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00030\u00052\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u0002H\u0003\u0012\u0004\u0012\u00020\b0\u0007H\u0007¢\u0006\u0002\u0010\t¨\u0006\n"}, d2 = {"rememberLauncherForActivityResult", "Landroidx/activity/compose/ManagedActivityResultLauncher;", "I", "O", "contract", "Landroidx/activity/result/contract/ActivityResultContract;", "onResult", "Lkotlin/Function1;", "", "(Landroidx/activity/result/contract/ActivityResultContract;Lkotlin/jvm/functions/Function1;Landroidx/compose/runtime/Composer;I)Landroidx/activity/compose/ManagedActivityResultLauncher;", "activity-compose_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ActivityResultRegistryKt {
    public static final <I, O> ManagedActivityResultLauncher<I, O> rememberLauncherForActivityResult(ActivityResultContract<I, O> activityResultContract, Function1<? super O, Unit> function1, Composer composer, int i) {
        composer.startReplaceableGroup(-1408504823);
        ComposerKt.sourceInformation(composer, "C(rememberLauncherForActivityResult)86@3568L30,87@3625L30,91@3794L49,*93@3924L7,96@4078L46,97@4152L85,103@4420L204,103@4364L260:ActivityResultRegistry.kt#q1dkbc");
        State stateRememberUpdatedState = SnapshotStateKt.rememberUpdatedState(activityResultContract, composer, i & 14);
        State stateRememberUpdatedState2 = SnapshotStateKt.rememberUpdatedState(function1, composer, (i >> 3) & 14);
        String str = (String) RememberSaveableKt.m4142rememberSaveable(new Object[0], (Saver) null, (String) null, (Function0) new Function0<String>() {
            public final String invoke() {
                return UUID.randomUUID().toString();
            }
        }, composer, 3072, 6);
        ActivityResultRegistryOwner current = LocalActivityResultRegistryOwner.INSTANCE.getCurrent(composer, 6);
        if (current == null) {
            throw new IllegalStateException("No ActivityResultRegistryOwner was provided via LocalActivityResultRegistryOwner".toString());
        }
        ActivityResultRegistry activityResultRegistry = current.getActivityResultRegistry();
        composer.startReplaceableGroup(-1672765924);
        ComposerKt.sourceInformation(composer, "CC(remember):ActivityResultRegistry.kt#9igjgp");
        Object objRememberedValue = composer.rememberedValue();
        if (objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = new ActivityResultLauncherHolder();
            composer.updateRememberedValue(objRememberedValue);
        }
        ActivityResultLauncherHolder activityResultLauncherHolder = (ActivityResultLauncherHolder) objRememberedValue;
        composer.endReplaceableGroup();
        composer.startReplaceableGroup(-1672765850);
        ComposerKt.sourceInformation(composer, "CC(remember):ActivityResultRegistry.kt#9igjgp");
        Object objRememberedValue2 = composer.rememberedValue();
        if (objRememberedValue2 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue2 = new ManagedActivityResultLauncher(activityResultLauncherHolder, stateRememberUpdatedState);
            composer.updateRememberedValue(objRememberedValue2);
        }
        ManagedActivityResultLauncher<I, O> managedActivityResultLauncher = (ManagedActivityResultLauncher) objRememberedValue2;
        composer.endReplaceableGroup();
        composer.startReplaceableGroup(-1672765582);
        ComposerKt.sourceInformation(composer, "CC(remember):ActivityResultRegistry.kt#9igjgp");
        boolean zChanged = composer.changed(activityResultLauncherHolder) | composer.changed(activityResultRegistry) | composer.changed(str) | composer.changed(activityResultContract) | composer.changed(stateRememberUpdatedState2);
        Object objRememberedValue3 = composer.rememberedValue();
        if (zChanged || objRememberedValue3 == Composer.INSTANCE.getEmpty()) {
            objRememberedValue3 = (Function1) new ActivityResultRegistryKt$rememberLauncherForActivityResult$1$1(activityResultLauncherHolder, activityResultRegistry, str, activityResultContract, stateRememberUpdatedState2);
            composer.updateRememberedValue(objRememberedValue3);
        }
        composer.endReplaceableGroup();
        EffectsKt.DisposableEffect(activityResultRegistry, str, activityResultContract, (Function1) objRememberedValue3, composer, (i << 6) & 896);
        composer.endReplaceableGroup();
        return managedActivityResultLauncher;
    }
}
