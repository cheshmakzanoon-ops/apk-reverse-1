local BFPingMark = BaseClass("BFPingMark")

function BFPingMark:OnCreate(gameObject, pingData)
  self.gameObject = gameObject
  local arrow = gameObject.transform:Find("mark/Arrow")
  if arrow ~= nil then
    arrow.gameObject:SetActive(false)
  end
  self.uuid = pingData.uuid
  local cTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = pingData:GetEndTime()
  local delay = (endTime - cTime) / 1000
  if delay <= 0 then
    self:TimerCallback()
    return
  end
  self.timer = TimerManager:GetInstance():GetTimer(delay, self.TimerCallback, self, false, false, false)
  self.timer:Start()
end

function BFPingMark:Destroy()
  self:DelTimer()
  if IsNotNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  self.gameObject = nil
end

function BFPingMark:DelTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function BFPingMark:TimerCallback()
  self:DelTimer()
  BattleFieldUtil.BFPingUtil().RemovePingData(self.uuid)
end

return BFPingMark
