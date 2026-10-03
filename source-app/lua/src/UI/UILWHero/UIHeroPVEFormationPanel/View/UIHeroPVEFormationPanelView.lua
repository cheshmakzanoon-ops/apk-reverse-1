local UIHeroPVEFormationPanelView = BaseClass("UIHeroPVEFormationPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Resource = CS.GameEntry.Resource
local HeroPVERenderTexture = require("UI.UILWHero.UIHeroPVEFormationPanel.Component.HeroPVERenderTexture")
local UIFormationHeroCell = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIFormationHeroCell")
local UIHeroInfoBar = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroInfoBar")
local FormationBuffView = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.FormationBuffView")
local ChooseTWSkillChipSetPopup = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.ChooseTWSkillChipSetPopup")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local ArmyFormationUtils = require("DataCenter.ArmyFormationData.ArmyFormationUtils")
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
local power_icon_path = "Root/MiddleContentContainer/TopBar/PowerInfo/PowerIcon"
local btnRecruit_path = "Root/BottomBar/RightBottomContainer/btnRecruit"

local function ClearHeroScroll(self)
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
  ClearHeroScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:ClearSound()
  base.OnDestroy(self)
end

local function OnBattleBtnClick(self)
  if self.squadData then
    local heroes = self.squadData:GetLocalAllHeroes()
    if table.IsNullOrEmpty(heroes) then
      return
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_battle_start)
    local curChipSetId = self.squadData:GetLocalTWSkillChipSetId()
    if self.source == EnterHeroSquadPanelWay.PveEnterBattle then
      if self.stageGroupId and self.stageId then
        SFSNetwork.SendMessage(MsgDefines.StartPveStage, self.stageGroupId, self.stageId, 1, nil, heroes, curChipSetId)
      end
    elseif self.source == EnterHeroSquadPanelWay.DetectEventPVE then
      if self.detectEventUuid then
        SFSNetwork.SendMessage(MsgDefines.StartDetectEventPve, self.detectEventUuid, 1, heroes, curChipSetId)
      end
    elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
      if self.cfgId then
        SFSNetwork.SendMessage(MsgDefines.FormationSave, 1, heroes, 1, curChipSetId)
        DataCenter.ZombieBattleManager:StartBattle()
      end
    elseif self.source == EnterHeroSquadPanelWay.StageFeatureBattle then
      DataCenter.ZombieBattleManager:StartBattle()
    end
  end
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
  local heroCount = 0
  local heroUuid
  local used = {}
  local heroDataList = {}
  for _, heroData in pairs(DataCenter.HeroDataManager:GetAllHeroList()) do
    table.insert(heroDataList, heroData)
  end
  table.sort(heroDataList, function(a, b)
    if a.quality > b.quality then
      return true
    elseif a.quality < b.quality then
      return false
    else
      local rankA = a:GetMaxAvailableRankByFrag()
      local rankB = b:GetMaxAvailableRankByFrag()
      if rankA > a.rank then
      end
      if rankB > b.rank then
      end
      if rankA > rankB then
        return true
      elseif rankA < rankB then
        return false
      elseif a.level > b.level then
        return true
      elseif a.level < b.level then
        return false
      else
        return false
      end
    end
    return false
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
end

local function TryTakeDownHeroAtIndex(self, index)
  if self.squadData then
    local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
    if heroUuid then
      self:TakeDownHero(self.squadIndex, heroUuid)
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
    OnBattleBtnClick(self)
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
  local heroWorldPos = DataCenter.ZombieBattleManager:GetSquadMemberPosition()
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
    if self:CheckItemSwitch() and self:UnlockHeroUpTip() then
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
  end)
  self.tacticalWeaponLevelText = self:AddComponent(UIText, tacticalWeaponLevelTextPath)
  self.chooseSkillChipSetBtn = self:AddComponent(UIButton, btn_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtn:SetOnClick(function()
    if self.squadData then
      local position = self.chooseSkillChipSetBtn.transform.position
      local x = position.x + 40
      local y = position.y - 20
      local formationDataType = ArmyFormationUtils.EnterSquadWay2FormationDataType[self.source]
      self.chooseTWSkillChipSetPopup:SetPosition(x, y)
      self.chooseTWSkillChipSetPopup:Popup(function(idx)
        self:OnClickSkillChipSet(idx)
      end, self.squadData, ArmyFormationUtils.formationDataType)
    end
  end)
  self.chooseSkillChipSetBtnIcon = self:AddComponent(UIImage, icon_choose_skill_chip_set_path)
  self.chooseSkillChipSetBtnText = self:AddComponent(UIText, txt_choose_skill_chip_set_path)
  self.chooseTWSkillChipSetPopup = self:AddComponent(ChooseTWSkillChipSetPopup, popup_choose_skill_chip_set_path)
  self.power_icon = self:AddComponent(UIImage, power_icon_path)
  self.powerInfoBtn = self:AddComponent(UIButton, powerInfoPath)
  self.powerInfoBtn:SetOnClick(function()
    self:ShowPowerInfo()
  end)
  self.btnRecruit = self:AddComponent(UIButton, btnRecruit_path)
  self.btnRecruit:SetActive(DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.HeroPanel_Require) and self:CheckItemSwitch())
  self.btnRecruit:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = false})
  end)
