local UIHeroSkillPage = BaseClass("UIHeroSkillPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroSkillEffectLineLink = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLineLink")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local ResourceManager = CS.GameEntry.Resource
local UIHeroPowerChangeItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPowerChangeItem")
local UIHeroSkillDesc = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillDesc")
local skillListPath = "CenterHeroInfo/HeroSkillInfo/SkillList"
local skill1Path = "CenterHeroInfo/HeroSkillInfo/SkillList/Skill1"
local skill2Path = "CenterHeroInfo/HeroSkillInfo/SkillList/Skill2"
local skill3Path = "CenterHeroInfo/HeroSkillInfo/SkillList/Skill3"
local skill4Path = "CenterHeroInfo/HeroSkillInfo/SkillList/Skill4"
local skillItemNameTextPath = "CenterHeroInfo/SkillDetailPage/ImgBg/firstLine/SkillNameAndLevel/SkillNameText"
local skillItemLevelTextPath = "CenterHeroInfo/SkillDetailPage/ImgBg/firstLine/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelText"
local skillItemLevelLimitTextPath = "CenterHeroInfo/SkillDetailPage/ImgBg/firstLine/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelLimitText"
local skillDescTextPath = "CenterHeroInfo/SkillDetailPage/ImgBg/forthLine/DescLayout/Viewport/Content/SkillDescText"
local nextEffectGroupPath = "CenterHeroInfo/SkillDetailPage/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup"
local nextEffectLineTemplatePath = "CenterHeroInfo/SkillDetailPage/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup/NextEffectValueLine"
local upgradeContainerPath = "CenterBottomInfo/UpgradeContainer"
local upgradeBtnPath = "CenterBottomInfo/UpgradeContainer/UpgradeBtn"
local upgradeBtnTextPath = "CenterBottomInfo/UpgradeContainer/UpgradeBtn/UpgradeBtnText"
local upgradeBtnRedPointPath = "CenterBottomInfo/UpgradeContainer/UpgradeBtn/UpgradeBtnRedPoint"
local costGroupPath = "CenterBottomInfo/UpgradeContainer/CostGroup"
local cost1Path = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost1"
local cost1IconPath = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost1/Cost1Icon"
local cost1TextPath = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost1/Cost1Text"
local cost2Path = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost2"
local cost2IconPath = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost2/Cost2Icon"
local cost2TextPath = "CenterBottomInfo/UpgradeContainer/CostGroup/Cost2/Cost2Text"
local upgradeConditionPath = "CenterBottomInfo/UpgradeContainer/UpgradeCondition"
local upgradeConditionTextPath = "CenterBottomInfo/UpgradeContainer/UpgradeCondition/UpgradeConditionText"
local gotoUpgradeHeroBtnPath = "CenterBottomInfo/GotoUpgradeHeroBtn"
local maxLevelTextPath = "CenterBottomInfo/MaxLevelText"
local heroSpineContainerPath = "CenterHeroInfo/PreviewSkillPage/HeroSpineViewport/HeroSpineContainer"
local upgradeEffectPath = "CenterHeroInfo/HeroSkillInfo/SkillList/SkillUpgradeEffect"
local upgradeGotoRankTextPath = "CenterBottomInfo/UpgradeGotoRankText"
local upgradeGotoRankBtnPath = "CenterBottomInfo/UpgradeGotoRankText/UpgradeGotoRankBtn"
local upgradeGotoRankBtnTextPath = "CenterBottomInfo/UpgradeGotoRankText/UpgradeGotoRankBtn/UpgradeGotoRankBtnText"
local heroNameTextPath = "CenterHeroInfo/HeroNameText"
local heroNickNameTextPath = "CenterHeroInfo/HeroNickNameText"
local playPreviewSkillBtnPath = "CenterHeroInfo/SkillDetailPage/ImgBg/thirdLine/PlayePreviewButton"
local realPowerTextPath = "CenterHeroInfo/PowerInfo/RealPower"
local realPowerEffectPath = "CenterHeroInfo/PowerInfo/RealPower/Effect"
local realPowerPath = "CenterHeroInfo/PowerInfo"
local realPowerContentPath = "CenterHeroInfo/PowerInfo/PowerEffectContent"
local cd_txt_path = "CenterHeroInfo/SkillDetailPage/ImgBg/firstLine/cd_txt"
local skill_type_txt_path = "CenterHeroInfo/SkillDetailPage/ImgBg/secondLine/skillType/skillType_txt"
local damage_type_icon_path = "CenterHeroInfo/SkillDetailPage/ImgBg/secondLine/damageType/damageTypeIcon"
local damage_type_txt_path = "CenterHeroInfo/SkillDetailPage/ImgBg/secondLine/damageType/damageType_txt"
local damage_type_path = "CenterHeroInfo/SkillDetailPage/ImgBg/secondLine/damageType"
local skill_type_path = "CenterHeroInfo/SkillDetailPage/ImgBg/secondLine/skillType"
local TIP_BG_COLOR = Color.New(0.2392, 0.2627, 0.3568, 1)

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

