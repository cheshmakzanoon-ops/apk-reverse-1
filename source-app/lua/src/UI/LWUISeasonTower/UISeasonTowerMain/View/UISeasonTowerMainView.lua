local UISeasonTowerMainView = BaseClass("UISeasonTowerMainView", UIBaseView)
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")
local PosConverse = require("Common.PosConverse")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonTowerSelectItemComponent = require("UI.LWUISeasonTower.UISeasonTowerMain.Component.SeasonTowerSelectItemComponent")
local UISeasonTowerStageInfoItemComponent = require("UI.LWUISeasonTower.UISeasonTowerMain.Component.UISeasonTowerStageInfoItemComponent")
local RECRUIT_100_BTN_CHANGE_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_herorecruit100_saoguang.prefab"
local Car_Effect_Path = "Assets/Main/Prefabs/UI/LWUISeasonTower/Effect/Prefab/Eff_ui_SeasonTower_sweeping_0%d.prefab"
local StageItemNum = 7
local FlyNumConfig = {
  1,
  3,
  6
}
local PowerInfoWorldOffsetY = 3.5

function UISeasonTowerMainView:OnCreate()
  base.OnCreate(self)
  local data = self:GetUserData()
  self.action = data.action
  self:ComponentDefine()
  self:DataDefine()
  self:SetData()
  if type(self.action) == "function" then
    local enterType = self.action()
    if enterType == SeasonTowerConfig.EnterType.Sweep then
      self:DoSweep()
    end
    self:SetUserData({})
    self.action = nil
  end
end

function UISeasonTowerMainView:OnDestroy()
  self.action = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonTowerMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnGoto = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.btnSweep = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnSweep:SetOnClick(function()
    self:OnBtnSweepClick()
  end)
  self.btnStopSweep = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnStopSweep:SetOnClick(function()
    self:OnBtnStopSweepClick()
  end)
  self.btnSetting = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnSetting:SetOnClick(function()
    self:OnBtnSettingClick()
  end)
  self.textAllFinish = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnRank = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.btnSelfBuff = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnSelfBuff:SetOnClick(function()
    self:OnBtnSelfBuffClick()
  end)
  self.btnEnvBuff = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnEnvBuff:SetOnClick(function()
    self:OnBtnEnvBuffClick()
  end)
  self.compResItem = self.viewSkin:AddComponent(self, UICommonResItem, 11)
  self.textNumTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.imgArrowDown = self.viewSkin:AddComponent(self, UIImage, 14)
  self.imgArrowUp = self.viewSkin:AddComponent(self, UIImage, 15)
  self.compContentArea = self.viewSkin:AddComponent(self, UIBaseContainer, 16)
  self.areaScrollView = self.viewSkin:AddComponent(self, UIScrollView, 17)
  self.btnTitleArea = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnTitleArea:SetOnClick(function()
    self:OnBtnTitleAreaClick()
  end)
  self.imgAllBuffIcon = self.viewSkin:AddComponent(self, UIImage, 19)
  self.btnAreaMask = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnAreaMask:SetOnClick(function()
    self:OnBtnAreaMaskClick()
  end)
  self.btnRewardPanel = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnRewardPanel:SetOnClick(function()
    self:OnBtnRewardPanelClick()
  end)
  self.textStrengthTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.imgCircleBg1 = self.viewSkin:AddComponent(self, UIImage, 23)
  self.imgCircleBg2 = self.viewSkin:AddComponent(self, UIImage, 24)
  self.imgCircleBg3 = self.viewSkin:AddComponent(self, UIImage, 25)
  self.imgCircleBg4 = self.viewSkin:AddComponent(self, UIImage, 26)
  self.imgCircleBg5 = self.viewSkin:AddComponent(self, UIImage, 27)
  self.imgCircleBg6 = self.viewSkin:AddComponent(self, UIImage, 28)
  self.imgCircleBg7 = self.viewSkin:AddComponent(self, UIImage, 29)
  self.compUISeasonTowerStageInfoItem1 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 30)
  self.compUISeasonTowerStageInfoItem2 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 31)
  self.compUISeasonTowerStageInfoItem3 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 32)
  self.compUISeasonTowerStageInfoItem4 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 33)
  self.compUISeasonTowerStageInfoItem5 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 34)
  self.compUISeasonTowerStageInfoItem6 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 35)
  self.compUISeasonTowerStageInfoItem7 = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 36)
  self.compCenterItem = self.viewSkin:AddComponent(self, UISeasonTowerStageInfoItemComponent, 37)
  self.compRedDotWithoutNum = self.viewSkin:AddComponent(self, UIBaseContainer, 38)
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 39)
  self.compMidContent = self.viewSkin:AddComponent(self, UIBaseContainer, 40)
  self.btnCard = self.viewSkin:AddComponent(self, UIButton, 41)
  self.btnCard:SetOnClick(function()
    self:OnBtnCardClick()
  end)
  self.textCardLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 42)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseContainer, 43)
  self.compCardEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 44)
  self.compCenterItemEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 45)
  self.textStageNowNumEffect = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 46)
  self.simpleAnimationStageNowNumEffect = self.viewSkin:AddComponent(self, UISimpleAnimation, 47)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 48)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compSpecialItemParent = self.viewSkin:AddComponent(self, UIBaseContainer, 49)
  self.textSpecialItemProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 50)
  self.compSpecialItem = self.viewSkin:AddComponent(self, UIBaseContainer, 51)
  self.compSweepingEffect = self.viewSkin:AddComponent(self, UIBaseContainer, 52)
  self.textSweepingProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 53)
  self.imgTipIcon = self.viewSkin:AddComponent(self, UIImage, 54)
  self.compPowerInfoEnemy = self.viewSkin:AddComponent(self, UIBaseContainer, 55)
  self.compPowerInfoSelf = self.viewSkin:AddComponent(self, UIBaseContainer, 56)
  self.textEnemyPowerNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 57)
  self.textSelfPowerNumber = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 58)
  self.rawImgSweepingMaxSpeedEffect03 = self.viewSkin:AddComponent(self, UIRawImage, 59)
  self.compSweepingEffectParent = self.viewSkin:AddComponent(self, UIBaseContainer, 60)
  self.simpleAnimationSweepingEffect = self.viewSkin:AddComponent(self, UISimpleAnimation, 61)
  self.animatorWinBannerArea = self.viewSkin:AddComponent(self, UIAnimator, 62)
  self.compWinBanner = self.viewSkin:AddComponent(self, UIBaseContainer, 63)
  self.compSeasonTowerGuideContent = self.viewSkin:AddComponent(self, UIBaseContainer, 64)
  self.textDialog = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 65)
  self.compSweepBtnEffPoint = self.viewSkin:AddComponent(self, UIBaseContainer, 66)
  self.rawImgSweepingMaxSpeedEffect02 = self.viewSkin:AddComponent(self, UIRawImage, 67)
  self.rawImgSweepingMaxSpeedEffect01 = self.viewSkin:AddComponent(self, UIRawImage, 68)
  self.btnGoto:SetSafeClickMode(true)
  self.btnSweep:SetSafeClickMode(true)
  self.stageItems = {}
  self.stageItemBgs = {}
  for i = 1, StageItemNum do
    local stageItem = self["compUISeasonTowerStageInfoItem" .. i]
    table.insert(self.stageItems, stageItem)
    local stageBgItem = self["imgCircleBg" .. i]
    table.insert(self.stageItemBgs, stageBgItem)
  end
  self.areaScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.areaScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.change100RecruitEff = self:AddComponent(UIVfx, "Root/BottomBar/BtnPanel/SweepBtn/SweepBtnEffPoint", RECRUIT_100_BTN_CHANGE_EFF_PATH, {
    lifeType = UIVfxLifeType.Stay
  })
  self.sweepingScreenEffectList = {
    self.rawImgSweepingMaxSpeedEffect01,
    self.rawImgSweepingMaxSpeedEffect02,
    self.rawImgSweepingMaxSpeedEffect03
  }
