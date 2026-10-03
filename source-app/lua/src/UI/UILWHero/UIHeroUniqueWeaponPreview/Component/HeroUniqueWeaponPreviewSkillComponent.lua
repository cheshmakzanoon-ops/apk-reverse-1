local base = UIBaseContainer
local HeroUniqueWeaponPreviewSkillComponent = BaseClass("HeroUniqueWeaponPreviewSkillComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local HeroUniqueWeaponPreviewDropComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewDropComponent")
local HeroUniqueWeaponPreviewSkillItemComponent = require("UI/UILWHero/UIHeroUniqueWeaponPreview/Component/HeroUniqueWeaponPreviewSkillItemComponent")
local UIHeroSkillItem = require("UI/UILWHero/UIHeroDetailPanel/Component/UIHeroSkillItem")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")
local PHYSICAL_COLOR = Color.New(0.9764706, 0.4352941, 0.4666667, 1)
local ENERGY_COLOR = Color.New(0.7215686, 0.3254902, 0.9254902, 1)
local DEBUFF_COLOR = Color.New(1, 0.3215686, 0.2470588, 1)
local BUFF_COLOR = Color.New(0.454902, 0.8235294, 0.5254902, 1)

function HeroUniqueWeaponPreviewSkillComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroUniqueWeaponPreviewSkillComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroUniqueWeaponPreviewSkillComponent:ReInit()
  self.compSelectLevelContent:ReInit()
  self.heroId = self.view:GetHeroId()
  self.curSelectLv = self.view:GetSelectLv()
  local attr, effects, previewSkills, weapon = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevelWeaponoEffects(self.heroId)
  self.effects = effects
  self.previewSkills = previewSkills
  if table.IsNullOrEmpty(self.effects) then
    return
  end
  self:UpdateSkills()
  self:UpdateSkillInfo()
end

function HeroUniqueWeaponPreviewSkillComponent:UpdateSkillInfo()
  if self.selectSkillIndex == nil or table.IsNullOrEmpty(self.previewSkills) or self.heroId == nil or self.curSelectLv == nil then
    return
  end
  local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.curSelectLv)
  if weaponTemplate == nil then
    return
  end
  local skillId = self.previewSkills[self.selectSkillIndex]
  if skillId == nil then
    return
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if not skillTemplate then
    return
  end
  self.textSkillName:SetLocalText(skillTemplate.name)
  local skillLv = DataCenter.HeroSkillTemplateManager:GetSkillGroupMaxLevel(skillTemplate.group, weaponTemplate.skill_level)
  self.compSkillDescText:SetText(skillTemplate:GetSkillDescByLevel(skillLv, false, "#5FEF87"))
  self.btnPlayePreview:SetActive((skillTemplate:IsShowSkillPreviewBtn()))
  local castType = self:GetSkillDisplayCastType(skillTemplate)
  local cd = ""
  if castType == SkillCastType.AutoAttack then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_1")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", self:GetCoolDownTime(skillTemplate, self.heroId))
  elseif castType == SkillCastType.Active then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_2")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", self:GetCoolDownTime(skillTemplate, self.heroId))
  elseif castType == SkillCastType.Passive then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_4")
  elseif castType == SkillCastType.Talent then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_3")
  elseif castType == SkillCastType.HeroAwaken then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_12")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", skillTemplate.pre_cd or 0)
  elseif castType == SkillCastType.None then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_0")
  else
    self.textSkillTypeTxt:SetText("")
  end
  self.textCdTxt:SetText(cd)
  local displayType = skillTemplate:GetSkillDisplayType()
  if displayType == SkillDisplayType.None then
    self.btnDamageType:SetActive(false)
  else
    self.btnDamageType:SetActive(true)
    local damageTypeText = self:GetSkillDamageTypeText(displayType)
    self.textDamageTypeTxt:SetText(damageTypeText)
    local damageTypeTextColor = self:GetSkillDamageTypeTextColor(displayType)
    if damageTypeTextColor then
      self.textDamageTypeTxt:SetColor(damageTypeTextColor)
    end
  end