local function OnClickSkillItem(self, skillData, item)
  if not skillData then
    return
  end
  local slotIndex = skillData:GetSlotIndex()
  self:SelectSkill(slotIndex)
end

local function OnClickUpgradeBtn(self)
  if not self.skillData or not self.heroData then
    return
  end
  local skillReachMaxLevel = self.skillData:IsReachMaxLevel()
  if skillReachMaxLevel then
    return
  end
  local skillPointId = DataCenter.HeroParamDataManager.heroSkillPointItemId
  local haveSkillPoint = DataCenter.ResourceItemDataManager:GetCountByItemId(skillPointId)
  local need = self.skillData:GetUpgradeCostSkillPoint()
  if haveSkillPoint >= need then
    SFSNetwork.SendMessage(MsgDefines.HeroSkillUpgrade, self.heroData.uuid, self.skillData:GetSlotIndex())
  elseif CS.SceneManager:IsInPVE() then
    UIUtil.ShowTipsId("quick_upgrade_tips")
  else
    LWResourceLackUtil:GotoResourceItemLack(skillPointId, need)
  end
end

local function DataDefine(self)
  self.templateHeroData = nil
  self.heroData = nil
  self.selectedSkillIndex = nil
  self.templateSkillInfo = nil
  self.selectSkillCallBack = BindCallback(self, OnClickSkillItem)
end

local function DataDestroy(self)
  if self.templateHeroData ~= nil then
    self.templateHeroData:Delete()
    self.templateHeroData = nil
  end
  self.heroData = nil
  self.selectedSkillIndex = nil
  self.selectSkillCallBack = nil
  self.templateSkillInfo = nil
  self.lastSpinePath = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
  DataCenter.PreviewSkillEffectManager:Destroy()
  self:HideUpgradeEffect()
end

local function OnClickGotoRankBtn(self)
  if self.view then
    local isHeroAwakenSkill = self.skillData ~= nil and self.skillData:IsHeroAwakenSkill()
    if isHeroAwakenSkill then
      self.view:GotoHeroAwakenPage()
    else
      self.view:GotoHeroRankPage()
    end
  end
end

local function ShowPreviewSkillWindow(self)
  if not self.heroData or not self.selectedSkillIndex then
    return
  end
  local heroId = self.heroData.heroId
  local selectedSkillInfo = self.heroData:GetHeroSkillBySlotIndex(self.selectedSkillIndex)
  local skillId = selectedSkillInfo:GetId()
  local skillLv = selectedSkillInfo:GetLevel()
  local skillMaxLv = selectedSkillInfo:GetMaxLevel()
  local weaponLv = self.heroData:GetUniqueWeaponLv()
  local awakenLv = self.heroData:GetHeroAwakenRankLevel()
  local skinId = self.heroData:GetSkinId()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv, weaponLv, awakenLv, skinId)
end

