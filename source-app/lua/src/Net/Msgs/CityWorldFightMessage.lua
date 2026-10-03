local CityWorldFightMessage = BaseClass("CityWorldFightMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("targetUuid", param.targetUuid)
    self.sfsObj:PutLong("formationUuid", param.formationUuid)
    if param.formationParam ~= nil then
      self.sfsObj:PutSFSObject("formationParam", param.formationParam)
    end
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.GuideCityManager:CityWorldFightHandle(t)
end

CityWorldFightMessage.OnCreate = OnCreate
CityWorldFightMessage.HandleMessage = HandleMessage
return CityWorldFightMessage
