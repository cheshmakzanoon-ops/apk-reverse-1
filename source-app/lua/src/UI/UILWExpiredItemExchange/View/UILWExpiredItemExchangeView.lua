local UILWExpiredItemExchangeView = BaseClass("UILWExpiredItemExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local selected_use_area_path = "ContentArea/BtnArea/SelectedUseArea"
local info_input_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput"
local dec_btn_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/DecBtn"
local slider_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/Slider"
local add_btn_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/AddBtn"
local count_text_path = "ContentArea/BtnArea/SelectedUseArea/InfoInput/TextBg/CountText"

function UILWExpiredItemExchangeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function UILWExpiredItemExchangeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWExpiredItemExchangeView:ComponentDefine()
  self.btnPanelClose = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanelClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("goods_recovery_title"))
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTips = self:AddComponent(UIText, "ContentArea/TipsText")
  self.compUICommonResItemLeft = self:AddComponent(UICommonResItem, "ContentArea/ContentItem/UICommonResItemLeft")
  self.compUICommonResItemRight = self:AddComponent(UICommonResItem, "ContentArea/ContentItem/UICommonResItemRight")
  self.btnCancel = self:AddComponent(UIButton, "ContentArea/BtnArea/GameObject/BtnCancel")
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.textCancel = self:AddComponent(UIText, "ContentArea/BtnArea/GameObject/BtnCancel/TextCancel")
  self.textCancel:SetText(Localization:GetString("110106"))
  self.btnConfirm = self:AddComponent(UIButton, "ContentArea/BtnArea/GameObject/BtnConfirm")
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textConfirm = self:AddComponent(UIText, "ContentArea/BtnArea/GameObject/BtnConfirm/TextConfirm")
  self.textConfirm:SetText(Localization:GetString("458522"))
  self.info_input = self:AddComponent(UIBaseContainer, info_input_path)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(function()
    if self.exchangeCount == nil then
      return
    end
    self:SetExchangeCount(self.exchangeCount - 1, true)
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider:SetOnValueChanged(function(value)
    if self.exchangeCount == nil or self.itemId == nil then
      return
    end
    if value <= 0 and self.exchangeCount == 1 then
      self.slider:SetValueWithoutNotify(1)
      return
    end
    self:SetExchangeCount(value, false)
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    if self.exchangeCount == nil then
      return
    end
    self:SetExchangeCount(self.exchangeCount + 1, true)
  end)
  self.count_text = self:AddComponent(UIText, count_text_path)
end

function UILWExpiredItemExchangeView:ComponentDestroy()
  self.textTitle = nil
  self.btnClose = nil
  self.textTips = nil
  self.compUICommonResItemLeft = nil
  self.compUICommonResItemRight = nil
  self.btnCancel = nil
  self.textCancel = nil
  self.btnConfirm = nil
  self.textConfirm = nil
end

function UILWExpiredItemExchangeView:DataDefine()
  local param = self:GetUserData()
  self.exchangeItemTemplate = param.exchangeItemTemplate
  self.itemId = checknumber(param.itemId)
  self.manager = DataCenter.ItemExchangeManager
  self.itemTemplate = self.manager:GetItemExchangeTemplateByItemId(self.itemId)
  self.exchangeCount = nil
end

function UILWExpiredItemExchangeView:DataDestroy()
  self.itemId = nil
  self.exchangeItemTemplate = nil
  self.manager = nil
  self.itemTemplate = nil
  self.exchangeCount = nil
end

function UILWExpiredItemExchangeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ExpiredItemExchangeSuccess, self.OnExchangeSuccess)
end

function UILWExpiredItemExchangeView:OnRemoveListener()
  self:RemoveUIListener(EventId.ExpiredItemExchangeSuccess, self.OnExchangeSuccess)
  base.OnRemoveListener(self)
end