end

function UISeasonTowerMainView:ComponentDestroy()
  self:StopAllSound()
  self:ClearGuideFinger()
  self:ClearGuideTimer()
  self:ClearBattleTimer()
  self.compSpecialItemParent:RemoveComponent(UICommonResItem)
  if self.specialItemReq then
    self:GameObjectDestroy(self.specialItemReq)
    self.specialItemReq = nil
  end
  self.stageItems = {}
  self.stageItemBgs = {}
  self:ClearScroll()
  self.viewSkin = nil
  self.textTime = nil
  self.btnBack = nil
  self.btnGoto = nil
  self.btnSweep = nil
  self.btnStopSweep = nil
  self.btnSetting = nil
  self.textAllFinish = nil
  self.btnRank = nil
  self.btnSelfBuff = nil
  self.btnEnvBuff = nil
  self.compResItem = nil
  self.textNumTxt = nil
  self.textTitle = nil
  self.imgArrowDown = nil
  self.imgArrowUp = nil
  self.compContentArea = nil
  self.areaScrollView = nil
  self.btnTitleArea = nil
  self.imgAllBuffIcon = nil
  self.btnAreaMask = nil
  self.btnRewardPanel = nil
  self.textStrengthTitle = nil
  self.imgCircleBg1 = nil
  self.imgCircleBg2 = nil
  self.imgCircleBg3 = nil
  self.imgCircleBg4 = nil
  self.imgCircleBg5 = nil
  self.imgCircleBg6 = nil
  self.imgCircleBg7 = nil
  self.compUISeasonTowerStageInfoItem1 = nil
  self.compUISeasonTowerStageInfoItem2 = nil
  self.compUISeasonTowerStageInfoItem3 = nil
  self.compUISeasonTowerStageInfoItem4 = nil
  self.compUISeasonTowerStageInfoItem5 = nil
  self.compUISeasonTowerStageInfoItem6 = nil
  self.compUISeasonTowerStageInfoItem7 = nil
  self.compCenterItem = nil
  self.compRedDotWithoutNum = nil
  self.imgItemIcon = nil
  self.compMidContent = nil
  self.btnCard = nil
  self.textCardLevel = nil
  self.compBg = nil
  self.compCardEffect = nil
  self.compCenterItemEffect = nil
  self.textStageNowNumEffect = nil
  self.simpleAnimationStageNowNumEffect = nil
  self.btnInfo = nil
  self.compSpecialItemParent = nil
  self.textSpecialItemProgress = nil
  self.compSpecialItem = nil
  self.compSweepingEffect = nil
  self.textSweepingProgress = nil
  self.imgTipIcon = nil
  self.compPowerInfoEnemy = nil
  self.compPowerInfoSelf = nil
  self.textEnemyPowerNumber = nil
  self.textSelfPowerNumber = nil
  self.rawImgSweepingMaxSpeedEffect03 = nil
  self.compSweepingEffectParent = nil
  self.simpleAnimationSweepingEffect = nil
  self.animatorWinBannerArea = nil
  self.compWinBanner = nil
  self.compSeasonTowerGuideContent = nil
  self.textDialog = nil
  self.compSweepBtnEffPoint = nil
  self.rawImgSweepingMaxSpeedEffect02 = nil
  self.rawImgSweepingMaxSpeedEffect01 = nil
  self.change100RecruitEff = nil
