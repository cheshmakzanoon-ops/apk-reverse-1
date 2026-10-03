local TacticalChipProductMessage = BaseClass("TacticalChipProductMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, buildingUuid, cfgId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", buildingUuid)
  self.sfsObj:PutInt("cfgId", cfgId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(t)
  end
end

TacticalChipProductMessage.OnCreate = OnCreate
TacticalChipProductMessage.HandleMessage = HandleMessage
return TacticalChipProductMessage
