local MaxAdManager = BaseClass("MaxAdManager")
local AdCollectionTemplate = require("DataCenter.MaxAdManager.AdCollectionTemplate")
local Localization = CS.GameEntry.Localization
local Sdk = CS.GameEntry.Sdk
local ApplovinManager = CS.ApplovinManager
local rapidjson = require("rapidjson")
local SwitchAdUnitTimes = 10
local DefaultShowAdFailCd = 10
local DefaultRefreshVisitorCd = 36000
local DefaultVisitorShowTime = 3600
local DefaultSDKVersion = "1.0.320"
local VISITOR_EVENT_ID = 15001
local REMINDER_VISITOR_SHOW_TIME_KEY = "REMINDER_VISITOR_SHOW_TIME_KEY"
local WATCH_AD_RECORD_KEY = "WATCH_AD_RECORD_KEY"

function MaxAdManager:__init()
  self.collectionTemplateList = nil
  self.serverAdsInfo = {}
  self.hasPrivilege = false
  self.showAdFailCd = DefaultShowAdFailCd
  self.visitorRefreshCd = DefaultRefreshVisitorCd
  self.visitorShowTime = DefaultVisitorShowTime
  self.sdkVersion = DefaultSDKVersion
  self.privilegePackageId = ""
  self.lastVisitorTime = nil
  self.lastLoadAdTime = nil
  self.init = false
  self.lastCheckReadyTime = nil
  self.lastCheckReadyState = nil
  self.privilegeItemId = 0
  self.topSwitch = false
  self.ApplovinSDK = ApplovinManager.Instance
  self:AddListener()
end

function MaxAdManager:__delete()
  if self.visitorFinishTimer ~= nil then
    self.visitorFinishTimer:Stop()
    self.visitorFinishTimer = nil
  end
  self:RemoveListener()
  self.ApplovinSDK = nil
  self.hasPrivilege = false
  self.collectionTemplateList = nil
  self.serverAdsInfo = {}
  self.showAdFailCd = DefaultShowAdFailCd
  self.visitorRefreshCd = DefaultRefreshVisitorCd
  self.visitorShowTime = DefaultVisitorShowTime
  self.sdkVersion = DefaultSDKVersion
  self.privilegePackageId = ""
  self.lastVisitorTime = nil
  self.lastLoadAdTime = nil
  self.init = false
  self.lastCheckReadyTime = nil
  self.lastCheckReadyState = nil
  self.privilegeItemId = 0
  self.topSwitch = false
end

function MaxAdManager:InitData(message)
  self:InitConfig()
end

function MaxAdManager:InitSdk(message)
  if self.hasPrivilege then
    return
  end
  if self.init == true then
    return
  end
  local adUnitList = {}
  local exist = {}
  for _, v in pairs(self:GetServerInfo()) do
    local template = self:GetAdCollectionTemplate(v.id)
    if template then
      local adUnitId = template:GetAdUnitId()
      if adUnitId and not exist[adUnitId] then
        exist[adUnitId] = true
        table.insert(adUnitList, adUnitId)
      end
    end
  end
  if table.IsNullOrEmpty(adUnitList) then
    return
  end
  self.init = true
  self:InitRewardedAd(adUnitList)
  self:SetUserId(LuaEntry.Player.uid)
end

function MaxAdManager:InitConfig()
  self.privilegePackageId = LuaEntry.DataConfig:TryGetStr("ads_para", "k1", "")
  self.showAdFailCd = LuaEntry.DataConfig:TryGetNum("ads_para", "k2", DefaultShowAdFailCd)
  self.visitorRefreshCd = LuaEntry.DataConfig:TryGetNum("ads_para", "k3", DefaultRefreshVisitorCd)
  self.visitorShowTime = LuaEntry.DataConfig:TryGetNum("ads_para", "k4", DefaultVisitorShowTime)
  self.sdkVersion = LuaEntry.DataConfig:TryGetStr("ads_para", "k5", DefaultSDKVersion)
  self.privilegeItemId = LuaEntry.DataConfig:TryGetNum("ads_para", "k11", 0)
end

function MaxAdManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnPassDay, self.OnPassDaySignal)
end

function MaxAdManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnPassDay, self.OnPassDaySignal)
end

