local UIParkourFormationPanelView = BaseClass("UIParkourFormationPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local HeroPVERenderTexture = require("UI.UIParkour.FormationUI.Component.HeroPVERenderTexture")
local UIFormationHeroCell = require("UI.UIParkour.FormationUI.Component.UIFormationTrailHeroCell")
local UIHeroInfoBar = require("UI.UIParkour.FormationUI.Component.UIHeroInfoBar_ParkourFormation")
local FormationBuffView = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.FormationBuffView")
local HeroInfo = require("DataCenter.HeroData.HeroInfo")
local ChooseTWSkillChipSetPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseTWSkillChipSetPopup")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
local UIFormationBubbleTipsContentComponent = require("UI.UIParkour.FormationUI.Component.UIFormationBubbleTipsContentComponent")
local UIParkourHeroQuickUpgradeController = require("UI.UIParkour.FormationUI.Component.UIParkourHeroQuickUpgradeController")
local UIParkourFormationTipPanel = require("UI.UIParkour.FormationUI.Component.UIParkourFormationTipPanel")
local UIParkourFormationTipPanelPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourFormationTipPanel.prefab"
local bottomBarPath = "Root/BottomBar"
local heroScrollPath = "Root/BottomBar/HeroList"
local heroListPath = "Root/BottomBar/HeroList/Content"
local battleBtnPath = "Root/BottomBar/Btns/BattleBtn"
local battleBtnTextPath = "Root/BottomBar/Btns/BattleBtn/BattleBtnText"
local quickBtnPath = "Root/BottomBar/Btns/QuickBtn"
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
local tacticalWeaponBtnPath = "Root/BottomBar/LeftBottomContainer/TacticalWeapon"
local tacticalWeaponLevelTextPath = "Root/BottomBar/LeftBottomContainer/TacticalWeapon/TacticalWeaponLevelNumberText"
local btn_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet"
local icon_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet/Icon"
local txt_choose_skill_chip_set_path = "Root/BottomBar/LeftBottomContainer/btnChooseSkillChipSet/txtChooseSkillChipSet"
local popup_choose_skill_chip_set_path = "PopupChooseSkillChipSet"
local btnRecruit_path = "Root/BottomBar/RightBottomContainer/btnRecruit"
local BattleResultGrowthUtils = require("UI.UIBattleResultUtils.BattleResultGrowthUtils")
local u_i_formation_bubble_tips_content_path = "Root/BottomBar/UIFormationBubbleTipsContent"
local hero_quick_upgrade_container_path = "Root/MiddleContentContainer/HeroQuickUpgradeContainer"

function UIParkourFormationPanelView:ClearHeroScroll()
  self.heroScroll:RemoveComponents(UIFormationHeroCell)
  self.heroList:DestroyChildNode()
end

function UIParkourFormationPanelView:SetVisible(state)
  if self.root then
    self.root:SetActive(state)
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  self.param, self.battleData = self:GetUserData()
  self.stageId = self.param.levelId
  self.enterType = self.param.enterType
  if self.enterType == PVEEnterType.StageFeatureBuilding then
    local featureId = DataCenter.LWBattleManager.logic.param.featureId
    if featureId then
      local featureTemp = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(featureId)
      if featureTemp.limit_hero and #featureTemp.limit_hero > 0 then
        local index = table.indexof(featureTemp.stages, self.stageId)
        if index then
          self.limit_hero = featureTemp.limit_hero[index]
        end
      end
    end
  end
  self:ComponentDefine()
  self:DataDefine()
  self:SetVisible(true)
  self:OnOpen()
  self:CheckNeedSwitchHero()
end

local function OnDestroy(self)
  self.guidedSwitch = nil
  if self.clickGuideDelayTimer then
    self.clickGuideDelayTimer:Stop()
    self.clickGuideDelayTimer = nil
  end
  if self.clickGuideListDelayTimer then
    self.clickGuideListDelayTimer:Stop()
    self.clickGuideListDelayTimer = nil
  end
  if self.switchGuideDelayTimer then
    self.switchGuideDelayTimer:Stop()
    self.switchGuideDelayTimer = nil
  end
  if self.switchGuideTween then
    self.switchGuideTween:Kill()
    self.switchGuideTween = nil
  end
  if not IsNull(self.switchFingerHandle) then
    self.switchFingerHandle:Destroy()
    self.switchFingerHandle = nil
  end
  self:ResetDragAreaPos()
  if self.hasTryHeroes and self.squadData then
    self.squadData:ResetLocalData()
  end
  self.limit_hero = nil
  self.limit_hero_savelist = nil
  self:ClearHeroScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearSound()
  base.OnDestroy(self)
end

function UIParkourFormationPanelView:OnBattleBtnClick()
  if self.squadData then
    local heroes = self.squadData:GetLocalAllHeroes()
    if table.IsNullOrEmpty(heroes) then
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.Music_Effect_battle_start)
    local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    if self.hasTryHeroes then
      local saveHeroes = {}
      for i, heroUuid in pairs(heroes) do
        if self.tryHeroesUuidToDataMap[heroUuid] == nil then
          saveHeroes[i] = heroUuid
        end
      end
      if not self.limit_hero then
        SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex or 1, saveHeroes, self.squadIndex or 1, curChipSetId)
      end
    elseif not self.limit_hero then
      SFSNetwork.SendMessage(MsgDefines.FormationSave, self.squadIndex or 1, heroes, self.squadIndex or 1, curChipSetId)
    end
    EventManager:GetInstance():Broadcast(EventId.ParkourBattleStart)
    self:SetVisible(false)
    if self.limit_hero then
      self.squadData:ClearLocalHeroes()
      if self.limit_hero_savelist then
        for k, v in pairs(self.limit_hero_savelist) do
          self.squadData:SetLocalHero(k, v)
        end
      end
    end
  end
