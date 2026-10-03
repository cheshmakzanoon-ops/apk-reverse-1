local UIHeroFakePVPFormationPanelView = BaseClass("UIHeroFakePVPFormationPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local HeroPVERenderTexture = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Component.HeroPVERenderTexture")
local UIFormationHeroCell = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIFormationHeroCell")
local UIHeroInfoBar = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroInfoBar")
local FormationBuffView = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.FormationBuffView")
local UIHeroFakeInfoBar = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Component.UIHeroFakeInfoBar")
local UIPVPArenaTopBar = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Component.PVPArenaTopBar")
local ChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseSquadPopup")
local UIArena3V3Container = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Component.UIArena3V3Container")
local Arena3V3ChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.Arena3V3ChooseSquadPopup")
local TruckChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.TruckChooseSquadPopup")
local UITrailTowerContainer = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Component.UITrailTowerContainer")
local ChooseTWSkillChipSetPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseTWSkillChipSetPopup")
local SquadPlanBtnItem = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.SquadPlanBtnItem")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local ChooseDominator = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseDominator")
local DominatorTips = require("UI/UILWDominator/Battle/UILWFormationPanelDominatorTipsComponent")
local DominatorPowerRecommend = require("UI/UILWDominator/Battle/UILWFormationPanelDominatorPowerRecommendComponent")
local quickBtnPath = "Root/BottomBar/Btns/QuickBtn"
local bottomBarPath = "Root/BottomBar"
local heroScrollPath = "Root/BottomBar/HeroList"
local heroListPath = "Root/BottomBar/HeroList/Content"
local battleBtnPath = "Root/BottomBar/Btns/BattleBtn"
local battleBtnTextPath = "Root/BottomBar/Btns/BattleBtn/BattleBtnText"
local backBtnPath = "Root/BottomBar/BtnBack"
local allTypeHeroTogglePath = "Root/BottomBar/Rect_List/AllTypeToggle"
local allTypeHeroToggleTextPath = "Root/BottomBar/Rect_List/AllTypeToggle/AllTypeHeroToggleText"
local tankTypeHeroTogglePath = "Root/BottomBar/Rect_List/TankTypeToggle"
local tankTypeHeroToggleIconPath = "Root/BottomBar/Rect_List/TankTypeToggle/TankTypeIcon"
local missileTypeTogglePath = "Root/BottomBar/Rect_List/MissileTypeToggle"
local missileTypeToggleIconPath = "Root/BottomBar/Rect_List/MissileTypeToggle/MissileTypeIcon"
local airForceTypeTogglePath = "Root/BottomBar/Rect_List/AirForceTypeToggle"
local airForceTypeToggleIconPath = "Root/BottomBar/Rect_List/AirForceTypeToggle/AirForceTypeIcon"
local middleContentContainerPath = "Root/MiddleContentContainer"
local formationContentPath = "Root/MiddleContentContainer/FormationContent"
local formationBgPath = "Root/MiddleContentContainer/FormationContent/FormationBg"
local powerInfoPath = "Root/MiddleContentContainer/TopBar/PowerInfo"
local powerInfoTextPath = "Root/MiddleContentContainer/TopBar/PowerInfo/PowerNumberText"
local slotAreaContainerPath = "Root/MiddleContentContainer/FormationContent/SlotAreas"
local slotAreaPath = "Root/MiddleContentContainer/FormationContent/SlotAreas/Slot%dArea"
local heroInfoBarContainerPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars"
local heroInfoBarPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars/Slot%dHeroInfoBar"
local heroListTipTextPath = "Root/BottomBar/HeroListTipText"
local recommandHeroPowerTextPath = "Root/MiddleContentContainer/TopBar/RecommandPowerInfo/RecPowerNumberText"
local stageNameTextPath = "Root/MiddleContentContainer/TopBar/StageNameText"
local rootPath = "Root"
local selfPlayerHeadPath = "Root/MiddleContentContainer/TopBar/SelfPlayerHead/HeadIcon"
local zombieHeadPath = "Root/MiddleContentContainer/TopBar/ZombieHead/ZombieHeadIcon"
local topBarPath = "Root/MiddleContentContainer/TopBar"
local heroInfo2BarContainerPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars2"
local heroInfo2BarPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars2/Slot%dHeroInfoBar"
local pvpArenaTopBarPath = "Root/PVPArenaTopBar"
local chooseSquadBtnPath = "Root/BottomBar/LeftBottomContainer/btnChooseSquad"
local chooseSquadBtnTextPath = "Root/BottomBar/LeftBottomContainer/btnChooseSquad/txtChooseSquad"
local chooseSquadPopupPath = "popupChooseSquad"
local arena3V3TopBarPath = "Root/Arena3V3Container"
local arena3V3ChooseSquadBtnPath = "3V3PopupChooseSquad"
local truck3V3ChooseSquadBtnPath = "TruckPopupChooseSquad"
local tacticalWeaponBtnPath = "Root/BottomBar/LeftBottomContainer/SelfWeapon"
local tacticalWeaponLevelNumberTextPath = "Root/BottomBar/LeftBottomContainer/SelfWeapon/SelfWeaponLevelNumberText"
local btn_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet"
local icon_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet/Icon"
local txt_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet/txtChooseSkillChipSet"
local popup_choose_skill_chip_set_path = "PopupChooseSkillChipSet"
local leftBottomContainerPath = "Root/BottomBar/LeftBottomContainer"
local dominatorTipsPath = "Root/BottomBar/CenterBottomContainer/DominatorTips"
local dominatorPowerRecommendPath = "Root/MiddleContentContainer/FormationContent/RecommendDominatorPowerContent"
local trailTowerContainerPath = "Root/TrailTowerContainer"
local squad_plan_content_path = "Root/MiddleContentContainer/FormationContent/SquadPlanContent"
local plan_btn_path = "Root/MiddleContentContainer/FormationContent/SquadPlanContent/Plan"
local formationPositionTypeTextPath = "Root/MiddleContentContainer/FormationContent/FormationPositionTypeText"

function UIHeroFakePVPFormationPanelView:ClearHeroScroll()
  self.heroScroll:RemoveComponents(UIFormationHeroCell)
  self.heroList:DestroyChildNode()
end

local function SetVisible(self, state)
  if self.root then
    self.root:SetActive(state)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SetVisible(self, true)
  self:OnOpen()
end

local function IsShowQuickBtn(self)
  return false
end

local function RefreshQuickBtn(self)
  local isShowQuickBtn = self:IsShowQuickBtn()
  self.quickBtn:SetActive(isShowQuickBtn)
end

local function OnQuickBtnClick(self)
  if not self.squadData then
    return
  end
  local heroCount = self:AutoFillArmyFormation()
  if heroCount <= 0 then
    UIUtil.ShowTipsId("auto_arrangement_tips")
    return
  end
  self:OnUpdateArmyFormationList()
end

local function GetEnemyFormation(self)
  local data
  if self.source == EnterHeroSquadPanelWay.TruckRob then
    self.squadData = DataCenter.LWMyStationDataManager:GetDefenceFormation()
  elseif self.source == EnterHeroSquadPanelWay.HSRRob then
    self.squadData = DataCenter.HSRDataManager:GetDefenceFormation()
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
    data = DataCenter.LW3V3Manager:GetDefTeamByIndex(self.squadIndex)
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    data = DataCenter.LWKOFBattleManager:GetDefTeamByIndex(self.squadIndex)
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    data = DataCenter.ArmyFormationDataManager:GetDefTeamByIndex()
  else
    data = DataCenter.ArmyFormationDataManager:GetDefTeamByIndex()
  end
  return data
end

