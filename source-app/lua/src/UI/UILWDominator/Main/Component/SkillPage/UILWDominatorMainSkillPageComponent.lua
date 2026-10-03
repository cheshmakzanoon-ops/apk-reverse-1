local base = require("UI/UILWDominator/Main/Component/UILWDominatorMainPageBaseComponent")
local UILWDominatorMainSkillPageComponent = BaseClass("UILWDominatorMainSkillPageComponent", base)
local Localization = CS.GameEntry.Localization
local UIHeroSkillItem = require("UI/UILWDominator/Main/Component/SkillPage/UILWDominatorSkillItemComponent")
local UIHeroSkillEffectLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillEffectLine")

function UILWDominatorMainSkillPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainSkillPageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainSkillPageComponent:ComponentDefine()
  self.btnInfo = self:AddComponent(UIButton, "Top/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textUserName = self:AddComponent(UIText, "NameContent/UserNameText")
  self.compUIHeroSkillItem01 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/UILWDominatorSkillItem01")
  self.compUIHeroSkillItem02 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/UILWDominatorSkillItem02")
  self.compUIHeroSkillItem03 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/UILWDominatorSkillItem03")
  self.compUIHeroSkillItem04 = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/UILWDominatorSkillItem04")
  self.compUIHeroSkillItems = {
    self.compUIHeroSkillItem01,
    self.compUIHeroSkillItem02,
    self.compUIHeroSkillItem03,
    self.compUIHeroSkillItem04
  }
  self.compSkillItemCenter = self:AddComponent(UIHeroSkillItem, "MainContent/SkillContent/SkillItemCenter")
  self.compEffectUpgrade = self:AddComponent(UIBaseContainer, "MainContent/SkillContent/EffectUpgrade")
  self.compEffectUpgrade:SetActive(false)
  self.textSkillName = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/firstLine/SkillNameAndLevel/SkillNameText")
  self.textSkillLevel = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/firstLine/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelText")
  self.textSkillLevelLimit = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/firstLine/SkillNameAndLevel/LevelAndLevelLimit/SkillLevelLimitText")
  self.textCdTxt = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/firstLine/cd_txt")
  self.textSkillTypeTxt = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/secondLine/skillType/skillType_txt")
  self.btnDamageType = self:AddComponent(UIButton, "MainContent/SkillInfoContent/ImgBg/secondLine/damageType")
  self.btnDamageType:SetOnClick(function()
    self:OnBtnDamageTypeClick()
  end)
  self.imgDamageTypeIcon = self:AddComponent(UIImage, "MainContent/SkillInfoContent/ImgBg/secondLine/damageType/damageTypeIcon")
  self.textDamageTypeTxt = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/secondLine/damageType/damageType_txt")
  self.textSkillInformationTitleTxt = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/thirdLine/skillInformationTitle_txt")
  self.btnPlayerPreview = self:AddComponent(UIButton, "MainContent/SkillInfoContent/ImgBg/thirdLine/PlayePreviewButton")
  self.btnPlayerPreview:SetOnClick(function()
    self:OnBtnPlayerPreviewClick()
  end)
  self.textSkillDesc = self:AddComponent(UIText, "MainContent/SkillInfoContent/ImgBg/forthLine/DescLayout/Viewport/Content/SkillDescText")
  self.compNextEffectGroup = self:AddComponent(UIBaseContainer, "MainContent/SkillInfoContent/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup")
  self.compNextEffectValueLine = self:AddComponent(UIBaseContainer, "MainContent/SkillInfoContent/ImgBg/forthLine/DescLayout/Viewport/Content/NextEffectGroup/NextEffectValueLine")
  self.compNextEffectValueLine.gameObject:GameObjectCreatePool()
  self.btnUpgrade = self:AddComponent(UIButton, "UpgradeContent/UpgradeContainer/UpgradeBtn")
  self.btnUpgrade:SetOnClick(function()
    self:OnBtnUpgradeClick()
  end)
  self.textUpgradeBtn = self:AddComponent(UIText, "UpgradeContent/UpgradeContainer/UpgradeBtn/UpgradeBtnText")
  self.compUpgradeBtnRedPoint = self:AddComponent(UIBaseContainer, "UpgradeContent/UpgradeContainer/UpgradeBtn/UpgradeBtnRedPoint")
  self.compUpgradeBtnRedPoint:SetActive(false)
  self.compCost1 = self:AddComponent(UIBaseContainer, "UpgradeContent/UpgradeContainer/CostGroup/Cost1")
  self.imgCost1Icon = self:AddComponent(UIImage, "UpgradeContent/UpgradeContainer/CostGroup/Cost1/Cost1Icon")
  self.textCost1 = self:AddComponent(UIText, "UpgradeContent/UpgradeContainer/CostGroup/Cost1/Cost1Text")
  self.compCost2 = self:AddComponent(UIBaseContainer, "UpgradeContent/UpgradeContainer/CostGroup/Cost2")
  self.compCost2:SetActive(false)
  self.imgCost2Icon = self:AddComponent(UIImage, "UpgradeContent/UpgradeContainer/CostGroup/Cost2/Cost2Icon")
  self.textCost2 = self:AddComponent(UIText, "UpgradeContent/UpgradeContainer/CostGroup/Cost2/Cost2Text")
  self.compUpgradeContainer = self:AddComponent(UIText, "UpgradeContent/UpgradeContainer")
  self.compUpgradeCondition = self:AddComponent(UIBaseContainer, "UpgradeContent/UpgradeCondition")
  self.textUpgradeCondition = self:AddComponent(UIText, "UpgradeContent/UpgradeCondition/UpgradeConditionText")
  self.btnGotoUpgradeHero = self:AddComponent(UIButton, "UpgradeContent/GotoUpgradeHeroBtn")
  self.btnGotoUpgradeHero:SetOnClick(function()
    self:OnBtnGotoUpdateDominatorClick()
  end)
  self.textGotoUpgradeHeroBtn = self:AddComponent(UIText, "UpgradeContent/GotoUpgradeHeroBtn/GotoUpgradeHeroBtnText")
  self.textMaxLevel = self:AddComponent(UIText, "UpgradeContent/MaxLevelText")
  self.textMaxLevel:SetLocalText("dominator_star_desc_1")
  self.textPower = self:AddComponent(UIText, "PowerContent/PowerText")
  self.compPowerEffect = self:AddComponent(UIBaseContainer, "PowerContent/PowerText/PowerEffect")
  self.compPowerEffect:SetActive(false)
  self.btnLeftSwitch = self:AddComponent(UIButton, "PowerContent/LeftSwitchBtn")
  self.btnLeftSwitch:SetOnClick(function()
    self:OnBtnLeftSwitchClick()
  end)
  self.btnRightSwitch = self:AddComponent(UIButton, "PowerContent/RightSwitchBtn")
  self.btnRightSwitch:SetOnClick(function()
    self:OnBtnRightSwitchClick()
  end)
end

function UILWDominatorMainSkillPageComponent:ComponentDestroy()
  self.btnInfo = nil
  self.textUserName = nil
  self.compUIHeroSkillItem01 = nil
  self.compUIHeroSkillItem02 = nil
  self.compUIHeroSkillItem03 = nil
  self.compUIHeroSkillItem04 = nil
  self.compSkillItemCenter = nil
  self.textSkillName = nil
  self.textSkillLevel = nil
  self.textSkillLevelLimit = nil
  self.textCdTxt = nil
  self.textSkillTypeTxt = nil
  self.imgDamageTypeIcon = nil
  self.textDamageTypeTxt = nil
  self.btnDamageType = nil
  self.textSkillInformationTitleTxt = nil
  self.btnPlayerPreview = nil
  self.textSkillDesc = nil
  self.compNextEffectGroup = nil
  self.compNextEffectValueLine.gameObject:GameObjectRecycleAll()
  self.compNextEffectValueLine = nil
  self.btnUpgrade = nil
  self.textUpgradeBtn = nil
  self.compUpgradeContainer = nil
  self.compUpgradeBtnRedPoint = nil
  self.compCost1 = nil
  self.imgCost1Icon = nil
  self.textCost1 = nil
  self.compCost2 = nil
  self.imgCost2Icon = nil
  self.textCost2 = nil
  self.compUpgradeCondition = nil
  self.textUpgradeCondition = nil
  self.btnGotoUpgradeHero = nil
  self.textGotoUpgradeHeroBtn = nil
  self.textMaxLevel = nil
  self.compUIHeroSkillItems = nil
  self.textPower = nil
  self.compPowerEffect = nil
  self.compEffectUpgrade = nil
  self.btnLeftSwitch = nil
  self.btnRightSwitch = nil
end

function UILWDominatorMainSkillPageComponent:DataDefine()
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
  self.updatePowerAnimFinishCallBack = nil
end

function UILWDominatorMainSkillPageComponent:DataDestroy()
  self.clickSkillCallBack = nil
  self.updatePowerAnimFinishCallBack = nil
end

function UILWDominatorMainSkillPageComponent:ReInit()
  if not self.view then
    return
  end
  self.info = self.view:GetCurShowInfo()
  if not self.info then
    return
  end
  self.mainTemplate = self.info:GetMainTemplate()
  if not self.mainTemplate then
    return
  end
  self.compEffectUpgrade:SetActive(false)
  self.compPowerEffect:SetActive(false)
  self:ResetSkillPageSelectSkillSlotIndex()
  self:UpdateUserName()
  self:UpdateSkillItems()
  self:UpdateSkillItemsSelect()
  self:UpdateSkillInfo()
  self:UpdateBtns()
  self:UpdatePower()
end

function UILWDominatorMainSkillPageComponent:ResetSkillPageSelectSkillSlotIndex()
  if self.mainTemplate then
    self.selectSkillSlotIndex = self.mainTemplate:GetCenterSkillIndex()
  else
    self.selectSkillSlotIndex = 1
  end
end

function UILWDominatorMainSkillPageComponent:SetSkillPageSelectSkillSlotIndex(index)
  self.selectSkillSlotIndex = index
end

function UILWDominatorMainSkillPageComponent:GetSkillPageSelectSkillSlotIndex()
  return self.selectSkillSlotIndex
end

function UILWDominatorMainSkillPageComponent:GetSkillPageSelectSkillInfo()
  local index = self:GetSkillPageSelectSkillSlotIndex()
  if self.info then
    return self.info:GetSkillInfoBySlotIndex(index)
  end
end

function UILWDominatorMainSkillPageComponent:UpdateUserName()
  if not self.info then
    return
  end
  self.textUserName:SetText(self.info:GetUserName())
end

function UILWDominatorMainSkillPageComponent:UpdateSkillItems()
  if not self.info then
    return
  end
  local count = self.info:GetTotalSkillCount()
  if count <= 0 then
    return
  end
  local normalSkillIndex = 1
  local centerSkillIndex = self.mainTemplate:GetCenterSkillIndex()
  for i = 1, count do
    local skillData = self.info:GetSkillInfoBySlotIndex(i)
    local isCenter = i == centerSkillIndex
    local isUnlock = false
    local showRedPoint = false
    if not skillData or self.mainTemplate:IsShowSkillBySkillGroup(skillData:GetGroupId()) then
      if skillData and skillData:IsUnlock() then
        isUnlock = true
        if not skillData:IsReachMaxLevel() then
          local mainTemplate = self.info:GetMainTemplate()
          if mainTemplate then
            local skillPointId = mainTemplate:GetSkillUpgradeCostItemId()
            if skillPointId then
              local haveSkillPoint = DataCenter.ItemData:GetItemCount(skillPointId)
              local need = skillData:GetUpgradeCostSkillPoint()
              if haveSkillPoint >= need then
                showRedPoint = true
              end
            end
          end
        end
      end
      if isCenter then
        self.compSkillItemCenter:SetData(skillData, {
          showSkillName = false,
          showSkillLevel = true,
          showLock = true,
          showRedPoint = showRedPoint,
          showStar = true,
          showSkillLevel = isUnlock
        }, self.clickSkillCallBack)
      else
        if self.compUIHeroSkillItems[normalSkillIndex] then
          self.compUIHeroSkillItems[normalSkillIndex]:SetData(skillData, {
            showSkillName = false,
            showSkillLevel = true,
            showLock = true,
            showRedPoint = showRedPoint,
            showStar = true,
            showSkillLevel = isUnlock
          }, self.clickSkillCallBack)
        end
        normalSkillIndex = normalSkillIndex + 1
      end
    end
  end
end

function UILWDominatorMainSkillPageComponent:UpdateSkillItemsSelect()
  local curSelectSkillIndex = self:GetSkillPageSelectSkillSlotIndex()
  local centerSkillIndex = self.mainTemplate:GetCenterSkillIndex()
  self.compSkillItemCenter:SetSelected(curSelectSkillIndex == centerSkillIndex)
  for i, v in pairs(self.compUIHeroSkillItems) do
    local skillData = v:GetSkillData()
    if skillData then
      v:SetSelected(curSelectSkillIndex == skillData:GetSlotIndex())
    end
  end
end

function UILWDominatorMainSkillPageComponent:UpdateSkillInfo()
  local skillInfo = self:GetSkillPageSelectSkillInfo()
  if not skillInfo or not self.info then
    return
  end
  local name = skillInfo:GetName()
  local isUnlocked = skillInfo:IsUnlock()
  if isUnlocked then
    self.textSkillName:SetText(name)
    self.textSkillLevel:SetText(string.format("Lv.%d", skillInfo:GetLevel()))
    self.textSkillLevelLimit:SetText(string.format("/%d", skillInfo:GetMaxLevel()))
  else
    self.textSkillName:SetText(string.format("%s (%s)", name, Localization:GetString(120050)))
    self.textSkillLevel:SetText("")
    self.textSkillLevelLimit:SetText("")
  end
  self.textSkillDesc:SetText(skillInfo:GetDesc(true))
  self:ClearSkillInfoEffect()
  local effectInfo = skillInfo:GetEffectsDesc()
  if 0 < #effectInfo then
    for i = 1, #effectInfo do
      self.compNextEffectGroup:SetActive(true)
      local item = self.compNextEffectValueLine.gameObject:GameObjectSpawn(self.compNextEffectGroup.transform)
      item.name = "skillItem" .. i
      local cell = self.compNextEffectGroup:AddComponent(UIHeroSkillEffectLine, item.name)
      cell:SetData(effectInfo[i].isUnlock, effectInfo[i].outDesc, i)
    end
  else
    self.compNextEffectGroup:SetActive(false)
  end
  self.btnPlayerPreview:SetActive(false)
  local castType = skillInfo:GetSkillDisplayCastType()
  local cd = ""
  if castType == SkillCastType.AutoAttack then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_1")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", skillInfo:GetCoolDownTime(self.info))
  elseif castType == SkillCastType.Active then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_2")
    cd = string.format("CD:<color=#5FEF87>%.2fs</color>", skillInfo:GetCoolDownTime(self.info))
  elseif castType == SkillCastType.Passive then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_4")
  elseif castType == SkillCastType.Talent then
    self.textSkillTypeTxt:SetLocalText("skill_detail_panel_3")
  else
    self.textSkillTypeTxt:SetText("")
  end
  self.textCdTxt:SetText(cd)
  local displayType = skillInfo:GetSkillDisplayType()
  if displayType == SkillDisplayType.None then
    self.btnDamageType:SetActive(false)
  else
    self.btnDamageType:SetActive(true)
    local icon = self.view.ctrl:GetSkillDamageTypeIcon(displayType)
    if not string.IsNullOrEmpty(icon) then
      self.imgDamageTypeIcon:LoadSprite(icon)
      self.imgDamageTypeIcon:SetNativeSize()
    end
    local damageTypeIconColor = self.view.ctrl:GetSkillDamageTypeIconColor(displayType)
    if damageTypeIconColor then
      self.imgDamageTypeIcon:SetColor(damageTypeIconColor)
    end
    local damageTypeText = self.view.ctrl:GetSkillDamageTypeText(displayType)
    self.textDamageTypeTxt:SetText(damageTypeText)
    local damageTypeTextColor = self.view.ctrl:GetSkillDamageTypeTextColor(displayType)
    if damageTypeTextColor then
      self.textDamageTypeTxt:SetColor(damageTypeTextColor)
    end
  end
