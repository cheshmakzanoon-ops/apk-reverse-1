local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local AccountScoreConst = require("DataCenter.AccountScore.AccountScoreConst")
local BaseAccount = require("DataCenter.AccountHelper.BaseAccount")
local MailAccount = BaseClass("MailAccount", BaseAccount)

function MailAccount:__init()
  self.gameAccount = ""
  self.accountStatus = 0
end

function MailAccount:__delete()
  self.gameAccount = ""
  self.accountStatus = 0
end

function MailAccount:Login(data)
  local title = 280050
  local isLoadingLogin = false
  if data then
    title = data.title or title
    isLoadingLogin = data.isLoadingLogin or isLoadingLogin
  end
  if title == 110008 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAddAccount, 110008, isLoadingLogin)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAddAccount, 280050, isLoadingLogin)
  end
end

function MailAccount:Bind()
  if DataCenter.AccountScoreManager:CheckAccountIDOpen() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountIdBind, AccountScoreConst.OpenType.BindMail)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICreateAccount, 1)
  end
end

function MailAccount:Unbind()
end

function MailAccount:Verify()
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("multibind_protect_title01"),
    contentText = Localization:GetString("multibind_protect_desc02"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        DataCenter.AccountManager:SetMailVerifyCodeType("bind")
        SFSNetwork.SendMessage(MsgDefines.AccountDeviceSendVerifyCode, {
          mail = self.gameAccount,
          oType = "bind"
        })
      end
    }
  })
end

function MailAccount:IsBound()
  if not string.IsNullOrEmpty(self.gameAccount) then
    if self.accountStatus == AccountBandState.Band then
      return true
    else
      return false
    end
  else
    return false
  end
end

function MailAccount:OnClick()
  local isBindGoogleSign = DataCenter.AccountManager.GoogleSignAccount:IsBound()
  local isBindPlayGames = DataCenter.AccountManager.PlayGamesAccount:IsBound()
  local isBindMail = self:IsBound()
  local isBindGameCenter = DataCenter.AccountManager.GameCenterAccount:IsBound()
  if not DataCenter.AccountManager:IsDoubleVerifyOpen() then
    if isBindMail then
      self:OnBtnHasBound()
    else
      self:Bind()
    end
    return
  end
  if isBindMail then
    self:OnBtnHasBound()
  else
    if DataCenter.AccountManager:IsInDoubleChannelVerifyTime() then
      self:Bind()
      return
    end
    if isBindGoogleSign and SDKManager.IS_Android() then
      DataCenter.AccountManager.GoogleSignAccount:Verify()
    elseif isBindPlayGames and SDKManager.IS_Android() then
      DataCenter.AccountManager.PlayGamesAccount:Verify()
    elseif isBindGameCenter and SDKManager.IS_IPhonePlayer() then
      DataCenter.AccountManager.GameCenterAccount:Verify()
    else
      self:Bind()
    end
  end
end

function MailAccount:OnBtnHasBound()
  local canBind = DataCenter.AccountManager:CanChangeBindAccount()
  if canBind then
    UIUtil.ShowMessage(Localization:GetString("email_unbind_des", self.gameAccount), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:VerifyOldEmail()
    end, function()
    end, nil, "email_change_title")
  else
    local expTime = DataCenter.AccountManager:GetAccountChangeBindExp()
    
    local function countdownCallback()
      DataCenter.AccountManager:SetAccountChangeBindExp(0)
    end
    
    UIUtil.ShowMessageWithCountdown("email_bind_fail_des", 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_bind_fail_title", expTime, countdownCallback)
  end
end

function MailAccount:VerifyOldEmail()
  DataCenter.AccountManager:SetIsBindingNewAccount(true)
  SFSNetwork.SendMessage(MsgDefines.ChangeBindAccountEmail, {changeType = 1})
end

return MailAccount