local function AutoFillArmyFormation(self)
  local tankPower = 1
  local missilePower = 1
  local aircraftPower = 1
  local enemy = DataCenter.LWBattleManager:GetCurBattleLogic().heroDataList
  if enemy then
    for _, data in ipairs(enemy) do
      local enemy_hero = DataCenter.HeroTemplateManager:GetTemplate(data.heroId)
      if enemy_hero.type == 1 then
        aircraftPower = aircraftPower + 0.04
        missilePower = missilePower - 0.04
      elseif enemy_hero.type == 2 then
        tankPower = tankPower + 0.04
        aircraftPower = aircraftPower - 0.04
      elseif enemy_hero.type == 3 then
        tankPower = tankPower - 0.04
        missilePower = missilePower + 0.04
      end
    end
  end
  local powers = {}
  powers[1] = tankPower
  powers[2] = missilePower
  powers[3] = aircraftPower
  local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
  if not isFormationBuffOpen then
    local squadData = self.squadData
    if squadData == nil then
      return 0
    end
    local heroCount = 0
    local heroUuid
    local used = {}
    local heroDataList = {}
    for _, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
      table.insert(heroDataList, heroData)
    end
    table.sort(heroDataList, function(a, b)
      return a.power * powers[a.heroType] > b.power * powers[b.heroType]
    end)
    local topFive = {}
    table.move(heroDataList, 1, math.min(5, #heroDataList), 1, topFive)
    local tanks = {}
    local others = {}
    for slotIndex = 1, 5 do
      local localHeroUuid = squadData:GetLocalHeroAtSlotIndex(slotIndex)
      heroUuid = nil
      if slotIndex == 1 or slotIndex == 2 then
        for _, heroData in ipairs(topFive) do
          if heroData and used[heroData.uuid] == nil and heroData.heroJob == HeroJob.Defense then
            used[heroData.uuid] = 1
            heroUuid = heroData.uuid
            tanks[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
      if heroUuid == nil then
        for _, heroData in ipairs(topFive) do
          if heroData and used[heroData.uuid] == nil then
            used[heroData.uuid] = 1
            heroUuid = heroData.uuid
            others[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
    end
    if heroCount == 0 then
      return heroCount
    end
    squadData:ClearLocalHeroes()
    for slotIndex = 1, 5 do
      squadData:SetLocalHero(slotIndex, tanks[slotIndex] and tanks[slotIndex] or others[slotIndex])
    end
    return heroCount
  else
    local squadData = self.squadData
    if squadData == nil then
      return 0
    end
    local tanks = {}
    local missiles = {}
    local aircrafts = {}
    local heroCount = 0
    local heroUuid
    local heroDataList = {}
    for _, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
      table.insert(heroDataList, heroData)
      if heroData.heroType == 1 then
        table.insert(tanks, heroData)
      elseif heroData.heroType == 2 then
        table.insert(missiles, heroData)
      elseif heroData.heroType == 3 then
        table.insert(aircrafts, heroData)
      end
    end
    table.sort(tanks, function(a, b)
      return a.power * powers[a.heroType] > b.power * powers[b.heroType]
    end)
    local tankTopFive = {}
    table.move(tanks, 1, math.min(5, #tanks), 1, tankTopFive)
    table.sort(missiles, function(a, b)
      return a.power * powers[a.heroType] > b.power * powers[b.heroType]
    end)
    local missileTopFive = {}
    table.move(missiles, 1, math.min(5, #missiles), 1, missileTopFive)
    table.sort(aircrafts, function(a, b)
      return a.power * powers[a.heroType] > b.power * powers[b.heroType]
    end)
    local aircraftTopFive = {}
    table.move(aircrafts, 1, math.min(5, #aircrafts), 1, aircraftTopFive)
    
    local function calcTotalPower(heroList)
      local total = 0
      for _, hero in ipairs(heroList) do
        total = total + hero.power * powers[hero.heroType]
      end
      return total
    end
    
    local tankTotal = calcTotalPower(tankTopFive)
    local missileTotal = calcTotalPower(missileTopFive)
    local aircraftTotal = calcTotalPower(aircraftTopFive)
    local maxCampTopFive
    local planAType = 0
    local planAPower = 0
    if tankTotal >= missileTotal and tankTotal >= aircraftTotal then
      maxCampTopFive = tankTopFive
      planAType = 1
      planAPower = tankTotal
    elseif tankTotal <= missileTotal and missileTotal >= aircraftTotal then
      maxCampTopFive = missileTopFive
      planAType = 2
      planAPower = missileTotal
    else
      maxCampTopFive = aircraftTopFive
      planAType = 3
      planAPower = aircraftTotal
    end
    table.sort(heroDataList, function(a, b)
      return a.power * powers[a.heroType] > b.power * powers[b.heroType]
    end)
    local planBTopFive = {}
    table.move(heroDataList, 1, math.min(5, #heroDataList), 1, planBTopFive)
    local planBPower = calcTotalPower(planBTopFive)
    local finalFive = {}
    local usePlanB = 1.3 <= planBPower / planAPower
    if usePlanB then
      finalFive = planBTopFive
    else
      finalFive = maxCampTopFive
    end
    local tanks = {}
    local others = {}
    local used = {}
    for slotIndex = 1, 5 do
      local localHeroUuid = squadData:GetLocalHeroAtSlotIndex(slotIndex)
      heroUuid = nil
      if slotIndex == 1 or slotIndex == 2 then
        for _, heroData in ipairs(finalFive) do
          if heroData and not used[heroData.uuid] and heroData.heroJob == HeroJob.Defense then
            used[heroData.uuid] = true
            heroUuid = heroData.uuid
            tanks[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
      if heroUuid == nil then
        for _, heroData in ipairs(finalFive) do
          if heroData and not used[heroData.uuid] then
            used[heroData.uuid] = true
            heroUuid = heroData.uuid
            others[slotIndex] = heroData.uuid
            if heroData.uuid ~= localHeroUuid then
              heroCount = heroCount + 1
            end
            break
          end
        end
      end
    end
    if heroCount == 0 then
      return heroCount
    end
    squadData:ClearLocalHeroes()
    for slotIndex = 1, 5 do
      squadData:SetLocalHero(slotIndex, tanks[slotIndex] and tanks[slotIndex] or others[slotIndex])
    end
    return heroCount
  end
end

local function OnDestroy(self)
  self.guidedSwitch = nil
  if self.clickGuideDelayTimer then
    self.clickGuideDelayTimer:Stop()
    self.clickGuideDelayTimer = nil
  end
  if self.switchGuideDelayTimer then
    self.switchGuideDelayTimer:Stop()
    self.switchGuideDelayTimer = nil
  end
  if self.truckRobBlocking then
    self.truckRobBlocking:Stop()
    self.truckRobBlocking = nil
  end
  if self.switchGuideTween then
    self.switchGuideTween:Kill()
    self.switchGuideTween = nil
  end
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  if not IsNull(self.switchFingerHandle) then
    self.switchFingerHandle:Destroy()
    self.switchFingerHandle = nil
  end
  self:ResetDragAreaPos(self)
  self:ClearHeroScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  self.__waitingForMsg = nil
  self:ClearSound()
  base.OnDestroy(self)
end

local function OnBattleBtnClick(self)
  if self.squadData then
    local heroesExceptDominator = self.squadData:GetLocalAllHeroes()
    if self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
      local par = DataCenter.LW3V3Manager:CheckNilTeamIndex()
      if par then
        UIUtil.ShowTips(Localization:GetString("500214", par))
        return
      end
    elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
      local par = DataCenter.LWKOFBattleManager:CheckNilTeamIndex()
      if par then
        UIUtil.ShowTips(Localization:GetString("500214", par))
        return
      end
    end
    local dominatorUuid = self.squadData:GetLocalDominatorUuid()
    local isOnlyDominatorFormationType = self.formationPositionType == ArmyFormationPositionType.OnlyDominator
    if isOnlyDominatorFormationType then
      if not table.IsNullOrEmpty(heroesExceptDominator) then
        Logger.LogWarning("UIHeroFakePVPFormationPanelView Error, has hero in only dominator mode")
        return
      end
      if dominatorUuid == nil or dominatorUuid == 0 then
        UIUtil.ShowTipsId("dominator_pve_dec_9")
        return
      end
    elseif table.IsNullOrEmpty(heroesExceptDominator) then
      if dominatorUuid ~= nil and 0 < dominatorUuid then
        UIUtil.ShowTipsId("dominator_squad_empty_warning")
        return
      end
      if self.source == EnterHeroSquadPanelWay.ActivityArenaV2 or self.source == EnterHeroSquadPanelWay.NewPeakArena or self.source == EnterHeroSquadPanelWay.NewGaleArena or self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
        UIUtil.ShowTipsId("new_arena_tips001")
      end
      return
    end
    local heroes = self.squadData:GenerateServerHeroArray()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_start)
    local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
      if self.detectEventUuid then
        SFSNetwork.SendMessage(MsgDefines.DetectEventFakePVP, self.detectEventUuid, self.squadIndex, heroes, curChipSetId)
      end
    elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
      if self.cfgId then
        if self.jeepAdventurePageType == JeepAdventurePageType.TowerUp then
          SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex, heroes, self.squadIndex, curChipSetId)
          SFSNetwork.SendMessage(MsgDefines.LWSaveTowerupRecord, self.cfgId)
        elseif self.jeepAdventurePageType == JeepAdventurePageType.Domintor then
          if dominatorUuid and 0 < dominatorUuid then
            SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex, heroes, self.squadIndex, curChipSetId)
            SFSNetwork.SendMessage(MsgDefines.LWSaveDominatorUpRecord, self.cfgId)
          else
            UIUtil.ShowTipsId("dominator_pve_dec_9")
            return
          end
        end
      end
    elseif self.source == EnterHeroSquadPanelWay.TruckRob then
      if not self.truckRobBlocking then
        DataCenter.LWMyStationDataManager:TrySaveTruckFormation(self.squadData, true)
        DataCenter.LWMyStationDataManager:TryAttackTrain(self.trainUuid, self.trainServerId, self.squadData)
        self.truckRobBlocking = TimerManager:GetInstance():DelayInvoke(function()
          if self then
            self.truckRobBlocking = nil
          end
        end, 10)
      end
    elseif self.source == EnterHeroSquadPanelWay.HSRRob then
      if not self.truckRobBlocking then
        DataCenter.LWMyStationDataManager:TrySaveTruckFormation(self.squadData, true)
        DataCenter.HSRDataManager:TryAttackHSR(self.param1.uid, self.squadData)
        self.truckRobBlocking = TimerManager:GetInstance():DelayInvoke(function()
          if self then
            self.truckRobBlocking = nil
          end
        end, 10)
      end
    elseif self.source == EnterHeroSquadPanelWay.PVPArena then
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      SFSNetwork.SendMessage(MsgDefines.StartPVPArenaBattle, self.arenaBattleInfo.otherInfo.playerInfo.uid, heroes, self.squadIndex, curChipSetId)
    elseif self.source == EnterHeroSquadPanelWay.ActivityArena then
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      SFSNetwork.SendMessage(MsgDefines.ActivityArenaBattle, self.arenaBattleInfo.activityId, self.arenaBattleInfo.otherRank, heroes, self.squadIndex, curChipSetId)
    elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
      self.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILW3V3Campaign, true)
    elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
      if self.waitWindow then
        return
      end
      self.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWKOFCampaign, true)
    elseif self.source == EnterHeroSquadPanelWay.TrailTower then
      local trailTowerData = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.trailTowerInfo.trailTowerLevelTemplate.towerId)
      if trailTowerData and trailTowerData:IsEnd() then
        UIUtil.ShowTipsId("trialtower_error_01")
        self:ClosePanel()
        return
      end
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      if self.trailTowerInfo.isBattleSweep then
        SFSNetwork.SendMessage(MsgDefines.TrailTowerBattleSwap, self.trailTowerInfo.trailTowerLevelTemplate.towerId, self.trailTowerInfo.trailTowerLevelTemplate.id, heroes, curChipSetId)
      else
        SFSNetwork.SendMessage(MsgDefines.TrailTowerBattle, self.trailTowerInfo.trailTowerLevelTemplate.towerId, self.trailTowerInfo.trailTowerLevelTemplate.id, heroes, curChipSetId)
      end
    elseif self.source == EnterHeroSquadPanelWay.ActivityArenaV2 then
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2Battle, self.arenaBattleInfo.activityId, self.arenaBattleInfo.otherRank, heroes, self.squadIndex, curChipSetId)
    elseif self.source == EnterHeroSquadPanelWay.NewPeakArena then
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      SFSNetwork.SendMessage(MsgDefines.NewArenaBattle, self.arenaBattleInfo.otherInfo.playerInfo.uid, heroes, self.squadIndex, curChipSetId)
    elseif self.source == EnterHeroSquadPanelWay.NewGaleArena then
      if self.__waitingForMsg then
        return
      end
      self.__waitingForMsg = true
      SFSNetwork.SendMessage(MsgDefines.GaleArenaBattle, self.arenaBattleInfo.otherInfo.playerInfo.uid, heroes, self.squadIndex, curChipSetId)
    elseif self.source == EnterHeroSquadPanelWay.BeginnerEvent then
      SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex, heroes, self.squadIndex)
      SFSNetwork.SendMessage(MsgDefines.LWBeginnerCityEventKillBoss, self.bossIndex)
    elseif self.source == EnterHeroSquadPanelWay.DetectZombieBusTrain then
      SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex, heroes, self.squadIndex, curChipSetId)
      SFSNetwork.SendMessage(MsgDefines.DetectEventZombieBusPassFeature, self.eventUuid, self.busIndex)
    elseif self.source == EnterHeroSquadPanelWay.T11IdleGameBattleEvent then
      SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex, heroes, self.squadIndex, curChipSetId)
      DataCenter.T11IdleGameDataManager:SendIdleGameEventBattleMessage(self.t11EventUuid, self.t11EventLevelId, heroes, curChipSetId)
    end
  end
end

local function TryTakeDownHeroAtIndex(self, index)
  if self.squadData then
    local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
    if heroUuid then
      if self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
        self:TakeDownTruckAttackHero(self.squadIndex, heroUuid)
      else
        self:TakeDownHero(self.squadIndex, heroUuid)
      end
    end
  end
end

function UIHeroFakePVPFormationPanelView:OnBeginDragHeroSlot(eventData, index)
  if self.dragingIndex then
    return
  end
  if self.squadData then
    local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
    if heroUuid then
      self.isInDragMode = true
      self.dragingIndex = index
      self.lastDragPosX = eventData.position.x
      self.lastDragPosY = eventData.position.y
      self.slotAreas[index].transform:SetAsFirstSibling()
      self.heroInfoBars[index].transform:SetParent(self.slotAreas[index].transform)
    end
  end
end

local function ResetDragAreaPos(self)
  if self.slotAreas then
    for k, v in pairs(self.slotAreas) do
      if self.slotPos[k] then
        local pos = self.slotPos[k]
        v.transform:Set_localPosition(pos.x, pos.y, pos.z)
      end
    end
  end
  if self.heroInfoBars then
    for k, v in pairs(self.heroInfoBars) do
      v.transform:SetParent(self.heroInfoBarContainer.transform)
      if self.heroInfoBarsPos and self.heroInfoBarsPos[k] then
        v.transform.localPosition = self.heroInfoBarsPos[k]
      end
    end
  end
end

local function SwitchHeroSlot(self, fromIndex, toIndex)
  if self.squadData then
    local fromHeroUuid = self.squadData:GetLocalHeroAtSlotIndex(fromIndex)
    local toHeroUuid = self.squadData:GetLocalHeroAtSlotIndex(toIndex)
    self.squadData:SetLocalHero(fromIndex, nil)
    self.squadData:SetLocalHero(toIndex, nil)
    self.squadData:SetLocalHero(fromIndex, toHeroUuid)
    self.squadData:SetLocalHero(toIndex, fromHeroUuid)
  end
end

local function OnDragEndHeroSlot(self, eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    ResetDragAreaPos(self)
    self.formationRt:OnDragHeroEnd(self.dragingIndex)
    if self.toSwitchIndex then
      SwitchHeroSlot(self, self.dragingIndex, self.toSwitchIndex)
      self:RefreshHeroInfo()
    end
    self.isInDragMode = false
    self.dragingIndex = nil
    self.toSwitchIndex = nil
    self.lastDragPosX = nil
    self.lastDragPosY = nil
  end
end

local function OnDragHeroSlot(self, eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    local curPosX = eventData.position.x
    local curPosY = eventData.position.y
    self.lastDragPosX = curPosX
    self.lastDragPosY = curPosY
    local uiPos = PosConverse.ScreenToUIPos(self.slotAreasContainer.rectTransform, Vector2.New(curPosX, curPosY))
    self.slotAreas[index].transform.localPosition = Vector3.New(uiPos.x, uiPos.y)
    local areaCenterPos = PosConverse.UIWorldToScreenPos(self.slotAreas[index].transform.position)
    local pos = Vector2.New(areaCenterPos.x, areaCenterPos.y)
    local rtScreenPos = pos
    if rtScreenPos.x < -8 or rtScreenPos.x > self.screenWidth + 8 then
      OnDragEndHeroSlot(self, eventData, self.dragingIndex)
      return
    end
    if rtScreenPos.y < -8 or rtScreenPos.y > self.screenHeight + 8 then
      OnDragEndHeroSlot(self, eventData, self.dragingIndex)
      return
    end
    self.formationRt:MoveHeroSlotPos(index, rtScreenPos)
  end
end

local function OnPointerEnterHeroSlot(self, eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex then
    return
  end
  self.toSwitchIndex = index
  self.formationRt:HeroSlotMoveToIndex(self.toSwitchIndex, self.dragingIndex)
  if self.heroInfoBarsPos then
    local pos = self.heroInfoBarsPos[self.dragingIndex]
    self.heroInfoBars[self.toSwitchIndex].transform:Set_localPosition(pos.x, pos.y, pos.z)
  end
end

local function OnPointerExitHeroSlot(self, eventData, index)
  if not self.isInDragMode then
    return
  end
  if self.isInDragMode and self.dragingIndex == index then
    return
  end
  if self.toSwitchIndex ~= index then
    return
  end
  self.formationRt:HeroSlotMoveToIndex(self.toSwitchIndex, self.toSwitchIndex)
  if self.heroInfoBarsPos then
    local pos = self.heroInfoBarsPos[self.toSwitchIndex]
    self.heroInfoBars[self.toSwitchIndex].transform:Set_localPosition(pos.x, pos.y, pos.z)
    self.toSwitchIndex = nil
  end
end

local function ComponentDefine(self)
  self.bottomBar = self:AddComponent(UIBaseContainer, bottomBarPath)
  self.heroList = self:AddComponent(GridInfinityScrollView, heroListPath)
  self.heroScroll = self:AddComponent(UIBaseContainer, heroScrollPath)
  self.battleBtn = self:AddComponent(UIButton, battleBtnPath)
  self.battleBtn:SetOnClick(function()
    self:OnBattleBtnClick()
  end)
  self.battleBtn:SetSafeClickMode(true)
  self.battleBtnText = self:AddComponent(UIText, battleBtnTextPath)
  self.quickBtn = self:AddComponent(UIButton, quickBtnPath)
  self.quickBtn:SetOnClick(function()
    self:OnQuickBtnClick()
  end)
  self.backBtn = self:AddComponent(UIButton, backBtnPath)
  self.backBtn:SetOnClick(function()
    if self.source == EnterHeroSquadPanelWay.TrailTower and self.trailTowerInfo then
      local trailTowerData = DataCenter.LWTrailTowerManager:GetTrailTowerInfoById(self.trailTowerInfo.trailTowerLevelTemplate.towerId)
      if trailTowerData and trailTowerData:IsEnd() then
        UIUtil.ShowTipsId("trialtower_error_01")
      end
    end
    self:ClosePanel()
  end)
  self.allTypeHeroToggle = self:AddComponent(UIToggle, allTypeHeroTogglePath)
  self.allTypeHeroToggle:SetOnValueChanged(function(isOn)
    if isOn then
      if not self.allTypeHeroToggle.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:OnChangeTypeToggle(HeroType.All)
    end
    self.allTypeHeroToggle.selecting = false
  end)
  self.allTypeHeroToggleText = self:AddComponent(UIText, allTypeHeroToggleTextPath)
  self.tankTypeHeroToggle = self:AddComponent(UIToggle, tankTypeHeroTogglePath)
  self.tankTypeHeroToggle:SetOnValueChanged(function(isOn)
    if isOn then
      if not self.tankTypeHeroToggle.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:OnChangeTypeToggle(HeroType.Tank)
    end
    self.tankTypeHeroToggle.selecting = false
  end)
  self.tankTypeHeroToggleIcon = self:AddComponent(UIImage, tankTypeHeroToggleIconPath)
  self.missileTypeToggle = self:AddComponent(UIToggle, missileTypeTogglePath)
  self.missileTypeToggle:SetOnValueChanged(function(isOn)
    if isOn then
      if not self.missileTypeToggle.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:OnChangeTypeToggle(HeroType.Missile)
    end
    self.missileTypeToggle.selecting = false
  end)
  self.missileTypeToggleIcon = self:AddComponent(UIImage, missileTypeToggleIconPath)
  self.airForceTypeToggle = self:AddComponent(UIToggle, airForceTypeTogglePath)
  self.airForceTypeToggle:SetOnValueChanged(function(isOn)
    if isOn then
      if not self.airForceTypeToggle.selecting then
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
      end
      self:OnChangeTypeToggle(HeroType.Aircraft)
    end
    self.airForceTypeToggle.selecting = false
  end)
  self.airForceTypeToggleIcon = self:AddComponent(UIImage, airForceTypeToggleIconPath)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middleContentContainerPath)
  self.formationContent = self:AddComponent(UIBaseContainer, formationContentPath)
  self.formationRt = self:AddComponent(HeroPVERenderTexture, "")
  self.uiScaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.formationBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/FormationContent/formationBtn")
  self.formationBuffIcon = self:AddComponent(UIImage, "Root/MiddleContentContainer/FormationContent/formationBtn/infoImage")
  self.firmationBufflView = self:AddComponent(FormationBuffView, "Root/MiddleContentContainer/FormationContent/firmationBufflView")
  self.buffCom = self:AddComponent(UIBaseComponent, "Root/MiddleContentContainer/FormationContent/firmationBufflView")
  self.buffViewCloseBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/FormationContent/firmationBufflView/closeBtn")
  self.buffViewCloseBtn:SetOnClick(function()
    self:SetBuffViewActive()
  end)
  self.formationBtn:SetOnClick(function()
    local isOn = self.buffCom:GetActive()
    if not isOn then
      self.firmationBufflView:ReInit(self.formationBuffInfo)
    end
    self.buffCom:SetActive(not isOn)
  end)
  self.powerInfo = self:AddComponent(UIBaseContainer, powerInfoPath)
  self.powerInfoText = self:AddComponent(UIText, powerInfoTextPath)
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not logic then
    return
  end
  self.slotAreasContainer = self:AddComponent(UIBaseContainer, slotAreaContainerPath)
  self.slotAreas = {}
  self.slotPos = {}
  for i = 1, 5 do
    local slotArea = self:AddComponent(UIEventTrigger, string.format(slotAreaPath, i))
    slotArea:OnPointerClick(function()
      if not self.isInDragMode then
        TryTakeDownHeroAtIndex(self, i)
      end
    end)
    slotArea:OnBeginDrag(function(eventData)
      self:OnBeginDragHeroSlot(eventData, i)
    end)
    slotArea:OnDrag(function(eventData)
      OnDragHeroSlot(self, eventData, i)
    end)
    slotArea:OnEndDrag(function(eventData)
      OnDragEndHeroSlot(self, eventData, i)
    end)
    slotArea:OnPointerEnter(function(eventData)
      OnPointerEnterHeroSlot(self, eventData, i)
    end)
    slotArea:OnPointerExit(function(eventData)
      OnPointerExitHeroSlot(self, eventData, i)
    end)
    table.insert(self.slotAreas, slotArea)
  end
  self.heroInfoBarContainer = self:AddComponent(UIBaseContainer, heroInfoBarContainerPath)
  self.heroInfoBars = {}
  for i = ArmyFormationSlot.Hero1, ArmyFormationSlot.Hero5 do
    local _idx = i
    local heroInfoBar = self:AddComponent(UIHeroInfoBar, string.format(heroInfoBarPath, _idx))
    table.insert(self.heroInfoBars, heroInfoBar)
  end
  self.heroInfo2BarContainer = self:AddComponent(UIBaseContainer, heroInfo2BarContainerPath)
  self.heroInfo2Bars = {}
  self.heroInfo2BarsPos = {}
  for i = ArmyFormationSlot.Hero1, ArmyFormationSlot.Hero5 do
    local _idx = i
    _idx = _idx + 5
    local heroInfoBar = self:AddComponent(UIHeroFakeInfoBar, string.format(heroInfo2BarPath, _idx))
    table.insert(self.heroInfo2Bars, heroInfoBar)
  end
  self.heroListTipText = self:AddComponent(UIText, heroListTipTextPath)
  self.recommandHeroPowerText = self:AddComponent(UIText, recommandHeroPowerTextPath)
  self.stageNameText = self:AddComponent(UIText, stageNameTextPath)
  self.root = self:AddComponent(UIBaseContainer, rootPath)
  self.selfPlayerHead = self:AddComponent(UIPlayerHead, selfPlayerHeadPath)
  self.zombieHeadIcon = self:AddComponent(UIImage, zombieHeadPath)
  self.topBar = self:AddComponent(UIBaseContainer, topBarPath)
  self.topBar:SetActive(false)
  self.pvpArenaTopBar = self:AddComponent(UIPVPArenaTopBar, pvpArenaTopBarPath)
  self.chooseSquadBtn = self:AddComponent(UIButton, chooseSquadBtnPath)
  self.chooseSquadBtn:SetOnClick(function()
    local position = self.chooseSquadBtn.transform.position
    local x = position.x + 40 * CommonUtil.ArabicAutoMirrorFactor()
    local y = position.y
    if self:IsNormalArena() then
      self.chooseSquadPopup:SetPosition(x, y)
      self.chooseSquadPopup:Popup(self.squadIndex, function(idx)
        self.squadIndex = idx
        self.chooseSquadBtnText:SetText("T" .. self.squadIndex)
        self:RefreshPVPArenaTopBar()
      end)
    elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
      self.arena3V3ChooseSquadPopup:SetPosition(x, y)
      self.arena3V3ChooseSquadPopup:Popup(self.squadIndex)
    elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
      self.arena3V3ChooseSquadPopup:SetPosition(x, y)
      self.arena3V3ChooseSquadPopup:Popup(self.squadIndex, self.source)
    elseif self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
      self.truckChooseSquadPopup:SetPosition(x, y)
      self.truckChooseSquadPopup:Popup(self.squadData.index)
    end
  end)
  self.chooseSquadBtnText = self:AddComponent(UIText, chooseSquadBtnTextPath)
  self.chooseSquadPopup = self:AddComponent(ChooseSquadPopup, chooseSquadPopupPath)
  self.chooseSquadPopup:SetActive(false)
  self.arena3V3Container = self:AddComponent(UIArena3V3Container, arena3V3TopBarPath)
  self.arena3V3ChooseSquadPopup = self:AddComponent(Arena3V3ChooseSquadPopup, arena3V3ChooseSquadBtnPath)
  self.arena3V3ChooseSquadPopup:SetIsDef(false)
  self.arena3V3ChooseSquadPopup:SetActive(false)
  self.truckChooseSquadPopup = self:AddComponent(TruckChooseSquadPopup, truck3V3ChooseSquadBtnPath)
  self.truckChooseSquadPopup:SetIsDef(false)
  self.truckChooseSquadPopup:SetActive(false)
  self.weaponBtn = self:AddComponent(UIButton, tacticalWeaponBtnPath)
  self.weaponBtn:SetOnClick(function()
    self:OnClickTacticalWeaponBtn()
  end)
  self.weaponLevelNumberText = self:AddComponent(UIText, tacticalWeaponLevelNumberTextPath)
  self.trailTowerContainer = self:AddComponent(UITrailTowerContainer, trailTowerContainerPath)
  self.squad_plan_content = self:AddComponent(UIImage, squad_plan_content_path)
  self.squad_plan_btn_list = {}
  for i = 1, 4 do
    local btnItem = self:AddComponent(SquadPlanBtnItem, plan_btn_path .. i)
    table.insert(self.squad_plan_btn_list, btnItem)
  end
  self.squad_plan_content:SetActive(false)
  self.chooseSkillChipSetBtn = self:AddComponent(UIButton, btn_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtnIcon = self:AddComponent(UIImage, icon_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtn:SetOnClick(function()
    if self.squadData then
      local position = self.chooseSkillChipSetBtn.transform.position
      local x = position.x + 40 * CommonUtil.ArabicAutoMirrorFactor()
      local y = position.y - 20
      local formationDataType = self.source
      self.chooseTWSkillChipSetPopup:SetPosition(x, y)
      self.chooseTWSkillChipSetPopup:Popup(function(idx)
        self:OnClickSkillChipSet(idx)
      end, self.squadData, formationDataType)
    end
  end)
  self.chooseSkillChipSetBtnText = self:AddComponent(UIText, txt_choose_skill_chip_set_path)
  self.chooseTWSkillChipSetPopup = self:AddComponent(ChooseTWSkillChipSetPopup, popup_choose_skill_chip_set_path)
  self:ResetUIComps()
  self.leftBottomContainer = self:AddComponent(UIBaseContainer, leftBottomContainerPath)
  self.chooseDominator = self:AddComponent(ChooseDominator, leftBottomContainerPath, self.leftBottomContainer, self)
  self.dominatorTips = self:AddComponent(DominatorTips, dominatorTipsPath)
  self.dominatorPowerRecommend = self:AddComponent(DominatorPowerRecommend, dominatorPowerRecommendPath)
  self.formationPositionTypeText = self:AddComponent(UIText, formationPositionTypeTextPath)
end

local function SetBuffViewActive(self)
  local isOn = self.buffCom:GetActive()
  if not isOn then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
  self.buffCom:SetActive(not isOn)
end

local function RefreshFormationBuff(self)
  local heroes = self.squadData:GetLocalAllHeroes()
  local type = self.formationBuffInfo and self.formationBuffInfo.type
  self.formationBuffInfo = HeroUtils.GetFormationBuffInfoList(heroes)
  self.formationBuffInfo.heros = HeroUtils.SortFormationHeros(heroes)
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

local function DataDefine(self)
  self.heroListGO = {}
  self.heroItems = {}
  self.hasInitHeroList = false
  self.heroType = nil
  self.squadIndex = 1
  self.cachedHeroUuids = {}
end

local function ComponentDestroy(self)
  self.bottomBar = nil
  self.heroList = nil
  self.heroScroll = nil
  self.battleBtn = nil
  self.battleBtnText = nil
  self.backBtn = nil
  self.allTypeHeroToggle = nil
  self.allTypeHeroToggleText = nil
  self.tankTypeHeroToggle = nil
  self.tankTypeHeroToggleIcon = nil
  self.missileTypeToggle = nil
  self.missileTypeToggleIcon = nil
  self.airForceTypeToggle = nil
  self.airForceTypeToggleIcon = nil
  self.middleContentContainer = nil
  self.formationContent = nil
  self.formationRt = nil
  self.powerInfo = nil
  self.powerInfoText = nil
  self.slotAreasContainer = nil
  self.slotAreas = nil
  self.slotPos = nil
  self.heroInfoBarContainer = nil
  self.heroInfoBars = nil
  self.heroInfoBarsPos = nil
  self.heroListTipText = nil
  self.recommandHeroPowerText = nil
  self.stageNameText = nil
  self.root = nil
  self.selfPlayerHead = nil
  self.zombieHeadIcon = nil
  self.topBar = nil
  self.heroInfo2BarContainer = nil
  self.heroInfo2Bars = nil
  self.heroInfo2BarsPos = nil
  self.pvpArenaTopBar = nil
  self.chooseSquadBtn = nil
  self.chooseSquadBtnText = nil
  self.chooseSquadPopup = nil
  self.arena3V3Container = nil
  self.arena3V3ChooseSquadPopup = nil
  self.truckChooseSquadPopup = nil
  self.weaponBtn = nil
  self.weaponLevelNumberText = nil
  self.trailTowerContainer = nil
  self.dominatorTips = nil
  self.dominatorPowerRecommend = nil
  self.formationPositionTypeText = nil
end

local function DataDestroy(self)
  self.source = nil
  self.param1 = nil
  self.param2 = nil
  self.heroListGO = nil
  self.heroItems = nil
  self.hasInitHeroList = false
  self.heroType = nil
  self.squadIndex = nil
  self.cachedHeroUuids = nil
  self.screenWidth = nil
  self.screenHeight = nil
  self.curHeroPos = nil
  self.curEnemyPos = nil
end

local function OnUpdateArmyFormationList(self)
  self:RefreshHeroList(false)
  self:RefreshHeroInfo()
  for i, heroUuid in pairs(self.cachedHeroUuids) do
    local squadIndex
    if self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
      squadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroUuid(heroUuid, true)
    end
    if not squadIndex then
      if self.squadData then
        local index = self.squadData:GetEmptySlotIndex()
        local hasEmptySlot = index ~= nil
        if hasEmptySlot then
          self.squadData:SetLocalHero(index, heroUuid)
        end
      end
      table.remove(self.cachedHeroUuids, i)
    end
  end
  self:RefreshHeroList(false)
  self:RefreshHeroInfo()
end

local function OnHide(self)
  SetVisible(self, false)
end

local function OnArena3V3BattleFinish(self, msg)
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILW3V3Campaign) then
    local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
    selfPlayerInfo.lastRank = DataCenter.LW3V3ArenaManager.lastSelfRank
    selfPlayerInfo.curRank = DataCenter.LW3V3ArenaManager.selfRank
    local otherPlayerInfo = DataCenter.LW3V3Manager.opponentData.playerInfo
    if msg.type3v3 == Type3v3.Train then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false}, msg, selfPlayerInfo, otherPlayerInfo)
    end
  end
end

local function OnDominatorUpdate(self, squadUuid)
  if self.squadData and self.squadData.uuid == squadUuid then
    self:RefreshHeroInfo()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:AddUIListener(EventId.HidePVEFormationPanel, OnHide)
  self:AddUIListener(EventId.Arena3V3BuffChange, self.RefreshPVPArenaChooseSquad)
  self:AddUIListener(EventId.TruckBuffChange, self.RefreshPVPArenaChooseSquad)
  self:AddUIListener(EventId.Arena3V3BattleFinish, self.OnArena3V3BattleFinish)
  self:AddUIListener(EventId.Arena3V3BattleLogicSwitchTeamEnd, self.OnSwitchTeam)
  self:AddUIListener(EventId.EnemyTruckWeaponDataArrive, self.OnEnemyTruckWeaponDataArrive)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
  self:AddUIListener(EventId.GetOtherWeaponInfo, self.OnGetOtherPlayerWeaponInfo)
  self:AddUIListener(EventId.TrainAttackReceived, self.OnTrainAttackReceived)
  self:AddUIListener(EventId.CheckTrainRefreshReceived, self.OnCheckTrainRefreshReceived)
  self:AddUIListener(EventId.RobTruckTryRefreshView, self.OnRobTruckTryRefreshView)
  self:AddUIListener(EventId.KOFBattleLogicSwitchTeamEnd, self.OnSwitchTeam)
  self:AddUIListener(EventId.DominatorFormationUpdate, OnDominatorUpdate)
  self:AddUIListener(EventId.DominatorFormationStateUpdate, self.OnDominatorStateUpdate)
  self:AddUIListener(EventId.OnBattleSquadCreateFinish, self.ResetUIComps)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:RemoveUIListener(EventId.HidePVEFormationPanel, OnHide)
  self:RemoveUIListener(EventId.Arena3V3BuffChange, self.RefreshPVPArenaChooseSquad)
  self:RemoveUIListener(EventId.TruckBuffChange, self.RefreshPVPArenaChooseSquad)
  self:RemoveUIListener(EventId.Arena3V3BattleFinish, self.OnArena3V3BattleFinish)
  self:RemoveUIListener(EventId.Arena3V3BattleLogicSwitchTeamEnd, self.OnSwitchTeam)
  self:RemoveUIListener(EventId.EnemyTruckWeaponDataArrive, self.OnEnemyTruckWeaponDataArrive)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
  self:RemoveUIListener(EventId.GetOtherWeaponInfo, self.OnGetOtherPlayerWeaponInfo)
  self:RemoveUIListener(EventId.TrainAttackReceived, self.OnTrainAttackReceived)
  self:RemoveUIListener(EventId.CheckTrainRefreshReceived, self.OnCheckTrainRefreshReceived)
  self:RemoveUIListener(EventId.RobTruckTryRefreshView, self.OnRobTruckTryRefreshView)
  self:RemoveUIListener(EventId.KOFBattleLogicSwitchTeamEnd, self.OnSwitchTeam)
  self:RemoveUIListener(EventId.DominatorFormationUpdate, OnDominatorUpdate)
  self:RemoveUIListener(EventId.DominatorFormationStateUpdate, self.OnDominatorStateUpdate)
  self:RemoveUIListener(EventId.OnBattleSquadCreateFinish, self.ResetUIComps)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.squadData then
    self:RefreshHeroInfo()
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
  if self.chooseTWSkillChipSetPopup then
    self.chooseTWSkillChipSetPopup:SetActive(false)
  end
end

local function RefreshToggleShow(self)
  if self.heroType == HeroType.All then
    self.allTypeHeroToggleText:SetColorRGBA(0, 0, 0, 1)
  else
    self.allTypeHeroToggleText:SetColorRGBA(0.467, 0.443, 0.522, 1)
  end
  if self.heroType == HeroType.Tank then
    self.tankTypeHeroToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_tanke_da.png")
  else
    self.tankTypeHeroToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_tanke_xiao.png")
  end
  if self.heroType == HeroType.Missile then
    self.missileTypeToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_daodan_da.png")
  else
    self.missileTypeToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_daodan_xiao.png")
  end
  if self.heroType == HeroType.Aircraft then
    self.airForceTypeToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_feiji_da.png")
  else
    self.airForceTypeToggleIcon:LoadSprite("Assets/Main/Sprites/UI/UILWHeroSquad/zyf_biandui_feiji_xiao.png")
  end
end

local function RefreshStageInfo(self)
end

function UIHeroFakePVPFormationPanelView:RefreshTruckRobTopBar()
  if self.trainBattleInfo then
    local ownerData = {}
    local otherData = {}
    otherData.totalPower = self.trainBattleInfo.power
    otherData.uid = self.trainBattleInfo.ownerId
    otherData.pic = self.trainBattleInfo.pic
    otherData.picver = self.trainBattleInfo.picVer
    otherData.headSkinId = self.trainBattleInfo.headSkinId
    ownerData.totalPower = self.squadData:GetTotalCapacity(self.squadIndex)
    ownerData.uid = LuaEntry.Player.uid
    ownerData.pic = LuaEntry.Player.pic
    ownerData.picver = LuaEntry.Player.picVer
    ownerData.headSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Head_Frame) or 0
    local ownerPowerDetailData = self:GetOwnerPowerDetailData()
    self.pvpArenaTopBar:Refresh(ownerData, otherData, self.trainBattleInfo.weaponData, nil, ownerPowerDetailData)
  end
end

function UIHeroFakePVPFormationPanelView:RefreshPVPArenaTopBar()
  if self:IsNormalArena() then
    self.pvpArenaTopBar:SetActive(true)
    if self.arenaBattleInfo then
      self.arenaBattleInfo.otherInfo.playerInfo.totalPower = self.armyPower
      self.arenaBattleInfo.ownerInfo.playerInfo.totalPower = self.squadData:GetPVPTotalCapacity(self.squadIndex)
      local weaponData = DataCenter.TacticalWeaponManager:GetOtherPlayerWeaponInfo(self.arenaBattleInfo.otherInfo.playerInfo.uid, self.arenaBattleInfo.otherInfo.playerInfo.serverId)
      local ownerPowerDetailData = self:GetOwnerPowerDetailData()
      self.pvpArenaTopBar:Refresh(self.arenaBattleInfo.ownerInfo.playerInfo, self.arenaBattleInfo.otherInfo.playerInfo, weaponData, self.arenaBattleInfo.otherInfo.skillChipArr, ownerPowerDetailData)
    end
  elseif self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
    self.pvpArenaTopBar:SetActive(true)
    self:RefreshTruckRobTopBar()
  else
    self.pvpArenaTopBar:SetActive(false)
  end
end

local function RefreshArena3V3Container(self)
  if self.source == EnterHeroSquadPanelWay.Arena3V3Attack or self.source == EnterHeroSquadPanelWay.KOFAttack then
    self.arena3V3Container:SetActive(true)
    local selfPlayerInfo = {}
    selfPlayerInfo.uid = LuaEntry.Player.uid
    selfPlayerInfo.name = LuaEntry.Player.name
    selfPlayerInfo.pic = LuaEntry.Player.pic
    selfPlayerInfo.picVer = LuaEntry.Player.picVer
    selfPlayerInfo.headFrame = LuaEntry.Player:GetHeadBgImg()
    selfPlayerInfo.power = self.squadData:GetTotalCapacity()
    local info = DataCenter.LW3V3Manager.opponentData
    if self.source == EnterHeroSquadPanelWay.KOFAttack then
      info = DataCenter.LWKOFBattleManager.opponentData
    end
    local oppoPlayerInfo = {}
    if info and info.playerInfo then
      local playerInfo = info.playerInfo
      oppoPlayerInfo.uid = playerInfo.uid
      oppoPlayerInfo.name = playerInfo.name
      oppoPlayerInfo.pic = playerInfo.pic
      oppoPlayerInfo.picVer = playerInfo.picver
      local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(playerInfo.headSkinId, playerInfo.headSkinET, false)
      oppoPlayerInfo.headFrame = headFramePath
      oppoPlayerInfo.power = 0
      if info.teams and info.teams[self.squadIndex] then
        oppoPlayerInfo.power = info.teams[self.squadIndex].power
      end
      oppoPlayerInfo.serverId = playerInfo.serverId
    end
    local oppoWeaponInfo = DataCenter.TacticalWeaponManager:GetOtherPlayerWeaponInfo(oppoPlayerInfo.uid, oppoPlayerInfo.serverId)
    local ownerPowerDetailData = self:GetOwnerPowerDetailData()
    self.arena3V3Container:Refresh(selfPlayerInfo, oppoPlayerInfo, self.squadIndex, oppoWeaponInfo, ownerPowerDetailData, self.source)
  else
    self.arena3V3Container:SetActive(false)
  end
end

local function RefreshPVPArenaChooseSquad(self)
  self.chooseSquadPopup:SetActive(false)
  self.arena3V3ChooseSquadPopup:SetActive(false)
  self.truckChooseSquadPopup:SetActive(false)
  if self.source == EnterHeroSquadPanelWay.PVPArena or self.source == EnterHeroSquadPanelWay.ActivityArena or self.source == EnterHeroSquadPanelWay.ActivityArenaV2 or self.source == EnterHeroSquadPanelWay.NewPeakArena or self.source == EnterHeroSquadPanelWay.NewGaleArena then
    self.chooseSquadBtn:SetActive(true)
    self.chooseSquadBtnText:SetText("T" .. self.squadIndex)
  elseif (self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob) and self.squadData then
    self.chooseSquadBtn:SetActive(true)
    if self.squadData.localSquadNo == nil or self.squadData.localSquadNo <= 0 then
      self.chooseSquadBtnText:SetText("")
    else
      self.chooseSquadBtnText:SetText("T" .. self.squadData.localSquadNo)
    end
    self:RefreshTruckRobTopBar()
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack and self.squadData then
    self.chooseSquadBtn:SetActive(true)
    self.chooseSquadBtnText:SetText("T" .. self.squadData.localSquadNo)
    RefreshArena3V3Container(self)
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack and self.squadData then
    self.chooseSquadBtn:SetActive(true)
    self.chooseSquadBtnText:SetText("T" .. self.squadData.localSquadNo)
    RefreshArena3V3Container(self)
  else
    self.chooseSquadBtn:SetActive(false)
  end
end

local function RefreshTWSkillChipBtn(self)
  local functionUnlock = DataCenter.TWSkillChipManager:IsFunctionUnlock()
  self.chooseSkillChipSetBtn:SetActive(functionUnlock)
  if functionUnlock then
    local setUnlock = DataCenter.TacticalChipManager:IsPlanUnlock(self.squadData:GetLocalTWSkillChipSetId())
    if setUnlock then
      self.chooseSkillChipSetBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/lrb_wurenji_xinpian_icon.png")
      self.chooseSkillChipSetBtnIcon:SetSizeDeltaXY(64, 48)
    else
      self.chooseSkillChipSetBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_tubiao_suo.png")
      self.chooseSkillChipSetBtnIcon:SetSizeDeltaXY(49.6, 64)
    end
    local localChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    if localChipSetId and 0 < localChipSetId then
      self.chooseSkillChipSetBtnText:SetLocalText("800323", localChipSetId)
    else
      self.chooseSkillChipSetBtnText:SetText("")
    end
  end
end

local function RefreshTrailTowerContainer(self)
  if self.source == EnterHeroSquadPanelWay.TrailTower then
    self.trailTowerContainer:SetActive(true)
    local selfPlayerInfo = {}
    selfPlayerInfo.uid = LuaEntry.Player.uid
    selfPlayerInfo.name = LuaEntry.Player.name
    selfPlayerInfo.pic = LuaEntry.Player.pic
    selfPlayerInfo.picVer = LuaEntry.Player.picVer
    selfPlayerInfo.headFrame = LuaEntry.Player:GetHeadBgImg()
    selfPlayerInfo.power = self.squadData:GetTotalCapacity()
    local oppoPlayerInfo = {}
    oppoPlayerInfo.uid = nil
    oppoPlayerInfo.name = nil
    oppoPlayerInfo.pic = nil
    oppoPlayerInfo.picVer = nil
    oppoPlayerInfo.headFrame = nil
    local powerStr = LocalController:instance():getValue(TableName.LWArmy, self.trailTowerInfo.trailTowerLevelTemplate.levelArmyId, "pve_power")
    local powerStrArr = string.split(powerStr, "|")
    local totalPower = 0
    for _, power in ipairs(powerStrArr) do
      totalPower = totalPower + tonumber(power)
    end
    oppoPlayerInfo.power = totalPower
    local ownerPowerDetailData = self:GetOwnerPowerDetailData()
    self.trailTowerContainer:Refresh(selfPlayerInfo, oppoPlayerInfo, self.trailTowerInfo.trailTowerLevelTemplate, ownerPowerDetailData)
  else
    self.trailTowerContainer:SetActive(false)
  end
end

local function OnOpen(self)
  local onOpenCallBack
  self.source, self.param1, self.param2, onOpenCallBack = self:GetUserData()
  if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
    self.detectEventUuid = self.param1
    if not self.detectEventUuid then
      self:ClosePanel()
      return
    end
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.detectEventUuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    self.stageId = template.para
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    if self.param1 and self.param1.pageType then
      self.jeepAdventurePageType = self.param1.pageType
      self.cfgId = self.param1.cfgId
      self.stageId = self.param2
    end
  elseif self.source == EnterHeroSquadPanelWay.BeginnerEvent then
    self.bossIndex = self.param1
  elseif self.source == EnterHeroSquadPanelWay.DetectZombieBusTrain then
    self.busId = self.param1.busId
    self.busIndex = self.param1.busIndex
    self.eventUuid = self.param1.eventUuid
  elseif self.source == EnterHeroSquadPanelWay.TruckRob then
    self.trainUuid = self.param1.uuid
    self.trainServerId = self.param1.serverId
    self.trainBattleInfo = self.param1
    local weaponData = DataCenter.LWMyStationDataManager:GetEnemyTruckWeapon()
    if weaponData and weaponData.uid == self.trainBattleInfo.ownerId then
      self.trainBattleInfo.weaponData = weaponData
    end
  elseif self.source == EnterHeroSquadPanelWay.HSRRob then
    self.trainBattleInfo = self.param1
  elseif self.source == EnterHeroSquadPanelWay.TrailTower then
    self.trailTowerInfo = self.param1
  elseif self:IsNormalArena() then
    self.arenaBattleInfo = self.param1
    self:CalculateActivityArenaArmyPower()
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    if onOpenCallBack then
      self.waitWindow = true
    end
  elseif self.source == EnterHeroSquadPanelWay.T11IdleGameBattleEvent then
    self.t11EventUuid = self.param1.eventUuid
    self.t11EventLevelId = self.param1.levelId
  end
  RefreshStageInfo(self)
  self.squadIndex = DataCenter.LWBattleManager:GetCurBattleLogic().squadIndex
  self:RefreshFormationPositionType()
  self:RefreshSquadData()
  RefreshPVPArenaChooseSquad(self)
  self:RefreshTWSkillChipBtn()
  local state = self.allTypeHeroToggle:GetIsOn()
  if state then
    self:OnChangeTypeToggle(HeroType.All)
  else
    self.allTypeHeroToggle:SetIsOn(true)
  end
  self:RefreshHeroInfo()
  self:RefreshHeroFakeInfo()
  self:RefreshWeaponInfo()
  if onOpenCallBack then
    onOpenCallBack()
  end
  self.chooseDominator:SetData(self.source, self.squadIndex, self.param1)
  self.dominatorTips:ReInit(self.source, self.squadIndex, self.squadData, self.param1)
  self.dominatorPowerRecommend:ReInit(self.source, self.param1)
  self:RefreshQuickBtn()
end

local function OnSwitchTeam(self, index)
  if self.source == EnterHeroSquadPanelWay.Arena3V3Attack or self.source == EnterHeroSquadPanelWay.KOFAttack then
    self.squadIndex = index
    self:RefreshSquadData()
    RefreshArena3V3Container(self)
    RefreshPVPArenaChooseSquad(self)
    self:RefreshHeroInfo()
    self:RefreshHeroFakeInfo()
    self:RefreshHeroList()
    self.chooseDominator:SetData(self.source, self.squadIndex, self.param1)
    self.waitWindow = false
  end
end

local function OnEnemyTruckWeaponDataArrive(self, weaponData)
  if self.source == EnterHeroSquadPanelWay.TruckRob and weaponData.uid == self.trainBattleInfo.ownerId then
    self.trainBattleInfo.weaponData = weaponData
    self:RefreshTruckRobTopBar()
  end
end

local function RefreshSquadData(self)
  if self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
    self.squadData = DataCenter.LWMyStationDataManager:GetRobFormation()
    self.squad_plan_content:SetActive(true)
    for k, v in ipairs(self.squad_plan_btn_list) do
      local data = {self = self, index = k}
      local bindFunc = BindCallback(data, self.OnClickSquadChooseBtn)
      v:SetData(self.source, k, self.squadData.index, bindFunc, true)
    end
    if self.squadData then
      self.squadIndex = self.squadData.index
    end
  elseif self:IsNormalArena() then
    self.squadData = ArenaArmyFormationInfo.New()
    self.squadData:ParseData(self.arenaBattleInfo.ownerInfo)
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
    self.squadData = DataCenter.LW3V3Manager:GetAtkTeamByIndex(self.squadIndex)
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    self.squadData = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(self.squadIndex)
  elseif self.source == EnterHeroSquadPanelWay.TrailTower then
    self.squadData = DataCenter.LWTrailTowerManager:GetTrailTowerFormation(self.trailTowerInfo.trailTowerLevelTemplate.towerId)
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    self.squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, self.squadIndex)
    local dominatorUuid = self.squadData:GetLocalDominatorUuid()
    if self.jeepAdventurePageType == JeepAdventurePageType.TowerUp then
      local dominatorUuid = self.squadData:GetLocalDominatorUuid()
      if dominatorUuid and 0 < dominatorUuid then
        local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
        if dominatorInfo and not dominatorInfo:IsUnlockedBattle() then
          self.squadData:UnsetLocalDominator()
        end
      end
    end
    self.squadData:SetFormationPositionType(self.formationPositionType)
  else
    self.squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, self.squadIndex)
  end
  self.slotCount = 5
  self:RefreshHeroInfo()
  self.chooseDominator:SetData(self.source, self.squadIndex, self.param1)
  self.chooseDominator:SetSquadData(self.squadData)
end

local function GetHeroList(self, heroType)
  local heroList = {}
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for uuid, heroData in pairs(heroDataList) do
    local displayData = {}
    if not (0 < heroType) or heroData.heroType == heroType then
      if self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
        local squadIndex = DataCenter.LW3V3Manager:GetHeroInAtkTeamIndex(uuid)
        if squadIndex then
          displayData.squadIndex = squadIndex
        end
      elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
        local squadIndex = DataCenter.LWKOFBattleManager:GetHeroInAtkTeamIndex(uuid)
        if squadIndex then
          displayData.squadIndex = squadIndex
        end
      elseif self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
        displayData.squadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroId(heroData.heroId, true)
      else
        local inSquad = self.squadData:HasLocalHero(uuid)
        if inSquad then
          displayData.squadIndex = self.squadIndex
        end
      end
      if self.source == EnterHeroSquadPanelWay.TrailTower then
        displayData.isSelected = displayData.squadIndex ~= nil
        displayData.canUse = DataCenter.LWTrailTowerManager:HeroIsCanUse(self.trailTowerInfo.trailTowerLevelTemplate.towerId, uuid)
      end
      displayData.heroData = heroData
      table.insert(heroList, displayData)
    end
  end
  if self.source == EnterHeroSquadPanelWay.TrailTower then
    table.sort(heroList, function(a, b)
      if a.canUse == b.canUse then
        if a.isSelected == b.isSelected then
          return a.heroData.power > b.heroData.power
        else
          return a.isSelected
        end
      else
        return a.canUse
      end
    end)
  else
    table.sort(heroList, function(a, b)
      return a.heroData.power > b.heroData.power
    end)
  end
  return heroList
end

function UIHeroFakePVPFormationPanelView:CalculateAmryPower()
  local armySoldierPower = 0
  for _, v in pairs(self.arenaBattleInfo.otherInfo.soldiers) do
    v.meta = DataCenter.SoldierDataManager:GetTemplate(v.type)
    armySoldierPower = armySoldierPower + v.meta.power * v.total
  end
  local otherPower = self.arenaBattleInfo.otherInfo.equipPower + self.arenaBattleInfo.otherInfo.power + armySoldierPower
  self.armyPower = otherPower
  return self.armyPower
end

function UIHeroFakePVPFormationPanelView:CalculateActivityArenaArmyPower()
  if self.arenaBattleInfo.otherInfo.formationPower and self.arenaBattleInfo.otherInfo.formationPower > 0 then
    self.armyPower = self.arenaBattleInfo.otherInfo.formationPower
    return self.armyPower
  end
  if self.arenaBattleInfo.otherInfo.playerInfo and self.arenaBattleInfo.otherInfo.playerInfo.power then
    self.armyPower = self.arenaBattleInfo.otherInfo.playerInfo.power
    return self.armyPower
  end
  return self:CalculateAmryPower()
end

function UIHeroFakePVPFormationPanelView:OnInitHeroScroll(go, index)
  local item = self.heroScroll:AddComponent(UIFormationHeroCell, go)
  self.heroListGO[go] = item
end

function UIHeroFakePVPFormationPanelView:OnUpdateHeroScroll(go, index)
  go.transform:Set_localScale(1.16, 1.16, 1)
  local item = self.heroListGO[go]
  local heroSquadData = self.heroDataList[index + 1]
  item:SetActive(heroSquadData ~= nil)
  local showFormation = false
  if self.source == EnterHeroSquadPanelWay.Arena3V3Attack or self.source == EnterHeroSquadPanelWay.TrailTower or self.source == EnterHeroSquadPanelWay.KOFAttack or self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
    showFormation = true
  end
  item:SetData(heroSquadData, showFormation)
  local isSelected = self.squadData:HasLocalHero(heroSquadData.heroData.uuid)
  item:SetSelected(isSelected)
  self.heroItems[heroSquadData.heroData.uuid] = item
  if isSelected == false then
    self.clickGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TryGuideClickHeroInList(item.heroCell)
    end, 0.85)
  end