end

local function IsShowQuickBtn(self)
  local quickSquadCtrl = LuaEntry.DataConfig:TryGetNum("newbies_herosquad_control", "k1", 0)
  if quickSquadCtrl ~= 1 then
    return false
  end
  if not self.stageId then
    return false
  end
  if self.enterType ~= PVEEnterType.Monopoly and self.enterType ~= PVEEnterType.TowerupJeepAdventure then
    return false
  end
  local maxLevel = LuaEntry.DataConfig:TryGetNum("auto_arrangement", "k4", 0)
  if maxLevel == nil or maxLevel == 0 or maxLevel < DataCenter.BuildManager.MainLv then
    return false
  end
  if self.enterType == PVEEnterType.Monopoly then
    local order = tonumber(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self.stageId, "order"))
    if not order then
      return false
    end
    local param = "k5"
    local minOrder = LuaEntry.DataConfig:TryGetNum("auto_arrangement", param, -1)
    if minOrder == -1 or order < minOrder then
      return false
    end
  end
  if self.enterType == PVEEnterType.TowerupJeepAdventure then
    local formation_special_type = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self.stageId, "formation_special_type")
    if formation_special_type == nil then
      return false
    end
    return formation_special_type == ""
  end
  return true
end

local function RefreshQuickBtn(self)
  local isShowQuickBtn = self:IsShowQuickBtn()
  self.isShowQuickBtn = isShowQuickBtn
  self.quickBtn:SetActive(isShowQuickBtn)
end

local function OnQuickBtnClick(self)
  if not self.squadData then
    return
  end
  PostEventLog.Track(PostEventLog.Defines.c_one_click_go_battle, {
    uid = LuaEntry.Player.uid,
    stageid = tostring(self.stageId)
  })
  local heroCount = self:AutoFillArmyFormation()
  if heroCount <= 0 then
    UIUtil.ShowTipsId("auto_arrangement_tips")
    return
  end
  if self.u_i_formation_bubble_tips_content then
    self.u_i_formation_bubble_tips_content:SetBubbleActive(false)
  end
  self:OnUpdateArmyFormationList()
end

local function SortByPower(a, b)
  return a.power > b.power
end

local function SortByDefence(a, b)
  return a.heroJob == HeroJob.Defense and b.heroJob ~= HeroJob.Defense
end

local function AutoFillArmyFormation(self)
  local squadData = self.squadData
  if squadData == nil then
    return 0
  end
  local tryHeroesMap = self.hasTryHeroes and self.tryHeroesUuidToDataMap or nil
  local heroCount, heroFormationMap = HeroUtils.AutoFillArmyFormationNew(self.squadData, tryHeroesMap)
  if heroCount == 0 then
    return heroCount
  end
  squadData:ClearLocalHeroes()
  for slotIndex, heroUuid in pairs(heroFormationMap) do
    squadData:SetLocalHero(slotIndex, heroUuid)
  end
  return heroCount
end

local function TryTakeDownHeroAtIndex(self, index)
  if self.squadData then
    local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
    if heroUuid then
      self:TakeDownHero(self.squadIndex, heroUuid)
    end
  end
end

function UIParkourFormationPanelView:OnBeginDragHeroSlot(eventData, index)
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
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Battle_Hero_Placement_Drag, false)
    end
  end
end

function UIParkourFormationPanelView:ResetDragAreaPos()
  for k, v in pairs(self.slotAreas) do
    v.transform.localPosition = self.slotPos[k]
  end
  for k, v in pairs(self.heroInfoBars) do
    v.transform:SetParent(self.heroInfoBarContainer.transform)
    v.transform.localPosition = self.heroInfoBarsPos[k]
  end
end

function UIParkourFormationPanelView:SwitchHeroSlot(fromIndex, toIndex)
  if self.squadData then
    local fromHeroUuid = self.squadData:GetLocalHeroAtSlotIndex(fromIndex)
    local toHeroUuid = self.squadData:GetLocalHeroAtSlotIndex(toIndex)
    self.squadData:SetLocalHero(fromIndex, nil)
    self.squadData:SetLocalHero(toIndex, nil)
    self.squadData:SetLocalHero(fromIndex, toHeroUuid)
    self.squadData:SetLocalHero(toIndex, fromHeroUuid)
  end
end

function UIParkourFormationPanelView:OnDragEndHeroSlot(eventData, index)
  if self.isInDragMode and self.dragingIndex == index then
    self:ResetDragAreaPos()
    self.formationRt:ResetPositions()
    if self.toSwitchIndex then
      self:SwitchHeroSlot(self.dragingIndex, self.toSwitchIndex)
      self:RefreshHeroInfo()
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_Battle_Hero_Placement_Drop, false)
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
      self:OnDragEndHeroSlot(eventData, self.dragingIndex)
      return
    end
    if rtScreenPos.y < -8 or rtScreenPos.y > self.screenHeight + 8 then
      self:OnDragEndHeroSlot(eventData, self.dragingIndex)
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
  self.toSwitchIndex = nil
