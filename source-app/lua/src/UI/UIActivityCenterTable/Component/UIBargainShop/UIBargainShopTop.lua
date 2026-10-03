local base = UIBaseContainer
local UIBargainShopTop = BaseClass("UIBargainShopTop", base)
local UICurrencyCell = require("UI.UIActivityCenterTable.Component.UIBargainShop.UICurrencyCell")
local const_bannerDes2_Key = "activity_bargain_shop_desc2"
local const_refreshTiming_Key = "activity_bargain_shop_desc6"
local Localization = CS.GameEntry.Localization

function UIBargainShopTop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIBargainShopTop:ComponentDefine()
  self.bannerTitle_text = self:AddComponent(UIText, "title")
  self.bannerDes_text = self:AddComponent(UIText, "des")
  self.bannerDes2_text = self:AddComponent(UIText, "des1")
  self.refreshTiming_text = self:AddComponent(UIText, "des2")
  self.endTime_text = self:AddComponent(UIText, "TimeLayout/Time")
  self.currencyCell = self:AddComponent(UICurrencyCell, "ExpArea")
  self.infoBtn = self:AddComponent(UIButton, "InfoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
end

function UIBargainShopTop:OnInfoBtnClick()
  local param = {}
  param.activityId = self.data and self.data.activityId or nil
  param.actTemplate = self.actTemplate
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBargainShopRules, {anim = true}, param)
end

function UIBargainShopTop:ComponentDestroy()
  self.bannerTitle_text = nil
  self.bannerDes_text = nil
  self.bannerDes2_text = nil
  self.refreshTiming_text = nil
  self.endTime_text = nil
  self.currencyIcon = nil
  self.currencyCount_text = nil
  self.currencyBtn = nil
end

function UIBargainShopTop:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBargainProp, self.RefreshBuyCount)
end

function UIBargainShopTop:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBargainProp, self.RefreshBuyCount)
  base.OnRemoveListener(self)
end

function UIBargainShopTop:RefreshBuyCount()
  self.bannerDes2_text:SetLocalText(const_bannerDes2_Key, self.data:GetBuyCount())
end

function UIBargainShopTop:UpdateData(actData, actTemplate)
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
end

function UIBargainShopTop:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.data.nextRefreshTime * 1000 - curTime
  self.refreshTiming_text:SetLocalText(const_refreshTiming_Key, UITimeManager:GetInstance():MilliSecondToFmtString(time))
  local time = self.data.endViewTime - curTime
  self.endTime_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(time))
  if time <= 0 then
    self:DeleteTimer()
  end
end

function UIBargainShopTop:AddTimer()
  self:RefreshTimerCountdown()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, function()
      self:RefreshTimerCountdown()
    end, self, false, false, false)
  end
  self.timer:Start()
end

function UIBargainShopTop:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIBargainShopTop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBargainShopTop:DataDestroy()
  self.data = nil
  self.actTemplate = nil
  self:DeleteTimer()
end

return UIBargainShopTop
