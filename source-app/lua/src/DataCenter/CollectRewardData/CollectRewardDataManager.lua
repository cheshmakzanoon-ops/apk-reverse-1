local CollectRewardDataManager = BaseClass("CollectRewardDataManager", CEventable)
local CollectRewardData = require("DataCenter.CollectRewardData.CollectRewardData")
local Localization = CS.GameEntry.Localization

local function Startup(self)
end

local function __init(self)
  self.collectRewardList = {}
  self.pvpPlunderLoadValue = 0
  self.collectLimitLevel = CollectLimitLevel.None
  self:AddListener()
end

local function __delete(self)
  self.collectRewardList = nil
  self.pvpPlunderLoadValue = nil
  self.collectLimitLevel = nil
end

local function AddListener(self)
  self:RegisterEvent(EventId.OnUnDelayPassDay, self.OnPassDay)
end

local function OnPassDay(self)
  self:ResetNowCollectLimitLevel(0)
end

local function ResetNowCollectLimitLevel(self, pvpPlunderLoadValue)
  self.pvpPlunderLoadValue = pvpPlunderLoadValue
  local collectLimitLevel = self:GetCollectLimitLevel(pvpPlunderLoadValue)
  if collectLimitLevel ~= self.collectLimitLevel then
    self.collectLimitLevel = collectLimitLevel
    EventManager:GetInstance():Broadcast(EventId.SelfCollectLimitLevelChange)
  end
end

local function GetNowCollectLimitBuffData(self)
  local buffData, status_id
  local rate = 0
  if self.collectLimitLevel == CollectLimitLevel.Red then
    status_id = "502002"
    local mainLv = DataCenter.BuildManager.MainLv
    local roleTemplate = DataCenter.RoleTemplateManager:GetTemplateByLevel(mainLv)
    rate = toInt(roleTemplate.rate3 * 100)
  elseif self.collectLimitLevel == CollectLimitLevel.Yellow then
    status_id = "502001"
    local mainLv = DataCenter.BuildManager.MainLv
    local roleTemplate = DataCenter.RoleTemplateManager:GetTemplateByLevel(mainLv)
    rate = toInt(roleTemplate.rate2 * 100)
  end
  if status_id then
    local statusLineData = DataCenter.StatusManager:GetTemplate(status_id)
    if statusLineData ~= nil then
      buffData = {}
      buffData.id = tonumber(status_id)
      buffData.name = Localization:GetString(statusLineData.name)
      buffData.icon = statusLineData.icon
      buffData.desc = Localization:GetString(statusLineData.description, string.GetFormattedStr2(self.pvpPlunderLoadValue), rate)
      buffData.endTime = UITimeManager:GetInstance():GetNextDayMs()
      buffData.totalTime = OneDayTime * 1000
    end
  end
  return buffData
end

local function UpdateCollectRewardList(self, message)
  if message == nil then
    return
  end
  if message.collect_reward ~= nil then
    self.collectRewardList = {}
    local arr = message.collect_reward
    table.walk(arr, function(k, v)
      local oneData = CollectRewardData.New()
      oneData:ParseData(v)
      if oneData.uuid ~= 0 then
        self.collectRewardList[oneData.uuid] = oneData
      end
    end)
  end
  if message.pvpPlunderLoadValue ~= nil then
    self:ResetNowCollectLimitLevel(message.pvpPlunderLoadValue)
  end
end

local function UpdateOneReward(self, message)
  local oneData = CollectRewardData.New()
  oneData:ParseData(message)
  if oneData.uuid ~= 0 then
    self.collectRewardList[oneData.uuid] = oneData
  end
  if CS.SceneManager.World ~= nil and oneData.type == CollectRewardType.ICE_SUPPLIES then
    EventManager:GetInstance():Broadcast(EventId.MonsterRewardCreate, oneData.pointId)
  end
  if oneData.type == CollectRewardType.PLUNDER and oneData.plunderValue then
    self:ResetNowCollectLimitLevel(oneData.plunderValue)
  end
  if oneData.type == CollectRewardType.DISCOVER_SUPPLIES or oneData.type == CollectRewardType.DISCOVER_MARCH_SUPPLIES then
    EventManager:GetInstance():Broadcast(EventId.DiscoverSuppliesInfo, oneData)
  end
  EventManager:GetInstance():Broadcast(EventId.CollectRewardDataUpdate, oneData)
