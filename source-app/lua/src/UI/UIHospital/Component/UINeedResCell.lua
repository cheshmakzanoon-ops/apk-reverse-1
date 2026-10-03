local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  resourceType,
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
  self.num_text_shadow = self:AddComponent(UIShadow, num_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.num_text = nil
  self.num_text_shadow = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.isRed = nil
end

local function DataDestroy(self)
  self.param = nil
  self.isRed = nil
end

local function ReInit(self, param)
  self.param = param
  self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.resourceType))
  self.num_text:SetText(string.GetFormattedSeperatorNum(param.count))
  self.isRed = nil
  self:RefreshColor(param.isRed)
end

local function RefreshColor(self, isRed)
  if self.isRed ~= isRed then
    self.isRed = isRed
    if isRed then
      self.num_text:SetColor(RedColor)
      self.num_text_shadow:AllEnable(false)
    else
      self.num_text:SetColor(WhiteColor)
      self.num_text_shadow:AllEnable(true)
    end
  end
end

local function OnBtnClick(self)
  if self.isRed then
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.resType = self.param.resourceType
    param.targetNum = self.param.count
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
  elseif self.param.resourceType ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, {anim = true}, self.param.resourceType)
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
UINeedResCell.RefreshColor = RefreshColor
return UINeedResCell