end

function UISeasonTowerMainView:DataDefine()
  self.isShowArea = false
  self.isSweeping = false
  self.currentScore = DataCenter.LWSeasonTowerManager:GetScore()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData then
    self.isShowArea = DataCenter.LWSeasonTowerManager:IsDefaultShowArea(stageData.stageId)
    if self.isShowArea then
      DataCenter.LWSeasonTowerManager:SetDefaultShowAreaState(stageData.stageId, false)
    end
    self.currentFloor = stageData.floor
  else
    self.currentFloor = 0
  end
  self.lastStrength = -1
  self.finishClose = false
  self.noneLevelPass = true
  self.showLevelList = {}
end

function UISeasonTowerMainView:DataDestroy()
  self.isShowArea = false
  self.isSweeping = false
  self.currentScore = 0
  self.currentFloor = 0
  self.lastStrength = -1
  self.finishClose = false
  self.noneLevelPass = true
  self.showLevelList = {}
end

function UISeasonTowerMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonTowerStageInfoRefresh, self.SetData)
  self:AddUIListener(EventId.SeasonTowerDestroyEnemy, self.OnHitEnemy)
  self:AddUIListener(EventId.SeasonTowerSweepStageChange, self.OnSweepStageChanged)
  self:AddUIListener(EventId.BattleCardLevelChange, self.RefreshBattleCardLevel)
  self:AddUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshRewardEntry)
  self:AddUIListener(EventId.SeasonTowerDestroyEnemyFailed, self.OnHitEnemyFailed)
  self:AddUIListener(EventId.SeasonTowerShowGuideTips, self.OnShowGuideTips)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpen)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
end

function UISeasonTowerMainView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonTowerStageInfoRefresh, self.SetData)
  self:RemoveUIListener(EventId.SeasonTowerDestroyEnemy, self.OnHitEnemy)
  self:RemoveUIListener(EventId.SeasonTowerSweepStageChange, self.OnSweepStageChanged)
  self:RemoveUIListener(EventId.BattleCardLevelChange, self.RefreshBattleCardLevel)
  self:RemoveUIListener(EventId.SeasonTowerRewardRefresh, self.RefreshRewardEntry)
  self:RemoveUIListener(EventId.SeasonTowerDestroyEnemyFailed, self.OnHitEnemyFailed)
  self:RemoveUIListener(EventId.SeasonTowerShowGuideTips, self.OnShowGuideTips)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpen)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  base.OnRemoveListener(self)
end

function UISeasonTowerMainView:SetData()
  self:RefreshArea()
  self:RefreshRewardEntry()
  self:RefreshBattleCardLevel()
  self:OnSweepStageChanged({
    isSweeping = self.isSweeping,
    noneLevelPass = self.noneLevelPass,
    showLevelList = self.showLevelList
  })
  self:Update1000MS()
  self:CheckGuideStep()
end

