local SurprisePointDetailMessage = BaseClass("SurprisePointDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, pointId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId or 0)
  self.sfsObj:PutLong("worldId", uuid or 0)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SurprisePointManager:OnSurprisePointDetail(t)
end

local function GetTestData(self)
  local t = {}
  return t
end

SurprisePointDetailMessage.GetTestData = GetTestData
SurprisePointDetailMessage.OnCreate = OnCreate
SurprisePointDetailMessage.HandleMessage = HandleMessage
return SurprisePointDetailMessage
