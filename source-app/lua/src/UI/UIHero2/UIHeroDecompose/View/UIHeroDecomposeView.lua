local UIHeroDecomposeView = BaseClass("UIHeroDecomposeView", UIBaseView)
local base = UIBaseView
local UIMedalCell = require("UI.UIHero2.UIHeroDebrisExchange.Component.UIMedalCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.exchangeItemId = param.itemId
  self.targetItemId = param.exchangeMedalId
  self.exchangeRatio = param.exchangeMedalNum
  self.exchangeRatio = 1
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.exchangeItemId)
  if itemTemplate ~= nil and not string.IsNullOrEmpty(itemTemplate.para3) then
    local para3 = string.split(itemTemplate.para3, "|")
    if para3 ~= nil and #para3 == 2 then
      self.exchangeRatio = toInt(para3[2])
    end
  end
  local exchangeItemData = DataCenter.ItemData:GetItemById(self.exchangeItemId)
  local have1 = exchangeItemData and exchangeItemData.count or 0
  self.itemCell1:SetData(self.exchangeItemId, have1)
  self.itemCell2:SetData(self.targetItemId, 0)
  self.exchangeItemTotal = have1
  self.exchangeNum = 0
  if 0 < have1 then
    self.exchangeNum = 1
  end
  self.slider:SetValue(self.exchangeNum / have1)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.callback = nil
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonMidPopUpTitle/titleText")
  self.textTitle:SetLocalText(150199)
  local panel = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  local btnClose = self:AddComponent(UIButton, "UICommonMidPopUpTitle/CloseBtn")
  btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
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
  self.maxBtn = self:AddComponent(UIButton, "Root/MaxBtn")
  self.maxBtn:SetOnClick(BindCallback(self, self.OnMaxClick))
  local maxBtnText = self:AddComponent(UIText, "Root/MaxBtn/MaxBtnText")
  maxBtnText:SetLocalText(110000)
end

local function OnMaxClick(self)
  local num = self.exchangeItemTotal
  if num <= 0 then
    return
  end
  num = math.min(num, self.exchangeItemTotal)
  self:SetCurExchangeNum(num)
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
end

local function ComponentDestroy(self)
  if self.slider ~= nil then
    self.slider:SetValue(0)
  end
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
  self.itemCell2:SetNumDisplay(num * self.exchangeRatio)
  self.exchangeNum = num
  CS.UIGray.SetGray(self.btnExchange.transform, num <= 0, 0 < num)
end

local function OnBtnExchangeClick(self)
  if self.exchangeNum <= 0 then
    return
  end
  local result = {}
  result[self.exchangeItemId] = self.exchangeNum
  SFSNetwork.SendMessage(MsgDefines.HeroDecomposePiece, result)
  self.ctrl:CloseSelf()
end

UIHeroDecomposeView.OnCreate = OnCreate
UIHeroDecomposeView.OnDestroy = OnDestroy
UIHeroDecomposeView.ComponentDefine = ComponentDefine
UIHeroDecomposeView.ComponentDestroy = ComponentDestroy
UIHeroDecomposeView.OnSliderValueChanged = OnSliderValueChanged
UIHeroDecomposeView.OnBtnExchangeClick = OnBtnExchangeClick
UIHeroDecomposeView.OnAddClick = OnAddClick
UIHeroDecomposeView.OnSubClick = OnSubClick
UIHeroDecomposeView.OnShortCutBtnClick = OnShortCutBtnClick
UIHeroDecomposeView.SetCurExchangeNum = SetCurExchangeNum
UIHeroDecomposeView.OnMaxClick = OnMaxClick
return UIHeroDecomposeView
