local UISettingAccountCtrl = BaseClass("UISettingAccountCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingAccount)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetAccountBindStateName(self)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  if account ~= nil and account ~= "" then
    local status = DataCenter.AccountManager.MailAccount.accountStatus or AccountBandState.UnBand
    if status == AccountBandState.UnBand then
      return Localization:GetString("280033")
    elseif status == AccountBandState.UnCheck then
      return Localization:GetString("280125")
    else
      return Localization:GetString("280057")
    end
  else
    local playerId = DataCenter.AccountManager.PlayGamesAccount.userId
    if playerId ~= "" then
      return Localization:GetString("280057")
    end
    local gpAccount = DataCenter.AccountManager.GoogleSignAccount.userId
    if gpAccount ~= "" then
      return Localization:GetString("280057")
    end
    local gcAccount = DataCenter.AccountManager.GameCenterAccount.userId
    if gcAccount ~= "" then
      return Localization:GetString("280057")
    end
  end
  return Localization:GetString("280033")
end

local function GetAccountBindState(self)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  if account ~= nil and account ~= "" then
    local status = DataCenter.AccountManager.MailAccount.accountStatus or AccountBandState.UnBand
    return status
  else
    return AccountBandState.UnBand
  end
end

UISettingAccountCtrl.CloseSelf = CloseSelf
UISettingAccountCtrl.Close = Close
UISettingAccountCtrl.GetAccountBindStateName = GetAccountBindStateName
UISettingAccountCtrl.GetAccountBindState = GetAccountBindState
return UISettingAccountCtrl
