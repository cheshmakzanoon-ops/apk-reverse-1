local Arena3V3RevengeGiveUpMessage = BaseClass("Arena3V3RevengeGiveUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function Arena3V3RevengeGiveUpMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", uid)
end

function Arena3V3RevengeGiveUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LW3V3ArenaManager:OnRevengeGiveUp(t)
  end
end

return Arena3V3RevengeGiveUpMessage