function MaxAdManager.OnPassDaySignal()
  DataCenter.MaxAdManager:RequestAdsInfo()
end

function MaxAdManager:Log(...)
  if self:IsDebugOpen() then
    Logger.LogError(...)
  end
end

function MaxAdManager:GetLogStr(dict)
  local arr = {}
  for k, v in pairs(dict) do
    table.insert(arr, tostring(k) .. "=" .. tostring(v))
  end
  return table.concat(arr, ", ")
end

function MaxAdManager:RequestAdsInfo()
  if not DataCenter.MaxAdManager:IsNeedRequest() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetAdsInfo)
end

function MaxAdManager:ShowAdsDetail(id)
  if not DataCenter.MaxAdManager:IsNeedRequest() then
    return
  end
  if not self:IsAdsUnlock() then
    return
  end
  if Config.IsPC() then
    UIUtil.ShowTipsId("activity_ads_016")
    return
  end
  if not self:IsAdsSupport() then
    UIUtil.ShowTipsId("activity_ads_010")
    return
  end
  local template = self:GetAdCollectionTemplate(id)
  if not self:HasPrivilege() and not self:IsAdReady(template:GetAdUnitId()) then
    UIUtil.ShowTipsId("activity_ads_005")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ShowAdsDetail, id)
end

function MaxAdManager:GetAdsReward(id, isAll)
  if not DataCenter.MaxAdManager:IsNeedRequest() then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetAdsReward, {
    id = id,
    isAll = isAll == true
  })
end

function MaxAdManager:OnReceiveAdsInfo(message)
  if message == nil then
    return
  end
  self.hasPrivilege = message.hasPrivilege == true
  self.topSwitch = message.topSwitch == true
  if type(message.collectionList) == "table" then
    for _, v in pairs(message.collectionList) do
      local data = self.serverAdsInfo[tostring(v.id)] or {}
      data.id = v.id
      data.rewardTimes = v.rewardTimes
      self.serverAdsInfo[tostring(v.id)] = data
    end
  end
  self:OnCheckVisitorState()
  EventManager:GetInstance():Broadcast(EventId.MaxAd_RefreshAdInfo)
  local info = CommonUtil.PlayerPrefsGetTable(WATCH_AD_RECORD_KEY, {})
  if not table.IsNullOrEmpty(info) then
    self:ClearWatchInfo()
    local serverDataList = DataCenter.MaxAdManager:GetServerInfo()
    local serverData = serverDataList[tostring(info.placement)] or {}
    if info.rewardTimes == serverData.rewardTimes then
      self:GetAdsReward(tonumber(info.placement), false)
    end
  end
end

function MaxAdManager:SetUserId(userId)
  local tbl = {}
  tbl.userId = userId
  local json = rapidjson.encode(tbl)
  Sdk:SendDataToNative("Applovin_SetUserId", json)
end

function MaxAdManager:ShowDebugger()
  Sdk:SendDataToNative("Applovin_ShowDebugger", "")
end

function MaxAdManager:InitRewardedAd(list)
  self:Log("MaxAdManager InitRewardedAd")
  local tbl = {}
  local adList = {}
  for _, v in pairs(list) do
    table.insert(adList, {adUnitId = v})
  end
  tbl.rewardedAdList = adList
  local json = rapidjson.encode(tbl)
  Sdk:SendDataToNative("Applovin_InitSdk", json)
  Sdk:SendDataToNative("Applovin_InitRewardedAd", json)
  self.lastLoadAdTime = UITimeManager:GetInstance():GetServerTime()
  TimerManager:GetInstance():DelayInvoke(function()
    for _, v in pairs(adList) do
      self:LoadAd(v.adUnitId)
    end
  end, 3)
end

function MaxAdManager:ShowAd(adUnitId, placement)
  self:Log("MaxAdManager Applovin_ShowAd" .. adUnitId)
  local tbl = {}
  tbl.adUnitId = adUnitId
  tbl.placement = placement
  local json = rapidjson.encode(tbl)
  Sdk:SendDataToNative("Applovin_ShowAd", json)
  DataCenter.LWSoundManager:StopBGMusic()
  if self:IsDebugOpen() then
    UIUtil.ShowTips("\231\173\1373\231\167\146")
    TimerManager:GetInstance():DelayInvoke(function()
      self:OnUserRewarded({placement = placement, adUnitId = adUnitId})
    end, 3)
  end
