local CardBoxItem = BaseClass("CardBoxItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local DOTween = CS.DG.Tweening.DOTween
local DEFAULT_Y = 0
local SELECTED_Y = 20

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.box = self:AddComponent(UIBaseContainer, "box")
  self.box_icon = self:AddComponent(UIRawImage, "box/box_icon")
  self.haveNum_txt = self:AddComponent(UITextMeshProUGUIEx, "box/haveNum_txt")
  self.selected_icon = self:AddComponent(UIImage, "selected_icon")
  self.btn = self:AddComponent(UIButton, "")
  self.selected_effect = self:AddComponent(UIImage, "box/selected_effect")
  self.btn:SetOnClick(function()
    if self.onClick then
      self.onClick()
    end
  end)
  self.box:SetLocalPositionXYZ(0, DEFAULT_Y, 0)
end

local function ComponentDestroy(self)
  self.box = nil
  self.box_icon = nil
  self.haveNum_txt = nil
  self.selected_icon = nil
  self.selected_effect = nil
end

local function DataDefine(self)
  self.boxData = nil
  self.isSelected = false
  self.onClick = nil
end

local function DataDestroy(self)
  self.boxData = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function CardBoxItem:Init(boxData)
  self.boxData = boxData
  self.boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(self.boxData.id)
  self:UpdateUI()
end

function CardBoxItem:UpdateUI()
  if not self.boxData then
    return
  end
  if self.boxTemplate then
    local iconPath = self.boxTemplate:GetLargeImage()
    self.box_icon:LoadSprite(iconPath)
  end
  self:UpdateCount()
  self.selected_icon:SetEnable(self.isSelected)
  self.selected_effect:SetEnable(self.isSelected)
end

function CardBoxItem:UpdateCount()
  if not self.boxData then
    return
  end
  local count = DataCenter.ItemData:GetItemCount(self.boxData.goods_id)
  self.boxData.count = count
  self.haveNum_txt:SetText(tostring(count))
end

function CardBoxItem:SetSelected(isSelected)
  if self.isSelected == isSelected then
    return
  end
  self.isSelected = isSelected
  self.selected_icon:SetEnable(isSelected)
  self.selected_effect:SetEnable(isSelected)
  self:PlaySelectAnimation(isSelected)
end

function CardBoxItem:PlaySelectAnimation(isSelected)
  DOTween.Kill(self.box.transform)
  local targetY = isSelected and SELECTED_Y or DEFAULT_Y
  self.box.transform:DOLocalMoveY(targetY, 0.3):SetEase(CS.DG.Tweening.Ease.OutBack)
end

function CardBoxItem:SetOnClick(callback)
  self.onClick = callback
end

function CardBoxItem:GetBoxId()
  return self.boxData and self.boxData.id or 0
end

function CardBoxItem:GetBoxCount()
  return self.boxData and self.boxData.count or 0
end

function CardBoxItem:OnRefreshItems()
  if not self.boxData then
    return
  end
  self:UpdateCount()
end

CardBoxItem.OnCreate = OnCreate
CardBoxItem.OnDestroy = OnDestroy
CardBoxItem.ComponentDefine = ComponentDefine
CardBoxItem.ComponentDestroy = ComponentDestroy
CardBoxItem.DataDefine = DataDefine
CardBoxItem.DataDestroy = DataDestroy
CardBoxItem.OnAddListener = OnAddListener
CardBoxItem.OnRemoveListener = OnRemoveListener
return CardBoxItem
