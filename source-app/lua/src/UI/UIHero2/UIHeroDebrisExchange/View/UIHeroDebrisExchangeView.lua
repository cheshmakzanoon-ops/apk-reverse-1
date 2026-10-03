local UIHeroDebrisExchangeView = BaseClass("UIHeroDebrisExchangeView", UIBaseView)
local base = UIBaseView
local UIMedalCell = require("UI.UIHero2.UIHeroDebrisExchange.Component.UIMedalCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local exchangeItemId, targetItemId, heroId, requireNum, fromHeroLackTip = self:GetUserData()
  self.exchangeItemId = exchangeItemId
  self.targetItemId = targetItemId
  self.heroId = heroId
  self.requireNum = requireNum
  self.fromHeroLackTip = fromHeroLackTip
  local exchangeItemData = DataCenter.ItemData:GetItemById(exchangeItemId)
  local have1 = exchangeItemData and exchangeItemData.count or 0
  self.itemCell1:SetData(exchangeItemId, have1)
  local targetItemData = DataCenter.ItemData:GetItemById(targetItemId)
  local have2 = targetItemData and targetItemData.count or 0
  self.itemCell2:SetData(targetItemId, have2)
  self.medalTop:SetData(targetItemId, have2)
  self.sliderTop:SetValue(Mathf.Clamp01(have2 / requireNum))
  self.textTop:SetText(have1 .. "/" .. requireNum)
  self.exchangeItemTotal = have1
  self.targetItemTotal = have2
  self.exchangeNum = 0
  self.slider:SetValue(0)
  self:OnShortCutBtnClick()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.callback = nil
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonMidPopUpTitle/titleText")
  self.textTitle:SetLocalText(129271)
  local panel = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  panel:SetOnClick(function()
    self.ctrl:CloseSelf(self.fromHeroLackTip, self.requireNum - self.exchangeNum, self.heroId, self.requireNum)
  end)
  local btnClose = self:AddComponent(UIButton, "UICommonMidPopUpTitle/CloseBtn")
  btnClose:SetOnClick(function()
    self.ctrl:CloseSelf(self.fromHeroLackTip, self.requireNum - self.exchangeNum, self.heroId, self.requireNum)
  end)
  self.medalTop = self:AddComponent(UIMedalCell, "Root/ItemTop")
  self.sliderTop = self:AddComponent(UISlider, "Root/SliderTop")
  self.textTop = self:AddComponent(UIText, "Root/SliderTop/TextTop")
  self.itemCell1 = self:AddComponent(UIMedalCell, "Root/UIItem1")
  self.itemCell2 = self:AddComponent(UIMedalCell, "Root/UIItem2")
  self.slider = self:AddComponent(UISlider, "Root/Slider")
  self.slider:SetOnValueChanged(BindCallback(self, self.OnSliderValueChanged))
  self.btnExchange = self:AddComponent(UIButton, "Root/BtnExchange")
  self.btnExchange:SetOnClick(BindCallback(self, self.OnBtnExchangeClick))
  self.textBtnExchange = self:AddComponent(UIText, "Root/BtnExchange/TextBtnExchange")
  self.textBtnExchange_shadow = self:AddComponent(UIShadow, "Root/BtnExchange/TextBtnExchange")
  self.textBtnExchange:SetLocalText(110029)
  self.addBtn = self:AddComponent(UIButton, "Root/AddBtn")
  self.addBtn:SetOnClick(BindCallback(self, self.OnAddClick))
  self.subBtn = self:AddComponent(UIButton, "Root/SubBtn")
  self.subBtn:SetOnClick(BindCallback(self, self.OnSubClick))
end

local function OnAddClick(self)
  local curNum = self.exchangeNum + 1
  curNum = math.max(0, math.min(curNum, self.exchangeItemTotal))
  if curNum > self.exchangeNum then
    self:SetCurExchangeNum(curNum)
  end
end

local function OnSubClick(self)
  local curNum = self.exchangeNum - 1
  curNum = math.max(0, math.min(curNum, self.exchangeItemTotal))
  if curNum < self.exchangeNum then
    self:SetCurExchangeNum(curNum)
  end
end

local function SetCurExchangeNum(self, curNum)
  if self.exchangeItemTotal == 0 then
    self.slider:SetValue(0)
  else
    local sliderValue = Mathf.Clamp01(curNum / self.exchangeItemTotal)
    self.slider:SetValue(sliderValue)
  end
end

local function OnShortCutBtnClick(self)
  local num = self.requireNum - self.targetItemTotal
  if num <= 0 then
    return
  end
  num = math.min(num, self.exchangeItemTotal)
  self:SetCurExchangeNum(num)
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.itemCell1 = nil
  self.itemCell2 = nil
  self.textItemName1 = nil
  self.textItemName2 = nil
  self.slider = nil
  self.btnExchange = nil
  self.textBtnExchange = nil
  self.textBtnExchange_shadow = nil
end

local function OnSliderValueChanged(self, value)
  local num = Mathf.Round(self.exchangeItemTotal * value)
  self.itemCell1:SetNumDisplay(num .. "/" .. self.exchangeItemTotal)
  self.itemCell2:SetNumDisplay(num)
  self.sliderTop:SetValue(Mathf.Clamp01((self.targetItemTotal + num) / self.requireNum))
  local numStr = 0 < num and "+<color=#88E337>" .. num .. "</color>" or ""
  self.textTop:SetText(self.targetItemTotal .. numStr .. "/" .. self.requireNum)
  self.exchangeNum = num
  CS.UIGray.SetGray(self.btnExchange.transform, num <= 0, 0 < num)
  self.textBtnExchange_shadow:SetAllColor(num <= 0 and YellowBtnShadowGrayColor or GreenBtnShadowLightColor)
end

local function OnBtnExchangeClick(self)
  if self.exchangeNum <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroMedalExchange, self.exchangeItemId, self.targetItemId, self.exchangeNum)
  self.ctrl:CloseSelf(self.fromHeroLackTip, self.requireNum - self.exchangeNum - self.targetItemTotal, self.heroId, self.requireNum)
end

UIHeroDebrisExchangeView.OnCreate = OnCreate
UIHeroDebrisExchangeView.OnDestroy = OnDestroy
UIHeroDebrisExchangeView.ComponentDefine = ComponentDefine
UIHeroDebrisExchangeView.ComponentDestroy = ComponentDestroy
UIHeroDebrisExchangeView.OnSliderValueChanged = OnSliderValueChanged
UIHeroDebrisExchangeView.OnBtnExchangeClick = OnBtnExchangeClick
UIHeroDebrisExchangeView.OnAddClick = OnAddClick
UIHeroDebrisExchangeView.OnSubClick = OnSubClick
UIHeroDebrisExchangeView.OnShortCutBtnClick = OnShortCutBtnClick
UIHeroDebrisExchangeView.SetCurExchangeNum = SetCurExchangeNum
return UIHeroDebrisExchangeView