end

local function ComponentDefine(self)
  self.bottomBar = self:AddComponent(UIBaseContainer, bottomBarPath)
  self.heroList = self:AddComponent(GridInfinityScrollView, heroListPath)
  self.heroScroll = self:AddComponent(UIBaseContainer, heroScrollPath)
  self.battleBtn = self:AddComponent(UIButton, battleBtnPath)
  self.battleBtn:SetOnClick(function()
    self:OnBattleBtnClick()
  end)
  self.battleBtnText = self:AddComponent(UIText, battleBtnTextPath)
  self.quickBtn = self:AddComponent(UIButton, quickBtnPath)
  self.quickBtn:SetOnClick(function()
    self:OnQuickBtnClick()
  end)
  self.backBtn = self:AddComponent(UIButton, backBtnPath)
  self.backBtn:SetOnClick(function()
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
  self.firmationBufflView = self:AddComponent(FormationBuffView, "Root/MiddleContentContainer/FormationContent/FormationBuffInfo")
  self.buffViewCloseBtn = self:AddComponent(UIButton, "Root/MiddleContentContainer/FormationContent/FormationBuffInfo/closeBtn")
  self.buffViewCloseBtn:SetOnClick(function()
    self:SetBuffViewActive()
  end)
  self.formationBtn:SetOnClick(function()
    local isOn = self.firmationBufflView:GetActive()
    if not isOn then
      self.firmationBufflView:ReInit(self.formationBuffInfo)
    end
    self.firmationBufflView:SetActive(not isOn)
  end)
  self.powerInfo = self:AddComponent(UIBaseContainer, powerInfoPath)
  self.powerInfoText = self:AddComponent(UIText, powerInfoTextPath)
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  local heroWorldPos = DataCenter.LWBattleManager:GetCurBattleLogic():GetSquadMemberPosition()
  local heroScreenPos = {}
  for i = 1, 5 do
    local worldPos = heroWorldPos[i] or Vector3.zero
    heroScreenPos[i] = PosConverse.WorldToScreenPos(worldPos, CS.UnityEngine.Camera.main)
  end
  self.slotAreasContainer = self:AddComponent(UIBaseContainer, slotAreaContainerPath)
  self.slotAreas = {}
  self.slotPos = {}
  for i = 1, 5 do
    local slotArea = self:AddComponent(UIEventTrigger, string.format(slotAreaPath, i))
    slotArea:OnPointerClick(function()
      if not self.isInDragMode and not self.limit_hero then
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
      self:OnDragEndHeroSlot(eventData, i)
    end)
    slotArea:OnPointerEnter(function(eventData)
      OnPointerEnterHeroSlot(self, eventData, i)
    end)
    slotArea:OnPointerExit(function(eventData)
      OnPointerExitHeroSlot(self, eventData, i)
    end)
    table.insert(self.slotAreas, slotArea)
    local screenPos = heroScreenPos[i]
    local localPos = PosConverse.ScreenToUIPos(self.slotAreasContainer.rectTransform, screenPos)
    local pos = Vector3.New(localPos.x, localPos.y, 0)
    slotArea.transform.localPosition = pos
    local slotPos = slotArea.transform.localPosition
    table.insert(self.slotPos, slotPos)
  end
  self.heroInfoBarContainer = self:AddComponent(UIBaseContainer, heroInfoBarContainerPath)
  self.heroInfoBars = {}
  self.heroInfoBarsPos = {}
  for i = 1, 5 do
    local heroInfoBar = self:AddComponent(UIHeroInfoBar, string.format(heroInfoBarPath, i))
    table.insert(self.heroInfoBars, heroInfoBar)
    if self.enterType == PVEEnterType.Monopoly then
      local season = SeasonUtil.GetSeason()
      if season == 0 then
        heroInfoBar:EnableClick()
      end
    elseif self:CheckItemSwitch() and self:UnlockHeroUpTip() then
      heroInfoBar:EnableClick()
    end
    local screenPos = heroScreenPos[i]
    screenPos.y = screenPos.y + 100 * self.screenHeight / 1440
    local localPos = PosConverse.ScreenToUIPos(self.heroInfoBarContainer.rectTransform, screenPos)
    local pos = Vector3.New(localPos.x, localPos.y, 0)
    heroInfoBar.transform.localPosition = pos
    local heroInfoBarPos = heroInfoBar.transform.localPosition
    table.insert(self.heroInfoBarsPos, heroInfoBarPos)
  end
  self.heroListTipText = self:AddComponent(UIText, heroListTipTextPath)
  self.recommandHeroPowerText = self:AddComponent(UIText, recommandHeroPowerTextPath)
  self.stageNameText = self:AddComponent(UIText, stageNameTextPath)
  self.root = self:AddComponent(UIBaseContainer, rootPath)
  self.selfPlayerHead = self:AddComponent(UIPlayerHead, selfPlayerHeadPath)
  self.zombieHeadIcon = self:AddComponent(UIImage, zombieHeadPath)
  self.tacticalWeaponBtn = self:AddComponent(UIButton, tacticalWeaponBtnPath)
  self.tacticalWeaponBtn:SetOnClick(function()
    self:OnClickTacticalWeaponBtn()
  end)
  self.tacticalWeaponLevelText = self:AddComponent(UIText, tacticalWeaponLevelTextPath)
  self.chooseSkillChipSetBtn = self:AddComponent(UIButton, btn_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtn:SetOnClick(function()
    if self.squadData then
      local position = self.chooseSkillChipSetBtn.transform.position
      local x = position.x + 40
      local y = position.y - 20
      local dataType = ArmyFormationUtils.EnterSquadWay2FormationDataType[self.source]
      local chipSetIndex = self.squadData:GetLocalTWSkillChipSetId()
      self.chooseTWSkillChipSetPopup:SetPosition(x, y)
      self.chooseTWSkillChipSetPopup:Popup(function(idx)
        self:OnClickSkillChipSet(idx)
      end, self.squadData, ArmyFormationUtils.dataType)
    end
  end)
  self.chooseSkillChipSetBtnIcon = self:AddComponent(UIImage, icon_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtnText = self:AddComponent(UIText, txt_choose_skill_chip_set_path)
  self.chooseTWSkillChipSetPopup = self:AddComponent(ChooseTWSkillChipSetPopup, popup_choose_skill_chip_set_path)
  self.btnRecruit = self:AddComponent(UIButton, btnRecruit_path)
  self.btnRecruit:SetActive(DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.HeroPanel_Require) and self:CheckItemSwitch())
  self.btnRecruit:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = false})
  end)
  self.u_i_formation_bubble_tips_content = self:TryAddComponent(UIFormationBubbleTipsContentComponent, u_i_formation_bubble_tips_content_path)
  if self.u_i_formation_bubble_tips_content then
    self.u_i_formation_bubble_tips_content:SetActive(false)
  end
  self.hero_quick_upgrade_container = self:TryAddComponent(UIParkourHeroQuickUpgradeController, hero_quick_upgrade_container_path)
