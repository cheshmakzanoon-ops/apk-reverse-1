local CoppaUtil = {}

local function getCoppaState()
  return CS.GameEntry.Setting:GetString(CS.KWSVerification.CoppaPrefsKeys.COPPA_STATE, CS.KWSVerification.CoppaState.NonUsRegions)
end

local function getAccountState()
  local accountState = CS.GameEntry.Setting:GetInt(CS.KWSVerification.CoppaPrefsKeys.ACCOUNT_STATE, CS.KWSVerification.AccountState.NotVerified)
  return accountState
end

function CoppaUtil.IsCoppaLimit()
  if CS.PrivacyFuncUtil.Instance:IsUs() then
    return CS.PrivacyFuncUtil.Instance:IsLimitUs()
  end
  if CS.PrivacyBrazil.Instance:IsBrazil() then
    return CS.PrivacyBrazil.Instance:IsLimitBrazil()
  end
  return false
end

function CoppaUtil.GetCanPay()
  if CS.PrivacyBrazil.Instance:IsBrazil() then
    return CS.PrivacyBrazil.Instance:HandleAgeVerification()
  end
  return true
end

function CoppaUtil.GetCoppaDialogId()
  return "coppa_limit_tips"
end

function CoppaUtil.IsCoppaLimitWithTips()
  if CoppaUtil.IsCoppaLimit() then
    UIUtil.ShowTipsId(CoppaUtil.GetCoppaDialogId())
    return true
  end
  return false
end

function CoppaUtil.IsShowCoppaBtnInMainUI()
  if DataCenter.BuildManager.MainLv < 1 then
    return false
  end
  if CS.PrivacyBrazil.Instance:IsBrazil() and CS.PrivacyBrazil.Instance:IsAgeVerifiedSwitchOn() and not CS.PrivacyBrazil.Instance:IsAgeVerified() then
    return true
  end
  return CoppaUtil.CanAppeal() or CoppaUtil.NeedVerify()
end

function CoppaUtil.CanAppeal()
  return CoppaUtil.IsCoppaLimit()
end

function CoppaUtil.NeedVerify()
  local accountState = getAccountState()
  if accountState == CS.KWSVerification.AccountState.Adult or accountState == CS.KWSVerification.AccountState.Child then
    return false
  end
  return CoppaUtil.IsUncertifiedCoppaState()
end

function CoppaUtil.IsUncertifiedCoppaState()
  local state = getCoppaState()
  return state == CS.KWSVerification.CoppaState.UsUncertifiedNewPlayer or state == CS.KWSVerification.CoppaState.UsUncertifiedNeedMail or state == CS.KWSVerification.CoppaState.UsUncertifiedMailPending or state == CS.KWSVerification.CoppaState.UsUncertifiedOldPlayer or state == CS.KWSVerification.CoppaState.UsUncertifiedOldTimeOut
end

function CoppaUtil.OpenVerifyDialog()
  CS.GameEntry.Setting:SetString(CS.KWSVerification.CoppaPrefsKeys.OPEN_FROM, CS.KWSVerification.CoppaOpenFrom.MainUI)
  CS.PrivacyFuncUtil.Instance:ShowUIPrivacyUS(0)
end

function CoppaUtil.PopupVerifyDialog()
  CS.GameEntry.Setting:SetString(CS.KWSVerification.CoppaPrefsKeys.OPEN_FROM, CS.KWSVerification.CoppaOpenFrom.Popup)
  CS.PrivacyFuncUtil.Instance:ShowUIPrivacyUS(0)
end

function CoppaUtil.Coppa_HandleSecondVerify_IpCountry()
  return CS.PrivacyFuncUtil.Instance:Coppa_HandleSecondVerify_IpCountry()
end

function CoppaUtil.GetFinalConfirmTime()
  return CS.PrivacyFuncUtil.Instance:GetFinalConfirmTime()
end

return ConstClass("CoppaUtil", CoppaUtil)
