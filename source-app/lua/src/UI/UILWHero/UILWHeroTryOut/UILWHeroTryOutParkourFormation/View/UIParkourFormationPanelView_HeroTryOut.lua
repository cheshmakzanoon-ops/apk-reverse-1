local base = require("UI/UIParkour/FormationUI/View/UIParkourFormationPanelView")
local UIParkourFormationPanelView_HeroTryOut = BaseClass("UIParkourFormationPanelView_HeroTryOut", base)
local UIFormationTrailHeroCell_HeroTryOut = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutParkourFormation.Component.UIFormationTrailHeroCell_HeroTryOut")
local UILWHeroTryOutFormationGuideContentComponent = require("UI.UILWHero.UILWHeroTryOut.UILWHeroTryOutParkourFormation.Component.UILWHeroTryOutFormationGuideContentComponent")
local Localization = CS.GameEntry.Localization

function UIParkourFormationPanelView_HeroTryOut:ComponentDefine()
  base.ComponentDefine(self)
  self.compHeroTryOutGuide = self:AddComponent(UILWHeroTryOutFormationGuideContentComponent, "Root/UILWHeroTryOutFormationGuideContent")
end

function UIParkourFormationPanelView_HeroTryOut:ComponentDestroy()
  base.ComponentDestroy(self)
  self.compHeroTryOutGuide = nil
end

function UIParkourFormationPanelView_HeroTryOut:OnOpen()
  base.OnOpen(self)
  if self.param == nil or self.param.extraData == nil or self.param.extraData.cfgId == nil then
    return
  end
  self.compHeroTryOutGuide:ReInit(self.param.extraData.cfgId)
end

function UIParkourFormationPanelView_HeroTryOut:OnInitHeroScroll(go, index)
  local item = self.heroScroll:AddComponent(UIFormationTrailHeroCell_HeroTryOut, go)
  self.heroListGO[go] = item
  self.heroListCell[index] = item
end

function UIParkourFormationPanelView_HeroTryOut:ClearHeroScroll()
  self.heroScroll:RemoveComponents(UIFormationTrailHeroCell_HeroTryOut)
  self.heroList:DestroyChildNode()
end

function UIParkourFormationPanelView_HeroTryOut:InitTryHeroData()
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

function UIParkourFormationPanelView_HeroTryOut:GetHeroList(heroType)
  local heroList = {}
  self:InitTryHeroData()
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
  table.sort(heroList, function(a, b)
    return a.heroData.power > b.heroData.power
  end)
  return heroList
end

function UIParkourFormationPanelView_HeroTryOut:RefreshSquadData()
  if self.param == nil or self.param.extraData == nil or self.param.extraData.cfgId == nil then
    return
  end
  self.squadData = DataCenter.HeroTryOutManager:GetArmyFormationInfoByHeroTryOutId(self.param.extraData.cfgId)
  self.squadData:ClearLocalHeroes()
  self.squadData:ResetLocalData()
  self.slotCount = 5
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
  if tryOutTemplate ~= nil and tryOutTemplate.lattice_type > 0 then
    self.squadData:SetFormationPositionType(tryOutTemplate.lattice_type)
  end
  self:RefreshHeroInfo()
end

function UIParkourFormationPanelView_HeroTryOut:RefreshHeroInfo()
  base.RefreshHeroInfo(self)
  self:TryShowSwitchGuide()
end

function UIParkourFormationPanelView_HeroTryOut:TryShowSwitchGuide()
  if self.param == nil or self.param.extraData == nil or self.param.extraData.cfgId == nil then
    return
  end
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
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

function UIParkourFormationPanelView_HeroTryOut:OnBattleBtnClick()
  if not self.squadData then
    return
  end
  if self.param == nil or self.param.extraData == nil or self.param.extraData.cfgId == nil then
    return
  end
  local shouldShowSwitchGuide = false
  local fromIndex, toIndex
  local tryOutTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(self.param.extraData.cfgId)
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

function UIParkourFormationPanelView_HeroTryOut:ConfirmEnterBattle()
  if self.squadData then
    local heroes = self.squadData:GetLocalAllHeroes()
    if table.IsNullOrEmpty(heroes) then
      return
    end
    DataCenter.LWSoundManager:PlaySound(10014)
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleStart)
    self:SetVisible(false)
  end
end

function UIParkourFormationPanelView_HeroTryOut:RefreshTWSkillChipBtn()
  self.chooseSkillChipSetBtn:SetActive(false)
end

function UIParkourFormationPanelView_HeroTryOut:RefreshTacticalWeapon()
  if self.squadData then
    local weaponInfo = self.squadData:GetTacticalWeaponInfo()
    if weaponInfo then
      self.tacticalWeaponBtn:SetActive(true)
      self.tacticalWeaponLevelText:SetText(weaponInfo.level)
    else
      self.tacticalWeaponBtn:SetActive(false)
    end
  end
end

function UIParkourFormationPanelView_HeroTryOut:OnClickTacticalWeaponBtn()
  if self.squadData then
    local weaponInfo = self.squadData:GetTacticalWeaponInfo()
    if weaponInfo then
      local selfEquips, skinId, skillChips, useSetId
      if useSetId ~= nil and 0 < useSetId then
        skillChips = DataCenter.TWSkillChipManager:GetChipsInfoByMasterSet(useSetId)
      end
      local power = weaponInfo.power
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, weaponInfo, selfEquips, self.tacticalWeaponBtn, skinId, skillChips, power)
    end
  end
end

return UIParkourFormationPanelView_HeroTryOut
