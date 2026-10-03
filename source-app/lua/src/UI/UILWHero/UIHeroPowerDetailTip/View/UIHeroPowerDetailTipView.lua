local UIHeroPowerDetailTipView = BaseClass("UIHeroPowerDetailTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  totalPower = 0,
  propertyPower = 0,
  skillPower = 0,
  equipPower = 0,
  position = Vector2.zero
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.param = param
  local rootRt = self.root.rectTransform
  self.totalPowerText:SetLocalText(151115, param.totalPower)
  self.propertyPowerNameText:SetLocalText(151116)
  self.propertyPowerValueText:SetText("+" .. param.propertyPower)
  self.skillPowerNameText:SetLocalText(151117)
  self.skillPowerValueText:SetText("+" .. param.skillPower)
  self.equipPowerNameText:SetLocalText(151118)
  self.equipPowerValueText:SetText("+" .. param.equipPower)
  self.descText:SetLocalText(151119)
  rootRt.position = param.position
  DOTween.Kill(rootRt)
  rootRt:Set_localScale(0, 0, 0)
  rootRt:DOScale(Vector3.New(1.1, 1.1, 0), 0.1):OnComplete(function()
    rootRt:DOScale(Vector3.one, 0.1)
  end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.root = self:AddComponent(UIBaseContainer, "Root/ImgBg")
  self.totalPowerText = self:AddComponent(UIText, "Root/ImgBg/TotalPowerText")
  self.propertyPower = self:AddComponent(UIText, "Root/ImgBg/PropertyPower")
  self.propertyPowerNameText = self:AddComponent(UIText, "Root/ImgBg/PropertyPower/PropertyPowerNameText")
  self.propertyPowerValueText = self:AddComponent(UIText, "Root/ImgBg/PropertyPower/PropertyPowerValueText")
  self.skillPower = self:AddComponent(UIText, "Root/ImgBg/SkillPower")
  self.skillPowerNameText = self:AddComponent(UIText, "Root/ImgBg/SkillPower/SkillPowerNameText")
  self.skillPowerValueText = self:AddComponent(UIText, "Root/ImgBg/SkillPower/SkillPowerValueText")
  self.equipPower = self:AddComponent(UIText, "Root/ImgBg/EquipPower")
  self.equipPowerNameText = self:AddComponent(UIText, "Root/ImgBg/EquipPower/EquipPowerNameText")
  self.equipPowerValueText = self:AddComponent(UIText, "Root/ImgBg/EquipPower/EquipPowerValueText")
  self.descText = self:AddComponent(UIText, "Root/ImgBg/DescText")
end

local function ComponentDestroy(self)
  self.root = nil
  self.totalPowerText = nil
  self.propertyPower = nil
  self.propertyPowerNameText = nil
  self.propertyPowerValueText = nil
  self.skillPower = nil
  self.skillPowerNameText = nil
  self.skillPowerValueText = nil
  self.equipPower = nil
  self.equipPowerNameText = nil
  self.equipPowerValueText = nil
  self.descText = nil
end

UIHeroPowerDetailTipView.Param = Param
UIHeroPowerDetailTipView.OnCreate = OnCreate
UIHeroPowerDetailTipView.OnDestroy = OnDestroy
UIHeroPowerDetailTipView.ComponentDefine = ComponentDefine
UIHeroPowerDetailTipView.ComponentDestroy = ComponentDestroy
return UIHeroPowerDetailTipView
