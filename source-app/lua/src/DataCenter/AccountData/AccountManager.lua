local AccountManager = BaseClass("AccountManager")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local RolesInfo = require("DataCenter.AccountData.RolesInfo")
local MailAccount = require("DataCenter.AccountHelper.MailAccount")
local GoogleSignAccount = require("DataCenter.AccountHelper.GoogleSignAccount")
local PlayGamesAccount = require("DataCenter.AccountHelper.PlayGamesAccount")
local GameCenterAccount = require("DataCenter.AccountHelper.GameCenterAccount")

function AccountManager:__init()
  self.allAccount = {}
  self.param = {}
  self.bindReward = {}
  self.rolesList = {}
  self.serverList = {}
  self.maxServerId = 0
  self.openRolesListAfterBind = false
  self.gmServers = {}
  self.firstBindAccountRewardFlag = false
  self.accountChangeBindExp = -1
  self.isBindingNewAccount = false
  self.oldEmailVerifyCode = ""
  self.isGuideInitFinished = false
  self.hasShownLevelOneBattleMainView = false
  self.shumeiCreateAccountRiskLevel = nil
  self.mailVerifyCodeType = ""
  self.isRegister = false
  self.MailAccount = MailAccount.New()
  self.GoogleSignAccount = GoogleSignAccount.New()
  self.PlayGamesAccount = PlayGamesAccount.New()
  self.GameCenterAccount = GameCenterAccount.New()
  
  function self.FuncOnParkourBattleMainViewCreate()
    self:OnCreateParkourBattleMainView()
  end
  
  EventManager:GetInstance():AddListener(EventId.ParkourBattleMainViewCreated, self.FuncOnParkourBattleMainViewCreate)
  
  function self.FuncOnGuideInitFinish()
    self:OnGuideInitFinish()
  end
  
  EventManager:GetInstance():AddListener(EventId.GuideInitFinish, self.FuncOnGuideInitFinish)
end

function AccountManager:__delete()
  EventManager:GetInstance():RemoveListener(EventId.GuideInitFinish, self.FuncOnGuideInitFinish)
  EventManager:GetInstance():RemoveListener(EventId.ParkourBattleMainViewCreated, self.FuncOnParkourBattleMainViewCreate)
  self.allAccount = nil
  self.param = nil
  self.bindReward = nil
  self.rolesList = nil
  self.serverList = nil
  self.openRolesListAfterBind = false
  self.gmServers = nil
  self.accountChangeBindExp = -1
  self.isBindingNewAccount = false
  self.oldEmailVerifyCode = ""
  self.mailVerifyCodeType = nil
  self.shumeiCreateAccountRiskLevel = nil
  self.hasShownLevelOneBattleMainView = nil
  self.isGuideInitFinished = nil
  self.isRegister = false
  self.PlayGamesAccount:Delete()
  self.PlayGamesAccount = nil
  self.MailAccount:Delete()
  self.MailAccount = nil
  self.GoogleSignAccount:Delete()
  self.GoogleSignAccount = nil
  self.GameCenterAccount:Delete()
  self.GameCenterAccount = nil
end

function AccountManager:InitData(message)
  local gameCenterOn = LuaEntry.DataConfig:CheckSwitch("gamecenter_binding")
  Setting:SetBool("SettingKeys_GAMECENTER_ON", gameCenterOn)
  local user = message.user
  self:SetAccountChangeBindExp(message.accountChangeBindCd)
  self:InitAccountBind(user)
  self.isRegister = message.isRegister
end

function AccountManager:OnEnterGame()
  if not CS.PlayGamesBridge.IsPlayGamesAvailable() then
    return
  end
  if Config and Config.IsPlayPC and Config.IsPlayPC() then
    return
  end
  local isNotBand = self:GetAccountBindState() == AccountBandState.UnBand
  if isNotBand then
    self.PlayGamesAccount:AutoBind()
  end
end

function AccountManager:InitAccountBind(user)
  if not user then
    return
  end
  self.firstBindAccountRewardFlag = tonumber(user.firstBindAccountRewardFlag or 0) == 1
  self.MailAccount.accountStatus = user.az_account_status
  self.MailAccount.gameAccount = user.email or ""
  if not user.bindFlag then
    self.MailAccount.gameAccount = ""
    self.MailAccount.accountStatus = AccountBandState.UnBand
  end
  Setting:SetString("Setting.CUSTOM_UID", self.MailAccount.gameAccount)
  self.GoogleSignAccount.userId = user.googlePlay
  self.GoogleSignAccount.userName = user.googleAccountName
  self.PlayGamesAccount.userId = user.pgsId
  self.PlayGamesAccount.userName = user.pgsName
  self.GameCenterAccount.userId = user.pfId
  self.GameCenterAccount.userName = user.pf
