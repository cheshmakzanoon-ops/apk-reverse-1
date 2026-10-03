local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local Setting = CS.GameEntry.Setting
local BaseAccount = require("DataCenter.AccountHelper.BaseAccount")
local GoogleSignAccount = BaseClass("GoogleSignAccount", BaseAccount)

function GoogleSignAccount:__init()
  EventManager:GetInstance():AddListener(EventId.Respond_From_3rd_Platform, self.RespondFrom3rdPlatform)
end

function GoogleSignAccount:__delete()
  EventManager:GetInstance():RemoveListener(EventId.Respond_From_3rd_Platform, self.RespondFrom3rdPlatform)
end

function GoogleSignAccount:Login(data)
  self:TipsNotSupport()
  CS.GameEntry.Sdk:SetAccountFunc(CS.LoginPlatform.GooglePlay, 1)
end

function GoogleSignAccount:Bind()
  self:TipsNotSupport()
  CS.GameEntry.Sdk:SetAccountFunc(CS.LoginPlatform.GooglePlay, 2)
end

function GoogleSignAccount:Unbind()
  self:TipsNotSupport()
  CS.GameEntry.Sdk:SetAccountFunc(CS.LoginPlatform.GooglePlay, 3)
end

function GoogleSignAccount:Verify()
  self:TipsNotSupport()
  UIUtil.ShowConfirmNew({
    title = Localization:GetString("multibind_protect_title01"),
    contentText = Localization:GetString("multibind_protect_desc04"),
    btnNum = 2,
    showToggle = false,
    confirmBtnParam = {
      action = function()
        CS.GameEntry.Sdk:SetAccountFunc(CS.LoginPlatform.GooglePlay, 4)
      end
    }
  })
end

function GoogleSignAccount:IsBound()
  if not string.IsNullOrEmpty(self.userId) then
    return true
  else
    return false
  end
end

function GoogleSignAccount:OnClick()
  local isBindMail = DataCenter.AccountManager.MailAccount:IsBound()
  local isBindGoogleSign = self:IsBound()
  local isBindPlayGames = DataCenter.AccountManager.PlayGamesAccount:IsBound()
  if not DataCenter.AccountManager:IsDoubleVerifyOpen() then
    if isBindGoogleSign then
      self:OnBtnHasBound()
    else
      self:Bind()
    end
    return
  end
  if isBindGoogleSign then
    self:OnBtnHasBound()
  else
    if DataCenter.AccountManager:IsInDoubleChannelVerifyTime() then
      self:Bind()
      return
    end
    if isBindMail then
      DataCenter.AccountManager.MailAccount:Verify()
    elseif isBindPlayGames then
      DataCenter.AccountManager.PlayGamesAccount:Verify()
    else
      self:Bind()
    end
  end
end

function GoogleSignAccount:OnBtnHasBound()
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

function GoogleSignAccount.RespondFrom3rdPlatform(data)
  if not data:ContainsKey("msgId") then
    return
  end
  local msgId = data:GetUtfString("msgId")
  local userId = data:ContainsKey("userId") and data:GetUtfString("userId") or ""
  local userName = data:ContainsKey("userName") and data:GetUtfString("userName") or ""
  local idToken = data:ContainsKey("idToken") and data:GetUtfString("idToken") or ""
  local accountFuncType = data:ContainsKey("accountFuncType") and data:GetInt("accountFuncType") or 0
  local email = data:ContainsKey("email") and data:GetUtfString("email") or ""
  if msgId == "login_sucess_google" then
    if userName == nil or userName == "" then
      UIUtil.ShowMessage("login failed google")
      return
    end
    if accountFuncType == 1 then
      if idToken == nil or idToken == "" then
        SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, {googleAccount = userId})
      else
        SFSNetwork.SendMessage(MsgDefines.AccountLoginNew, {googleAccount = userId, idToken = idToken})
      end
    elseif accountFuncType == 2 then
      if idToken == nil or idToken == "" then
        SFSNetwork.SendMessage(MsgDefines.UserBind, {
          googlePlay = userId,
          optType = AccountBindType.Bind,
          googlePlayName = userName
        })
      else
        SFSNetwork.SendMessage(MsgDefines.UserBind, {
          googlePlay = userId,
          optType = AccountBindType.Bind,
          googlePlayName = userName,
          idToken = idToken
        })
      end
    elseif accountFuncType == 3 then
      local gpAccount = DataCenter.AccountManager.GoogleSignAccount.userId
      if string.IsNullOrEmpty(gpAccount) then
        Logger.LogError("\229\185\179\229\143\176\230\141\162\231\187\145\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132GooglePlay\232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if gpAccount == userId then
        SFSNetwork.SendMessage(MsgDefines.GoogleCancelBind, {type = "google", account = userId})
      else
        UIUtil.ShowMessage(Localization:GetString("email_unbind_des_fail"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_unbind_title")
      end
    elseif accountFuncType == 4 then
      local gpAccount = DataCenter.AccountManager.GoogleSignAccount.userId
      if string.IsNullOrEmpty(gpAccount) then
        Logger.LogError("GooglePlay\233\170\140\232\175\129\226\128\148\226\128\148\226\128\148\226\128\148\229\189\147\229\137\141\230\156\172\229\156\176\229\173\152\229\130\168\231\154\132GooglePlay\232\180\166\229\143\183\228\184\186\231\169\186\239\188\129")
        return
      end
      if gpAccount == userId then
        SFSNetwork.SendMessage(MsgDefines.MultiProtectGoogleVerify)
        UIUtil.ShowTipsId("multibind_protect_verity02")
      else
        UIUtil.ShowMessage(Localization:GetString("multibind_protect_desc03"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "multibind_protect_title02")
      end
    end
  elseif msgId == "login_failed_google" or msgId == "login_canceled_google" or msgId == "login_canceled_fb" or msgId == "login_failed_fb" or msgId == "login_failed_gamecenter" then
    local err = ""
    if data:ContainsKey("_errorNo") then
      err = "," .. data:GetUtfString("_errorNo")
    end
    if accountFuncType == 1 then
      UIUtil.ShowTips(Localization:GetString("120951", err))
    elseif accountFuncType == 2 then
      UIUtil.ShowTips(Localization:GetString("280054") .. err)
    elseif accountFuncType == 3 then
      UIUtil.ShowMessage(Localization:GetString("email_unbind_des_fail"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_unbind_title")
    elseif accountFuncType == 4 then
      UIUtil.ShowTips(Localization:GetString("120951", err))
    end
  end
end

function GoogleSignAccount:TipsNotSupport()
  if not CS.GameEntry.Sdk.IsGoogleAvailable and SDKManager.IS_Android() then
    UIUtil.ShowTipsId("multibind_protect_tips01")
  end
end

return GoogleSignAccount
