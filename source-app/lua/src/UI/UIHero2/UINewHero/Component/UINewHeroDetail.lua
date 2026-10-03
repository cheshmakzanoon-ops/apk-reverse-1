local UINewHeroDetail = BaseClass("UINewHeroDetail", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIHeroMilitaryRankIcon = require("UI.UIHero2.UIHeroInfo.Component.UIHeroMilitaryRankIcon")
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.levelBg = self:AddComponent(UIBaseContainer, "TopNode/levelBg")
  self.textTitleLevel = self:AddComponent(UIText, "TopNode/levelBg/TextTitleLevel")
  self.textCurLevel = self:AddComponent(UIText, "TopNode/levelBg/TextTitleLevel/TextCurLevel")
  self.textExp = self:AddComponent(UIText, "TopNode/levelBg/SliderExp/TextValueExp")
  self.sliderExp = self:AddComponent(UISlider, "TopNode/levelBg/SliderExp")
  self.btnUpgrade = self:AddComponent(UIButton, "TopNode/levelBg/BtnUpgrade")
  self.textValueAttack = self:AddComponent(UIText, "TopNode/NodeAttrAttack/TextValueAttack")
  self.textValueDefence = self:AddComponent(UIText, "TopNode/NodeAttrDefence/TextValueDefence")
  self.textValueArmy = self:AddComponent(UIText, "TopNode/NodeAttrArmy/TextValueArmy")
  self.btnAtk = self:AddComponent(UIButton, "TopNode/NodeAttrAttack")
  self.btnDef = self:AddComponent(UIButton, "TopNode/NodeAttrDefence")
  self.btnArmy = self:AddComponent(UIButton, "TopNode/NodeAttrArmy")
  self.btnAtk:SetOnClick(BindCallback(self, self.OnBtnAtkClick))
  self.btnDef:SetOnClick(BindCallback(self, self.OnBtnDefClick))
  self.btnArmy:SetOnClick(BindCallback(self, self.OnBtnArmyClick))
  self.textTitleSkill = self:AddComponent(UIText, "skillBg/TextTitleSkill")
  self.btnSkills = {}
  for k = 1, HeroUtils.SKILL_CNT_MAX do
    local nodeBtn = self:AddComponent(UIButton, "skillBg/SkillContent/Skill" .. k)
    nodeBtn:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnBtnSkillClick(k)
    end)
    local imgIcon = self:AddComponent(UIImage, "skillBg/SkillContent/Skill" .. k .. "/ImgIcon" .. k)
    local textLevel = self:AddComponent(UIText, "skillBg/SkillContent/Skill" .. k .. "/TextLv" .. k)
    local imgLvBg = self:AddComponent(UIText, "skillBg/SkillContent/Skill" .. k .. "/ImgLvBg" .. k)
    local imgLock = self:AddComponent(UIImage, "skillBg/SkillContent/Skill" .. k .. "/ImgLock" .. k)
    local nodeEffect = self:AddComponent(UIBaseContainer, "skillBg/SkillContent/Skill" .. k .. "/NodeEffect" .. k)
    table.insert(self.btnSkills, {
      btn = nodeBtn,
      icon = imgIcon,
      lvBg = imgLvBg,
      lock = imgLock,
      textLv = textLevel,
      nodeFx = nodeEffect
    })
  end
  self.textTitleLevel:SetLocalText(100082)
  self.textTitleSkill:SetLocalText(150106)
  self.heroStar = self:AddComponent(UIHeroStars, "TopNode/starBg/UIHeroStars1")
  self.heroDebrisIcon = self:AddComponent(UIImage, "TopNode/starBg/UIHeroDebrisIcon")
  self.heroStarBg = self:AddComponent(UIBaseContainer, "TopNode/starBg")
end

local function ComponentDestroy(self)
end

local function InitData(self, heroUuid)
  self.heroUuid = heroUuid
  self:RefreshView()
end

local function RefreshView(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self.heroData = heroData
  local level = heroData.level
  local maxLevel = heroData:GetCurMaxLevel()
  local totalExp = HeroUtils.GetLevelUpNeedExp(level)
  local curExp = heroData.exp
  local atk = heroData.atk
  local def = heroData.def
  self.textCurLevel:SetText(level)
  local percent = curExp / totalExp
  if 1 < percent then
    percent = 1
  end
  self.textExp:SetText(string.format("%s/%s", curExp, totalExp))
  self.sliderExp:SetValue(percent)
  self.textValueAttack:SetText(atk)
  self.textValueDefence:SetText(def)
  self.textValueArmy:SetText(HeroUtils.GetArmyLimit(level, heroData:GetRank(), heroData.rarity, heroData.heroId, heroData.quality))
  local param = {}
  param.showStarNum = self.heroData.quality
  param.maxStarNum = HeroUtils.GetMaxStarLevel(self.heroData.heroId)
  param.progressType = UIHeroStarProgressType.UIHeroStarProgressType_Block
  param.showBG = true
  self.heroStar:SetData(param)
  local heroDebrisId = HeroUtils.GetHeroDebrisIdByHeroId(self.heroData.heroId)
  self.heroDebrisIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(heroDebrisId))
  self:ResetTopNodePosition()
  self:UpdateSkills()
