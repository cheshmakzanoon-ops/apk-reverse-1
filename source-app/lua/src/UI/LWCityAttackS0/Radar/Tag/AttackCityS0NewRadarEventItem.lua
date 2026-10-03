local base = UIBaseContainer
local AttackCityS0NewRadarEventItem = BaseClass("AttackCityS0NewRadarEventItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AttackCityS0NewRadarEventItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
  self:UpdateTime()
end

function AttackCityS0NewRadarEventItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AttackCityS0NewRadarEventItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnRadarEvent = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnRadarEvent:SetOnClick(function()
    self:OnBtnRadarEventClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function AttackCityS0NewRadarEventItem:ComponentDestroy()
  self.viewSkin = nil
  self.btnRadarEvent = nil
  self.textTitle = nil
  self.textTime = nil
end

function AttackCityS0NewRadarEventItem:DataDefine()
end

function AttackCityS0NewRadarEventItem:DataDestroy()
  self:RemoveUpdateTimer()
end

function AttackCityS0NewRadarEventItem:OnAddListener()
  base.OnAddListener(self)
end

function AttackCityS0NewRadarEventItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AttackCityS0NewRadarEventItem:InitData()
  self.cityLevel, self.nextStateTime = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
  self.textTitle:SetLocalText("city_war_detect_city_01", self.cityLevel + 1)
  if self.updateTimer == nil then
    function self.updateTimer()
      self:UpdateTime()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function AttackCityS0NewRadarEventItem:OnBtnRadarEventClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.AttackCityS0RadarEventPopView, {anim = true})
end

function AttackCityS0NewRadarEventItem:UpdateTime()
  if self.nextStateTime and self.nextStateTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.nextStateTime - curTime
    if 0 < deltaTime then
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.textTime:SetText("00:00:00")
    end
  end
end

function AttackCityS0NewRadarEventItem:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

return AttackCityS0NewRadarEventItem