end

function UILWDominatorMainSkillPageComponent:ClearSkillInfoEffect()
  self.compNextEffectGroup:RemoveComponents(UIHeroSkillEffectLine)
  self.compNextEffectValueLine.gameObject:GameObjectRecycleAll()
end

function UILWDominatorMainSkillPageComponent:UpdateBtns()
  local skillInfo = self:GetSkillPageSelectSkillInfo()
  if skillInfo == nil or self.info == nil then
    return
  end
  local isUnlocked = skillInfo:IsUnlock()
  self.btnGotoUpgradeHero:SetActive(not isUnlocked)
  self.compUpgradeCondition:SetActive(not isUnlocked)
  self.compUpgradeContainer:SetActive(isUnlocked)
  self.textMaxLevel:SetActive(isUnlocked)
  if isUnlocked then
    local isMaxLevel = skillInfo:IsReachMaxLevel()
    self.btnUpgrade:SetActive(not isMaxLevel)
    self.compCost1:SetActive(not isMaxLevel)
    self.textMaxLevel:SetActive(isMaxLevel)
    if not isMaxLevel then
      local mainTemplate = self.info:GetMainTemplate()
      if mainTemplate then
        local skillPointId = mainTemplate:GetSkillUpgradeCostItemId()
        local skillPointIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, skillPointId)
        self.imgCost1Icon:LoadSprite(skillPointIcon)
        local haveSkillPoint = DataCenter.ItemData:GetItemCount(skillPointId)
        local need = skillInfo:GetUpgradeCostSkillPoint()
        if haveSkillPoint >= need then
          self.textCost1:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveSkillPoint, need))
        else
          self.textCost1:SetText(string.format("<color=#F97077>%d</color>/%d", haveSkillPoint, need))
        end
      end
    end
  else
    local needRank = self.info:GetSkillUnlockRankByIndex(skillInfo:GetSlotIndex())
    local rankGroup = 0
    local info = self.view:GetCurShowInfo()
    if info then
      local rankTemplate = info:GetCurRankTemplate()
      if rankTemplate then
        rankGroup = rankTemplate.group
      end
    end
    self.textUpgradeCondition:SetLocalText("dominator_skill_lock_desc_4", needRank)
  end
