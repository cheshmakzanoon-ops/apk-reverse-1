local UIHeroPVPFormationPanelView = BaseClass("UIHeroPVPFormationPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local HeroSquadModelViewer = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.HeroSquadModelViewer")
local UIHeroPVPFormationPanelHeroCellShell = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroPVPFormationPanelHeroCellShell")
local UIHeroInfoBar = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroInfoBar")
local FormationBuffView = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.FormationBuffView")
local ChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseSquadPopup")
local Arena3V3ChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.Arena3V3ChooseSquadPopup")
local TruckChooseSquadPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.TruckChooseSquadPopup")
local UIHeroPVPArena3V3Container = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroPVPArena3V3Container")
local SquadPlanBtnItem = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.SquadPlanBtnItem")
local ChooseTWSkillChipSetPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseTWSkillChipSetPopup")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local ChooseDominator = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseDominator")
local UIHeroPVPFormationSelectPanel = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroPVPFormationSelectPanel")
local bottomBarPath = "Root/BottomBar"
local heroScrollPath = "Root/BottomBar/HeroList"
local heroListPath = "Root/BottomBar/HeroList/Content"
local saveBtnPath = "Root/BottomBar/SaveBtn"
local saveBtnTextPath = "Root/BottomBar/SaveBtn/SaveBtnText"
local quickBtnPath = "Root/BottomBar/QuickBtn"
local backBtnPath = "Root/BottomBar/BtnBack"
local heroBtnPath = "Root/BottomBar/BtnHero"
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
local formationRtPath = "Root/MiddleContentContainer/FormationContent/FormationRT"
local powerInfoPath = "Root/MiddleContentContainer/PowerInfo"
local powerInfoTextPath = "Root/MiddleContentContainer/PowerInfo/PowerNumberText"
local slotAreaContainerPath = "Root/MiddleContentContainer/FormationContent/SlotAreas"
local slotAreaPath = "Root/MiddleContentContainer/FormationContent/SlotAreas/Slot%dArea"
local heroInfoBarContainerPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars"
local heroInfoBarPath = "Root/MiddleContentContainer/FormationContent/HeroInfoBars/Slot%dHeroInfoBar"
local heroListTipTextPath = "Root/BottomBar/HeroListTipText"
local glowEffectPath = "Root/MiddleContentContainer/FormationContent/Eff_ui_bdmb_glow"
local shangZhenEffectPath = "Root/MiddleContentContainer/FormationContent/Eff_ui_bdmb_shangzhen%d"
local chooseSquadBtnPath = "Root/MiddleBar/LeftBottomContainer/btnChooseSquad"
local chooseSquadBtnTextPath = "Root/MiddleBar/LeftBottomContainer/btnChooseSquad/txtChooseSquad"
local chooseSquadPopupPath = "popupChooseSquad"
local arena3V3ChooseSquadBtnPath = "3V3PopupChooseSquad"
local truckChooseSquadBtnPath = "TruckPopupChooseSquad"
local arena3V3ContainerPath = "Root/MiddleBar/3V3DefenceContainer"
local squad_plan_content_path = "Root/MiddleBar/SquadPlanContent"
local plan_btn_path = "Root/MiddleBar/SquadPlanContent/Plan"
local tacticalWeaponBtnPath = "Root/MiddleBar/LeftBottomContainer/TacticalWeapon"
local tacticalWeaponLevelNumberTextPath = "Root/MiddleBar/LeftBottomContainer/TacticalWeapon/TacticalWeaponLevelNumberText"
local btn_choose_skill_chip_set_path = "Root/MiddleBar/LeftBottomContainer/btnChooseSkillChipSet"
local icon_choose_skill_chip_set_path = "Root/MiddleBar/LeftBottomContainer/btnChooseSkillChipSet/Icon"
local txt_choose_skill_chip_set_path = "Root/MiddleBar/LeftBottomContainer/btnChooseSkillChipSet/txtChooseSkillChipSet"
local popup_choose_skill_chip_set_path = "PopupChooseSkillChipSet"
local power_icon_path = "Root/MiddleContentContainer/PowerInfo/PowerIcon"
local left_bottom_container_path = "Root/MiddleBar/LeftBottomContainer"
local second_left_bottom_container_path = "Root/MiddleBar/SecondLeftBottomContainer"
local random_toggle_path = "Root/MiddleBar/RandomToggle"

local function ClearHeroScroll(self)
  self.heroScroll:RemoveComponents(UIHeroPVPFormationPanelHeroCellShell)
  self.heroList:DestroyChildNode()
end

local function ShowGlowEffectOn(self, index)
  self.glowEffect:SetActive(false)
  self.glowEffect.transform:SetParent(self.slotAreas[index].transform)
  self.glowEffect.transform.localPosition = Vector3.New(6.6, 5.7, 0)
  self.glowEffect:SetActive(true)
end

local function HideGlowEffect(self)
  self.glowEffect:SetActive(false)
  self.glowEffect.transform:SetParent(self.formationContent.transform)
end

local function HideAllShangZhenEffect(self)
  for i = 1, 5 do
    self.shangZhenEffects[i]:SetActive(false)
    self.shangZhenEffects[i].transform:SetParent(self.formationContent.transform)
  end
  if self.delayHide then
    self.delayHide:Stop()
    self.delayHide = nil
  end
end

local function ShowShangZhenEffectOn(self, indices)
  if table.IsNullOrEmpty(indices) then
    return
  end
  if self.delayHide then
    self.delayHide:Stop()
    self.delayHide = nil
  end
  for i = 1, 5 do
    if indices[i] then
      self.shangZhenEffects[i]:SetActive(false)
      self.shangZhenEffects[i].transform:SetParent(self.slotAreas[i].transform)
      self.shangZhenEffects[i].transform.localPosition = Vector3.New(9.7, 10, 0)
      self.shangZhenEffects[i]:SetActive(true)
      DataCenter.LWSoundManager:PlaySound(62249, false)
    else
      self.shangZhenEffects[i]:SetActive(false)
      self.shangZhenEffects[i].transform:SetParent(self.formationContent.transform)
    end
  end
  self.delayHide = TimerManager:GetInstance():DelayInvoke(function()
    HideAllShangZhenEffect(self)
  end, 1)
end

