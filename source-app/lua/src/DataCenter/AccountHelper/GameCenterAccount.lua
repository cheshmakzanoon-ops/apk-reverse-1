local Localization = CS.GameEntry.Localization
local BaseAccount = require("DataCenter.AccountHelper.BaseAccount")
local GameCenterAccount = BaseClass("GameCenterAccount", BaseAccount)

function GameCenterAccount:__init()
end

function GameCenterAccount:__delete()
end

function GameCenterAccount:Login(data)
  local function OnBindComplete(success, authData)
    local userId = authData.teamPlayerID
    
    local userName = authData.displayName
    if success then
      SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, {pfId = userId})
    else
      local errorMessage = authData.displayName
      UIUtil.ShowTips(Localization:GetString("120951", errorMessage))
    end
  end
  
  CS.GameCenterBridge.Login(OnBindComplete)
end

function GameCenterAccount:Bind()
  local function OnBindComplete(success, authData)
    local userId = authData.teamPlayerID
    
    local userName = authData.displayName
    if success then
      SFSNetwork.SendMessage(MsgDefines.UserBind, {
        googlePlay = userId,
        optType = AccountBindType.Bind,
        googlePlayName = userName
      })
    else
      local errorMessage = authData.displayName
      UIUtil.ShowTips(Localization:GetString("280054") .. errorMessage)
    end
  end
  
  CS.GameCenterBridge.Login(OnBindComplete)
end

function GameCenterAccount:Unbind()
  local function OnBindComplete(success, authData)
    local userId = authData.teamPlayerID
    
    local userName = authData.displayName
    if success then
      if string.IsNullOrEmpty(self.userId) then
        Logger.LogError("VerifyGameCenter\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132GameCenter\232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if self.userId == userId then
        SFSNetwork.SendMessage(MsgDefines.GoogleCancelBind, {
          type = "AppStore",
          account = self.userId
        })
      else
        UIUtil.ShowMessage(Localization:GetString("multibind_protect_desc03"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "multibind_protect_title02")
      end
    else
      local errorMessage = authData.displayName
      UIUtil.ShowTips(Localization:GetString("120951", errorMessage))
    end
  end
  
  CS.GameCenterBridge.Login(OnBindComplete)
end

function GameCenterAccount:Verify()
  local function OnBindComplete(success, authData)
    local userId = authData.teamPlayerID
    
    local userName = authData.displayName
    if success then
      if string.IsNullOrEmpty(self.userId) then
        Logger.LogError("VerifyGameCenter\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132GameCenter\232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if self.userId == userId then
        SFSNetwork.SendMessage(MsgDefines.MultiProtectGoogleVerify)
        UIUtil.ShowTipsId("multibind_protect_verity02")
      else
        UIUtil.ShowMessage(Localization:GetString("multibind_protect_desc03"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "multibind_protect_title02")
      end
    else
      local errorMessage = authData.displayName
      UIUtil.ShowTips(Localization:GetString("120951", errorMessage))
    end
  end
  
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("multibind_protect_title01"),
    contentText = Localization:GetString("multibind_protect_desc05"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        CS.GameCenterBridge.Login(OnBindComplete)
      end
    }
  })
end

function GameCenterAccount:IsBound()
  if not string.IsNullOrEmpty(self.userId) then
    return true
  else
    return false
  end
end

function GameCenterAccount:OnClick()
  local isBindMail = DataCenter.AccountManager.MailAccount:IsBound()
  local isBindGameCenter = self:IsBound()
  if not DataCenter.AccountManager:IsDoubleVerifyOpen() then
    if isBindGameCenter then
      self:OnBtnHasBound()
    else
      self:Bind()
    end
    return
  end
  if isBindGameCenter then
    self:OnBtnHasBound()
  else
    if DataCenter.AccountManager:IsInDoubleChannelVerifyTime() then
      self:Bind()
      return
    end
    if isBindMail then
      DataCenter.AccountManager.MailAccount:Verify()
    else
      self:Bind()
    end
  end
end

function GameCenterAccount:OnBtnHasBound()
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

return GameCenterAccount