end

function UILWDominatorMainSkillPageComponent:OnSkillUpgradeCallback(evt)
  self:UpdateBtns()
  self:UpdateSkillItems()
  self:UpdateSkillItemsSelect()
  self:UpdateSkillInfo()
  if evt and evt.skillSlotIndex then
    self:PlaySkillUpgradeAnim(evt.skillSlotIndex)
  end
end

function UILWDominatorMainSkillPageComponent:UpdatePower()
  if self.view and self.textPower then
    local info = self.view:GetCurShowInfo()
    if info then
      self.textPower:SetText(tostring(info:GetPower()))
    end
  end
  if self.view then
    local allMainIdList = self.view:GetAllMainIdList()
    if allMainIdList then
      local allCount = table.count(allMainIdList)
      local curIndex = self.view:GetCurShowMainIdIndex()
      self.btnLeftSwitch:SetActive(1 < curIndex)
      self.btnRightSwitch:SetActive(allCount > curIndex)
    end
  end
end

function UILWDominatorMainSkillPageComponent:PlaySkillUpgradeAnim(targetSkillSlotIndex)
  if self.mainTemplate then
    local targetTrans
    local centerSkillIndex = self.mainTemplate:GetCenterSkillIndex()
    if targetSkillSlotIndex == centerSkillIndex then
      targetTrans = self.compSkillItemCenter.transform
      self.compEffectUpgrade:SetLocalScaleXYZ(ResetScale.x, ResetScale.y, ResetScale.z)
      self.compEffectUpgrade:SetAnchoredPositionXY(self.compSkillItemCenter:GetAnchoredPositionX(), self.compEffectUpgrade:GetAnchoredPositionY())
    else
      self.compEffectUpgrade:SetLocalScaleXYZ(0.9, 0.9, 0.9)
      for i, v in pairs(self.compUIHeroSkillItems) do
        local skillInfo = v:GetSkillData()
        if skillInfo and skillInfo:GetSlotIndex() == targetSkillSlotIndex then
          targetTrans = v.transform
          self.compEffectUpgrade:SetAnchoredPositionXY(v:GetAnchoredPositionX(), self.compEffectUpgrade:GetAnchoredPositionY())
          break
        end
      end
    end
    if targetTrans then
      self.compEffectUpgrade:SetActive(false)
      self.compEffectUpgrade:SetActive(true)
      if self.updatePowerAnimFinishCallBack == nil then
        function self.updatePowerAnimFinishCallBack()
          if self.compPowerEffect then
            self.compPowerEffect:SetActive(false)
            
            self.compPowerEffect:SetActive(true)
          end
          self:UpdatePower()
        end
      end
      local path = "Assets/_Art_LastWar/Effect/Prefab/UI/Yingxiongxiangqing/Eff_ui_hero_xiangqing_shengji_jingyan.prefab"
      local src = targetTrans.position
      local dest = self.textPower.transform.position
      local parent = UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform
      DataCenter.FlyController.DoFlyWithBezierFunc(path, src, dest, 1, parent, self.updatePowerAnimFinishCallBack)
    else
      self:UpdatePower()
    end
  end
