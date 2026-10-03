local UIScienceTopBtnCell = BaseClass("UIScienceTopBtnCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  btnType
}
local icon_path = "Icon"
local count_path = "CountText"
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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.count = self:AddComponent(UIText, count_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.count = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.icon:LoadSprite(self:GetTopBtnImage(self.param.btnType))
  self:RefreshCount()
end

local function RefreshCount(self)
  self.count:SetText(self:GetTopBtnCount(self.param.btnType))
end

local function OnBtnClick(self)
  if self.param.btnType == UIScienceTopBtnType.Electricity then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, ResourceType.Electricity)
  elseif self.param.btnType == UIScienceTopBtnType.Money then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, ResourceType.Food)
  elseif self.param.btnType == UIScienceTopBtnType.Gold then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, ResourceType.Gold)
  end
end

local function GetTopBtnCount(self, topBtn)
  if topBtn == UIScienceTopBtnType.Electricity then
    return LuaEntry.Resource:GetCntByResType(ResourceType.Electricity)
  elseif topBtn == UIScienceTopBtnType.Money then
    return LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  elseif topBtn == UIScienceTopBtnType.Gold then
    return LuaEntry.Player.gold
  end
end

local function GetTopBtnImage(self, topBtn)
  if topBtn == UIScienceTopBtnType.Electricity then
    return DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Electricity)
  elseif topBtn == UIScienceTopBtnType.Money then
    return DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Food)
  elseif topBtn == UIScienceTopBtnType.Gold then
    return DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
  end
end

UIScienceTopBtnCell.OnCreate = OnCreate
UIScienceTopBtnCell.OnDestroy = OnDestroy
UIScienceTopBtnCell.Param = Param
UIScienceTopBtnCell.OnEnable = OnEnable
UIScienceTopBtnCell.OnDisable = OnDisable
UIScienceTopBtnCell.ComponentDefine = ComponentDefine
UIScienceTopBtnCell.ComponentDestroy = ComponentDestroy
UIScienceTopBtnCell.DataDefine = DataDefine
UIScienceTopBtnCell.DataDestroy = DataDestroy
UIScienceTopBtnCell.ReInit = ReInit
UIScienceTopBtnCell.RefreshCount = RefreshCount
UIScienceTopBtnCell.OnBtnClick = OnBtnClick
UIScienceTopBtnCell.GetTopBtnCount = GetTopBtnCount
UIScienceTopBtnCell.GetTopBtnImage = GetTopBtnImage
return UIScienceTopBtnCell
