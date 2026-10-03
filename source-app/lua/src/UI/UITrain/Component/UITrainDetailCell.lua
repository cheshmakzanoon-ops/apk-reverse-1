local UITrainDetailCell = BaseClass("UITrainDetailCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  detailType,
  callBack,
  template
}
local this_path = ""
local detail_name_path = "DetailName"
local detail_icon_path = "DetailIcon"
local detail_value_path = "DetailValue"
local detail_add_value_path = "DetailValue/DetailAddValue"

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
  self.detail_icon = self:AddComponent(UIImage, detail_icon_path)
  self.detail_name = self:AddComponent(UIText, detail_name_path)
  self.detail_value = self:AddComponent(UIText, detail_value_path)
  self.detail_add_value = self:AddComponent(UIText, detail_add_value_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.detail_icon = nil
  self.detail_name = nil
  self.detail_value = nil
  self.detail_add_value = nil
  self.btn = nil
end

local function DataDefine(self)
  self.param = {}
  self.clickDes = ""
end

local function DataDestroy(self)
  self.param = nil
  self.clickDes = nil
end

local function ReInit(self, param)
  self.param = param
  self.detail_icon:LoadSprite(UITrainDetailTypeIcon[param.detailType])
  self:SetDetailInfo()
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.clickDes, self.transform.position)
  end
end

local function SetDetailInfo(self)
  if self.param.detailType == UITrainDetailType.Attack then
    self.detail_name:SetLocalText(GameDialogDefine.ATTACK)
    self.detail_value:SetText(self.param.template.attack)
    self.detail_add_value:SetText(self:GetAddText(self.param.template:GetAttackAddValue()))
    self.clickDes = Localization:GetString(GameDialogDefine.ATTACK_CLICK_DES)
  elseif self.param.detailType == UITrainDetailType.Defense then
    self.detail_name:SetLocalText(GameDialogDefine.DEFENSE)
    self.detail_value:SetText(self.param.template.defence)
    self.detail_add_value:SetText(self:GetAddText(self.param.template:GetDefenceAddValue()))
    self.clickDes = Localization:GetString(GameDialogDefine.DEFENSE_CLICK_DES)
  elseif self.param.detailType == UITrainDetailType.Blood then
    self.detail_name:SetLocalText(GameDialogDefine.BLOOD)
    self.detail_add_value:SetText(self:GetAddText(self.param.template:GetHealthAddValue()))
    self.detail_value:SetText(self.param.template.health)
    self.clickDes = Localization:GetString(GameDialogDefine.BLOOD_CLICK_DES)
  elseif self.param.detailType == UITrainDetailType.Speed then
    self.detail_name:SetLocalText(GameDialogDefine.SPEED)
    self.detail_value:SetText(self:GetAddText(self.param.template:GetSpeedValue()))
    self.detail_add_value:SetText("")
    self.clickDes = Localization:GetString(GameDialogDefine.SPEED_CLICK_DES)
  elseif self.param.detailType == UITrainDetailType.Load then
    self.detail_name:SetLocalText(GameDialogDefine.LOAD)
    self.detail_value:SetText(self.param.template.load)
    self.detail_add_value:SetText(self:GetAddText(self.param.template:GetLoadAddValue()))
    self.clickDes = Localization:GetString(GameDialogDefine.LOAD_CLICK_DES)
  elseif self.param.detailType == UITrainDetailType.Power then
    self.detail_name:SetLocalText(GameDialogDefine.POWER)
    self.detail_value:SetText(self.param.template.power)
    self.detail_add_value:SetText(self:GetAddText(self.param.template:GetAttackAddValue()))
    self.clickDes = Localization:GetString(GameDialogDefine.POWER_CLICK_DES)
  end
end

local function GetAddText(self, value)
  if 0 < value then
    return "+" .. value
  elseif value < 0 then
    return value
  else
    return ""
  end
  return ""
end

UITrainDetailCell.OnCreate = OnCreate
UITrainDetailCell.OnDestroy = OnDestroy
UITrainDetailCell.Param = Param
UITrainDetailCell.OnBtnClick = OnBtnClick
UITrainDetailCell.OnEnable = OnEnable
UITrainDetailCell.OnDisable = OnDisable
UITrainDetailCell.ComponentDefine = ComponentDefine
UITrainDetailCell.ComponentDestroy = ComponentDestroy
UITrainDetailCell.DataDefine = DataDefine
UITrainDetailCell.DataDestroy = DataDestroy
UITrainDetailCell.ReInit = ReInit
UITrainDetailCell.SetDetailInfo = SetDetailInfo
UITrainDetailCell.GetAddText = GetAddText
return UITrainDetailCell
