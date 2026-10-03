local UIHeroRankPage = BaseClass("UIHeroRankPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroPreviewLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPreviewLine")
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local UIHeroPowerChangeItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPowerChangeItem")
local ResourceManager = CS.GameEntry.Resource
local rankTextPath = "CenterHeroInfo/RankText"
local rankStarContainerPath = "RightTopInfo/StarContainer"
local rankStarTemplatePath = "RightTopInfo/StarContainer/RankStar"
local heroSpineContainerPath = "RightTopInfo/HeroSpineContainer"
local hpLinePath = "CenterHeroInfo/ContentContainer/UpgradeLines/HpLine"
local atkLinePath = "CenterHeroInfo/ContentContainer/UpgradeLines/AtkLine"
local defLinePath = "CenterHeroInfo/ContentContainer/UpgradeLines/DefLine"
local LineEffectPath = "CenterHeroInfo/ContentContainer/UpgradeLines/LineEffect"
local skillListPath = "CenterHeroInfo/ContentContainer/SkillList"
local skill1Path = "CenterHeroInfo/ContentContainer/SkillList/Skill1"
local skill2Path = "CenterHeroInfo/ContentContainer/SkillList/Skill2"
local skill3Path = "CenterHeroInfo/ContentContainer/SkillList/Skill3"
local skill4Path = "CenterHeroInfo/ContentContainer/SkillList/Skill4"
local skill1EnhanceTipPath = "CenterHeroInfo/ContentContainer/SkillList/Skill1/Skill1EnhanceTip"
local skill2EnhanceTipPath = "CenterHeroInfo/ContentContainer/SkillList/Skill2/Skill2EnhanceTip"
local skill3EnhanceTipPath = "CenterHeroInfo/ContentContainer/SkillList/Skill3/Skill3EnhanceTip"
local skill4EnhanceTipPath = "CenterHeroInfo/ContentContainer/SkillList/Skill4/Skill4EnhanceTip"
local improveBtnContainerPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer"
local improveBtnPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer/ImproveBtn"
local improveBtnRedPointPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer/ImproveBtn/ImproveBtnRedPoint"
local improveBtnCostGroupPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer/CostGroup"
local improveBtnCostIconPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer/CostGroup/CostIcon"
local improveBtnCostTextPath = "CenterBottomInfo/btnLayOut/ImproveBtnContainer/CostGroup/CostText"
local maxRankTipTextPath = "CenterBottomInfo/MaxRankTipText"
local exchangeBtnPath = "CenterBottomInfo/btnLayOut/ExchangeBtnItem/ExchangeBtn"
local exchangeBtnCommonFragIcon = "CenterBottomInfo/ExchangeBtn/CommonFragIcon"
local exchangeBtnCommonFragCountText = "CenterBottomInfo/ExchangeBtn/CommonFragCountText"
local heroNickNameTextPath = "CenterHeroInfo/HeroNickNameText"
local heroNameTextPath = "CenterHeroInfo/HeroNameText"
local powerTextPath = "CenterHeroInfo/PowerInfo/RealPower"
local realPowerPath = "CenterHeroInfo/PowerInfo"
local realPowerEffectPath = "CenterHeroInfo/PowerInfo/RealPower/Effect"
local realPowerContentPath = "CenterHeroInfo/PowerInfo/PowerEffectContent"
local starContentPath = "CenterHeroInfo/HeroRankStar"
local heroHonorContainerPath = "CenterBottomInfo/HeroHonorContainer"
local heroHonorTipTextPath = "CenterBottomInfo/HeroHonorContainer/HeroHonorTipText"
local heroHonorGotoBtnPath = "CenterBottomInfo/HeroHonorContainer/HeroHonorGotoBtn"
local heroHonorGotoBtnTextPath = "CenterBottomInfo/HeroHonorContainer/HeroHonorGotoBtn/HeroHonorGotoBtnText"
local heroHonorInfoBtnPath = "CenterBottomInfo/HeroHonorContainer/HeroHonorInfoBtn"

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

