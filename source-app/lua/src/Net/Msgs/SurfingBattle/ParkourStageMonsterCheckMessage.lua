local ParkourStageMonsterCheckMessage = BaseClass("ParkourStageMonsterCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourStageMonsterCheckMessage:OnCreate(distance, totalRunTime, totalStopTime, monsterBorn, monsterId, realMonsterId, uuid)
  base.OnCreate(self)
  self.sfsObj:PutDouble("distance", distance)
  self.sfsObj:PutDouble("totalRunTime", totalRunTime)
  self.sfsObj:PutDouble("totalStopTime", totalStopTime)
  self.sfsObj:PutInt("monsterBorn", monsterBorn)
  self.sfsObj:PutInt("monsterId", monsterId)
  self.sfsObj:PutUtfString("monsterPara", tostring(realMonsterId))
  self.sfsObj:PutLong("uuid", uuid)
end

function ParkourStageMonsterCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  end
end

return ParkourStageMonsterCheckMessage