function UISeasonTowerMainView:RefreshArea()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local template = stageData:GetTemplate()
  self.textTitle:SetLocalText(template.name)
  self.imgArrowDown:SetActive(self.isShowArea)
  self.imgArrowUp:SetActive(not self.isShowArea)
  self.compContentArea:SetActive(self.isShowArea)
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  self.areaScrollView:SetTotalCount(#stageList)
  self.areaScrollView:RefillCells()
  self:RefreshProgress()
  self:ShowEnvBuffTip()
  self:RefreshPowerInfo()
  self:RefreshBuff()
end

function UISeasonTowerMainView:RefreshBuff()
  local userBuffActive = DataCenter.LWSeasonTowerManager:IsUserBuffActive()
  local allBuffActive = DataCenter.LWSeasonTowerManager:IsAllBuffActive()
  self.btnSelfBuff:SetActive(userBuffActive)
  self.btnEnvBuff:SetActive(allBuffActive)
  if userBuffActive then
    self.btnSelfBuff:SetSprite(DataCenter.LWSeasonTowerManager:GetUserBuffIcon())
  end
  if allBuffActive then
    self.imgAllBuffIcon:LoadSprite(DataCenter.LWSeasonTowerManager:GetAllBuffIcon())
  end
end

function UISeasonTowerMainView:RefreshRewardEntry()
  self.textNumTxt:SetText(self.currentScore)
  self.compRedDotWithoutNum:SetActive(DataCenter.LWSeasonTowerManager:HasAnyRewardToClaim())
  self:RefreshSpecialItem()
end

function UISeasonTowerMainView:RefreshSpecialItem()
  local current, total = DataCenter.LWSeasonTowerManager:GetSpecialItemInfo()
  local isShow = current < total
  if isShow then
    if not self.specialItemReq then
      self.specialItemReq = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item"
        item:SetActive(true)
        item.transform:SetParent(self.compSpecialItemParent.transform)
        item.transform:Set_localScale(0.7, 0.7, 1)
        item.transform:Set_sizeDelta(150, 150)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.compSpecialItemParent:AddComponent(UICommonResItem, item.name)
        local param = {}
        param.rewardType = RewardType.GOODS
        param.itemId = DataCenter.LWSeasonTowerManager:GetGroupRewardSpecialItem()
        cell:ReInit(param)
        cell:SetAnchoredPositionXY(54, -54)
      end)
    end
    self.textSpecialItemProgress:SetText(current .. "/" .. total)
  end
  self.compSpecialItem:SetActive(isShow and not self.isSweeping)
end

function UISeasonTowerMainView:RefreshBattleCardLevel()
  self.textCardLevel:SetText(DataCenter.LWSeasonTowerManager.battleCardTotalLevel)
end

function UISeasonTowerMainView:RefreshProgress()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  local floor = self.currentFloor
  if floor + 1 <= stageData:GetMaxFloor() then
    floor = floor + 1
  end
  self.textStrengthTitle:SetText(Localization:GetString("season_tower_difficulty"))
  for i = 1, StageItemNum do
    if i <= 4 - floor or i >= 2005 - floor then
      self.stageItems[i]:SetActive(false)
      self.stageItemBgs[i]:SetActive(false)
    else
      self.stageItems[i]:SetActive(true)
      self.stageItemBgs[i]:SetActive(true)
      self.stageItems[i]:SetData(floor + i - 4, false)
    end
  end
  self.compCenterItem:SetData(floor, true)
  local isAllFinish = stageData:GetMaxFloor() <= self.currentFloor
  self.btnGoto:SetActive(not isAllFinish)
  self.btnSweep:SetActive(not isAllFinish and DataCenter.LWSeasonTowerManager:IsShowSweepBtn())
  self.textAllFinish:SetActive(isAllFinish)
end

function UISeasonTowerMainView:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = DataCenter.LWSeasonTowerManager:GetEndTime()
  local leftTime = math.max(endTime - curTime, 0)
  local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textTime:SetText(leftTimeStr)
  self:CheckGuideShow()
end

function UISeasonTowerMainView:OnBtnBackClick()
  DataCenter.LWSeasonTowerSceneManager:Exit()
  self.ctrl:CloseSelf()
end

function UISeasonTowerMainView:OnBtnGotoClick()
  if self.isSweeping then
    UIUtil.ShowTipsId("season_tower_battle_ing")
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local army = stageData:GetArmy()
  if army == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, stageData.floor)
  if difficultyTemplate == nil then
    return
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.SeasonTower
  param.levelId = army.armyId
  param.sceneId = difficultyTemplate.battle_show
  param.extraData = {
    stageId = stageData.stageId
  }
  DataCenter.LWSeasonTowerSceneManager:ExitBeforeBattle()
  DataCenter.LWBattleManager:Enter(param)
end

function UISeasonTowerMainView:DoSweep()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  self.isSweeping = true
  DataCenter.LWSeasonTowerManager:Battle(stageData.stageId, SeasonTowerConfig.BattleType.Sweep)
end

