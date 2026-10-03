local UIHeroInfoDetail = BaseClass("UIHeroInfoDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGray = CS.UIGray
local UIHeroSkillMedalNum = require("UI.UIHero2.Common.UIHeroSkillMedalNum")
local UIHeroStars = require("UI.UIHero2.Common.UIHeroStars")
local UIHeroMilitaryRankIcon = require("UI.UIHero2.UIHeroInfo.Component.UIHeroMilitaryRankIcon")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.fromType = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataChanged)
  self:AddUIListener(EventId.HeroStarUpBack, self.OnHeroStarUp)
  self:AddUIListener(EventId.ResourceUpdated, self.OnRefreshItems)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
  self:AddUIListener(EventId.HeroAdvanceGuide, self.DoHeroAdvanceGuide)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroAdvanceGuide, self.DoHeroAdvanceGuide)
  self:RemoveUIListener(EventId.HeroStarUpBack, self.OnHeroStarUp)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataChanged)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnRefreshItems)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.SkillUpgradeEnd, self.OnHandleSkillUpgrade)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.levelBg = self:AddComponent(UIBaseContainer, "TopNode/levelBg")
  self.textTitleLevel = self:AddComponent(UIText, "TopNode/levelBg/TextTitleLevel")
  self.textCurLevel = self:AddComponent(UIText, "TopNode/levelBg/TextTitleLevel/TextCurLevel")
  self.textExp = self:AddComponent(UIText, "TopNode/levelBg/SliderExp/TextValueExp")
  self.sliderExp = self:AddComponent(UISlider, "TopNode/levelBg/SliderExp")
  self.btnUpgrade = self:AddComponent(UIButton, "TopNode/levelBg/BtnUpgrade")
  self.btnUpgradeRedPoint = self:AddComponent(UIButton, "TopNode/levelBg/BtnUpgrade/UpgradeRedPoint")
  self.btnUpgradeRedPoint:SetActive(false)
  self.btnBeyond = self:AddComponent(UIButton, "TopNode/levelBg/BtnBeyond")
  self.imgBeyondGreen = self:AddComponent(UIImage, "TopNode/levelBg/BtnBeyond/ImgBeyondGreen")
  self.imgBeyondYellow = self:AddComponent(UIImage, "TopNode/levelBg/BtnBeyond/ImgBeyondYellow")
  self.beyondEffect = self:AddComponent(UIBaseContainer, "TopNode/VFX_yingxiong_shengji_tishi_glow")
  self.beyondEffect:SetActive(false)
  self.textValueAttack = self:AddComponent(UIText, "TopNode/NodeAttrAttack/TextValueAttack")
  self.textValueDefence = self:AddComponent(UIText, "TopNode/NodeAttrDefence/TextValueDefence")
  self.textValueArmy = self:AddComponent(UIText, "TopNode/NodeAttrArmy/TextValueArmy")
  self.btnAtk = self:AddComponent(UIButton, "TopNode/NodeAttrAttack")
  self.btnDef = self:AddComponent(UIButton, "TopNode/NodeAttrDefence")
  self.btnArmy = self:AddComponent(UIButton, "TopNode/NodeAttrArmy")
  self.btnAtk:SetOnClick(BindCallback(self, self.OnBtnAtkClick))
  self.btnDef:SetOnClick(BindCallback(self, self.OnBtnDefClick))
  self.btnArmy:SetOnClick(BindCallback(self, self.OnBtnArmyClick))
  self.skillMedal = self:AddComponent(UIHeroSkillMedalNum, "TopNode/UIHeroSkillMedalNum")
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
    local redDot = self:AddComponent(UIBaseContainer, "skillBg/SkillContent/Skill" .. k .. "/RedDot" .. k)
    local upgradeEffect = self:AddComponent(UIBaseContainer, "skillBg/SkillContent/Skill" .. k .. "/Vfx_yingxiong_tubiao_tishi_" .. k)
    table.insert(self.btnSkills, {
      btn = nodeBtn,
      icon = imgIcon,
      lvBg = imgLvBg,
      lock = imgLock,
      textLv = textLevel,
      nodeFx = nodeEffect,
      redDot = redDot,
      upgradeEffect = upgradeEffect
    })
  end
  self.btnBeyond:SetOnClick(BindCallback(self, self.OnBtnBeyondClick))
  self.btnUpgrade:SetOnClick(BindCallback(self, self.OnClickBtnHeroUpgrade))
  self.textTitleLevel:SetLocalText(100082)
  self.textTitleSkill:SetLocalText(150106)
  self.heroStarBg = self:AddComponent(UIBaseContainer, "TopNode/starBg")
  self.heroStar = self:AddComponent(UIHeroStars, "TopNode/starBg/UIHeroStars1")
  self.heroDebrisIcon = self:AddComponent(UIImage, "TopNode/starBg/UIHeroDebrisIcon")
  self.heroUpgradeStarBtn = self:AddComponent(UIButton, "TopNode/starBg/UIHeroUpgradeStarBtn")
  self.starIntroBtn = self:AddComponent(UIButton, "TopNode/starBg/StarIntroBtn")
  self.starIntroBtn:SetOnClick(BindCallback(self, self.OnStarIntroClick))
  self.heroUpgradeStarBtn:SetOnClick(BindCallback(self, self.OnHeroUpgradeStarClick))
  self.heroUpgradeStarRedPoint = self:AddComponent(UIButton, "TopNode/starBg/UIHeroUpgradeStarBtn/RedPoint")
  self.heroUpgradeStarRedPoint:SetActive(false)
  self.holeImg = self:AddComponent(UIBaseContainer, "HoleImg")
  self.maskImg = self:AddComponent(UIImage, "HoleImg/MaskImg")
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.maskImg.rectTransform.sizeDelta = Vector2.New(Screen.width / scaleFactor, Screen.height / scaleFactor)
end