end

function UIHeroFakePVPFormationPanelView:OnDestroyHeroScrollItem(go, index)
  local heroSquadData = self.heroDataList[index + 1]
  if heroSquadData and heroSquadData.heroData then
    self.heroItems[heroSquadData.heroData.uuid] = nil
  end
end

local function TakeDownHero(self, squadIndex, heroUuid)
  if squadIndex ~= self.squadIndex then
  else
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_quit_the_battle)
    local index = self.squadData:GetLocalHeroIndex(heroUuid)
    self.squadData:SetLocalHero(index, nil)
    self:RefreshHeroList(false)
    self:RefreshHeroInfo()
  end
end

local function OnClickHeroCell(self, heroDisplayData, heroItem)
  if not heroDisplayData then
    return
  end
  if self.source == EnterHeroSquadPanelWay.TrailTower and heroDisplayData.canUse ~= nil and not heroDisplayData.canUse then
    local heroName = Localization:GetString(heroDisplayData.heroData.firstName)
    local trailTowerTemplate = DataCenter.LWTrailTowerManager:GetHeroBelongToTrailTower(self.trailTowerInfo.trailTowerLevelTemplate.towerId, heroDisplayData.heroData.uuid)
    local trailTowerName = trailTowerTemplate ~= nil and Localization:GetString(trailTowerTemplate.name) or ""
    UIUtil.ShowTips(Localization:GetString("trialtower_045", heroName, trailTowerName))
    return
  end
  local heroUuid = heroDisplayData.heroData.uuid
  local isInSquad = heroDisplayData.squadIndex == self.squadIndex
  if isInSquad then
    local index = self.squadData:GetLocalHeroIndex(heroUuid)
    self.squadData:SetLocalHero(index, nil)
    heroItem:SetSelected(false)
    self:RefreshHeroInfo()
    heroDisplayData.squadIndex = nil
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_quit_the_battle)
    return
  end
  local index = self.squadData:GetEmptySlotIndex()
  local hasEmptySlot = index ~= nil
  if hasEmptySlot then
    if self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
      local inSquadIndex = DataCenter.LW3V3Manager:GetHeroInAtkTeamIndex(heroUuid)
      local isInOtherSquad = inSquadIndex ~= nil and inSquadIndex ~= self.squadIndex
      if isInOtherSquad then
        local heroName = heroDisplayData.heroData:GetName()
        local otherSquad = DataCenter.LW3V3Manager:GetAtkTeamByIndex(inSquadIndex)
        if otherSquad then
          UIUtil.ShowMessage(Localization:GetString(500263, heroName, inSquadIndex), 1, "110006", nil, function()
            local inOtherSquadindex = otherSquad:GetLocalHeroIndex(heroUuid)
            if inOtherSquadindex then
              otherSquad:SetLocalHero(inOtherSquadindex, nil)
            end
            self.squadData:SetLocalHero(index, heroUuid)
            self:RefreshHeroList(false)
            self:RefreshHeroInfo()
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
            if heroData then
              local meta = heroData.meta
              if meta then
                local soundAsset = meta.sound_show
                if not string.IsNullOrEmpty(soundAsset) then
                  self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
                end
              end
            end
          end, nil, nil)
        end
      else
        self.squadData:SetLocalHero(index, heroUuid)
        heroItem:SetSelected(true)
        self:RefreshHeroInfo()
        heroDisplayData.squadIndex = self.squadIndex
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData then
          local meta = heroData.meta
          if meta then
            local soundAsset = meta.sound_show
            if not string.IsNullOrEmpty(soundAsset) then
              self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
            end
          end
        end
      end
    elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
      local inSquadIndex = DataCenter.LWKOFBattleManager:GetHeroInAtkTeamIndex(heroUuid)
      local isInOtherSquad = inSquadIndex ~= nil and inSquadIndex ~= self.squadIndex
      if isInOtherSquad then
        local heroName = heroDisplayData.heroData:GetName()
        local otherSquad = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(inSquadIndex)
        if otherSquad then
          UIUtil.ShowMessage(Localization:GetString(500263, heroName, inSquadIndex), 1, "110006", nil, function()
            local inOtherSquadindex = otherSquad:GetLocalHeroIndex(heroUuid)
            if inOtherSquadindex then
              otherSquad:SetLocalHero(inOtherSquadindex, nil)
            end
            self.squadData:SetLocalHero(index, heroUuid)
            self:RefreshHeroList(false)
            self:RefreshHeroInfo()
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
            if heroData then
              local meta = heroData.meta
              if meta then
                local soundAsset = meta.sound_show
                if not string.IsNullOrEmpty(soundAsset) then
                  self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
                end
              end
            end
          end, nil, nil)
        end
      else
        self.squadData:SetLocalHero(index, heroUuid)
        heroItem:SetSelected(true)
        self:RefreshHeroInfo()
        heroDisplayData.squadIndex = self.squadIndex
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData then
          local meta = heroData.meta
          if meta then
            local soundAsset = meta.sound_show
            if not string.IsNullOrEmpty(soundAsset) then
              self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
            end
          end
        end
      end
    elseif self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
      local inSquadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroId(heroDisplayData.heroData.heroId, true)
      local isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= self.squadIndex
      if isInOtherFormation then
        local otherSquad = DataCenter.LWMyStationDataManager:GetAttackFormationByIndex(heroDisplayData.squadIndex)
        local heroName = heroDisplayData.heroData:GetName()
        local squadName = DataCenter.BuildManager:GetBuildingNameByUuid(otherSquad.buildingUuid)
        if not ArmyFormationUtils.IsHeroCanTakeDown(otherSquad, heroUuid) then
          UIUtil.ShowTipsId("dominator_squad_empty_warning")
          return
        end
        UIUtil.ShowMessage(Localization:GetString(120212, heroName, squadName), 1, "110006", nil, function()
          self:TakeDownTruckAttackHero(heroDisplayData.squadIndex, heroUuid)
        end, nil, nil)
        return
      else
        self:PutOnHeroDirectly(heroItem, heroDisplayData, index, heroUuid)
      end
    elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
      local isCanUseIndex = true
      if self.jeepAdventurePageType == JeepAdventurePageType.Domintor and self.formationPositionType then
        local showSlotIndexList = ArmyFormationSlotPositionType[self.formationPositionType]
        if showSlotIndexList then
          local isShow = false
          for _, v in ipairs(showSlotIndexList) do
            if v == index then
              isShow = true
              break
            end
          end
          if not isShow then
            isCanUseIndex = false
          end
        end
      end
      if isCanUseIndex then
        self:PutOnHeroDirectly(heroItem, heroDisplayData, index, heroUuid)
      end
    else
      self:PutOnHeroDirectly(heroItem, heroDisplayData, index, heroUuid)
    end
  else
    UIUtil.ShowTipsId(120210)
  end
