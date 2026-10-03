local AllianceDeclareWarCancelMessage = BaseClass("AllianceDeclareWarCancelMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("serverid", serverId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceDeclareWarManager:DeleteWar(t)
    UIUtil.ShowTipsId("new_city_activity_battle_tips1035")
  end
end

AllianceDeclareWarCancelMessage.OnCreate = OnCreate
AllianceDeclareWarCancelMessage.HandleMessage = HandleMessage
return AllianceDeclareWarCancelMessage
