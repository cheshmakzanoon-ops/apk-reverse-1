local TruckStationBubble = BaseClass("TruckStationBubble")
local Localization = CS.GameEntry.Localization

function TruckStationBubble:__init(transform)
  self.transform = transform
  self:ComponentDefine()
  self:Refresh()
end

function TruckStationBubble:__delete()
  self:Destroy()
end

function TruckStationBubble:Destroy()
  self:RemoveTimer()
  self:ComponentDestroy()
end

function TruckStationBubble:ComponentDefine()
  self.bg = self.transform:Find("Go").gameObject
  self.state = self.transform:Find("Go/state"):GetComponent(typeof(CS.TextMeshProEx))
  self.state.text = Localization:GetString("458525")
  self.time = self.transform:Find("Go/time"):GetComponent(typeof(CS.TextMeshProEx))
  self.trigger = self.transform:Find("Go/Trigger"):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
end

function TruckStationBubble:ComponentDestroy()
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.bg = nil
  self.state = nil
  self.time = nil
  self.transform = nil
end

function TruckStationBubble:AddTimer()
  if self.updateSecTimer == nil then
    self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
    self.updateSecTimer:Start()
  end
end

function TruckStationBubble:RemoveTimer()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
end

function TruckStationBubble:OnUpdateSec()
  local now = UITimeManager:GetInstance():GetServerTime()
  local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.timestamp - now)
  self.time.text = str
end

function TruckStationBubble:Refresh()
  self:RemoveTimer()
  local state, ts = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  if state == RailwayStationState.WarmUp then
    self.bg:SetActive(true)
    self.timestamp = ts
    self.state.text = Localization:GetString("458525")
    self:AddTimer()
    self:OnUpdateSec()
  else
    local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
    if closed then
      self.bg:SetActive(true)
      self.timestamp = closeEndTime
      self.state.text = Localization:GetString("alliance_train_039")
      self:AddTimer()
      self:OnUpdateSec()
      return
    end
    self.bg:SetActive(false)
  end
end

function TruckStationBubble:OnClick()
  local state, _ = DataCenter.LWMyStationDataManager:GetRailwayStationState()
  local closed, closeEndTime = DataCenter.LWAllyStationDataManager:IsTrainClosed()
  if closed and state > RailwayStationState.FirstReward then
    UIUtil.ShowMessage(Localization:GetString("alliance_train_041"), 1, GameDialogDefine.CONFIRM, nil, nil, nil, nil, "alliance_train_040", nil, nil, nil, nil, nil, closeEndTime, CS.UnityEngine.TextAnchor.UpperLeft)
    return
  end
  RailwayUtil.ClickTrainStation()
end

return TruckStationBubble