local function ComponentDefine(self)
  self.skillList = self:AddComponent(UIBaseContainer, skillListPath)
  self.skill1 = self:AddComponent(UIHeroSkillItem, skill1Path)
  self.skill2 = self:AddComponent(UIHeroSkillItem, skill2Path)
  self.skill3 = self:AddComponent(UIHeroSkillItem, skill3Path)
  self.skill4 = self:AddComponent(UIHeroSkillItem, skill4Path)
  self.skills = {
    self.skill1,
    self.skill2,
    self.skill3,
    self.skill4
  }
  self.skillNameText = self:AddComponent(UIText, skillItemNameTextPath)
  self.skillLevelText = self:AddComponent(UIText, skillItemLevelTextPath)
  self.skillLevelLimitText = self:AddComponent(UIText, skillItemLevelLimitTextPath)
  self.skillDescText = self:AddComponent(UIHeroSkillDesc, skillDescTextPath)
  self.nextEffectGroup = self:AddComponent(UIBaseContainer, nextEffectGroupPath)
  self.nextEffectLineTemplate = self.transform:Find(nextEffectLineTemplatePath).gameObject
  self.nextEffectLineTemplate:GameObjectCreatePool()
  self.upgradeContainer = self:AddComponent(UIBaseComponent, upgradeContainerPath)
  self.upgradeBtn = self:AddComponent(UIButton, upgradeBtnPath)
  self.upgradeBtn:SetOnClick(function()
    OnClickUpgradeBtn(self)
  end)
  self.upgradeBtnText = self:AddComponent(UIText, upgradeBtnTextPath)
  self.upgradeBtnRedPoint = self:AddComponent(UIBaseComponent, upgradeBtnRedPointPath)
  self.costGroup = self:AddComponent(UIBaseContainer, costGroupPath)
  self.cost1 = self:AddComponent(UIBaseContainer, cost1Path)
  self.cost1Icon = self:AddComponent(UIImage, cost1IconPath)
  self.cost1Text = self:AddComponent(UIText, cost1TextPath)
  self.cost2 = self:AddComponent(UIBaseContainer, cost2Path)
  self.cost2Icon = self:AddComponent(UIImage, cost2IconPath)
  self.cost2Text = self:AddComponent(UIText, cost2TextPath)
  self.upgradeCondition = self:AddComponent(UIBaseComponent, upgradeConditionPath)
  self.upgradeConditionText = self:AddComponent(UIText, upgradeConditionTextPath)
  self.gotoUpgradeHeroBtn = self:AddComponent(UIButton, gotoUpgradeHeroBtnPath)
  self.gotoUpgradeHeroBtn:SetOnClick(function()
    if self.view and self.heroData then
      local needRank = self.heroData:GetSkillUnlockRankByIndex(self.skillData:GetSlotIndex())
      local unlockLevel = self.heroData:GetSkillUnlockLevelByIndex(self.skillData:GetSlotIndex())
      if unlockLevel <= self.heroData.level then
        self.view:GotoHeroRankPage()
      elseif needRank > self.heroData.rank then
        self.view:GotoHeroGrowthPage()
      end
    end
  end)
  self.maxLevelText = self:AddComponent(UIText, maxLevelTextPath)
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.upgradeEffect = self:AddComponent(UIBaseContainer, upgradeEffectPath)
  self.upgradeGotoRankText = self:AddComponent(UIText, upgradeGotoRankTextPath)
  self.upgradeGotoRankText:SetLocalText(151135)
  self.upgradeGotoRankBtn = self:AddComponent(UIButton, upgradeGotoRankBtnPath)
  self.upgradeGotoRankBtnText = self:AddComponent(UIText, upgradeGotoRankBtnTextPath)
  self.upgradeGotoRankBtn:SetOnClick(function()
    OnClickGotoRankBtn(self)
  end)
  self.upgradeGotoRankBtnText:SetLocalText(110003)
  self.heroNameText = self:AddComponent(UIText, heroNameTextPath)
  self.heroNickNameText = self:AddComponent(UIText, heroNickNameTextPath)
  self.playPreviewBtn = self:AddComponent(UIButton, playPreviewSkillBtnPath)
  self.playPreviewBtn:SetOnClick(function()
    ShowPreviewSkillWindow(self)
  end)
  self.realPower = self:AddComponent(UIBaseContainer, realPowerPath)
  self.realPowerText = self:AddComponent(UIText, realPowerTextPath)
  self.realPowerEffect = self:AddComponent(UIBaseContainer, realPowerEffectPath)
  self.realPowerContent = self:AddComponent(UIBaseContainer, realPowerContentPath)
  self.realPowerPrefab = self.realPowerContent.transform:Find("PowerChangeItem")
  self.realPowerPrefab.gameObject:SetActive(false)
  self.powerChangePool = {}
  self.cd_txt = self:AddComponent(UIText, cd_txt_path)
  self.skill_type_txt = self:AddComponent(UIText, skill_type_txt_path)
  self.damage_type_icon = self:AddComponent(UIImage, damage_type_icon_path)
  self.damage_type_txt = self:AddComponent(UIText, damage_type_txt_path)
  self.damage_type = self:AddComponent(UIButton, damage_type_path)
  self.skill_type = self:AddComponent(UIButton, skill_type_path)
  self.damage_type:SetOnClick(function()
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
    param.alignObject = self.damage_type_txt.transform
    param.yPosFix = -10
    param.bgColor = TIP_BG_COLOR
    param.showArrow = false
    param.preferTop = true
    param.width = 400
    param.descTxtColor = WhiteColor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.skill_type:SetOnClick(function()
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
    elseif castType == SkillCastType.None then
      desc = Localization:GetString("skill_detail_panel_0_detail")
    else
      return
    end
    local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
    param.content = desc
    param.alignObject = self.skill_type_txt.transform
    param.yPosFix = -10
    param.bgColor = TIP_BG_COLOR
    param.showArrow = false
    param.preferTop = true
    param.width = 400
    param.descTxtColor = WhiteColor
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
  end)
  self.compAwakenEffectValueLine = self:AddComponent(UIBaseComponent, "CenterHeroInfo/SkillDetailPage/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup/AwakenEffectValueLine")
  self.textAwakenEffectValueLine = self:LazyAddComponent(UIHeroSkillDesc, "CenterHeroInfo/SkillDetailPage/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup/AwakenEffectValueLine/ActiveStateText")
end

local function ComponentDestroy(self)
  self.skillList = nil
  self.skill1 = nil
  self.skill2 = nil
  self.skill3 = nil
  self.skill4 = nil
  self.skills = nil
  self.skillNameText = nil
  self.skillLevelText = nil
  self.skillLevelLimitText = nil
  self.skillDescText = nil
  self.nextEffectGroup = nil
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  self.nextEffectLineTemplate = nil
  self.upgradeContainer = nil
  self.upgradeBtn = nil
  self.upgradeBtnText = nil
  self.upgradeBtnRedPoint = nil
  self.costGroup = nil
  self.cost1 = nil
  self.cost1Icon = nil
  self.cost1Text = nil
  self.cost2 = nil
  self.cost2Icon = nil
  self.cost2Text = nil
  self.upgradeCondition = nil
  self.upgradeConditionText = nil
  self.gotoUpgradeHeroBtn = nil
  self.maxLevelText = nil
  self.heroSpineContainer = nil
  self.upgradeGotoRankText = nil
  self.upgradeGotoRankBtn = nil
  self.upgradeGotoRankBtnText = nil
  self.heroNameText = nil
  self.heroNickNameText = nil
  self.playPreviewBtn = nil
  self.compAwakenEffectValueLine = nil
  self.textAwakenEffectValueLine = nil
end

local function SelectSkill(self, skillIndex)
  if not self.heroData then
    return
  end
  if self.selectedSkillIndex == skillIndex then
    return
  end
  self.selectedSkillIndex = skillIndex
  self.skillData = self.heroData:GetHeroSkillBySlotIndex(skillIndex)
  self.heroData:MarkNewUnlockedSkillRead(skillIndex)
  if self.skills[skillIndex] then
    local newTagShowState = self.skills[skillIndex]:GetNewTagShowState()
    if newTagShowState then
      self.skills[skillIndex]:HideNewTag()
    end
  end
  local hasNew = false
  for k, v in pairs(self.skills) do
    if v:GetNewTagShowState() then
      hasNew = true
      break
    end
  end
  if self.skillData and not self.skillData:IsUnlock() then
    if not self.templateSkillInfo then
      self.templateSkillInfo = SkillInfo.New()
    end
    local newSkillId = DataCenter.HeroSkillTemplateManager:GetMaxStarSkillBySkillId(self.skillData:GetId())
    self.templateSkillInfo:CreateFromTemplate(newSkillId, false, IntMaxValue)
    self.templateSkillInfo.slotIndex = self.skillData:GetSlotIndex()
    self.skillData = self.templateSkillInfo
  end
  for i = 1, 4 do
    self.skills[i]:SetSelected(i == skillIndex)
  end
  self:RefreshSkillView()
  self.view:RefreshSkillToggleRedPoint()
end

local function RefreshHeroBaseInfo(self)
  if not self.heroData then
    return
  end
  self.heroNameText:SetText(self.heroData:GetName())
  self.heroNickNameText:SetText(self.heroData:GetNickName())
end

local function RefreshHeroSkillListInfo(self)
  for i = 1, 4 do
    local skillData = self.heroData:GetHeroSkillBySlotIndex(i)
    local skillShowRedPoint = false
    if skillData ~= nil and not self.isTemplateHero then
      skillShowRedPoint = HeroRedPointManager:GetInstance():IsHeroInSquad(self.heroData.uuid) and self.heroData:IsSkillCanUpgrade(skillData)
    end
    local unlockLevel = 0
    local isNew = false
    if skillData then
      if not skillData:IsUnlock() then
        unlockLevel = self.heroData:GetSkillUnlockLevelByIndex(i)
      end
      isNew = self.heroData:IsIndexSkillNewUnlocked(i)
    end
    self.skills[i]:SetData(skillData, {
      showSkillName = false,
      showSkillLevel = true,
      showLock = true,
      showRedPoint = skillShowRedPoint,
      unlockLevel = unlockLevel,
      showStar = true
    }, self.selectSkillCallBack)
    self.skills[i]:SetSelected(i == self.selectedSkillIndex)
    if isNew then
      self.skills[i]:ShowNewTag()
    end
    local isAwakenSkill = skillData ~= nil and skillData:IsHeroAwakenSkill()
    if isAwakenSkill then
      self.skills[i]:SetSelectBgScale(0.9)
    else
      self.skills[i]:SetSelectBgScale(0.8)
    end
    self.skills[i]:RefreshAwakenSkillFrameVfx(true)
  end
  self.view:RefreshSkillToggleRedPoint()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillList.transform)