local function OnCreate(self)
  base.OnCreate(self)
  self.ctrl:SetView(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  HideGlowEffect(self)
  HideAllShangZhenEffect(self)
  self:ResetDragAreaPos(self)
  if self.formationRt then
    self.formationRt:ResetPositions()
  end
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
  if self.clickGuideDelayTimer then
    self.clickGuideDelayTimer:Stop()
    self.clickGuideDelayTimer = nil
  end
  self.hasShowHeroCellGuide = false
  ClearHeroScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearSound()
  base.OnDestroy(self)
end

local function CanEdit(self)
  if self.source == EnterHeroSquadPanelWay.Marching then
    return false
  end
  if self.squadData and not self.squadData:IsFree() then
    return false
  end
  if self.source == EnterHeroSquadPanelWay.HSRDeparture and self.squadData and self.squadData.index then
    local busyList = DataCenter.LWMyStationDataManager:GetBusyDefenceFormationIndexList()
    if busyList[self.squadData.index] then
      return false
    end
  end
  return true
end

function UIHeroPVPFormationPanelView:CheckCanEditWithTips()
  local canEdit = self:CanEdit()
  if not canEdit then
    if self.source == EnterHeroSquadPanelWay.HSRDeparture then
      UIUtil.ShowTipsId("server_train_formation_tips")
    else
      UIUtil.ShowTipsId(120209)
    end
  end
  return canEdit
end

local function OnBackBtnClick(self)
  if self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
    local isDiff = self.squadData:CheckLoacalRemoteDiff()
    if not isDiff then
      local tmpTb
      if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
        tmpTb = DataCenter.LW3V3Manager:GetDirtySelfDefTeams()
      elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
        tmpTb = DataCenter.LWKOFBattleManager:GetDirtySelfDefTeams()
      elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
        tmpTb = DataCenter.ChampionDuelManager:GetDirtySelfTeams()
      end
      isDiff = not table.IsNullOrEmpty(tmpTb)
    end
    if isDiff then
      local emptyTeamIndex
      if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
        emptyTeamIndex = DataCenter.LW3V3Manager:GetSelfEmptyDefTeam()
      elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
        emptyTeamIndex = DataCenter.LWKOFBattleManager:GetSelfEmptyDefTeam()
      elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
        emptyTeamIndex = DataCenter.ChampionDuelManager:GetSelfEmptyTeam()
      end
      UIUtil.ShowMessage(Localization:GetString(500215), 2, "500231", "500232", function()
        self:ClosePanel()
      end, function()
        if emptyTeamIndex ~= nil then
          UIUtil.ShowMessage(Localization:GetString(500214, emptyTeamIndex), 2, "500231", "500230", function()
            self:ClosePanel()
          end, function()
            self:ChangeSquadIndex(emptyTeamIndex)
          end, nil)
        else
          if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
            DataCenter.LW3V3Manager:SaveDefTeams()
          elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
            DataCenter.LWKOFBattleManager:SaveDefTeams()
          elseif self.source == EnterHeroSquadPanelWay.ChampionDuel and not self:ChampionDuelCheckAndSave() then
            return
          end
          self:ClosePanel()
        end
      end, nil)
    else
      self:ClosePanel()
    end
  elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
    self:ClosePanel()
  elseif self.source == EnterHeroSquadPanelWay.ExpiredMonthlyCard then
    self:CheckOpenExpiredMonthlyCardTips()
  else
    self:OnSaveBtnClick(false)
  end
end

local function OnHeroBtnClick(self)
  self:ClosePanel()
  GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

local function OnSaveBtnClick(self, isTrueClick, noClose)
  if self.squadData then
    local heroes = self.squadData:GetLocalAllHeroes()
    local dominatorUuid = self.squadData:GetLocalDominatorUuid()
    if table.IsNullOrEmpty(heroes) and not string.IsNullOrEmpty(dominatorUuid) then
      UIUtil.ShowTipsId("dominator_squad_empty_warning")
      return
    end
    local isDiff = self.squadData:CheckLoacalRemoteDiff()
    if not isDiff then
      if self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
        local curBuffId = self.ctrl:GetSquadBuffId()
        local remoteBuffId = self.ctrl:GetRemoteSquadBuffId()
        isDiff = curBuffId ~= remoteBuffId
      elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
        isDiff = not table.IsNullOrEmpty(DataCenter.LW3V3Manager:GetDirtySelfDefTeams())
      elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
        isDiff = not table.IsNullOrEmpty(DataCenter.LWKOFBattleManager:GetDirtySelfDefTeams())
      elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
        isDiff = not table.IsNullOrEmpty(DataCenter.ChampionDuelManager:GetDirtySelfTeams())
      end
    end
    local squadIndex = self.ctrl:GetSquadIndex()
    local squadBuffId = self.ctrl:GetSquadBuffId()
    if isDiff then
      local curHeroes = self.squadData:GenerateServerHeroArray()
      local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
      local saveType = 1
      if self.source == EnterHeroSquadPanelWay.Gate then
        SFSNetwork.SendMessage(MsgDefines.DefenseInfoSave, self.squadData.uuid, curHeroes)
      elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
        DataCenter.LWMyStationDataManager:TrySaveAllTruckFormation(false)
        DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = squadIndex
      elseif self.source == EnterHeroSquadPanelWay.PVPArenaDefence then
        SFSNetwork.SendMessage(MsgDefines.SavePVPArenaDefence, curHeroes, squadBuffId, curChipSetId)
        UIUtil.ShowTipsId(300056)
      elseif self.source == EnterHeroSquadPanelWay.ActivityArenaDefence then
        SFSNetwork.SendMessage(MsgDefines.ActivityArenaSave, curHeroes, squadBuffId, self.activityId, curChipSetId)
        UIUtil.ShowTipsId(300056)
      elseif self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence then
        if table.IsNullOrEmpty(curHeroes) then
          UIUtil.ShowTipsId("new_arena_tips001")
        else
          SFSNetwork.SendMessage(MsgDefines.ActivityArenaV2Save, curHeroes, squadBuffId, self.activityId, curChipSetId)
          UIUtil.ShowTipsId(300056)
        end
      elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
        local emptyTeamIndex
        if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
          emptyTeamIndex = DataCenter.LW3V3Manager:GetSelfEmptyDefTeam()
        elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
          emptyTeamIndex = DataCenter.LWKOFBattleManager:GetSelfEmptyDefTeam()
        elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
          emptyTeamIndex = DataCenter.ChampionDuelManager:GetSelfEmptyTeam()
        end
        if emptyTeamIndex ~= nil then
          UIUtil.ShowMessage(Localization:GetString(500214, emptyTeamIndex), 1, "500230", nil, function()
            self:ChangeSquadIndex(emptyTeamIndex)
          end)
        elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
          DataCenter.LW3V3Manager:SaveDefTeams()
        elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
          DataCenter.LWKOFBattleManager:SaveDefTeams()
        elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
          self:ChampionDuelCheckAndSave()
        end
        return
      elseif self.source < EnterHeroSquadPanelWay.PVE then
        SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, self.squadData.uuid, curHeroes, saveType, curChipSetId)
      elseif self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence then
        SFSNetwork.SendMessage(MsgDefines.NewArenaSave, curHeroes, squadBuffId, curChipSetId)
        UIUtil.ShowTipsId(300056)
      elseif self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
        SFSNetwork.SendMessage(MsgDefines.GaleArenaSave, curHeroes, squadBuffId, curChipSetId)
        UIUtil.ShowTipsId(300056)
      end
    elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
      UIUtil.ShowTipsId(801154)
      return
    elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
      UIUtil.ShowTipsId(801154)
      return
    elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
      if self:ChampionDuelCheckAndSave(true) then
        UIUtil.ShowTipsId(801154)
      end
      return
    elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
      DataCenter.LWMyStationDataManager.curDefenceSquadIndexInView = squadIndex
    end
  end
  if not noClose then
    self:ClosePanel()
  end
end

local function OnQuickBtnClick(self)
  if not self.squadData then
    return
  end
  if self.quickBtn == nil or not self.quickBtn:GetActive() then
    return
  end
  local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.squadData.uuid)
  if not squadData then
    self.quickBtn:SetActive(false)
    return
  end
  if DataCenter.HeroDataManager:AutoFillArmyFormation(squadData, 1) > 0 then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
  else
    self.quickBtn:SetActive(false)
  end
end

local function IsShowQuickBtn(self)
  local quickSquadCtrl = LuaEntry.DataConfig:TryGetNum("newbies_herosquad_control", "k1", 0)
  if quickSquadCtrl ~= 1 then
    return false
  end
  if self.source ~= EnterHeroSquadPanelWay.ParkingLotBuilding and self.source ~= EnterHeroSquadPanelWay.ToMarch then
    return false
  end
  if not self.squadData then
    return false
  end
  local maxLevel = LuaEntry.DataConfig:TryGetNum("auto_arrangement", "k1", 0)
  if maxLevel == nil or maxLevel == 0 or maxLevel < DataCenter.BuildManager.MainLv then
    return false
  end
  local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.squadData.uuid)
  if not squadData then
    return false
  end
  local emptySlot = squadData:GetEmptySlotIndex()
  if emptySlot ~= nil then
    local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
    for uuid, _ in pairs(heroDataList) do
      local squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(uuid)
      if squadIndex == nil then
        return true
      end
    end
  end
  return false
end

local function RefreshQuickBtn(self)
  self.quickBtn:SetActive(self:IsShowQuickBtn())
end

local function ChampionDuelCheckBeastHero(self, heroUuid)
  if self.source ~= EnterHeroSquadPanelWay.ChampionDuel then
    return true
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  local heroLevelLimit = DataCenter.BuildManager.MainLv * DataCenter.HeroParamDataManager.heroLevelLimitByCityLevel
  if heroData ~= nil and heroLevelLimit <= heroData.level then
    return true
  end
  if self.CD_HeroLvList == nil then
    self.CD_HeroLvList = DataCenter.HeroDataManager:GetHeroSortList()
  end
  if self.CD_K4 == nil then
    self.CD_K4 = LuaEntry.DataConfig:TryGetNum("lw_champion_duel", "k4", 20)
  end
  local heroDataList = self.CD_HeroLvList or {}
  local checkNum = self.CD_K4 or 20
  for i = 1, checkNum do
    local hero = heroDataList[i]
    if hero and hero.uuid == heroUuid then
      return true
    end
  end
  return false
