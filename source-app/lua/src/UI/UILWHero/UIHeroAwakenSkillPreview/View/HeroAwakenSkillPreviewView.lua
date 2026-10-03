local HeroAwakenSkillPreviewView = BaseClass("HeroAwakenSkillPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroSkillEffectLineLink = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLineLink")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")
local TIP_BG_COLOR = Color.New(0.2392, 0.2627, 0.3568, 1)
local PHYSICAL_COLOR = Color.New(0.9764706, 0.4352941, 0.4666667, 1)
local ENERGY_COLOR = Color.New(0.7215686, 0.3254902, 0.9254902, 1)
local DEBUFF_COLOR = Color.New(1, 0.3215686, 0.2470588, 1)
local BUFF_COLOR = Color.New(0.454902, 0.8235294, 0.5254902, 1)

function HeroAwakenSkillPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function HeroAwakenSkillPreviewView:OnDestroy()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.HeroAwakenSkinPreview) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.HeroAwakenSkinPreview)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenSkillPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.rawImgHeroSpineBg = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.btnAwakenSkin = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnAwakenSkin:SetOnClick(function()
    self:OnBtnAwakenSkinClick()
  end)
  self.textBody = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textSkillName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textSkillLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textSkillLevelLimit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textCdTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnSkillType = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnSkillType:SetOnClick(function()
    self:OnBtnSkillTypeClick()
  end)
  self.textSkillTypeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnDamageType = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnDamageType:SetOnClick(function()
    self:OnBtnDamageTypeClick()
  end)
  self.imgDamageTypeIcon = self.viewSkin:AddComponent(self, UIImage, 12)
  self.textDamageTypeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textSkillInformationTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.btnPlayePreview = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnPlayePreview:SetOnClick(function()
    self:OnBtnPlayePreviewClick()
  end)
  self.compSkillDescText = self.viewSkin:AddComponent(self, UIHeroSkillDesc, 16)
  self.compNextEffectGroup = self.viewSkin:AddComponent(self, UIBaseContainer, 17)
  self.compAwakenEffectValueLine = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.compActiveStateText = self.viewSkin:AddComponent(self, UIHeroSkillDesc, 19)
  self.compNextEffectValueLine = self.viewSkin:AddComponent(self, UIBaseComponent, 20)
  self.compUIHeroSkillItem = self.viewSkin:AddComponent(self, UIHeroSkillItem, 21)
  self.textContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.compBase1 = self.viewSkin:AddComponent(self, UIBaseComponent, 23)
  self.textBody:SetLocalText("hero_awaken_btn_28")
  self.compNextEffectValueLine.gameObject:GameObjectCreatePool()
  local screenHeight = CS.UnityEngine.Screen.height
  local hMin, hMax = 416, 800
  local sMin, sMax = 1440, 1800
  local targetH = hMin + (hMax - hMin) * (screenHeight - sMin) / (sMax - sMin)
  targetH = math.max(hMin, math.min(hMax, targetH))
  self.compBase1:SetSizeDeltaY(targetH)
end

function HeroAwakenSkillPreviewView:ComponentDestroy()
  self.viewSkin = nil
  self.btnBack = nil
  self.rawImgHeroSpineBg = nil
  self.btnAwakenSkin = nil
  self.textBody = nil
  self.textSkillName = nil
  self.textSkillLevel = nil
  self.textSkillLevelLimit = nil
  self.textCdTxt = nil
  self.btnSkillType = nil
  self.textSkillTypeTxt = nil
  self.btnDamageType = nil
  self.imgDamageTypeIcon = nil
  self.textDamageTypeTxt = nil
  self.textSkillInformationTitleTxt = nil
  self.btnPlayePreview = nil
  self.compSkillDescText = nil
  self.compNextEffectGroup = nil
  self.compAwakenEffectValueLine = nil
  self.compActiveStateText = nil
  self.compNextEffectValueLine = nil
  self.compUIHeroSkillItem = nil
  self.textContent = nil
  self.compBase1 = nil
end

function HeroAwakenSkillPreviewView:DataDefine()
  self.heroData = nil
  self.skillData = nil
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
end

function HeroAwakenSkillPreviewView:DataDestroy()
  self.heroData = nil
  self.skillData = nil
  self.clickSkillCallBack = nil
end

function HeroAwakenSkillPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function HeroAwakenSkillPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HeroAwakenSkillPreviewView:OnOpen()
  self.heroData = self:GetUserData()
  if not self.heroData then
    Logger.LogError("HeroAwakenSkillPreviewView heroData is nil")
    self.ctrl:CloseSelf()
    return
  end
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  if not awakenTemplate then
    Logger.LogError("HeroAwakenSkillPreviewView awakenTemplate is nil, heroId:" .. self.heroData.heroId)
    self.ctrl:CloseSelf()
    return
  end
  self.textContent:SetLocalText(awakenTemplate.skill_preview_key)
  local spineBgPath = awakenTemplate.spine_preview_pic
  if string.IsNullOrEmpty(spineBgPath) then
    self.rawImgHeroSpineBg:SetActive(false)
  else
    self.rawImgHeroSpineBg:LoadSpriteAsync(spineBgPath)
    self.rawImgHeroSpineBg:SetActive(true)
  end
  local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroData.heroId, 1)
  if not rankTemplate then
    Logger.LogError("HeroAwakenSkillPreviewView rankTemplate is nil, heroId:" .. self.heroData.heroId)
    self.ctrl:CloseSelf()
    return
  end
  local skillId = rankTemplate:GetSkillId()
  if skillId then
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillTemplate then
      local newSkillId = DataCenter.HeroSkillTemplateManager:GetMaxStarSkillBySkillId(skillId)
      local skillData = SkillInfo.New()
      skillData:CreateFromTemplate(newSkillId, true, IntMaxValue, nil, self.heroData.uuid)
      self.skillData = skillData
      self.compUIHeroSkillItem:SetData(skillData, {
        showSkillName = false,
        showSkillLevel = false,
        showLock = false,
        showRedPoint = false,
        showStar = true
      }, self.clickSkillCallBack)
      self.compUIHeroSkillItem:RefreshAwakenSkillFrameVfx(true)
      local showSkillData = skillData
      local nameStr = showSkillData:GetName()
      if skillData:IsUnlock() then
        self.textSkillName:SetText(nameStr)
        self.textSkillLevel:SetText(string.format("Lv.%d", showSkillData:GetLevel()))
        self.textSkillLevelLimit:SetText(string.format("/%d", showSkillData:GetMaxLevel()))
      else
        local resultStr = string.format("%s (%s)", nameStr, Localization:GetString(120050))
        self.textSkillName:SetText(resultStr)
        self.textSkillLevel:SetText("")
        self.textSkillLevelLimit:SetText("")
      end
      self.compSkillDescText:SetText(showSkillData:GetDesc(true))
      self.compNextEffectGroup:RemoveComponents(UIHeroSkillEffectLineLink)
      self.compNextEffectValueLine.gameObject:GameObjectRecycleAll()
      local effectsDesc = showSkillData:GetEffectsDesc()
      local isHeroAwakenSkill = showSkillData:IsHeroAwakenSkill()
      if 0 < #effectsDesc then
        for i = 1, #effectsDesc do
          self.compNextEffectGroup:SetActive(true)
          local item = self.compNextEffectValueLine.gameObject:GameObjectSpawn(self.compNextEffectGroup.transform)
          item.name = "item" .. i
          local cell = self.compNextEffectGroup:AddComponent(UIHeroSkillEffectLineLink, item.name)
          cell:SetData(effectsDesc[i].isUnlock, effectsDesc[i].outDesc, i, isHeroAwakenSkill)
        end
      else
        self.compNextEffectGroup:SetActive(false)
      end
      if showSkillData then
        self.btnPlayePreview:SetActive(showSkillData:IsShowSkillPreviewBtn())
      end
      local castType = showSkillData:GetSkillDisplayCastType()
      local cd = ""
      if castType == SkillCastType.AutoAttack then
        self.textSkillTypeTxt:SetLocalText("skill_detail_panel_1")
        cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetCoolDownTime(self.heroData))
      elseif castType == SkillCastType.Active then
        self.textSkillTypeTxt:SetLocalText("skill_detail_panel_2")
        cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetCoolDownTime(self.heroData))
      elseif castType == SkillCastType.Passive then
        self.textSkillTypeTxt:SetLocalText("skill_detail_panel_4")
      elseif castType == SkillCastType.Talent then
        self.textSkillTypeTxt:SetLocalText("skill_detail_panel_3")
      elseif castType == SkillCastType.HeroAwaken then
        self.textSkillTypeTxt:SetLocalText("skill_detail_panel_12")
        cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetPreCd())
      else
        self.textSkillTypeTxt:SetText("")
      end
      self.textCdTxt:SetText(cd)
      local displayType = showSkillData:GetSkillDisplayType()
      if displayType == SkillDisplayType.None then
        self.btnDamageType:SetActive(false)
      else
        self.btnDamageType:SetActive(true)
        if displayType == SkillDisplayType.PhysicalDamage then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulishanghai.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_5")
          self.textDamageTypeTxt:SetColor(PHYSICAL_COLOR)
          self.imgDamageTypeIcon:SetColor(WhiteColor)
        elseif displayType == SkillDisplayType.EnergyDamage then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangshanghai.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_6")
          self.textDamageTypeTxt:SetColor(ENERGY_COLOR)
          self.imgDamageTypeIcon:SetColor(WhiteColor)
        elseif displayType == SkillDisplayType.PhysicalDefense then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulifangyu.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_7")
          self.textDamageTypeTxt:SetColor(PHYSICAL_COLOR)
          self.imgDamageTypeIcon:SetColor(WhiteColor)
        elseif displayType == SkillDisplayType.EnergyDefense then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangfangyu.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_8")
          self.textDamageTypeTxt:SetColor(ENERGY_COLOR)
          self.imgDamageTypeIcon:SetColor(WhiteColor)
        elseif displayType == SkillDisplayType.Buff then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_injury.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_10")
          self.textDamageTypeTxt:SetColor(BUFF_COLOR)
          self.imgDamageTypeIcon:SetColor(BUFF_COLOR)
        elseif displayType == SkillDisplayType.Debuff then
          self.imgDamageTypeIcon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_death.png")
          self.textDamageTypeTxt:SetLocalText("skill_detail_panel_11")
          self.textDamageTypeTxt:SetColor(DEBUFF_COLOR)
          self.imgDamageTypeIcon:SetColor(DEBUFF_COLOR)
        end
        self.imgDamageTypeIcon:SetNativeSize()
      end
      local isAwakenSkill = showSkillData:IsHeroAwakenSkill()
      self.compAwakenEffectValueLine:SetActive(isAwakenSkill)
      if isAwakenSkill and self.heroData ~= nil then
        local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroData.heroId, true)
        if awakenTemplate then
          local valueStr = awakenTemplate:GetAwakenEffectValueLineText()
          self.compActiveStateText:SetText(valueStr)
        end
      end
    end
  end
