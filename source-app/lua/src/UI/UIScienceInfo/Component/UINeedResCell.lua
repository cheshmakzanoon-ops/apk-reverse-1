local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
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
  self.num_shadow = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.numText = nil
  self.numColor = nil
end

local function DataDestroy(self)
  self.param = nil
  self.numText = nil
  self.numColor = nil
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
  self.num_text:SetText(string.GetFormattedSpecial(param.count))
  if param.isRed then
    self.num_text:SetColor(RedColor)
    self.num_shadow:AllEnable(false)
  else
    self.num_text:SetColor(WhiteColor)
    self.num_shadow:AllEnable(true)
  end
end

local function OnBtnClick(self)
  if not self.param.isRed then
    return
  end
  if self.param.resourceType ~= nil then
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.resType = self.param.resourceType
    param.targetNum = self.param.count
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
  elseif self.param.resourceItemId ~= nil then
    local name = LocalController:instance():getStrValue(TableName.Aps_Resource_Item, self.param.resourceItemId, "name")
    local desc = LocalController:instance():getStrValue(TableName.Aps_Resource_Item, self.param.resourceItemId, "desc")
    self:ShowDesc(name, desc)
  elseif self.param.itemId ~= nil and self.param.isRed then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if itemTemplate then
      if itemTemplate.price > 0 then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.itemId = self.param.itemId
        param.targetNum = self.param.count
        table.insert(lackTab, param)
        GoToResLack.GoToItemResLackList(lackTab)
      else
        UIUtil.ShowTips(Localization:GetString("126002", DataCenter.ItemTemplateManager:GetName(self.param.itemId)))
      end
    end
  end
end

local function ShowDesc(self, name, desc)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btn.transform.position + Vector3.New(-20, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.title = Localization:GetString(name)
  param.content = Localization:GetString(desc)
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UINeedResCell.OnCreate = OnCreate
UINeedResCell.OnDestroy = OnDestroy
UINeedResCell.Param = Param
UINeedResCell.OnBtnClick = OnBtnClick
UINeedResCell.OnEnable = OnEnable
UINeedResCell.OnDisable = OnDisable
UINeedResCell.ComponentDefine = ComponentDefine
UINeedResCell.ComponentDestroy = ComponentDestroy
UINeedResCell.DataDefine = DataDefine
UINeedResCell.DataDestroy = DataDestroy
UINeedResCell.ReInit = ReInit
UINeedResCell.ShowDesc = ShowDesc
return UINeedResCell
