local LwSeasonMasteryResetMessage = BaseClass("LwSeasonMasteryResetMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.MasteryManager:GetDataInfoMsgHandle(t)
  EventManager:GetInstance():Broadcast(EventId.LWMasterySkillUp)
end

LwSeasonMasteryResetMessage.OnCreate = OnCreate
LwSeasonMasteryResetMessage.HandleMessage = HandleMessage
return LwSeasonMasteryResetMessage