end

function AccountManager:AccountBindHandle(message)
  if message.errorCode == nil then
    self.MailAccount.gameAccount = self.param.userName
    self.MailAccount.accountStatus = AccountBandState.UnCheck
    Setting:SetString("Setting.CUSTOM_UID", self.MailAccount.gameAccount)
    EventManager:GetInstance():Broadcast(EventId.AccountBindEvent)
    if not DataCenter.AccountScoreManager:CheckAccountIDOpen() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountVerify, self.param.userName, 2)
    end
  else
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICreateAccount) then
      EventManager:GetInstance():Broadcast(EventId.CreateAccountMailFail)
    end
  end
end

function AccountManager:ChangeBindAccountSuccess(message)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
  local openManageView = DataCenter.AccountScoreManager:CheckAccountIDOpen()
  if not openManageView then
    UIUtil.ShowMessage(Localization:GetString("email_change_des_success"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_change_title")
  end
  self:SetIsBindingNewAccount(false)
  self:SetAccountChangeBindExp(tonumber(message.accountChangeBindCd))
  self.MailAccount.gameAccount = message.newEmail or ""
  self.MailAccount.accountStatus = AccountBandState.Band
  Setting:SetString("Setting.CUSTOM_UID", self.MailAccount.gameAccount)
  EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
end

function AccountManager:SetParam(param)
  self.param = param
end

function AccountManager:AccountLoginHandle(message)
  local errorCode = message.errorCode
  if errorCode then
    if errorCode == "E100200" then
      local userName = message.gameUserName or ""
      local userServerId = message.serverId or ""
      local reason = message.banMsgId or ""
      if not message.banTime then
        local bantime = 0
      end
    elseif errorCode == "280048" then
      UIUtil.ShowTips(Localization:GetString("280048", self.param.mail or ""))
    else
      UIUtil.ShowTipsId(errorCode)
    end
    return
  end
  local gameUid = message.gameUid
  if not gameUid or gameUid == "" then
    local status = message.status
    if not status then
      UIUtil.ShowMessage(Localization:GetString("280061"))
    else
      local tipsId = status == 1 and 280112 or status == 2 and 280081
      if tipsId then
        UIUtil.ShowTipsId(tipsId)
        EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
      end
    end
    return
  end
  local loginKey = message.loginKey
  local accountArr = message.accountArr
  if accountArr then
    self.rolesList = {}
    for _, account in ipairs(accountArr) do
      local rolesInfo = RolesInfo.New()
      rolesInfo:Parse(account)
      rolesInfo.loginKey = loginKey
      table.insert(self.rolesList, rolesInfo)
    end
    local type = message.type
    if type == 0 or type == 2 or type == 4 or type == 5 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles, {anim = true, hideTop = true}, 1)
    else
      EventManager:GetInstance():Broadcast(EventId.RolesRefresh)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILoginConfirm, {anim = true}, message)
  end
end

function AccountManager:GetRolesList()
  return self.rolesList
end

function AccountManager:PushAccountFirmedHandle(message)
  self.MailAccount.accountStatus = AccountBandState.Band
  if CS.SDKManager.IS_UNITY_IOS() and CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.263") >= 0 then
    local account = self.MailAccount.gameAccount
    if account ~= nil and account ~= "" and self:IsGoogleEmail(account) then
      CS.GameEntry.Sdk:AnalyticsAccountEmail(account)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AccountBindOKEvent)
  local openAccountManager = DataCenter.AccountScoreManager:CheckAccountIDOpen()
  if not openAccountManager then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountVerify)
    local closeCallBack
    if self.openRolesListAfterBind then
      function closeCallBack()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles, {anim = true, hideTop = true}, 0)
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBindSuccess, BindSuccessType.BindAccount, message.reward ~= nil, closeCallBack)
  end
end

function AccountManager:IsGoogleEmail(account)
  local domain = account:match("@(.*)")
  if domain == "gmail.com" or domain == "googlemail.com" then
    return true
  else
    return false
  end
end