function UILWExpiredItemExchangeView:OnOpen()
  if (self.itemTemplate == nil or not self.itemTemplate:IsExpiredNow()) and not DataCenter.ItemData:CheckItemIsExpiredInOtherParamData(self.itemId) then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(self.itemTemplate.id)
  self.slider.unity_uislider.maxValue = userCount
  self.slider.unity_uislider.minValue = 0
  self:SetDescText()
  self:SetExchangeCount(1, true)
end

function UILWExpiredItemExchangeView:SetDescText()
  local descStr1 = Localization:GetString("goods_recovery_tips1")
  if self.exchangeItemTemplate and self.exchangeItemTemplate.times_type == 4 then
    local descStr2 = Localization:GetString(self.exchangeItemTemplate.text)
    descStr1 = descStr1 .. "\n" .. descStr2
  end
  self.textTips:SetText(descStr1)
end

function UILWExpiredItemExchangeView:UpdateItems()
  local function UpdateItem(itemData, itemObj, count)
    local rewardData = {
      rewardType = RewardType.GOODS,
      
      itemId = itemData.id,
      count = count
    }
    itemObj:ReInit(rewardData)
  end
  
  if self.itemTemplate == nil then
    return
  end
  local targetItemData = self.itemTemplate:GetExchangeTargetItemData()
  if targetItemData == nil or targetItemData[1] == nil then
    return
  end
  local itemTemplateLeft = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemTemplate.id)
  local itemTemplateRight = DataCenter.ItemTemplateManager:GetItemTemplate(targetItemData[1].itemId)
  if itemTemplateLeft == nil or itemTemplateRight == nil then
    return
  end
  UpdateItem(itemTemplateLeft, self.compUICommonResItemLeft, self.exchangeCount)
  UpdateItem(itemTemplateRight, self.compUICommonResItemRight, targetItemData[1].itemNum * self.exchangeCount)
end

function UILWExpiredItemExchangeView:SetExchangeCount(count, triggerSliderChange)
  if self.itemTemplate == nil then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(self.itemTemplate.id)
  if userCount <= 0 then
    return
  end
  if count > userCount then
    count = userCount
  end
  if count <= 0 then
    count = 1
  end
  if self.exchangeCount ~= nil and self.exchangeCount == count then
    return
  end
  self.exchangeCount = count
  self.count_text:SetText(tostring(math.floor(self.exchangeCount)) .. "/" .. tostring(userCount))
  if triggerSliderChange then
    self.slider:SetValue(self.exchangeCount)
  else
    self.slider:SetValueWithoutNotify(self.exchangeCount)
  end
  UIGray.SetGray(self.dec_btn.transform, 1 >= self.exchangeCount, true)
  UIGray.SetGray(self.add_btn.transform, userCount <= self.exchangeCount, true)
  self:UpdateItems()
end

function UILWExpiredItemExchangeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWExpiredItemExchangeView:OnBtnCancelClick()
  self.ctrl:CloseSelf()
end

function UILWExpiredItemExchangeView:OnBtnConfirmClick()
  if self.itemTemplate == nil then
    return
  end
  if self.exchangeCount == nil or self.exchangeCount <= 0 then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(self.itemTemplate.id)
  if userCount == self.exchangeCount then
    UIUtil.ShowSecondMessage(Localization:GetString("129052"), Localization:GetString("goods_recovery_tips2"), 2, "", "", function()
      if self.itemTemplate ~= nil and self.exchangeCount ~= nil and self.exchangeCount > 0 then
        self.manager:SendExchangeItemMsg(self.itemTemplate.id, self.exchangeCount)
      end
    end, nil, nil, nil, nil, nil, nil, nil, nil, false)
  else
    self.manager:SendExchangeItemMsg(self.itemTemplate.id, self.exchangeCount)
  end
end

function UILWExpiredItemExchangeView:OnExchangeSuccess()
  self.ctrl:CloseSelf()
end

return UILWExpiredItemExchangeView
