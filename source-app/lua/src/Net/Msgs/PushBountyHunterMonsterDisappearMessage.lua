local PushBountyHunterMonsterDisappearMessage = BaseClass("PushBountyHunterMonsterDisappearMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBountyHunterMonsterDisappearMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushBountyHunterMonsterDisappearMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return PushBountyHunterMonsterDisappearMessage