end

local function ChampionDuelCheckAndSave(self, onlyCheck)
  local canUseT4 = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  if not canUseT4 then
    for i = 1, 3 do
      local teamInfo = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(i)
      if teamInfo and teamInfo.localSquadNo == 4 then
        local str = Localization:GetString("champion_duel_tips1171", i)
        UIUtil.ShowTips(str)
        return false
      end
    end
  end
  local dirtyTeams = DataCenter.ChampionDuelManager:GetDirtySelfTeams()
  if table.IsNullOrEmpty(dirtyTeams) then
    return false
  end
  local haveFree = false
  for _, v in pairs(self.heroDataList) do
    if v.squadIndex == nil or v.squadIndex == 0 then
      haveFree = true
      break
    end
  end
  if haveFree then
    local notBeastUuids = {}
    local haveEmpty = false
    for _, team in pairs(dirtyTeams) do
      if team:GetEmptySlotIndex() then
        haveEmpty = true
      end
      for uuid, _ in pairs(team.localHeroes) do
        local have = self:ChampionDuelCheckBeastHero(uuid)
        if not have then
          table.insert(notBeastUuids, uuid)
        end
      end
    end
    if 0 < #notBeastUuids or haveEmpty then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionDuelFormationTips, {anim = true}, haveEmpty, notBeastUuids, self)
      return false
    end
  end
  if not onlyCheck then
    DataCenter.ChampionDuelManager:SendSaveTeam()
  end
  return true
end

local function TryDepartureTrain(self)
  local trainUuid = self.paramData.trainUuid
  EventManager:GetInstance():Broadcast(EventId.GF_click_departure_btn)
  DataCenter.LWMyStationDataManager:TryDepartureTrain(trainUuid, self.squadData)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrainDeparture)
end

local function TryTakeDownHeroAtIndex(self, index)
  local canEdit = self:CheckCanEditWithTips()
  if not canEdit then
    return
  end
  if self.squadData then
    local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
    if heroUuid then
      local squadIndex = self.ctrl:GetSquadIndex()
      self:TakeDownHero(squadIndex, heroUuid)
    end
  end
end

local function OnBeginDragHeroSlot(self, eventData, index)
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
  for k, v in pairs(self.slotAreas) do
    v.transform.localPosition = self.slotPos[k]
  end
  for k, v in pairs(self.heroInfoBars) do
    v.transform:SetParent(self.heroInfoBarContainer.transform)
    v.transform.localPosition = self.heroInfoBarsPos[k]
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
    self.formationRt:ResetPositions()
    if self.toSwitchIndex then
      local canEdit = self:CheckCanEditWithTips()
      if canEdit then
        SwitchHeroSlot(self, self.dragingIndex, self.toSwitchIndex)
      end
      self:RefreshHeroInfo()
    end
    self.isInDragMode = false
    self.dragingIndex = nil
    self.toSwitchIndex = nil
    self.lastDragPosX = nil
    self.lastDragPosY = nil
    HideGlowEffect(self)
  end
end