local function ComponentDestroy(self)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function InitData(self, param, fromType)
  self.fromType = fromType
  if fromType == self.view.FromType.HeroList then
    self.heroUuid = param
  elseif fromType == self.view.FromType.HeroMap or fromType == self.view.FromType.SingleHeroId then
    self.heroId = param
  elseif fromType == self.view.FromType.HeroDetail then
    self.heroMapData = param
  end
  self:RefreshView()
end

local function ResetTopNodePosition(self)
  local heroId
  if self.fromType == self.view.FromType.HeroList then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData ~= nil then
      heroId = heroData.heroId
    end
  elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
    heroId = self.heroId
  elseif self.fromType == self.view.FromType.HeroDetail then
    heroId = self.heroMapData.heroId
  end
  if heroId ~= nil then
  end
end

local function RefreshView(self)
  local heroId, level, maxLevel, curExp, totalExp, atk, def, rankId, quality
  local isReachFinalLimit = false
  local camp = -1
  self.skillMedal:RefreshView()
  local army
  self.heroUpgradeStarBtn:SetActive(false)
  self.skillMedal:SetActive(false)
  if self.fromType == self.view.FromType.HeroList then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    local needBeyond = heroData.isMaster and heroData:IsReachBreakLimit()
    rankId = heroData:GetRank()
    heroId = heroData.heroId
    level = heroData.level
    quality = heroData.quality
    maxLevel = heroData:GetCurMaxLevel()
    totalExp = HeroUtils.GetLevelUpNeedExp(needBeyond and level - 1 or level)
    curExp = needBeyond and totalExp + heroData.exp or heroData.exp
    isReachFinalLimit = level == heroData:GetFinalLevel()
    atk = heroData.atk
    def = heroData.def
    camp = heroData.camp
    local upgradeShowFlag = heroData.isMaster and not needBeyond and heroData.level < heroData:GetFinalLevel()
    self.btnUpgrade:SetActive(upgradeShowFlag)
    self.btnUpgradeRedPoint:SetActive(upgradeShowFlag and heroData:ShowUpGradeRedPoint())
    self.btnBeyond:SetActive(needBeyond)
    self.beyondEffect:SetActive(false)
    if self.delayTimer == nil and needBeyond then
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.beyondEffect:SetActive(self.btnBeyond:GetActive())
        local pos = self.btnBeyond.transform.position
        self.beyondEffect.transform:Set_position(pos.x, pos.y + 5, pos.z)
        if self.delayTimer ~= nil then
          self.delayTimer:Stop()
          self.delayTimer = nil
        end
      end, 1)
    end
    self.heroUpgradeStarBtn:SetActive(not HeroUtils.IsReachStarLimit(heroData))
    self.heroUpgradeStarRedPoint:SetActive(heroData:CanUpgradeStar())
    if needBeyond then
      self:CheckBeyondRes()
    end
    self.skillMedal:SetActive(true)
  elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
    heroId = self.heroId
    maxLevel = 1
    level = maxLevel
    quality = 1
    totalExp = HeroUtils.GetLevelUpNeedExp(maxLevel)
    curExp = 0
    atk, def = HeroUtils.GetMaxAttrForHeroMap(heroId, quality, level, 0)
    atk = Mathf.Round(atk)
    def = Mathf.Round(def)
    camp = HeroUtils.GetCampByHeroId(heroId)
    self.btnUpgrade:SetActive(false)
    self.btnBeyond:SetActive(false)
    self.beyondEffect:SetActive(false)
  elseif self.fromType == self.view.FromType.HeroDetail then
    heroId = self.heroMapData.heroId
    maxLevel = self.heroMapData.level
    level = self.heroMapData.level
    totalExp = HeroUtils.GetLevelUpNeedExp(maxLevel)
    curExp = totalExp
    atk, def = HeroUtils.GetHeroAttr(heroId, self.heroMapData.quality, self.heroMapData.level, HeroUtils.GetBeyondTimesByLevel(self.heroMapData.level), self.heroMapData.rank)
    atk = Mathf.Round(atk)
    def = Mathf.Round(def)
    army = self.heroMapData.army
    camp = HeroUtils.GetCampByHeroId(heroId)
    self.btnUpgrade:SetActive(false)
    self.btnBeyond:SetActive(false)
    self.beyondEffect:SetActive(false)
  end
  self.textCurLevel:SetText(level)
  if isReachFinalLimit then
    self.textExp:SetLocalText(150027)
    self.sliderExp:SetValue(1.0)
  else
    local percent = curExp / totalExp
    if 1 < percent then
      percent = 1
    end
    self.textExp:SetText(string.format("%s/%s", curExp, totalExp))
    self.sliderExp:SetValue(percent)
  end
  local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  self.heroConfig = config
  rankId = rankId or config.max_rank_level
  quality = quality or config.max_star_level
  local campExAtk = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraAtkByCamp(camp))
  campExAtk = Mathf.Round(campExAtk * 10) / 10
  campExAtk = math.tointeger(campExAtk) or campExAtk
  local atkStr = tostring(atk)
  if 0 < campExAtk then
    atkStr = atkStr .. " <color=#BCEE22><size=24>+" .. campExAtk .. "</size></color>"
  end
  local campExDef = LuaEntry.Effect:GetGameEffect(HeroUtils.GetExtraDefByCamp(camp))
  campExDef = Mathf.Round(campExDef * 10) / 10
  campExDef = math.tointeger(campExDef) or campExDef
  local defStr = tostring(def)
  if 0 < campExDef then
    defStr = defStr .. " <color=#BCEE22><size=24>+" .. campExDef .. "</size></color>"
  end
  self.textValueAttack:SetText(atkStr)
  self.textValueDefence:SetText(defStr)
  if army then
    self.textValueArmy:SetText(army)
  else
    self.textValueArmy:SetText(HeroUtils.GetArmyLimit(level, rankId, config.rarity, config.id, quality))
  end
  self:UpdateSkills()
  local param = {}
  param.showStarNum = quality
  param.maxStarNum = HeroUtils.GetMaxStarLevel(config.id)
  param.progressType = UIHeroStarProgressType.UIHeroStarProgressType_Block
  param.showBG = true
  self.heroStar:SetData(param)
  local heroDebrisId = HeroUtils.GetHeroDebrisIdByHeroId(heroId)
  self.heroDebrisIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(heroDebrisId))
  self:ResetTopNodePosition()