end

local function OnBtnAtkClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btnAtk.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("150155")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnBtnDefClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btnDef.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("220207")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 150
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnBtnArmyClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.btnArmy.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("150182")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 150
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function UpdateSkills(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  local config = heroData.config
  local skillArray = config.skill
  if type(skillArray) ~= "table" then
    skillArray = string.split(skillArray, "|")
  end
  local skillCount = #skillArray
  self.btnSkillsDict = {}
  for k, t in ipairs(self.btnSkills) do
    if k > skillCount then
      t.btn:SetActive(false)
    else
      t.btn:SetActive(true)
      local skillId = tonumber(skillArray[k])
      self.btnSkillsDict[skillId] = t
      t.icon:LoadSprite(HeroUtils.GetSkillIcon(skillId))
      local level = HeroUtils.SkillLevelLimit
      local unlock = true
      if heroData ~= nil then
        local skillData = heroData:GetSkillData(skillId)
        if skillData ~= nil then
          level = skillData.level
          unlock = skillData:IsUnlock()
        end
      end
      t.lvBg:SetActive(0 < level)
      t.lock:SetActive(false)
      UIGray.SetGray(t.btn.transform, not unlock, true)
      t.textLv:SetText(level == 0 and "" or level)
    end
  end
end

local function OnBtnSkillClick(self, index)
  local config, heroData
  heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  config = heroData.config
  local skillIdList = config.skill
  if type(skillIdList) ~= "table" then
    skillIdList = string.split(skillIdList, "|")
  end
  local skillId = tonumber(skillIdList[index])
  local level = HeroUtils.SkillLevelLimit
  local unlockQuality = 1
  if heroData ~= nil then
    local skillData = heroData:GetSkillData(skillId)
    if skillData ~= nil then
      level = skillData.level
      unlockQuality = skillData.unlockQuality
    end
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local btn = self.btnSkills[index].btn
  local position = btn.transform.position
  local UIHeroSkillTipView = require("UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView")
  local dir = UIHeroSkillTipView.Direction.ABOVE
  local param = UIHeroSkillTipView.Param.New()
  param.content = Localization:GetString("150155")
  param.dir = dir
  param.skillId = skillId
  param.skillLevel = level
  param.skillUnlockQuality = unlockQuality
  param.pivot = 0.8 + index * 0.03
  param.position = position + Vector3.New(0, 55, 0) * scaleFactor
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, {anim = false}, param)
end

local function ResetTopNodePosition(self)
  local heroId
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData ~= nil then
    heroId = heroData.heroId
  end
  if heroId ~= nil then
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
    if rarity == HeroUtils.RarityType.C then
      self.heroStarBg:SetActive(false)
      self.levelBg.transform:Set_localPosition(-3, 204, 0)
      self.btnAtk.transform:Set_localPosition(-108, 88.5, 0)
      self.btnDef.transform:Set_localPosition(-114, 1.3, 0)
      self.btnArmy.transform:Set_localPosition(-121, -84.5, 0)
    else
      self.heroStarBg:SetActive(true)
      self.levelBg.transform:Set_localPosition(-3, 134, 0)
      self.btnAtk.transform:Set_localPosition(-108, 28.5, 0)
      self.btnDef.transform:Set_localPosition(-114, -28.7, 0)
      self.btnArmy.transform:Set_localPosition(-121, -84.5, 0)
    end
  end
end

UINewHeroDetail.OnCreate = OnCreate
UINewHeroDetail.OnDestroy = OnDestroy
UINewHeroDetail.ComponentDefine = ComponentDefine
UINewHeroDetail.ComponentDestroy = ComponentDestroy
UINewHeroDetail.ResetTopNodePosition = ResetTopNodePosition
UINewHeroDetail.InitData = InitData
UINewHeroDetail.RefreshView = RefreshView
UINewHeroDetail.OnBtnAtkClick = OnBtnAtkClick
UINewHeroDetail.OnBtnDefClick = OnBtnDefClick
UINewHeroDetail.OnBtnArmyClick = OnBtnArmyClick
UINewHeroDetail.UpdateSkills = UpdateSkills
UINewHeroDetail.OnBtnSkillClick = OnBtnSkillClick
return UINewHeroDetail
