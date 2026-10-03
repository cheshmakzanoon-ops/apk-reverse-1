local ActivityVisitorManager = BaseClass("ActivityVisitorManager", Singleton)
local ActivityVisitorData = require("Scene.CityVisitor.ActivityVisitorData")

local function AddListeners(self)
  function self.genVisitorFunc()
    self:CheckGenActivityVisitor()
  end
  
  function self.removeAndGenCheckFunc()
    self:RemoveReceivedRewardAndExpiredVisitor()
    self:CheckGenActivityVisitor()
  end
  
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.genVisitorFunc)
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.genVisitorFunc)
  EventManager:GetInstance():AddListener(EventId.ActivityVisitorDataUpdate, self.removeAndGenCheckFunc)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.genVisitorFunc)
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.genVisitorFunc)
  EventManager:GetInstance():RemoveListener(EventId.ActivityVisitorDataUpdate, self.removeAndGenCheckFunc)
end

local function __init(self)
  AddListeners(self)
  self.allActivityVisitorDataDic = {}
end

local function __delete(self)
  RemoveListener(self)
  self.allActivityVisitorDataDic = nil
end

function ActivityVisitorManager:InitMsg(message)
  self:UpdateData(message)
end

function ActivityVisitorManager:UpdateData(message)
  if not message.activityVisitor then
    return
  end
  for k, v in pairs(message.activityVisitor) do
    local activityId = k
    local fakeVisitorData
    local fakeUuid = self:GetFakeUuid(activityId, v.eventId)
    if not table.containsKey(self.allActivityVisitorDataDic, fakeUuid) then
      local actVisitorData = ActivityVisitorData.New()
      fakeVisitorData = DataCenter.CityVisitorManager:CreateOneFakeVisitorDataByEventId(v.eventId, fakeUuid)
      fakeVisitorData.actVisitorData = actVisitorData
      self.allActivityVisitorDataDic[fakeUuid] = fakeVisitorData
    else
      fakeVisitorData = self.allActivityVisitorDataDic[fakeUuid]
    end
    if fakeVisitorData.actVisitorData then
      fakeVisitorData.actVisitorData:UpdateData(activityId, v)
    end
  end
end

function ActivityVisitorManager:CheckGenActivityVisitor()
  for _, v in pairs(self.allActivityVisitorDataDic) do
    local fakeVisitorData = v
    if fakeVisitorData then
      local activityVisitorData = fakeVisitorData.actVisitorData
      if not activityVisitorData:IsExpired() then
        DataCenter.CityVisitorManager:AddVisitor(fakeVisitorData, nil, 1)
        if SceneUtils.GetIsInCity() then
          DataCenter.CityVisitorManager:ReGenVisitors()
        end
      end
    end
  end
end

function ActivityVisitorManager:GetActivityVisitorDataByUid(uid)
  if not table.containsKey(self.allActivityVisitorDataDic, uid) then
    return nil
  end
  return self.allActivityVisitorDataDic[uid]
end

function ActivityVisitorManager:GetFakeUuid(activityId, eventId)
  return string.format("activity_%s_%s_fake", activityId, eventId)
end

function ActivityVisitorManager:SetActivityVisitorReceivedState(activityId, nextResetTime)
  local activityVisitorData = self:GetVisitorDataByActivityId(activityId)
  if not activityVisitorData or not activityVisitorData.actVisitorData then
    return
  end
  activityVisitorData.actVisitorData:UpdateDataOnReceiveReward(nextResetTime)
  self:RemoveReceivedRewardAndExpiredVisitor()
end

function ActivityVisitorManager:GetVisitorDataByActivityId(activityId)
  local ret
  for _, v in pairs(self.allActivityVisitorDataDic) do
    if v and v.actVisitorData and toInt(v.actVisitorData.activityId) == activityId then
      ret = v
      break
    end
  end
  return ret
end

function ActivityVisitorManager:RemoveReceivedRewardAndExpiredVisitor()
  for _, v in pairs(self.allActivityVisitorDataDic) do
    if v and v.actVisitorData:IsExpired() then
      local uid = v.uid
      local type = v.type
      local operate = 1
      DataCenter.CityVisitorManager:PlayVisitorFinishAni(uid, type, operate)
    end
  end
end

ActivityVisitorManager.__init = __init
ActivityVisitorManager.__delete = __delete
return ActivityVisitorManager
