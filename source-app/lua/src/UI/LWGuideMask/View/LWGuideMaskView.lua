local base = UIBaseView
local LWGuideMaskView = BaseClass("LWGuideMaskView", base)
local compBook = {
  {
    path = "mask_ctrl",
    name = "maskCtrl",
    type = nil
  },
  {
    path = "target_dummy",
    name = "tarDummy",
    type = nil
  },
  {
    path = "fingers/style_1",
    name = "fingers",
    idx = 1,
    type = UIBaseContainer
  },
  {
    path = "fingers/style_2",
    name = "fingers",
    idx = 2,
    type = UIBaseContainer
  },
  {
    path = "btn_skip",
    name = "btnSkip",
    type = UIButton
  },
  {
    path = "btn_skip/text",
    name = "txtSkip",
    type = UIText
  }
}
local max_stay_time = 10
local max_blocked_clicks = 10

function LWGuideMaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Draw()
  EventManager:GetInstance():Broadcast(EventId.GF_guide_mask_ready)
end

function LWGuideMaskView:OnDestroy()
  if self.pointerTimer ~= nil then
    self.pointerTimer:Stop()
    self.pointerTimer = nil
  end
  self:StopFingerSound()
  self:DeleteFingerSoundTimer()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWGuideMaskView:ComponentDestroy()
  if self.stayTimer ~= nil then
    self.stayTimer:Stop()
    self.stayTimer = nil
  end
  if not IsNull(self.maskCtrl) and self.OnClickBlocked ~= nil then
    self.maskCtrl:OnClickBlocked("-", self.OnClickBlocked)
  end
  self:ClearCompsByBook(compBook)
end

function LWGuideMaskView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.blockedClickCount = 0
  self.maskCtrl = self.maskCtrl:GetComponent(typeof(CS.UIGuideMaskCtrl))
  
  function self.OnClickBlocked()
    self.blockedClickCount = self.blockedClickCount + 1
    if self.blockedClickCount >= max_blocked_clicks then
      self.btnSkip:SetActive(true)
    end
  end
  
  self.maskCtrl:OnClickBlocked("+", self.OnClickBlocked)
  self.btnSkip:SetActive(false)
  self.btnSkip:SetOnClick(function()
    DataCenter.LWGuideFlowManager:KillRunningFlow()
  end)
  self.txtSkip:SetText(CS.GameEntry.Localization:GetString("110171"))
  self.stayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.btnSkip:SetActive(true)
  end, max_stay_time)
end

function LWGuideMaskView:Draw()
  local maskParams = self:GetUserData()
  local matParams = maskParams.matParams
  if matParams ~= nil then
    self.maskCtrl:SetMaterialProperties(matParams.color, matParams.rcr, matParams.fade, matParams.inverse)
  end
  self.maskCtrl.interactOffset = Vector2(maskParams.interactOffset, maskParams.interactOffset)
  self.maskCtrl.visualOffset = Vector2(maskParams.visualOffset, maskParams.visualOffset)
  local target = maskParams.target
  local returns
  if target ~= nil then
    returns = self.maskCtrl:Guide(UIManager:GetInstance().canvas, target, maskParams.animDuration)
  else
    local rect = maskParams.rect
    target = self.tarDummy:GetComponent(typeof(CS.UnityEngine.RectTransform))
    target.anchoredPosition = Vector2(rect.x, rect.y)
    target.sizeDelta = Vector2(rect.w, rect.h)
    returns = self.maskCtrl:Guide(UIManager:GetInstance().canvas, target, maskParams.animDuration)
  end
  for style, finger in ipairs(self.fingers) do
    if style == maskParams.pointerStyle then
      local offsetX = maskParams.pointerOffsetX or 0
      local offsetY = maskParams.pointerOffsetY or 0
      finger:SetAnchoredPositionXY(returns[0].x + offsetX, returns[0].y + offsetY, true)
      local pointerDelay = maskParams.animDuration * 2
      if 0 < pointerDelay then
        self.pointerTimer = TimerManager:GetInstance():DelayInvoke(function()
          local closureFinger = finger
          closureFinger:SetActive(true)
          self:StartFingerSoundTimer()
        end, pointerDelay)
      else
        finger:SetActive(true)
        self:StartFingerSoundTimer()
      end
    else
      finger:SetActive(false)
    end
  end
end

function LWGuideMaskView:StartFingerSoundTimer()
  self:DeleteFingerSoundTimer()
  self.fingerSoundTimer = TimerManager:GetInstance():GetTimer(5, self.PlayFingerSound, self, false, false, false)
  self.fingerSoundTimer:Start()
end

function LWGuideMaskView:DeleteFingerSoundTimer()
  if self.fingerSoundTimer then
    self.fingerSoundTimer:Stop()
    self.fingerSoundTimer = nil
  end
end

function LWGuideMaskView:PlayFingerSound()
  self:StopFingerSound()
  self.playingFingerSoundId = DataCenter.LWSoundManager:PlaySound(62294, false)
end

function LWGuideMaskView:StopFingerSound()
  if self.playingFingerSoundId then
    DataCenter.LWSoundManager:StopSound(self.playingFingerSoundId)
    self.playingFingerSoundId = nil
  end
end

return LWGuideMaskView
