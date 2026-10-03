local UIJeepAdventureMainView = BaseClass("UIJeepAdventureMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIJeepAdventureMainStageItem = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainStageItem")
local UIJeepAdventureMainPageBtn = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainPageBtn")
local UIJeepAdventureMainSkillPanel = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainSkillPanel")
local UIJeepAdventureMainSpeedPanel = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainSpeedPanel")
local UIJeepAdventureMainMultiKillEffect = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainMultiKillEffect")
local UIJeepAdventureMainFirstRewardPanel = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainFirstRewardPanel")
local StageItemNum = 8
local NowStageIndex = 4
local PageSetting = {
  [JeepAdventurePageType.TowerUp] = {
    ProgressImgPath = "lrb_guaji_kache_guanqia_tiao"
  },
  [JeepAdventurePageType.Domintor] = {
    ProgressImgPath = "lrb_guaji_zhuzai_guanqia_tiao"
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.btnInfo = self:AddComponent(UIButton, "Root/TopBar/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnBack = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnGoto = self:AddComponent(UIButton, "Root/BottomBar/BtnPanel/GotoBtn")
  self.btnGoto:SetOnClick(function()
    self:OnBtnGotoClick()
  end)
  self.textSweep = self:AddComponent(UIText, "Root/BottomBar/BtnPanel/SweepBtn/SweepBtnText")
  self.btnSweep = self:AddComponent(UIButton, "Root/BottomBar/BtnPanel/SweepBtn")
  self.btnSweep:SetOnClick(function()
    self:OnBtnSweepClick()
  end)
  self.textStopSweep = self:AddComponent(UIText, "Root/BottomBar/BtnPanel/StopSweepBtn/StopSweepBtnText")
  self.btnStopSweep = self:AddComponent(UIButton, "Root/BottomBar/BtnPanel/StopSweepBtn")
  self.btnStopSweep:SetOnClick(function()
    self:OnBtnStopSweepClick()
  end)
  self.textGoto = self:AddComponent(UIText, "Root/BottomBar/BtnPanel/GotoBtn/GotoBtnText")
  self.textAllFinish = self:AddComponent(UIText, "Root/BottomBar/BtnPanel/AllFinishText")
  self.textAllFinish:SetLocalText("jeep_levels_coming_soon")
  self.imgFill = self:AddComponent(UIImage, "Root/BottomBar/rewardContent/CircleSlider/FillArea/Fill")
  self.btnReward = self:AddComponent(UIButton, "Root/BottomBar/rewardContent/rewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.compRedPoint = self:AddComponent(UIBaseContainer, "Root/BottomBar/rewardContent/RedPoint")
  self.btnRank = self:AddComponent(UIButton, "Root/MidContent/rankBtn")
  self.btnRank:SetOnClick(function()
    self:OnBtnRankClick()
  end)
  self.textRank = self:AddComponent(UIText, "Root/MidContent/rankBtn/rankBtnText")
  self.compCellBgRoot = self:AddComponent(UIBaseContainer, "Root/MidContent/StageProgress/Bg/CellBgRoot")
  self.imgLineProgress = self:AddComponent(UIImage, "Root/MidContent/StageProgress/Bg/LineBg/LineProgress")
  self.compCellRoot = self:AddComponent(UIBaseContainer, "Root/MidContent/StageProgress/Bg/CellRoot")
  self.compZhuzaiBtn = self:AddComponent(UIJeepAdventureMainPageBtn, "Root/MidContent/PagePanel/ZhuzaiBtn")
  self.compHuocheBtn = self:AddComponent(UIJeepAdventureMainPageBtn, "Root/MidContent/PagePanel/HuocheBtn")
  self.compSkillBg = self:AddComponent(UIJeepAdventureMainSkillPanel, "Root/MidContent/SkillBg")
  self.compSpeedBg = self:AddComponent(UIJeepAdventureMainSpeedPanel, "Root/MidContent/SpeedBg")
  self.textTitle:SetLocalText(456801)
  self.textGoto:SetLocalText(456802)
  self.textRank:SetLocalText(456813)
  self.textSweep:SetLocalText("armed_truck_reward_auto_battle")
  self.textStopSweep:SetLocalText("armed_truck_reward_stop_btn")
  self.compSkillBg:SetActive(false)
  self.compSpeedBg:Refresh()
  self.stageItems = {}
  self.stageItemBgs = {}
  for i = 1, StageItemNum do
    local stageItem = self:AddComponent(UIJeepAdventureMainStageItem, "Root/MidContent/StageProgress/Bg/CellRoot/StageInfoItem" .. i)
    table.insert(self.stageItems, stageItem)
    local stageBgItem = self:AddComponent(UIImage, "Root/MidContent/StageProgress/Bg/CellBgRoot/StageInfoItemBg" .. i)
    table.insert(self.stageItemBgs, stageBgItem)
  end
  self.compHuocheBtn:SetData(JeepAdventurePageType.TowerUp, Bind(self, self.SelectTab))
  self.compZhuzaiBtn:SetData(JeepAdventurePageType.Domintor, Bind(self, self.SelectTab))
  self.topEffect = self:AddComponent(UIBaseComponent, "Root/TopEffect")
  self.topEffect:SetActive(false)
  self.speedUpEffect = self:AddComponent(UIBaseContainer, "Root/TopEffect/Eff_UI_suduxian")
  local ScreenSize = self.rectTransform.rect
  local scaleWidth = ScreenSize.width / DefaultScreenWidth
  local scaleHeight = ScreenSize.height / DefaultScreenHeight
  self.speedUpEffect:SetLocalScaleXYZ(scaleWidth, scaleHeight, 1)
  self.compPagePanel = self:AddComponent(UIBaseContainer, "Root/MidContent/PagePanel")
  self.compMultiKillEffect = self:AddComponent(UIJeepAdventureMainMultiKillEffect, "Root/MidContent/MultiKillEff")
  self.compMultiKillEffect:SetData(99999)
  self.compMultiKillEffect:Refresh(0)
  self.compFirstRewardPanel = self:AddComponent(UIJeepAdventureMainFirstRewardPanel, "Root/MidContent/FirstRewardPanel")
  self.compFirstRewardPanel:SetActive(false)
  self.centerItem = self:AddComponent(UIJeepAdventureMainStageItem, "Root/MidContent/StageProgress/CenterItem")
  self.victoryEffect = self:AddComponent(UIBaseContainer, "Root/MidContent/StageProgress/VictoryEffect")
  self.victoryEffect:SetActive(false)
  self.cellBgRootBeginX = self.compCellBgRoot:GetAnchoredPositionX()
  self.cellRootBeginX = self.compCellRoot:GetAnchoredPositionX()
end

local function ComponentDestroy(self)
  self.stageItems = nil
  self.stageItemBgs = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.btnBack = nil
  self.btnGoto = nil
  self.imgFill = nil
  self.btnReward = nil
  self.compRedPoint = nil
  self.btnRank = nil
  self.compCellBgRoot = nil
  self.imgLineProgress = nil
  self.compCellRoot = nil
  self.compZhuzaiBtn = nil
  self.compHuocheBtn = nil
  self.compSkillBg = nil
  self.compSpeedBg = nil
  self.speedUpEffect = nil
  self.compPagePanel = nil
  self.compMultiKillEffect = nil
  self.compFirstRewardPanel = nil
  self.centerItem = nil
  self.victoryEffect = nil
  self.cellBgRootBeginX = nil
  self.cellRootBeginX = nil
end

local function DataDefine(self)
  self.pageType = nil
  self.triggerGuide = nil
  self:CheckGuide()
  local tab = JeepAdventurePageType.TowerUp
  local mark = DataCenter.LWJeepAdventureManager:GetBattleBackMark()
  if mark then
    tab = DataCenter.LWJeepAdventureManager.pageType
  end
  self:RefreshTab(tab)
end

local function DataDestroy(self)
  self.pageType = nil
  self.triggerGuide = nil
  self.killNum = nil
  self.inSweep = nil
  DataCenter.TowerUpSaveDataManager:SetOneKeySweep(false)
  self:ClearTween()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HummerSceneTrigger, self.OnHummerSceneTrigger)
  self:AddUIListener(EventId.HummerSceneSpeedLevel, self.OnHummerSceneSpeedLevel)
  self:AddUIListener(EventId.ReveiveDominatorUpFirstReward, self.OnReveiveDominatorUpFirstReward)
  self:AddUIListener(EventId.ReveiveTowerUpFirstReward, self.OnReveiveTowerUpFirstReward)
  self:AddUIListener(EventId.JeepAdventureAddMultiKill, self.OnJeepAdventureAddMultiKill)
  self:AddUIListener(EventId.JeepAdventureFastSweep, self.OnTowerupFakePVPBattleDataGet)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HummerSceneTrigger, self.OnHummerSceneTrigger)
  self:RemoveUIListener(EventId.HummerSceneSpeedLevel, self.OnHummerSceneSpeedLevel)
  self:RemoveUIListener(EventId.ReveiveDominatorUpFirstReward, self.OnReveiveDominatorUpFirstReward)
  self:RemoveUIListener(EventId.ReveiveTowerUpFirstReward, self.OnReveiveTowerUpFirstReward)
  self:RemoveUIListener(EventId.JeepAdventureAddMultiKill, self.OnJeepAdventureAddMultiKill)
  self:RemoveUIListener(EventId.JeepAdventureFastSweep, self.OnTowerupFakePVPBattleDataGet)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  local param = DataCenter.LWJeepAdventureManager:GetDetailParam(self.pageType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

local function OnBtnBackClick(self)
  if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    self:StopOneKeySweep()
  else
    DataCenter.LWHummerSceneManager:Exit()
  end
end

local function OnBtnGotoClick(self)
  DataCenter.LWHummerSceneManager:ExitBeforeBattle()
  DataCenter.LWJeepAdventureManager:EnterBattle(self.curStageId + 1, self.pageType)
end

local function OnBtnRewardClick(self)
  local function innerFunc()
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 0)
  end
  
  if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    self:StopOneKeySweep(innerFunc)
  else
    innerFunc()
  end
end

local function OnBtnRankClick(self)
  local function innerFunc()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true, hideTop = false}, 0, DataCenter.LWJeepAdventureManager:GetRankTypeByPageType(self.pageType))
  end
  
  if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    self:StopOneKeySweep(innerFunc)
  else
    innerFunc()
  end
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeDelta = curTime - DataCenter.StageManager.lastIdleRewardTimeStamp
  local maxTime = DataCenter.StageManager.hangUpMaxTime
  local curNum = timeDelta
  local maxNum = maxTime
  local percent = curNum / maxNum
  percent = math.max(0, math.min(percent, 1))
  self.imgFill:SetFillAmount(percent)