end

function UILWDominatorMainSkillPageComponent:OnRefreshItems()
  self:UpdateBtns()
end

function UILWDominatorMainSkillPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DominatorSkillUpgradeSuccess, self.OnSkillUpgradeCallback)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function UILWDominatorMainSkillPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.DominatorSkillUpgradeSuccess, self.OnSkillUpgradeCallback)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function UILWDominatorMainSkillPageComponent:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("dominator_skill_desc_1")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UILWDominatorMainSkillPageComponent:OnBtnGotoUpdateDominatorClick()
  self.view:SetCurShowPageTag(UILWDominatorMainPageTag.Rank)
end

function UILWDominatorMainSkillPageComponent:OnBtnUpgradeClick()
  local skillInfo = self:GetSkillPageSelectSkillInfo()
  if skillInfo == nil or self.info == nil then
    return
  end
  local skillReachMaxLevel = skillInfo:IsReachMaxLevel()
  if skillReachMaxLevel then
    return
  end
  local mainTemplate = self.info:GetMainTemplate()
  if mainTemplate then
    local skillPointId = mainTemplate:GetSkillUpgradeCostItemId()
    if 0 < skillPointId then
      local haveSkillPoint = DataCenter.ItemData:GetItemCount(skillPointId)
      local need = skillInfo:GetUpgradeCostSkillPoint()
      if haveSkillPoint >= need then
        DataCenter.DominatorManager:SendSkillUpgradeMessage(self.info.uuid, skillInfo:GetSlotIndex())
      else
        LWResourceLackUtil:GotoGoodsItemLack(skillPointId, need)
      end
    end
  end