end

local function PutOnHeroDirectly(self, heroItem, heroDisplayData, index, heroUuid)
  self.squadData:SetLocalHero(index, heroUuid)
  heroItem:SetSelected(true)
  self:RefreshHeroInfo()
  heroDisplayData.squadIndex = self.squadIndex
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData then
    local meta = heroData.meta
    if meta then
      local soundAsset = meta.sound_show
      if not string.IsNullOrEmpty(soundAsset) then
        self.soundHandle = DataCenter.LWSoundManager:PlayHeroSound(soundAsset)
      end
    end
  end
end

local function TakeDownTruckAttackHero(self, squadIndex, heroUuid)
  if squadIndex ~= self.squadIndex then
    local otherSquad = DataCenter.LWMyStationDataManager:GetAttackFormationByIndex(squadIndex)
    if otherSquad then
      local index = otherSquad:GetLocalHeroIndex(heroUuid)
      otherSquad:SetLocalHero(index, nil)
      local curHeroes = otherSquad:GetLocalAllHeroes()
      DataCenter.LWMyStationDataManager:TrySaveTruckFormation(otherSquad, true)
      table.insert(self.cachedHeroUuids, heroUuid)
    end
  else
    local index = self.squadData:GetLocalHeroIndex(heroUuid)
    if index then
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_quit_the_battle)
      self.squadData:SetLocalHero(index, nil)
      self:RefreshHeroList(false)
      self:RefreshHeroInfo()
    end
  end
