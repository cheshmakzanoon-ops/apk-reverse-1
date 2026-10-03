local base = UIBaseContainer
local T11OverviewPageComponent = BaseClass("T11OverviewPageComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter.T11DataManager.T11Constant")
local UIModelView = require("Framework.UI.Component.UIModelView")
local T11SceneViewCtrl = require("UI.T11MainView.Component.SceneView.T11SceneViewCtrl")
local T11PowerTipCptComponent = require("UI.T11MainView.Component.PowerTip.T11PowerTipCptComponent")
local T11PowerInfoComponent = require("UI.T11Common.T11PowerInfoComponent")
local r_t_scene_bg_path = "AniRoot/RTSceneBg"
local info_btn_path = "TopArea/InfoBtn"
local research_preview_btn_path = "TopArea/ResearchPreviewBtn"
local bottom_layout_path = "BottomLayout"
local upgrade_eff_path = "AniRoot/UpgradeEff"
local break_stage_eff_path = "AniRoot/BreakStageEff"
local SCENE_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/CommonCpt/T11SceneView.prefab"
local UPGRADE_EFF_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_T11OverviewPage_upgrade.prefab"
local BREAK_STAGE_EFF_PREFAB_PATH = "Assets/Main/Prefabs/UI/T11/Effect/Eff_ui_T11OverviewPage_upgrade_nextlevel.prefab"
local STATE_CPT_CONFIG = {
  [T11UnlockState.T11UnlockProgressUpgrade] = {
    stateName = "T11UnlockProgressUpgrade",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11UnlockProgressUpgradeItem.prefab",
    cls = "UI.T11MainView.Component.State.T11UnlockProgressUpgradeItemComponent"
  },
  [T11UnlockState.SkillProgressUpgrade] = {
    stateName = "SkillProgressUpgrade",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11SkillProgressUpgradeItem.prefab",
    cls = "UI.T11MainView.Component.State.T11SkillProgressUpgradeItemComponent"
  },
  [T11UnlockState.T11Unlockable] = {
    stateName = "T11Unlockable",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11UnlockableItem.prefab",
    cls = "UI.T11MainView.Component.State.T11UnlockableItemComponent"
  },
  [T11UnlockState.SkillBreakable] = {
    stateName = "SkillBreakable",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11SkillUnlockableItem.prefab",
    cls = "UI.T11MainView.Component.State.T11SkillUnlockableItemComponent"
  },
  [T11UnlockState.T11Unlocking] = {
    stateName = "T11Unlocking",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11UnlockingItem.prefab",
    cls = "UI.T11MainView.Component.State.T11UnlockingItemComponent"
  },
  [T11UnlockState.SkillBreaking] = {
    stateName = "SkillBreaking",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11SkillUnlockingItem.prefab",
    cls = "UI.T11MainView.Component.State.T11SkillUnlockingItemComponent"
  },
  [T11UnlockState.T11UnlockConfirmComplete] = {
    stateName = "T11UnlockConfirmComplete",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11UnlockConfirmCompleteItem.prefab",
    cls = "UI.T11MainView.Component.State.T11UnlockConfirmCompleteItemComponent"
  },
  [T11UnlockState.SkillBreakConfirmComplete] = {
    stateName = "SkillBreakConfirmComplete",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11SkillBreakConfirmCompleteItem.prefab",
    cls = "UI.T11MainView.Component.State.T11SkillBreakConfirmCompleteItemComponent"
  },
  [T11UnlockState.T11MaxStage] = {
    stateName = "T11MaxStage",
    prefabPath = "Assets/Main/Prefabs/UI/T11/T11MainView/Component/StateCpt/T11MaxStageItem.prefab",
    cls = "UI.T11MainView.Component.State.T11MaxStageItemComponent"
  }
}
local ShowInfoType = {Main = 0, UpgradeConfirm = 1}

function T11OverviewPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  RenderSetting.ToggleCustomDepthRenderFeature(true)
end

function T11OverviewPageComponent:OnDestroy()
  RenderSetting.ToggleCustomDepthRenderFeature(false)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11OverviewPageComponent:OnEnable()
  base.OnEnable(self)
  if self.sceneViewCtrl then
    self.sceneViewCtrl:RefreshAllEquipAni()
  end
end