end

function HeroAwakenSkillPreviewView:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function HeroAwakenSkillPreviewView:OnBtnAwakenSkinClick()
  if not self.heroData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenSkinPreview, {anim = true}, self.heroData)
end

function HeroAwakenSkillPreviewView:OnBtnSkillTypeClick()
  if not self.skillData then
    return
  end
  local castType = self.skillData:GetSkillDisplayCastType()
  local desc = ""
  if castType == SkillCastType.AutoAttack then
    desc = Localization:GetString("skill_detail_panel_1_detail")
  elseif castType == SkillCastType.Active then
    desc = Localization:GetString("skill_detail_panel_2_detail")
  elseif castType == SkillCastType.Passive then
    desc = Localization:GetString("skill_detail_panel_4_detail")
  elseif castType == SkillCastType.Talent then
    desc = Localization:GetString("skill_detail_panel_3_detail")
  elseif castType == SkillCastType.HeroAwaken then
    desc = Localization:GetString("skill_detail_panel_12_detail")
  else
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.content = desc
  param.alignObject = self.textSkillTypeTxt.transform
  param.yPosFix = -10
  param.bgColor = TIP_BG_COLOR
  param.showArrow = false
  param.preferTop = true
  param.width = 400
  param.descTxtColor = WhiteColor
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function HeroAwakenSkillPreviewView:OnBtnDamageTypeClick()
  if not self.skillData then
    return
  end
  local displayType = self.skillData:GetSkillDisplayType()
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
  param.bgColor = TIP_BG_COLOR
  param.showArrow = false
  param.preferTop = true
  param.width = 400
  param.descTxtColor = WhiteColor
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function HeroAwakenSkillPreviewView:OnBtnPlayePreviewClick()
  if not self.heroData or not self.skillData then
    return
  end
  local heroId = self.heroData.heroId
  local skillId = self.skillData:GetId()
  local skillLv = self.skillData:GetLevel()
  local skillMaxLv = self.skillData:GetMaxLevel()
  local weaponLv = self.heroData:GetUniqueWeaponLv()
  local awakenLv = self.heroData:GetHeroAwakenRankLevel()
  local skinId = self.heroData:GetSkinId()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv, weaponLv, awakenLv, skinId)
end

function HeroAwakenSkillPreviewView:OnClickSkillItem(skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillDetailPanel, {anim = true}, skillData, skillItem)
end

return HeroAwakenSkillPreviewView