end

local function ClearSound(self)
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
end

function UIHeroFakePVPFormationPanelView:RefreshHeroList(moveToTop)
  self.heroDataList = self:GetHeroList(self.heroType)
  local count = table.count(self.heroDataList)
  if 0 < count then
    self.heroScroll:SetActive(true)
    if not self.hasInitHeroList then
      local bindFunc1 = BindCallback(self, self.OnInitHeroScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateHeroScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyHeroScrollItem)
      self.heroList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitHeroList = true
    self.heroList:SetItemCount(count)
    self.heroList:ForceUpdate()
    if moveToTop then
      self.heroList:MoveItemByIndex(0)
    end
    self.heroListTipText:SetActive(false)
  else
    self.heroScroll:SetActive(false)
    self.heroListTipText:SetActive(true)
  end
end

local function OnSelectTypeToggle(self)
  self:RefreshHeroList(true)
end

local function OnChangeTypeToggle(self, heroType)
  if self.heroType == heroType then
    return
  end
  self.heroType = heroType
  OnSelectTypeToggle(self)
  RefreshToggleShow(self)
end

local function RefreshHeroFakeInfo(self)
  local heroData = DataCenter.LWBattleManager:GetCurBattleLogic().heroDataList
  for i = 1, ArmyFormationSlot.Hero5 do
    local hasHero = heroData and heroData[i]
    if hasHero then
      local heroId = heroData[i].heroId
      self.heroInfo2Bars[i]:SetData(heroData[i].level, heroId, heroData[i].weaponLevel)
    else
      self.heroInfo2Bars[i]:SetData(nil)
    end
  end