end

function UIHeroPVEFormationPanelView:UnlockHeroUpTip()
  if not self.enterType then
    _, _, _, self.enterType = self:GetUserData()
  end
  if self.enterType ~= PVEEnterType.Monopoly then
    return false
  end
  if DataCenter.MonopolyManager.player.curId < 26 then
    return false
  end
  return true
end

function UIHeroPVEFormationPanelView:CheckItemSwitch()
  return false
end

local function SetBuffViewActive(self)
  local isOn = self.firmationBufflView:GetActive()
  if not isOn then
    self.firmationBufflView:ReInit(self.formationBuffInfo)
  end
  self.firmationBufflView:SetActive(not isOn)
end

function UIHeroPVEFormationPanelView:RefreshFormationBuffInfo()
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
  if self.firmationBufflView:GetActive() then
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
  self.tacticalWeaponBtn = nil
  self.tacticalWeaponLevelText = nil
  self.power_icon = nil
  self.powerInfoBtn = nil
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
  self.weaponInfo = nil
end

local function OnUpdateArmyFormationList(self)
  self:RefreshHeroList(false)
  self:RefreshHeroInfo()
end

local function OnHide(self)
  SetVisible(self, false)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:AddUIListener(EventId.HidePVEFormationPanel, OnHide)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ArmyFormatUpdate, OnUpdateArmyFormationList)
  self:RemoveUIListener(EventId.HidePVEFormationPanel, OnHide)
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnTWSkillChipUpdate)
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
    local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), self.stageId)
    if line then
      local format = Localization:GetString("levels_num", line.level)
      self.stageNameText:SetText(format)
      self.enemyPowerRec = tonumber(line.pow_rec)
      self.recommandHeroPowerText:SetText(string.GetFormattedStr(self.enemyPowerRec))
    end
  end
end

local function RefreshPlayerHead(self)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  self.selfPlayerHead:SetData(uid, pic, picVer)
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
  local param1, param2
  self.source, param1, param2, self.enterType = self:GetUserData()
  if self.source == EnterHeroSquadPanelWay.PveEnterBattle then
    self.stageGroupId = param1
    self.stageId = param2
  elseif self.source == EnterHeroSquadPanelWay.DetectEventPVE then
    self.detectEventUuid = param1
    if not self.detectEventUuid then
      self:ClosePanel()
      return
    end
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.detectEventUuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    self.stageId = template.para
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    self.cfgId = param1
    self.stageId = param2
  elseif self.source == EnterHeroSquadPanelWay.StageFeatureBattle then
    self.stageId = param2
  end
  RefreshStageInfo(self)
  RefreshTacticalWeapon(self)
  self.squadIndex = 1
  self:RefreshSquadData()
  RefreshTWSkillChipBtn(self)
  local state = self.allTypeHeroToggle:GetIsOn()
  if state then
    self:OnChangeTypeToggle(HeroType.All)
  else
    self.allTypeHeroToggle:SetIsOn(true)
  end
  self:RefreshHeroInfo()
  RefreshPlayerHead(self)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), self.stageId)
  if line then
    local zombieHeadPath = line.stage_icon
    self.zombieHeadIcon:LoadSprite(zombieHeadPath)
  end
  if self.enterType == PVEEnterType.Monopoly then
    local isSBttle = DataCenter.MonopolyManager:GetSpontaneousBattle()
    if isSBttle then
      self.delayBattleStart = TimerManager:GetInstance():DelayInvoke(function()
        OnBattleBtnClick(self)
      end, 1)
    end
  end
  self:RefreshQuickBtn()