end

local function Refresh(self)
  self.curStageId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(self.pageType)
  local midStageId = self.curStageId + 1
  local nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(midStageId, self.pageType)
  if nextTemplate == nil then
    midStageId = self.curStageId
  end
  for i = 1, StageItemNum do
    local stageId = midStageId + (i - NowStageIndex)
    local cfg = DataCenter.LWJeepAdventureManager:GetStageMetaByType(stageId, self.pageType)
    if cfg == nil then
      self.stageItems[i]:SetActive(false)
      self.stageItemBgs[i]:SetActive(false)
    else
      self.stageItems[i]:SetActive(true)
      self.stageItemBgs[i]:SetActive(true)
      self.stageItems[i]:SetData(cfg, self.pageType, i <= NowStageIndex and JeepStageItemType.Finished or JeepStageItemType.UnFinished)
      if cfg.isElite then
        self.stageItemBgs[i]:LoadSprite("Assets/Main/Sprites/UI/UIJeepAdventureNew/lrb_guaji_kache_guanqiadian_boss_bg.png")
      else
        self.stageItemBgs[i]:LoadSprite("Assets/Main/Sprites/UI/UIJeepAdventureNew/lrb_guaji_kache_guanqiadian_bg.png")
      end
    end
  end
  self.centerItem:SetData(DataCenter.LWJeepAdventureManager:GetStageMetaByType(midStageId, self.pageType), self.pageType, JeepStageItemType.Center)
  self.imgLineProgress:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, PageSetting[self.pageType].ProgressImgPath))
  if LuaEntry.DataConfig:CheckSwitch("truck_first_reward") and not DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    self.compFirstRewardPanel:SetActive(true)
    self.compFirstRewardPanel:Refresh(self.pageType)
  else
    self.compFirstRewardPanel:SetActive(false)
  end
  self:RefreshBtnPanel(nextTemplate == nil)
