local ParkourStageTimeCheckMessage = BaseClass("ParkourStageTimeCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ParkourStageTimeCheckMessage:OnCreate(distance, totalRunTime, totalStopTime, uuid)
  base.OnCreate(self)
  self.sfsObj:PutDouble("distance", distance)
  self.sfsObj:PutDouble("totalRunTime", totalRunTime)
  self.sfsObj:PutDouble("totalStopTime", totalStopTime)
  self.sfsObj:PutLong("uuid", uuid)
end

function ParkourStageTimeCheckMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  end
end

return ParkourStageTimeCheckMessage