end

local function RefreshHeroInfo(self)
  if not self.squadData then
    return
  end
  self.heroes = self.squadData:GetLocalAllHeroes()
  local hero40010inFront, hero30002atBack
  local totalCombatPower = 0
  local heroCount = 0
  for i = 1, self.slotCount do
    local hasHero = self.heroes[i] ~= nil
    if hasHero then
      local heroUuid = self.heroes[i]
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        self.heroInfoBars[i]:SetData(heroData.level, heroUuid)
        totalCombatPower = totalCombatPower + heroData.power
        if 1 <= i and i <= 2 and heroData.heroId == 40010 then
          hero40010inFront = i
        end
        if 3 <= i and i <= 5 and heroData.heroId == 30002 then
          hero30002atBack = i
        end
      end
      heroCount = heroCount + 1
    else
      self.heroInfoBars[i]:SetData(nil)
    end
  end
  local heroDatas = {}
  for index, heroUuid in pairs(self.heroes) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil then
      heroDatas[index] = heroData
    end
  end
  local dominatorUuid = self.squadData:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      heroDatas[ArmyFormationSlot.Dominator] = dominatorInfo:GetHeroInfo()
      totalCombatPower = totalCombatPower + dominatorInfo.power
    else
    end
  end
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if logic and logic.SetHeroers then
    DataCenter.LWBattleManager:GetCurBattleLogic():SetHeroers(heroDatas)
  end
  if self:IsNormalArena() then
    totalCombatPower = self.squadData:GetPVPTotalCapacity(self.squadIndex)
  end
  self.powerInfoText:SetText(string.GetFormattedStr(totalCombatPower))
  if not self.guidedSwitch and hero40010inFront and hero30002atBack then
    self.guidedSwitch = true
    self.switchGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:GuideSwitchHeros(self.slotAreas[hero30002atBack], self.slotAreas[hero40010inFront])
    end, 0.5)
  end
  self:RefreshFormationBuff()
  self:RefreshTWSkillChipBtn()
  RefreshArena3V3Container(self)
  self:RefreshPVPArenaTopBar()
  RefreshTrailTowerContainer(self)