end

function UIParkourFormationPanelView:UnlockHeroUpTip()
  if self.enterType ~= PVEEnterType.Monopoly then
    return false
  end
  if DataCenter.MonopolyManager.player.curId < 26 then
    return false
  end
  return true
end

function UIParkourFormationPanelView:CheckItemSwitch()
  do return false end
  return false
end

function UIParkourFormationPanelView:CheckShowLvUp(index)
  if not self:CheckItemSwitch() then
    return false
  end
  if not self:UnlockHeroUpTip() then
    return false
  end
  local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
  if not heroUuid then
    return false
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if not heroData then
    return false
  end
  local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)
  return canUpgrade or not reachLevelLimit
end

local function SetBuffViewActive(self)
  local isOn = self.firmationBufflView:GetActive()
  if not isOn then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
  self.firmationBufflView:SetActive(not isOn)
end

function UIParkourFormationPanelView:RefreshFormationBuffInfo()
  local heros = self.squadData:GetLocalAllHeroes()
  local type = self.formationBuffInfo and self.formationBuffInfo.type
  if self.hasTryHeroes then
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
  else
    self.formationBuffInfo = HeroUtils.GetFormationBuffInfoList(heros)
    self.formationBuffInfo.heros = HeroUtils.SortFormationHeros(heros)
  end
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
  if self.firmationBufflView:GetActive() then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
end

local function DataDefine(self)
  self.heroListGO = {}
  self.heroListCell = {}
  self.heroItems = {}
  self.hasInitHeroList = false
  self.heroType = nil
  self.squadIndex = 1
  self.cachedHeroUuids = {}
  self.tryHeroesUuidToDataMap = {}
  self.hasTryHeroes = false
  self.tryHeroesDataInit = false
  self.isShowQuickBtn = false
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
  self.tacticalWeaponBtn = nil
  self.tacticalWeaponLevelText = nil
  self.formationTipPanel = nil
  if self.tipReq then
    self.tipReq:Destroy()
    self.tipReq = nil
  end
  if self.guideClickHeroTimer then
    self.guideClickHeroTimer:Stop()
    self.guideClickHeroTimer = nil
  end
  if self.guideClickTimer then
    self.guideClickTimer:Stop()
    self.guideClickTimer = nil
  end
  self.u_i_formation_bubble_tips_content = nil
  self.hero_quick_upgrade_container = nil
end

local function DataDestroy(self)
  self.heroListGO = nil
  self.heroItems = nil
  self.hasInitHeroList = false
  self.heroType = nil
  self.squadIndex = nil
  self.cachedHeroUuids = nil
  self.screenWidth = nil
  self.screenHeight = nil
  self.heroListCell = nil
  self.tryHeroesUuidToDataMap = nil
  self.hasTryHeroes = false
  self.tryHeroesDataInit = false
  self.isShowQuickBtn = nil
end

local function OnUpdateArmyFormationList(self)
  self:RefreshHeroList(false)
  self:RefreshHeroInfo()
end

local function OnHide(self)
  self:SetVisible(false)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
  self:AddUIListener(EventId.PlotGroupDone, self.PlotGroupDone)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
  self:RemoveUIListener(EventId.PlotGroupDone, self.PlotGroupDone)
