local EasterEggPickUpMessage = BaseClass("EasterEggPickUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggPickUpMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function EasterEggPickUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  DataCenter.ActEasterEggManager:OnRecPickUpEgg(t)
end

return EasterEggPickUpMessage