end

local function UpdateView(self)
end

local function OnSetHero(self)
  self:UpdateView()
end

local function ClosePanel(self)
  if self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILW3V3Campaign)
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWKOFCampaign)
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
    DataCenter.LWBattleManager:Exit()
  else
    DataCenter.LWBattleManager:Exit()
  end
end

local function TryGuideClickHeroInList(self, heroCell)
  if self.squadData:GetEmptySlotIndex() ~= nil and CommonUtil.PlayerPrefsGetInt("PVE_FORMATION_CLICK_HERO_GUIDE", 0) == 0 then
    CommonUtil.PlayerPrefsSetInt("PVE_FORMATION_CLICK_HERO_GUIDE", 1)
    self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.clickFingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      if heroCell then
        transform.position = heroCell.img_icon.transform.position
      end
      TimerManager:GetInstance():DelayInvoke(function()
        if not IsNull(self.clickFingerHandle) then
          self.clickFingerHandle:Destroy()
          self.clickFingerHandle = nil
        end
      end, 2)
    end)
  end
end

local function GuideSwitchHeros(self, srcSlot, tarSlot)
  if not IsNull(self.switchFingerHandle) then
    self.switchFingerHandle:Destroy()
    self.switchFingerHandle = nil
  end
  self.switchFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger_hold.prefab")
  self.switchFingerHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(handle)
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
    transform.position = srcSlot.transform.position
    transform.localScale = Vector3.one
    local img = transform:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
    self.switchGuideTween = DOTween.Sequence()
    if not IsNull(img) then
      self.switchGuideTween:Append(img:DOFade(0, 0))
      self.switchGuideTween:Append(img:DOFade(1, 0.5))
    end
    self.switchGuideTween:Append(transform:DOMove(tarSlot.transform.position, 0.5))
    if not IsNull(img) then
      self.switchGuideTween:Append(img:DOFade(0, 0.5))
    end
    self.switchGuideTween:SetLoops(2)
    self.switchGuideTween:OnComplete(function()
      if not IsNull(self.switchFingerHandle) then
        self.switchFingerHandle:Destroy()
        self.switchFingerHandle = nil
      end
    end)
  end)
end

local function RefreshWeaponInfo(self)
  self.weaponData = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  local appearanceMeta
  if self.weaponData then
    appearanceMeta = DataCenter.TacticalWeaponManager:GetWeaponAppearance(self.weaponData.id)
    self.weaponBtn:SetActive(true)
    self.weaponLevelNumberText:SetText(self.weaponData.level)
  else
    self.weaponBtn:SetActive(false)
  end
end

local function OnClickSquadChooseBtn(data)
  local self = data.self
  local index = data.index
  local squadData = DataCenter.LWMyStationDataManager:GetAttackFormationByIndex(index)
  if squadData ~= nil then
    self.squadData = squadData
    self.squadIndex = squadData.index
    self.slotCount = 5
    for k, v in ipairs(self.squad_plan_btn_list) do
      local newData = {self = self, index = k}
      local bindFunc = BindCallback(newData, self.OnClickSquadChooseBtn)
      v:SetData(self.source, k, index, bindFunc, true)
    end
  end
  self:RefreshHeroInfo()
  self:RefreshHeroList(false)
  self:RefreshPVPArenaChooseSquad()
  self.chooseDominator:SetData(self.source, self.squadIndex)
  self.chooseDominator:SetSquadData(self.squadData)
end

local function OnClickSkillChipSet(self, idx)
  TacticalWeaponUtils:SetSquadUseSet(self.source, self.squadData, idx, function()
    self:RefreshHeroInfo()
  end)
end

local function OnTWSkillChipUpdate(self)
  self:RefreshTWSkillChipBtn()
end

function UIHeroFakePVPFormationPanelView:OnTrainAttackReceived()
  TimerManager:GetInstance():DelayInvoke(function()
    if self then
      self.truckRobBlocking = nil
    end
  end, 1)
end

function UIHeroFakePVPFormationPanelView:OnCheckTrainRefreshReceived(uuid)
  if self.source == EnterHeroSquadPanelWay.TruckRob and self.trainUuid == uuid then
    self:RefreshTruckRobTopBar()
  end
end

function UIHeroFakePVPFormationPanelView:OnRobTruckTryRefreshView(uuid)
  if self.source == EnterHeroSquadPanelWay.TruckRob and self.trainUuid == uuid then
    self:RefreshHeroFakeInfo()
  end
end

local function OnGetOtherPlayerWeaponInfo(self, playerUid)
  if self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
    if DataCenter.LW3V3Manager.opponentData and DataCenter.LW3V3Manager.opponentData.uid == playerUid then
      self:RefreshArena3V3Container()
    end
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    if DataCenter.LWKOFBattleManager.opponentData and DataCenter.LWKOFBattleManager.opponentData.uid == playerUid then
      self:RefreshArena3V3Container()
    end
  elseif self:IsNormalArena() and self.arenaBattleInfo.otherInfo.playerInfo.uid and self.arenaBattleInfo.otherInfo.playerInfo.uid == playerUid then
    self:RefreshPVPArenaTopBar()
  end
end

function UIHeroFakePVPFormationPanelView:GetOwnerPowerDetailData()
  local heroPower = 0
  local armyPower = 0
  local squadEquipPower = 0
  local otherPower = 0
  local dominatorPower = 0
  local isFakeArmyPower = false
  if self:IsNormalArena() then
    self.squadData:ConscriptSoldier()
    local buildUid = DataCenter.LW3V3Manager:GetCurrentTeamBuffBuildingUuid(self.squadIndex)
    heroPower = self.squadData:GetPVPHeroesCapacity()
    armyPower = self.squadData:GetSoldiersCapacity()
    squadEquipPower = self.squadData:GetPVPEquipCapacity(buildUid)
    otherPower = self.squadData:GetTWSkillChipCapacity()
    dominatorPower = self.squadData:GetDominatorCapacity()
    isFakeArmyPower = false
  elseif self.source == EnterHeroSquadPanelWay.TruckRob or self.source == EnterHeroSquadPanelWay.HSRRob then
    if self.squadData.RecalculateMaxLevelSoldier then
      self.squadData:RecalculateMaxLevelSoldier()
    else
      self.squadData:ConscriptSoldier()
    end
    heroPower = self.squadData:GetHeroesCapacity()
    armyPower = self.squadData:GetSoldiersCapacity()
    squadEquipPower = self.squadData:GetEquipCapacity()
    otherPower = self.squadData:GetTWSkillChipCapacity()
    dominatorPower = self.squadData:GetDominatorCapacity()
    isFakeArmyPower = false
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Attack then
    heroPower = self.squadData:GetHeroesCapacity()
    armyPower = self.squadData:GetSoldiersCapacity()
    squadEquipPower = self.squadData:GetEquipCapacity()
    otherPower = self.squadData:GetTWSkillChipCapacity()
    dominatorPower = self.squadData:GetDominatorCapacity()
    isFakeArmyPower = false
  elseif self.source == EnterHeroSquadPanelWay.KOFAttack then
    heroPower = self.squadData:GetHeroesCapacity()
    armyPower = self.squadData:GetSoldiersCapacity()
    squadEquipPower = self.squadData:GetEquipCapacity()
    otherPower = self.squadData:GetTWSkillChipCapacity()
    isFakeArmyPower = false
  else
    if self.source == EnterHeroSquadPanelWay.TrailTower then
      heroPower = self.squadData:GetHeroesCapacity()
      armyPower = self.squadData:GetSoldiersCapacity()
      squadEquipPower = self.squadData:GetEquipCapacity()
      otherPower = self.squadData:GetTWSkillChipCapacity()
      dominatorPower = self.squadData:GetDominatorCapacity()
      isFakeArmyPower = false
    else
    end
  end
  local sourceData = {
    heroPower = math.floor(heroPower),
    armyPower = math.floor(armyPower),
    squadEquipPower = math.floor(squadEquipPower),
    otherPower = math.floor(otherPower),
    dominatorPower = math.floor(dominatorPower),
    isFakeArmyPower = isFakeArmyPower
  }
  return sourceData
