local CallerUnit = require("Scene.CityVisitor.Visitors.VisitorUnit")
local base = CallerUnit
local VisitorAllianceCongratulation = BaseClass("VisitorAllianceCongratulation", CallerUnit)
local playerHead = "TipRoot/WorldPlayerHead"
local WorldPlayerHead = require("Scene.WorldPlayer.WorldPlayerHead")
local Const = require("Scene.CityVisitor.Const")
local Localization = CS.GameEntry.Localization
local bubbleAnchor = Vector3.New(0, 6, 0)

function VisitorAllianceCongratulation:OnCreateModel(req, uid, startPos, endPos)
  base.OnCreateModel(self, req, uid, startPos, endPos)
  self.isMoving = true
  self.contentList = DataCenter.AllianceCongratulationDataManager:GetBubbleStringContents()
  self.fixedTime = DataCenter.AllianceCongratulationDataManager:GetBubbleFixedTime()
  self.VFX_point = self.transform:Find("VFX_point")
  self.playHead = self.transform:Find(playerHead)
  if self.VFX_point then
    self.VFX_point.gameObject:SetActive(false)
  end
  if self.visitorData.eventType == VisitorType.AllianceCongratulation then
    if self.playHead then
      self.playHead.gameObject:SetActive(true)
      local head = WorldPlayerHead.New()
      head:OnCreate(self.playHead.gameObject)
      if not table.IsNullOrEmpty(self.visitorData.roleInfo) then
        head:SetHeadData(self.visitorData.roleInfo)
      else
        local roleInfo = DataCenter.AllianceCongratulationDataManager:GetPlayerHeadInfo(uid)
        head:SetHeadAndFrameLocal(roleInfo)
      end
    end
    if self.icon then
      self.icon.gameObject:SetActive(false)
    end
    DataCenter.CityVisitorManager:SaveAnimalTrigger(VisitorType.AllianceCongratulation, function()
      self:PlayAnimalTrigger()
    end)
  else
    if self.playHead then
      self.playHead.gameObject:SetActive(false)
    end
    if self.icon then
      self.icon.gameObject:SetActive(true)
    end
  end
end

function VisitorAllianceCongratulation:FinishVisitor(operate)
  self.isFinish = true
  self:SetFinishTargetPos()
  self:PlayAni(Const.animation.Walk2)
  if self.questionIcon then
    self.questionIcon.gameObject:SetActive(false)
  end
  if operate == 1 then
    self.smilingFaceIcon.gameObject:SetActive(true)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      if self.tipRoot then
        self.tipRoot.gameObject:SetActive(false)
      end
    end, Const.showEmojiTime)
  elseif self.tipRoot then
    self.tipRoot.gameObject:SetActive(false)
  end
  if self.modelTrigger then
    self.modelTrigger.onPointerClick = nil
  end
  if self.trigger then
    self.trigger.onPointerClick = nil
  end
  DataCenter.CityVisitorManager:DeleteVisitor(self.visitorData.uid, self.visitorData.type)
end

function VisitorAllianceCongratulation:OnTriggerClick()
  if not self.param then
    return
  end
  if self.param.isNewLogic then
    base.OnTriggerClick(self)
  else
    self:OnConfirmClick()
  end
end

function VisitorAllianceCongratulation:OnConfirmClick()
  DataCenter.CityVisitorManager:PlayAnimalTrigger(VisitorType.AllianceCongratulation)
  DataCenter.LWSoundManager:PlaySound(91027, false)
  self.pointDelay = TimerManager:GetInstance():DelayInvoke(function()
    self:OnDelayClick(function()
      if self.visitorData then
        SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 1)
      else
        UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllShow
        })
      end
    end)
  end, 1.5)
end

function VisitorAllianceCongratulation:PlayAnimalTrigger()
  self.isMoving = false
  if self.tipRoot then
    self:PlayAni(Const.animation.Point)
    self.pointEffectDelay = TimerManager:GetInstance():DelayInvoke(function()
      if self.VFX_point then
        self.VFX_point.gameObject:SetActive(true)
      end
    end, 0.1)
    if self.playHead then
      self.playHead.gameObject:SetActive(false)
    end
  end
  self.pointDelayEnd = TimerManager:GetInstance():DelayInvoke(function()
    self.isMoving = true
    if self.icon and self.icon.gameObject then
      self.icon.gameObject:SetActive(true)
    end
    if self.visitorData then
      DataCenter.CityVisitorManager:PlayVisitorFinishAni(self.visitorData.uid, self.visitorData.type, 1)
    end
  end, 1.5)
end

function VisitorAllianceCongratulation:CancelClick()
  self:OnDelayClick(function()
    if self.visitorData then
      SFSNetwork.SendMessage(MsgDefines.VisitorOperateMessage, self.visitorData.uid, 0)
    else
      UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllShow
      })
    end
  end)
end

function VisitorAllianceCongratulation:OnFinish()
  DataCenter.CityVisitorManager.RemoveDeleteCacheListToUid(self.uid)
end

function VisitorAllianceCongratulation:ClearData()
  if self.plotDelay then
    self.plotDelay:Stop()
    self.plotDelay = nil
  end
  if self.pointDelayEnd then
    self.pointDelayEnd:Stop()
    self.pointDelayEnd = nil
  end
  if self.pointDelay then
    self.pointDelay:Stop()
    self.pointDelay = nil
  end
  if self.pointEffectDelay then
    self.pointEffectDelay:Stop()
    self.pointEffectDelay = nil
  end
  self.isMoving = nil
  self.fixedTime = nil
  self.contentList = nil
  self.playHead = nil
  self.VFX_point = nil
  self._timeCounter = nil
  base.ClearData(self)
end

function VisitorAllianceCongratulation:OnUpdate()
  if self.isMoving then
    base.OnUpdate(self)
  end
  if self.visitorData and not table.IsNullOrEmpty(self.visitorData.roleInfo) then
    if self._timeCounter == nil then
      self._timeCounter = self.fixedTime
    end
    local deltaTime = Time.deltaTime
    self._timeCounter = self._timeCounter - deltaTime
    if self._timeCounter <= 0 then
      self._timeCounter = self.fixedTime
      DataCenter.CityVisitorManager:RequestShow(function()
        self:PlayPlotBubble3D()
      end, self.fixedTime + 1)
    end
  end
end

function VisitorAllianceCongratulation:PlayPlotBubble3D()
  if not self.playHead or IsNull(self.playHead) or IsNull(self.playHead.gameObject) or not self.playHead.gameObject.activeSelf then
    return
  end
  local transform = self.playHead.gameObject.transform
  local bubbleParams = {}
  local sContent = ""
  if self.contentList and #self.contentList > 0 then
    local i = math.random(1, #self.contentList)
    sContent = self.contentList[i]
  end
  bubbleParams.fakePlotMeta = {
    duration = 3,
    contentString = Localization:GetString(sContent, self.visitorData.roleInfo.name)
  }
  bubbleParams.followTarget = transform
  bubbleParams.anchor = bubbleAnchor
  bubbleParams.mode = "3DFollow"
  EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
end

return VisitorAllianceCongratulation