function AccountManager:GetAccountBindState()
  if self.MailAccount.gameAccount and self.MailAccount.gameAccount ~= "" then
    return self.MailAccount.accountStatus or 0
  end
  if not string.IsNullOrEmpty(self.PlayGamesAccount.userId) then
    return AccountBandState.Band
  end
  if not string.IsNullOrEmpty(self.GoogleSignAccount.userId) then
    return AccountBandState.Band
  end
  if not string.IsNullOrEmpty(self.GameCenterAccount.userId) then
    return AccountBandState.Band
  end
  return AccountBandState.UnBand
end

function AccountManager:OnHandleNewGame()
  local state = self:GetAccountBindState()
  if state == AccountBandState.Band then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles, {anim = true, hideTop = true}, 0)
    return
  end
  
  local function openWindow()
    if DataCenter.AccountScoreManager:CheckAccountIDOpen() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountManage, {anim = true, hideTop = true}, nil, true)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, {anim = true, hideTop = true}, nil, true)
    end
  end
  
  UIUtil.ShowMessage(Localization:GetString("280097"), 1, GameDialogDefine.CONFIRM, "", openWindow, false, false, "", true)
  return
end

function AccountManager:SaveBindAccountReward(message)
  if next(message.reward) then
    self.bindReward = message.reward
  end
end

function AccountManager:GetBindAccountReward()
  return self.bindReward
end

function AccountManager:AccountGetAllServerHandle(message)
  if not message.type or not message.servers then
    return
  end
  local list = message.servers
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  if message.type == 0 then
    if 0 >= self.maxServerId then
      self.serverList = {}
      self.maxServerId = message.maxServerId
      local num = LuaEntry.DataConfig:TryGetNum("server_population", "k3", 10)
      local count = math.ceil(self.maxServerId / num)
      for i = 1, count do
        self.serverList[i - 1] = {
          minNum = 1 + (i - 1) * num,
          maxNum = math.min(i * num, self.maxServerId),
          serverList = {},
          serverIndex = i - 1
        }
      end
    end
    self.serverList[-1] = self.serverList[-1] or {
      minNum = 0,
      maxNum = 0,
      serverList = {},
      serverIndex = -1
    }
    self.serverList[-1].serverList = list
    if message.gmServers then
      self.serverList[-2] = self.serverList[-2] or {
        serverList = {},
        serverIndex = -2
      }
      self.serverList[-2].serverList = message.gmServers
    else
      self.serverList[-2] = nil
    end
    self.gmServers = message.gmServers
  else
    local page = message.page
    if page and self.serverList[page] then
      self.serverList[page].serverList = list
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ServerListRefresh)
end

function AccountManager:GetServerListByIndex(index)
  if self.serverList[index] ~= nil then
    return self.serverList[index].serverList
  end
  return ""
end

function AccountManager:GetServerTabData()
  local list = {}
  for k, v in pairs(self.serverList) do
    if 0 <= k then
      local param = {}
      param.index = k
      param.minNum = v.minNum
      param.maxNum = v.maxNum
      table.insert(list, param)
    end
  end
  table.sort(list, function(a, b)
    return a.index > b.index
  end)
  local firstParam = {}
  firstParam.index = -1
  table.insert(list, 1, firstParam)
  if self.serverList and self.serverList[-2] and not table.IsNullOrEmpty(self.serverList[-2].serverList) then
    local gmServer = {}
    gmServer.index = -2
    table.insert(list, 1, gmServer)
  end
  return list
end

function AccountManager:SetAfterBindOpenRolesList(state)
  self.openRolesListAfterBind = state
end

function AccountManager:ResetAfterBindOpenRolesList()
  self.openRolesListAfterBind = false
end

function AccountManager:SetAccountChangeBindExp(accountChangeBindExp)
  self.accountChangeBindExp = accountChangeBindExp or 0
end

function AccountManager:GetAccountChangeBindExp()
  return self.accountChangeBindExp
end

function AccountManager:CanChangeBindAccount()
  local expTime = self.accountChangeBindExp
  if expTime < 0 then
    Logger.LogError("\230\141\162\231\187\145\233\130\174\231\174\177/\229\185\179\229\143\176\229\128\146\232\174\161\230\151\182\230\156\170\232\162\171\229\136\157\229\167\139\229\140\150\239\188\129")
    return false
  elseif expTime == 0 then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = expTime - curTime
  return remainTime < 0
end

function AccountManager:SetIsBindingNewAccount(isBinding)
  self.isBindingNewAccount = isBinding
end

