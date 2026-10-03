local base = UIBaseContainer
local ActOwnFoodSlot = BaseClass("ActOwnFoodSlot", base)
local empty_path = "empty"
local food_path = "food"
local foodCount_path = "food/itemParent/item/NumText"
local itemParent_path = "food/itemParent"
local itemBtn_path = "itemBtn"
local itemQuality_path = "food/itemParent/item/ImgQuality"
local itemIcon_path = "food/itemParent/item/ImgIcon"

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
  self.empty = self:AddComponent(UIBaseContainer, empty_path)
  self.food = self:AddComponent(UIBaseContainer, food_path)
  self.foodCount = self:AddComponent(UIText, foodCount_path)
  self.itemParent = self:AddComponent(UIBaseContainer, itemParent_path)
  self.itemBtn = self:AddComponent(UIButton, itemBtn_path)
  self.itemQuality = self:AddComponent(UIImage, itemQuality_path)
  self.itemIcon = self:AddComponent(UIImage, itemIcon_path)
  self.itemIcon.transform:Set_localScale(1, 1, 1)
  self.itemBtn:SetOnClick(function()
    self:OnItemClick()
  end)
end

local function ComponentDestroy(self)
  self.empty = nil
  self.food = nil
  self.foodCount = nil
  self.itemParent = nil
  self.itemBtn = nil
  self.itemQuality = nil
  self.itemIcon = nil
  self.itemId = nil
  self.click = nil
  self.isEmpty = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function ActOwnFoodSlot:SetData(itemId, click)
  self.itemId = itemId
  self.click = click
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  self.itemQuality:LoadSprite(UIUtil.GetItemQualityBg(goods.quality))
  self.itemIcon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  self:RefreshCount()
end

function ActOwnFoodSlot:RefreshCount()
  local item = DataCenter.ItemData:GetItemById(self.itemId)
  self.isEmpty = true
  self.count = 0
  if item then
    self.isEmpty = item.count == 0
    self.itemParent:SetActive(true)
    self.count = item.count
    self.foodCount:SetText(self.count)
  end
  self.empty:SetActive(self.isEmpty)
  if self.isEmpty then
    self.foodCount:SetText(0)
    self.itemIcon:SetColorRGBA255(255, 255, 255, 128)
  else
    self.itemIcon:SetColorRGBA255(255, 255, 255, 255)
  end
end

function ActOwnFoodSlot:AddCount(count)
  self.count = self.count + count
  self.isEmpty = self.count == 0
  self.empty:SetActive(self.isEmpty)
  if self.isEmpty then
    self.foodCount:SetText(0)
    self.itemIcon:SetColorRGBA255(255, 255, 255, 128)
  else
    self.foodCount:SetText(self.count)
    self.itemIcon:SetColorRGBA255(255, 255, 255, 255)
  end
end

function ActOwnFoodSlot:OnItemClick()
  if self.click and self.itemId then
    if not self.isEmpty then
      local seq = CS.DG.Tweening.DOTween.Sequence()
      seq:Append(self.itemIcon.transform:DOScale(Vector3(1.2, 1.2, 1), 0.08333333333333333):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      seq:Append(self.itemIcon.transform:DOScale(Vector3(0.9, 0.9, 1), 0.05):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      seq:Append(self.itemIcon.transform:DOScale(Vector3(1.05, 1.0, 1), 0.06666666666666667):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      seq:Append(self.itemIcon.transform:DOScale(Vector3(1, 1, 1), 0.3):SetEase(CS.DG.Tweening.Ease.InOutQuad))
      local result = self.click(self.itemId)
      if result then
        self.count = self.count - 1
        self.isEmpty = self.count == 0
        self.empty:SetActive(self.isEmpty)
        if self.isEmpty then
          self.foodCount:SetText(0)
          self.itemIcon:SetColorRGBA255(255, 255, 255, 128)
        else
          self.foodCount:SetText(self.count)
          self.itemIcon:SetColorRGBA255(255, 255, 255, 255)
        end
      end
    else
      LWResourceLackUtil:GotoGoodsItemLack(self.itemId, 1)
    end
  end
end

ActOwnFoodSlot.OnCreate = OnCreate
ActOwnFoodSlot.OnDestroy = OnDestroy
ActOwnFoodSlot.OnEnable = OnEnable
ActOwnFoodSlot.OnDisable = OnDisable
ActOwnFoodSlot.ComponentDefine = ComponentDefine
ActOwnFoodSlot.ComponentDestroy = ComponentDestroy
ActOwnFoodSlot.DataDefine = DataDefine
ActOwnFoodSlot.DataDestroy = DataDestroy
return ActOwnFoodSlot
