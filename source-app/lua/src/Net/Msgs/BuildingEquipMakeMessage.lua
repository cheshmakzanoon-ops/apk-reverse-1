local BuildingEquipMakeMessage = BaseClass("BuildingEquipMakeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, buildingUuid, equipCfgId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", buildingUuid)
  self.sfsObj:PutInt("equipCfgId", equipCfgId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleProduceBuildingUpgrade(message)
  end
end

BuildingEquipMakeMessage.OnCreate = OnCreate
BuildingEquipMakeMessage.HandleMessage = HandleMessage
return BuildingEquipMakeMessage