end

function UIParkourFormationPanelView:PlotGroupDone(plotId)
  if plotId == 2732 then
    local param = {}
    param.position = self.heroInfoBars[self.guideIndex].heroCell.transform.position + Vector3.New(0, -20, 0)
    param.textKey = "newbies_guide_herosquad_tips"
    param.scale = Vector3.New(1, 1, 1)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrowFinger_New, {anim = true}, param)
  end
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

local function OnKeyCodeEscape(self)
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:ClosePanel()
  end, 1)
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
  if self.stageId then
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self.stageId)
    if line then
      local format = Localization:GetString("levels_num", line.level)
      self.stageNameText:SetText(format)
      local powerRec = line.pow_rec
      if string.IsNullOrEmpty(powerRec) then
        self.recommandHeroPowerText:SetText("0")
      else
        self.enemyPowerRec = tonumber(powerRec)
        self.recommandHeroPowerText:SetText(string.GetFormattedStr(self.enemyPowerRec))
      end
    end
  end
end

local function RefreshPlayerHead(self)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  self.selfPlayerHead:SetData(uid, pic, picVer)
end

local function OnOpen(self)
  self.guideHeroUuid = nil
  RefreshStageInfo(self)
  self.squadIndex = 1
  if self.battleData then
    self.squadIndex = self.battleData:GetFormationSaveType()
  end
  self:RefreshSquadData()
  local state = self.allTypeHeroToggle:GetIsOn()
  if state then
    self:OnChangeTypeToggle(HeroType.All)
  else
    self.allTypeHeroToggle:SetIsOn(true)
  end
  self:RefreshHeroInfo()
  RefreshPlayerHead(self)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self.stageId)
  if line then
    local stageIcon = line.stage_icon
    if not string.IsNullOrEmpty(stageIcon) then
      self.zombieHeadIcon:LoadSprite(stageIcon)
    end
  end
  self:RefreshTacticalWeapon()
  self:RefreshTWSkillChipBtn()
  self:RefreshQuickBtn()
  self:RefreshFormationTipPanel()
  if self.limit_hero then
    local heros = self.squadData:GetLocalAllHeroes()
    self.limit_hero_savelist = {}
    for k, v in pairs(heros) do
      self.limit_hero_savelist[k] = v
    end
    self.squadData:ClearLocalHeroes()
    for _, value in ipairs(self.heroListCell) do
      local heroId = value.heroCell.heroId
      if self.limit_hero == heroId then
        self.squadData:SetLocalHero(4, value.heroCell.heroUuid)
      end
    end
  end
end

function UIParkourFormationPanelView:InitGuideHero()
  if self.guideHeroUuid ~= nil then
    return
  end
  self.guideHeroUuid = 0
  for index, data in ipairs(self.heroDataList) do
    local uuid = data.heroData.uuid
    if index < 5 and self.guideHeroUuid == 0 then
      local selected = self.squadData:HasLocalHero(uuid)
      if not selected then
        self.guideHeroUuid = uuid
        break
      end
    end
  end
end

local function RefreshSquadData(self)
  self.squadData = DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(self.squadIndex or 1)
  self.slotCount = 5
  local formationSpecialType = self.battleData.formationSpecialType
  if formationSpecialType then
    self.squadData:SetFormationPositionType(formationSpecialType)
  end
  self:RefreshHeroInfo()
end

function UIParkourFormationPanelView:GetHeroList(heroType)
  local heroList = {}
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for uuid, heroData in pairs(heroDataList) do
    local displayData = {}
    if not (0 < heroType) or heroData.heroType == heroType then
      local inSquad = self.squadData:HasLocalHero(uuid)
      if inSquad then
        displayData.squadIndex = self.squadIndex
      end
      displayData.heroData = heroData
      table.insert(heroList, displayData)
    end
  end
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
  if self.limit_hero then
    local index = 1
    for i, v in ipairs(heroList) do
      if v.heroData.heroId == self.limit_hero then
        index = i
        break
      end
    end
    if index then
      local item = table.remove(heroList, index)
      table.insert(heroList, 1, item)
    end
  end
  return heroList
end

function UIParkourFormationPanelView:InitTryHeroData()
  local tryHeroes = DataCenter.LWBattleManager:GetCurBattleLogic().tryHeroes
  if tryHeroes and type(tryHeroes) == "table" and 0 < #tryHeroes and not self.tryHeroesDataInit then
    self.tryHeroesUuidToDataMap = {}
    self.tryHeroesDataInit = true
    local tmpUuid = -1
    local dataCount = #tryHeroes
    dataCount = math.floor(dataCount / 3)
    for i = 1, dataCount do
      local index = (i - 1) * 3 + 1
      local heroId = tryHeroes[index]
      local heroLevel = tryHeroes[index + 1]
      local heroRank = tryHeroes[index + 2]
      local h = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
      if h == nil then
        local hero = HeroInfo.New()
        hero:UpdateFromTemplate(heroId, heroLevel, heroRank)
        hero.uuid = tmpUuid
        self.tryHeroesUuidToDataMap[tmpUuid] = hero
        self.hasTryHeroes = true
        tmpUuid = tmpUuid - 1
      end
    end
  end
