local UIHeroSpecialTipView = BaseClass("UIHeroSpecialTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local MinHeight = 80
local MaxHeight = 300
local MarginX = 30
local MarginY = 20
local Screen = CS.UnityEngine.Screen
local ParamData = {
  specialId = 0,
  position = Vector2.zero,
  isWeaponSpecial = false
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  local param = self:GetUserData()
  self.param = param
  local specialId = param.specialId
  self.specialName = GetTableData(TableName.HeroSpecial, specialId, "name")
  self.specialDesc = GetTableData(TableName.HeroSpecial, specialId, "desc")
  self.specialQuality = GetTableData(TableName.HeroSpecial, specialId, "quality")
  local rootRt = self.root.rectTransform
  local deltaX = 0
  if param.deltaX ~= nil then
    deltaX = param.deltaX
  end
  local deltaY = 0
  if param.deltaY ~= nil then
    deltaY = param.deltaY
  end
  self.nameText:SetLocalText(self.specialName)
  local result = ""
  local effectList = GetTableData(TableName.HeroSpecial, specialId, "effect")
  if effectList ~= nil then
    local index = 1
    for k, v in pairs(effectList) do
      local value = ""
      if 0 < v then
        value = "+" .. HeroUtils.GetFormattedPropertyValue(k, v)
      else
        value = HeroUtils.GetFormattedPropertyValue(k, v)
      end
      if index == 1 then
        result = result .. string.format("%s : %s ", Localization:GetString(HeroUtils.GetHeroPropertyNameId(k)), value)
      else
        result = result .. string.format([[

%s : %s ]], Localization:GetString(HeroUtils.GetHeroPropertyNameId(k)), value)
      end
      index = index + 1
    end
  end
  self.descText:SetText(result)
  local contentHeight = self.descText:GetHeight()
  if self.param.isWeaponSpecial then
    self.nameImg:LoadSprite(HeroUtils.GetWeaponSpecialBg(self.specialQuality))
  else
    self.nameImg:LoadSprite(HeroUtils.GetHeroSpecialBgByQuality(self.specialQuality))
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  rootRt.position = param.position + Vector3.New(deltaX, deltaY, 0) * scaleFactor
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
  self.root = self:AddComponent(UIBaseContainer, "Root")
  self.descText = self:AddComponent(UIText, "Root/DescText")
  self.nameText = self:AddComponent(UIText, "Root/Name/Text")
  self.nameImg = self:AddComponent(UIImage, "Root/Name")
end

local function ComponentDestroy(self)
  self.root = nil
  self.descText = nil
  self.nameText = nil
  self.nameImg = nil
end

UIHeroSpecialTipView.Param = Param
UIHeroSpecialTipView.OnCreate = OnCreate
UIHeroSpecialTipView.OnDestroy = OnDestroy
UIHeroSpecialTipView.ComponentDefine = ComponentDefine
UIHeroSpecialTipView.ComponentDestroy = ComponentDestroy
return UIHeroSpecialTipView
