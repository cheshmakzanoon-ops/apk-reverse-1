local base = UIBaseContainer
local SeasonFarmerBuildLevelItem = BaseClass("SeasonFarmerBuildLevelItem", base)
local TextTitle_path = "ItemNameInfo"
local TextDes_path = "ItemPowerInfo"
local Icon_path = "ItemIcon"
local BtnGoto_path = "GotoBtn"

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
  self.TextTitle = self:AddComponent(UIText, TextTitle_path)
  self.TextDes = self:AddComponent(UIText, TextDes_path)
  self.Icon = self:AddComponent(UIImage, Icon_path)
  self.BtnGoto = self:AddComponent(UIButton, BtnGoto_path)
  self.BtnGoto:SetOnClick(BindCallback(self, self.OnBtnGotoClick))
end

local function ComponentDestroy(self)
  self.TextTitle = nil
  self.TextDes = nil
  self.Icon = nil
  self.BtnGoto = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function ReInit(self, index, data)
  if data == nil then
    return
  end
  self.data = data
  self.TextTitle:SetLocalText(data.title)
  self.TextDes:SetLocalText(data.desc)
  self.Icon:LoadSprite(data.icon)
end

local function OnBtnGotoClick(self)
  if self.data == nil or self.data.gotoFunc == nil then
    return
  end
  self.data.gotoFunc()
end

SeasonFarmerBuildLevelItem.OnCreate = OnCreate
SeasonFarmerBuildLevelItem.OnDestroy = OnDestroy
SeasonFarmerBuildLevelItem.OnEnable = OnEnable
SeasonFarmerBuildLevelItem.OnDisable = OnDisable
SeasonFarmerBuildLevelItem.ComponentDefine = ComponentDefine
SeasonFarmerBuildLevelItem.ComponentDestroy = ComponentDestroy
SeasonFarmerBuildLevelItem.DataDefine = DataDefine
SeasonFarmerBuildLevelItem.DataDestroy = DataDestroy
SeasonFarmerBuildLevelItem.ReInit = ReInit
SeasonFarmerBuildLevelItem.OnBtnGotoClick = OnBtnGotoClick
return SeasonFarmerBuildLevelItem
