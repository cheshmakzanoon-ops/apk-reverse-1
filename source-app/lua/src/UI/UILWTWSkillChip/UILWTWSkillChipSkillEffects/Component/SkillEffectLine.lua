local SkillEffectLine = BaseClass("SkillEffectLine", UIBaseContainer)
local base = UIBaseContainer
local star_path = "star"
local star_txt_path = "star/starTxt"
local effect_txt_path = "effectTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.star = self:AddComponent(UIImage, star_path)
  self.starTxt = self:AddComponent(UIText, star_txt_path)
  self.effectTxt = self:AddComponent(UIText, effect_txt_path)
  self.bg = self:AddComponent(UIImage, "")
end

local function ComponentDestroy(self)
end

local function SetData(self, effectText, index, bgType)
  if index <= 5 then
    self.star:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star02.png")
  else
    self.star:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lrb_wurenjixinpian_zhujiemian_star01.png")
  end
  self.starTxt:SetText(index)
  self.effectTxt:SetText(effectText)
  if bgType == 1 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_jihuo01.png")
    self.bg:SetColorRGBA255(255, 255, 255, 255)
    self.star:SetColorRGBA255(255, 255, 255, 255)
    self.starTxt:SetColorRGBA255(255, 255, 255, 255)
    self.effectTxt:SetColorRGBA255(42, 40, 48, 255)
  elseif bgType == 2 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_jihuo02.png")
    self.bg:SetColorRGBA255(255, 255, 255, 255)
    self.star:SetColorRGBA255(255, 255, 255, 255)
    self.starTxt:SetColorRGBA255(255, 255, 255, 255)
    self.effectTxt:SetColorRGBA255(42, 40, 48, 255)
  elseif bgType == 3 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_4xp.png")
    self.bg:SetColorRGBA255(239, 234, 234, 255)
    self.star:SetColorRGBA255(255, 255, 255, 127)
    self.starTxt:SetColorRGBA255(255, 255, 255, 178)
    self.effectTxt:SetColorRGBA255(42, 40, 48, 178)
  elseif bgType == 4 then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_common_4xp.png")
    self.bg:SetColorRGBA255(235, 226, 195, 255)
    self.star:SetColorRGBA255(255, 255, 255, 127)
    self.starTxt:SetColorRGBA255(255, 255, 255, 178)
    self.effectTxt:SetColorRGBA255(42, 40, 48, 178)
  end
end

SkillEffectLine.OnCreate = OnCreate
SkillEffectLine.OnDestroy = OnDestroy
SkillEffectLine.OnEnable = OnEnable
SkillEffectLine.OnDisable = OnDisable
SkillEffectLine.DataDefine = DataDefine
SkillEffectLine.DataDestroy = DataDestroy
SkillEffectLine.ComponentDefine = ComponentDefine
SkillEffectLine.ComponentDestroy = ComponentDestroy
SkillEffectLine.SetData = SetData
return SkillEffectLine