local function OnClickImproveBtn(self)
  if not self.heroData then
    return
  end
  if self.heroData:IsReachMaxRank() then
    return
  end
  local fragId = self.heroData:GetHeroFragId()
  local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
  local costFragCount = self.heroData:GetUpgradeRankCost()
  if haveFragCount >= costFragCount then
    SFSNetwork.SendMessage(MsgDefines.UpgradeHeroRank, self.heroData.uuid, 0)
  elseif CS.SceneManager:IsInPVE() then
    UIUtil.ShowTipsId("quick_upgrade_tips")
  else
    LWResourceLackUtil:GotoGoodsItemLack(fragId, costFragCount)
  end
end

local function OnClickExchangeBtn(self)
  if self.heroData ~= nil then
    local commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
    local costCount = self.heroData:GetUpgradeRankCost()
    local fragCount = DataCenter.ItemData:GetItemCount(self.heroData:GetHeroFragId())
    local commonFragCount = DataCenter.ItemData:GetItemCount(commonFragId)
    local count = costCount - fragCount
    if commonFragCount >= count then
      SFSNetwork.SendMessage(MsgDefines.UpgradeHeroRank, self.heroData.uuid, 1)
    elseif CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_tips")
    else
      LWResourceLackUtil:GotoGoodsItemLack(commonFragId, costCount - fragCount)
    end
  end
end

local function OnClickSkillItem(self, skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillDetailPanel, {anim = true}, skillData, skillItem)
end