end

local function RefreshBtns(self)
  if not self.skillData then
    return
  end
  if self.skillData:IsUnlock() then
    self.gotoUpgradeHeroBtn:SetActive(false)
    local reachMaxLevel = self.skillData:IsReachMaxLevel()
    local reachMaxStar = self.skillData:IsReachMaxStar()
    if reachMaxLevel then
      self.cost1:SetActive(false)
      self.cost2:SetActive(false)
      self.upgradeCondition:SetActive(false)
      self.upgradeBtn:SetActive(false)
      if not self.isTemplateHero then
        local reachMaxStarMaxLevel = self.skillData.level >= self.skillData:GetMaxStarSkillMaxLevel()
        self.upgradeGotoRankText:SetActive(not reachMaxStarMaxLevel)
        self.maxLevelText:SetActive(reachMaxStarMaxLevel)
      else
        self.upgradeGotoRankText:SetActive(false)
        self.maxLevelText:SetActive(false)
      end
    else
      self.cost1:SetActive(true)
      self.cost2:SetActive(false)
      self.upgradeCondition:SetActive(false)
      self.upgradeBtn:SetActive(true)
      self.maxLevelText:SetActive(false)
      self.upgradeGotoRankText:SetActive(false)
      local skillPointId = DataCenter.HeroParamDataManager.heroSkillPointItemId
      local skillPointIcon = DataCenter.RewardManager:GetPicByType(RewardType.RESOURCE_ITEM, skillPointId)
      self.cost1Icon:LoadSprite(skillPointIcon)
      local haveSkillPoint = DataCenter.ResourceItemDataManager:GetCountByItemId(skillPointId)
      local need = self.skillData:GetUpgradeCostSkillPoint()
      if haveSkillPoint >= need then
        self.cost1Text:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveSkillPoint, need))
        self.upgradeBtnRedPoint:SetActive(HeroRedPointManager:GetInstance():IsHeroInSquad(self.heroData.uuid))
      else
        self.cost1Text:SetText(string.format("<color=#F97077>%d</color>/%d", haveSkillPoint, need))
        self.upgradeBtnRedPoint:SetActive(false)
      end
    end
  else
    self.cost1:SetActive(false)
    self.cost2:SetActive(false)
    self.upgradeCondition:SetActive(true)
    self.upgradeBtn:SetActive(false)
    local needRank = self.heroData:GetSkillUnlockRankByIndex(self.skillData:GetSlotIndex())
    local unlockLevel = self.heroData:GetSkillUnlockLevelByIndex(self.skillData:GetSlotIndex())
    if 1 < needRank then
      local rankName = DataCenter.HeroRankTemplateManager:GetRankName(needRank)
      self.upgradeConditionText:SetLocalText(300510, unlockLevel, rankName)
    else
      self.upgradeConditionText:SetLocalText(300505, unlockLevel)
    end
    self.gotoUpgradeHeroBtn:SetActive(true)
    self.maxLevelText:SetActive(false)
    self.upgradeGotoRankText:SetActive(false)
  end
