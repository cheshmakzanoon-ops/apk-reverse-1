local WorldWinterStormTimer = BaseClass("WorldWinterStormTimer")
local red_path = "red"
local red_fill_path = "red/red_fill"
local blue_path = "blue"
local blue_fill_path = "blue/blue_fill"

function WorldWinterStormTimer:OnCreate(go, scale)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.red = self.transform:Find(red_path)
  self.red:Set_localScale(scale, scale, scale)
  self.red_fill = self.transform:Find(red_fill_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
  self.blue = self.transform:Find(blue_path)
  self.blue:Set_localScale(scale, scale, scale)
  self.blue_fill = self.transform:Find(blue_fill_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
end

function WorldWinterStormTimer:OnDestroy()
  if self.sequence ~= nil then
    self.sequence:Pause()
    self.sequence:Kill()
    self.sequence = nil
  end
  self.red = nil
  self.red_fill = nil
  self.blue = nil
  self.blue_fill = nil
  self:DeleteTimer()
  self.timer_action = nil
end

function WorldWinterStormTimer:ReInit(pointId, mapPointInfo)
  self.pointId = pointId
  self.mapPointInfo = mapPointInfo
  self.detailInfo = mapPointInfo ~= nil and mapPointInfo.detail or nil
  self.mySide = DataCenter.ActWinterStormManager:GetMySide()
  self.config = self.detailInfo ~= nil and DataCenter.WinterStormTemplateManager:GetTemplate(self.detailInfo.BuildId) or nil
  self:UpdateStatus()
end

function WorldWinterStormTimer:UpdateData(pointId, mapPointInfo)
  if self.pointId ~= pointId then
    return
  end
  self.mapPointInfo = mapPointInfo
  self.detailInfo = mapPointInfo ~= nil and mapPointInfo.detail or nil
  if self.detailInfo and self.sequence == nil then
    self:UpdateStatus()
  end
end

function WorldWinterStormTimer:UpdateLastOccupy(detailInfo)
  local lastOccupyTime = detailInfo ~= nil and detailInfo.LastOccupyTime or nil
  if lastOccupyTime == nil or lastOccupyTime == 0 then
    return
  end
  local tmpShow = 0 < lastOccupyTime and 1 or 2
  local mySide = self.mySide
  tmpShow = mySide == tmpShow and 2 or 1
  self:SetFillMaterial(tmpShow)
  self:SetProcess(math.abs(lastOccupyTime) / self.config.occupy_time)
end

function WorldWinterStormTimer:UpdateStatus()
  self.red.gameObject:SetActive(false)
  self.blue.gameObject:SetActive(false)
  self.endTime = nil
  self.occupyTime = nil
  self.fillMaterial = nil
  local detailInfo = self.detailInfo
  local config = self.config
  if detailInfo == nil or config == nil or detailInfo.EventFinishTime == 0 or detailInfo.State ~= WinterEntityState.Waiting and detailInfo.State ~= WinterEntityState.Occupying then
    self:UpdateLastOccupy(detailInfo)
    self:DeleteTimer()
    return
  end
  if detailInfo.Side == 0 then
    self:UpdateLastOccupy(detailInfo)
    self:DeleteTimer()
    return
  end
  self:UpdateEndTime()
  self:AddTimer()
end

function WorldWinterStormTimer:UpdateEndTime()
  local detailInfo = self.detailInfo
  local config = self.config
  if detailInfo == nil or config == nil then
    return
  end
  local showSide = detailInfo.Side
  local mySide = self.mySide
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local opTime = config.occupy_time
  if opTime < detailInfo.EventFinishTime - curTime then
    self.endTime = detailInfo.EventFinishTime - opTime
    showSide = showSide == mySide and 1 or 2
    self.bSelf = false
  else
    self.endTime = detailInfo.EventFinishTime
    showSide = showSide == mySide and 2 or 1
    self.bSelf = true
  end
  local remainTime = self.endTime ~= nil and self.endTime - curTime or 0
  if 0 < remainTime then
    self.occupyTime = opTime
  else
    self.endTime = nil
    self.occupyTime = nil
    self.fillMaterial = nil
    showSide = 0
    self:DeleteTimer()
  end
  self:SetFillMaterial(showSide)
  self:TimerAction()
end

function WorldWinterStormTimer:SetFillMaterial(showSide)
  self.red.gameObject:SetActive(showSide == 1)
  self.blue.gameObject:SetActive(showSide == 2)
  if showSide == 1 then
    self.fillMaterial = self.red_fill.material
  elseif showSide == 2 then
    self.fillMaterial = self.blue_fill.material
  end
end

function WorldWinterStormTimer:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, true, false)
  self.timer:Start()
end

function WorldWinterStormTimer:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function WorldWinterStormTimer:TimerAction()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.endTime ~= nil and self.endTime * 1000 - curTime or 0
  if self.occupyTime ~= nil then
    if 0 < remainTime then
      local num = remainTime / (self.occupyTime * 1000)
      if self.bSelf then
        num = 1 - num
      end
      self:SetProcess(num)
      return
    end
    self:UpdateEndTime()
  end
end

function WorldWinterStormTimer:SetProcess(percent)
  if self.fillMaterial ~= nil then
    self.fillMaterial:SetFloat("_Progress", percent)
  end
end

function WorldWinterStormTimer:UpdateLod(lod)
end

return WorldWinterStormTimer