local function ComponentDefine(self)
  self.rankText = self:AddComponent(UIText, rankTextPath)
  self.rankStarContainer = self:AddComponent(UIBaseContainer, rankStarContainerPath)
  self.rankStarTemplate = self.transform:Find(rankStarTemplatePath).gameObject
  self.rankStarTemplate:GameObjectCreatePool()
  self.heroSpineContainer = self:AddComponent(UIBaseContainer, heroSpineContainerPath)
  self.hpLine = self:AddComponent(UIHeroPreviewLine, hpLinePath)
  self.atkLine = self:AddComponent(UIHeroPreviewLine, atkLinePath)
  self.defLine = self:AddComponent(UIHeroPreviewLine, defLinePath)
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
  self.skill1EnhanceTip = self:AddComponent(UIImage, skill1EnhanceTipPath)
  self.skill2EnhanceTip = self:AddComponent(UIImage, skill2EnhanceTipPath)
  self.skill3EnhanceTip = self:AddComponent(UIImage, skill3EnhanceTipPath)
  self.skill4EnhanceTip = self:AddComponent(UIImage, skill4EnhanceTipPath)
  self.skillEnhanceTips = {
    self.skill1EnhanceTip,
    self.skill2EnhanceTip,
    self.skill3EnhanceTip,
    self.skill4EnhanceTip
  }
  self.improveBtnContainer = self:AddComponent(UIBaseContainer, improveBtnContainerPath)
  self.improveBtn = self:AddComponent(UIButton, improveBtnPath)
  self.improveBtn:SetOnClick(function()
    OnClickImproveBtn(self)
  end)
  self.improveBtnRedPoint = self:AddComponent(UIImage, improveBtnRedPointPath)
  self.improveBtnCostGroup = self:AddComponent(UIBaseContainer, improveBtnCostGroupPath)
  self.improveBtnCostIcon = self:AddComponent(UIImage, improveBtnCostIconPath)
  self.improveBtnCostText = self:AddComponent(UIText, improveBtnCostTextPath)
  self.maxRankTipText = self:AddComponent(UIText, maxRankTipTextPath)
  self.exchangeBtn = self:AddComponent(UIButton, exchangeBtnPath)
  self.exchangeBtnItem = self:AddComponent(UIBaseContainer, "CenterBottomInfo/btnLayOut/ExchangeBtnItem")
  self.exchangeBtn:SetOnClick(function()
    OnClickExchangeBtn(self)
  end)
  self.heroNickNameText = self:AddComponent(UIText, heroNickNameTextPath)
  self.heroNameText = self:AddComponent(UIText, heroNameTextPath)
  self.lineEffect = self:AddComponent(UIBaseContainer, LineEffectPath)
  self.groupLayOut = self:AddComponent(UIBaseContainer, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut")
  self.lineEffect:SetActive(false)
  self.realPower = self:AddComponent(UIBaseContainer, realPowerPath)
  self.realPowerText = self:AddComponent(UIText, powerTextPath)
  self.realPowerEffect = self:AddComponent(UIBaseContainer, realPowerEffectPath)
  self.realPowerContent = self:AddComponent(UIBaseContainer, realPowerContentPath)
  self.realPowerPrefab = self.realPowerContent.transform:Find("PowerChangeItem")
  self.realPowerPrefab.gameObject:SetActive(false)
  self.powerChangePool = {}
  self.starContent = self:AddComponent(UIBaseContainer, starContentPath)
  self.starMap = {}
  for i = 1, 5 do
    local star = self.starContent:AddComponent(UIImage, "Star" .. i)
    local data = {}
    data.root = star
    data.inner = {}
    self.starMap[i] = data
  end
  self.exchangeComItem = self:AddComponent(UIBaseContainer, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup2")
  self.exchangeHeroItem = self:AddComponent(UIBaseContainer, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup1")
  self.exchangeComText = self:AddComponent(UIText, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup2/CostText2")
  self.exchangeHeroText = self:AddComponent(UIText, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup1/CostText1")
  self.exchangeHeroIcon = self:AddComponent(UIImage, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup1/CostIcon1")
  self.exchangeComIcon = self:AddComponent(UIImage, "CenterBottomInfo/btnLayOut/ExchangeBtnItem/groupLayOut/CostGroup2/CostIcon2")
  self.heroHonorContainer = self:AddComponent(UIBaseContainer, heroHonorContainerPath)
  self.heroHonorTipText = self:AddComponent(UIText, heroHonorTipTextPath)
  self.heroHonorGotoBtn = self:AddComponent(UIButton, heroHonorGotoBtnPath)
  self.heroHonorGotoBtnText = self:AddComponent(UIText, heroHonorGotoBtnTextPath)
  self.heroHonorInfoBtn = self:AddComponent(UIButton, heroHonorInfoBtnPath)
  self.heroHonorGotoBtn:SetOnClick(function()
    if CS.SceneManager:IsInPVE() then
      UIUtil.ShowTipsId("quick_upgrade_block_tips")
      return
    end
    if self.heroData then
      local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[self.heroData.heroType])
      local unlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
      if typeBuilding and unlockLevel <= typeBuilding.level then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOF, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, self.heroData.heroType, self.heroData.uuid)
      else
        GoToUtil.GotoCityByBuildId(HeroTypeBuilding[self.heroData.heroType], WorldTileBtnType.City_Upgrade)
      end
    end
  end)
  self.heroHonorInfoBtn:SetOnClick(function()
    local param = {
      activityRulesStr = Localization:GetString("110307")
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
end

local function DataDefine(self)
  self.heroData = nil
  self.clickSkillCallBack = BindCallback(self, OnClickSkillItem)
end

local function ComponentDestroy(self)
  self:ClearTemplatePool()
  self.rankText = nil
  self.rankStarContainer = nil
  self.rankStarTemplate.gameObject:GameObjectRecycleAll()
  self.rankStarTemplate = nil
  self.heroSpineContainer = nil
  self.hpLine = nil
  self.atkLine = nil
  self.defLine = nil
  self.skillList = nil
  self.skill1 = nil
  self.skill2 = nil
  self.skill3 = nil
  self.skill4 = nil
  self.skills = nil
  self.skill1EnhanceTip = nil
  self.skill2EnhanceTip = nil
  self.skill3EnhanceTip = nil
  self.skill4EnhanceTip = nil
  self.skillEnhanceTips = nil
  self.improveBtnContainer = nil
  self.improveBtn = nil
  self.improveBtnRedPoint = nil
  self.improveBtnCostGroup = nil
  self.improveBtnCostIcon = nil
  self.improveBtnCostText = nil
  self.maxRankTipText = nil
  self.exchangeBtn = nil
  self.exchangeBtnCommonFragIcon = nil
  self.exchangeBtnCommonFragCountText = nil
end

local function DataDestroy(self)
  self.heroData = nil
  self.clickSkillCallBack = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.lineEffect:SetActive(false)
  self.active = false
end

local function OnResOrItemUpdate(self)
  if self.isTemplateHero == true then
    return
  end
  self:RefreshImproveBtn()
end

local function OnUpgradeHeroRank(self)
  self:RefreshView()
  local ret = self.view.ctrl:GetHeroPropChange(self.heroData.uuid)
  if ret and ret.powerChange > 0 then
    self:ShowPowerChange(ret.powerChange, self.starContent.transform)
    self.view.ctrl:SaveHeroProp(self.heroData.uuid)
  end
  self.lineEffect:SetActive(false)
  self.lineEffect:SetActive(true)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_HERO_RANK_CHANGE, false)
  if not self.heroData then
    return
  end
  local newUnlockSkill = self.heroData:GetRankUnlockSkill()
  if table.IsNullOrEmpty(newUnlockSkill) then
    return
  end
  local skillData = newUnlockSkill[1]
  local heroData = self.heroData
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroUnlockNewSkillPanel, {anim = true}, skillData, heroData, self.view:GetSkillPageTogglePosition())
  self.heroData:SetSkillPageRedPoint()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:AddUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:AddUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:AddUIListener(EventId.HeroUpgradeRank, OnUpgradeHeroRank)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.ResourceUpdated, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.RefreshItems, OnResOrItemUpdate)
  self:RemoveUIListener(EventId.HeroUpgradeRank, OnUpgradeHeroRank)
end

local function RefreshRankBaseInfo(self)
  if not self.heroData then
    return
  end
  local rankTemplate = self.heroData.rankTemplate
  if not rankTemplate then
    return
  end
  self.rankText:SetLocalText(rankTemplate.name)
  local fragId = self.heroData:GetHeroFragId()
  local fragIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, fragId)
  local commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
  self.exchangeComIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, commonFragId))
  self.exchangeHeroIcon:LoadSprite(fragIcon)
  local curStar, maxStar = self.heroData.rankTemplate:GetStarCount()
  self.rankStarContainer:RemoveComponents(UIHeroSkillStar)
  self.rankStarTemplate.gameObject:GameObjectRecycleAll()
  if 0 < maxStar then
    for i = 1, maxStar do
      self.rankStarContainer:SetActive(true)
      local item = self.rankStarTemplate:GameObjectSpawn(self.rankStarContainer.transform)
      item.name = "star" .. i
      local cell = self.rankStarContainer:AddComponent(UIHeroSkillStar, item.name)
      cell:SetFilled(i <= curStar)
      if i <= curStar then
        cell:SetStarIndex(i)
      end
    end
  else
    self.rankStarContainer:SetActive(false)
  end