end

local PHYSICAL_COLOR = Color.New(0.9764706, 0.4352941, 0.4666667, 1)
local ENERGY_COLOR = Color.New(0.7215686, 0.3254902, 0.9254902, 1)
local DEBUFF_COLOR = Color.New(1, 0.3215686, 0.2470588, 1)
local BUFF_COLOR = Color.New(0.454902, 0.8235294, 0.5254902, 1)

local function RefreshSelectedSkillDetail(self)
  if not self.skillData then
    return
  end
  local showSkillData = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeSkillInfoData(self.heroData, self.skillData)
  local nameStr = showSkillData:GetName()
  if self.skillData:IsUnlock() then
    self.skillNameText:SetText(nameStr)
    self.skillLevelText:SetText(string.format("Lv.%d", showSkillData:GetLevel()))
    self.skillLevelLimitText:SetText(string.format("/%d", showSkillData:GetMaxLevel()))
  else
    local resultStr = string.format("%s (%s)", nameStr, Localization:GetString(120050))
    self.skillNameText:SetText(resultStr)
    self.skillLevelText:SetText("")
    self.skillLevelLimitText:SetText("")
  end
  self.skillDescText:SetText(showSkillData:GetDesc(true))
  self.nextEffectGroup:RemoveComponents(UIHeroSkillEffectLineLink)
  self.nextEffectLineTemplate.gameObject:GameObjectRecycleAll()
  local effectsDesc = showSkillData:GetEffectsDesc()
  local isHeroAwakenSkill = showSkillData:IsHeroAwakenSkill()
  if 0 < #effectsDesc then
    for i = 1, #effectsDesc do
      self.nextEffectGroup:SetActive(true)
      local descText = HeroUtils.ProcessHyperText(effectsDesc[i].outDesc, nil, false)
      local item = self.nextEffectLineTemplate:GameObjectSpawn(self.nextEffectGroup.transform)
      item.name = "item" .. i
      local cell = self.nextEffectGroup:AddComponent(UIHeroSkillEffectLineLink, item.name)
      cell:SetData(effectsDesc[i].isUnlock, descText, i, isHeroAwakenSkill)
    end
  else
    self.nextEffectGroup:SetActive(false)
  end
  if showSkillData then
    self.playPreviewBtn:SetActive(showSkillData:IsShowSkillPreviewBtn())
  end
  local castType = showSkillData:GetSkillDisplayCastType()
  local cd = ""
  if castType == SkillCastType.AutoAttack then
    self.skill_type_txt:SetLocalText("skill_detail_panel_1")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetCoolDownTime(self.heroData))
  elseif castType == SkillCastType.Active then
    self.skill_type_txt:SetLocalText("skill_detail_panel_2")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetCoolDownTime(self.heroData))
  elseif castType == SkillCastType.Passive then
    self.skill_type_txt:SetLocalText("skill_detail_panel_4")
  elseif castType == SkillCastType.Talent then
    self.skill_type_txt:SetLocalText("skill_detail_panel_3")
  elseif castType == SkillCastType.HeroAwaken then
    self.skill_type_txt:SetLocalText("skill_detail_panel_12")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", showSkillData:GetPreCd())
  elseif castType == SkillCastType.None then
    self.skill_type_txt:SetLocalText("skill_detail_panel_0")
  else
    self.skill_type_txt:SetText("")
  end
  self.cd_txt:SetText(cd)
  local displayType = showSkillData:GetSkillDisplayType()
  if displayType == SkillDisplayType.None then
    self.damage_type:SetActive(false)
  else
    self.damage_type:SetActive(true)
    if displayType == SkillDisplayType.PhysicalDamage then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulishanghai.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_5")
      self.damage_type_txt:SetColor(PHYSICAL_COLOR)
      self.damage_type_icon:SetColor(WhiteColor)
    elseif displayType == SkillDisplayType.EnergyDamage then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangshanghai.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_6")
      self.damage_type_txt:SetColor(ENERGY_COLOR)
      self.damage_type_icon:SetColor(WhiteColor)
    elseif displayType == SkillDisplayType.PhysicalDefense then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_wulifangyu.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_7")
      self.damage_type_txt:SetColor(PHYSICAL_COLOR)
      self.damage_type_icon:SetColor(WhiteColor)
    elseif displayType == SkillDisplayType.EnergyDefense then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_jinengleixin_nengliangfangyu.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_8")
      self.damage_type_txt:SetColor(ENERGY_COLOR)
      self.damage_type_icon:SetColor(WhiteColor)
    elseif displayType == SkillDisplayType.Buff then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_injury.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_10")
      self.damage_type_txt:SetColor(BUFF_COLOR)
      self.damage_type_icon:SetColor(BUFF_COLOR)
    elseif displayType == SkillDisplayType.Debuff then
      self.damage_type_icon:LoadSprite("Assets/Main/Sprites/UI/UIHeroCommon/zyf_shibingzhuangtai_death.png")
      self.damage_type_txt:SetLocalText("skill_detail_panel_11")
      self.damage_type_txt:SetColor(DEBUFF_COLOR)
      self.damage_type_icon:SetColor(DEBUFF_COLOR)
    end
    self.damage_type_icon:SetNativeSize()
  end
  local isAwakenSkill = showSkillData:IsHeroAwakenSkill()
  self.compAwakenEffectValueLine:SetActive(isAwakenSkill)
  if isAwakenSkill and self.heroData ~= nil then
    local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroData.heroId, true)
    if awakenTemplate then
      local valueStr = awakenTemplate:GetAwakenEffectValueLineText()
      self.textAwakenEffectValueLine:SetText(valueStr)
    end
  end
  RefreshBtns(self)
