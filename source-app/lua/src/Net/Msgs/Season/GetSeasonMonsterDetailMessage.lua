local GetSeasonMonsterDetailMessage = BaseClass("GetSeasonMonsterDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetSeasonMonsterDetailMessage:OnCreate(monsterUuid, serverId)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", monsterUuid)
  self.sfsObj:PutLong("serverId", serverId)
end

function GetSeasonMonsterDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.strongholdMonster then
    DataCenter.SeasonDataManager:UpdateMonsterDetail(t.strongholdMonster.uuid, t.strongholdMonster)
  end
  if t.strongholdBoss then
    DataCenter.SeasonDataManager:UpdateMonsterDetail(t.strongholdBoss.uuid, t.strongholdBoss)
  end
  if t.ghostKing then
    DataCenter.SeasonDataManager:UpdateMonsterDetail(t.ghostKing.uuid, t.ghostKing)
  end
end

return GetSeasonMonsterDetailMessage
