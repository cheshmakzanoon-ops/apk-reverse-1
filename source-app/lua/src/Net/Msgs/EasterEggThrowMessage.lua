local EasterEggThrowMessage = BaseClass("EasterEggThrowMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggThrowMessage:OnCreate(activityId, type, context, optionA, optionB)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("type", type)
  self.sfsObj:PutUtfString("context", context)
  self.sfsObj:PutUtfString("optionA", optionA)
  self.sfsObj:PutUtfString("optionB", optionB)
end

function EasterEggThrowMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ActEasterEggManager:OnRecThrow(t)
end

return EasterEggThrowMessage