end

local function RefreshRankDetail(self)
  if not self.heroData then
    return
  end
  local isReachMaxRank = self.heroData:IsReachMaxRank()
  if not isReachMaxRank then
    local nextRankTemplate = DataCenter.HeroRankTemplateManager:GetTemplate(self.heroData.rank + 1)
    if not nextRankTemplate then
      return
    end
    local hpFactor = self.heroData:GetHpFactor()
    local curHp = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.HealthPoint, false) * hpFactor
    curHp = tostring(math.floor(curHp))
    local nextHp = nextRankTemplate:GetEffectAdd(HeroEffectDefine.HealthPoint, false) * hpFactor
    nextHp = tostring(math.floor(nextHp))
    self.hpLine:SetData(curHp, nextHp)
    local atkFactor = self.heroData:GetAtkFactor()
    local curAtk = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalAttack, false) * atkFactor
    curAtk = tostring(math.floor(curAtk))
    local nextAtk = nextRankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalAttack, false) * atkFactor
    nextAtk = tostring(math.floor(nextAtk))
    self.atkLine:SetData(curAtk, nextAtk)
    local defFactor = self.heroData:GetDefFactor()
    local curDef = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalDefense, false) * defFactor
    curDef = tostring(math.floor(curDef))
    local nextDef = nextRankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalDefense, false) * defFactor
    nextDef = tostring(math.floor(nextDef))
    self.defLine:SetData(curDef, nextDef)
  else
    local hpFactor = self.heroData:GetHpFactor()
    local hp = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.HealthPoint, false)
    hp = tostring(math.floor(hp * hpFactor))
    self.hpLine:SetData(hp)
    local atkFactor = self.heroData:GetAtkFactor()
    local atk = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalAttack, false)
    atk = tostring(math.floor(atk * atkFactor))
    self.atkLine:SetData(atk)
    local defFactor = self.heroData:GetDefFactor()
    local def = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalDefense, false)
    def = tostring(math.floor(def * defFactor))
    self.defLine:SetData(def)
  end
  self:ShowRank(self.heroData.rank, self.heroData.meta.maxRank)
