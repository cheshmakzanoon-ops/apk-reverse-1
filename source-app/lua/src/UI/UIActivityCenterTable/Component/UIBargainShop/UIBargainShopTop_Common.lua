local base = UIBaseContainer
local UIBargainShopTop_Common = BaseClass("UIBargainShopTop_Common", base)
local UICurrencyCell = require("UI.UIActivityCenterTable.Component.UIBargainShop.UICurrencyCell")
local const_bannerDes2_Key = "activity_bargain_shop_desc2"
local const_refreshTiming_Key = "activity_bargain_shop_desc6"
local Localization = CS.GameEntry.Localization

function UIBargainShopTop_Common:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBargainShopTop_Common:ComponentDefine()
  self.bannerTitle_text = self:AddComponent(UIText, "titleLayout/title")
  self.bannerTitle_outline = self:AddComponent(UIOutline, "titleLayout/title")
  self.bannerTitle_shadow = self:AddComponent(UIShadow, "titleLayout/title")
  self.bannerDes_text = self:AddComponent(UIText, "des")
  self.bannerDes_outline = self:AddComponent(UIOutline, "des")
  self.bannerDes_shadow = self:AddComponent(UIShadow, "des")
  self.bannerDes2_text = self:AddComponent(UIText, "des1")
  self.endTime_outline = self:AddComponent(UIShadow, "TimeLayout/Time")
  self.endTime_shadow = self:AddComponent(UIOutline, "TimeLayout/Time")
  self.refreshTiming_text = self:AddComponent(UIText, "des2")
  self.endTime_text = self:AddComponent(UIText, "TimeLayout/Time")
  self.currencyCell = self:AddComponent(UICurrencyCell, "ExpArea")
  self.infoBtn = self:AddComponent(UIButton, "titleLayout/InfoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

function UIBargainShopTop_Common:OnInfoBtnClick()
  local param = {}
  param.activityId = self.data and self.data.activityId or nil
  param.actTemplate = self.actTemplate
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBargainShopRules, {anim = true}, param)
end

function UIBargainShopTop_Common:ComponentDestroy()
  self.bannerTitle_text = nil
  self.bannerDes_text = nil
  self.bannerDes2_text = nil
  self.refreshTiming_text = nil
  self.endTime_text = nil
  self.currencyIcon = nil
  self.currencyCount_text = nil
  self.currencyBtn = nil
end

function UIBargainShopTop_Common:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainProp, self.RefreshBuyCount)
end

function UIBargainShopTop_Common:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainProp, self.RefreshBuyCount)
  base.OnRemoveListener(self)
end

function UIBargainShopTop_Common:RefreshBuyCount()
  self.bannerDes2_text:SetLocalText(const_bannerDes2_Key, self.data:GetBuyCount())
end

function UIBargainShopTop_Common:UpdateData(actData, actTemplate)
  self.data = actData
  self.actTemplate = actTemplate
  self.currencyCell:UpdateData(self.data)
  self.bannerTitle_text:SetLocalText(actTemplate.name)
  self.bannerDes_text:SetLocalText(actTemplate.desc_info)
  if self.actTemplate.para_5 and tonumber(self.actTemplate.para_5) == 1 then
    self.bannerDes2_text:SetActive(true)
    self:RefreshBuyCount()
  else
    self.bannerDes2_text:SetActive(false)
  end
  self:AddTimer()
  self:SetViewColor()
end

function UIBargainShopTop_Common:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.data.nextRefreshTime * 1000 - curTime
  self.refreshTiming_text:SetLocalText(const_refreshTiming_Key, UITimeManager:GetInstance():MilliSecondToFmtString(time))
  local time = self.data.endViewTime - curTime
  self.endTime_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  if time <= 0 then
    self:DeleteTimer()
  end
end

function UIBargainShopTop_Common:AddTimer()
  self:DeleteTimer()
  self:RefreshTimerCountdown()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, function()
      self:RefreshTimerCountdown()
    end, self, false, false, false)
  end
  self.timer:Start()
end

function UIBargainShopTop_Common:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIBargainShopTop_Common:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopTop_Common:DataDestroy()
  self.data = nil
  self.actTemplate = nil
  self:DeleteTimer()
end

function UIBargainShopTop_Common:SetViewColor()
  local showTemp = self.actTemplate:GetShowConfigTemp()
  if showTemp == nil then
    return
  end
  UIActivityCenterCommonUtil.SetTopViewColor(self.bannerTitle_text.gameObject, self.bannerDes_text.gameObject, self.endTime_text.gameObject, showTemp)
end

return UIBargainShopTop_Common
