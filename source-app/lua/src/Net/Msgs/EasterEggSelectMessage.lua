local EasterEggSelectMessage = BaseClass("EasterEggSelectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function EasterEggSelectMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", param.activityId)
  self.sfsObj:PutUtfString("eggUuid", param.eggUuid)
  self.sfsObj:PutInt("answer", param.answer)
end

function EasterEggSelectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActEasterEggManager:UpdateVoteInfo(t)
  end
end

return EasterEggSelectMessage
