local base = UIAsyncContainer
local UIParkourBonusDash = BaseClass("UIParkourBonusDash", base)
local Localization = CS.GameEntry.Localization

function UIParkourBonusDash:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIParkourBonusDash:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIParkourBonusDash:ComponentDefine()
  self.btnDashBg = self:AddComponent(UIButton, "DashBg")
  self.btnDashBg:SetOnClick(function()
    self:OnBtnDashBgClick()
  end)
  self.imgProgressFgMask = self:AddComponent(UIImage, "Content/progressBg/progressFgMask")
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "Content/tips")
  self.eff1 = self:AddComponent(UIBaseContainer, "Content/progressBg/eff1")
  self.eff2 = self:AddComponent(UIBaseContainer, "Content/progressBg/eff2")
  self.eff3 = self:AddComponent(UIBaseContainer, "Content/progressBg/eff3")
  self.eff4 = self:AddComponent(UIBaseContainer, "Content/progressBg/eff4")
  self.eff_all = self:AddComponent(UIBaseContainer, "Content/progressBg/eff_all")
  self.eff1:SetActive(false)
  self.eff2:SetActive(false)
  self.eff3:SetActive(false)
  self.eff4:SetActive(false)
  self.eff_all:SetActive(false)
  self.maskWidth = 254
  self.imgProgressFgMask:SetSizeDeltaX(0)
  self:SetAnchorMinXY(0, 0)
  self:SetAnchorMaxXY(1, 1)
  self:SetSizeDeltaXY(0, 0)
end

function UIParkourBonusDash:ComponentDestroy()
  self.btnDashBg = nil
  self.imgProgressFgMask = nil
  self.textTips = nil
end

function UIParkourBonusDash:DataDefine()
end

function UIParkourBonusDash:DataDestroy()
  self.start = nil
  self:ClearDelay()
end

function UIParkourBonusDash:OnAddListener()
  base.OnAddListener(self)
end

function UIParkourBonusDash:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIParkourBonusDash:OnBtnDashBgClick()
  local time = Time.realtimeSinceStartup
  if time < self.tapEndTime then
    self.clickCounter = self.clickCounter + 1
    local curEnergy = self.clickCounter * self.tapEnergy
    local progress = curEnergy / self.totalEnergy
    progress = Mathf.Min(progress, 1)
    local width = progress * self.maskWidth
    self.imgProgressFgMask:SetSizeDeltaX(width)
    if 1 <= progress then
      self.damageCoefficient = 3
      if 1 > self.progress then
        EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashProgressChange, tostring(progress))
        self.eff1:SetActive(true)
        self.eff2:SetActive(true)
        self.eff3:SetActive(true)
        self.eff4:SetActive(true)
        self.eff_all:SetActive(true)
      end
    elseif 0.75 <= progress then
      self.damageCoefficient = 2.5
      if self.progress < 0.75 then
        EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashProgressChange, tostring(progress))
        self.eff1:SetActive(true)
        self.eff2:SetActive(true)
        self.eff3:SetActive(true)
      end
    elseif 0.5 <= progress then
      self.damageCoefficient = 2
      if self.progress < 0.5 then
        EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashProgressChange, tostring(progress))
        self.eff1:SetActive(true)
        self.eff2:SetActive(true)
      end
    elseif 0.25 <= progress then
      self.damageCoefficient = 1.5
      if self.progress < 0.25 then
        EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashProgressChange, tostring(progress))
        self.eff1:SetActive(true)
      end
    end
    self.progress = progress
  else
    self:OnBonusStart()
  end
end

function UIParkourBonusDash:UpdateData()
end

function UIParkourBonusDash:OnBonusStart()
  self:ClearDelay()
  if self.start then
    return
  end
  self.start = true
  EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashStart, self.damageCoefficient)
  self:SetActive(false)
end

function UIParkourBonusDash:SetData(param)
  self.param = param
  local bonusExtendData = param.extendData
  self.enterTime = Time.realtimeSinceStartup
  self.tapTime = bonusExtendData.tapTime or 1
  self.tapEndTime = self.enterTime + self.tapTime
  self.tapEnergy = bonusExtendData.tapEnergy
  self.totalEnergy = bonusExtendData.totalEnergy
  self.clickCounter = 0
  self.start = false
  self.damageCoefficient = 1
  self.progress = 0
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.delay = nil
    self:OnBonusStart()
  end, self.tapTime)
  EventManager:GetInstance():Broadcast(EventId.ParkourBonusDashProgressChange, tostring(0))
end

function UIParkourBonusDash:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

return UIParkourBonusDash
