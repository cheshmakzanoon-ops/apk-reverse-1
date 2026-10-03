local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemFish = BaseClass("UICommonResItemFish", UICommonResItemBase)
local base = UICommonResItemBase

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.item_icon_rawImage = self:TryAddComponent(UIRawImage, "clickBtn/ItemIconRawImage")
end

local function ComponentDestroy(self)
  self.item_icon_rawImage.transform.parent:Find("ItemIcon").gameObject:SetActive(true)
  self.item_icon_rawImage:SetActive(false)
  self.item_icon_rawImage = nil
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnReInit(self)
  if self.param.isFish then
    self.item_icon_rawImage:SetActive(true)
    self.item_icon:SetActive(false)
    local meta = DataCenter.FishMetaManager:GetMeta(self.param.itemId)
    if not string.IsNullOrEmpty(meta.pic) then
      self.item_icon_rawImage:LoadSpriteAsyncWithCallback(meta.pic, function()
        if self.item_icon_rawImage then
          self.item_icon_rawImage:SetNativeSize()
        end
      end)
    end
    local scale = meta.collect_proportion or 1
    self.item_icon_rawImage:SetLocalScaleXYZ(scale * 0.36, scale * 0.36, scale * 0.36)
    self.img_recapture_mark:SetActive(self.param.isConfiscate)
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(3))
  else
    self.item_icon:SetActive(true)
    self.item_icon_rawImage:SetActive(false)
  end
end

UICommonResItemFish.OnCreate = OnCreate
UICommonResItemFish.OnDestroy = OnDestroy
UICommonResItemFish.ComponentDefine = ComponentDefine
UICommonResItemFish.ComponentDestroy = ComponentDestroy
UICommonResItemFish.DataDefine = DataDefine
UICommonResItemFish.DataDestroy = DataDestroy
UICommonResItemFish.OnReInit = OnReInit
return UICommonResItemFish