end

function MaxAdManager:CacheWatchInfo(placement, rewardTimes)
  CommonUtil.PlayerPrefsSetTable(WATCH_AD_RECORD_KEY, {placement = placement, rewardTimes = rewardTimes})
end

function MaxAdManager:ClearWatchInfo()
  CommonUtil.PlayerPrefsSetTable(WATCH_AD_RECORD_KEY, {})
end

function MaxAdManager:LoadAd(adUnitId)
  self:Log("MaxAdManager Applovin_LoadAd" .. adUnitId)
  local tbl = {}
  tbl.adUnitId = adUnitId
  local json = rapidjson.encode(tbl)
  Sdk:SendDataToNative("Applovin_LoadAd", json)
  self.lastLoadAdTime = UITimeManager:GetInstance():GetServerTime()
end

function MaxAdManager:IsAdReady(adUnitId)
  if self:IsDebugOpen() then
    return true
  end
  local tbl = {}
  tbl.adUnitId = adUnitId
  local json = rapidjson.encode(tbl)
  local ready = Sdk:GetDataFromNative("Applovin_IsAdReady", json)
  self:Log("MaxAdManager IsAdReady" .. adUnitId .. " " .. ready)
  return ready == "1"
end

function MaxAdManager:__SdkCallback(key, data)
  CommonUtil.ProtectCall(function()
    if key == "Applovin_OnReceiveListener" then
      self:OnReceiveListener(data)
    elseif key == "Applovin_OnCheckReadyResp" then
      self:OnCheckReadyResp(data)
    end
  end)
end

function MaxAdManager:OnCheckReadyResp(jsonData)
end

function MaxAdManager:OnReceiveListener(jsonData)
  local result = rapidjson.decode(jsonData)
  if result == nil then
    PostEventLog.Track(PostEventLog.Defines.applovin_callback_break, {err_code = "nil", errMsg = jsonData})
    return
  end
  local reason = result.reason
  if reason == "Applovin_Callback_OnUserRewarded" then
    self:OnUserRewarded(result)
  elseif reason == "Applovin_Callback_OnAdLoaded" then
    self:OnAdLoaded(result)
  elseif reason == "Applovin_Callback_OnAdDisplay" then
    self:OnAdDisplay(result)
  elseif reason == "Applovin_Callback_OnAdHidden" then
    self:OnAdHidden(result)
  elseif reason == "Applovin_Callback_OnAdClicked" then
    self:OnAdClicked(result)
  elseif reason == "Applovin_Callback_OnAdRevenuePaid" then
    self:OnAdRevenuePaid(result)
  elseif reason == "Applovin_Callback_OnAdRequestStarted" then
    self:OnAdRequestStarted(result)
  elseif reason == "Applovin_Callback_OnAdLoadFailed" then
    self:OnAdLoadFailed(result)
  elseif reason == "Applovin_Callback_OnAdDisplayFailed" then
    self:OnAdDisplayFailed(result)
  end
end

function MaxAdManager:CreateReportData(maxAdData)
  return {
    ad_country_code = maxAdData.countryCode,
    network_account_id = maxAdData.networkName,
    af_ad_id = maxAdData.adUnitId,
    af_ad_type = maxAdData.adFormat,
    af_content_id = maxAdData.placement,
    af_receipt_id = maxAdData.dspId,
    af_ad = maxAdData.networkPlacement,
    af_adset = maxAdData.revenuePrecision,
    af_order_id = maxAdData.dspName,
    af_quantity = maxAdData.revenue
  }
end

function MaxAdManager:CreateReportErrorData(maxErrorData)
  return {
    code = maxErrorData.code,
    errormsg = maxErrorData.message,
    typecode = maxErrorData.networkErrorCode,
    err_msg = maxErrorData.networkErrorMessage,
    af_ad_id = maxErrorData.adUnitId
  }
end

