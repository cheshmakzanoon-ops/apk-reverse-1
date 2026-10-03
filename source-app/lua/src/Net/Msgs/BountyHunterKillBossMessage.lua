local BountyHunterKillBossMessage = BaseClass("BountyHunterKillBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BountyHunterKillBossMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function BountyHunterKillBossMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
  end
end

return BountyHunterKillBossMessage