end

function UIParkourFormationPanelView:OnInitHeroScroll(go, index)
  local item = self.heroScroll:AddComponent(UIFormationHeroCell, go)
  self.heroListGO[go] = item
  self.heroListCell[index] = item
end

local function OnUpdateHeroScroll(self, go, index)
  go.transform:Set_localScale(1.16, 1.16, 1)
  local item = self.heroListGO[go]
  local heroSquadData = self.heroDataList[index + 1]
  item:SetActive(heroSquadData ~= nil)
  item:SetData(heroSquadData, false)
  local uuid = heroSquadData.heroData.uuid
  local isSelected = self.squadData:HasLocalHero(uuid)
  item:SetSelected(isSelected)
  item.index = index
  self.heroItems[heroSquadData.heroData.uuid] = item
  if isSelected == false and uuid == self.guideHeroUuid then
    self.clickGuideListDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.clickGuideListDelayTimer = nil
      self:TryGuideClickHeroInList(item.heroCell)
    end, 0.85)
  end
end

local function OnDestroyHeroScrollItem(self, go, index)
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
  if self.limit_hero then
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
    self.squadData:SetLocalHero(index, heroUuid)
    heroItem:SetSelected(true)
    self:RefreshHeroInfo()
    heroDisplayData.squadIndex = self.squadIndex
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_go_into_battle)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData == nil and self.hasTryHeroes then
      heroData = self.tryHeroesUuidToDataMap[heroUuid]
    end
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
end

local function ClearSound(self)
  if self.soundHandle then
    DataCenter.LWSoundManager:StopSound(self.soundHandle)
    self.soundHandle = nil
  end
end

local function RefreshHeroList(self, moveToTop)
  self.heroDataList = self:GetHeroList(self.heroType)
  local count = table.count(self.heroDataList)
  self:InitGuideHero()
  if 0 < count then
    self.heroScroll:SetActive(true)
    if not self.hasInitHeroList then
      local bindFunc1 = BindCallback(self, self.OnInitHeroScroll)
      local bindFunc2 = BindCallback(self, OnUpdateHeroScroll)
      local bindFunc3 = BindCallback(self, OnDestroyHeroScrollItem)
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
  if self.limit_hero then
    for _, value in ipairs(self.heroListCell) do
      local heroId = value.heroCell.heroId
      local lockTrans = value.gameObject.transform:Find("Lock")
      if self.limit_hero == heroId then
        lockTrans.gameObject:SetActive(false)
      else
        lockTrans.gameObject:SetActive(true)
        local button = lockTrans.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Button))
        button.onClick:RemoveAllListeners()
        button.onClick:AddListener(function()
          local template = DataCenter.HeroTemplateManager:GetTemplate(self.limit_hero)
          UIUtil.ShowTips(Localization:GetString("newbies_fuben_hero_unlock_desc", Localization:GetString(template.name)))
        end)
      end
    end
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
  local hero40010inFront, hero30002atBack
  local heroCount = 0
  for i = 1, self.slotCount do
    local hasHero = self.heroes[i] ~= nil
    if hasHero then
      local heroUuid = self.heroes[i]
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData == nil and self.hasTryHeroes then
        heroData = self.tryHeroesUuidToDataMap[heroUuid]
      end
      if heroData ~= nil then
        if heroData.fromTemplate then
          self.heroInfoBars[i]:SetDataByHeroInfo(heroData)
        else
          self.heroInfoBars[i]:SetData(heroData.level, heroUuid)
        end
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
    if heroData == nil and self.hasTryHeroes then
      heroData = self.tryHeroesUuidToDataMap[heroUuid]
    end
    if heroData ~= nil then
      heroDatas[index] = heroData
    end
  end
  DataCenter.LWBattleManager:GetCurBattleLogic():SetHeroers(heroDatas)
  self.heroPowerRec = self.squadData:GetPVETotalCapacity()
  self.powerInfoText:SetText(string.GetFormattedStr(self.heroPowerRec))
  if not self.guidedSwitch and hero40010inFront and hero30002atBack then
    self.guidedSwitch = true
    self.switchGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:GuideSwitchHeros(self.slotAreas[hero30002atBack], self.slotAreas[hero40010inFront])
    end, 0.5)
  end
  self:RefreshFormationBuff()
  local localChipSetId = self.squadData:GetLocalTWSkillChipSetId()
  if localChipSetId and 0 < localChipSetId then
    self.chooseSkillChipSetBtnText:SetText(string.format("T%d", localChipSetId))
  else
    self.chooseSkillChipSetBtnText:SetText("")
  end
  self:RefreshHeroLvUpSign()
  if self.isShowQuickBtn and self.u_i_formation_bubble_tips_content then
    self.u_i_formation_bubble_tips_content:CheckIsShowBubbleTips(self.squadData)
  end
  if self.enterType == PVEEnterType.Monopoly then
    local season = SeasonUtil.GetSeason()
    if self.hero_quick_upgrade_container and season == 0 then
      self.hero_quick_upgrade_container:RefreshCheckHeroQuickUpgradeShowState(heroDatas)
    end
  end
end

