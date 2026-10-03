local ThemeActivityManager = BaseClass("ThemeActivityManager")

local function __init(self)
  self.themeActivityInfoDic = {}
  self.noticeRewardInfoDic = {}
  self.oldActivitiesDic = {}
  self.isNoticeInfoReady = false
  self.isActInfoReady = false
  self:AddListener()
end

local function __delete(self)
  self.themeActivityInfoDic = nil
  self.noticeRewardInfoDic = nil
  self.oldActivitiesDic = {}
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function UpdateOneThemeActivity(self, data)
  if not self.themeActivityInfoDic then
    self.themeActivityInfoDic = {}
  end
  self.themeActivityInfoDic[data.type] = data
  self:InitOldActivities(data.type)
  self:TryReqNoticeInfo(data)
  self.isActInfoReady = true
  EventManager:GetInstance():Broadcast(EventId.UpdateOneThemeActivity)
end

local function TryReqNoticeInfo(self, data)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < data.startTime then
    self:RequestActivityNoticeInfo(data.id)
  end
end

local function UpdateNoticeRewardInfo(self, t)
  if t.activityId then
    local activityId = tostring(t.activityId)
    local rewardInfoDic = {}
    if t.stageArr then
      for i, v in ipairs(t.stageArr) do
        local rewardInfo = {}
        rewardInfo.day = v.day
        rewardInfo.reward = v.reward
        rewardInfo.state = v.state
        rewardInfoDic[rewardInfo.day] = rewardInfo
      end
    end
    self.noticeRewardInfoDic[activityId] = rewardInfoDic
    self.isNoticeInfoReady = true
    EventManager:GetInstance():Broadcast(EventId.UpdateThemeActNoticeRewardInfo, activityId)
  end
end

local function GetNoticeRewardInfo(self, activityId)
  local rewardInfo = self.noticeRewardInfoDic[activityId] or {}
  return rewardInfo, self.isNoticeInfoReady
end

local function GetThemeActivityInfo(self, type)
  return self.themeActivityInfoDic and self.themeActivityInfoDic[type] or nil
end

local function CheckIfShowEntrance(self, type)
  if not self.themeActivityInfoDic or not self.themeActivityInfoDic[type] then
    return false
  end
  local activityInfo = self.themeActivityInfoDic[type]
  if activityInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
    return false
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if activityInfo.noticeStartTime and activityInfo.noticeStartTime > 0 and serverTime >= activityInfo.noticeStartTime and serverTime < activityInfo.startTime then
    return true, 0
  end
  if serverTime >= activityInfo.startTime and serverTime < activityInfo.endTime then
    return true, 1
  end
  return false
end

local function GetThemeActivityRedCount(self, type)
  local redCount = 0
  local isShow, isOpen = self:CheckIfShowEntrance(type)
  if isShow then
    local activityInfo = self.themeActivityInfoDic[type]
    local pveActId = ActivitySummaryPveActId
    if isOpen == 0 then
      if self.isNoticeInfoReady then
        local serverTime = UITimeManager:GetInstance():GetServerTime()
        local noticeInfo = self:GetNoticeRewardInfo(activityInfo.id)
        local noticePassDays = math.ceil((serverTime - activityInfo.noticeStartTime) / (OneDayTime * 1000))
        for i = 1, ThemeActivityNoticeDays do
          if i <= noticePassDays and (not noticeInfo[i] or noticeInfo[i].state == 0) then
            redCount = redCount + 1
          end
        end
      end
    else
      local strSubAct = activityInfo.para1
      local subList = string.split(strSubAct, ";")
      local serverTime = UITimeManager:GetInstance():GetServerTime()
      for i, v in ipairs(subList) do
        local subActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(v)
        if subActInfo and serverTime >= subActInfo.startTime and serverTime < subActInfo.endTime then
          if DataCenter.ActivityListDataManager:IsActivityNew(v) then
            redCount = redCount + 1
          end
          local moduleRed = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(subActInfo.type, subActInfo.id)
          redCount = redCount + moduleRed
        end
      end
      if self:CheckIfPackageIsNew(activityInfo) then
        redCount = redCount + 1
      end
      pveActId = 7 <= #subList and tonumber(subList[7]) or pveActId
    end
    local pveActRed = DataCenter.PveActManager:GetRedCount(pveActId)
    if 0 < pveActRed then
      redCount = redCount + pveActRed
    end
  end
  return redCount
end

local function OnRecvNoticeReward(self, t)
  local activityId = tostring(t.activityId)
  local day = t.day
  local tempInfo = self.noticeRewardInfoDic[activityId]
  if tempInfo and tempInfo[day] then
    tempInfo[day].state = 1
  else
    local newInfo = {}
    newInfo.day = day
    newInfo.state = 1
    tempInfo[day] = newInfo
  end
  DataCenter.RewardManager:ShowCommonReward(t)
  DataCenter.RewardManager:AddRewardsAndRes(t)
  EventManager:GetInstance():Broadcast(EventId.UpdateThemeActNoticeRewardInfo, activityId)
