local UIHeroCellBigPiece = BaseClass("UIHeroCellBigPiece", UIBaseContainer)
local base = UIBaseContainer
local purple_effect_path = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_suipian_jiqi_zise.prefab"
local orange_effect_path = "Assets/_Art/Effect/prefab/ui/VFX_ui_hero_suipian_jiqi_chengse.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.itemId = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.itemCover = self:AddComponent(UIImage, "ImgQualityPieceCover")
  self.itemContainer = self:AddComponent(UIBaseContainer, "HeroDebris")
  self.item_slider = self:AddComponent(UISlider, "HeroDebris/ItemSlider")
  self.item_slider_progress = self:AddComponent(UISlider, "HeroDebris/ItemSlider/Fill Area")
  self.itemCover:SetActive(false)
  self.itemIcon = self:AddComponent(UIImage, "HeroDebris/ImgHeroDebrisBg/ImgHeroDebrisIcon")
  self.itemNumText = self:AddComponent(UIText, "HeroDebris/PieceNumText")
  self.itemEnough = self:AddComponent(UIBaseContainer, "HeroDebris/ItemEnough")
  self.itemEnoughText = self:AddComponent(UIText, "HeroDebris/ItemEnough/ItemEnoughText")
  self.itemEnough:SetActive(false)
  self.itemEnoughText:SetLocalText(120204)
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
end

local function SetData(self, param)
  self.param = param
  self:RefreshView()
end

local function RefreshView(self)
  local itemCount = DataCenter.ItemData:GetItemCount(self.param)
  local itemNeed = HeroUtils.GetJigsawCost(self.param)
  local percent = itemCount / itemNeed
  self.itemNumText:SetLocalText(150033, itemCount, itemNeed)
  percent = math.max(0, math.min(1, percent))
  self.item_slider:SetValue(percent)
  self.item_slider_progress:SetActive(0 < itemCount)
  self.itemCover:SetActive(itemCount < itemNeed)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param)
  self.itemIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.param))
  if itemCount >= itemNeed then
    self:LoadItemExchangeEffect(goods.color)
  else
    self:RemoveItemExchangeEffect()
  end
  self.itemEnough:SetActive(itemCount >= itemNeed)
end

local function LoadItemExchangeEffect(self, color)
  if self.effectRequest ~= nil then
    return
  end
  local effectPath = ""
  if color == ItemColor.PURPLE then
    effectPath = purple_effect_path
  elseif color == ItemColor.ORANGE then
    effectPath = orange_effect_path
  end
  if string.IsNullOrEmpty(effectPath) then
    return
  end
  self.effectRequest = self:GameObjectInstantiateAsync(effectPath, function(request)
    if request.isError then
      return
    end
    self.effectRequest.gameObject.name = "ItemExchangeEffect"
    self.effectRequest.gameObject.transform.parent = self.transform
    self.effectRequest.gameObject.transform.localPosition = ResetPosition
    self.effectRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  end)
end

local function RemoveItemExchangeEffect(self)
  if self.effectRequest ~= nil then
    self.effectRequest:Destroy()
  end
  self.effectRequest = nil
end

UIHeroCellBigPiece.OnCreate = OnCreate
UIHeroCellBigPiece.OnDestroy = OnDestroy
UIHeroCellBigPiece.ComponentDefine = ComponentDefine
UIHeroCellBigPiece.ComponentDestroy = ComponentDestroy
UIHeroCellBigPiece.SetData = SetData
UIHeroCellBigPiece.RefreshView = RefreshView
UIHeroCellBigPiece.LoadItemExchangeEffect = LoadItemExchangeEffect
UIHeroCellBigPiece.RemoveItemExchangeEffect = RemoveItemExchangeEffect
return UIHeroCellBigPiece