function UIParkourFormationPanelView:RefreshHeroLvUpSign()
  local upHeroes = {}
  for i = 1, #self.heroInfoBars do
    local heroInfoBar = self.heroInfoBars[i]
    local lvup = self:CheckShowLvUp(i)
    heroInfoBar:ShowLvUp(lvup)
    if lvup then
      table.insert(upHeroes, {
        index = i,
        uuid = self.squadData:GetLocalHeroAtSlotIndex(i)
      })
    end
  end
  if #upHeroes == 0 then
    return
  end
  self:TryGuideLvUp(upHeroes)
end

function UIParkourFormationPanelView:TryGuideLvUp(upHeroes)
  if not self:CheckItemSwitch() then
    return
  end
  if not self:UnlockHeroUpTip() then
    return
  end
  if CommonUtil.PlayerPrefsGetInt("TryGuideLvUp", 0) ~= 0 then
    return
  end
  CommonUtil.PlayerPrefsSetInt("TryGuideLvUp", 1)
  self.guideIndex = nil
  local maxQuality, maxLevel
  for i = 1, #upHeroes do
    local heroUuid = upHeroes[i].uuid
    if heroUuid then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if not maxLevel or maxLevel <= heroData.level and maxQuality <= heroData.quality then
        maxQuality = heroData.quality
        maxLevel = heroData.level
        self.guideIndex = upHeroes[i].index
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = 2732, hideMainUI = false})
end

local function UpdateView(self)
end

local function OnSetHero(self)
  self:UpdateView()
end

local function ClosePanel(self)
  if self.limit_hero then
    self.squadData:ClearLocalHeroes()
    if self.limit_hero_savelist then
      for k, v in pairs(self.limit_hero_savelist) do
        self.squadData:SetLocalHero(k, v)
      end
    end
  end
  PostEventLog.BattleResultLog(PVEType.Parkour, 2)
  if self.enterType == PVEEnterType.TowerupJeepAdventure then
    DataCenter.LWBattleManager:SetBattleExitFlag(true)
    DataCenter.LWBattleManager:Exit(function()
      if self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, "quit")
  else
    DataCenter.LWBattleManager:Exit(nil, "quit")
    self.ctrl:CloseSelf()
  end
  if DataCenter.LWBattleManager.logic.param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnExitBattle(DataCenter.LWBattleManager.logic.param.buildUuid)
  end
end

function UIParkourFormationPanelView:TryGuideClickHero(heroCell)
end

function UIParkourFormationPanelView:PlayGuideClickHero(heroCell)
  if not heroCell then
    return
  end
  local param = {
    position = heroCell.img_icon.transform.position + Vector3(50, -50, 0),
    positionType = PositionType.Screen
  }
  DataCenter.ArrowManager:ShowFingerArrow(param)
  self.guideClickTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.guideClickTimer = nil
    self:TryGuideClickHero(heroCell)
  end, 2)
end

local function TryGuideClickHeroInList(self, heroCell)
  if DataCenter.LWGuideFlowManager:IsRunning() then
    return
  end
  if self.squadData:GetEmptySlotIndex() ~= nil and not self.guidedClickHero then
    if not heroCell then
      return
    end
    local param = {
      position = heroCell.img_icon.transform.position + Vector3(50, -50, 0),
      positionType = PositionType.Screen
    }
    DataCenter.ArrowManager:ShowFingerArrow(param)
    self.guideClickHeroTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.guideClickHeroTimer = nil
      DataCenter.ArrowManager:RemoveFingerArrow()
    end, 2)
  end
end

local function GuideSwitchHeros(self, srcSlot, tarSlot)
  if not IsNull(self.switchFingerHandle) then
    self.switchFingerHandle:Destroy()
    self.switchFingerHandle = nil
  end
  self.switchFingerHandle = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger_hold.prefab", function(handle)
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

local function RefreshTacticalWeapon(self)
  local weaponInfo = DataCenter.TacticalWeaponManager:GetFirstWeaponInfo()
  if weaponInfo then
    self.tacticalWeaponBtn:SetActive(true)
    self.tacticalWeaponLevelText:SetText(weaponInfo.level)
    self.weaponInfo = weaponInfo
  else
    self.tacticalWeaponBtn:SetActive(false)
  end
end

function UIParkourFormationPanelView:OnClickTacticalWeaponBtn()
  if self.weaponInfo then
    local selfEquips = DataCenter.TacticalWeaponManager:GetAllSelfWearingEquips()
    local skinId = DataCenter.TacticalWeaponManager:GetWeaponSkinId()
    local skillChips
    local useSetId = self.squadData:GetLocalTWSkillChipSetId()
    if useSetId ~= nil and 0 < useSetId then
      skillChips = DataCenter.TWSkillChipManager:GetChipsInfoByMasterSet(useSetId)
    end
    local power = DataCenter.TacticalWeaponManager:GetWeaponTotalPower()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.weaponInfo, selfEquips, self.tacticalWeaponBtn, skinId, skillChips, power)
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

local function OnClickSkillChipSet(self, idx)
  TacticalWeaponUtils:SetSquadUseSet(EnterHeroSquadPanelWay.PVE, self.squadData, idx, function()
    local logic = DataCenter.LWBattleManager:GetCurBattleLogic()
    if logic and logic.ChangeTWSkillChipSetId then
      logic:ChangeTWSkillChipSetId(idx)
    end
    self:RefreshHeroInfo()
  end)