local function OnDragHeroSlot(self, eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    local curPosX = eventData.position.x
    local curPosY = eventData.position.y
    local offsetX = (curPosX - self.lastDragPosX) / self.uiScaleFactor
    local offsetY = (curPosY - self.lastDragPosY) / self.uiScaleFactor
    self.lastDragPosX = curPosX
    self.lastDragPosY = curPosY
    local curPos = self.slotAreas[index].transform.localPosition
    self.slotAreas[index].transform.localPosition = Vector3.New(curPos.x + offsetX, curPos.y + offsetY, curPos.z)
    local areaCenterPos = PosConverse.UIWorldToScreenPos(self.slotAreas[index].transform.position)
    local pos = Vector2.New(areaCenterPos.x, areaCenterPos.y)
    local rtScreenPos = pos - self.formationRtOrigin
    rtScreenPos.x = rtScreenPos.x / self.formationRtScale.x
    rtScreenPos.y = rtScreenPos.y / self.formationRtScale.y
    if rtScreenPos.x < -8 or rtScreenPos.x > self.formationRtRealSize + 8 then
      OnDragEndHeroSlot(self, eventData, self.dragingIndex)
      return
    end
    if rtScreenPos.y < -8 or rtScreenPos.y > self.formationRtRealSize + 8 then
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
  self.heroInfoBars[self.toSwitchIndex].transform.localPosition = self.heroInfoBarsPos[self.dragingIndex]
  ShowGlowEffectOn(self, self.toSwitchIndex)
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
  self.heroInfoBars[self.toSwitchIndex].transform.localPosition = self.heroInfoBarsPos[self.toSwitchIndex]
  HideGlowEffect(self)
  self.toSwitchIndex = nil
end

local function ComponentDefine(self)
  self.bottomBar = self:AddComponent(UIBaseContainer, bottomBarPath)
  self.heroList = self:AddComponent(GridInfinityScrollView, heroListPath)
  self.heroScroll = self:AddComponent(UIBaseContainer, heroScrollPath)
  self.saveBtn = self:AddComponent(UIButton, saveBtnPath)
  self.saveBtn:SetOnClick(function()
    OnSaveBtnClick(self, true)
  end)
  self.saveBtnText = self:AddComponent(UIText, saveBtnTextPath)
  self.quickBtn = self:AddComponent(UIButton, quickBtnPath)
  self.quickBtn:SetOnClick(function()
    self:OnQuickBtnClick()
  end)
  self.backBtn = self:AddComponent(UIButton, backBtnPath)
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.heroBtn = self:AddComponent(UIButton, heroBtnPath)
  self.heroBtn:SetOnClick(function()
    self:OnHeroBtnClick()
  end)
  local isHeroBtnShow = BattleFieldUtil.InBattleField()
  self.heroBtn:SetActive(isHeroBtnShow)
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
  self.formationBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/FormationContent/formationBtn")
  self.formationBuffIcon = self:AddComponent(UIImage, "Root/MiddleContentContainer/FormationContent/formationBtn/infoImage")
  self.firmationBufflView = self:AddComponent(FormationBuffView, "Root/buffInfo")
  self.buffCom = self:AddComponent(UIBaseComponent, "Root/buffInfo")
  self.buffViewCloseBtn = self:AddComponent(UIButton, "Root/buffInfo/closeBtn")
  self.buffViewCloseBtn:SetOnClick(function()
    self:SetBuffViewActive()
  end)
  self.formationBtn:SetOnClick(function()
    self:SetBuffViewActive()
  end)
  self.airForceTypeToggleIcon = self:AddComponent(UIImage, airForceTypeToggleIconPath)
  self.middleContentContainer = self:AddComponent(UIBaseContainer, middleContentContainerPath)
  self.formationContent = self:AddComponent(UIBaseContainer, formationContentPath)
  self.formationBg = self:AddComponent(UIRawImage, formationBgPath)
  self.formationRt = self:AddComponent(HeroSquadModelViewer, formationRtPath)
  self.uiScaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.formationRtOrigin = PosConverse.UIWorldToScreenPos(self.formationRt.transform.position)
  self.formationRtRealSize = self.formationRt.rtSize
  self.formationRtScale = Vector2.New(self.formationRt:GetSizeDelta().x * self.uiScaleFactor / self.formationRt.rtSize, self.formationRt:GetSizeDelta().y * self.uiScaleFactor / self.formationRtRealSize)
  self.powerInfo = self:AddComponent(UIBaseContainer, powerInfoPath)
  self.powerInfoText = self:AddComponent(UIText, powerInfoTextPath)
  self.power_info_btn = self:AddComponent(UIButton, powerInfoPath)
  self.power_icon = self:AddComponent(UIImage, power_icon_path)
  self.power_info_btn:SetOnClick(function()
    self:ShowPowerInfo()
  end)
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
      OnBeginDragHeroSlot(self, eventData, i)
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
    local slotPos = slotArea.transform.localPosition
    table.insert(self.slotPos, slotPos)
  end
  self.heroInfoBarContainer = self:AddComponent(UIBaseContainer, heroInfoBarContainerPath)
  self.heroInfoBars = {}
  self.heroInfoBarsPos = {}
  for i = 1, 5 do
    local heroInfoBar = self:AddComponent(UIHeroInfoBar, string.format(heroInfoBarPath, i))
    table.insert(self.heroInfoBars, heroInfoBar)
    local heroInfoBarPos = heroInfoBar.transform.localPosition
    table.insert(self.heroInfoBarsPos, heroInfoBarPos)
  end
  self.heroListTipText = self:AddComponent(UIText, heroListTipTextPath)
  self.glowEffect = self:AddComponent(UIBaseContainer, glowEffectPath)
  self.glowEffect:SetActive(false)
  self.shangZhenEffects = {}
  for i = 1, 5 do
    local shangZhenEffect = self:AddComponent(UIBaseContainer, string.format(shangZhenEffectPath, i))
    shangZhenEffect:SetActive(false)
    table.insert(self.shangZhenEffects, shangZhenEffect)
  end
  self.chooseSquadBtn = self:AddComponent(UIButton, chooseSquadBtnPath)
  self.chooseSquadBtn:SetOnClick(function()
    local position = self.chooseSquadBtn.transform.position
    local x = position.x + 40
    local y = position.y
    if self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
      self.chooseSquadPopup:SetPosition(x, y)
      self.chooseSquadPopup:Popup(self.ctrl:GetSquadBuffId(), function(idx)
        self.ctrl:SetSquadBuffId(idx)
        self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", idx))
        self.chooseSquadBtnText:SetText("T" .. idx)
        self:RefreshHeroInfo()
      end)
    elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
      self.truckChooseSquadPopup:SetPosition(x, y)
      self.truckChooseSquadPopup:Popup(self.ctrl:GetSquadIndex())
    elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
      self.arena3V3ChooseSquadPopup:SetPosition(x, y)
      self.arena3V3ChooseSquadPopup:Popup(self.ctrl:GetSquadIndex(), self.source)
    end
  end)
  self.chooseSquadBtnText = self:AddComponent(UIText, chooseSquadBtnTextPath)
  self.chooseSquadPopup = self:AddComponent(ChooseSquadPopup, chooseSquadPopupPath, false)
  self.chooseSquadPopup:SetActive(false)
  self.arena3V3ChooseSquadPopup = self:AddComponent(Arena3V3ChooseSquadPopup, arena3V3ChooseSquadBtnPath)
  self.arena3V3ChooseSquadPopup:SetActive(false)
  self.arena3V3ChooseSquadPopup:SetIsDef(true)
  self.truckChooseSquadPopup = self:AddComponent(TruckChooseSquadPopup, truckChooseSquadBtnPath)
  self.truckChooseSquadPopup:SetActive(false)
  self.truckChooseSquadPopup:SetIsDef(true)
  self.arena3V3Container = self:AddComponent(UIHeroPVPArena3V3Container, arena3V3ContainerPath)
  self.weaponBtn = self:AddComponent(UIButton, tacticalWeaponBtnPath)
  self.weaponBtn:SetOnClick(function()
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
  end)
  self.weaponLevelNumberText = self:AddComponent(UIText, tacticalWeaponLevelNumberTextPath)
  self.squad_plan_content = self:AddComponent(UIImage, squad_plan_content_path)
  self.squad_plan_btn_list = {}
  for i = 1, 4 do
    local btnItem = self:AddComponent(SquadPlanBtnItem, plan_btn_path .. i)
    table.insert(self.squad_plan_btn_list, btnItem)
  end
  self.squad_plan_content:SetActive(false)
  self.chooseSkillChipSetBtn = self:AddComponent(UIButton, btn_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtn:SetOnClick(function()
    if self.squadData then
      local position = self.chooseSkillChipSetBtn.transform.position
      local x = position.x + 40
      local y = position.y - 20
      local dataType = self.source
      self.chooseTWSkillChipSetPopup:SetPosition(x, y)
      self.chooseTWSkillChipSetPopup:Popup(function(idx)
        self:OnClickSkillChipSet(idx)
      end, self.squadData, dataType)
    end
  end)
  self.chooseSkillChipSetBtnText = self:AddComponent(UIText, txt_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtnIcon = self:AddComponent(UIImage, icon_choose_skill_chip_set_path)
  self.chooseTWSkillChipSetPopup = self:AddComponent(ChooseTWSkillChipSetPopup, popup_choose_skill_chip_set_path)
  self.btn_containers = self:AddComponent(UIBaseContainer, left_bottom_container_path)
  self.second_btn_containers = self:AddComponent(UIBaseContainer, second_left_bottom_container_path)
  self.chooseDominator = self:AddComponent(ChooseDominator, second_left_bottom_container_path, self.second_btn_containers, self)
  self.chooseDominator:Refresh()
  self.selectPanel = self:AddComponent(UIHeroPVPFormationSelectPanel, random_toggle_path)
  self.selectPanel:SetActive(false)
end

local function SetBuffViewActive(self)
  local isOn = self.buffCom:GetActive()
  if not isOn then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
  self.buffCom:SetActive(not isOn)
end

local function DataDefine(self)
  self.heroListGO = {}
  self.heroItems = {}
  self.hasInitHeroList = false
  self.heroType = nil
  self.cachedHeroUuids = {}
  self.prevHeroes = nil
  self.hasAddListener = false
end

local function ComponentDestroy(self)
  self.bottomBar = nil
  self.heroList = nil
  self.heroScroll = nil
  self.saveBtn = nil
  self.saveBtnText = nil
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
  self.formationBg = nil
  self.formationRt = nil
  self.powerInfo = nil
  self.powerInfoText = nil
  self.power_icon = nil
  self.power_info_btn = nil
  self.slotAreasContainer = nil
  self.slotAreas = nil
  self.slotPos = nil
  self.heroInfoBarContainer = nil
  self.heroInfoBars = nil
  self.heroInfoBarsPos = nil
  self.heroListTipText = nil
  self.chooseSquadBtn = nil
  self.chooseSquadBtnText = nil
  self.chooseSquadPopup = nil
  self.arena3V3ChooseSquadPopup = nil
  self.truckChooseSquadPopup = nil
  self.arena3V3Container = nil
  self.weaponBtn = nil
  self.weaponLevelNumberText = nil
  self.squad_plan_content = nil
end

local function DataDestroy(self)
  self.heroListGO = nil
  self.heroItems = nil
  self.hasInitHeroList = false
  self.heroType = nil
  self.cachedHeroUuids = nil
  self.prevHeroes = nil
  self.weaponData = nil
end

local function OnUpdateArmyFormationList(self)
  if self.squadData and ArmyFormationUtils.GetDataTypeByEnterWay(self.source) == FormationDataType.ArmyFormation then
    local squadUuid = self.squadData.uuid
    if squadUuid then
      local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(squadUuid)
      if squadData then
        squadData:SyncLocalData(self.squadData)
        self:RefreshSquadData()
      end
    end
  end
  for i, heroUuid in pairs(self.cachedHeroUuids) do
    local squadIndex
    if self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
      squadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroUuid(heroUuid)
    else
      squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroUuid)
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

local function OnCDOnFormationUpdate(self)
  if self.source == EnterHeroSquadPanelWay.ChampionDuel then
    local squadIndex = self.ctrl:GetSquadIndex()
    self.squadData = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(squadIndex)
    self.arena3V3Container:RefreshShow(squadIndex, self.source)
    self.chooseDominator:SetSquadData(self.squadData)
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
  self:AddUIListener(EventId.Arena3V3BuffChange, self.RefreshChooseSquadBtn)
  self:AddUIListener(EventId.TruckBuffChange, self.RefreshChooseSquadBtn)
  self:AddUIListener(EventId.Arena3V3SwitchDefTeamOrder, self.OnArena3V3SwitchDefTeam)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
  self:AddUIListener(EventId.ChampionDuelFormationRefresh, self.OnCDOnFormationUpdate)
  self:AddUIListener(EventId.DominatorFormationUpdate, OnDominatorUpdate)
  self:AddUIListener(EventId.KOFSwitchDefTeamOrder, self.OnKOFSwitchDefTeamOrder)
  self.hasAddListener = true
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.hasAddListener then
    self:RemoveUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
    self:RemoveUIListener(EventId.Arena3V3BuffChange, self.RefreshChooseSquadBtn)
    self:RemoveUIListener(EventId.TruckBuffChange, self.RefreshChooseSquadBtn)
    self:RemoveUIListener(EventId.Arena3V3SwitchDefTeamOrder, self.OnArena3V3SwitchDefTeam)
    self:RemoveUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
    self:RemoveUIListener(EventId.ChampionDuelFormationRefresh, self.OnCDOnFormationUpdate)
    self:RemoveUIListener(EventId.KOFSwitchDefTeamOrder, self.OnKOFSwitchDefTeamOrder)
    self:RemoveUIListener(EventId.DominatorFormationUpdate, OnDominatorUpdate)
    self.hasAddListener = false
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
  if self.squadData then
    self:RefreshHeroInfo()
    self:RefreshWeaponInfo()
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

function UIHeroPVPFormationPanelView:RefreshBuffViewContent()
  self.firmationBufflView:RefillContent()
end

local function RefreshChooseSquadBtn(self)
  if self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
    local buffIndex = self.ctrl:GetSquadBuffId()
    self.chooseSquadBtnText:SetText("T" .. buffIndex)
    self.chooseSquadBtn:SetActive(true)
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture or self.source == EnterHeroSquadPanelWay.ChampionDuel then
    if self.squadData.localSquadNo == nil or self.squadData.localSquadNo <= 0 then
      self.chooseSquadBtnText:SetText("")
    else
      self.chooseSquadBtnText:SetText("T" .. self.squadData.localSquadNo)
      self:RefreshHeroInfo()
    end
    self.chooseSquadBtn:SetActive(true)
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

local function OnOpen(self)
  self.source, self.paramData, self.activityId = self:GetUserData()
  self.source = self.source or EnterHeroSquadPanelWay.ParkingLotBuilding
  self.arena3V3Container:SetActive(self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel)
  self.ctrl:SetSource(self.source)
  self.saveBtn:SetActive(self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture)
  self.ctrl:SetSquadIndex(1)
  if self.source == EnterHeroSquadPanelWay.ParkingLotBuilding or self.source == EnterHeroSquadPanelWay.ExpiredMonthlyCard then
    local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByBuildingUuid(self.paramData)
    if squadData ~= nil then
      squadData:ResetLocalData()
      self.ctrl:SetSquadIndex(squadData.index)
      self:RefreshSquadData()
      self.squad_plan_content:SetActive(true)
      for k, v in ipairs(self.squad_plan_btn_list) do
        local data = {self = self, index = k}
        local bindFunc = BindCallback(data, self.OnClickSquadChooseBtn)
        v:SetData(self.source, k, squadData.index, bindFunc)
      end
    else
      self:ClosePanel()
      return
    end
    self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", squadData.index))
  elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
    self.saveBtnText:SetLocalText("500232")
    self.squad_plan_content:SetActive(true)
    local curDefenceIndex = self.paramData.curDefenceFormationIndex
    local squadData = DataCenter.LWMyStationDataManager:GetDefenceFormation(curDefenceIndex)
    if squadData ~= nil then
      self.squadData = squadData
      self.ctrl:SetSquadIndex(squadData.index)
      self.slotCount = 5
      for k, v in ipairs(self.squad_plan_btn_list) do
        local data = {self = self, index = k}
        local bindFunc = BindCallback(data, self.OnClickSquadChooseBtn)
        v:SetData(self.source, k, squadData.index, bindFunc)
      end
    else
      self:ClosePanel()
      return
    end
    self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", squadData.index))
  elseif self.source == EnterHeroSquadPanelWay.Gate then
    local squadData = DataCenter.ArmyFormationDataManager:GetDefenceFormation()
    if squadData ~= nil then
      squadData:ResetLocalData()
    end
    self:RefreshSquadData()
    self.formationBg:LoadSprite("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_defend.png")
  elseif self.source == EnterHeroSquadPanelWay.MainUI or self.source == EnterHeroSquadPanelWay.Marching or self.source == EnterHeroSquadPanelWay.ToMarch then
    local squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.paramData)
    if squadData ~= nil then
      self.ctrl:SetSquadIndex(squadData.index)
      squadData:ResetLocalData()
      self:RefreshSquadData()
    else
      self:ClosePanel()
      return
    end
    self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", squadData.index))
  elseif self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
    self.squadData = ArenaArmyFormationInfo.New()
    self.squadData:ParseData(self.paramData)
    self.slotCount = 5
    self.ctrl:SetSquadBuffId(self.paramData.squadNo)
    self.ctrl:SetRemoteSquadBuffId(self.paramData.squadNo)
    self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", self.paramData.squadNo))
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
    if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
      self.squadData = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(self.paramData)
    elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
      self.squadData = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(self.paramData)
    elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
      self.squadData = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(self.paramData)
    end
    self.slotCount = 5
    self.ctrl:SetSquadIndex(self.paramData)
    self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", self.paramData))
    self.arena3V3Container:RefreshShow(self.paramData, self.source)
  end
  self:RefreshChooseSquadBtn()
  local state = self.allTypeHeroToggle:GetIsOn()
  if state then
    self:OnChangeTypeToggle(HeroType.All)
  else
    self.allTypeHeroToggle:SetIsOn(true)
  end
  self:RefreshFormationBuffInfo()
  self:RefreshQuickBtn()
  self.firmationBufflView:ReInit(self.formationBuffInfo)
  self.chooseDominator:SetData(self.source, self.ctrl:GetSquadIndex(), self.squadData)
  self.chooseDominator:SetSquadData(self.squadData)
  self:RefreshSelectPanel()
end

local function RefreshSquadData(self)
  self.squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, self.ctrl:GetSquadIndex())
  if self.source == EnterHeroSquadPanelWay.Gate then
    self.slotCount = self.squadData.slots
  elseif self.source < EnterHeroSquadPanelWay.PVE then
    if self.squadData ~= nil then
      self.slotCount = self.squadData.slots
    end
  else
    self.slotCount = self.squadData.slots
  end