function T11OverviewPageComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgRTSceneBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.compBottomLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compT11PowerTipCpt = self.viewSkin:AddComponent(self, T11PowerTipCptComponent, 3)
  self.compT11PowerInfo = self.viewSkin:AddComponent(self, T11PowerInfoComponent, 4)
  self.compUpgradeEff = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.simpleAnimationAniRoot = self.viewSkin:AddComponent(self, UISimpleAnimation, 6)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.researchPreviewBtn = self:AddComponent(UIButton, research_preview_btn_path)
  self.researchPreviewBtn:SetOnClick(function()
    self:OnResearchPreviewBtnClick()
  end)
  self.gameRT = self:AddComponent(UIModelView, r_t_scene_bg_path)
  self.stateCptRoot = self:AddComponent(UIBaseContainer, bottom_layout_path)
  self.upgradeConfirmCpt = nil
  self.upgradeVFX = self:AddComponent(UIVfx, upgrade_eff_path, UPGRADE_EFF_PREFAB_PATH)
  self.breakStageVFX = self:AddComponent(UIVfx, break_stage_eff_path, BREAK_STAGE_EFF_PREFAB_PATH)
end

function T11OverviewPageComponent:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgRTSceneBg = nil
  self.compBottomLayout = nil
  self.compT11PowerTipCpt = nil
  self.compT11PowerInfo = nil
  self.compUpgradeEff = nil
  self.simpleAnimationAniRoot = nil
  self.stateCptRoot:RemoveAllComponentes()
  self.upgradeConfirmCpt = nil
end

function T11OverviewPageComponent:DataDefine()
  self.curUnlockState = T11UnlockState.Unknown
  self.allStateCptDic = {}
  self.curUIShowType = ShowInfoType.Main
  self.sceneViewCtrl = nil
end

function T11OverviewPageComponent:DataDestroy()
  self.curUnlockState = nil
  self.allStateCptDic = nil
  self.curUIShowType = nil
  if self.sceneViewCtrl then
    self.sceneViewCtrl:Destroy()
    self.sceneViewCtrl = nil
  end
  if self.playBreakStageTimer then
    self.playBreakStageTimer:Stop()
    self.playBreakStageTimer = nil
  end
  if self.modelDelayRefreshTimer then
    self.modelDelayRefreshTimer:Stop()
    self.modelDelayRefreshTimer = nil
  end
  if self.delayOpenViewTimer then
    self.delayOpenViewTimer:Stop()
    self.delayOpenViewTimer = nil
  end
end

function T11OverviewPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.T11ProgressUpgradeSuccess, self.OnUpgradeSuccess)
  self:AddUIListener(EventId.T11EnterBreakState, self.OnEnterBreakState)
  self:AddUIListener(EventId.T11ResearchStateUpdate, self.UpdateBottomAreaByCurState)
  self:AddUIListener(EventId.T11ResearchQueueFinish, self.OnResearchQueueFinish)
  self:AddUIListener(EventId.T11ShowUpgradeConfirm, self.ShowUpgradeConfirm)
  self:AddUIListener(EventId.T11SuccessChangeSoldierMode, self.OnSuccessChangeSoldierMode)
  self:AddUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedSuccess)
  self:AddUIListener(EventId.T11DataUpdate, self.OnPushUpdateT11Data)
  self:AddUIListener(EventId.CloseUI, self.OnCloseT11UpgradeView)
end

function T11OverviewPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.T11ProgressUpgradeSuccess, self.OnUpgradeSuccess)
  self:RemoveUIListener(EventId.T11EnterBreakState, self.OnEnterBreakState)
  self:RemoveUIListener(EventId.T11ResearchStateUpdate, self.UpdateBottomAreaByCurState)
  self:RemoveUIListener(EventId.T11ResearchQueueFinish, self.OnResearchQueueFinish)
  self:RemoveUIListener(EventId.T11ShowUpgradeConfirm, self.ShowUpgradeConfirm)
  self:RemoveUIListener(EventId.T11SuccessChangeSoldierMode, self.OnSuccessChangeSoldierMode)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnAddSpeedSuccess)
  self:RemoveUIListener(EventId.T11DataUpdate, self.OnPushUpdateT11Data)
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseT11UpgradeView)
  base.OnRemoveListener(self)
end

function T11OverviewPageComponent:RefreshView()
  self:RefreshRTSceneBg()
  self:UpdateBottomAreaByCurState()
  self:ChangeUIShowType(ShowInfoType.Main, true)
  if self.sceneViewCtrl then
    self.sceneViewCtrl:RefreshModelState()
  end
  self.compT11PowerTipCpt:RefreshView()
  self:RefreshPowerValueTipInfo()
  self.simpleAnimationAniRoot:Play("Idle")
end

function T11OverviewPageComponent:OnPushUpdateT11Data()
  self:UpdateBottomAreaByCurState(true)
end

function T11OverviewPageComponent:OnResearchQueueFinish()
  local targetState = DataCenter.T11DataManager:GetCurT11UpgradeState()
  self:ShowTargetStateCpt(targetState)
end

