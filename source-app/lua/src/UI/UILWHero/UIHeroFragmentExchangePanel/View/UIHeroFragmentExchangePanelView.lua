local UIHeroFragmentExchangePanelView = BaseClass("UIHeroFragmentExchangePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
  self:OnAddListener()
end

local function OnDestroy(self)
  self:OnRemoveListener()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bgCloseBtn = self:AddComponent(UIButton, "panel")
  self.bgCloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.closeBtn = self:AddComponent(UIButton, "Root/UICommonPopUpTitle/CloseBtn")
  self.closeBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.commonHeroFragmentItem = self:AddComponent(UICommonResItem, "Root/ImgBg/Item1")
  self.heroFragmentItem = self:AddComponent(UICommonResItem, "Root/ImgBg/Item2")
  self.commonHeroFragmentValueText = self:AddComponent(UIText, "Root/ImgBg/Item1/Item1CountText")
  self.heroFragmentValueText = self:AddComponent(UIText, "Root/ImgBg/Item2/Item2CountText")
  self.minusBtn = self:AddComponent(UIButton, "Root/ImgBg/MinusBtn")
  self.minusBtn:SetOnClick(BindCallback(self, self.OnMinusBtnClick))
  self.addBtn = self:AddComponent(UIButton, "Root/ImgBg/AddBtn")
  self.addBtn:SetOnClick(BindCallback(self, self.OnAddBtnClick))
  self.slider = self:AddComponent(UISlider, "Root/ImgBg/Slider")
  self.slider:SetOnValueChanged(function(value)
    if not self.sliderBroadcastChange then
      return
    end
    local count = math.ceil(value * self.maxCommonFragmentCount)
    self:SliderEditValue(count, false, true)
  end)
  self.inputField = self:AddComponent(UIInput, "Root/ImgBg/InputBg/Input")
  self.inputField:SetOnValueChange(function(value)
    if not self.inputFieldBroadcastChange then
      return
    end
    local count = tonumber(value)
    if count == nil then
      count = 0
    elseif count <= 0 then
      count = 0
    end
    self:InputEditValue(count, true, false)
  end)
  self.confirmBtn = self:AddComponent(UIButton, "Root/ImgBg/ConfirmBtn")
  self.confirmBtnText = self:AddComponent(UIText, "Root/ImgBg/ConfirmBtn/BtnText")
  self.confirmBtn:SetOnClick(BindCallback(self, self.OnConfrimBtnClick))
  self.arrowIcon = self:AddComponent(UIImage, "Root/ImgBg/Arrow")
  self.contentRoot = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.item1NameText = self:AddComponent(UIText, "Root/ImgBg/Item1NameText")
  self.item2NameText = self:AddComponent(UIText, "Root/ImgBg/Item2NameText")
  self.descText = self:AddComponent(UIText, "Root/ImgBg/DescText")
  self.confirmBtnText:SetLocalText(151108)
end

local function DataDefine(self)
  self.maxCommonFragmentCount = -1
  self.exchangCount = -1
  self.inputFieldBroadcastChange = true
  self.sliderBroadcastChange = true
end

local function ComponentDestroy(self)
  self.bgCloseBtn = nil
  self.closeBtn = nil
  self.commonHeroFragmentItem = nil
  self.heroFragmentItem = nil
  self.commonHeroFragmentValueText = nil
  self.heroFragmentValueText = nil
  self.minusBtn = nil
  self.addBtn = nil
  self.slider = nil
  self.inputField = nil
  self.confirmBtn = nil
  self.confirmBtnText = nil
  self.arrowIcon = nil
  self.contentRoot = nil
  self.item1NameText = nil
  self.item2NameText = nil
  self.descText = nil
end

local function DataDestroy(self)
  self.maxCommonFragmentCount = nil
  self.exchangCount = nil
  self.fragId = nil
  self.curHeroUuid = nil
  self.inputFieldBroadcastChange = false
  self.sliderBroadcastChange = false
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnOpen(self)
  self.curHeroUuid, self.needFragCount = self:GetUserData()
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.curHeroUuid)
  if self.heroData == nil then
    self.ctrl.CloseSelf()
  end
  self.fragId = self.heroData.fragId
  self.commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
  local param1 = {
    rewardType = RewardType.GOODS,
    itemId = self.commonFragId
  }
  self.commonHeroFragmentItem:ReInit(param1)
  self.commonHeroFragmentItem:SetItemCountActive(false)
  local param2 = {
    rewardType = RewardType.GOODS,
    itemId = self.fragId
  }
  self.heroFragmentItem:ReInit(param2)
  self.heroFragmentItem:SetItemCountActive(false)
  self.commonHeroFragCount = DataCenter.ItemData:GetItemCount(self.commonFragId)
  self.maxCommonFragmentCount = math.min(self.commonHeroFragCount, self.needFragCount)
  self.curHaveHeroFragCount = DataCenter.ItemData:GetItemCount(self.fragId)
  self.item1NameText:SetText(DataCenter.ItemTemplateManager:GetName(self.commonFragId))
  self.item2NameText:SetText(DataCenter.ItemTemplateManager:GetName(self.fragId))
  self.descText:SetLocalText(151106, self.needFragCount)
  self:ManualEditValue(self.maxCommonFragmentCount)
end

local function UpdateView(self)
  if self.heroData == nil then
    return
  end
end

local function OnValueChanged(self)
  self.commonHeroFragmentValueText:SetText(string.format("%d/%d", self.exchangCount, self.commonHeroFragCount))
  self.heroFragmentValueText:SetText(tostring(self.exchangCount))