end

local function CheckBeyondRes(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if not heroData.isMaster then
    self.imgBeyondGreen:SetActive(false)
    self.imgBeyondYellow:SetActive(true)
    return false
  end
  local canBeyond = heroData:CanBeyond()
  self.imgBeyondGreen:SetActive(canBeyond)
  self.imgBeyondYellow:SetActive(not canBeyond)
end

local function OnClickBtnHeroUpgrade(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData.level >= heroData:GetFinalLevel() then
    return
  end
  if not heroData.isMaster then
    return
  end
  if heroData:NeedBeyond() then
    UIUtil.ShowTipsId(129085)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroLvUp, self.heroUuid)
end

local function OnBtnBeyondClick(self)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if not heroData.isMaster then
    return
  end
  local maxLevel = HeroUtils.GetMaxLevelByQuality(heroData.heroId, heroData.quality)
  if maxLevel <= heroData.level then
    local name = Localization:GetString(heroData.config.name)
    local quality = HeroUtils.GetNextMaxLevelByQuality(heroData.heroId, heroData.quality, heroData.level)
    local star = HeroUtils.GetHeroStarAndProgress(quality)
    if star <= 0 then
      return
    end
    local heroName = string.format("<color='%s'>%s</color>", HeroUtils.GetRarityColorStr(heroData.rarity), name)
    UIUtil.ShowMessage(Localization:GetString("129232", heroName, tostring(star)), 1, GameDialogDefine.GOTO, GameDialogDefine.CANCEL, function()
      self.view.modelViewer:ToggleSceneVisible(false)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvanceSuccess, self.heroUuid)
    end)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBeyond, self.heroUuid)
