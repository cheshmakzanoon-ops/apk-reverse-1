local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  itemId,
  resourceType,
  count,
  isRed
}
local item_icon_path = "Common_icon_cp"
local num_text_path = "Common_icon_cp/content_ui_new"
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
end

local function DataDefine(self)
  self.param = {}
  self.numColor = nil
end

local function DataDestroy(self)
  self.param = nil
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
  end
  self.num_text:SetText(string.GetFormattedSeperatorNum(param.count))
  if param.isRed then
    self:SetNumColor(RedColor)
  else
    self:SetNumColor(WhiteColor)
  end
end

local function OnBtnClick(self)
  if self.param.isRed then
    if self.param.itemId ~= nil then
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
    else
      local lackTab = {}
      local param = {}
      param.type = ResLackType.Res
      param.resType = self.param.resourceType
      param.targetNum = self.param.count
      table.insert(lackTab, param)
      GoToResLack.GoToItemResLackList(lackTab)
    end
  elseif self.param.resourceType ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, {anim = true}, self.param.resourceType)
  elseif self.param.itemId ~= nil then
    UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
  end
end

local function SetNumColor(self, value)
  if self.numColor ~= value then
    self.numColor = value
    self.num_text:SetColor(value)
  end
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
UINeedResCell.SetNumColor = SetNumColor
return UINeedResCell