end

local function RemoveOneReward(self, uuid)
  if self.collectRewardList[uuid] ~= nil then
    self.collectRewardList[uuid] = nil
  end
end

local function GetRewardDataByUuid(self, uuid)
  return self.collectRewardList[uuid]
end

local function GetRewardListBySort(self)
  local showList = {}
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  table.walksort(self.collectRewardList, function(leftKey, rightKey)
    local aData = self.collectRewardList[leftKey]
    local bData = self.collectRewardList[rightKey]
    if aData ~= nil and bData ~= nil then
      if aData.type ~= bData.type and (CollectRewardSort[aData.type] or CollectRewardSort[bData.type]) then
        return aData.type > bData.type
      end
      if aData.expireTime ~= bData.expireTime then
        return aData.expireTime > bData.expireTime
      end
      return aData.uuid > bData.uuid
    end
    return false
  end, function(a, b)
    if b.expireTime > serverTime then
      table.insert(showList, b)
    end
  end)
  return showList
end

local function GetCollectLimitLevel(self, plunder_resource_now)
  local level = CollectLimitLevel.None
  if plunder_resource_now == nil or plunder_resource_now == 0 then
    return level
  end
  local mainLv = DataCenter.BuildManager.MainLv
  local roleTemplate = DataCenter.RoleTemplateManager:GetTemplateByLevel(mainLv)
  local plunder_resource_max = 0
  local plunder_resource_max2 = 0
  if roleTemplate ~= nil and roleTemplate.plunder_resource_max and roleTemplate.plunder_resource_max2 then
    local effectValue = LuaEntry.Effect:GetGameEffect(94028)
    if effectValue ~= nil and effectValue ~= 0 then
      plunder_resource_max = roleTemplate.plunder_resource_max * (1 + effectValue)
      plunder_resource_max2 = roleTemplate.plunder_resource_max2 * (1 + effectValue)
    else
      plunder_resource_max = roleTemplate.plunder_resource_max
      plunder_resource_max2 = roleTemplate.plunder_resource_max2
    end
  end
  if roleTemplate ~= nil and plunder_resource_max ~= 0 and plunder_resource_max2 ~= 0 and plunder_resource_now >= plunder_resource_max then
    if plunder_resource_now >= plunder_resource_max2 then
      level = CollectLimitLevel.Red
    elseif plunder_resource_now >= plunder_resource_max then
      level = CollectLimitLevel.Yellow
    end
  end
  return level
end

CollectRewardDataManager.__init = __init
CollectRewardDataManager.__delete = __delete
CollectRewardDataManager.Startup = Startup
CollectRewardDataManager.UpdateCollectRewardList = UpdateCollectRewardList
CollectRewardDataManager.UpdateOneReward = UpdateOneReward
CollectRewardDataManager.RemoveOneReward = RemoveOneReward
CollectRewardDataManager.GetRewardDataByUuid = GetRewardDataByUuid
CollectRewardDataManager.GetRewardListBySort = GetRewardListBySort
CollectRewardDataManager.GetCollectLimitLevel = GetCollectLimitLevel
CollectRewardDataManager.AddListener = AddListener
CollectRewardDataManager.OnPassDay = OnPassDay
CollectRewardDataManager.ResetNowCollectLimitLevel = ResetNowCollectLimitLevel
CollectRewardDataManager.GetNowCollectLimitBuffData = GetNowCollectLimitBuffData
return CollectRewardDataManager
