local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local BaseAccount = require("DataCenter.AccountHelper.BaseAccount")
local PlayGamesAccount = BaseClass("PlayGamesAccount", BaseAccount)

function PlayGamesAccount:__init()
end

function PlayGamesAccount:__delete()
end

function PlayGamesAccount:Login(data)
  self:TipsNotSupport()
  
  local function OnLoginComplete(authData)
    local authCode = authData.authCode
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if success then
      self:LogEvent("login")
      SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, {pgs_id = playerId, auth_code = authCode})
    elseif string.IsNullOrEmpty(error) then
      UIUtil.ShowTipsId("multibind_protect_tips05")
    else
      UIUtil.ShowTips(Localization:GetString("email_bind_fail_title") .. error)
      UIUtil.ShowTips(Localization:GetString("120951", error))
    end
  end
  
  CS.PlayGamesBridge.Login(OnLoginComplete)
end

function PlayGamesAccount:Bind()
  self:TipsNotSupport()
  
  local function OnLoginComplete(authData)
    local authCode = authData.authCode
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if success then
      self:LogEvent("manual_bind")
      SFSNetwork.SendMessage(MsgDefines.UserBind, {
        optType = AccountBindType.Bind,
        pgs_id = playerId,
        pgs_name = displayName,
        auth_code = authCode
      })
    elseif string.IsNullOrEmpty(error) then
      UIUtil.ShowTipsId("multibind_protect_tips05")
    else
      UIUtil.ShowTips(Localization:GetString("120951", error))
    end
  end
  
  CS.PlayGamesBridge.Login(OnLoginComplete)
end

function PlayGamesAccount:Unbind()
  self:TipsNotSupport()
  
  local function OnLoginComplete(authData)
    local authCode = authData.authCode
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if success then
      if string.IsNullOrEmpty(self.userId) then
        Logger.LogError("VerifyPlayGames\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132 self.userId \232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if self.userId == playerId then
        self:LogEvent("unbind")
        SFSNetwork.SendMessage(MsgDefines.GoogleCancelBind, {type = "GooglePlay", account = playerId})
      else
        UIUtil.ShowMessage(Localization:GetString("multibind_protect_desc03"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "multibind_protect_title02")
      end
    elseif string.IsNullOrEmpty(error) then
      UIUtil.ShowTipsId("multibind_protect_tips05")
    else
      UIUtil.ShowTips(Localization:GetString("120951", error))
    end
  end
  
  CS.PlayGamesBridge.Login(OnLoginComplete)
end

function PlayGamesAccount:Verify()
  self:TipsNotSupport()
  
  local function OnLoginComplete(authData)
    local authCode = authData.authCode
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if success then
      if string.IsNullOrEmpty(self.userId) then
        Logger.LogError("VerifyPlayGames\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132 self.userId \232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if self.userId == playerId then
        self:LogEvent("verify")
        SFSNetwork.SendMessage(MsgDefines.MultiProtectGoogleVerify)
        UIUtil.ShowTipsId("multibind_protect_verity02")
      else
        UIUtil.ShowMessage(Localization:GetString("multibind_protect_desc03"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "multibind_protect_title02")
      end
    elseif string.IsNullOrEmpty(error) then
      UIUtil.ShowTipsId("multibind_protect_tips05")
    else
      UIUtil.ShowTips(Localization:GetString("120951", error))
    end
  end
  
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("multibind_protect_title01"),
    contentText = Localization:GetString("multibind_protect_desc06"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        CS.PlayGamesBridge.Login(OnLoginComplete)
      end
    }
  })
end

function PlayGamesAccount:IsBound()
  if not string.IsNullOrEmpty(self.userId) then
    return true
  else
    return false
  end
end

function PlayGamesAccount:OnClick()
  local isBindMail = DataCenter.AccountManager.MailAccount:IsBound()
  local isBindGoogleSign = DataCenter.AccountManager.GoogleSignAccount:IsBound()
  local isBindPlayGames = self:IsBound()
  if not DataCenter.AccountManager:IsDoubleVerifyOpen() then
    if isBindPlayGames then
      self:OnBtnHasBound()
    else
      self:Bind()
    end
    return
  end
  if isBindPlayGames then
    self:OnBtnHasBound()
  else
    if DataCenter.AccountManager:IsInDoubleChannelVerifyTime() then
      self:Bind()
      return
    end
    if isBindMail then
      DataCenter.AccountManager.MailAccount:Verify()
    elseif isBindGoogleSign then
      DataCenter.AccountManager.GoogleSignAccount:Verify()
    else
      self:Bind()
    end
  end
end

function PlayGamesAccount:OnBtnHasBound()
  local isBindMail = DataCenter.AccountManager.MailAccount:IsBound()
  if not isBindMail then
    UIUtil.ShowMessage(Localization:GetString("email_no_bind_des"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_no_bind_title")
    return
  end
  local canBind = DataCenter.AccountManager:CanChangeBindAccount()
  if canBind then
    UIUtil.ShowMessage(Localization:GetString("email_change_des", self.userName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:Unbind()
    end, function()
    end, nil, "email_unbind_title")
  else
    local expTime = DataCenter.AccountManager:GetAccountChangeBindExp()
    
    local function countdownCallback()
      DataCenter.AccountManager:SetAccountChangeBindExp(0)
    end
    
    UIUtil.ShowMessageWithCountdown("email_bind_fail_des", 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_bind_fail_title", expTime, countdownCallback)
  end
end

function PlayGamesAccount:AutoBind()
  local function OnLoginComplete(authData)
    local authCode = authData.authCode
    
    local playerId = authData.playerId
    local displayName = authData.displayName
    local success = authData.success
    local code = authData.code
    local error = authData.error
    if success then
      self:LogEvent("auto_bind")
      SFSNetwork.SendMessage(MsgDefines.UserBind, {
        optType = AccountBindType.Bind,
        pgs_id = playerId,
        pgs_name = displayName,
        auth_code = authCode,
        auto_bind = true
      })
    else
    end
  end
  
  CS.PlayGamesBridge.LoginSilently(OnLoginComplete)
end

function PlayGamesAccount:TipsNotSupport()
  if not CS.GameEntry.Sdk.IsGoogleAvailable and SDKManager.IS_Android() then
    UIUtil.ShowTipsId("multibind_protect_tips01")
  end
end

function PlayGamesAccount:LogEvent(optName)
  local playerUid = ""
  if LuaEntry and LuaEntry.Player and LuaEntry.Player.uid then
    playerUid = LuaEntry.Player.uid
  end
  PostEventLog.Track("c_google_play_account", {
    s_para1 = optName,
    detail = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, ""),
    airkey = CS.GameEntry.Device:GetDeviceUid_Transcoding(),
    uid = playerUid
  })
end

return PlayGamesAccount