function MaxAdManager:OnUserRewarded(data)
  self:Log("OnUserRewarded = " .. table.dump(data))
  self:LoadAd(data.adUnitId)
  local isAll = UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMaxAd)
  local serverDataList = DataCenter.MaxAdManager:GetServerInfo()
  local serverData = serverDataList[tostring(data.placement)] or {}
  self:CacheWatchInfo(data.placement, serverData.rewardTimes)
  self:GetAdsReward(tonumber(data.placement), isAll)
  local report = self:CreateReportData(data)
  PostEventLog.Track(PostEventLog.Defines.ADViewSuccess, report)
  Logger.LogInfo("MaxAdManager OnUserRewarded " .. MaxAdManager:GetLogStr(data))
  CommonUtil.PlayGameBgMusic()
end

function MaxAdManager:OnAdLoaded(data)
  Logger.LogInfo("MaxAdManager OnAdLoaded")
  self:Log("OnAdLoaded = " .. table.dump(data))
  local report = self:CreateReportData(data)
  local time = UITimeManager:GetInstance():GetServerTime()
  if self.lastLoadAdTime then
    report.after_exp = time - self.lastLoadAdTime
  end
  self.lastCheckReadyState = true
  self.lastCheckReadyTime = nil
  PostEventLog.Track(PostEventLog.Defines.ADLoadingSuccess, report)
end

function MaxAdManager:OnAdDisplay(data)
  Logger.LogInfo("MaxAdManager OnAdDisplay")
  self:Log("OnAdDisplay = " .. table.dump(data))
end

function MaxAdManager:OnAdHidden(data)
  Logger.LogInfo("MaxAdManager OnAdHidden")
  self:Log("OnAdHidden = " .. table.dump(data))
  CommonUtil.PlayGameBgMusic()
end

function MaxAdManager:OnAdClicked(data)
  Logger.LogInfo("MaxAdManager OnAdClicked")
  self:Log("OnAdClicked = " .. table.dump(data))
  local report = self:CreateReportData(data)
  PostEventLog.Track(PostEventLog.Defines.ADClick, report)
end

function MaxAdManager:OnAdRevenuePaid(data)
  self:Log("OnAdRevenuePaid = " .. table.dump(data))
  local report = self:CreateReportData(data)
  PostEventLog.Track(PostEventLog.Defines.ADIncome, report)
  Logger.LogInfo("MaxAdManager OnAdRevenuePaid " .. MaxAdManager:GetLogStr(data))
end

function MaxAdManager:OnAdRequestStarted(data)
  Logger.LogInfo("MaxAdManager OnAdRequestStarted")
  self:Log("OnAdRequestStarted = " .. table.dump(data))
end

function MaxAdManager:OnAdLoadFailed(data)
  Logger.LogError(string.format("MaxAdManager OnAdLoadFailed %s %s %s", tostring(data.adUnitId), tostring(data.code), tostring(data.message)))
  self:Log("OnAdLoadFailed = " .. table.dump(data))
  local report = self:CreateReportErrorData(data)
  PostEventLog.Track(PostEventLog.Defines.ADLoadingFail, report)
end

function MaxAdManager:OnAdDisplayFailed(data)
  Logger.LogError(string.format("MaxAdManager OnAdDisplayFailed %s %s %s", tostring(data.adUnitId), tostring(data.code), tostring(data.message)))
  self:Log("OnAdDisplayFailed = " .. table.dump(data))
  local placement = data.extra
  local report = self:CreateReportErrorData(data)
  report.af_content_id = placement
  PostEventLog.Track(PostEventLog.Defines.AdShowFail, report)
  CommonUtil.PlayGameBgMusic()
end

function MaxAdManager:IsAdsUnlock()
  local data = DataCenter.MaxAdManager:GetServerInfo()
  local isShow = false
  for _, v in pairs(data) do
    if self:IsAdShow(v.id) then
      isShow = true
      break
    end
  end
  return isShow
end

function MaxAdManager:IsAdsComponentCanShow()
  return self.topSwitch and self:IsNeedRequest()
end

function MaxAdManager:IsNeedRequest()
  return false
end

function MaxAdManager:GetPrivilegeItemData()
  if self.privilegeItemId == 0 then
    return
  end
  return {
    count = 1,
    id = tostring(self.privilegeItemId),
    itemId = self.privilegeItemId,
    rewardType = RewardType.GOODS
  }
end

function MaxAdManager:IsAdShow(adId)
  local data = self:GetAdCollectionById(adId)
  if table.count(data.serverData) == 0 then
    return false
  end
  local count = data.template.times - data.serverData.rewardTimes
  return 0 < count
