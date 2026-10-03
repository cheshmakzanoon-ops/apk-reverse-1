local FormationHeroSkillItem = BaseClass("FormationHeroSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local skill_icon_path = "SkillObj/ImgIcon1"
local skill_unlock_path = "SkillObj/ImgLock1"
local skill_lock_path = "Img"
local skill_level_path = "SkillObj/TextLv1"
local skill_name_path = "TextName"
local btn_path = ""
local UIHeroSkillTipView = require("UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView")

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
  self.skill_lock = self:AddComponent(UIBaseContainer, skill_lock_path)
  self.skill_unlock = self:AddComponent(UIImage, skill_unlock_path)
  self.skill_icon = self:AddComponent(UIImage, skill_icon_path)
  self.skill_level = self:AddComponent(UIText, skill_level_path)
  self.skill_name = self:AddComponent(UIText, skill_name_path)
  self._add_btn = self:AddComponent(UIButton, btn_path)
  self._add_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.skill_lock = nil
  self.skill_unlock = nil
  self.skill_icon = nil
  self.skill_level = nil
  self.skill_name = nil
  self._add_btn = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, skillId, skillLv, index)
  self.skillId = skillId
  self.skillLv = skillLv
  self.index = index
  local icon = HeroUtils.GetSkillIcon(skillId)
  if self.skillLv > 0 then
    self.skill_unlock:SetActive(true)
    self.skill_lock:SetActive(false)
  else
    self.skill_unlock:SetActive(false)
    self.skill_lock:SetActive(true)
  end
  self.skill_level:SetText(self.skillLv)
  self.skill_name:SetText(Localization:GetString(GetTableData(TableName.SkillTab, skillId, "name")))
  self.skill_icon:LoadSprite(icon)
end

local function OnBtnClick(self)
  if self.skillId ~= nil and self.skillLv ~= nil then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self._add_btn.transform.position + Vector3.New(30, 0, 0) * scaleFactor
    local screenPos = PosConverse.WorldToScreenPos(position)
    local dir = screenPos.y < Screen.height / 2 and UIHeroSkillTipView.Direction.ABOVE or UIHeroSkillTipView.Direction.BELOW
    local param = UIHeroSkillTipView.Param.New()
    param.content = Localization:GetString("150155")
    param.dir = dir
    param.skillId = self.skillId
    param.skillLevel = self.skillLv
    param.notShowUnlock = true
    param.pivot = 0.5 + (self.index - 3) * 0.2
    param.position = position + Vector3.New(0, dir == UIHeroSkillTipView.Direction.ABOVE and 35 or -30, 0) * scaleFactor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, {anim = false}, param)
  end
end

FormationHeroSkillItem.OnCreate = OnCreate
FormationHeroSkillItem.OnDestroy = OnDestroy
FormationHeroSkillItem.OnBtnClick = OnBtnClick
FormationHeroSkillItem.OnEnable = OnEnable
FormationHeroSkillItem.OnDisable = OnDisable
FormationHeroSkillItem.ComponentDefine = ComponentDefine
FormationHeroSkillItem.ComponentDestroy = ComponentDestroy
FormationHeroSkillItem.DataDefine = DataDefine
FormationHeroSkillItem.DataDestroy = DataDestroy
FormationHeroSkillItem.ReInit = ReInit
return FormationHeroSkillItem
