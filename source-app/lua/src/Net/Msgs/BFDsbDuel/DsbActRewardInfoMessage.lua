local DsbActRewardInfoMessage = BaseClass("DsbActRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DsbActRewardInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function DsbActRewardInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    BattlefieldDsbDuelUtils.ActInfo:OnGetActRewardInfoMsg(t)
  end
end

return DsbActRewardInfoMessage