end

local function RefreshTab(self, pageType)
  local domintorUnlock = DataCenter.DomintorStageManager:IsShow()
  if not domintorUnlock then
    self.compZhuzaiBtn:SetActive(false)
    pageType = JeepAdventurePageType.TowerUp
  else
    self.compZhuzaiBtn:SetActive(true)
    if DataCenter.DomintorStageManager:IsUnlock() then
      CS.UIGray.SetGray(self.compZhuzaiBtn.transform, false, true)
    else
      CS.UIGray.SetGray(self.compZhuzaiBtn.transform, true, true)
      pageType = JeepAdventurePageType.TowerUp
    end
  end
  self:SelectTab(pageType)
end

local function SelectTab(self, pageType)
  local function innerFunc()
    if self.pageType == pageType then
      return
    end
    if pageType == JeepAdventurePageType.TowerUp then
      self.compHuocheBtn:SetSelect()
      self.compZhuzaiBtn:SetUnSelect()
      self.pageType = pageType
      self:Refresh()
      EventManager:GetInstance():Broadcast(EventId.JeepAdventureChangePage, self.pageType)
    elseif pageType == JeepAdventurePageType.Domintor then
      if DataCenter.DomintorStageManager:IsUnlock() then
        self.compZhuzaiBtn:SetSelect()
        self.compHuocheBtn:SetUnSelect()
        self.pageType = pageType
        self:Refresh()
        EventManager:GetInstance():Broadcast(EventId.JeepAdventureChangePage, self.pageType)
      else
        UIUtil.ShowTips(Localization:GetString("dominatorup_open_tips"))
      end
    end
  end
  
  if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    self:StopOneKeySweep(innerFunc)
  else
    innerFunc()
  end
