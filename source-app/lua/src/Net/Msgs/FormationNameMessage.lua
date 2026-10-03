local FormationNameMessage = BaseClass("FormationNameMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, name)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutUtfString("name", name)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
  end
end

FormationNameMessage.OnCreate = OnCreate
FormationNameMessage.HandleMessage = HandleMessage
return FormationNameMessage
