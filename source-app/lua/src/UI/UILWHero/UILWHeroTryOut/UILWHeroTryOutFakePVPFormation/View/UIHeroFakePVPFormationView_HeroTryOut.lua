local base = require("UI/UILWHero/UIHeroFakePVPFormationPanel/View/UIHeroFakePVPFormationPanelView")
local UIHeroFakePVPFormationView_HeroTryOut = BaseClass("UIHeroFakePVPFormationView_HeroTryOut", base)
local UIFormationTrailHeroCell_HeroTryOut = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutParkourFormation.Component.UIFormationTrailHeroCell_HeroTryOut")
local UILWHeroTryOutFormationGuideContentComponent = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutParkourFormation.Component.UILWHeroTryOutFormationGuideContentComponent")
local Localization = CS.GameEntry.Localization

function UIHeroFakePVPFormationView_HeroTryOut:DataDefine()
  base.DataDefine(self)
  self.tryHeroesDataInit = false
  self.tryHeroesUuidToDataMap = {}
end

function UIHeroFakePVPFormationView_HeroTryOut:DataDestroy()
  base.DataDestroy(self)
  self.tryHeroesDataInit = nil
  self.tryHeroesUuidToDataMap = nil
end

function UIHeroFakePVPFormationView_HeroTryOut:ComponentDefine()
  base.ComponentDefine(self)
  self.compHeroTryOutGuide = self:AddComponent(UILWHeroTryOutFormationGuideContentComponent, "Root/MiddleContentContainer/FormationContent/UILWHeroTryOutFormationGuideContent")
end

function UIHeroFakePVPFormationView_HeroTryOut:ComponentDestroy()
  base.ComponentDestroy(self)
  self.compHeroTryOutGuide = nil
end

function UIHeroFakePVPFormationView_HeroTryOut:OnOpen()
  base.OnOpen(self)
  if self.param1 == nil or self.param1.cfgId == nil then
    return
  end
  self.compHeroTryOutGuide:ReInit(self.param1.cfgId)
end

function UIHeroFakePVPFormationView_HeroTryOut:OnInitHeroScroll(go, index)
  local item = self.heroScroll:AddComponent(UIFormationTrailHeroCell_HeroTryOut, go)
  self.heroListGO[go] = item
end

function UIHeroFakePVPFormationView_HeroTryOut:ClearHeroScroll()
  self.heroScroll:RemoveComponents(UIFormationTrailHeroCell_HeroTryOut)
  self.heroList:DestroyChildNode()
end

