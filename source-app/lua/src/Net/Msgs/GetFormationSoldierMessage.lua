local GetFormationSoldierMessage = BaseClass("GetFormationSoldierMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArmyFormationDataManager:RefreshFormationSoldier(t)
  end
end

GetFormationSoldierMessage.OnCreate = OnCreate
GetFormationSoldierMessage.HandleMessage = HandleMessage
return GetFormationSoldierMessage
