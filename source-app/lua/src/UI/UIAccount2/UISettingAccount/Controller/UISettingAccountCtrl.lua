local UISettingAccountCtrl = BaseClass("UISettingAccountCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingAccount)
  DataCenter.AccountManager:ResetAfterBindOpenRolesList()
end

local function CloseAll(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UISettingAccount)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPlayerDetail)
  DataCenter.AccountManager:ResetAfterBindOpenRolesList()
end

local function GetAccountBindStateName(self)
  local account = DataCenter.AccountManager.MailAccount.gameAccount
  if not string.IsNullOrEmpty(account) then
    local status = DataCenter.AccountManager.MailAccount.accountStatus or AccountBandState.UnBand
    if status == AccountBandState.UnBand then
      return Localization:GetString("280033")
    elseif status == AccountBandState.UnCheck then
      return Localization:GetString("280125")
    else
      return Localization:GetString("280057")
    end
  else
    local gpUid = DataCenter.AccountManager.GoogleSignAccount.userId
    if not string.IsNullOrEmpty(gpUid) then
      return Localization:GetString("280057")
    end
    local playerId = DataCenter.AccountManager.PlayGamesAccount.userId
    if not string.IsNullOrEmpty(playerId) then
      return Localization:GetString("280057")
    end
    local gameCenter = DataCenter.AccountManager.GameCenterAccount.userId
    if not string.IsNullOrEmpty(gameCenter) then
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
UISettingAccountCtrl.CloseAll = CloseAll
UISettingAccountCtrl.GetAccountBindStateName = GetAccountBindStateName
UISettingAccountCtrl.GetAccountBindState = GetAccountBindState
return UISettingAccountCtrl