end

local function IsNormalArena(self)
  return self.source == EnterHeroSquadPanelWay.PVPArena or self.source == EnterHeroSquadPanelWay.ActivityArena or self.source == EnterHeroSquadPanelWay.ActivityArenaV2 or self.source == EnterHeroSquadPanelWay.NewPeakArena or self.source == EnterHeroSquadPanelWay.NewGaleArena
end

function UIHeroFakePVPFormationPanelView:ResetUIComps()
  local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  if not logic then
    return
  end
  local needRecalculate = false
  if not self.curEnemyPos or not self.curHeroPos then
    needRecalculate = true
  else
    if self.curHeroPos then
      for i = 1, #self.curHeroPos do
        local heroPos = self.curHeroPos[i]
        local curHeroPos = logic:GetSquadMemberPosition(i)
        if not Vector3.Equals(heroPos, curHeroPos) then
          needRecalculate = true
          break
        end
      end
    end
    if not needRecalculate and self.curEnemyPos then
      for i = 1, #self.curEnemyPos do
        local enemyPos = self.curEnemyPos[i]
        local curEnemyPos = logic:GetEnemyMemberPosition(i)
        if not Vector3.Equals(enemyPos, curEnemyPos) then
          needRecalculate = true
          break
        end
      end
    end
  end
  if not needRecalculate then
    return
  end
  local heroWorldPos = logic:GetSquadMemberPosition()
  local heroScreenPos = {}
  for i, v in pairs(heroWorldPos) do
    local worldPos = v
    heroScreenPos[i] = PosConverse.WorldToScreenPos(worldPos, CS.UnityEngine.Camera.main)
  end
  self.slotPos = self.slotPos or {}
  for i = 1, #self.slotAreas do
    local slotArea = self.slotAreas[i]
    local screenPos = heroScreenPos[i]
    if not screenPos then
      slotArea:SetActive(false)
    else
      slotArea:SetActive(true)
      local localPos = PosConverse.ScreenToUIPos(self.slotAreasContainer.rectTransform, screenPos)
      slotArea.transform:Set_localPosition(localPos.x, localPos.y, 0)
      if not self.slotPos[i] then
        self.slotPos[i] = {
          x = localPos.x,
          y = localPos.y
        }
      else
        self.slotPos[i].x = localPos.x
        self.slotPos[i].y = localPos.y
      end
    end
  end
  self.heroInfoBarsPos = self.heroInfoBarsPos or {}
  for i = 1, #self.heroInfoBars do
    local heroInfoBar = self.heroInfoBars[i]
    if not heroScreenPos[i] then
      heroInfoBar:SetActive(false)
    else
      local screenPos = heroScreenPos[i]
      screenPos.y = screenPos.y + 100 * self.screenHeight / 1440
      local localPos = PosConverse.ScreenToUIPos(self.heroInfoBarContainer.rectTransform, screenPos)
      heroInfoBar.transform:Set_localPosition(localPos.x, localPos.y, 0)
      if not self.heroInfoBarsPos[i] then
        self.heroInfoBarsPos[i] = {
          x = localPos.x,
          y = localPos.y
        }
      else
        self.heroInfoBarsPos[i].x = localPos.x
        self.heroInfoBarsPos[i].y = localPos.y
      end
    end
  end
  local enemyWorldPos = logic:GetEnemyMemberPosition()
  local enemyScreenPos = {}
  for i = 1, #enemyWorldPos do
    local worldPos = enemyWorldPos[i] or Vector3.zero
    enemyScreenPos[i] = PosConverse.WorldToScreenPos(worldPos, CS.UnityEngine.Camera.main)
  end
  self.heroInfo2BarsPos = self.heroInfo2BarsPos or {}
  for i = 1, #self.heroInfo2Bars do
    local heroInfoBar = self.heroInfo2Bars[i]
    if not enemyScreenPos[i] then
      heroInfoBar:SetActive(false)
    else
      local screenPos = enemyScreenPos[i]
      screenPos.y = screenPos.y + 100 * self.screenHeight / 1440
      local localPos = PosConverse.ScreenToUIPos(self.heroInfo2BarContainer.rectTransform, screenPos)
      heroInfoBar.transform:Set_localPosition(localPos.x, localPos.y, 0)
      if not self.heroInfo2BarsPos[i] then
        self.heroInfo2BarsPos[i] = {
          x = localPos.x,
          y = localPos.y
        }
      else
        self.heroInfo2BarsPos[i].x = localPos.x
        self.heroInfo2BarsPos[i].y = localPos.y
      end
    end
  end
  self.curHeroPos = heroWorldPos
  self.curEnemyPos = enemyWorldPos
end

function UIHeroFakePVPFormationPanelView:OnDominatorStateUpdate()
  self:ResetUIComps()
end

function UIHeroFakePVPFormationPanelView:RefreshFormationPositionType()
  self.formationPositionType = ArmyFormationPositionType.Normal
  if self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure and self.jeepAdventurePageType == JeepAdventurePageType.Domintor and self.cfgId then
    local dominatorUpTemplate = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(self.cfgId)
    if dominatorUpTemplate then
      self.formationPositionType = dominatorUpTemplate:GetFormationPositionType()
    end
  end
  if self.formationPositionType == ArmyFormationPositionType.DominatorAndHero345 then
    self.formationPositionTypeText:SetActive(true)
    self.formationPositionTypeText:SetLocalText("dominator_pve_dec_3")
  elseif self.formationPositionType == ArmyFormationPositionType.OnlyDominator then
    self.formationPositionTypeText:SetActive(true)
    self.formationPositionTypeText:SetLocalText("dominator_pve_dec_4")
  else
    self.formationPositionTypeText:SetActive(false)
  end
end

function UIHeroFakePVPFormationPanelView:OnClickTacticalWeaponBtn()
  if self.weaponData then
    local selfEquips = DataCenter.TacticalWeaponManager:GetAllSelfWearingEquips()
    local skinId = DataCenter.TacticalWeaponManager:GetWeaponSkinId()
    local skillChips
    local useSetId = self.squadData:GetLocalTWSkillChipSetId()
    if useSetId ~= nil and 0 < useSetId then
      skillChips = DataCenter.TWSkillChipManager:GetChipsInfoByMasterSet(useSetId)
    end
    local power = DataCenter.TacticalWeaponManager:GetWeaponTotalPower()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.weaponData, selfEquips, self.weaponBtn, skinId, skillChips, power)
  end
end

UIHeroFakePVPFormationPanelView.OnCreate = OnCreate
UIHeroFakePVPFormationPanelView.OnDestroy = OnDestroy
UIHeroFakePVPFormationPanelView.OnEnable = OnEnable
UIHeroFakePVPFormationPanelView.OnDisable = OnDisable
UIHeroFakePVPFormationPanelView.UpdateView = UpdateView
UIHeroFakePVPFormationPanelView.OnAddListener = OnAddListener
UIHeroFakePVPFormationPanelView.OnRemoveListener = OnRemoveListener
UIHeroFakePVPFormationPanelView.ComponentDefine = ComponentDefine
UIHeroFakePVPFormationPanelView.DataDefine = DataDefine
UIHeroFakePVPFormationPanelView.ComponentDestroy = ComponentDestroy
UIHeroFakePVPFormationPanelView.DataDestroy = DataDestroy
UIHeroFakePVPFormationPanelView.OnOpen = OnOpen
UIHeroFakePVPFormationPanelView.RefreshSquadData = RefreshSquadData
UIHeroFakePVPFormationPanelView.RefreshHeroInfo = RefreshHeroInfo
UIHeroFakePVPFormationPanelView.OnSetHero = OnSetHero
UIHeroFakePVPFormationPanelView.ClosePanel = ClosePanel
UIHeroFakePVPFormationPanelView.OnSelectTypeToggle = OnSelectTypeToggle
UIHeroFakePVPFormationPanelView.OnChangeTypeToggle = OnChangeTypeToggle
UIHeroFakePVPFormationPanelView.OnClickHeroCell = OnClickHeroCell
UIHeroFakePVPFormationPanelView.TakeDownHero = TakeDownHero
UIHeroFakePVPFormationPanelView.ResetDragAreaPos = ResetDragAreaPos
UIHeroFakePVPFormationPanelView.TryGuideClickHeroInList = TryGuideClickHeroInList
UIHeroFakePVPFormationPanelView.GuideSwitchHeros = GuideSwitchHeros
UIHeroFakePVPFormationPanelView.RefreshFormationBuff = RefreshFormationBuff
UIHeroFakePVPFormationPanelView.SetBuffViewActive = SetBuffViewActive
UIHeroFakePVPFormationPanelView.RefreshHeroFakeInfo = RefreshHeroFakeInfo
UIHeroFakePVPFormationPanelView.RefreshPVPArenaChooseSquad = RefreshPVPArenaChooseSquad
UIHeroFakePVPFormationPanelView.OnArena3V3BattleFinish = OnArena3V3BattleFinish
UIHeroFakePVPFormationPanelView.OnSwitchTeam = OnSwitchTeam
UIHeroFakePVPFormationPanelView.OnEnemyTruckWeaponDataArrive = OnEnemyTruckWeaponDataArrive
UIHeroFakePVPFormationPanelView.RefreshWeaponInfo = RefreshWeaponInfo
UIHeroFakePVPFormationPanelView.ClearSound = ClearSound
UIHeroFakePVPFormationPanelView.OnClickSquadChooseBtn = OnClickSquadChooseBtn
UIHeroFakePVPFormationPanelView.PutOnHeroDirectly = PutOnHeroDirectly
UIHeroFakePVPFormationPanelView.TakeDownTruckAttackHero = TakeDownTruckAttackHero
UIHeroFakePVPFormationPanelView.OnUpdateArmyFormationList = OnUpdateArmyFormationList
UIHeroFakePVPFormationPanelView.OnClickSkillChipSet = OnClickSkillChipSet
UIHeroFakePVPFormationPanelView.OnTWSkillChipUpdate = OnTWSkillChipUpdate
UIHeroFakePVPFormationPanelView.OnGetOtherPlayerWeaponInfo = OnGetOtherPlayerWeaponInfo
UIHeroFakePVPFormationPanelView.IsNormalArena = IsNormalArena
UIHeroFakePVPFormationPanelView.IsShowQuickBtn = IsShowQuickBtn
UIHeroFakePVPFormationPanelView.RefreshQuickBtn = RefreshQuickBtn
UIHeroFakePVPFormationPanelView.OnQuickBtnClick = OnQuickBtnClick
UIHeroFakePVPFormationPanelView.AutoFillArmyFormation = AutoFillArmyFormation
UIHeroFakePVPFormationPanelView.GetEnemyFormation = GetEnemyFormation
UIHeroFakePVPFormationPanelView.GetHeroList = GetHeroList
UIHeroFakePVPFormationPanelView.RefreshTWSkillChipBtn = RefreshTWSkillChipBtn
UIHeroFakePVPFormationPanelView.RefreshArena3V3Container = RefreshArena3V3Container
UIHeroFakePVPFormationPanelView.RefreshTrailTowerContainer = RefreshTrailTowerContainer
UIHeroFakePVPFormationPanelView.OnBattleBtnClick = OnBattleBtnClick
return UIHeroFakePVPFormationPanelView
