local WorldPointWaitOpenManager = BaseClass("WorldPointWaitOpenManager")
local WaitTime = 10000

local function __init(self)
  self.isHaveListener = false
  self.pointId = nil
  self.type = nil
  self.uuid = nil
  self.waitEndTime = 0
  self.byDetect = nil
end

local function __delete(self)
  if self.isHaveListener == true then
    self.isHaveListener = false
    EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
  self.isHaveListener = nil
  self.pointId = nil
  self.type = nil
  self.uuid = nil
  self.waitEndTime = nil
  self.byDetect = nil
end

local function SetWaitOpenPointData(self, pointId, type, uuid)
  self.pointId = pointId
  self.type = type
  self.uuid = uuid
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.waitEndTime = curTime + WaitTime
  if self.isHaveListener == false then
    self.isHaveListener = true
    EventManager:GetInstance():AddListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():AddListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
end

local function TryOpenPoint()
  local self = DataCenter.WorldPointWaitOpenManager
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.waitEndTime and self.isHaveListener == true then
    self.isHaveListener = false
    EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
  local pointId = self.pointId
  local type = self.type
  local uuid = self.uuid
  local info, marchInfo
  if type == "DoPlayerAssistance" then
    info = CS.SceneManager.World:GetPointInfo(pointId)
    if info ~= nil then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY, pointId, info.uuid)
    end
  else
    if pointId ~= nil then
      info = CS.SceneManager.World:GetPointInfo(pointId)
      if info ~= nil then
        UIUtil.OnClickWorld(pointId, type)
      end
    end
    if info == nil and uuid ~= nil then
      marchInfo = CS.SceneManager.World:GetMarch(uuid)
      if marchInfo ~= nil then
        UIUtil.OnClickWorldTroop(uuid)
      end
    end
  end
  if (info ~= nil or marchInfo ~= nil) and self.isHaveListener == true then
    self.isHaveListener = false
    EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
end

WorldPointWaitOpenManager.__init = __init
WorldPointWaitOpenManager.__delete = __delete
WorldPointWaitOpenManager.SetWaitOpenPointData = SetWaitOpenPointData
WorldPointWaitOpenManager.TryOpenPoint = TryOpenPoint
return WorldPointWaitOpenManager