end

local function OnHeroStarUp(self)
  self:RefreshView()
end

local function OnHeroDataChanged(self, heroUuid)
  if self.heroUuid ~= heroUuid then
    return
  end
  self:RefreshView()
end

local function OnHeroAdvanceSuccess(self)
  self:RefreshView()
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

local function OnRefreshItems(self)
  self:RefreshView()
end

local function UpdateSkills(self)
  local config, heroData
  if self.fromType == self.view.FromType.HeroList then
    heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    config = heroData.config
  elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
    config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.heroId)
  else
    return
  end
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
      local skillData
      local unlock = true
      if heroData ~= nil then
        skillData = heroData:GetSkillData(skillId)
        if skillData ~= nil then
          level = skillData:GetLevel()
          unlock = heroData:IsSkillUnlock(skillId)
        end
      else
        level = 0
        unlock = false
      end
      local canUpgrade = false
      if heroData ~= nil and heroData:IsSkillCanUpgrade(skillId) then
        local costMedalId = config.skill_levelup_item
        local costMedalNum = config.skill_levelup_num
        local currentNum = DataCenter.ItemData:GetItemCount(costMedalId)
        if level <= table.count(costMedalNum) then
          local needNum = costMedalNum[level]
          canUpgrade = currentNum >= needNum
        end
      end
      t.lvBg:SetActive(unlock)
      t.lock:SetActive(unlock)
      UIGray.SetGray(t.btn.transform, not unlock, true)
      t.textLv:SetText(level)
      t.textLv:SetActive(unlock)
      t.redDot:SetActive(canUpgrade)
      t.upgradeEffect:SetActive(canUpgrade)
    end
  end
end

local function OnHandleSkillUpgrade(self, message)
  self:UpdateSkills()
end

local function OnBtnSkillClick(self, index)
  local config, heroData
  if self.fromType == self.view.FromType.HeroList then
    heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    config = heroData.config
  elseif self.fromType == self.view.FromType.HeroMap or self.fromType == self.view.FromType.SingleHeroId then
    config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.heroId)
  else
    return
  end
  local skillIdList = config.skill
  if type(skillIdList) ~= "table" then
    skillIdList = string.split(skillIdList, "|")
  end
  local skillId = tonumber(skillIdList[index])
  local level = HeroUtils.SkillLevelLimit
  local unlock = true
  local unlockQuality = 1
  if heroData ~= nil then
    local skillData = heroData:GetSkillData(skillId)
    if skillData ~= nil then
      level = skillData:GetLevel()
      unlock = heroData:IsSkillUnlock(skillId)
      unlockQuality = skillData.unlockQuality
    end
  else
    local type2 = tonumber(GetTableData(TableName.SkillTab, skillId, "type2"))
    if type2 == 11 then
      level = 1
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
  param.isUnlock = unlock
  param.skillLevel = level
  param.skillIndex = index
  param.skillUnlockQuality = unlockQuality
  param.heroRarity = self.heroConfig.rarity
  param.heroUuid = self.heroUuid
  param.pivot = 0.75 + index * 0.03
  param.position = position + Vector3.New(0, 55, 0) * scaleFactor
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillTip, {anim = false}, param)
end

local function OptimalCheckPassed(self)
end

local function GetBtnUpSizeDelta(self)
  return self.btnUpgrade.transform.position
end

local function GetBtnSkill(self, skillId)
  if self.btnSkillsDict[skillId] then
    return self.btnSkillsDict[skillId].btn.transform.position
  end
end

local function OnHeroUpgradeStarClick(self)
  self.view:OnBtnAdvanceClick()
end

local function ShowHeroStarUpHoleImg(self)
  local btn = self:GetGuideStarUpBtn()
  if btn ~= nil then
    self.holeImg:SetActive(true)
    self.holeImg.transform:Set_position(btn.transform:Get_position())
    self.maskImg.transform:Set_position(ResetPosition)
  end
end

local function GetGuideStarUpBtn(self)
  return self.heroUpgradeStarBtn
end