end

local function RefreshImproveBtn(self)
  if not self.heroData then
    return
  end
  if self.heroData:IsReachMaxRank() then
    self.improveBtnContainer:SetActive(false)
    self.exchangeBtn:SetActive(false)
    self.groupLayOut:SetActive(false)
    self.maxRankTipText:SetActive(false)
    self.heroHonorContainer:SetActive(true)
    local typeBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[self.heroData.heroType])
    local unlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
    if typeBuilding and unlockLevel <= typeBuilding.level then
      self.heroHonorTipText:SetLocalText(110305)
      self.heroHonorGotoBtnText:SetLocalText(110003)
    else
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(HeroTypeBuilding[self.heroData.heroType])
      if buildTemplate then
        self.heroHonorTipText:SetLocalText(110304, Localization:GetString(buildTemplate.name), unlockLevel)
        self.heroHonorGotoBtnText:SetLocalText(151056)
      end
    end
  else
    self.improveBtnContainer:SetActive(true)
    self.exchangeBtn:SetActive(true)
    self.groupLayOut:SetActive(true)
    self.maxRankTipText:SetActive(false)
    self.heroHonorContainer:SetActive(false)
    local fragId = self.heroData:GetHeroFragId()
    local fragIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, fragId)
    self.improveBtnCostIcon:LoadSprite(fragIcon)
    local haveFragCount = DataCenter.ItemData:GetItemCount(fragId)
    local costFragCount = self.heroData:GetUpgradeRankCost()
    if haveFragCount >= costFragCount then
      self.exchangeComItem:SetActive(false)
      self.improveBtnCostText:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveFragCount, costFragCount))
      self.improveBtnRedPoint:SetActive(true)
      self.exchangeBtnItem:SetActive(false)
    else
      self.commonFragId = DataCenter.HeroParamDataManager:GetQualityFragmentIdByQuality(self.heroData)
      local commonHeroFragCount = DataCenter.ItemData:GetItemCount(self.commonFragId)
      local count = costFragCount - haveFragCount
      local colour = commonHeroFragCount >= count and "<color=#5FEF87>%d</color>/%d" or "<color=#F97077>%d</color>/%d"
      self.exchangeHeroItem:SetActive(haveFragCount ~= 0)
      self.exchangeComText:SetText(string.format(colour, commonHeroFragCount, count))
      self.exchangeComItem:SetActive(true)
      self.exchangeHeroText:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveFragCount, haveFragCount))
      self.improveBtnCostText:SetText(string.format("<color=#F97077>%d</color>/%d", haveFragCount, costFragCount))
      self.improveBtnRedPoint:SetActive(false)
      self.exchangeBtnItem:SetActive(true)
    end
  end
end

