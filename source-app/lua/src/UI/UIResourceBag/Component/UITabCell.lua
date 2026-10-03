local UITabCell = BaseClass("UITabCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  resourceType,
  callBack,
  isSelect
}
local icon_path = "Icon"
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
  self.tab_icon = self:AddComponent(UIImage, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.tab_icon = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetSelect(param.isSelect)
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.resourceType)
  end
end

local function SetSelect(self, value)
  if value then
    self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_up"))
    self.icon:LoadSprite(ResourceTabSelectImage[self.param.resourceType])
  else
    self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_tab_down"))
    self.icon:LoadSprite(ResourceTabUnSelectImage[self.param.resourceType])
  end
end

UITabCell.OnCreate = OnCreate
UITabCell.OnDestroy = OnDestroy
UITabCell.Param = Param
UITabCell.OnEnable = OnEnable
UITabCell.OnDisable = OnDisable
UITabCell.ComponentDefine = ComponentDefine
UITabCell.ComponentDestroy = ComponentDestroy
UITabCell.DataDefine = DataDefine
UITabCell.DataDestroy = DataDestroy
UITabCell.ReInit = ReInit
UITabCell.OnBtnClick = OnBtnClick
UITabCell.SetSelect = SetSelect
return UITabCell
