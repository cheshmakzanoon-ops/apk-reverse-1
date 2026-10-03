local AllyDrillTipsItemComponent = BaseClass("AllyDrillTipsItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.rawImgBanner = self:AddComponent(UIRawImage, "banner")
  self.textLabelNum = self:AddComponent(UITextMeshProUGUIEx, "ItemLabel/labelNum")
  self.textDesc = self:AddComponent(UITextMeshProUGUIEx, "desc")
end

local function ComponentDestroy(self)
  self.rawImgBanner = nil
  self.textLabelNum = nil
  self.textDesc = nil
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

function AllyDrillTipsItemComponent:Init(index, banner, desc)
  if not string.IsNullOrEmpty(banner) then
    self.rawImgBanner:LoadSprite(banner)
  end
  self.textLabelNum:SetText(index)
  self.textDesc:SetLocalText(desc)
end

AllyDrillTipsItemComponent.OnCreate = OnCreate
AllyDrillTipsItemComponent.OnDestroy = OnDestroy
AllyDrillTipsItemComponent.OnEnable = OnEnable
AllyDrillTipsItemComponent.OnDisable = OnDisable
AllyDrillTipsItemComponent.ComponentDefine = ComponentDefine
AllyDrillTipsItemComponent.ComponentDestroy = ComponentDestroy
AllyDrillTipsItemComponent.DataDefine = DataDefine
AllyDrillTipsItemComponent.DataDestroy = DataDestroy
AllyDrillTipsItemComponent.OnAddListener = OnAddListener
AllyDrillTipsItemComponent.OnRemoveListener = OnRemoveListener
return AllyDrillTipsItemComponent