function AccountManager:GetIsBindingNewAccount()
  return self.isBindingNewAccount
end

function AccountManager:SetOldEmailVerifyCode(verifyCode)
  self.oldEmailVerifyCode = verifyCode
end

function AccountManager:GetOldEmailVerifyCode()
  return self.oldEmailVerifyCode
end

function AccountManager:GoogleCancelBindRefresh()
  if self.param and not string.IsNullOrEmpty(self.param.type) then
    if self.param.type == "google" then
      self.GoogleSignAccount:ClearBindData()
    elseif self.param.type == "GooglePlay" then
      self.PlayGamesAccount:ClearBindData()
    elseif self.param.type == "AppStore" then
      self.GameCenterAccount:ClearBindData()
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MSG_USER_BIND_OK)
  UIUtil.ShowMessage(Localization:GetString("email_unbind_des_success"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "email_unbind_title")
end

function AccountManager:OnCreateParkourBattleMainView()
  if DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
    self.hasShownLevelOneBattleMainView = true
  end
end

function AccountManager:OnGuideInitFinish()
  self.isGuideInitFinished = true
end

function AccountManager:IsShumeiCreateAccountRisk()
  if not CS.ShumeiSdkManager.Instance.IsFunctionOpen then
    return false
  end
  if Config and Config.IsPlayPC and Config.IsPlayPC() then
    return false
  end
  return self.shumeiCreateAccountRiskLevel == 1 or self.shumeiCreateAccountRiskLevel == 2
end

function AccountManager:TriggerShumeiCreateAccountBan()
  local function FuncOpenBanView()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountBan, {anim = true}, self.shumeiCreateAccountRiskLevel, AccountBanViewShowType.ShumeiCreateAccountRisk)
  end
  
  if not self:IsShumeiCreateAccountRisk() then
    return
  end
  local isOn = CS.ClientSwitch.IsOn(CS.ClientSwitch.ENABLE_SHUMEI_CREATE_ACCOUNT_RISK_BAN)
  if DataCenter.LWGuideManager:GetCurGuideId() == GuideState.LevelOne then
    if self.hasShownLevelOneBattleMainView then
      if isOn then
        FuncOpenBanView()
      end
      PostEventLog.Track(PostEventLog.Defines.ShumeiCreateAccountRiskBan, {
        emulator_baned = "popup_after"
      })
      PostEventLog.Track("s_shu_mei_create_role_ban", {
        s_para1 = "shumei_null_or_emulator"
      })
    else
    end
  else
    if isOn then
      FuncOpenBanView()
    end
    PostEventLog.Track(PostEventLog.Defines.ShumeiCreateAccountRiskBan, {emulator_baned = "popup"})
  end
end

function AccountManager:OnPushShumeiExceptionLevel(message)
  if message == nil then
    Logger.LogWarning("ShumeiExceptionLevel message is nil")
    return
  end
  self.shumeiCreateAccountRiskLevel = message.creat_account_rick_level
  if self:IsShumeiCreateAccountRisk() then
    Logger.LogInfo("ShumeiExceptionLevel creat_account_rick_level is 1")
  end
  if not self.isGuideInitFinished then
    Logger.LogWarning("ShumeiExceptionLevel pushed when guide not init")
    return
  end
  self:TriggerShumeiCreateAccountBan()
end

function AccountManager:SetMailVerifyCodeType(oType)
  self.mailVerifyCodeType = oType
end

function AccountManager:GetMailVerifyCodeType()
  return self.mailVerifyCodeType
end

function AccountManager:IsDeviceMgrOpen()
  return LuaEntry.DataConfig:CheckSwitch("unbind_device")
end

function AccountManager:IsDoubleVerifyOpen()
  return LuaEntry.DataConfig:CheckSwitch("second_device_factor")
end

function AccountManager:IsInDoubleChannelVerifyTime()
  local expireTime = Setting:GetPrivateString("DoubleChannelVerifyExpireTime", "")
  if not string.IsNullOrEmpty(expireTime) then
    local now = UITimeManager:GetInstance():GetServerTime()
    local eTime = tonumber(expireTime)
    if now < eTime then
      return true
    end
  end
  return false
end

function AccountManager:Odm2_PostAggregateConversionInfo()
  if CS.SDKManager.IS_UNITY_IOS() and CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, "1.0.322") >= 0 and self.isRegister then
    CS.GameEntry.Sdk:Odm2_PostAggregateConversionInfo()
  end
end

return AccountManager