end

local function RefreshHeroView(self)
  if not self.heroData then
    return
  end
  RefreshHeroBaseInfo(self)
  RefreshHeroSkillListInfo(self)
end

local function RefreshSkillView(self)
  if not self.skillData then
    return
  end
  RefreshSelectedSkillDetail(self)
end

local function RefreshView(self)
  RefreshHeroView(self)
  RefreshSkillView(self)
end

local function SetData(self, heroData, pageParam)
  if heroData == nil then
    return
  end
  self.heroData = heroData
  self.isTemplateHero = self.view:IsTemplateHero()
  if not self.isTemplateHero then
    self.view.ctrl:SaveHeroProp(heroData.uuid)
  end
  RefreshHeroView(self)
  self.selectedSkillIndex = nil
  if pageParam then
    SelectSkill(self, pageParam)
  else
    SelectSkill(self, 1)
  end
  self:HideUpgradeEffect()
  self.realPower:SetActive(not self.isTemplateHero)
  self.realPowerText:SetText(self.heroData.power)
end

local upgradeEffectPosition = Vector3.New(0, 13, 0)

local function ShowUpgradeEffect(self)
  if not self.selectedSkillIndex then
    return
  end
  local skillItem = self.skills[self.selectedSkillIndex]
  if not skillItem then
    return
  end
  self.upgradeEffect.transform:SetParent(skillItem.transform)
  self.upgradeEffect.transform.localPosition = upgradeEffectPosition
  self.upgradeEffect.transform.localScale = Vector3.one
  self.upgradeEffect:SetActive(false)
  self.upgradeEffect:SetActive(true)
  local ret = self.view.ctrl:GetHeroPropChange(self.heroData.uuid)
  if ret and ret.powerChange > 0 then
    self:ShowPowerChange(ret.powerChange, skillItem.transform)
    self.view.ctrl:SaveHeroProp(self.heroData.uuid)
  end
