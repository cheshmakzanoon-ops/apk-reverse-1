local EasterOpenWorldEggMessage = BaseClass("EasterOpenWorldEggMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterOpenWorldEggMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("uuid", param.eggUuid)
end

function EasterOpenWorldEggMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:OnRecOpenWorldEgg(t)
  end
end

return EasterOpenWorldEggMessage
