local VisitorFreshMessage = BaseClass("VisitorFreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.addVisitor then
    DataCenter.CityVisitorManager:AddVisitor(t.addVisitor)
  end
end

local function CreateClientVisitor(eventId, uuid)
  local Const = require("Scene.CityVisitor.Const")
  local startTime = UITimeManager:GetInstance():GetServerTime()
  return {
    uid = uuid and uuid or eventId + 100000000,
    eventId = eventId,
    startTime = startTime,
    visitorId = eventId + 100000000,
    type = Const.VisitorType.GEN_BY_TIME
  }
end

function VisitorFreshMessage:GetTestData()
  local t = {}
  t.addVisitor = CreateClientVisitor(math.random(20701, 20749))
  return t
end

VisitorFreshMessage.OnCreate = OnCreate
VisitorFreshMessage.HandleMessage = HandleMessage
return VisitorFreshMessage
