local TCCardEquipConfirmView = BaseClass("TCCardEquipConfirmView", UIBaseView)
local CardDetailItem = require("UI.LWUITCCardEquipConfirm.Component.TCCardDetailItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local DETAIL_ITEM_PATH = "Assets/Main/Prefabs/UI/UILWTC/Component/CardDetailItem/TCCardDetailItem.prefab"
local root_path = "Root"
local panel_path = "panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local params = self:GetUserData()
  self.allCardDataList = params.cardDataList
  self.equipCardFunc = params.equipCardFunc
  self:ReInit()
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
  self.detailItemRoot = self:AddComponent(UIBaseContainer, root_path)
  self.panelBtn = self:AddComponent(UIButton, panel_path)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.canvasGroup = self:AddComponent(UICanvasGroup, root_path)
end

local function ComponentDestroy(self)
  self:ClearAllCardDetailItem()
  self.detailItemRoot:RemoveComponents(CardDetailItem)
  self.allCardDetailItemList = nil
  self.allDetailItemReqList = nil
  if self.updateLayoutTimer then
    self.updateLayoutTimer:Stop()
    self.updateLayoutTimer = nil
  end
end

local function DataDefine(self)
  self.allCardDetailItemList = {}
  self.allDetailItemReqList = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function TCCardEquipConfirmView:ReInit()
  self:ClearAllCardDetailItem()
  self.canvasGroup:SetAlpha(0)
  if self.allCardDataList then
    for index, v in ipairs(self.allCardDataList) do
      local isLastItem = index == #self.allCardDataList
      self:CreateCardDetailItem(v, isLastItem)
    end
  end
end

function TCCardEquipConfirmView:CreateCardDetailItem(cardData, isLastItem)
  local request = Resource:InstantiateAsync(DETAIL_ITEM_PATH)
  request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local name = tostring(NameCount)
    go.name = name
    NameCount = NameCount + 1
    local trans = go.transform
    trans:SetParent(self.detailItemRoot.transform)
    trans.transform:Reset()
    local cardDetailItem = self.detailItemRoot:AddComponent(CardDetailItem, name)
    local closeFunc, equipCardFunc
    local isShowBtnArea = isLastItem and self.equipCardFunc
    if isShowBtnArea then
      equipCardFunc = self.equipCardFunc
      
      function closeFunc()
        self.ctrl:CloseSelf()
      end
    end
    cardDetailItem:SetData(cardData, self.allCardDataList, equipCardFunc, closeFunc)
    cardDetailItem:AutoHeight()
    table.insert(self.allCardDetailItemList, cardDetailItem)
    if isLastItem then
      self:OnItemAllLoadFinish()
    end
  end)
  table.insert(self.allDetailItemReqList, request)
end

function TCCardEquipConfirmView:OnItemAllLoadFinish()
  self:ModifyItemHeight()
  self.canvasGroup:SetAlpha(1)
  if self.updateLayoutTimer then
    self.updateLayoutTimer:Stop()
  end
  self.updateLayoutTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ModifyItemHeight()
  end, 0.1)
end

function TCCardEquipConfirmView:ModifyItemHeight()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.detailItemRoot.rectTransform)
  for _, v in ipairs(self.allCardDetailItemList) do
    v:ModifyHeight()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.detailItemRoot.rectTransform)
end

function TCCardEquipConfirmView:ClearAllCardDetailItem()
  for _, v in ipairs(self.allDetailItemReqList) do
    v:Destroy()
  end
end

TCCardEquipConfirmView.OnCreate = OnCreate
TCCardEquipConfirmView.OnDestroy = OnDestroy
TCCardEquipConfirmView.OnEnable = OnEnable
TCCardEquipConfirmView.OnDisable = OnDisable
TCCardEquipConfirmView.ComponentDefine = ComponentDefine
TCCardEquipConfirmView.ComponentDestroy = ComponentDestroy
TCCardEquipConfirmView.DataDefine = DataDefine
TCCardEquipConfirmView.DataDestroy = DataDestroy
TCCardEquipConfirmView.OnAddListener = OnAddListener
TCCardEquipConfirmView.OnRemoveListener = OnRemoveListener
return TCCardEquipConfirmView