function UISeasonTowerMainView:OnBtnSweepClick()
  if self.isSweeping then
    UIUtil.ShowTipsId("season_tower_battle_ing")
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local formation = DataCenter.LWSeasonTowerManager:GetFormation(stageData.stageId)
  if formation:GetLocalHeroesCount() == 0 then
    UIUtil.ShowTipsId("all_squad_empty_warning")
    return
  end
  if formation:GetLocalHeroesCount() < 5 then
    local param = {
      contentText = Localization:GetString("season_tower_battle_quick_tips"),
      btnNum = 2,
      confirmBtnParam = {
        action = function()
          self:OnBtnSettingClick()
        end
      },
      cancelBtnParam = {
        action = function()
          self:DoSweep()
        end
      }
    }
    UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.SeasonTowerSweepTipSecondConfirm, param)
  else
    self:DoSweep()
  end
end

function UISeasonTowerMainView:OnBtnStopSweepClick()
end

function UISeasonTowerMainView:OnBtnSettingClick()
  if self.isSweeping then
    UIUtil.ShowTipsId("season_tower_battle_ing")
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local army = stageData:GetArmy()
  if army == nil then
    return
  end
  local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, stageData.floor)
  if difficultyTemplate == nil then
    return
  end
  local param = {}
  param.type = PVEType.FakePVP
  param.enterType = PVEEnterType.SeasonTower
  param.levelId = army.armyId
  param.sceneId = difficultyTemplate.battle_show
  param.extraData = {
    stageId = stageData.stageId
  }
  DataCenter.LWSeasonTowerSceneManager:ExitBeforeBattle()
  DataCenter.LWBattleManager:Enter(param)
end

function UISeasonTowerMainView:OnBtnRankClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISeasonTowerRank, {anim = true})
end

function UISeasonTowerMainView:OnBtnSelfBuffClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerBuffPanel, {anim = true}, {
    buffType = SeasonTowerConfig.BuffType.User
  })
end

function UISeasonTowerMainView:OnBtnEnvBuffClick()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData then
    DataCenter.LWSeasonTowerManager:SetEnvBuffShowState(stageData.stageId, false)
    self:ShowEnvBuffTip()
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerBuffPanel, {anim = true}, {
    buffType = SeasonTowerConfig.BuffType.All
  })
end

function UISeasonTowerMainView:OnBtnRewardPanelClick()
  if self.isSweeping then
    UIUtil.ShowTipsId("season_tower_battle_ing")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUISeasonTowerReward, {anim = true})
end

function UISeasonTowerMainView:OnBtnTitleAreaClick()
  self.isShowArea = not self.isShowArea
  self:RefreshArea()
end

function UISeasonTowerMainView:OnBtnAreaMaskClick()
  self.isShowArea = false
  self:RefreshArea()
end

function UISeasonTowerMainView:ClearScroll()
  self.areaScrollView:ClearCells()
  self.areaScrollView:RemoveComponents(SeasonTowerSelectItemComponent)
end

function UISeasonTowerMainView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.areaScrollView:AddComponent(SeasonTowerSelectItemComponent, itemObj)
  local stageList = DataCenter.LWSeasonTowerManager.stageList
  local param = {}
  param.data = stageList[index]
  param.index = index
  
  function param.selectFunc(i)
    local stageIndex = DataCenter.LWSeasonTowerManager:GetSelectStageIndex()
    if i ~= stageIndex then
      DataCenter.LWSeasonTowerManager:SetSelectStageIndex(i)
      EventManager:GetInstance():Broadcast(EventId.SeasonTowerStageChanged)
      local stageData = DataCenter.LWSeasonTowerManager:GetStageDataByIndex(i)
      if stageData then
        self.currentFloor = stageData.floor
      else
        self.currentFloor = 0
      end
      self.currentScore = DataCenter.LWSeasonTowerManager:GetScore()
    end
    self.isShowArea = false
    self:RefreshArea()
  end
  
  param.selectIndex = DataCenter.LWSeasonTowerManager:GetSelectStageIndex()
  param.parentType = SeasonTowerConfig.SelectItemUI.Main
  item:SetData(param)
end

function UISeasonTowerMainView:OnDeleteCell(itemObj, index)
  self.areaScrollView:RemoveComponent(itemObj.name, SeasonTowerSelectItemComponent)
end

function UISeasonTowerMainView:OnHitEnemy(data)
  local level = data.level or 1
  local levelFloor = data.levelFloor or 0
  self:FlyReward(level)
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData then
    local template = stageData:GetTemplate()
    local nextFloor = levelFloor + self.currentFloor
    self.currentScore = self.currentScore + template:GetTotalScore(self.currentFloor, nextFloor)
    self.currentFloor = nextFloor
    self.sweepingEffectNum = (self.sweepingEffectNum or 0) + levelFloor
    self.simpleAnimationSweepingEffect:Stop()
    self.simpleAnimationSweepingEffect:Play("number")
    self.textSweepingProgress:SetText("\195\151" .. self.sweepingEffectNum)
    self:ShowSweepingCarEffect(level)
    self:OnBattleWin()
  end
  self:RefreshProgress()
  self:RefreshRewardEntry()
  self.hitSoundId = DataCenter.LWSoundManager:PlaySound(SeasonTowerConfig.Sound.HitSound[tonumber(level)], false, true)
  if self.sweepSoundId then
    DataCenter.LWSoundManager:StopSound(self.sweepSoundId)
  end
  self.sweepSoundId = DataCenter.LWSoundManager:PlaySound(SeasonTowerConfig.Sound.SweepSound[tonumber(level)], true)