local function HideHeroStarUpHoleImg(self)
  self.holeImg:SetActive(false)
end

local function DoHeroAdvanceGuide(self, param)
  local eventType = param.eventType
  local quality = param.quality
  if eventType == HeroAdvanceGuideSignalType.Enter then
  elseif eventType == HeroAdvanceGuideSignalType.ShowHeroStarUpBlack then
    self:ShowHeroStarUpHoleImg()
  elseif eventType == HeroAdvanceGuideSignalType.HideHeroStarUpBlack then
    self:HideHeroStarUpHoleImg()
  end
end

local function ShowArrowToUpgradeStar(self)
  TimerManager:GetInstance():DelayInvoke(function()
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.heroUpgradeStarBtn.transform.position
    param.isReversal = true
    DataCenter.ArrowManager:ShowArrow(param)
  end, 0.5)
end

local function ShowArrowToBeyond(self)
  TimerManager:GetInstance():DelayInvoke(function()
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.btnBeyond.transform.position
    param.isReversal = true
    DataCenter.ArrowManager:ShowArrow(param)
  end, 0.5)
end

local function OnStarIntroClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.heroDebrisIcon.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  local star = 0
  local progress = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  if heroData then
    star, progress = HeroUtils.GetHeroStarAndProgress(heroData.quality)
  elseif self.heroId ~= nil then
    local quality = HeroUtils.GetMaxStarLevel(self.heroId)
    star, progress = HeroUtils.GetHeroStarAndProgress(quality)
  end
  param.content = Localization:GetString("129270", star, progress)
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIHeroInfoDetail.OnCreate = OnCreate
UIHeroInfoDetail.OnDestroy = OnDestroy
UIHeroInfoDetail.OnEnable = OnEnable
UIHeroInfoDetail.OnDisable = OnDisable
UIHeroInfoDetail.ComponentDefine = ComponentDefine
UIHeroInfoDetail.ComponentDestroy = ComponentDestroy
UIHeroInfoDetail.OnAddListener = OnAddListener
UIHeroInfoDetail.OnRemoveListener = OnRemoveListener
UIHeroInfoDetail.InitData = InitData
UIHeroInfoDetail.RefreshView = RefreshView
UIHeroInfoDetail.OnClickBtnHeroUpgrade = OnClickBtnHeroUpgrade
UIHeroInfoDetail.OnBtnBeyondClick = OnBtnBeyondClick
UIHeroInfoDetail.ResetTopNodePosition = ResetTopNodePosition
UIHeroInfoDetail.OnHeroDataChanged = OnHeroDataChanged
UIHeroInfoDetail.OnHeroAdvanceSuccess = OnHeroAdvanceSuccess
UIHeroInfoDetail.OnRefreshItems = OnRefreshItems
UIHeroInfoDetail.OnBtnAtkClick = OnBtnAtkClick
UIHeroInfoDetail.OnBtnDefClick = OnBtnDefClick
UIHeroInfoDetail.OnBtnArmyClick = OnBtnArmyClick
UIHeroInfoDetail.UpdateSkills = UpdateSkills
UIHeroInfoDetail.OnHandleSkillUpgrade = OnHandleSkillUpgrade
UIHeroInfoDetail.OnBtnSkillClick = OnBtnSkillClick
UIHeroInfoDetail.OptimalCheckPassed = OptimalCheckPassed
UIHeroInfoDetail.GetBtnSkill = GetBtnSkill
UIHeroInfoDetail.GetBtnUpSizeDelta = GetBtnUpSizeDelta
UIHeroInfoDetail.CheckBeyondRes = CheckBeyondRes
UIHeroInfoDetail.OnHeroUpgradeStarClick = OnHeroUpgradeStarClick
UIHeroInfoDetail.OnHeroStarUp = OnHeroStarUp
UIHeroInfoDetail.ShowHeroStarUpHoleImg = ShowHeroStarUpHoleImg
UIHeroInfoDetail.HideHeroStarUpHoleImg = HideHeroStarUpHoleImg
UIHeroInfoDetail.GetGuideStarUpBtn = GetGuideStarUpBtn
UIHeroInfoDetail.DoHeroAdvanceGuide = DoHeroAdvanceGuide
UIHeroInfoDetail.ShowArrowToUpgradeStar = ShowArrowToUpgradeStar
UIHeroInfoDetail.ShowArrowToBeyond = ShowArrowToBeyond
UIHeroInfoDetail.OnStarIntroClick = OnStarIntroClick
return UIHeroInfoDetail