end

local function OnMinusBtnClick(self)
  self:ManualEditValue(self.exchangCount - 1)
end

local function OnAddBtnClick(self)
  self:ManualEditValue(self.exchangCount + 1)
end

local function ManualEditValue(self, value)
  if value == self.exchangCount then
    return
  end
  local newCount = value
  if newCount < 0 then
    newCount = 0
  end
  if newCount > self.maxCommonFragmentCount then
    newCount = self.maxCommonFragmentCount
  end
  self.exchangCount = newCount
  self.sliderBroadcastChange = false
  self.inputFieldBroadcastChange = false
  self.inputField:SetText(tostring(self.exchangCount))
  self.slider:SetValue(self.exchangCount / self.maxCommonFragmentCount)
  self.sliderBroadcastChange = true
  self.inputFieldBroadcastChange = true
  self:OnValueChanged()
end

local function SliderEditValue(self, value)
  if value == self.exchangCount then
    return
  end
  local newCount = value
  if newCount < 0 then
    newCount = 0
  end
  if newCount > self.maxCommonFragmentCount then
    newCount = self.maxCommonFragmentCount
  end
  self.exchangCount = newCount
  self.inputFieldBroadcastChange = false
  self.inputField:SetText(tostring(self.exchangCount))
  self.inputFieldBroadcastChange = true
  self:OnValueChanged()
end

local function InputEditValue(self, value)
  if value == self.exchangCount then
    return
  end
  local forceCorrectInputField = false
  local newCount = value
  if newCount < 0 then
    newCount = 0
    forceCorrectInputField = true
  end
  if newCount > self.maxCommonFragmentCount then
    newCount = self.maxCommonFragmentCount
    forceCorrectInputField = true
  end
  self.exchangCount = newCount
  if forceCorrectInputField then
    self.inputField:SetText(tostring(self.exchangCount))
  end
  self.sliderBroadcastChange = false
  self.slider:SetValue(self.exchangCount / self.maxCommonFragmentCount)
  self.sliderBroadcastChange = true
  self:OnValueChanged()
end

local function OnConfrimBtnClick(self)
  if self.exchangCount <= 0 then
    if self.commonHeroFragCount == 0 then
      LWResourceLackUtil:GotoGoodsItemLack(self.commonFragId, 1)
    end
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroExchangeFrag, self.heroData.heroId, self.exchangCount)
  self.ctrl:CloseSelf()
end

local Pivot_Y_Max = 1
local Pivot_Y_Min = 0
local Pivot_Mid = 0.5
local Pivot_X_Max = 1
local Pivot_X_Min = 0

local function CheckAlign(self)
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = 1
  local _rect = self.contentRoot.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * scale
  local alignObject = self.alignObject
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  local pivot = Vector2.New(0.5, 0.5)
  pivot.x = Pivot_Mid
  _arrowX = 0
  pivot.y = Pivot_Y_Min
  _arrowY = -BgHeight / 2 + 10
  if pivot.x == Pivot_Mid and pivot.y == Pivot_Y_Min then
    _rotation = 180
  elseif pivot.x == Pivot_Mid and pivot.y == Pivot_Y_Max then
    _rotation = 0
  elseif pivot.x == Pivot_X_Max and pivot.y == Pivot_Y_Min then
    _rotation = 270
  elseif pivot.x == Pivot_X_Max and pivot.y == Pivot_Y_Max then
    _rotation = 270
  elseif pivot.x == Pivot_X_Min and pivot.y == Pivot_Y_Min then
    _rotation = 90
  elseif pivot.x == Pivot_X_Min and pivot.y == Pivot_Y_Max then
    _rotation = 90
  end
  self.arrowIcon.transform.localRotation = Quaternion.Euler(0, 0, _rotation)
  self.arrowIcon.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self.arrowIcon:SetActive(true)
  self.contentRoot.rectTransform.pivot = pivot
  self.contentRoot.transform.position = alignObject.transform.position
end

UIHeroFragmentExchangePanelView.OnCreate = OnCreate
UIHeroFragmentExchangePanelView.OnDestroy = OnDestroy
UIHeroFragmentExchangePanelView.OnEnable = OnEnable
UIHeroFragmentExchangePanelView.OnDisable = OnDisable
UIHeroFragmentExchangePanelView.ComponentDefine = ComponentDefine
UIHeroFragmentExchangePanelView.DataDefine = DataDefine
UIHeroFragmentExchangePanelView.ComponentDestroy = ComponentDestroy
UIHeroFragmentExchangePanelView.DataDestroy = DataDestroy
UIHeroFragmentExchangePanelView.OnOpen = OnOpen
UIHeroFragmentExchangePanelView.UpdateView = UpdateView
UIHeroFragmentExchangePanelView.OnValueChanged = OnValueChanged
UIHeroFragmentExchangePanelView.OnMinusBtnClick = OnMinusBtnClick
UIHeroFragmentExchangePanelView.OnAddBtnClick = OnAddBtnClick
UIHeroFragmentExchangePanelView.OnConfrimBtnClick = OnConfrimBtnClick
UIHeroFragmentExchangePanelView.CheckAlign = CheckAlign
UIHeroFragmentExchangePanelView.ManualEditValue = ManualEditValue
UIHeroFragmentExchangePanelView.SliderEditValue = SliderEditValue
UIHeroFragmentExchangePanelView.InputEditValue = InputEditValue
return UIHeroFragmentExchangePanelView
