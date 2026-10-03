local UISkillCell = BaseClass("UISkillCell", UIBaseContainer)
local base = UIBaseContainer
local Param = DataClass("Param", ParamData)
local ParamData = {
  iconName,
  index,
  callBack
}
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
  self.item_icon = self:AddComponent(UIImage, this_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self:SetItemIconImage(param.iconName)
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param.index, self.transform.position)
  end
end

local function SetItemIconImage(self, imageName)
  self.item_icon:LoadSprite(imageName)
end

UISkillCell.OnCreate = OnCreate
UISkillCell.OnDestroy = OnDestroy
UISkillCell.Param = Param
UISkillCell.OnBtnClick = OnBtnClick
UISkillCell.OnEnable = OnEnable
UISkillCell.OnDisable = OnDisable
UISkillCell.ComponentDefine = ComponentDefine
UISkillCell.ComponentDestroy = ComponentDestroy
UISkillCell.DataDefine = DataDefine
UISkillCell.DataDestroy = DataDestroy
UISkillCell.ReInit = ReInit
UISkillCell.SetItemIconImage = SetItemIconImage
return UISkillCell