end

local function HideUpgradeEffect(self)
  self.upgradeEffect.transform:SetParent(self.skillList.transform)
  self.upgradeEffect:SetActive(false)
end

local function OnHeroSkillUpgrade(self)
  if self.heroData and self.selectedSkillIndex then
    self.skillData = self.heroData:GetHeroSkillBySlotIndex(self.selectedSkillIndex)
  end
  self:RefreshView()
  ShowUpgradeEffect(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_HERO_Upgrade, false)
end

local function OnResOrItemUpdate(self)
  if self.isTemplateHero == true then
    return
  end
  self:RefreshBtns()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkillUpgradeEnd, OnHeroSkillUpgrade)
  self:AddUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, OnResOrItemUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, OnHeroSkillUpgrade)
  self:RemoveUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  base.OnRemoveListener(self)
end

local function GetHeroSpineContainer(self)
  return self.heroSpineContainer
end

local function ShowPowerChange(self, power, srcTrans)
  if self.showPowerChangeCallBack == nil then
    function self.showPowerChangeCallBack(i)
      self:RecyclePowerTemplate(i)
    end
  end
  if self.showPowerChangeCallBackStep2 == nil then
    function self.showPowerChangeCallBackStep2()
      self.realPowerEffect:SetActive(false)
      
      self.realPowerEffect:SetActive(true)
      if self.realPowerText and self.heroData then
        self.realPowerText:SetText(self.heroData.power)
      end
    end
  end
  local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
  local src = srcTrans.position
  local dest = self.realPowerText.transform.position
  local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
  DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 1, parent, self.showPowerChangeCallBackStep2)