function T11OverviewPageComponent:UpdateBottomAreaByCurState(refreshFromUpgrade)
  local targetState = DataCenter.T11DataManager:GetCurT11UpgradeState()
  self:ShowTargetStateCpt(targetState)
  if self.modelDelayRefreshTimer then
    self.modelDelayRefreshTimer:Stop()
    self.modelDelayRefreshTimer = nil
  end
  if self.sceneViewCtrl then
    local isChangePoseForThisUpgrade = T11Util.GetCurUpgradeEquipProgress() == 0
    if refreshFromUpgrade and isChangePoseForThisUpgrade then
      self.modelDelayRefreshTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.sceneViewCtrl:RefreshModelState()
      end, Const.DelayRefreshTimeWhenEquipBreak)
    else
      self.sceneViewCtrl:RefreshModelState()
    end
  end
  self:RefreshPowerValueTipInfo()
end

function T11OverviewPageComponent:ShowTargetStateCpt(targetState)
  if self.curUnlockState == targetState then
    return
  end
  if self.curLoadReq then
    self.curLoadReq:Destroy()
  end
  local pervStateState = self.curUnlockState
  local prevStateCpt = self.allStateCptDic[pervStateState]
  if prevStateCpt then
    self:OnExitPrevState(prevStateCpt, pervStateState)
  end
  self.curUnlockState = targetState
  local curStateCpt = self.allStateCptDic[self.curUnlockState]
  if not curStateCpt then
    local stateCptConfig = STATE_CPT_CONFIG[self.curUnlockState]
    if not stateCptConfig then
      Logger.LogError("T11OverviewPageComponent:ShowTargetStateCpt stateCptConfig is nil")
      return
    end
    T11Util.ShowLog("T11OverviewPageComponent:ShowTargetStateCpt targetState:" .. stateCptConfig.stateName)
    local stateName = stateCptConfig.stateName
    local prefabPath = stateCptConfig.prefabPath
    local cls = stateCptConfig.cls
    if string.IsNullOrEmpty(prefabPath) or string.IsNullOrEmpty(cls) then
      Logger.LogError("T11OverviewPageComponent:ShowTargetStateCpt prefabPath or cls is nil")
      return
    end
    self.curLoadReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
      self.curLoadReq = nil
      req.gameObject.transform:SetParent(self.stateCptRoot.transform)
      req.gameObject.transform:SetAsFirstSibling()
      req.gameObject.transform.localPosition = Vector3(0, 0, 0)
      req.gameObject.transform.localScale = Vector3(1, 1, 1)
      req.gameObject:SetActive(true)
      req.gameObject.transform.name = stateName
      curStateCpt = self.stateCptRoot:AddComponent(require(cls), stateName)
      self.allStateCptDic[targetState] = curStateCpt
      if curStateCpt.RefreshView then
        curStateCpt:RefreshView()
      end
    end)
    return
  end
  if not curStateCpt.activeSelf then
    curStateCpt:SetActive(true)
  end
  if curStateCpt.RefreshView then
    curStateCpt:RefreshView()
  end
end

function T11OverviewPageComponent:RefreshRTSceneBg()
  self.gameRT:Clear()
  self.gameRT:SetDefaultSceneTrans(Vector3.New(500, 0, 500))
  self.gameRT:SetRTFormat(CS.UnityEngine.RenderTextureFormat.ARGBHalf)
  self.gameRT:ReInit(SCENE_PREFAB_PATH)
  self.gameRT:SetOnLoadSceneHandler(function()
    if not self.sceneViewCtrl then
      self.sceneViewCtrl = T11SceneViewCtrl.New()
    end
    self.sceneViewCtrl:Init(self.gameRT)
    self.sceneViewCtrl:RefreshModelState()
  end)
  RenderSetting.SetShadowDistance(10)
end

function T11OverviewPageComponent:OnUpgradeSuccess()
  self:UpdateBottomAreaByCurState(true)
  self.compT11PowerTipCpt:RefreshView(true)
  self:RefreshPowerValueTipInfo()
  self:ShowUpgradeEff()
end

function T11OverviewPageComponent:ShowUpgradeEff()
  local curEquipUpgradeProgress = T11Util.GetCurUpgradeEquipProgress()
  if curEquipUpgradeProgress == 0 then
    self:PlayStageEffDelay(Const.DelayRefreshTimeWhenEquipBreak)
  else
    self.upgradeVFX:Replay()
  end
end

function T11OverviewPageComponent:OnEnterBreakState()
  self:UpdateBottomAreaByCurState()
end