end

function UISeasonTowerMainView:OnHitEnemyFailed(level)
  self.simpleAnimationSweepingEffect:Stop()
  self.simpleAnimationSweepingEffect:Play("moveout")
  if level == -1 then
    level = 1
  end
  self.hitFailedSoundId = DataCenter.LWSoundManager:PlaySound(SeasonTowerConfig.Sound.HitFailedSound[tonumber(level)], false)
end

function UISeasonTowerMainView:OnSweepStageChanged(data)
  local state = data.isSweeping
  self.isSweeping = state
  self.noneLevelPass = data.noneLevelPass
  self.showLevelList = data.showLevelList
  self.compMidContent:SetActive(not state)
  self.compBg:SetActive(not state)
  self.compCenterItemEffect:SetActive(state)
  self:StopAllSound()
  if not state then
    self.sweepingEffectNum = 0
    self:ShowSweepingCarEffect()
  elseif not data.noneLevelPass then
    self.simpleAnimationSweepingEffect:Stop()
    self.simpleAnimationSweepingEffect:Play("movein")
    if data.showLevelList then
      self:ShowSweepingCarEffect(data.showLevelList[1])
    end
  end
  self.compSweepingEffect:SetActive(self.isSweeping and not self.noneLevelPass)
  self.btnGoto:LoadSprite(not state and UIAssets.GREEN_BTN or UIAssets.GREY_BTN)
  self.btnSweep:LoadSprite(not state and UIAssets.GREEN_BTN or UIAssets.GREY_BTN)
  self:RefreshSpecialItem()
  self:RefreshCardEffect()
  self:RefreshPowerInfo()
end

function UISeasonTowerMainView:ShowSweepingCarEffect(level)
  for _, v in ipairs(self.sweepingScreenEffectList) do
    v:SetActive(false)
  end
  if self.carEffectReq then
    self:GameObjectDestroy(self.carEffectReq)
    self.carEffectReq = nil
  end
  if not self.isSweeping then
    return
  end
  if level == nil then
    return
  end
  if self.sweepingScreenEffectList[level] then
    self.sweepingScreenEffectList[level]:SetActive(true)
  end
  self.carEffectReq = self:GameObjectInstantiateAsync(string.format(Car_Effect_Path, level), function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    obj:SetActive(self.isSweeping)
    obj.transform:SetParent(self.compSweepingEffectParent.transform)
    obj.transform:Set_anchoredPosition(0, 0)
    obj.transform:Set_localEulerAngles(0, 0, 0)
    obj.transform:Set_localScale(1, 1, 1)
    if CommonUtil.IsArabicAutoMirrorOpen() then
      obj.transform:Set_localScale(-1, 1, 1)
    else
      obj.transform:Set_localScale(1, 1, 1)
    end
    obj.transform:Set_anchoredPosition(0, 0)
  end)
end

function UISeasonTowerMainView:OnBattleWin()
  self.compWinBanner:SetActive(true)
  self.animatorWinBannerArea:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
  self:ClearBattleTimer()
  self.showBattleTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.compWinBanner then
      self.compWinBanner:SetActive(false)
    end
  end, 1.8)
end

function UISeasonTowerMainView:ClearBattleTimer()
  if self.showBattleTimer then
    self.showBattleTimer:Stop()
    self.showBattleTimer = nil
  end
end

function UISeasonTowerMainView:FlyReward(level)
  if self.imgItemIcon == nil then
    return
  end
  local img = self.imgItemIcon.transform
  local pic = "Assets/Main/Sprites/UI/LWUISeasonTower/FX_S6yuanzheng_jifeng_icon.png"
  local centerScreenPos = Vector2.New(Screen.width * 0.5, Screen.height * 0.5 + 200)
  local success, startPos = CS.UnityEngine.RectTransformUtility.ScreenPointToWorldPointInRectangle(CS.GameEntry.UIContainer, centerScreenPos, CS.GameEntry.UICamera)
  if not success then
    startPos = img.position
  end
  local num = FlyNumConfig[level]
  startPos.y = startPos.y
  UIUtil.DoFly(RewardType.GOODS, num, pic, startPos, img.position, 50, 50, nil, nil)
end

function UISeasonTowerMainView:OnBtnCardClick()
  if self.isSweeping then
    UIUtil.ShowTipsId("season_tower_battle_ing")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonTowerCardPanel, {anim = true})
end

function UISeasonTowerMainView:OnBtnInfoClick()
  DataCenter.LWSeasonTowerManager:OpenRule()