end

local function GetHeroList(self, heroType)
  local heroList = {}
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  local squadIndex = self.ctrl:GetSquadIndex()
  for uuid, heroData in pairs(heroDataList) do
    local displayData = {}
    if not (0 < heroType) or heroData.heroType == heroType then
      if self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
        displayData.squadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroId(heroData.heroId)
      elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
        displayData.squadIndex = DataCenter.LW3V3Manager:GetHeroInSelfDefTeamIndex(uuid)
      elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
        displayData.squadIndex = DataCenter.LWKOFBattleManager:GetHeroInSelfDefTeamIndex(uuid)
      elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
        displayData.squadIndex = DataCenter.ChampionDuelManager:GetHeroInSelfTeamOrder(uuid)
      elseif self.source ~= EnterHeroSquadPanelWay.Gate then
        displayData.squadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(uuid)
      else
        local inSquad = self.squadData:HasLocalHero(uuid)
        if inSquad then
          displayData.squadIndex = squadIndex
        end
      end
      displayData.heroData = heroData
      table.insert(heroList, displayData)
    end
  end
  table.sort(heroList, function(a, b)
    return a.heroData.power > b.heroData.power
  end)
  return heroList
end

local function OnInitHeroScroll(self, go, index)
  local item = self.heroScroll:AddComponent(UIHeroPVPFormationPanelHeroCellShell, go)
  self.heroListGO[go] = item
end

local function OnUpdateHeroScroll(self, go, index)
  go.transform:Set_localScale(1.16, 1.16, 1)
  local item = self.heroListGO[go]
  local heroSquadData = self.heroDataList[index + 1]
  local isInOtherFormation = false
  if heroSquadData.squadIndex then
    isInOtherFormation = heroSquadData.squadIndex ~= self.ctrl:GetSquadIndex()
  end
  if not self:ChampionDuelCheckBeastHero(heroSquadData.heroData.uuid) then
    heroSquadData.canUse = false
  end
  item:SetData(heroSquadData, isInOtherFormation and self.source ~= EnterHeroSquadPanelWay.PVPArenaDefence and self.source ~= EnterHeroSquadPanelWay.ActivityArenaDefence and self.source ~= EnterHeroSquadPanelWay.ActivityArenaV2Defence and self.source ~= EnterHeroSquadPanelWay.NewPeakArenaDefence and self.source ~= EnterHeroSquadPanelWay.NewGaleArenaDefence, index)
  local isSelected = false
  if self.squadData then
    isSelected = self.squadData:HasLocalHero(heroSquadData.heroData.uuid)
    item:SetSelected(isSelected)
  end
  item:SetCanvasGroupAlpha(heroSquadData ~= nil and 1 or 0)
  self.heroItems[heroSquadData.heroData.uuid] = item
  if not self.hasShowHeroCellGuide and self.showGuideHeroDataIndex ~= nil and 0 < self.showGuideHeroDataIndex and index == self.showGuideHeroDataIndex - 1 then
    self.hasShowHeroCellGuide = true
    self.showGuideHeroDataIndex = nil
    item:ShowGuide()
  end
