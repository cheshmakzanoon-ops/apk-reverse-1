local BFPingData = BaseClass("BFPingData")

function BFPingData:__init()
  self:Reset()
end

function BFPingData:__delete()
  self:Reset()
end

function BFPingData:Reset()
  self.cfgId = 0
  self.cfg = nil
  self.uid = ""
  self.uuid = 0
  self.cTime = 0
  self.pid = 0
end

function BFPingData:ParseData(t, bfType)
  self.cfgId = tonumber(t.cfgid)
  self.cfg = BattleFieldUtil.GetPingTemplate(self.cfgId, bfType)
  self.uid = t.uid
  self.uuid = t.uuid
  self.cTime = t.createinmills
  self.pid = t.pid
end

function BFPingData:GetEndTime()
  local duration = self.cfg ~= nil and self.cfg.world_duration or 1
  local eTime = self.cTime + duration * 1000
  return eTime
end

function BFPingData:CheckEnd()
  local cTime = UITimeManager:GetInstance():GetServerTime()
  local eTime = self:GetEndTime()
  return cTime >= eTime
end

return BFPingData