end

function UISeasonTowerMainView:ShowEnvBuffTip()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  self.imgTipIcon:SetActive(DataCenter.LWSeasonTowerManager:IsShowEnvBuffTip(stageData.stageId))
end

function UISeasonTowerMainView:GetSeasonTowerSceneRefs()
  local sceneMgr = DataCenter.LWSeasonTowerSceneManager
  local logic = sceneMgr and sceneMgr.logic or nil
  local cameraLogic = logic and logic.cameraLogic or nil
  local sceneCamera = cameraLogic and cameraLogic.camera or nil
  if logic == nil or sceneCamera == nil then
    return nil, nil
  end
  return logic, sceneCamera
end

function UISeasonTowerMainView:GetEnemyRoot(logic, squadRoot)
  if logic == nil or table.IsNullOrEmpty(logic.enemyList) then
    return nil
  end
  local squadPosZ
  if squadRoot ~= nil then
    local _, _, z = squadRoot.transform:Get_position()
    squadPosZ = z
  end
  local targetEnemy
  local minDistance = math.huge
  for _, enemy in pairs(logic.enemyList) do
    local enemyRoot = enemy and enemy.armyRoot or nil
    if enemyRoot ~= nil and enemy.alive then
      if squadPosZ == nil then
        return enemyRoot
      end
      local _, _, enemyPosZ = enemyRoot.transform:Get_position()
      local distance = math.abs(enemyPosZ - squadPosZ)
      if squadPosZ <= enemyPosZ and minDistance > distance then
        minDistance = distance
        targetEnemy = enemyRoot
      end
    end
  end
  return targetEnemy
end

function UISeasonTowerMainView:SetPowerInfoPosition(comp, worldPos, sceneCamera, offset)
  if comp == nil or worldPos == nil or sceneCamera == nil then
    return
  end
  local viewportPos = sceneCamera:WorldToViewportPoint(worldPos)
  if viewportPos == nil or viewportPos.z <= 0 then
    comp:SetActive(false)
    return
  end
  local parentRect = comp.transform.parent
  if parentRect == nil then
    return
  end
  local screenPos = PosConverse.WorldToScreenPos(worldPos, sceneCamera)
  local uiPos = PosConverse.ScreenToUIPos(parentRect, screenPos)
  comp:SetActive(true)
  comp:SetAnchoredPositionXY(uiPos.x, uiPos.y + offset)
end

function UISeasonTowerMainView:UpdatePowerInfoPosition()
  if self.compPowerInfoSelf == nil or self.compPowerInfoEnemy == nil then
    return
  end
  local logic, sceneCamera = self:GetSeasonTowerSceneRefs()
  if logic == nil or sceneCamera == nil then
    return
  end
  local squadRoot = logic:GetSquadRoot()
  if squadRoot ~= nil and self.textSelfPowerNumber ~= nil then
    local squadPos = squadRoot.transform.position
    squadPos.y = squadPos.y + PowerInfoWorldOffsetY
    self:SetPowerInfoPosition(self.compPowerInfoSelf, squadPos, sceneCamera, 170)
  end
  local enemyRoot = self:GetEnemyRoot(logic, squadRoot)
  if enemyRoot ~= nil and self.textEnemyPowerNumber ~= nil then
    local enemyPos = enemyRoot.transform.position
    enemyPos.y = enemyPos.y + PowerInfoWorldOffsetY
    self:SetPowerInfoPosition(self.compPowerInfoEnemy, enemyPos, sceneCamera, 120)
  end
end

function UISeasonTowerMainView:RefreshPowerInfo()
  self.compPowerInfoSelf:SetActive(false)
  self:RefreshMyPowerInfo()
  self.compPowerInfoEnemy:SetActive(false)
  self:RefreshEnemyPowerInfo()
  self:UpdatePowerInfoPosition()
end

function UISeasonTowerMainView:RefreshMyPowerInfo()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local myFormation = DataCenter.LWSeasonTowerManager:GetFormation(stageData.stageId)
  if stageData == nil then
    return
  end
  self.compPowerInfoSelf:SetActive(true)
  self.textSelfPowerNumber:SetText(string.GetFormattedStr(myFormation:GetSeasonTowerTotalCapacity()))
end

function UISeasonTowerMainView:RefreshEnemyPowerInfo()
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local power = 0
  local floor = math.max(1, self.currentFloor or stageData.floor or 0)
  local armyTemplate = stageData:GetArmyTemplateByFloor(floor + 1)
  if armyTemplate == nil then
    return
  end
  if armyTemplate and armyTemplate.pve_power then
    for _, value in ipairs(armyTemplate.pve_power) do
      power = power + (tonumber(value) or 0)
    end
  end
  self.compPowerInfoEnemy:SetActive(true)
  self.textEnemyPowerNumber:SetText(string.GetFormattedStr(math.floor(power)))
end

