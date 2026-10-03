package androidx.compose.p002ui.autofill;

import androidx.autofill.HintConstants;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.SetsKt;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\"\n\u0002\b\u0006\b\u0000\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bB\u000f\b\u0016\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004B\u0015\b\u0002\u0012\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00030\u0006¢\u0006\u0002\u0010\u0007J\u0016\u0010\b\u001a\u00020\u00002\u0006\u0010\t\u001a\u00020\u0000H\u0080\u0002¢\u0006\u0002\b\nR\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00030\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\f"}, d2 = {"Landroidx/compose/ui/autofill/ContentType;", "", "contentHint", "", "(Ljava/lang/String;)V", "contentHints", "", "(Ljava/util/Set;)V", "plus", "other", "plus$ui_release", "Companion", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ContentType {
    private final Set<String> contentHints;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final ContentType Username = new ContentType(HintConstants.AUTOFILL_HINT_USERNAME);
    private static final ContentType Password = new ContentType(HintConstants.AUTOFILL_HINT_PASSWORD);
    private static final ContentType EmailAddress = new ContentType(HintConstants.AUTOFILL_HINT_EMAIL_ADDRESS);
    private static final ContentType NewUsername = new ContentType(HintConstants.AUTOFILL_HINT_NEW_USERNAME);
    private static final ContentType NewPassword = new ContentType(HintConstants.AUTOFILL_HINT_NEW_PASSWORD);
    private static final ContentType PostalAddress = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS);
    private static final ContentType PostalCode = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_CODE);
    private static final ContentType CreditCardNumber = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_NUMBER);
    private static final ContentType CreditCardSecurityCode = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_SECURITY_CODE);
    private static final ContentType CreditCardExpirationDate = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DATE);
    private static final ContentType CreditCardExpirationMonth = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_MONTH);
    private static final ContentType CreditCardExpirationYear = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_YEAR);
    private static final ContentType CreditCardExpirationDay = new ContentType(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DAY);
    private static final ContentType AddressCountry = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_COUNTRY);
    private static final ContentType AddressRegion = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_REGION);
    private static final ContentType AddressLocality = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_LOCALITY);
    private static final ContentType AddressStreet = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_STREET_ADDRESS);
    private static final ContentType AddressAuxiliaryDetails = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_EXTENDED_ADDRESS);
    private static final ContentType PostalCodeExtended = new ContentType(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_EXTENDED_POSTAL_CODE);
    private static final ContentType PersonFullName = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME);
    private static final ContentType PersonFirstName = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_GIVEN);
    private static final ContentType PersonLastName = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_FAMILY);
    private static final ContentType PersonMiddleName = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_MIDDLE);
    private static final ContentType PersonMiddleInitial = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_MIDDLE_INITIAL);
    private static final ContentType PersonNamePrefix = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_PREFIX);
    private static final ContentType PersonNameSuffix = new ContentType(HintConstants.AUTOFILL_HINT_PERSON_NAME_SUFFIX);
    private static final ContentType PhoneNumber = new ContentType(HintConstants.AUTOFILL_HINT_PHONE_NUMBER);
    private static final ContentType PhoneNumberDevice = new ContentType(HintConstants.AUTOFILL_HINT_PHONE_NUMBER_DEVICE);
    private static final ContentType PhoneCountryCode = new ContentType(HintConstants.AUTOFILL_HINT_PHONE_COUNTRY_CODE);
    private static final ContentType PhoneNumberNational = new ContentType(HintConstants.AUTOFILL_HINT_PHONE_NATIONAL);
    private static final ContentType Gender = new ContentType(HintConstants.AUTOFILL_HINT_GENDER);
    private static final ContentType BirthDateFull = new ContentType(HintConstants.AUTOFILL_HINT_BIRTH_DATE_FULL);
    private static final ContentType BirthDateDay = new ContentType(HintConstants.AUTOFILL_HINT_BIRTH_DATE_DAY);
    private static final ContentType BirthDateMonth = new ContentType(HintConstants.AUTOFILL_HINT_BIRTH_DATE_MONTH);
    private static final ContentType BirthDateYear = new ContentType(HintConstants.AUTOFILL_HINT_BIRTH_DATE_YEAR);
    private static final ContentType SmsOtpCode = new ContentType(HintConstants.AUTOFILL_HINT_SMS_OTP);

    private ContentType(Set<String> set) {
        this.contentHints = set;
    }

    public ContentType(String str) {
        this((Set<String>) SetsKt.setOf(str));
    }

    @Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\bJ\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0015\u0010M\u001a\u00020\u00042\u0006\u0010N\u001a\u00020OH\u0000¢\u0006\u0002\bPR\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0006R\u0011\u0010\t\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u0006R\u0011\u0010\u000b\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u0006R\u0011\u0010\r\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u0006R\u0011\u0010\u000f\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0006R\u0011\u0010\u0011\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0006R\u0011\u0010\u0013\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0006R\u0011\u0010\u0015\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0006R\u0011\u0010\u0017\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0006R\u0011\u0010\u0019\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0006R\u0011\u0010\u001b\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0006R\u0011\u0010\u001d\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u0006R\u0011\u0010\u001f\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u0006R\u0011\u0010!\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u0006R\u0011\u0010#\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u0006R\u0011\u0010%\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b&\u0010\u0006R\u0011\u0010'\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u0006R\u0011\u0010)\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b*\u0010\u0006R\u0011\u0010+\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b,\u0010\u0006R\u0011\u0010-\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b.\u0010\u0006R\u0011\u0010/\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b0\u0010\u0006R\u0011\u00101\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b2\u0010\u0006R\u0011\u00103\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b4\u0010\u0006R\u0011\u00105\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b6\u0010\u0006R\u0011\u00107\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b8\u0010\u0006R\u0011\u00109\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b:\u0010\u0006R\u0011\u0010;\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b<\u0010\u0006R\u0011\u0010=\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b>\u0010\u0006R\u0011\u0010?\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b@\u0010\u0006R\u0011\u0010A\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bB\u0010\u0006R\u0011\u0010C\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bD\u0010\u0006R\u0011\u0010E\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bF\u0010\u0006R\u0011\u0010G\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bH\u0010\u0006R\u0011\u0010I\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bJ\u0010\u0006R\u0011\u0010K\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\bL\u0010\u0006¨\u0006Q"}, d2 = {"Landroidx/compose/ui/autofill/ContentType$Companion;", "", "()V", "AddressAuxiliaryDetails", "Landroidx/compose/ui/autofill/ContentType;", "getAddressAuxiliaryDetails", "()Landroidx/compose/ui/autofill/ContentType;", "AddressCountry", "getAddressCountry", "AddressLocality", "getAddressLocality", "AddressRegion", "getAddressRegion", "AddressStreet", "getAddressStreet", "BirthDateDay", "getBirthDateDay", "BirthDateFull", "getBirthDateFull", "BirthDateMonth", "getBirthDateMonth", "BirthDateYear", "getBirthDateYear", "CreditCardExpirationDate", "getCreditCardExpirationDate", "CreditCardExpirationDay", "getCreditCardExpirationDay", "CreditCardExpirationMonth", "getCreditCardExpirationMonth", "CreditCardExpirationYear", "getCreditCardExpirationYear", "CreditCardNumber", "getCreditCardNumber", "CreditCardSecurityCode", "getCreditCardSecurityCode", "EmailAddress", "getEmailAddress", "Gender", "getGender", "NewPassword", "getNewPassword", "NewUsername", "getNewUsername", "Password", "getPassword", "PersonFirstName", "getPersonFirstName", "PersonFullName", "getPersonFullName", "PersonLastName", "getPersonLastName", "PersonMiddleInitial", "getPersonMiddleInitial", "PersonMiddleName", "getPersonMiddleName", "PersonNamePrefix", "getPersonNamePrefix", "PersonNameSuffix", "getPersonNameSuffix", "PhoneCountryCode", "getPhoneCountryCode", "PhoneNumber", "getPhoneNumber", "PhoneNumberDevice", "getPhoneNumberDevice", "PhoneNumberNational", "getPhoneNumberNational", "PostalAddress", "getPostalAddress", "PostalCode", "getPostalCode", "PostalCodeExtended", "getPostalCodeExtended", "SmsOtpCode", "getSmsOtpCode", "Username", "getUsername", "from", "value", "", "from$ui_release", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final ContentType getUsername() {
            return ContentType.Username;
        }

        public final ContentType getPassword() {
            return ContentType.Password;
        }

        public final ContentType getEmailAddress() {
            return ContentType.EmailAddress;
        }

        public final ContentType getNewUsername() {
            return ContentType.NewUsername;
        }

        public final ContentType getNewPassword() {
            return ContentType.NewPassword;
        }

        public final ContentType getPostalAddress() {
            return ContentType.PostalAddress;
        }

        public final ContentType getPostalCode() {
            return ContentType.PostalCode;
        }

        public final ContentType getCreditCardNumber() {
            return ContentType.CreditCardNumber;
        }

        public final ContentType getCreditCardSecurityCode() {
            return ContentType.CreditCardSecurityCode;
        }

        public final ContentType getCreditCardExpirationDate() {
            return ContentType.CreditCardExpirationDate;
        }

        public final ContentType getCreditCardExpirationMonth() {
            return ContentType.CreditCardExpirationMonth;
        }

        public final ContentType getCreditCardExpirationYear() {
            return ContentType.CreditCardExpirationYear;
        }

        public final ContentType getCreditCardExpirationDay() {
            return ContentType.CreditCardExpirationDay;
        }

        public final ContentType getAddressCountry() {
            return ContentType.AddressCountry;
        }

        public final ContentType getAddressRegion() {
            return ContentType.AddressRegion;
        }

        public final ContentType getAddressLocality() {
            return ContentType.AddressLocality;
        }

        public final ContentType getAddressStreet() {
            return ContentType.AddressStreet;
        }

        public final ContentType getAddressAuxiliaryDetails() {
            return ContentType.AddressAuxiliaryDetails;
        }

        public final ContentType getPostalCodeExtended() {
            return ContentType.PostalCodeExtended;
        }

        public final ContentType getPersonFullName() {
            return ContentType.PersonFullName;
        }

        public final ContentType getPersonFirstName() {
            return ContentType.PersonFirstName;
        }

        public final ContentType getPersonLastName() {
            return ContentType.PersonLastName;
        }

        public final ContentType getPersonMiddleName() {
            return ContentType.PersonMiddleName;
        }

        public final ContentType getPersonMiddleInitial() {
            return ContentType.PersonMiddleInitial;
        }

        public final ContentType getPersonNamePrefix() {
            return ContentType.PersonNamePrefix;
        }

        public final ContentType getPersonNameSuffix() {
            return ContentType.PersonNameSuffix;
        }

        public final ContentType getPhoneNumber() {
            return ContentType.PhoneNumber;
        }

        public final ContentType getPhoneNumberDevice() {
            return ContentType.PhoneNumberDevice;
        }

        public final ContentType getPhoneCountryCode() {
            return ContentType.PhoneCountryCode;
        }

        public final ContentType getPhoneNumberNational() {
            return ContentType.PhoneNumberNational;
        }

        public final ContentType getGender() {
            return ContentType.Gender;
        }

        public final ContentType getBirthDateFull() {
            return ContentType.BirthDateFull;
        }

        public final ContentType getBirthDateDay() {
            return ContentType.BirthDateDay;
        }

        public final ContentType getBirthDateMonth() {
            return ContentType.BirthDateMonth;
        }

        public final ContentType getBirthDateYear() {
            return ContentType.BirthDateYear;
        }

        public final ContentType getSmsOtpCode() {
            return ContentType.SmsOtpCode;
        }

        public final ContentType from$ui_release(String value) {
            switch (value.hashCode()) {
                case -1844815832:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_MONTH)) {
                        return getCreditCardExpirationMonth();
                    }
                    break;
                case -1821235109:
                    if (value.equals(HintConstants.AUTOFILL_HINT_NEW_PASSWORD)) {
                        return getNewPassword();
                    }
                    break;
                case -1757573738:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_SECURITY_CODE)) {
                        return getCreditCardSecurityCode();
                    }
                    break;
                case -1682373820:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DAY)) {
                        return getCreditCardExpirationDay();
                    }
                    break;
                case -1492157798:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_MIDDLE_INITIAL)) {
                        return getPersonMiddleInitial();
                    }
                    break;
                case -1327425451:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PHONE_COUNTRY_CODE)) {
                        return getPhoneCountryCode();
                    }
                    break;
                case -1249512767:
                    if (value.equals(HintConstants.AUTOFILL_HINT_GENDER)) {
                        return getGender();
                    }
                    break;
                case -1192969641:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PHONE_NUMBER)) {
                        return getPhoneNumber();
                    }
                    break;
                case -1151034798:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_NUMBER)) {
                        return getCreditCardNumber();
                    }
                    break;
                case -1070931784:
                    if (value.equals(HintConstants.AUTOFILL_HINT_EMAIL_ADDRESS)) {
                        return getEmailAddress();
                    }
                    break;
                case -782964728:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_REGION)) {
                        return getAddressRegion();
                    }
                    break;
                case -742913724:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_FAMILY)) {
                        return getPersonLastName();
                    }
                    break;
                case -724274829:
                    if (value.equals(HintConstants.AUTOFILL_HINT_BIRTH_DATE_MONTH)) {
                        return getBirthDateMonth();
                    }
                    break;
                case -613980922:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_DATE)) {
                        return getCreditCardExpirationDate();
                    }
                    break;
                case -613352043:
                    if (value.equals(HintConstants.AUTOFILL_HINT_CREDIT_CARD_EXPIRATION_YEAR)) {
                        return getCreditCardExpirationYear();
                    }
                    break;
                case -398527665:
                    if (value.equals(HintConstants.AUTOFILL_HINT_BIRTH_DATE_DAY)) {
                        return getBirthDateDay();
                    }
                    break;
                case -265713450:
                    if (value.equals(HintConstants.AUTOFILL_HINT_USERNAME)) {
                        return getUsername();
                    }
                    break;
                case -50595520:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PHONE_NATIONAL)) {
                        return getPhoneNumberNational();
                    }
                    break;
                case 289393:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_STREET_ADDRESS)) {
                        return getAddressStreet();
                    }
                    break;
                case 146220155:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_EXTENDED_ADDRESS)) {
                        return getAddressAuxiliaryDetails();
                    }
                    break;
                case 530622780:
                    if (value.equals(HintConstants.AUTOFILL_HINT_BIRTH_DATE_FULL)) {
                        return getBirthDateFull();
                    }
                    break;
                case 531173098:
                    if (value.equals(HintConstants.AUTOFILL_HINT_BIRTH_DATE_YEAR)) {
                        return getBirthDateYear();
                    }
                    break;
                case 678483840:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME)) {
                        return getPersonFullName();
                    }
                    break;
                case 956262285:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PHONE_NUMBER_DEVICE)) {
                        return getPhoneNumberDevice();
                    }
                    break;
                case 991032982:
                    if (value.equals(HintConstants.AUTOFILL_HINT_NEW_USERNAME)) {
                        return getNewUsername();
                    }
                    break;
                case 1216985755:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PASSWORD)) {
                        return getPassword();
                    }
                    break;
                case 1369618690:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_COUNTRY)) {
                        return getAddressCountry();
                    }
                    break;
                case 1617991537:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_EXTENDED_POSTAL_CODE)) {
                        return getPostalCodeExtended();
                    }
                    break;
                case 1662667945:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS)) {
                        return getPostalAddress();
                    }
                    break;
                case 1781320055:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_ADDRESS_LOCALITY)) {
                        return getAddressLocality();
                    }
                    break;
                case 1834963923:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_GIVEN)) {
                        return getPersonFirstName();
                    }
                    break;
                case 1865618463:
                    if (value.equals(HintConstants.AUTOFILL_HINT_SMS_OTP)) {
                        return getSmsOtpCode();
                    }
                    break;
                case 1917507122:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_PREFIX)) {
                        return getPersonNamePrefix();
                    }
                    break;
                case 1935279861:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_MIDDLE)) {
                        return getPersonMiddleName();
                    }
                    break;
                case 2006194929:
                    if (value.equals(HintConstants.AUTOFILL_HINT_PERSON_NAME_SUFFIX)) {
                        return getPersonNameSuffix();
                    }
                    break;
                case 2011152728:
                    if (value.equals(HintConstants.AUTOFILL_HINT_POSTAL_CODE)) {
                        return getPostalCode();
                    }
                    break;
            }
            return new ContentType(value);
        }
    }

    public final ContentType plus$ui_release(ContentType other) {
        return new ContentType((Set<String>) SetsKt.plus(this.contentHints, other.contentHints));
    }
}