end

local function OnHummerSceneTrigger(self, cfg)
  self.compSkillBg:Refresh(cfg)
end

local function OnHummerSceneSpeedLevel(self, param)
  self.compSpeedBg:Refresh(param)
end

local function OnReveiveDominatorUpFirstReward(self)
  if self.pageType == JeepAdventurePageType.Domintor then
    self:Refresh()
  end
end

local function OnReveiveTowerUpFirstReward(self)
  if self.pageType == JeepAdventurePageType.TowerUp then
    self:Refresh()
  end
end

local function SetTopEffectActive(self, active)
  self.topEffect:SetActive(active)
end

local function CheckGuide(self)
  if self.triggerGuide == nil then
    self.triggerGuide = CommonUtil.PlayerPrefsGetBool(SettingKeys.TRIGGER_DOMINATORUP_GUIDE, false)
  end
  if DataCenter.DomintorStageManager:IsUnlock() and not self.triggerGuide then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compPagePanel.transform)
    self.triggerGuide = true
    CommonUtil.PlayerPrefsSetBool(SettingKeys.TRIGGER_DOMINATORUP_GUIDE, true)
    local param = {}
    param.positionType = PositionType.Screen
    param.position = self.compZhuzaiBtn.transform.position + Vector3.New(100, 0, 0)
    param.isAutoClose = 3
    DataCenter.ArrowManager:ShowFingerArrow(param)
  end
end

local function OnJeepAdventureAddMultiKill(self)
  if self.killNum == nil then
    self.killNum = 0
  end
  self.killNum = self.killNum + 1
  self.compMultiKillEffect:Refresh(self.killNum)
end

local function RefreshBtnPanel(self, isLast)
  if isLast then
    self.btnGoto:SetActive(false)
    self.btnSweep:SetActive(false)
    self.btnStopSweep:SetActive(false)
    self.textAllFinish:SetActive(true)
  else
    if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
      self.btnGoto:SetActive(false)
      self.btnSweep:SetActive(false)
      self.btnStopSweep:SetActive(true)
    else
      self.btnGoto:SetActive(true)
      self.btnStopSweep:SetActive(false)
      self.btnSweep:SetActive(true)
    end
    self.textAllFinish:SetActive(false)
  end
end

local function OnBtnSweepClick(self)
  local can, str = DataCenter.LWJeepAdventureManager:GetCanSweepByType(self.pageType)
  if can then
    self:ClearTween()
    DataCenter.TowerUpSaveDataManager:SetOneKeySweep(true)
    self:Refresh()
    DataCenter.LWJeepAdventureManager:OneClickSweepByType(self.curStageId + 1, self.pageType)
  else
    UIUtil.ShowTips(str)
  end
end

local function OnBtnStopSweepClick(self)
  self:StopOneKeySweep()
end

local function StopOneKeySweep(self, callback)
  self:ClearTween()
  DataCenter.TowerUpSaveDataManager:ShowSweepReward(self.pageType, JeepStageSweepResultType.Stop, callback)
  self:Refresh()
end