end

local function OnTWSkillChipUpdate(self)
  self:RefreshTWSkillChipBtn()
end

local function RefreshFormationTipPanel(self)
  local saveType = self.battleData:GetFormationSaveType()
  local show = false
  local tip1, tip2
  if saveType == FormationSaveType.ParkourOneHero then
    show = true
    tip1 = Localization:GetString("activity_breakthrough_tips_56")
    tip2 = Localization:GetString("activity_breakthrough_tips_57", 1)
  elseif saveType == FormationSaveType.ParkourTwoHero then
    show = true
    tip1 = Localization:GetString("activity_breakthrough_tips_56")
    tip2 = Localization:GetString("activity_breakthrough_tips_57", 2)
  elseif saveType == FormationSaveType.ParkourThreeHero then
    show = true
    tip1 = Localization:GetString("activity_breakthrough_tips_56")
    tip2 = Localization:GetString("activity_breakthrough_tips_57", 3)
  elseif saveType == FormationSaveType.ParkourFourHero then
    show = true
    tip1 = Localization:GetString("activity_breakthrough_tips_56")
    tip2 = Localization:GetString("activity_breakthrough_tips_57", 4)
  end
  if show then
    if self.formationTipPanel == nil then
      self.formationTipPanel = self:LoadComponentAsync(UIParkourFormationTipPanel, UIParkourFormationTipPanelPath, self.middleContentContainer.transform)
    end
    self.formationTipPanel:SetActive(true)
    self.formationTipPanel:SetData(tip1, tip2, Vector2(0, 240))
  elseif self.formationTipPanel ~= nil then
    self.formationTipPanel:SetActive(false)
  end
end

function UIParkourFormationPanelView:CheckNeedSwitchHero()
  local data = BattleResultGrowthUtils:GetNeedAdjustFormationData()
  if data == nil or self.guidedSwitch or self.switchGuideDelayTimer then
    return
  end
  local slot1 = data[1].slot
  local slot2 = data[2].slot
  self.switchGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:GuideSwitchHeros(self.slotAreas[slot1], self.slotAreas[slot2])
  end, 0.5)
  BattleResultGrowthUtils:ClearNeedAdjustFormationData()
end

UIParkourFormationPanelView.OnCreate = OnCreate
UIParkourFormationPanelView.OnDestroy = OnDestroy
UIParkourFormationPanelView.OnEnable = OnEnable
UIParkourFormationPanelView.OnDisable = OnDisable
UIParkourFormationPanelView.UpdateView = UpdateView
UIParkourFormationPanelView.OnAddListener = OnAddListener
UIParkourFormationPanelView.OnRemoveListener = OnRemoveListener
UIParkourFormationPanelView.ComponentDefine = ComponentDefine
UIParkourFormationPanelView.DataDefine = DataDefine
UIParkourFormationPanelView.ComponentDestroy = ComponentDestroy
UIParkourFormationPanelView.DataDestroy = DataDestroy
UIParkourFormationPanelView.OnOpen = OnOpen
UIParkourFormationPanelView.RefreshSquadData = RefreshSquadData
UIParkourFormationPanelView.RefreshHeroInfo = RefreshHeroInfo
UIParkourFormationPanelView.OnSetHero = OnSetHero
UIParkourFormationPanelView.ClosePanel = ClosePanel
UIParkourFormationPanelView.OnSelectTypeToggle = OnSelectTypeToggle
UIParkourFormationPanelView.OnChangeTypeToggle = OnChangeTypeToggle
UIParkourFormationPanelView.OnClickHeroCell = OnClickHeroCell
UIParkourFormationPanelView.RefreshHeroList = RefreshHeroList
UIParkourFormationPanelView.TakeDownHero = TakeDownHero
UIParkourFormationPanelView.TryGuideClickHeroInList = TryGuideClickHeroInList
UIParkourFormationPanelView.GuideSwitchHeros = GuideSwitchHeros
UIParkourFormationPanelView.RefreshFormationBuff = RefreshFormationBuff
UIParkourFormationPanelView.OnKeyCodeEscape = OnKeyCodeEscape
UIParkourFormationPanelView.SetBuffViewActive = SetBuffViewActive
UIParkourFormationPanelView.RefreshTacticalWeapon = RefreshTacticalWeapon
UIParkourFormationPanelView.ClearSound = ClearSound
UIParkourFormationPanelView.RefreshTWSkillChipBtn = RefreshTWSkillChipBtn
UIParkourFormationPanelView.OnClickSkillChipSet = OnClickSkillChipSet
UIParkourFormationPanelView.OnTWSkillChipUpdate = OnTWSkillChipUpdate
UIParkourFormationPanelView.IsShowQuickBtn = IsShowQuickBtn
UIParkourFormationPanelView.RefreshQuickBtn = RefreshQuickBtn
UIParkourFormationPanelView.OnQuickBtnClick = OnQuickBtnClick
UIParkourFormationPanelView.AutoFillArmyFormation = AutoFillArmyFormation
UIParkourFormationPanelView.OnUpdateArmyFormationList = OnUpdateArmyFormationList
UIParkourFormationPanelView.RefreshFormationTipPanel = RefreshFormationTipPanel
return UIParkourFormationPanelView
