package zendesk.messaging.android.internal.messagingscreen;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.enums.EnumEntries;
import kotlin.enums.EnumEntriesKt;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001:\u0001\u0016B\u0019\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nJ(\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\n2\u0006\u0010\u0010\u001a\u00020\b2\u0006\u0010\u0011\u001a\u00020\u0012H\u0002J*\u0010\u0013\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u0010\u001a\u00020\b2\b\b\u0002\u0010\u0011\u001a\u00020\u0012J\u000e\u0010\u0014\u001a\u00020\f2\u0006\u0010\t\u001a\u00020\nJ\u0010\u0010\u0015\u001a\u00020\f2\u0006\u0010\t\u001a\u00020\nH\u0002R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0017"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator;", "", "supportFragmentManager", "Landroidx/fragment/app/FragmentManager;", "fragmentContainer", "", "(Landroidx/fragment/app/FragmentManager;I)V", "hasScreenBeenDisplayed", "", "tagName", "", "navigate", "", "fragment", "Landroidx/fragment/app/Fragment;", "fragmentTagName", "addToBackStack", "transactionBehaviour", "Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator$TransactionBehaviour;", "navigateToScreen", "popBackCurrentScreen", "popBackScreenIfDisplayed", "TransactionBehaviour", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingNavigator {
    private final int fragmentContainer;
    private final FragmentManager supportFragmentManager;

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0004\b\u0080\u0081\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004¨\u0006\u0005"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingNavigator$TransactionBehaviour;", "", "(Ljava/lang/String;I)V", "REPLACE", "ADD", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public enum TransactionBehaviour {
        REPLACE,
        ADD;

        private static final EnumEntries $ENTRIES = EnumEntriesKt.enumEntries(values());

        public static EnumEntries<TransactionBehaviour> getEntries() {
            return $ENTRIES;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[TransactionBehaviour.values().length];
            try {
                iArr[TransactionBehaviour.ADD.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[TransactionBehaviour.REPLACE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    @Inject
    public MessagingNavigator(FragmentManager supportFragmentManager, int i) {
        Intrinsics.checkNotNullParameter(supportFragmentManager, "supportFragmentManager");
        this.supportFragmentManager = supportFragmentManager;
        this.fragmentContainer = i;
    }

    public static void navigateToScreen$default(MessagingNavigator messagingNavigator, Fragment fragment, String str, boolean z, TransactionBehaviour transactionBehaviour, int i, Object obj) {
        if ((i & 4) != 0) {
            z = true;
        }
        if ((i & 8) != 0) {
            transactionBehaviour = TransactionBehaviour.REPLACE;
        }
        messagingNavigator.navigateToScreen(fragment, str, z, transactionBehaviour);
    }

    public final void navigateToScreen(Fragment fragment, String tagName, boolean addToBackStack, TransactionBehaviour transactionBehaviour) {
        Intrinsics.checkNotNullParameter(fragment, "fragment");
        Intrinsics.checkNotNullParameter(tagName, "tagName");
        Intrinsics.checkNotNullParameter(transactionBehaviour, "transactionBehaviour");
        navigate(fragment, tagName, addToBackStack, transactionBehaviour);
    }

    private final void navigate(Fragment fragment, String fragmentTagName, boolean addToBackStack, TransactionBehaviour transactionBehaviour) {
        popBackScreenIfDisplayed(fragmentTagName);
        FragmentTransaction fragmentTransactionBeginTransaction = this.supportFragmentManager.beginTransaction();
        fragmentTransactionBeginTransaction.setReorderingAllowed(true);
        int i = WhenMappings.$EnumSwitchMapping$0[transactionBehaviour.ordinal()];
        if (i == 1) {
            fragmentTransactionBeginTransaction.add(this.fragmentContainer, fragment, fragmentTagName);
        } else if (i == 2) {
            fragmentTransactionBeginTransaction.replace(this.fragmentContainer, fragment, fragmentTagName);
        }
        if (addToBackStack) {
            fragmentTransactionBeginTransaction.addToBackStack(fragmentTagName);
        }
        fragmentTransactionBeginTransaction.commit();
    }

    private final void popBackScreenIfDisplayed(String tagName) {
        if (hasScreenBeenDisplayed(tagName) && Intrinsics.areEqual(tagName, "ConversationFragment")) {
            popBackCurrentScreen(tagName);
        }
    }

    public final boolean hasScreenBeenDisplayed(String tagName) {
        Intrinsics.checkNotNullParameter(tagName, "tagName");
        return this.supportFragmentManager.findFragmentByTag(tagName) != null;
    }

    public final void popBackCurrentScreen(String tagName) {
        Intrinsics.checkNotNullParameter(tagName, "tagName");
        this.supportFragmentManager.popBackStack(tagName, 1);
    }
}