function UISeasonTowerMainView:RefreshCardEffect()
  if self.effectReq then
    self:GameObjectDestroy(self.effectReq)
    self.effectReq = nil
  end
  if not self.isSweeping then
    return
  end
  local path = DataCenter.LWSeasonTowerManager:GetCardEffectPath()
  if path == nil then
    return
  end
  self.effectReq = self:GameObjectInstantiateAsync(path, function(req)
    if req.isError then
      return
    end
    local obj = req.gameObject
    obj:SetActive(self.isSweeping)
    obj.transform:SetParent(self.compCardEffect.transform)
    obj.transform:Set_localPosition(0, 0, 0)
    obj.transform:Set_localEulerAngles(0, 0, 0)
    obj.transform:Set_localScale(1, 1, 1)
  end)
end

function UISeasonTowerMainView:CheckGuideShow()
  if DataCenter.LWSeasonTowerManager:HasAnyStageChallenged() then
    return
  end
  self.tickTime = (self.tickTime or 0) + 1
  if self.tickTime >= 10 then
    self:ShowGuideFinger(self.btnGoto)
    self.tickTime = 0
  end
end

function UISeasonTowerMainView:ClearGuideTimer()
  if self.guideTimer then
    self.guideTimer:Stop()
    self.guideTimer = nil
  end
  if self.delayDestroyFingerTimer then
    self.delayDestroyFingerTimer:Stop()
    self.delayDestroyFingerTimer = nil
  end
end

function UISeasonTowerMainView:OnShowGuideTips(data)
  local state = data.state
  if state then
    self.compSeasonTowerGuideContent:SetActive(true)
    self.textDialog:SetLocalText(data.key)
    self:ClearGuideTimer()
    self.guideTimer = TimerManager:GetInstance():DelayInvoke(function()
      if not self.compSeasonTowerGuideContent then
        return
      end
      self.compSeasonTowerGuideContent:SetActive(false)
    end, 5)
  else
    self.compSeasonTowerGuideContent:SetActive(false)
  end
end

function UISeasonTowerMainView:OnWindowOpen(windowName)
  self:OnShowGuideTips({state = false})
end

function UISeasonTowerMainView:OnWindowClosed(windowName)
  if windowName == UIWindowNames.UILWCloud then
    self:CheckSweepBtnUnlock()
  end
end

function UISeasonTowerMainView:CheckGuideStep()
  self:OnShowGuideTips({state = false})
  if not DataCenter.LWGuideFlowManager:ReadDone(SeasonTowerConfig.GuideData.GuideId.STEP_2) and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActivityDetailPopup) then
    EventManager:GetInstance():Broadcast(EventId.GF_season_tower_trigger, {
      trigger_id = SeasonTowerConfig.GuideData.TriggerId.EnterMain
    })
  elseif not DataCenter.LWGuideFlowManager:ReadDone(SeasonTowerConfig.GuideData.GuideId.STEP_5) and DataCenter.LWSeasonTowerManager:HasAnyStageChallenged() then
    EventManager:GetInstance():Broadcast(EventId.GF_season_tower_trigger, {
      trigger_id = SeasonTowerConfig.GuideData.TriggerId.BattleSuccess
    })
  end
end

function UISeasonTowerMainView:CheckSweepBtnUnlock()
  local state = DataCenter.LWSeasonTowerManager:CheckSweepBtnUnlock()
  if state then
    self:OnShowGuideTips({
      state = true,
      key = "season_tower_guide_tips2",
      component = self.btnSweep
    })
    self.change100RecruitEff:Replay()
  else
    self.change100RecruitEff:Stop()
  end
end

function UISeasonTowerMainView:ShowGuideFinger(component)
  self:ClearGuideFinger()
  self.clickFingerHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab")
  self.clickFingerHandle:completed("+", function(handle)
    if handle.isError then
      return
    end
    CommonUtil.CallAutoArabicMirrorManually(handle)
    local gameObject = handle.gameObject
    local transform = gameObject.transform
    transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Background.Name).transform, false)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    transform.position = component.transform.position
    if self.delayDestroyFingerTimer then
      self.delayDestroyFingerTimer:Stop()
      self.delayDestroyFingerTimer = nil
    end
    self.delayDestroyFingerTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ClearGuideFinger()
    end, 3)
  end)
end

function UISeasonTowerMainView:ClearGuideFinger()
  if not IsNull(self.clickFingerHandle) then
    self.clickFingerHandle:Destroy()
    self.clickFingerHandle = nil
  end
end

function UISeasonTowerMainView:StopAllSound()
  if self.hitFailedSoundId then
    DataCenter.LWSoundManager:StopSound(self.hitFailedSoundId)
  end
  if self.sweepSoundId then
    DataCenter.LWSoundManager:StopSound(self.sweepSoundId)
  end
  if self.hitSoundId then
    DataCenter.LWSoundManager:StopSound(self.hitSoundId)
  end
end

return UISeasonTowerMainView
