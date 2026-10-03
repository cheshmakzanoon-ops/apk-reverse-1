local LwSeasonMasteryHomeChangeMessage = BaseClass("LwSeasonMasteryHomeChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, home_id, importTemp)
  base.OnCreate(self)
  self.sfsObj:PutInt("homeId", home_id)
  self.sfsObj:PutInt("importTemp", importTemp)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.importTempRes ~= nil and next(t.importTempRes) then
    UIUtil.ShowTipsId("season_switch_info10")
  else
    UIUtil.ShowTipsId("season_switch_info09")
  end
  DataCenter.MasteryManager:GetDataInfoMsgHandle(t)
  EventManager:GetInstance():Broadcast(EventId.LWMasteryChangeMsgGet)
end

LwSeasonMasteryHomeChangeMessage.OnCreate = OnCreate
LwSeasonMasteryHomeChangeMessage.HandleMessage = HandleMessage
return LwSeasonMasteryHomeChangeMessage
