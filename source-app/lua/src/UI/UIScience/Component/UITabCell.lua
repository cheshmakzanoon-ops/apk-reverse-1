local UITabCell = BaseClass("UITabCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  scienceTab,
  callBack,
  isSelect
}
local icon_path = "TabIcon"
local gray_path = "GrayGo"
local this_path = ""
local select_path = "SelectImage"
local SelectScale = Vector3.New(1.2, 1.2, 1)

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
  self.gray = self:AddComponent(UIBaseContainer, gray_path)
  self.select = self:AddComponent(UIImage, select_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.btn = nil
  self.gray = nil
  self.select = nil
end

local function DataDefine(self)
  self.param = {}
  self.grayActive = nil
  self.selectActive = nil
end

local function DataDestroy(self)
  self.param = nil
  self.grayActive = nil
  self.selectActive = nil
end

local function ReInit(self, param)
  self.param = param
  local template = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(param.scienceTab)
  if template ~= nil then
    self:SetIconImage(template.icon)
  end
  if param.isSelect then
    self:SetSelect(true)
    self:OnBtnClick()
  else
    self:SetSelect(false)
  end
end

local function SetGrayActive(self, value)
  if self.grayActive ~= value then
    self.grayActive = value
    self.gray.gameObject:SetActive(value)
  end
end

local function SetSelectActive(self, value)
  if self.selectActive ~= value then
    self.selectActive = value
    self.select.gameObject:SetActive(value)
  end
end

local function SetIconImage(self, imageName)
  self.icon:LoadSprite(imageName)
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.scienceTab)
  end
end

local function SetSelect(self, value)
  if value then
    self:SetSelectActive(true)
    self:SetGrayActive(false)
    self:SetScale(SelectScale)
  else
    self:SetSelectActive(false)
    self:SetGrayActive(true)
    self:SetScale(ResetScale)
  end
end

local function SetScale(self, value)
  if self.scale ~= value then
    self.scale = value
    self.icon.transform.localScale = value
  end
end

UITabCell.OnCreate = OnCreate
UITabCell.OnDestroy = OnDestroy
UITabCell.Param = Param
UITabCell.SetGrayActive = SetGrayActive
UITabCell.OnEnable = OnEnable
UITabCell.OnDisable = OnDisable
UITabCell.ComponentDefine = ComponentDefine
UITabCell.ComponentDestroy = ComponentDestroy
UITabCell.DataDefine = DataDefine
UITabCell.DataDestroy = DataDestroy
UITabCell.ReInit = ReInit
UITabCell.SetIconImage = SetIconImage
UITabCell.OnBtnClick = OnBtnClick
UITabCell.SetSelect = SetSelect
UITabCell.SetSelectActive = SetSelectActive
UITabCell.SetScale = SetScale
return UITabCell