end

function UILWDominatorMainSkillPageComponent:OnBtnDamageTypeClick()
  local skillInfo = self:GetSkillPageSelectSkillInfo()
  if skillInfo == nil or self.info == nil then
    return
  end
  local displayType = skillInfo:GetSkillDisplayType()
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

function UILWDominatorMainSkillPageComponent:OnClickSkillItem(skillInfo, skillItem)
  if not skillInfo then
    return
  end
  local slotIndex = skillInfo:GetSlotIndex()
  local curIndex = self:GetSkillPageSelectSkillSlotIndex()
  if curIndex ~= slotIndex then
    self:SetSkillPageSelectSkillSlotIndex(slotIndex)
    self:UpdateSkillItemsSelect()
    self:UpdateSkillInfo()
    self:UpdateBtns()
  end
end

function UILWDominatorMainSkillPageComponent:OnBtnPlayerPreviewClick()
  local skillInfo = self:GetSkillPageSelectSkillInfo()
  if skillInfo == nil or self.info == nil then
    return
  end
  local mainTemplate = self.info:GetMainTemplate()
  if mainTemplate then
    local heroTemplate = mainTemplate:GetHeroTemplate()
    if heroTemplate then
      local heroId = heroTemplate.id
      local skillId = skillInfo:GetId()
      local skillLv = skillInfo:GetLevel()
      local skillMaxLv = skillInfo:GetMaxLevel()
      local weaponLv = 0
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPreviewSkillWindow, {anim = true}, heroId, skillId, skillLv, skillMaxLv, weaponLv)
    end
  end
end

function UILWDominatorMainSkillPageComponent:OnBtnLeftSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  if 1 < curIndex then
    local newIndex = curIndex - 1
    local allMainIdList = self.view:GetAllMainIdList()
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

function UILWDominatorMainSkillPageComponent:OnBtnRightSwitchClick()
  local curIndex = self.view:GetCurShowMainIdIndex()
  local allMainIdList = self.view:GetAllMainIdList()
  local allCount = 0
  if allMainIdList then
    allCount = table.count(allMainIdList)
  end
  if curIndex < allCount then
    local newIndex = curIndex + 1
    self.view:SetCurShowMainId(allMainIdList[newIndex])
  end
end

return UILWDominatorMainSkillPageComponent
