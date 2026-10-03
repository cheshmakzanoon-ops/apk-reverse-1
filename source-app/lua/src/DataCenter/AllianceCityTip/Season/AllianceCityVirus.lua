local AllianceCityVirus = BaseClass("AllianceCityVirus")
local Localization = CS.GameEntry.Localization

function AllianceCityVirus:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.icon = self.transform:Find("Icon")
    self.icon:Set_localScale(1, 1, 1)
    self.layerText = self.transform:Find("Icon/Text"):GetComponent(typeof(CS.TextMeshProEx))
    
    function self.timer_action(temp)
      self:CheckVirusFinish()
    end
  end
end

function AllianceCityVirus:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self:DeleteTimer()
  self.timer_action = nil
  self.gameObject = nil
  self.transform = nil
  self.layerText = nil
  self.bUuid = nil
  self.allianceCityTip = nil
  self.virusNum = nil
  self.virusEndTime = nil
  self.statusId = nil
end

function AllianceCityVirus:SetData(virusNum, virusEndTime, statusId, uuid, tip)
  self.virusNum = virusNum
  self.virusEndTime = virusEndTime * 0.001
  self.statusId = statusId
  self.bUuid = uuid
  self.allianceCityTip = tip
  self:RefreshText(self.virusNum)
  self:AddTimer()
end

function AllianceCityVirus:RefreshText(level)
  if not self.curLevel then
    self.curLevel = 0
  end
  if self.curLevel == level then
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
      self.layerText.text = tostring(level) .. " - " .. math.floor(self.virusEndTime - UITimeManager:GetInstance():GetServerSeconds())
    end
    return
  end
  if level > self.curLevel and self.icon then
    EventManager:GetInstance():Broadcast(EventId.VirusPoisonedBubble, {
      bUuid = self.bUuid
    })
    self.tweenSeq = DOTween.Sequence():Append(self.icon:DOScale(Vector3.New(1.6, 1.6, 1), 0.1)):AppendInterval(0.1):Append(self.icon:DOScale(ResetScale, 0.3))
  end
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    self.layerText.text = tostring(level) .. " - " .. math.floor(self.virusEndTime - UITimeManager:GetInstance():GetServerSeconds())
  else
    self.layerText.text = tostring(level)
  end
  self.curLevel = level
end

function AllianceCityVirus:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function AllianceCityVirus:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

function AllianceCityVirus:CheckVirusFinish()
  if self.virusEndTime and self.virusNum then
    self.virusNum, self.virusEndTime = SeasonUtil.CalcVirusLevel(self.virusNum, self.virusEndTime, self.statusId)
    if self.virusNum > 0 then
      self:RefreshText(self.virusNum)
    else
      self.allianceCityTip:RemoveVirus()
    end
  end
end

return AllianceCityVirus
