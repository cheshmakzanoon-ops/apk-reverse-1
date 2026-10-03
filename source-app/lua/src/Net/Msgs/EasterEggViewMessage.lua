local EasterEggViewMessage = BaseClass("EasterEggViewMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggViewMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("eggUuid", param.eggUuid)
end

function EasterEggViewMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecViewEgg(t)
  end
end

return EasterEggViewMessage
