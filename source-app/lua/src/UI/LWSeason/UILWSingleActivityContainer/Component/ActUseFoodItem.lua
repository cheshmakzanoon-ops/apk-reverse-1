local base = UIBaseContainer
local ActUseFoodItem = BaseClass("ActUseFoodItem", base)
local itemBtn_path = "itemBtn"
local itemParent_path = "itemParent"
local itemQuality_path = "itemParent/item/ImgQuality"
local itemIcon_path = "itemParent/item/ImgIcon"
local itemNum_path = "itemParent/item/NumText"
local empty_path = "empty"
local itemIconAni_path = "aniParent/ImgIconAni"
local itemIconAniParent_path = "aniParent"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.itemBtn = self:AddComponent(UIButton, itemBtn_path)
  self.itemParent = self:AddComponent(UIBaseContainer, itemParent_path)
  self.itemQuality = self:AddComponent(UIImage, itemQuality_path)
  self.itemIcon = self:AddComponent(UIImage, itemIcon_path)
  self.itemNum = self:AddComponent(UIText, itemNum_path)
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.itemIconAni = self:AddComponent(UIImage, itemIconAni_path)
  self.itemIconAniParent = self:AddComponent(UIBaseContainer, itemIconAniParent_path)
  self.itemIconAniParent:SetActive(false)
  self.itemIcon:SetLocalPositionXYZ(0, 6, 0)
  self.itemIcon.transform.rotation = Quaternion.Euler(0, 0, 0)
  self.itemIcon.transform:Set_localScale(1, 1, 1)
  self.itemBtn:SetOnClick(function()
    self:OnItemClick()
  end)
end

local function ComponentDestroy(self)
  self.itemBtn = nil
  self.itemParent = nil
  self.itemQuality = nil
  self.itemIcon = nil
  self.itemNum = nil
  self.empty = nil
  self.itemIconAni = nil
  self.itemIconAniParent = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ActUseFoodItem:SetData(itemId, click)
  self:SetItemId(itemId)
  self.click = click
end

function ActUseFoodItem:SetItemId(itemId, ani)
  self.itemId = itemId
  self.itemNum:SetText("")
  self:_reSetData()
  if ani then
    self.itemIcon.transform.rotation = Quaternion.Euler(0, 0, 25)
    self.itemIcon:SetLocalPositionXYZ(0, 306, 0)
    self.itemIcon.transform:Set_localScale(0.6, 0.6, 0.6)
    self.seq = CS.DG.Tweening.DOTween.Sequence()
    self.seq:Append(self.itemIcon.transform:DORotate(Vector3(0, 0, 0), 0.16666666666666666):SetEase(CS.DG.Tweening.Ease.InOutSine))
    self.seq:Join(self.itemIcon.transform:DOLocalMove(Vector3(0, 6, 0), 0.16666666666666666):SetEase(CS.DG.Tweening.Ease.InOutSine))
    
    function self.seq.onComplete()
      self.seq = nil
    end
    
    self.seq1 = CS.DG.Tweening.DOTween.Sequence()
    self.seq1:Append(self.itemIcon.transform:DOScale(Vector3(1, 1, 1), 0.13333333333333333):SetEase(CS.DG.Tweening.Ease.InOutSine))
    self.seq1:Append(self.itemIcon.transform:DOScale(Vector3(1.2, 1.2, 1), 0.1):SetEase(CS.DG.Tweening.Ease.InOutSine))
    self.seq1:Append(self.itemIcon.transform:DOScale(Vector3(0.92, 0.92, 1), 0.1):SetEase(CS.DG.Tweening.Ease.InOutSine))
    self.seq1:Append(self.itemIcon.transform:DOScale(Vector3(1.05, 1.05, 1), 0.08333333333333333):SetEase(CS.DG.Tweening.Ease.InOutSine))
    self.seq1:Append(self.itemIcon.transform:DOScale(Vector3(1, 1, 1), 0.16666666666666666):SetEase(CS.DG.Tweening.Ease.InOutSine))
    
    function self.seq1.onComplete()
      self.seq1 = nil
    end
  end
end

function ActUseFoodItem:_reSetData()
  self.isEmpty = self.itemId == nil
  if not self.isEmpty then
    self.isEmpty = false
    self.itemParent:SetActive(true)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if goods then
      self.itemIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
      self.itemIconAni:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
    self.empty:SetActive(false)
  else
    self.empty:SetActive(true)
    self.itemParent:SetActive(false)
  end
end

function ActUseFoodItem:ReSetAnimation()
  if self.seq1 and self.seq1:IsPlaying() then
    self.seq1:Kill(true)
    self.seq1 = nil
  end
  if self.seq and self.seq:IsPlaying() then
    self.seq:Kill(true)
    self.seq = nil
  end
end

function ActUseFoodItem:SetEmpty()
  self.itemId = nil
  self:_reSetData()
end

function ActUseFoodItem:OnItemClick()
  if self.click and not self.isEmpty then
    local result = self.click(self.itemId)
    if result then
      self:ReSetAnimation()
      self:SetEmpty()
    end
  end
end

ActUseFoodItem.OnCreate = OnCreate
ActUseFoodItem.OnDestroy = OnDestroy
ActUseFoodItem.OnEnable = OnEnable
ActUseFoodItem.OnDisable = OnDisable
ActUseFoodItem.ComponentDefine = ComponentDefine
ActUseFoodItem.ComponentDestroy = ComponentDestroy
ActUseFoodItem.DataDefine = DataDefine
ActUseFoodItem.DataDestroy = DataDestroy
return ActUseFoodItem