end

local RES_SHOW_TYPE = {
  [ResourceType.Wood] = true,
  [ResourceType.Food] = true,
  [ResourceType.Metal] = true
}

function MaxAdManager:IsResourceAdShow(adId, resType)
  if not RES_SHOW_TYPE[resType] then
    return false
  end
  return self:IsAdShow(adId)
end

function MaxAdManager:IsAdsSupport()
  return CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, self.sdkVersion) >= 0
end

function MaxAdManager:ShowAdsCollectionPanel()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMaxAd, {anim = true})
end

function MaxAdManager:GetServerInfo()
  return self.serverAdsInfo
end

function MaxAdManager:GetAdCollectionTemplateList()
  if self.collectionTemplateList ~= nil then
    return self.collectionTemplateList
  end
  self.collectionTemplateList = {}
  LocalController:instance():visitTable(TableName.LW_ADS_COLLECTION, function(id, lineData)
    local rowData = AdCollectionTemplate.New()
    rowData:InitData(lineData)
    self.collectionTemplateList[tostring(lineData.id)] = rowData
  end)
  return self.collectionTemplateList
end

function MaxAdManager:GetAdCollectionTemplate(id)
  if id == nil then
    return
  end
  local list = self:GetAdCollectionTemplateList()
  local template = list[tostring(id)]
  if template == nil then
    self:Log("GetAdCollectionTemplate Error " .. tostring(id))
  end
  return template
end

function MaxAdManager:GetAdCollection()
  local data = DataCenter.MaxAdManager:GetServerInfo()
  local showAdList = {}
  for k, v in pairs(data) do
    local template = DataCenter.MaxAdManager:GetAdCollectionTemplate(k)
    if template then
      table.insert(showAdList, {template = template, serverData = v})
    end
  end
  return showAdList
end

function MaxAdManager:GetAdCollectionById(id)
  local data = DataCenter.MaxAdManager:GetServerInfo()
  local template = DataCenter.MaxAdManager:GetAdCollectionTemplate(id)
  return {
    template = template or {},
    serverData = data[tostring(id)] or {}
  }
end

function MaxAdManager:IsDebugOpen()
  return GMUtils.GetBool(GMConst.AdDebugMode, false)
end

function MaxAdManager:ShowAdById(id)
  local template = self:GetAdCollectionTemplate(id)
  if template == nil then
    Logger.LogError("[\230\137\190\228\184\141\229\136\176\233\133\141\231\189\174]" .. id)
    return
  end
  local adUnitId = template:GetAdUnitId()
  if adUnitId == nil then
    Logger.LogError("[adUnitId\230\178\161\230\139\191\229\136\176]" .. id)
    return
  end
  if not self:HasPrivilege() then
    self:ShowAd(adUnitId, id)
  else
    local isAll = UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIMaxAd)
    self:GetAdsReward(tonumber(id), isAll)
  end
  PostEventLog.Track(PostEventLog.Defines.ADIconClick, {af_content_id = id})
end

function MaxAdManager:HasPrivilege()
  if not self:IsFirstPayConfigOpen() then
    return false
  end
  return self.hasPrivilege
end

function MaxAdManager:IsFirstPayConfigOpen()
  local packageData, rechargeId = DataCenter.FirstPayManager:GetFirstPayPack()
  if packageData == nil then
    return false
  end
  if string.IsNullOrEmpty(self.privilegePackageId) then
    return false
  end
  return self.privilegePackageId ~= "0"
end

function MaxAdManager:ShowReward(message)
  if message.rewards ~= nil then
    local list = {}
    list = DataCenter.RewardManager:ReturnRewardParamForMessage(message.rewards) or {}
    table.sort(list, function(a, b)
      if a.rewardType ~= b.rewardType then
        return a.rewardType == RewardType.HERO and true or false
      else
        return a.sortOrder < b.sortOrder
      end
    end)
    local golloesList = DataCenter.RewardManager:GetGolloesRewards(message)
    for i, v in ipairs(golloesList) do
      table.insert(list, v)
    end
    local param = {}
    param.rewardList = list
    param.title = Localization:GetString("128027")
    param.collectAdNum = message.rewardNum or 0
    DataCenter.RewardManager:SetParam(param)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetReward, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackageOnlyRewardAd, {
      anim = true,
      playEffect = false,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, param)
  end