function UIHeroFakePVPFormationView_HeroTryOut:InitTryHeroData()
  if not self.tryHeroesDataInit then
    self.tryHeroesUuidToDataMap = {}
    self.tryHeroesDataInit = true
    local allHeroDataDict = self.squadData:GetAllHeroDataDict()
    if not table.IsNullOrEmpty(allHeroDataDict) then
      for uuid, heroData in pairs(allHeroDataDict) do
        self.tryHeroesUuidToDataMap[uuid] = heroData
        self.hasTryHeroes = true
      end
    end
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:GetHeroList(heroType)
  local heroList = {}
  self:InitTryHeroData()
  if self.tryHeroesUuidToDataMap then
    for uuid, v in pairs(self.tryHeroesUuidToDataMap) do
      if heroType == 0 or heroType == v.heroType then
        local displayData = {}
        displayData.heroData = v
        local inSquad = self.squadData:HasLocalHero(uuid)
        if inSquad then
          displayData.squadIndex = self.squadIndex
        end
        table.insert(heroList, displayData)
      end
    end
  end
  table.sort(heroList, function(a, b)
    return a.heroData.power > b.heroData.power
  end)
  return heroList
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshSquadData()
  if self.param1 == nil or self.param1.cfgId == nil then
    return
  end
  self.squadData = DataCenter.HeroTryOutManager:GetArmyFormationInfoByHeroTryOutId(self.param1.cfgId)
  self.squadData:ClearLocalHeroes()
  self.squadData:ResetLocalData()
  self.slotCount = 5
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param1.cfgId)
  if tryOutTemplate ~= nil and tryOutTemplate.lattice_type > 0 then
    self.squadData:SetFormationPositionType(tryOutTemplate.lattice_type)
  end
  self:RefreshHeroInfo()
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshHeroInfo()
  if not self.squadData then
    return
  end
  self.heroes = self.squadData:GetLocalAllHeroes()
  local totalCombatPower = 0
  local heroCount = 0
  for i = 1, self.slotCount do
    local hasHero = self.heroes[i] ~= nil
    if hasHero then
      local heroUuid = self.heroes[i]
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData == nil and self.hasTryHeroes and self.tryHeroesUuidToDataMap then
        heroData = self.tryHeroesUuidToDataMap[heroUuid]
      end
      if heroData ~= nil then
        if heroData.fromTemplate then
          self.heroInfoBars[i]:SetDataByHeroInfo(heroData)
        else
          self.heroInfoBars[i]:SetData(heroData.level, heroUuid)
        end
        totalCombatPower = totalCombatPower + heroData.power
      end
      heroCount = heroCount + 1
    else
      self.heroInfoBars[i]:SetData(nil)
    end
  end
  local heroDatas = {}
  for index, heroUuid in pairs(self.heroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData == nil and self.hasTryHeroes and self.tryHeroesUuidToDataMap then
      heroData = self.tryHeroesUuidToDataMap[heroUuid]
    end
    if heroData ~= nil then
      heroDatas[index] = heroData
    end
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.SetHeroers then
    DataCenter.LWBattleManager:GetCurBattleLogic():SetHeroers(heroDatas)
  end
  self:RefreshFormationBuff()
  self:RefreshTWSkillChipBtn()
  self:RefreshArena3V3Container()
  self:RefreshPVPArenaTopBar()
  self:RefreshTrailTowerContainer()
  self:TryShowSwitchGuide()
end

function UIHeroFakePVPFormationView_HeroTryOut:TryShowSwitchGuide()
  if self.param1 == nil or self.param1.cfgId == nil then
    return
  end
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param1.cfgId)
  if tryOutTemplate ~= nil and tryOutTemplate.target > 0 then
    local uuid = self.squadData:GetUuidByHeroId(tryOutTemplate.hero_id)
    if uuid then
      local curIndex = self.squadData:GetLocalHeroIndex(uuid)
      if curIndex ~= nil and curIndex ~= tryOutTemplate.target then
        if self.switchGuideDelayTimer then
          self.switchGuideDelayTimer:Stop()
          self.switchGuideDelayTimer = nil
        end
        self.switchGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:GuideSwitchHeros(self.slotAreas[curIndex], self.slotAreas[tryOutTemplate.target])
        end, 0.5)
      end
    end
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:OnBattleBtnClick()
  if not self.squadData then
    return
  end
  if self.param1 == nil or self.param1.cfgId == nil then
    return
  end
  local shouldShowSwitchGuide = false
  local fromIndex, toIndex
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param1.cfgId)
  if tryOutTemplate ~= nil and tryOutTemplate.target > 0 then
    local uuid = self.squadData:GetUuidByHeroId(tryOutTemplate.hero_id)
    if uuid then
      local curIndex = self.squadData:GetLocalHeroIndex(uuid)
      if curIndex ~= nil and curIndex ~= tryOutTemplate.target then
        shouldShowSwitchGuide = true
        fromIndex = curIndex
        toIndex = tryOutTemplate.target
      end
    end
  end
  if shouldShowSwitchGuide then
    local contentText = Localization:GetString("herotrial_desc_01")
    UIUtil.ShowMessage(contentText, 2, "herotrial_btn_01", "herotrial_btn_02", function()
      self:ConfirmEnterBattle()
    end, function()
      if self.switchGuideDelayTimer then
        self.switchGuideDelayTimer:Stop()
        self.switchGuideDelayTimer = nil
      end
      if fromIndex ~= nil and toIndex ~= nil and self.slotAreas ~= nil then
        self:GuideSwitchHeros(self.slotAreas[fromIndex], self.slotAreas[toIndex])
      end
    end)
  else
    self:ConfirmEnterBattle()
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:ConfirmEnterBattle()
  if self.squadData then
    if self.__waitingForMsg then
      return
    end
    local heroes = self.squadData:GetLocalAllHeroes()
    if table.IsNullOrEmpty(heroes) then
      return
    end
    self.__waitingForMsg = true
    DataCenter.LWSoundManager:PlaySound(10014)
    local herosServer = self.squadData:GetAllLocalHerosForServer()
    DataCenter.HeroTryOutManager:SendHeroTryOutBattleMessage(self.param1.cfgId, herosServer)
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshFormationBuff()
  local heros = self.squadData:GetLocalAllHeroes()
  local type = self.formationBuffInfo and self.formationBuffInfo.type
  local heroInfos = {}
  for i, heroUuid in pairs(heros) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData == nil then
      heroData = self.tryHeroesUuidToDataMap[heroUuid]
    end
    if heroData ~= nil then
      table.insert(heroInfos, heroData)
    end
  end
  self.formationBuffInfo = HeroUtils.GetFormationBuffInfoListByHeroInfos(heroInfos)
  self.formationBuffInfo.heros = HeroUtils.SortFormationHerosByHeroInfos(heroInfos)
  if self.formationBuffInfo.type ~= type and self.formationBuffInfo.type ~= 0 then
    local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
    if isFormationBuffOpen then
      UIUtil.PlayScaleAnim(self.formationBtn.rectTransform)
    end
  end
  local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
  if isFormationBuffOpen then
    if self.formationBuffInfo.type == 0 then
      self.formationBuffIcon:SetActive(false)
    else
      self.formationBuffIcon:SetActive(true)
      local path = string.format(LoadPath.HeroCommonPath, self.formationBuffInfo.icon)
      self.formationBuffIcon:LoadSprite(path)
    end
  else
    self.formationBuffIcon:SetActive(true)
    local path = string.format(LoadPath.HeroCommonPath, "od_biandui_zhenyingsuo")
    self.formationBuffIcon:LoadSprite(path)
  end
  if self.buffCom:GetActive() then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshTWSkillChipBtn()
  self.chooseSkillChipSetBtn:SetActive(false)
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshWeaponInfo()
  if self.squadData then
    local weaponInfo = self.squadData:GetTacticalWeaponInfo()
    if weaponInfo then
      self.weaponBtn:SetActive(true)
      self.weaponLevelNumberText:SetText(weaponInfo.level)
    else
      self.weaponBtn:SetActive(false)
    end
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:OnClickTacticalWeaponBtn()
  if self.squadData then
    local weaponInfo = self.squadData:GetTacticalWeaponInfo()
    if weaponInfo then
      local selfEquips, skinId, skillChips, useSetId
      if useSetId ~= nil and 0 < useSetId then
        skillChips = DataCenter.TWSkillChipManager:GetChipsInfoByMasterSet(useSetId)
      end
      local power = weaponInfo.power
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, weaponInfo, selfEquips, self.weaponBtn, skinId, skillChips, power)
    end
  end
end

function UIHeroFakePVPFormationView_HeroTryOut:RefreshFormationPositionType()
  self.formationPositionType = ArmyFormationPositionType.Normal
  if self.param1 == nil or self.param1.cfgId == nil then
    return
  end
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param1.cfgId)
  if tryOutTemplate ~= nil and tryOutTemplate.lattice_type > 0 then
    self.formationPositionType = tryOutTemplate.lattice_type
  end
  self.formationPositionTypeText:SetActive(false)
end

return UIHeroFakePVPFormationView_HeroTryOut