end

local function ShowGuide(self, heroCell)
  self.clickGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:TryGuideClickHeroInList(heroCell)
  end, 0.85)
end

local function OnDestroyHeroScrollItem(self, go, index)
  local heroSquadData = self.heroDataList[index + 1]
  if heroSquadData and heroSquadData.heroData then
    self.heroItems[heroSquadData.heroData.uuid] = nil
  end
end

local function TakeDownHero(self, squadIndex, heroUuid)
  if squadIndex ~= self.ctrl:GetSquadIndex() then
    local otherSquad = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, squadIndex)
    if otherSquad then
      local index = otherSquad:GetLocalHeroIndex(heroUuid)
      otherSquad:SetLocalHero(index, nil)
      local curHeroes = otherSquad:GenerateServerHeroArray()
      SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, otherSquad.uuid, curHeroes, 0)
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

local function TakeDownTruckDepartureHero(self, squadIndex, heroUuid)
  if squadIndex ~= self.ctrl:GetSquadIndex() then
    local otherSquad = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(squadIndex)
    if otherSquad then
      local index = otherSquad:GetLocalHeroIndex(heroUuid)
      otherSquad:SetLocalHero(index, nil)
      DataCenter.LWMyStationDataManager:TrySaveTruckFormation(otherSquad)
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

function UIHeroPVPFormationPanelView:RefreshFormationBuffInfo()
  local heros = self.squadData:GetLocalAllHeroes()
  local type = self.formationBuffInfo and self.formationBuffInfo.type
  self.formationBuffInfo = HeroUtils.GetFormationBuffInfoList(heros)
  self.formationBuffInfo.heros = HeroUtils.SortFormationHeros(heros)
  if self.formationBuffInfo.type ~= type and self.formationBuffInfo.type ~= 0 then
    local isFormationBuffOpen = UIUtil.IsFormationBuffInfoOpen()
    if isFormationBuffOpen then
      UIUtil.PlayScaleAnim(self.formationBtn.rectTransform)
    end
  end
end

local function RefreshFormationBuff(self)
  self:RefreshFormationBuffInfo()
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

local function OnClickHeroCell(self, heroDisplayData, heroItem)
  if not heroDisplayData then
    return
  end
  local canEdit = self:CheckCanEditWithTips()
  if not canEdit then
    return
  end
  local heroUuid = heroDisplayData.heroData.uuid
  local squadPos = self.squadData:GetLocalHeroIndex(heroUuid)
  local isInSquad = squadPos ~= nil
  if isInSquad then
    self.squadData:SetLocalHero(squadPos, nil)
    heroDisplayData.squadIndex = nil
    heroItem:SetSelected(false)
    self:RefreshHeroInfo()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_quit_the_battle)
    return
  end
  if not self:ChampionDuelCheckBeastHero(heroUuid) then
    Logger.LogInfo("ChampionDuelCheckBeastHero not beast ==> ", heroUuid)
    UIUtil.ShowTipsId("champion_duel_tips1081")
    return
  end
  local isInOtherFormation = false
  local curSquadIndex = self.ctrl:GetSquadIndex()
  if self.source == EnterHeroSquadPanelWay.Gate or self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
  elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
    local inSquadIndex = DataCenter.LWMyStationDataManager:GetHeroTruckSquadIndexByHeroId(heroDisplayData.heroData.heroId)
    isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= curSquadIndex
  elseif self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
    local inSquadIndex = DataCenter.LW3V3Manager:GetHeroInSelfDefTeamIndex(heroUuid)
    isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= curSquadIndex
  elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
    local inSquadIndex = DataCenter.LWKOFBattleManager:GetHeroInSelfDefTeamIndex(heroUuid)
    isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= curSquadIndex
  elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
    local inSquadIndex = DataCenter.ChampionDuelManager:GetHeroInSelfTeamOrder(heroUuid)
    isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= curSquadIndex
  else
    local inSquadIndex = DataCenter.ArmyFormationDataManager:GetHeroSquadIndex(heroUuid)
    isInOtherFormation = inSquadIndex ~= nil and inSquadIndex ~= curSquadIndex
  end
  local index = self.squadData:GetEmptySlotIndex()
  local hasEmptySlot = index ~= nil
  if hasEmptySlot then
    if not isInOtherFormation then
      if (self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture) and DataCenter.LWMyStationDataManager:IsHeroBusyInDefenceFormation(heroUuid) then
        UIUtil.ShowTipsId(120211)
        return
      end
      heroDisplayData.squadIndex = curSquadIndex
      self.squadData:SetLocalHero(index, heroUuid)
      heroItem:SetSelected(true)
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
      return
    else
      if self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
        local otherSquad
        if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
          otherSquad = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(heroDisplayData.squadIndex)
        elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
          otherSquad = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(heroDisplayData.squadIndex)
        elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
          otherSquad = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(heroDisplayData.squadIndex)
        end
        if otherSquad then
          local heroName = heroDisplayData.heroData:GetName()
          local squadName = ""
          UIUtil.ShowMessage(Localization:GetString(500263, heroName, squadName), 1, "110006", nil, function()
            otherSquad:SetLocalHero(otherSquad:GetLocalHeroIndex(heroUuid), nil)
            self.squadData:SetLocalHero(index, heroUuid)
            self:RefreshHeroList(false)
            self:RefreshHeroInfo()
          end, nil, nil)
          return
        else
          UIUtil.ShowTipsId(120211)
        end
      elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
        local otherSquad = DataCenter.LWMyStationDataManager:GetDefenceFormationByIndex(heroDisplayData.squadIndex)
        local busyFormationList = DataCenter.LWMyStationDataManager:GetBusyDefenceFormationIndexList()
        if busyFormationList[otherSquad.index] == nil then
          if not ArmyFormationUtils.IsHeroCanTakeDown(otherSquad, heroUuid) then
            UIUtil.ShowTipsId("dominator_squad_empty_warning")
            return
          end
          local heroName = heroDisplayData.heroData:GetName()
          local squadName = DataCenter.BuildManager:GetBuildingNameByUuid(otherSquad.buildingUuid)
          UIUtil.ShowMessage(Localization:GetString(120212, heroName, squadName), 1, "110006", nil, function()
            TakeDownTruckDepartureHero(self, heroDisplayData.squadIndex, heroUuid)
          end, nil, nil)
          return
        else
          UIUtil.ShowTipsId(120211)
        end
      else
        local otherSquad = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, heroDisplayData.squadIndex)
        if not otherSquad:IsFree() then
          UIUtil.ShowTipsId(120211)
          return
        end
        if not ArmyFormationUtils.IsHeroCanTakeDown(otherSquad, heroUuid) then
          UIUtil.ShowTipsId("dominator_squad_empty_warning")
          return
        end
        local heroName = heroDisplayData.heroData:GetName()
        local squadName = DataCenter.BuildManager:GetBuildingNameByUuid(otherSquad.buildingUuid)
        UIUtil.ShowMessage(Localization:GetString(120212, heroName, squadName), 1, "110006", nil, function()
          TakeDownHero(self, heroDisplayData.squadIndex, heroUuid)
        end, nil, nil)
        return
      end
      return
    end
  else
    UIUtil.ShowTipsId(120210)
  end
end

local function ClearSound(self)
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
end

