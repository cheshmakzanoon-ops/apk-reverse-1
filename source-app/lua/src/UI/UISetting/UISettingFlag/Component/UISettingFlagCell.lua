local UISettingFlagCell = BaseClass("UISettingFlagCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  name
}
local this_path = ""
local des_path = "Name"
local img_path = "FlagImg"

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
  self.img = self:AddComponent(UIImage, img_path)
  self.des = self:AddComponent(UIText, des_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.img = nil
  self.des = nil
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
  local template = DataCenter.NationTemplateManager:GetNationTemplate(param.name)
  if param.name ~= nil then
    self.des:SetText(template.flag)
    self.img:LoadSprite(template:GetNationFlagPath())
  end
end

local function OnBtnClick(self)
  UIUtil.ShowMessage(Localization:GetString("390058"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    SFSNetwork.SendMessage(MsgDefines.SetCountryFlag, {
      flag = self.param.name
    })
    self.view.ctrl:CloseSelf()
  end)
end

UISettingFlagCell.OnCreate = OnCreate
UISettingFlagCell.OnDestroy = OnDestroy
UISettingFlagCell.Param = Param
UISettingFlagCell.OnEnable = OnEnable
UISettingFlagCell.OnDisable = OnDisable
UISettingFlagCell.ComponentDefine = ComponentDefine
UISettingFlagCell.ComponentDestroy = ComponentDestroy
UISettingFlagCell.DataDefine = DataDefine
UISettingFlagCell.DataDestroy = DataDestroy
UISettingFlagCell.ReInit = ReInit
UISettingFlagCell.OnBtnClick = OnBtnClick
return UISettingFlagCell
