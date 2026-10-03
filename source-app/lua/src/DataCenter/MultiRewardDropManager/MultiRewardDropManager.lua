local MultiRewardDropManager = BaseClass("MultiRewardDropManager")
local MultiRewardInfo = require("DataCenter/MultiRewardDropManager/MultiRewardInfo")

local function __init(self)
  self.allMultiInfoDic = {}
  self.activityMultiDic = {}
  self:AddListener()
end

local function __delete(self)
  self.allMultiInfoDic = nil
  self.activityMultiDic = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function InitMsg(self, message)
  self:UpdateMsg(message)
end

local function UpdateMsg(self, message)
  if message.multipleDrop then
    for activityId, data in pairs(message.multipleDrop) do
      self:UpdateMultiRewardData(activityId, data)
    end
  end
  if self.allMultiInfoDic and table.count(self.allMultiInfoDic) > 0 then
    EventManager:GetInstance():Broadcast(EventId.MultiRewardDataUpdate)
  end
end

function MultiRewardDropManager:UpdateMultiRewardData(activityId, data)
  if type(activityId) ~= "number" then
    activityId = toInt(activityId)
  end
  if not table.containsKey(self.activityMultiDic, activityId) then
    self.activityMultiDic[activityId] = {}
  end
  local timeInfo = {}
  timeInfo.startTime = data.sTime
  timeInfo.enjoyEndTime = data.viewETime
  timeInfo.realEndTime = data.eTime
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime / 1000 > data.eTime then
    return
  end
  if data.multiples then
    for k, v in pairs(data.multiples) do
      local multiConfigId = k
      local multiVal = v
      local uuid = activityId .. multiConfigId
      local multiInfo = self.allMultiInfoDic[uuid]
      if multiInfo then
        self.allMultiInfoDic[uuid]:UpdateData(activityId, multiConfigId, multiVal, timeInfo)
      else
        multiInfo = MultiRewardInfo.New()
        multiInfo:UpdateData(activityId, multiConfigId, multiVal, timeInfo)
        self.allMultiInfoDic[uuid] = multiInfo
      end
      local activityMultiList = self.activityMultiDic[activityId]
      if not table.containsKey(activityMultiList, uuid) then
        activityMultiList[uuid] = multiInfo
      end
    end
  end
end

function MultiRewardDropManager:GetCanEnjoyMaxMultiValue(rewardType, timestamp)
  local data = self:GetAllActivityMaxMultiValueByRewardType(rewardType, timestamp)
  if not data or data:IsExpired(timestamp) then
    return 1
  end
  return data.multiVal
end

function MultiRewardDropManager:GetAllActivityMaxMultiValueByRewardType(rewardType, timestamp)
  local ret
  local allDataList = self:GetAllMultiRewardByRewardType(rewardType)
  for _, v in ipairs(allDataList) do
    if v:IsTargetTimeCanEnjoyMultiReward(timestamp) and (not ret or v.multiVal > ret.multiVal) then
      ret = v
    end
  end
  return ret
end

function MultiRewardDropManager:GetAllMultiRewardByRewardType(rewardType)
  local ret = {}
  for _, v in pairs(self.allMultiInfoDic) do
    if v:GetRewardType() == rewardType then
      table.insert(ret, v)
    end
  end
  return ret
end

function MultiRewardDropManager:GetAllActivityMultiRewardData(activityId)
  if type(activityId) ~= "number" then
    activityId = toInt(activityId)
  end
  local ret = {}
  if not table.containsKey(self.activityMultiDic, activityId) then
    return ret
  end
  local allActDataList = self.activityMultiDic[activityId]
  for _, v in pairs(allActDataList) do
    table.insert(ret, v)
  end
  return ret
end

function MultiRewardDropManager:GetActivityMultiRewardData(activityId, rewardType)
  if type(activityId) ~= "number" then
    activityId = toInt(activityId)
  end
  local ret
  local allActDataList = self.GetAllActivityMultiRewardData(activityId)
  if not allActDataList then
    return ret
  end
  for _, v in pairs(allActDataList) do
    if v.GetRewardType() == rewardType then
      ret = v
    end
  end
  return ret
end

function MultiRewardDropManager:GetActivityMultiRewardValue(activityId, rewardType)
  if type(activityId) ~= "number" then
    activityId = toInt(activityId)
  end
  local data = self:GetActivityMultiRewardData(activityId, rewardType)
  if data then
    return data.multiVal
  end
  return nil
end

function MultiRewardDropManager:CheckIsNeedPop()
  if not self.activityMultiDic then
    return
  end
  for activityId, data in pairs(self.activityMultiDic) do
    local multiRewardSaveKey = string.format("MultiRewardPopRecord_%s", activityId)
    if not CommonUtil.PlayerPrefsGetBool(multiRewardSaveKey) and DataCenter.ActivityListDataManager:IsReadyForDownloadRes(activityId) then
      for _, v in pairs(data) do
        if not v:IsCurExpired() then
          DataCenter.UIPopWindowManager:Push(UIWindowNames.UIMultiRewardPop, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, activityId)
          CommonUtil.PlayerPrefsSetBool(multiRewardSaveKey, 1)
          break
        end
      end
    end
  end
end

MultiRewardDropManager.__init = __init
MultiRewardDropManager.__delete = __delete
MultiRewardDropManager.AddListener = AddListener
MultiRewardDropManager.RemoveListener = RemoveListener
MultiRewardDropManager.InitMsg = InitMsg
MultiRewardDropManager.UpdateMsg = UpdateMsg
return MultiRewardDropManager
