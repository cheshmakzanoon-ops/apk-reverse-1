local UICommonCountdownView = BaseClass("UICommonCountdownView", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTip1 = self:AddComponent(UIText, "Bg/node/tip1")
  self.textTip1:SetActive(false)
  self.textTip2 = self:AddComponent(UIText, "Bg/node/tip2")
  self.nodeBg2 = self:AddComponent(UIImage, "Bg/node/tiao")
  self.mainAnimator = self:AddComponent(UIAnimator, "")
  local posX = string.IsNullOrEmpty(self.bannerTxt) and 100000 or 0
  self.nodeBg2:SetLocalPositionXYZ(posX, 0, 0)
end

function UICommonCountdownView:ReInit()
  self.valid = false
  local userData = self:GetUserData() or {}
  self.endTime = userData.endTime or UITimeManager:GetInstance():GetServerTime() + 5000
  self.openTimeMs = userData.openTimeMs
  self.finalTxt = userData.finalTxt
  self.bannerTxt = userData.bannerTxt
  if not string.IsNullOrEmpty(self.bannerTxt) then
    self.textTip2:SetText(self.bannerTxt)
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  self.valid = now < self.endTime
  self:UpdateTime()
end

function UICommonCountdownView:Update100MS()
  if self.valid then
    if not self.animStart then
      self.animStart = true
      self.textTip1:SetActive(true)
      if self.mainAnimator then
        local normalizedOffset = 0
        if self.openTimeMs and 0 < self.openTimeMs then
          local now = UITimeManager:GetInstance():GetServerTime()
          local elapsedMs = math.max(0, now - self.openTimeMs)
          if 0 < elapsedMs then
            local success, animLength = self.mainAnimator:GetAnimationReturnTime("V_ui_LWCityFightCountTimeToGo_go")
            if success and 0 < animLength then
              normalizedOffset = math.min(elapsedMs / (animLength * 1000), 1)
            end
          end
        end
        self.mainAnimator:Play("V_ui_LWCityFightCountTimeToGo_go", 0, normalizedOffset)
      end
    end
    self:UpdateTime()
  end
end

function UICommonCountdownView:UpdateTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local diff = self.endTime - curTime
  self.textTip1:SetText(toInt(diff // 1000 + 1))
  if diff <= -1 then
    self.valid = false
    if self.closeAnimTimer then
      self.closeAnimTimer:Stop()
      self.closeAnimTimer = nil
    end
    if string.IsNullOrEmpty(self.finalTxt) then
      self.ctrl:CloseSelf()
    else
      if self.mainAnimator then
        local posX = string.IsNullOrEmpty(self.bannerTxt) and 100000 or 0
        self.nodeBg2:SetLocalPositionXYZ(posX, 0, 0)
        local success, time = self.mainAnimator:PlayAnimationReturnTime("V_ui_LWCityFightCountTimeToGo_text")
        if success then
          self.closeAnimTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.ctrl:CloseSelf()
          end, time)
        else
          self.ctrl:CloseSelf()
        end
      end
      self.textTip1:SetText(self.finalTxt)
    end
  end
end

local function ComponentDestroy(self)
  if self.closeAnimTimer then
    self.closeAnimTimer:Stop()
    self.closeAnimTimer = nil
  end
  self.mainAnimator = nil
  self.textTip1 = nil
  self.textTip2 = nil
end

local function DataDefine(self)
  self.animStart = false
  self.synchronizePhaseOffset = 0.38
end

local function DataDestroy(self)
  self.animStart = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnBgClick(self)
end

UICommonCountdownView.OnCreate = OnCreate
UICommonCountdownView.OnDestroy = OnDestroy
UICommonCountdownView.OnEnable = OnEnable
UICommonCountdownView.OnDisable = OnDisable
UICommonCountdownView.ComponentDefine = ComponentDefine
UICommonCountdownView.ComponentDestroy = ComponentDestroy
UICommonCountdownView.DataDefine = DataDefine
UICommonCountdownView.DataDestroy = DataDestroy
UICommonCountdownView.OnAddListener = OnAddListener
UICommonCountdownView.OnRemoveListener = OnRemoveListener
UICommonCountdownView.OnBtnBgClick = OnBtnBgClick
return UICommonCountdownView