end

function HeroUniqueWeaponPreviewSkillComponent:GetSkillDamageTypeIcon(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulishanghai.png"
  elseif displayType == SkillDisplayType.EnergyDamage then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangshanghai.png"
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulifangyu.png"
  elseif displayType == SkillDisplayType.EnergyDefense then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangfangyu.png"
  elseif displayType == SkillDisplayType.Buff then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_injury.png"
  elseif displayType == SkillDisplayType.Debuff then
    return "Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_death.png"
  end
  return ""
end

function HeroUniqueWeaponPreviewSkillComponent:GetSkillDamageTypeText(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return Localization:GetString("skill_detail_panel_5")
  elseif displayType == SkillDisplayType.EnergyDamage then
    return Localization:GetString("skill_detail_panel_6")
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return Localization:GetString("skill_detail_panel_7")
  elseif displayType == SkillDisplayType.EnergyDefense then
    return Localization:GetString("skill_detail_panel_8")
  elseif displayType == SkillDisplayType.Buff then
    return Localization:GetString("skill_detail_panel_10")
  elseif displayType == SkillDisplayType.Debuff then
    return Localization:GetString("skill_detail_panel_11")
  end
  return ""
end

function HeroUniqueWeaponPreviewSkillComponent:GetSkillDamageTypeTextColor(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return PHYSICAL_COLOR
  elseif displayType == SkillDisplayType.EnergyDamage then
    return ENERGY_COLOR
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return PHYSICAL_COLOR
  elseif displayType == SkillDisplayType.EnergyDefense then
    return ENERGY_COLOR
  elseif displayType == SkillDisplayType.Buff then
    return BUFF_COLOR
  elseif displayType == SkillDisplayType.Debuff then
    return DEBUFF_COLOR
  end
end

function HeroUniqueWeaponPreviewSkillComponent:GetSkillDamageTypeIconColor(displayType)
  if displayType == SkillDisplayType.PhysicalDamage then
    return WhiteColor
  elseif displayType == SkillDisplayType.EnergyDamage then
    return WhiteColor
  elseif displayType == SkillDisplayType.PhysicalDefense then
    return WhiteColor
  elseif displayType == SkillDisplayType.EnergyDefense then
    return WhiteColor
  elseif displayType == SkillDisplayType.Buff then
    return BUFF_COLOR
  elseif displayType == SkillDisplayType.Debuff then
    return DEBUFF_COLOR
  end
end

function HeroUniqueWeaponPreviewSkillComponent:GetCoolDownTime(skillTemplate, heroId)
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
  if not heroData or not heroData.GetProperty then
    return skillTemplate.attack_interval
  end
  local castType = skillTemplate:GetSkillCastType()
  if castType == SkillCastType.AutoAttack then
    local attackSpeed = heroData:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
    return skillTemplate.attack_interval / (1 + attackSpeed)
  elseif castType == SkillCastType.Active then
    local coolDownReduce = heroData:GetProperty(HeroEffectDefine.AllCdReduceRate)
    return skillTemplate.attack_interval / (1 + coolDownReduce)
  else
    return skillTemplate.attack_interval
  end
end

function HeroUniqueWeaponPreviewSkillComponent:GetSkillDisplayCastType(skillTemplate)
  local displayCastType = SkillCastType.None
  if skillTemplate then
    displayCastType = skillTemplate:GetSkillDisplayCastType()
  end
  if displayCastType <= SkillCastType.None and skillTemplate then
    displayCastType = skillTemplate:GetSkillCastType()
  end
  return displayCastType
end

function HeroUniqueWeaponPreviewSkillComponent:UpdateSkills()
  if table.IsNullOrEmpty(self.effects) or not self.curSelectLv then
    return
  end
  local totalCount = table.count(self.effects)
  self:ReloadSkillItems(totalCount, function()
    if self.effects and self.skillItems and self.curSelectLv then
      for i, v in ipairs(self.effects) do
        local item = self.skillItems[i]
        if item then
          local weaponLv = v.weaponLv
          item:SetData(i, v.icon, weaponLv > self.curSelectLv, self.clickItemCallBack)
        end
      end
    end
    self:UpdateSkillSelect()
  end)
end

function HeroUniqueWeaponPreviewSkillComponent:UpdateSkillSelect()
  if self.skillItems then
    for i, v in pairs(self.skillItems) do
      local index = v:GetIndex()
      local isSelect = index and self.selectSkillIndex and index == self.selectSkillIndex
      v:SetSelect(isSelect)
    end
  end
end

function HeroUniqueWeaponPreviewSkillComponent:ReloadSkillItems(totalCount, finishCallback)
  local curCount = 0
  if self.skillItemReqs then
    curCount = table.count(self.skillItemReqs)
  end
  if totalCount > curCount then
    if self.skillItems then
      for _, v in pairs(self.skillItems) do
        v:SetActive(true)
      end
    end
    for i = curCount + 1, totalCount do
      local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/UIHeroEffectSelectItem.prefab")
      loadRequest:completed("+", function()
        if not IsNull(loadRequest.gameObject) and not IsNull(self.compSkillContent) and self.skillItems then
          local pageObj = loadRequest.gameObject
          local transform = pageObj.transform
          transform:SetParent(self.compSkillContent.transform)
          transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          pageObj.name = "skillItem" .. i
          local item = self:AddComponent(HeroUniqueWeaponPreviewSkillItemComponent, pageObj)
          item:SetActive(true)
          self.skillItems[i] = item
          if i == totalCount and finishCallback then
            finishCallback()
          end
        end
      end)
      self.skillItemReqs[i] = loadRequest
    end
  else
    if self.skillItems then
      for i = 1, curCount do
        local item = self.skillItems[i]
        if item then
          item:SetActive(i <= totalCount)
        end
      end
    end
    if finishCallback then
      finishCallback()
    end
  end
end

function HeroUniqueWeaponPreviewSkillComponent:ComponentDefine()
  self.compSkillContent = self:AddComponent(UIBaseContainer, "MainContent/SkillContent")
  self.textSkillName = self:AddComponent(UITextMeshProUGUIEx, "MainContent/SkillInfoContent/ImgBg/firstLine/SkillNameAndLevel/SkillNameText")
  self.textCdTxt = self:AddComponent(UITextMeshProUGUIEx, "MainContent/SkillInfoContent/ImgBg/firstLine/cd_txt")
  self.btnSkillType = self:AddComponent(UIButton, "MainContent/SkillInfoContent/ImgBg/secondLine/skillType")
  self.btnSkillType:SetOnClick(function()
    self:OnBtnSkillTypeClick()
  end)
  self.textSkillTypeTxt = self:AddComponent(UITextMeshProUGUIEx, "MainContent/SkillInfoContent/ImgBg/secondLine/skillType/skillType_txt")
  self.btnDamageType = self:AddComponent(UIButton, "MainContent/SkillInfoContent/ImgBg/secondLine/damageType")
  self.btnDamageType:SetOnClick(function()
    self:OnBtnDamageTypeClick()
  end)
  self.textDamageTypeTxt = self:AddComponent(UITextMeshProUGUIEx, "MainContent/SkillInfoContent/ImgBg/secondLine/damageType/damageType_txt")
  self.textSkillInformationTitleTxt = self:AddComponent(UITextMeshProUGUIEx, "MainContent/SkillInfoContent/ImgBg/thirdLine/skillInformationTitle_txt")
  self.btnPlayePreview = self:AddComponent(UIButton, "MainContent/SkillInfoContent/ImgBg/thirdLine/PlayePreviewButton")
  self.btnPlayePreview:SetOnClick(function()
    self:OnBtnPlayePreviewClick()
  end)
  self.compSelectLevelContent = self:AddComponent(HeroUniqueWeaponPreviewDropComponent, "SelectLevelContent")
  self.compSkillDescText = self:AddComponent(UIHeroSkillDesc, "MainContent/SkillInfoContent/ImgBg/forthLine/DescLayout/Viewport/Content/SkillDescText")
end

function HeroUniqueWeaponPreviewSkillComponent:ComponentDestroy()
  self.compSkillContent = nil
  self.textSkillName = nil
  self.textCdTxt = nil
  self.btnSkillType = nil
  self.textSkillTypeTxt = nil
  self.btnDamageType = nil
  self.textDamageTypeTxt = nil
  self.textSkillInformationTitleTxt = nil
  self.btnPlayePreview = nil
  self.compSelectLevelContent = nil
  self.compSkillDescText = nil
end

function HeroUniqueWeaponPreviewSkillComponent:DataDefine()
  self.skillItems = {}
  self.skillItemReqs = {}
  self.clickItemCallBack = BindCallback(self, self.OnClickItem)
  self.selectSkillIndex = 1
end

function HeroUniqueWeaponPreviewSkillComponent:DataDestroy()
  self.skillItems = nil
  self.skillItemReqs = nil
  self.clickItemCallBack = nil
  self.selectSkillIndex = nil
end

function HeroUniqueWeaponPreviewSkillComponent:OnAddListener()
  base.OnAddListener(self)
end

function HeroUniqueWeaponPreviewSkillComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeroUniqueWeaponPreviewSkillComponent:OnClickItem(skillIndex)
  self.selectSkillIndex = skillIndex
  self:UpdateSkillSelect()
  self:UpdateSkillInfo()
end

function HeroUniqueWeaponPreviewSkillComponent:OnBtnSkillTypeClick()
end

function HeroUniqueWeaponPreviewSkillComponent:OnBtnDamageTypeClick()
  if self.selectSkillIndex == nil or table.IsNullOrEmpty(self.previewSkills) then
    return
  end
  local skillId = self.previewSkills[self.selectSkillIndex]
  if skillId == nil then
    return
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if not skillTemplate then
    return
  end
  local displayType = skillTemplate:GetSkillDisplayType()
  local desc = ""
  if displayType == SkillDisplayType.PhysicalDamage then
    desc = Localization:GetString("skill_detail_panel_5_detail")
  elseif displayType == SkillDisplayType.EnergyDamage then
    desc = Localization:GetString("skill_detail_panel_6_detail")
  elseif displayType == SkillDisplayType.PhysicalDefense then
    desc = Localization:GetString("skill_detail_panel_7_detail")
  elseif displayType == SkillDisplayType.EnergyDefense then
    desc = Localization:GetString("skill_detail_panel_8_detail")
  elseif displayType == SkillDisplayType.Buff then
    desc = Localization:GetString("skill_detail_panel_10_detail")
  elseif displayType == SkillDisplayType.Debuff then
    desc = Localization:GetString("skill_detail_panel_11_detail")
  else
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.content = desc
  param.alignObject = self.textDamageTypeTxt.transform
  param.yPosFix = -10
  param.bgColor = Color.New(0.2392, 0.2627, 0.3568, 1)
  param.showArrow = false
  param.preferTop = true
  param.width = 400
  param.descTxtColor = WhiteColor
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function HeroUniqueWeaponPreviewSkillComponent:OnBtnPlayePreviewClick()
  if self.selectSkillIndex == nil or table.IsNullOrEmpty(self.previewSkills) or self.heroId == nil or self.curSelectLv == nil then
    return
  end
  local skillId = self.previewSkills[self.selectSkillIndex]
  if skillId == nil then
    return
  end
  local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if not skillTemplate then
    return
  end
  local weaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(self.heroId, self.curSelectLv)
  if weaponTemplate == nil then
    return
  end
  local skillLv = DataCenter.HeroSkillTemplateManager:GetSkillGroupMaxLevel(skillTemplate.group, weaponTemplate.skill_level)
  local awakenLv, skinId
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(self.heroId)
  if heroData then
    awakenLv = heroData:GetHeroAwakenRankLevel()
    skinId = heroData:GetSkinId()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, self.heroId, skillId, skillLv, skillLv, self.curSelectLv, awakenLv, skinId)
end

return HeroUniqueWeaponPreviewSkillComponent
