local DigTreasureGiveHammerMessage = BaseClass("DigTreasureGiveHammerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DigTreasureGiveHammerMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("target", tostring(uid))
end

function DigTreasureGiveHammerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local uid = t.target
    if uid then
      EventManager:GetInstance():Broadcast(EventId.DigTreasureHelpSuccess, uid)
    end
  end
end

return DigTreasureGiveHammerMessage
