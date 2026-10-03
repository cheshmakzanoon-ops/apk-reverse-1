local UIHammerExchangeView = BaseClass("UIHammerExchangeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
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
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.slider = self:AddComponent(UISlider, "UICommonPopUpTitle/mid/Slider")
  self.btnSubtract = self:AddComponent(UIButton, "UICommonPopUpTitle/mid/subtractBtn")
  self.btnSubtract:SetOnClick(function()
    self:OnBtnSubtractClick()
  end)
  self.btnAdd = self:AddComponent(UIButton, "UICommonPopUpTitle/mid/addBtn")
  self.btnAdd:SetOnClick(function()
    self:OnBtnAddClick()
  end)
  self.btnExchange = self:AddComponent(UIButton, "UICommonPopUpTitle/bottom/exchangeBtn")
  self.btnExchange:SetOnClick(function()
    self:OnBtnExchangeClick()
  end)
  self.textExchangeBtn = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bottom/exchangeBtn/exchangeBtnText")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg/Common_img_title/titleText")
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/bg/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/top/textDesc")
  self.textHave = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bottom/textHave")
  self.inputCount = self:AddComponent(UIInput, "UICommonPopUpTitle/mid/countInput")
  self.inputCount:SetOnEndEdit(function(value)
    self:InputListener(value)
  end)
  self.slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
  self.leftIcon = self:AddComponent(UICommonResItem, "UICommonPopUpTitle/top/leftIcon")
  self.rightIcon = self:AddComponent(UICommonResItem, "UICommonPopUpTitle/top/rightIcon")
  self.textTitle:SetLocalText("treasure_map_exchange_01")
  self.textExchangeBtn:SetLocalText("treasure_map_exchange_04")
end

local function ComponentDestroy(self)
  self.btnPanel = nil
  self.slider = nil
  self.btnSubtract = nil
  self.btnAdd = nil
  self.btnExchange = nil
  self.textExchangeBtn = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textDesc = nil
  self.textHave = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Init(self)
  self.nMinCount = 1
  local nMaxHammerNum = DataCenter.DigTreasureManager:GetUseItemNum()
  self.tExchangeInfo = DataCenter.DigTreasureManager:GetExchangeInfo()
  self.nRate = self.tExchangeInfo[1].nCount / self.tExchangeInfo[2].nCount
  self.nMaxCostCount = math.floor(nMaxHammerNum / self.nRate) * self.nRate
  self.nMaxCount = math.floor(self.nMaxCostCount / self.nRate)
  self.nMinCostCount = self.tExchangeInfo[1].nCount
  self.slider:SetValue(self.tExchangeInfo[2].nCount)
  self.inputCount:SetText(self.tExchangeInfo[1].nCount)
  self.slider.unity_uislider.maxValue = self.nMaxCount
  self.slider.unity_uislider.minValue = self.nMinCount
  local tParaLeft = {}
  tParaLeft.rewardType = RewardType.GOODS
  tParaLeft.itemId = self.tExchangeInfo[1].nItemId
  tParaLeft.count = self.tExchangeInfo[1].nCount
  self.leftIcon:ReInit(tParaLeft)
  local tParaRight = {}
  tParaRight.rewardType = RewardType.GOODS
  tParaRight.itemId = self.tExchangeInfo[2].nItemId
  tParaRight.count = self.tExchangeInfo[2].nCount
  self.rightIcon:ReInit(tParaRight)
  self.textDesc:SetLocalText("treasure_map_exchange_02", self.tExchangeInfo[2].nCount, self.tExchangeInfo[1].nCount)
  self.textHave:SetLocalText("treasure_map_exchange_03", self.nMaxCount)
end

local function OnBtnPanelClick(self)
  self.ctrl:CloseSelf()
end

local function OnBtnSubtractClick(self)
  local nCurValue = self.slider:GetValue()
  if nCurValue > self.nMinCount then
    self.slider:SetValue(nCurValue - 1)
  end
end

local function OnBtnAddClick(self)
  local nCurValue = self.slider:GetValue()
  if nCurValue < self.nMaxCount then
    self.slider:SetValue(nCurValue + 1)
  end
end

local function OnBtnExchangeClick(self)
  local nCount = self.slider:GetValue()
  local nRealCount = math.floor(nCount * self.nRate)
  SFSNetwork.SendMessage(MsgDefines.HammerExchange, nRealCount)
  self.ctrl:CloseSelf()
end

local function InputListener(self, value)
  local nCount = tonumber(value) or self.slider:GetValue()
  nCount = math.floor(nCount / self.nRate) * self.nRate
  if nCount > self.nMaxCostCount then
    nCount = self.nMaxCostCount
  elseif nCount < self.nMinCostCount then
    nCount = self.nMinCostCount
  end
  nCount = math.floor(nCount)
  local nExchangeNum = self:GetExchangeCount(nCount)
  self.slider:SetValue(nExchangeNum)
  self.inputCount:SetText(nCount)
  self.leftIcon:SetItemCount(nCount)
  self.rightIcon:SetItemCount(nExchangeNum)
end

local function OnValueChange(self, value)
  local nBoxCount = math.floor(value)
  local nNeedCostNum = math.floor(nBoxCount * self.nRate)
  self.inputCount:SetText(nNeedCostNum)
  self.leftIcon:SetItemCount(nNeedCostNum)
  self.rightIcon:SetItemCount(nBoxCount)
end

local function OnBtnCloseClick(self)
  self.ctrl:CloseSelf()
end

local function GetExchangeCount(self, nCostNum)
  local nExchangeCount = math.floor(nCostNum / self.nRate)
  return nExchangeCount
end

UIHammerExchangeView.OnCreate = OnCreate
UIHammerExchangeView.OnDestroy = OnDestroy
UIHammerExchangeView.OnEnable = OnEnable
UIHammerExchangeView.OnDisable = OnDisable
UIHammerExchangeView.ComponentDefine = ComponentDefine
UIHammerExchangeView.ComponentDestroy = ComponentDestroy
UIHammerExchangeView.DataDefine = DataDefine
UIHammerExchangeView.DataDestroy = DataDestroy
UIHammerExchangeView.OnAddListener = OnAddListener
UIHammerExchangeView.OnRemoveListener = OnRemoveListener
UIHammerExchangeView.OnBtnPanelClick = OnBtnPanelClick
UIHammerExchangeView.OnBtnSubtractClick = OnBtnSubtractClick
UIHammerExchangeView.OnBtnAddClick = OnBtnAddClick
UIHammerExchangeView.OnBtnExchangeClick = OnBtnExchangeClick
UIHammerExchangeView.InputListener = InputListener
UIHammerExchangeView.OnBtnCloseClick = OnBtnCloseClick
UIHammerExchangeView.OnValueChange = OnValueChange
UIHammerExchangeView.Init = Init
UIHammerExchangeView.GetExchangeCount = GetExchangeCount
return UIHammerExchangeView
