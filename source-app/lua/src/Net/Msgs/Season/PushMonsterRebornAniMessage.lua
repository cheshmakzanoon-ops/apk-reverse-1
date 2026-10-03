local PushMonsterRebornAniMessage = BaseClass("PushMonsterRebornAniMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonsterRebornAniMessage:OnCreate()
  base.OnCreate(self)
end

function PushMonsterRebornAniMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode == nil and t.uuid then
    if t.strongholdBoss then
      DataCenter.SeasonDataManager:UpdateMonsterDetail(t.uuid, t.strongholdBoss)
    else
      DataCenter.SeasonDataManager:UpdateMonsterRebornAni(t.uuid)
    end
  end
end

return PushMonsterRebornAniMessage
