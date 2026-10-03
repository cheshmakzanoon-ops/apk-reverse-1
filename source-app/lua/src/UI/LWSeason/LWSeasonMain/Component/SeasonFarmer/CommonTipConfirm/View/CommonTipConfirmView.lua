local base = UIBaseView
local CommonTipConfirmView = BaseClass("CommonTipConfirmView", base)
local CommonTipItem = require("UI.LWSeason.LWSeasonMain.Component.SeasonFarmer.CommonTipConfirm.Component.CommonTipItem")
local title_path = "PopUpTitle/Common_img_title/titleText"
local tip_path = "PopUpTitle/TipsText"
local limit_path = "PopUpTitle/LimitText"
local confirmBtn_path = "PopUpTitle/Btn"
local closeBtn_path = "PopUpTitle/CloseBtn"
local conditionItem_path = "PopUpTitle/ScrollView/Content/ConditionItem"
local itemParent_path = "PopUpTitle/ScrollView/Content"
local maskBtn_path = "panel"
local ScrollView_path = "PopUpTitle/ScrollView"
local btnTime_path = "PopUpTitle/Btn/TimeText"
local btnText_path = "PopUpTitle/Btn/BtnText"
local contentSize_path = "PopUpTitle/ScrollView/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.panelParam = self:GetUserData()
  self:Refresh()
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
  self.title = self:AddComponent(UIText, title_path)
  self.tip = self:AddComponent(UIText, tip_path)
  self.limit = self:AddComponent(UIText, limit_path)
  self.confirmBtn = self:AddComponent(UIButton, confirmBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.conditionItem = self:AddComponent(CommonTipItem, conditionItem_path)
  self.itemParent = self:AddComponent(UIBaseContainer, itemParent_path)
  self.maskBtn = self:AddComponent(UIButton, maskBtn_path)
  self.ScrollView = self:AddComponent(UIScrollRect, ScrollView_path)
  self.btnTime = self:AddComponent(UIText, btnTime_path)
  self.btnText = self:AddComponent(UIText, btnText_path)
  self.tipItem = self.transform:Find(conditionItem_path).gameObject
  self.tipItem:GameObjectCreatePool()
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirmBtn:SetOnClick(function()
    self:ConfirmBtn()
  end)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.fitter = nil
  self.title = nil
  self.tip = nil
  self.limit = nil
  self.confirmBtn = nil
  self.closeBtn = nil
  self.conditionItem = nil
  self.itemParent = nil
  self.maskBtn = nil
  self.ScrollView = nil
  self.btnTime = nil
  self.btnText = nil
  self.contentSize = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CommonTipConfirmView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushUserSeasonRoleEvent, self.GetSeasonRoleData)
end

function CommonTipConfirmView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushUserSeasonRoleEvent, self.GetSeasonRoleData)
  base.OnRemoveListener(self)
end

function CommonTipConfirmView:Refresh()
  local data = self.ctrl:GetPanelData(self.panelParam.panelType)
  self.title:SetText(data.title)
  self.btnText:SetText(data.btnText)
  local itemList = data.tipDataList
  self.clickTime = 10
  for i = 1, #itemList do
    local goItem = self.tipItem:GameObjectSpawn(self.itemParent.transform)
    goItem.name = "item_" .. i
    goItem:SetActive(true)
    local theItem = self.itemParent:AddComponent(CommonTipItem, goItem.name)
    theItem:ReInit(itemList[i])
  end
  self:RefreshBtnState()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemParent.transform)
end

function CommonTipConfirmView:ClearItemCell()
  self.ScrollView:SetVerticalNormalizedPosition(1)
  self.itemParent:RemoveComponents(CommonTipItem)
  self.tipItem:GameObjectRecycleAll()
end

function CommonTipConfirmView:Update1000MS()
  if self.clickTime then
    self.clickTime = self.clickTime - 1
    if self.clickTime <= 0 then
      self.clickTime = nil
    end
    self:RefreshBtnState()
  end
end

function CommonTipConfirmView:RefreshBtnState()
  if self.clickTime then
    CS.UIGray.SetGray(self.confirmBtn.transform, true, false)
    self.btnTime:SetActive(true)
    self.btnTime:SetText(string.format("%ss", self.clickTime))
    return
  end
  self.btnTime:SetActive(false)
  CS.UIGray.SetGray(self.confirmBtn.transform, false, true)
end

function CommonTipConfirmView:ConfirmBtn()
  if self.clickTime then
    return
  end
  if type(self.panelParam.confirmCall) == "function" then
    self.panelParam.confirmCall()
  end
end

function CommonTipConfirmView:GetSeasonRoleData()
  if self.panelParam.panelType == CommonTipConfirmType.SeasonFarmerRewardTip then
    self.ctrl:CloseSelf()
  end
end

CommonTipConfirmView.OnCreate = OnCreate
CommonTipConfirmView.OnDestroy = OnDestroy
CommonTipConfirmView.OnEnable = OnEnable
CommonTipConfirmView.OnDisable = OnDisable
CommonTipConfirmView.ComponentDefine = ComponentDefine
CommonTipConfirmView.ComponentDestroy = ComponentDestroy
CommonTipConfirmView.DataDefine = DataDefine
CommonTipConfirmView.DataDestroy = DataDestroy
return CommonTipConfirmView