end

local function InitOldActivities(self, type)
  local actList = self:GetOldSubThemeActivities(type)
  self.oldActivitiesDic[type] = actList
end

local function SetAsOldActivity(self, mainType, subId)
  subId = tostring(subId)
  local oldList = self.oldActivitiesDic[mainType]
  if not table.hasvalue(oldList, subId) then
    table.insert(oldList, subId)
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function CheckIfIsOldActivity(self, type, subId)
  subId = tostring(subId)
  if self.oldActivitiesDic[type] then
    return table.hasvalue(self.oldActivitiesDic[type], subId)
  end
  return false
end

local function SetAllSubActivityOld(self, type)
  local strOld = ""
  local oldList = {}
  local strK = LuaEntry.Player.uid .. "_OldThemeAct" .. type
  local activityInfo = self.themeActivityInfoDic[type]
  if activityInfo then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    local actIdList = string.split(activityInfo.para1, ";")
    for i, v in ipairs(actIdList) do
      local subInfo = DataCenter.ActivityListDataManager:GetActivityDataById(v)
      if subInfo then
        if serverTime >= subInfo.startTime then
          table.insert(oldList, subInfo.id)
          if string.IsNullOrEmpty(strOld) then
            strOld = subInfo.id
          else
            strOld = strOld .. ";" .. subInfo.id
          end
        end
      else
        strOld = strOld .. ";" .. v
        table.insert(oldList, v)
      end
    end
  end
  self.oldActivitiesDic[type] = oldList
  CS.GameEntry.Setting:SetString(strK, strOld)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

local function GetOldSubThemeActivities(self, type)
  local strK = LuaEntry.Player.uid .. "_OldThemeAct" .. type
  local strOld = CS.GameEntry.Setting:GetString(strK, "")
  local oldList = {}
  if not string.IsNullOrEmpty(strOld) then
    oldList = string.split(strOld, ";")
  end
  return oldList
end

local function CheckIfPackageIsNew(self, actInfo)
  local strK = LuaEntry.Player.uid .. "_ActSummaryPackage_" .. actInfo.id
  local cacheEndT = CS.GameEntry.Setting:GetString(strK, "0")
  local numEndT = tonumber(cacheEndT)
  return numEndT ~= actInfo.endTime
end

local function SetPackageOld(self, actInfo)
  local strK = LuaEntry.Player.uid .. "_ActSummaryPackage_" .. actInfo.id
  CS.GameEntry.Setting:SetString(strK, actInfo.endTime)
end

local function RequestActivityNoticeInfo(self, activityId)
  SFSNetwork.SendMessage(MsgDefines.GetThemeActivityInfo, activityId)
end

local function RequestClaimNoticeReward(self, activityId, day)
  if self.isNoticeInfoReady then
    SFSNetwork.SendMessage(MsgDefines.ClaimThemeActNoticeReward, activityId, day)
  end
end

ThemeActivityManager.__init = __init
ThemeActivityManager.__delete = __delete
ThemeActivityManager.AddListener = AddListener
ThemeActivityManager.RemoveListener = RemoveListener
ThemeActivityManager.InitOldActivities = InitOldActivities
ThemeActivityManager.CheckIfShowEntrance = CheckIfShowEntrance
ThemeActivityManager.UpdateOneThemeActivity = UpdateOneThemeActivity
ThemeActivityManager.GetThemeActivityInfo = GetThemeActivityInfo
ThemeActivityManager.GetThemeActivityRedCount = GetThemeActivityRedCount
ThemeActivityManager.UpdateNoticeRewardInfo = UpdateNoticeRewardInfo
ThemeActivityManager.GetNoticeRewardInfo = GetNoticeRewardInfo
ThemeActivityManager.TryReqNoticeInfo = TryReqNoticeInfo
ThemeActivityManager.OnRecvNoticeReward = OnRecvNoticeReward
ThemeActivityManager.SetAsOldActivity = SetAsOldActivity
ThemeActivityManager.CheckIfIsOldActivity = CheckIfIsOldActivity
ThemeActivityManager.SetAllSubActivityOld = SetAllSubActivityOld
ThemeActivityManager.GetOldSubThemeActivities = GetOldSubThemeActivities
ThemeActivityManager.CheckIfPackageIsNew = CheckIfPackageIsNew
ThemeActivityManager.SetPackageOld = SetPackageOld
ThemeActivityManager.RequestActivityNoticeInfo = RequestActivityNoticeInfo
ThemeActivityManager.RequestClaimNoticeReward = RequestClaimNoticeReward
return ThemeActivityManager