local function OnTowerupFakePVPBattleDataGet(self, msg)
  if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
    if msg.isWin then
      local curStageId = DataCenter.LWJeepAdventureManager:GetCurStageIdByType(self.pageType)
      local nextTemplate = DataCenter.LWJeepAdventureManager:GetStageMetaByType(curStageId + 1, self.pageType)
      if nextTemplate then
        self:ClearTween()
        local scaleTime = 0.5
        local moveTime = 0.5
        local moveX = CommonUtil.ArabicAutoMirrorFactor() * -63
        self.victoryEffect:SetActive(false)
        self.victoryEffect:SetActive(true)
        self.tweenSequence = CS.DG.Tweening.DOTween.Sequence()
        self.tweenSequence:Append(self.centerItem.transform:DOScale(1.5, scaleTime / 2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        self.tweenSequence:Append(self.compCellBgRoot.transform:DOAnchorPosX(moveX, moveTime))
        self.tweenSequence:Join(self.compCellRoot.transform:DOAnchorPosX(moveX, moveTime))
        self.tweenSequence:Join(self.centerItem.transform:DOScale(0.8, moveTime / 2):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.InOutQuad))
        self.tweenSequence:OnComplete(function()
          if self then
            if DataCenter.TowerUpSaveDataManager:GetOneKeySweep() then
              self:OnBtnSweepClick()
            else
              self:OnBtnStopSweepClick()
            end
          end
        end)
      else
        DataCenter.TowerUpSaveDataManager:ShowSweepReward(self.pageType, JeepStageSweepResultType.Victory)
        self:Refresh()
      end
    else
      DataCenter.TowerUpSaveDataManager:ShowSweepReward(self.pageType, JeepStageSweepResultType.Lose)
      self:Refresh()
    end
  end
end

local function ClearTween(self)
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
  self.centerItem:SetLocalScaleXYZ(1, 1, 1)
  self.compCellBgRoot:SetAnchoredPositionXY(self.cellBgRootBeginX, self.compCellBgRoot:GetAnchoredPositionY())
  self.compCellRoot:SetAnchoredPositionXY(self.cellRootBeginX, self.compCellRoot:GetAnchoredPositionY())
  self.victoryEffect:SetActive(false)
end

UIJeepAdventureMainView.OnCreate = OnCreate
UIJeepAdventureMainView.OnDestroy = OnDestroy
UIJeepAdventureMainView.OnEnable = OnEnable
UIJeepAdventureMainView.OnDisable = OnDisable
UIJeepAdventureMainView.ComponentDefine = ComponentDefine
UIJeepAdventureMainView.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainView.DataDefine = DataDefine
UIJeepAdventureMainView.DataDestroy = DataDestroy
UIJeepAdventureMainView.OnAddListener = OnAddListener
UIJeepAdventureMainView.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainView.OnBtnInfoClick = OnBtnInfoClick
UIJeepAdventureMainView.OnBtnBackClick = OnBtnBackClick
UIJeepAdventureMainView.OnBtnGotoClick = OnBtnGotoClick
UIJeepAdventureMainView.OnBtnRewardClick = OnBtnRewardClick
UIJeepAdventureMainView.OnBtnRankClick = OnBtnRankClick
UIJeepAdventureMainView.Update1000MS = Update1000MS
UIJeepAdventureMainView.Refresh = Refresh
UIJeepAdventureMainView.RefreshTab = RefreshTab
UIJeepAdventureMainView.SelectTab = SelectTab
UIJeepAdventureMainView.OnHummerSceneTrigger = OnHummerSceneTrigger
UIJeepAdventureMainView.OnHummerSceneSpeedLevel = OnHummerSceneSpeedLevel
UIJeepAdventureMainView.OnReveiveDominatorUpFirstReward = OnReveiveDominatorUpFirstReward
UIJeepAdventureMainView.OnReveiveTowerUpFirstReward = OnReveiveTowerUpFirstReward
UIJeepAdventureMainView.SetTopEffectActive = SetTopEffectActive
UIJeepAdventureMainView.CheckGuide = CheckGuide
UIJeepAdventureMainView.OnJeepAdventureAddMultiKill = OnJeepAdventureAddMultiKill
UIJeepAdventureMainView.OnBtnSweepClick = OnBtnSweepClick
UIJeepAdventureMainView.OnBtnStopSweepClick = OnBtnStopSweepClick
UIJeepAdventureMainView.RefreshBtnPanel = RefreshBtnPanel
UIJeepAdventureMainView.OnTowerupFakePVPBattleDataGet = OnTowerupFakePVPBattleDataGet
UIJeepAdventureMainView.StopOneKeySweep = StopOneKeySweep
UIJeepAdventureMainView.ClearTween = ClearTween
return UIJeepAdventureMainView