function UIHeroPVPFormationPanelView:CheckOpenExpiredMonthlyCardTips()
  if self.source == EnterHeroSquadPanelWay.ExpiredMonthlyCard then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("weekcard_squad_save_desc_5"), 1, "weekcard_squad_save_button_3", "", function()
      self:OnSaveBtnClick()
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
    end, nil, nil, "weekcard_squad_save_title_2")
  end
end

local function RefreshHeroList(self, moveToTopIfNoGuide)
  self.heroDataList = GetHeroList(self, self.heroType)
  local count = table.count(self.heroDataList)
  if 0 < count then
    self.heroScroll:SetActive(true)
    local moveIndex
    self.showGuideHeroDataIndex = 0
    if not self.hasShowHeroCellGuide then
      local firstCanSelectHeroDataIndex = self.ctrl:GetFirstCanSelectHeroDataForEmptySlotIndex(self.squadData, self.heroDataList)
      if firstCanSelectHeroDataIndex ~= nil and 0 < firstCanSelectHeroDataIndex then
        self.showGuideHeroDataIndex = firstCanSelectHeroDataIndex
        moveIndex = firstCanSelectHeroDataIndex - 1
      end
    end
    if not self.hasInitHeroList then
      local bindFunc1 = BindCallback(self, OnInitHeroScroll)
      local bindFunc2 = BindCallback(self, OnUpdateHeroScroll)
      local bindFunc3 = BindCallback(self, OnDestroyHeroScrollItem)
      self.heroList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitHeroList = true
    self.heroList:SetItemCount(count)
    if moveIndex ~= nil then
      self.heroList:MoveItemByIndex(moveIndex)
    elseif moveToTopIfNoGuide then
      self.heroList:MoveItemByIndex(0)
    else
      self.heroList:ForceUpdate()
    end
    self.heroListTipText:SetActive(false)
  else
    self.heroScroll:SetActive(false)
    self.heroListTipText:SetActive(true)
  end
end

local function OnSelectTypeToggle(self)
  RefreshHeroList(self, true)
end

local function OnChangeTypeToggle(self, heroType)
  if self.heroType == heroType then
    return
  end
  self.heroType = heroType
  OnSelectTypeToggle(self)
  RefreshToggleShow(self)
end

local function RefreshHeroInfo(self)
  self.heroes = self.squadData:GetLocalAllHeroes()
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
      end
      heroCount = heroCount + 1
    else
      self.heroInfoBars[i]:SetData(nil)
    end
  end
  local dominatorUuid = self.squadData:GetLocalDominatorUuid()
  if dominatorUuid and 0 < dominatorUuid then
    local dominator = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominator then
      totalCombatPower = totalCombatPower + dominator.power
    end
  end
  self.formationRt:SetHeroesUuid(self.heroes, dominatorUuid)
  totalCombatPower = totalCombatPower + self.squadData:GetEquipCapacity() + self.squadData:GetTWSkillChipCapacity() + self.squadData:GetVirtualConscriptSoldierPower()
  if self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture or self.source == EnterHeroSquadPanelWay.ChampionDuel then
    totalCombatPower = self.squadData:GetTotalCapacity()
  elseif self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
    totalCombatPower = self.squadData:GetTotalCapacity()
  end
  self.powerInfoText:SetText(string.GetFormattedStr2(totalCombatPower))
  self:RefreshFormationBuff()
  if self.prevHeroes then
    local newHeroIndices = {}
    for index, heroUuid in pairs(self.heroes) do
      local prevHeroUuid = self.prevHeroes[index]
      if prevHeroUuid == nil then
        newHeroIndices[index] = true
      end
    end
    ShowShangZhenEffectOn(self, newHeroIndices)
  end
  self.prevHeroes = DeepCopy(self.heroes)
  self:RefreshTWSkillChipBtn()
  self:RefreshQuickBtn()
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
  if appearanceMeta then
    self.formationRt:SetWeaponMeta(appearanceMeta)
  else
    self.formationRt:CheckRemoveTacticalWeapon()
  end
end

local function UpdateView(self)
end

local function OnSetHero(self)
  self:UpdateView()
end

local function ClosePanel(self)
  local formationDataType = ArmyFormationUtils.GetDataTypeByEnterWay(self.source)
  if self.source == EnterHeroSquadPanelWay.ChampionDuel then
    local tmpTb = DataCenter.ChampionDuelManager:GetDirtySelfTeams()
    if not table.IsNullOrEmpty(tmpTb) then
      for _, v in pairs(tmpTb) do
        v:ResetLocalData()
      end
    end
  elseif self.squadData ~= nil and formationDataType and formationDataType == FormationDataType.ArmyFormation then
    local formations = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
    if not table.IsNullOrEmpty(formations) then
      for _, v in pairs(formations) do
        v:ResetLocalData()
      end
    else
      self.squadData:ResetLocalData()
    end
  elseif self.squadData and self.source ~= EnterHeroSquadPanelWay.TruckDeparture and self.source ~= EnterHeroSquadPanelWay.HSRDeparture then
    self.squadData:ResetLocalData()
  end
  if self.closePanelCallBack then
    self.closePanelCallBack()
  end
  self.ctrl:CloseSelf()
end