end

function MaxAdManager:CheckAdState(adUnitId)
  if not self:IsAdsSupport() then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.lastCheckReadyTime ~= nil and curTime - self.lastCheckReadyTime < self.showAdFailCd * 1000 then
    return
  end
  self.lastCheckReadyState = self:IsAdReady(adUnitId)
  if self.lastCheckReadyState ~= true then
    self:LoadAd(adUnitId)
    self.lastCheckReadyTime = UITimeManager:GetInstance():GetServerTime()
  end
end

function MaxAdManager:GetCheckAdReadyTime()
  if self.lastCheckReadyTime == nil then
    return 0
  end
  return self.showAdFailCd * 1000 - (UITimeManager:GetInstance():GetServerTime() - self.lastCheckReadyTime)
end

function MaxAdManager:GetCheckAdReadyState()
  return self.lastCheckReadyState
end

function MaxAdManager:IsVisitorShow()
  if self.lastVisitorTime == nil then
    self.lastVisitorTime = CommonUtil.PlayerPrefsGetLong(REMINDER_VISITOR_SHOW_TIME_KEY, 0)
  end
  local lastShowTime = self.lastVisitorTime
  if lastShowTime == 0 then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = curTime - lastShowTime
  if diff < self.visitorShowTime * 1000 then
    return true
  elseif diff >= self.visitorShowTime * 1000 and diff < self.visitorRefreshCd * 1000 then
    return false
  else
    return true
  end
end

function MaxAdManager:GetVisitor()
  if self.visitor ~= nil then
    return self.visitor
  end
  if self.lastVisitorTime == nil then
    self.lastVisitorTime = CommonUtil.PlayerPrefsGetLong(REMINDER_VISITOR_SHOW_TIME_KEY, 0)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastVisitorTime > self.visitorRefreshCd * 1000 or curTime < self.lastVisitorTime then
    self:UpdateVisitorTime()
  end
  local visitor = DataCenter.CityVisitorManager.CreateClientVisitor(VISITOR_EVENT_ID)
  visitor.startTime = self.lastVisitorTime
  self.visitor = visitor
  return visitor
end

function MaxAdManager:OnCheckVisitorState()
  local isAdUnlock = DataCenter.MaxAdManager:IsAdsUnlock()
  local isVisitorShow = DataCenter.MaxAdManager:IsVisitorShow()
  local visitor = self:GetVisitor()
  local hasVisitor = DataCenter.CityVisitorManager.GetVisitorByEventId(visitor.eventId, visitor.type)
  local createVisitor = not hasVisitor and isAdUnlock and isVisitorShow
  if createVisitor then
    self:ShowVisitor(visitor)
  end
  local removeVisitor = hasVisitor and (not isAdUnlock or not isVisitorShow)
  if removeVisitor then
    self:FinishVisitor(visitor.uid)
  end
end

function MaxAdManager:IsVisitorFinish()
  if self.lastVisitorTime == nil then
    self.lastVisitorTime = CommonUtil.PlayerPrefsGetLong(REMINDER_VISITOR_SHOW_TIME_KEY, 0)
  end
  local lastShowTime = self.lastVisitorTime
  if lastShowTime == 0 then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - lastShowTime < self.visitorShowTime * 1000 then
    return false
  end
  return true
end

function MaxAdManager:UpdateVisitorTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  CommonUtil.PlayerPrefsSetLong(REMINDER_VISITOR_SHOW_TIME_KEY, curTime)
  self.lastVisitorTime = curTime
end

function MaxAdManager:ShowVisitor(visitor)
  DataCenter.CityVisitorManager:AddVisitor(visitor, false)
  if self.visitorFinishTimer ~= nil then
    self.visitorFinishTimer:Stop()
    self.visitorFinishTimer = nil
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local delay = self.visitorShowTime - (curTime - visitor.startTime) / 1000
  self:Log(delay .. " s\229\144\142\229\185\184\229\173\152\232\128\133\230\182\136\229\164\177")
  self.visitorFinishTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:FinishVisitor(visitor.uid)
  end, delay)
end

function MaxAdManager:FinishVisitor(uid)
  DataCenter.CityVisitorManager:FinishVisitorByUid(uid)
end

return MaxAdManager