end

local function RefreshSquadData(self)
  self.squadData = DataCenter.ArmyFormationDataManager:GetFormationByType(self.source, self.squadIndex)
  self.slotCount = 5
  self:RefreshHeroInfo()
end

local function GetHeroList(self, heroType)
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
  table.sort(heroList, function(a, b)
    return a.heroData.power > b.heroData.power
  end)
  return heroList
end

local function OnInitHeroScroll(self, go, index)
  local item = self.heroScroll:AddComponent(UIFormationHeroCell, go)
  self.heroListGO[go] = item
end

local function OnUpdateHeroScroll(self, go, index)
  go.transform:Set_localScale(1.16, 1.16, 1)
  local item = self.heroListGO[go]
  local heroSquadData = self.heroDataList[index + 1]
  item:SetActive(heroSquadData ~= nil)
  item:SetData(heroSquadData, false)
  local isSelected = self.squadData:HasLocalHero(heroSquadData.heroData.uuid)
  item:SetSelected(isSelected)
  self.heroItems[heroSquadData.heroData.uuid] = item
  if isSelected == false then
    self.clickGuideDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
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
  self.heroDataList = GetHeroList(self, self.heroType)
  local count = table.count(self.heroDataList)
  if 0 < count then
    self.heroScroll:SetActive(true)
    if not self.hasInitHeroList then
      local bindFunc1 = BindCallback(self, OnInitHeroScroll)
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
      if heroData ~= nil then
        self.heroInfoBars[i]:SetData(heroData.level, heroUuid)
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
  DataCenter.ZombieBattleManager:SetHeroers(heroDatas)
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
    self.chooseSkillChipSetBtnText:SetLocalText("800323", localChipSetId)
  else
    self.chooseSkillChipSetBtnText:SetText("")
  end
  self:RefreshHeroLvUpSign()
end

function UIHeroPVEFormationPanelView:RefreshHeroLvUpSign()
  for i = 1, #self.heroInfoBars do
    local heroInfoBar = self.heroInfoBars[i]
    heroInfoBar:ShowLvUp(self:CheckShowLvUp(i))
  end
end

function UIHeroPVEFormationPanelView:CheckShowLvUp(index)
  if not self:CheckItemSwitch() then
    return false
  end
  if not self:UnlockHeroUpTip() then
    return false
  end
  if self.enterType ~= PVEEnterType.Monopoly then
    return false
  end
  local heroUuid = self.squadData:GetLocalHeroAtSlotIndex(index)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if not heroData then
    return false
  end
  local canUpgrade, canUpgradeWithoutExpItems, overFinalLevel, reachLevelLimit = DataCenter.HeroDataManager:GetHeroCanUpgradeInfos(heroData)
  return canUpgrade or not reachLevelLimit
end

local function UpdateView(self)
end

local function OnSetHero(self)
  self:UpdateView()
end

local function ClosePanel(self)
  local exitStageId = DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
  local stageTemp = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), exitStageId)
  if self.source == EnterHeroSquadPanelWay.DetectEventPVE then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.DetectEventExitBtn)
  elseif self.source == EnterHeroSquadPanelWay.PveEnterBattle then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  elseif self.source == EnterHeroSquadPanelWay.TowerupJeepAdventure then
    DataCenter.ZombieBattleManager:SetBattleExitFlag(true)
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.TowerupExitBtn)
  elseif self.source == EnterHeroSquadPanelWay.StageFeatureBattle then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  end
  if DataCenter.ZombieBattleManager.param.enterType == PVEEnterType.StageFeatureBuilding then
    DataCenter.StageFeatureBuildingManager:OnExitBattle(DataCenter.ZombieBattleManager.param.buildUuid)
  end
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
      CommonUtil.CallAutoArabicMirrorManually(handle)
      local gameObject = handle.gameObject
      local transform = gameObject.transform
      transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Guide.Name).transform, false)
      transform.localScale = Vector3.one
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