local function TryGuideClickHeroInList(self, heroCell)
  if DataCenter.LWGuideFlowManager:IsRunning() then
    return
  end
  if self.squadData:GetEmptySlotIndex() ~= nil and not self.guidedClickHero then
    self.guidedClickHero = true
    self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
    self.clickFingerHandle:completed("+", function(handle)
      if handle.isError then
        return
      end
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.localScale = Vector3.one
      if heroCell and heroCell.img_icon then
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

local function ChangeSquadIndex(self, newIndex, needToResetLocalData)
  local curSquadIndex = self.ctrl:GetSquadIndex()
  if curSquadIndex == newIndex then
    return
  end
  if self.source == EnterHeroSquadPanelWay.Arena3V3Defence then
    self.squadData = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(newIndex)
  elseif self.source == EnterHeroSquadPanelWay.KOFDefence then
    self.squadData = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(newIndex)
  elseif self.source == EnterHeroSquadPanelWay.ChampionDuel then
    if not DataCenter.ChampionDuelManager:CheckSelfTeamOrderUnlocked(newIndex, true) then
      return
    end
    self.squadData = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(newIndex)
  end
  if self.squadData and needToResetLocalData then
    self.squadData:ResetLocalData()
  end
  self.ctrl:SetSquadIndex(newIndex)
  self.chooseDominator:SetData(self.source, newIndex)
  self.chooseDominator:SetSquadData(self.squadData)
  self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", newIndex))
  if self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.ChampionDuel then
    self.arena3V3Container:RefreshShow(newIndex, self.source)
  end
  local state = self.allTypeHeroToggle:GetIsOn()
  if state then
    self:OnChangeTypeToggle(HeroType.All)
  else
    self.allTypeHeroToggle:SetIsOn(true)
  end
  self:RefreshChooseSquadBtn()
  self:RefreshFormationBuffInfo()
  self:RefreshQuickBtn()
  self.firmationBufflView:ReInit(self.formationBuffInfo)
  self:RefreshHeroList(false)
  self:RefreshHeroInfo()
end

local function OnArena3V3SwitchDefTeam(self, changeData)
  local index1 = changeData.oldIndex
  local index2 = changeData.newIndex
  local curSquadIndex = self.ctrl:GetSquadIndex()
  if curSquadIndex == index1 then
    self:ChangeSquadIndex(index2)
  elseif curSquadIndex == index2 then
    self:ChangeSquadIndex(index1)
  end
end

local function OnKOFSwitchDefTeamOrder(self, changeData)
  if self.source and self.source == EnterHeroSquadPanelWay.KOFDefence then
    local index1 = changeData.oldIndex
    local index2 = changeData.newIndex
    local curSquadIndex = self.ctrl:GetSquadIndex()
    if curSquadIndex == index1 then
      self:ChangeSquadIndex(index2)
    elseif curSquadIndex == index2 then
      self:ChangeSquadIndex(index1)
    end
  end
end

local function OnClickSquadChooseBtn(data)
  local self = data.self
  local index = data.index
  local squadData
  if self.source == EnterHeroSquadPanelWay.ParkingLotBuilding or self.source == EnterHeroSquadPanelWay.ExpiredMonthlyCard then
    self:OnSaveBtnClick(false, true)
    squadData = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(index)
  elseif self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture then
    squadData = DataCenter.LWMyStationDataManager:GetDefenceFormation(index)
  end
  if squadData ~= nil then
    self.squadData = squadData
    self.ctrl:SetSquadIndex(squadData.index)
    self.chooseDominator:SetData(self.source, squadData.index)
    self.chooseDominator:SetSquadData(squadData)
    self.slotCount = 5
    for k, v in ipairs(self.squad_plan_btn_list) do
      local newData = {self = self, index = k}
      local bindFunc = BindCallback(newData, self.OnClickSquadChooseBtn)
      v:SetData(self.source, k, index, bindFunc)
    end
  end
  local index
  if squadData then
    index = squadData.index
  else
    index = self.ctrl:GetSquadIndex()
  end
  self.formationBg:LoadSprite(string.format("Assets/Main/TextureEx/UILWHeroSquad/biandui_cheku_%d.png", index))
  self:RefreshHeroInfo()
  self:RefreshHeroList(false)
  self:RefreshChooseSquadBtn()
end

local function OnClickSkillChipSet(self, idx)
  local canEdit = self:CheckCanEditWithTips()
  if not canEdit then
    return
  end
  TacticalWeaponUtils:SetSquadUseSet(self.source, self.squadData, idx, function()
    self:RefreshHeroInfo()
  end)
end

local function OnTWSkillChipUpdate(self)
  self:RefreshTWSkillChipBtn()
end

local function ShowPowerInfo(self)
  local heroPower = 0
  local armyPower = 0
  local squadEquipPower = 0
  local otherPower = 0
  local dominatorPower = 0
  local isFakeArmyPower = false
  if self.source == EnterHeroSquadPanelWay.Arena3V3Defence or self.source == EnterHeroSquadPanelWay.TruckDeparture or self.source == EnterHeroSquadPanelWay.HSRDeparture or self.source == EnterHeroSquadPanelWay.PVPArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaDefence or self.source == EnterHeroSquadPanelWay.ActivityArenaV2Defence or self.source == EnterHeroSquadPanelWay.ChampionDuel or self.source == EnterHeroSquadPanelWay.KOFDefence or self.source == EnterHeroSquadPanelWay.NewPeakArenaDefence or self.source == EnterHeroSquadPanelWay.NewGaleArenaDefence then
    heroPower = self.squadData:GetHeroesCapacity()
    armyPower = self.squadData:GetSoldiersCapacity()
    squadEquipPower = self.squadData:GetEquipCapacity()
    otherPower = self.squadData:GetTWSkillChipCapacity()
    dominatorPower = self.squadData:GetDominatorCapacity()
    isFakeArmyPower = false
  else
    heroPower = self.squadData:GetHeroesCapacity()
    armyPower = self.squadData:GetVirtualConscriptSoldierPower()
    squadEquipPower = self.squadData:GetEquipCapacity()
    otherPower = self.squadData:GetTWSkillChipCapacity()
    dominatorPower = self.squadData:GetDominatorCapacity()
    isFakeArmyPower = true
  end
  local sourceData = {
    heroPower = math.floor(heroPower),
    armyPower = math.floor(armyPower),
    squadEquipPower = math.floor(squadEquipPower),
    otherPower = math.floor(otherPower),
    dominatorPower = math.floor(dominatorPower),
    isFakeArmyPower = isFakeArmyPower
  }
  UIUtil.ShowArmyFormationPowerTips(self.power_icon.transform.position, 0, -20, sourceData)
end

function UIHeroPVPFormationPanelView:RefreshSelectPanel()
  self.selectPanel:SetActive(false)
  if self.source == EnterHeroSquadPanelWay.KOFDefence and DataCenter.LWKOFBattleManager:GetType() == TypeKOF.NewPeakArena then
    self.selectPanel:SetActive(true)
    self.selectPanel:SetData(UserSettingKey.NEW_ARENA_KOF_RANDOM, "alliance_train_013")
  end
end

UIHeroPVPFormationPanelView.OnCreate = OnCreate
UIHeroPVPFormationPanelView.OnDestroy = OnDestroy
UIHeroPVPFormationPanelView.OnEnable = OnEnable
UIHeroPVPFormationPanelView.OnDisable = OnDisable
UIHeroPVPFormationPanelView.UpdateView = UpdateView
UIHeroPVPFormationPanelView.OnAddListener = OnAddListener
UIHeroPVPFormationPanelView.OnRemoveListener = OnRemoveListener
UIHeroPVPFormationPanelView.ComponentDefine = ComponentDefine
UIHeroPVPFormationPanelView.DataDefine = DataDefine
UIHeroPVPFormationPanelView.ComponentDestroy = ComponentDestroy
UIHeroPVPFormationPanelView.DataDestroy = DataDestroy
UIHeroPVPFormationPanelView.OnOpen = OnOpen
UIHeroPVPFormationPanelView.RefreshSquadData = RefreshSquadData
UIHeroPVPFormationPanelView.RefreshHeroInfo = RefreshHeroInfo
UIHeroPVPFormationPanelView.OnSetHero = OnSetHero
UIHeroPVPFormationPanelView.ClosePanel = ClosePanel
UIHeroPVPFormationPanelView.OnSelectTypeToggle = OnSelectTypeToggle
UIHeroPVPFormationPanelView.OnChangeTypeToggle = OnChangeTypeToggle
UIHeroPVPFormationPanelView.OnClickHeroCell = OnClickHeroCell
UIHeroPVPFormationPanelView.RefreshHeroList = RefreshHeroList
UIHeroPVPFormationPanelView.TakeDownHero = TakeDownHero
UIHeroPVPFormationPanelView.ResetDragAreaPos = ResetDragAreaPos
UIHeroPVPFormationPanelView.CanEdit = CanEdit
UIHeroPVPFormationPanelView.RefreshFormationBuff = RefreshFormationBuff
UIHeroPVPFormationPanelView.SetBuffViewActive = SetBuffViewActive
UIHeroPVPFormationPanelView.TryGuideClickHeroInList = TryGuideClickHeroInList
UIHeroPVPFormationPanelView.RefreshChooseSquadBtn = RefreshChooseSquadBtn
UIHeroPVPFormationPanelView.ChangeSquadIndex = ChangeSquadIndex
UIHeroPVPFormationPanelView.OnArena3V3SwitchDefTeam = OnArena3V3SwitchDefTeam
UIHeroPVPFormationPanelView.OnSaveBtnClick = OnSaveBtnClick
UIHeroPVPFormationPanelView.OnQuickBtnClick = OnQuickBtnClick
UIHeroPVPFormationPanelView.IsShowQuickBtn = IsShowQuickBtn
UIHeroPVPFormationPanelView.RefreshQuickBtn = RefreshQuickBtn
UIHeroPVPFormationPanelView.RefreshWeaponInfo = RefreshWeaponInfo
UIHeroPVPFormationPanelView.ClearSound = ClearSound
UIHeroPVPFormationPanelView.OnClickSquadChooseBtn = OnClickSquadChooseBtn
UIHeroPVPFormationPanelView.TryDepartureTrain = TryDepartureTrain
UIHeroPVPFormationPanelView.RefreshTWSkillChipBtn = RefreshTWSkillChipBtn
UIHeroPVPFormationPanelView.OnClickSkillChipSet = OnClickSkillChipSet
UIHeroPVPFormationPanelView.OnTWSkillChipUpdate = OnTWSkillChipUpdate
UIHeroPVPFormationPanelView.ShowPowerInfo = ShowPowerInfo
UIHeroPVPFormationPanelView.OnCDOnFormationUpdate = OnCDOnFormationUpdate
UIHeroPVPFormationPanelView.ChampionDuelCheckBeastHero = ChampionDuelCheckBeastHero
UIHeroPVPFormationPanelView.ChampionDuelCheckAndSave = ChampionDuelCheckAndSave
UIHeroPVPFormationPanelView.OnBackBtnClick = OnBackBtnClick
UIHeroPVPFormationPanelView.OnHeroBtnClick = OnHeroBtnClick
UIHeroPVPFormationPanelView.OnKOFSwitchDefTeamOrder = OnKOFSwitchDefTeamOrder
UIHeroPVPFormationPanelView.ShowGuide = ShowGuide
return UIHeroPVPFormationPanelView