local function RefreshHeroskillList(self)
  for i = 1, 4 do
    local skillData = self.heroData:GetHeroSkillBySlotIndex(i)
    local unlockLevel = 0
    if skillData and not skillData:IsUnlock() then
      unlockLevel = self.heroData:GetSkillUnlockLevelByIndex(i)
    end
    self.skills[i]:SetData(skillData, {
      showSkillName = false,
      showSkillLevel = true,
      showLock = true,
      showRedPoint = false,
      showStar = true,
      unlockLevel = unlockLevel
    }, self.clickSkillCallBack)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.skillList.transform)
  local isReachMaxRank = self.heroData:IsReachMaxRank()
  if not isReachMaxRank then
    local upgradeStarSkills = {}
    local heroSkills = self.heroData:GetAllSkills()
    for skillId, skillData in pairs(heroSkills) do
      if skillData then
        local isReachMaxStar = skillData:IsReachMaxStar()
        if not isReachMaxStar then
          local nextStarSkillId = skillData:GetId() + 1
          local nextStarSkillTempalte = DataCenter.HeroSkillTemplateManager:GetTemplate(nextStarSkillId)
          if nextStarSkillTempalte and nextStarSkillTempalte.needRank <= self.heroData.rank + 1 then
            upgradeStarSkills[skillData:GetSlotIndex()] = true
          end
        end
      end
    end
    for index, enhanceTip in pairs(self.skillEnhanceTips) do
      if upgradeStarSkills[index] then
        self.skills[index]:ShowNewStarEffect()
      else
      end
    end
    upgradeStarSkills = nil
  else
    for index, enhanceTip in pairs(self.skillEnhanceTips) do
      enhanceTip:SetActive(false)
    end
  end
end

local function RefreshView(self)
  RefreshHeroskillList(self)
  RefreshRankBaseInfo(self)
  RefreshRankDetail(self)
  RefreshImproveBtn(self)
  self.realPowerText:SetText(self.heroData.power)
end

local function SetData(self, heroData)
  if not heroData then
    return
  end
  self.heroData = heroData
  self.isTemplateHero = self.view:IsTemplateHero()
  if self.isTemplateHero then
    self.realPower:SetActive(false)
  else
    self.realPower:SetActive(true)
    self.heroNickNameText:SetText(self.heroData:GetNickName())
    self.heroNameText:SetText(self.heroData:GetName())
    self.view.ctrl:SaveHeroProp(heroData.uuid)
  end
  RefreshView(self)
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

local function ShowRank(self, rank, maxRank)
  local starNum = (maxRank - 1) / 5
  for i = 1, 5 do
    if i <= starNum then
      self.starMap[i].root:SetActive(true)
      local rankGroup = math.floor((rank - 1) / 5) + 1
      local innerRank = (rank - 1) % 5
      if i < rankGroup then
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_5")
      elseif i == rankGroup and 0 < innerRank then
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/UILWHeroDetail/cfm_biandui_xingxing_" .. innerRank)
      else
        self.starMap[i].root:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/lyp_yingxiongxing_01.png")
      end
    else
      self.starMap[i].root:SetActive(false)
    end
  end
end

local function GetHeroModelContainer(self)
  return nil
end

UIHeroRankPage.OnCreate = OnCreate
UIHeroRankPage.OnDestroy = OnDestroy
UIHeroRankPage.OnEnable = OnEnable
UIHeroRankPage.OnDisable = OnDisable
UIHeroRankPage.OnAddListener = OnAddListener
UIHeroRankPage.OnRemoveListener = OnRemoveListener
UIHeroRankPage.ComponentDefine = ComponentDefine
UIHeroRankPage.DataDefine = DataDefine
UIHeroRankPage.ComponentDestroy = ComponentDestroy
UIHeroRankPage.DataDestroy = DataDestroy
UIHeroRankPage.RefreshRankBaseInfo = RefreshRankBaseInfo
UIHeroRankPage.RefreshRankDetail = RefreshRankDetail
UIHeroRankPage.RefreshImproveBtn = RefreshImproveBtn
UIHeroRankPage.RefreshView = RefreshView
UIHeroRankPage.RefreshHeroskillList = RefreshHeroskillList
UIHeroRankPage.SetData = SetData
UIHeroRankPage.GetHeroSpineContainer = GetHeroSpineContainer
UIHeroRankPage.ClearTemplatePool = ClearTemplatePool
UIHeroRankPage.GetPowerTemplate = GetPowerTemplate
UIHeroRankPage.RecyclePowerTemplate = RecyclePowerTemplate
UIHeroRankPage.ShowPowerChange = ShowPowerChange
UIHeroRankPage.ShowRank = ShowRank
UIHeroRankPage.GetHeroModelContainer = GetHeroModelContainer
return UIHeroRankPage
