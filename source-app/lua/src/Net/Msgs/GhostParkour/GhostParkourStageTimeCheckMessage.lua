local GhostParkourStageTimeCheckMessage = BaseClass("GhostParkourStageTimeCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourStageTimeCheckMessage:OnCreate(distance, totalRunTime, totalStopTime, uuid, coinNum, buffList)
  base.OnCreate(self)
  self.sfsObj:PutDouble("distance", distance)
  self.sfsObj:PutDouble("totalRunTime", totalRunTime)
  self.sfsObj:PutDouble("totalStopTime", totalStopTime)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("coinNum", coinNum)
  self.sfsObj:PutUtfString("buffList", buffList)
end

function GhostParkourStageTimeCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  end
end

return GhostParkourStageTimeCheckMessage