end

local function RecyclePowerTemplate(self, item)
  item.gameObject:SetActive(false)
  table.insert(self.powerChangePool, item)
end

local function GetPowerTemplate(self)
end

local function ClearTemplatePool(self)
  self.realPowerContent:RemoveComponents(UIHeroPowerChangeItem)
  self.showPowerChangeCallBack = nil
  self.showPowerChangeCallBackStep2 = nil
  self.powerChangePool = nil
end

local function GetHeroModelContainer(self)
  return nil
end

UIHeroSkillPage.OnCreate = OnCreate
UIHeroSkillPage.OnDestroy = OnDestroy
UIHeroSkillPage.OnEnable = OnEnable
UIHeroSkillPage.OnDisable = OnDisable
UIHeroSkillPage.DataDefine = DataDefine
UIHeroSkillPage.DataDestroy = DataDestroy
UIHeroSkillPage.ComponentDefine = ComponentDefine
UIHeroSkillPage.ComponentDestroy = ComponentDestroy
UIHeroSkillPage.SetData = SetData
UIHeroSkillPage.OnAddListener = OnAddListener
UIHeroSkillPage.OnRemoveListener = OnRemoveListener
UIHeroSkillPage.RefreshHeroView = RefreshHeroView
UIHeroSkillPage.RefreshSkillView = RefreshSkillView
UIHeroSkillPage.RefreshView = RefreshView
UIHeroSkillPage.SelectSkill = SelectSkill
UIHeroSkillPage.GetHeroSpineContainer = GetHeroSpineContainer
UIHeroSkillPage.RefreshBtns = RefreshBtns
UIHeroSkillPage.ShowUpgradeEffect = ShowUpgradeEffect
UIHeroSkillPage.HideUpgradeEffect = HideUpgradeEffect
UIHeroSkillPage.ShowPreviewSkillWindow = ShowPreviewSkillWindow
UIHeroSkillPage.ShowPowerChange = ShowPowerChange
UIHeroSkillPage.RecyclePowerTemplate = RecyclePowerTemplate
UIHeroSkillPage.GetPowerTemplate = GetPowerTemplate
UIHeroSkillPage.ClearTemplatePool = ClearTemplatePool
UIHeroSkillPage.GetHeroModelContainer = GetHeroModelContainer
return UIHeroSkillPage
