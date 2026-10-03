local NeedResCell = BaseClass("NeedResCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  resourceType,
  resourceItemId,
  count,
  isRed
}
local item_icon_path = "ResourceIcon"
local num_text_path = "ResourceNum"
local this_path = ""

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.num_shadow = self:AddComponent(UIShadow, num_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.num_text = nil
  self.btn = nil
  self.num_shadow = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  if param.itemId ~= nil then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if goods ~= nil then
      self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    end
  elseif param.resourceType ~= nil then
    self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.resourceType))
  elseif param.resourceItemId ~= nil then
    local resourceItemData = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(param.resourceItemId)
    if resourceItemData ~= nil then
      self.item_icon:LoadSprite(resourceItemData:GetIconPath())
    end
  end
  self.num_text:SetText(string.GetFormattedSeperatorNum(param.count))
  if param.isRed then
    self.num_text:SetColor(Color.New(0.91, 0.26, 0.26, 1))
    self.num_shadow:AllEnable(false)
  else
    self.num_text:SetColor(WhiteColor)
    self.num_shadow:AllEnable(true)
  end
end

local function OnBtnClick(self)
end

NeedResCell.OnCreate = OnCreate
NeedResCell.OnDestroy = OnDestroy
NeedResCell.Param = Param
NeedResCell.OnBtnClick = OnBtnClick
NeedResCell.OnEnable = OnEnable
NeedResCell.OnDisable = OnDisable
NeedResCell.ComponentDefine = ComponentDefine
NeedResCell.ComponentDestroy = ComponentDestroy
NeedResCell.DataDefine = DataDefine
NeedResCell.DataDestroy = DataDestroy
NeedResCell.ReInit = ReInit
return NeedResCell
