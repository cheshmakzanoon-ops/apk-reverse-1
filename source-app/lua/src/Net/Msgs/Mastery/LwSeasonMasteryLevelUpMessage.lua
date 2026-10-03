local LwSeasonMasteryLevelUpMessage = BaseClass("LwSeasonMasteryLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, mastery_id)
  base.OnCreate(self)
  self.sfsObj:PutInt("mastery_id", mastery_id)
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

LwSeasonMasteryLevelUpMessage.OnCreate = OnCreate
LwSeasonMasteryLevelUpMessage.HandleMessage = HandleMessage
return LwSeasonMasteryLevelUpMessage