function T11OverviewPageComponent:OnExitPrevState(prevStateCpt, prevState)
  if not prevStateCpt then
    return
  end
  prevStateCpt:SetActive(false)
  if prevState == T11UnlockState.T11Unlockable or prevState == T11UnlockState.SkillBreakable then
    self:ChangeUIShowType(ShowInfoType.Main)
  end
  if prevState == T11UnlockState.T11UnlockConfirmComplete then
    self:PlayStageEffDelay(Const.DelayRefreshTimeWhenEquipBreak)
    if self.delayOpenViewTimer then
      self.delayOpenViewTimer:Stop()
      self.delayOpenViewTimer = nil
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.T11SoldierNewGet)
  end
  if prevState == T11UnlockState.SkillBreakConfirmComplete and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.T11SoldierNewGet) then
    self:PlayStageEffDelay(Const.DelayRefreshTimeWhenEquipBreak)
    if self.delayOpenViewTimer then
      self.delayOpenViewTimer:Stop()
      self.delayOpenViewTimer = nil
    end
    self.delayOpenViewTimer = TimerManager:GetInstance():DelayInvoke(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.T11UnlockNewSkill, {anim = true})
    end, Const.UnlockNewSkillOrSoldierDelayTime)
  end
end

function T11OverviewPageComponent:PlayStageEffDelay(delay)
  if self.playBreakStageTimer then
    self.playBreakStageTimer:Stop()
    self.playBreakStageTimer = nil
  end
  self.playBreakStageTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.playBreakStageTimer = nil
    self.breakStageVFX:Replay()
  end, delay or 1)
end

local GUIDE_TYPE = 100
local GUIDE_IMAGE_PREFIX_PATH = "Assets/Main/TextureEx/UIT11Ex/%s.png"

function T11OverviewPageComponent:OnInfoBtnClick()
  if not self.guideList then
    self.guideList = {}
    LocalController:instance():visitTable(TableName.Desert_Battle_Guide, function(id, lineData)
      local battle_type = lineData:getIntValue("battle_type")
      if battle_type == GUIDE_TYPE then
        local big_pic = lineData:getValue("big_pic")
        local small_pic = lineData:getValue("small_pic_list")
        if not string.IsNullOrEmpty(big_pic) then
          big_pic = string.format(GUIDE_IMAGE_PREFIX_PATH, big_pic)
        end
        if not string.IsNullOrEmpty(small_pic) then
          small_pic = string.format(GUIDE_IMAGE_PREFIX_PATH, small_pic)
        end
        table.insert(self.guideList, {
          num = lineData:getIntValue("id"),
          tittle = lineData:getValue("tittle"),
          battle_type = lineData:getValue("battle_type"),
          big_pic = big_pic,
          small_pic = small_pic,
          desc = lineData:getValue("small_pic_desc_list")
        })
      end
    end)
    table.sort(self.guideList, function(a, b)
      return a.num < b.num
    end)
  end
  if #self.guideList > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, {anim = true}, self.guideList)
  end
end

function T11OverviewPageComponent:OnResearchPreviewBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.T11SoldierResearchPlan)
end

function T11OverviewPageComponent:ShowUpgradeConfirm()
  self:ChangeUIShowType(ShowInfoType.UpgradeConfirm)
end

function T11OverviewPageComponent:ChangeUIShowType(showType, noSwitchAni)
  self.curUIShowType = showType
  if self.curUIShowType == ShowInfoType.Main then
    self.compBottomLayout:SetActive(true)
    self.compT11PowerTipCpt:SetShowHideState(true)
    self.researchPreviewBtn:SetActive(true)
    self.infoBtn:SetActive(true)
  elseif self.curUIShowType == ShowInfoType.UpgradeConfirm then
    self.compBottomLayout:SetActive(false)
    self.compT11PowerTipCpt:SetShowHideState(false)
    self.researchPreviewBtn:SetActive(false)
    self.infoBtn:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.T11UpgradeConfirm)
  end
  local screenRatio = CS.UnityEngine.Screen.height / CS.UnityEngine.Screen.width
  if 2 < screenRatio then
    self.simpleAnimationAniRoot:Play("Idle")
  elseif not noSwitchAni then
    local switchAniName = self.curUIShowType == ShowInfoType.Main and "ShowOut" or "ShowIn"
    self.simpleAnimationAniRoot:Play(switchAniName)
  end
end

function T11OverviewPageComponent:OnSuccessChangeSoldierMode(isFirst)
  if isFirst then
    return
  end
  local curSelSoldierTmp = T11Util.GetCurT11SoldierTmpData()
  if curSelSoldierTmp then
    local soldierName = Localization:GetString(curSelSoldierTmp.name)
    UIUtil.ShowTips(Localization:GetString("soldier_eleven_change_success", soldierName))
  end
end

function T11OverviewPageComponent:RefreshPowerValueTipInfo()
  local curT11SearchPower = DataCenter.T11DataManager:GetT11SearchPower()
  self.compT11PowerInfo:SetPowerValue(curT11SearchPower)
end

function T11OverviewPageComponent:OnAddSpeedSuccess()
  self:UpdateBottomAreaByCurState()
end

function T11OverviewPageComponent:OnCloseT11UpgradeView(windowName)
  if windowName ~= UIWindowNames.T11UpgradeConfirm then
    return
  end
  self:ChangeUIShowType(ShowInfoType.Main)
end

return T11OverviewPageComponent