local function OnClickSkillChipSet(self, idx)
  TacticalWeaponUtils:SetSquadUseSet(self.source, self.squadData, idx, function()
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

local function ShowPowerInfo(self)
  local heroCombatPower = 0
  for i = 1, self.slotCount do
    local hasHero = self.heroes[i] ~= nil
    if hasHero then
      local heroUuid = self.heroes[i]
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData ~= nil then
        heroCombatPower = heroCombatPower + heroData.power
      end
    end
  end
  local sourceData = {
    heroPower = math.floor(heroCombatPower),
    armyPower = 0,
    squadEquipPower = 0,
    otherPower = 0,
    isFakeArmyPower = true
  }
  UIUtil.ShowArmyFormationPowerTips(self.power_icon.transform.position, 0, -20, sourceData)
end

UIHeroPVEFormationPanelView.OnCreate = OnCreate
UIHeroPVEFormationPanelView.OnDestroy = OnDestroy
UIHeroPVEFormationPanelView.OnEnable = OnEnable
UIHeroPVEFormationPanelView.OnDisable = OnDisable
UIHeroPVEFormationPanelView.UpdateView = UpdateView
UIHeroPVEFormationPanelView.OnAddListener = OnAddListener
UIHeroPVEFormationPanelView.OnRemoveListener = OnRemoveListener
UIHeroPVEFormationPanelView.ComponentDefine = ComponentDefine
UIHeroPVEFormationPanelView.DataDefine = DataDefine
UIHeroPVEFormationPanelView.ComponentDestroy = ComponentDestroy
UIHeroPVEFormationPanelView.DataDestroy = DataDestroy
UIHeroPVEFormationPanelView.OnOpen = OnOpen
UIHeroPVEFormationPanelView.RefreshSquadData = RefreshSquadData
UIHeroPVEFormationPanelView.RefreshHeroInfo = RefreshHeroInfo
UIHeroPVEFormationPanelView.OnSetHero = OnSetHero
UIHeroPVEFormationPanelView.ClosePanel = ClosePanel
UIHeroPVEFormationPanelView.OnSelectTypeToggle = OnSelectTypeToggle
UIHeroPVEFormationPanelView.OnChangeTypeToggle = OnChangeTypeToggle
UIHeroPVEFormationPanelView.OnClickHeroCell = OnClickHeroCell
UIHeroPVEFormationPanelView.RefreshHeroList = RefreshHeroList
UIHeroPVEFormationPanelView.TakeDownHero = TakeDownHero
UIHeroPVEFormationPanelView.ResetDragAreaPos = ResetDragAreaPos
UIHeroPVEFormationPanelView.TryGuideClickHeroInList = TryGuideClickHeroInList
UIHeroPVEFormationPanelView.GuideSwitchHeros = GuideSwitchHeros
UIHeroPVEFormationPanelView.RefreshFormationBuff = RefreshFormationBuff
UIHeroPVEFormationPanelView.OnKeyCodeEscape = OnKeyCodeEscape
UIHeroPVEFormationPanelView.SetBuffViewActive = SetBuffViewActive
UIHeroPVEFormationPanelView.ClearSound = ClearSound
UIHeroPVEFormationPanelView.RefreshTWSkillChipBtn = RefreshTWSkillChipBtn
UIHeroPVEFormationPanelView.OnTWSkillChipUpdate = OnTWSkillChipUpdate
UIHeroPVEFormationPanelView.OnClickSkillChipSet = OnClickSkillChipSet
UIHeroPVEFormationPanelView.ShowPowerInfo = ShowPowerInfo
UIHeroPVEFormationPanelView.IsShowQuickBtn = IsShowQuickBtn
UIHeroPVEFormationPanelView.RefreshQuickBtn = RefreshQuickBtn
UIHeroPVEFormationPanelView.OnQuickBtnClick = OnQuickBtnClick
UIHeroPVEFormationPanelView.AutoFillArmyFormation = AutoFillArmyFormation
UIHeroPVEFormationPanelView.OnUpdateArmyFormationList = OnUpdateArmyFormationList
return UIHeroPVEFormationPanelView
