local base = UIBaseContainer
local UIActBountyHunterMain = BaseClass("UIActBountyHunterMain", UIBaseContainer)
local BountyHunterSceneView = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterSceneView")
local BountyHunterPhaseItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.BountyHunterPhaseItemComponent")
local BountyHunterBossHpBarComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.BountyHunterBossHpBarComponent")
local RewardStashQueueComponentComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.BountyHunterRewardStashQueueComponentComponent")
local LWUIActBountyHunterShopEntranceComponent = require("UI/UIActivityCenterTable/Component/ActBountyHunter/Component/LWUIActBountyHunterShopEntranceComponent")
local LWUIActBountyHunterBossEntranceComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Component.LWUIActBountyHunterBossEntranceComponent")
local BountyHunterMainRewardShowComponent = require("UI/UIActivityCenterTable/Component/ActBountyHunter/Component/BountyHunterMainRewardShowComponent")
local UIActBountyHunterRefreshMonsterComponent = require("UI/UIActivityCenterTable/Component/ActBountyHunter/Component/UIActBountyHunterRefreshMonsterComponent")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local Resource = CS.GameEntry.Resource
local RECRUIT_100_BTN_CHANGE_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/Eff_ui_herorecruit100_saoguang.prefab"
local rect_path = "Root/Rect"
local scene_viewer_root_path = "Root/HunterSceneViewer"
local act_name_text_path = "Root/Rect/TopArea/ActBaseInfo/ActNameText"
local remain_time_text_path = "Root/Rect/TopArea/ActBaseInfo/RemainTimeContent/RemainTimeText"
local attack_btn_path = "Root/Rect/BottomArea/AttackBtn"
local cost_item_img_path = "Root/Rect/BottomArea/AttackBtn/root/layout/CostItemImg"
local cost_num_text_path = "Root/Rect/BottomArea/AttackBtn/root/layout/CostNumText"
local attack_all_btn_path = "Root/Rect/BottomArea/AttackAllBtn"
local attack_all_text_path = "Root/Rect/BottomArea/AttackAllBtn/root/AttackAllText"
local cost_item_img_all_path = "Root/Rect/BottomArea/AttackAllBtn/root/layout/CostItemImgAll"
local cost_num_text_all_path = "Root/Rect/BottomArea/AttackAllBtn/root/layout/CostNumTextAll"
local total_reward_slider_root_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardSliderRoot"
local total_reward_slider_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardSliderRoot/TotalRewardSlider"
local bounty_hunter_phase_item_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardSliderRoot/item_root/BountyHunterPhaseItem"
local reward_item_root_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardSliderRoot/item_root"
local cur_score_progress_text_path = "Root/Rect/TopArea/TotalRewardArea/CurScoreProgressText"
local cur_score_progress_item_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardBtn/UICommonResItem"
local close_total_reward_btn_path = "Root/Rect/TopArea/TotalRewardArea/CloseTotalRewardBtn"
local close_total_reward_btn_small_path1 = "Root/Rect/TopArea/TotalRewardArea/TotalRewardCloseBtn1"
local close_total_reward_btn_small_path2 = "Root/Rect/TopArea/TotalRewardArea/TotalRewardCloseBtn2"
local cost_good_icon_path = "Root/Rect/TopArea/BuyBulletArea/CostGoodIcon"
local cost_value_text_path = "Root/Rect/TopArea/BuyBulletArea/CostValueText"
local add_btn_path = "Root/Rect/TopArea/BuyBulletArea/addBtn"
local add_btn_red_path = "Root/Rect/TopArea/BuyBulletArea/addRedPoint"
local collect_box_btn_path = "Root/Rect/BottomArea/CollectBoxBtn"
local collect_box_btn_red_path = "Root/Rect/BottomArea/CollectBoxBtn/CollectBoxBtnRed"
local remain_atk_count_text_path = "Root/Rect/RemainAtkCountText"
local total_reward_area_path = "Root/Rect/TopArea/TotalRewardArea"
local total_reward_btn_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardBtn"
local total_reward_btn_red_path = "Root/Rect/TopArea/TotalRewardArea/TotalRewardBtn/TotalRewardBtnRed"
local bounty_hunter_boss_hp_bar_path = "Root/Rect/TopArea/BountyHunterBossHpBar"
local eff_ui_wurenji_rewards_path = "Root/Rect/BottomArea/CollectBoxBtn/CollectBoxEff/Eff_ui_wurenji_rewards"
local eff_ui_box_lightsweep_path = "Root/Rect/BottomArea/CollectBoxBtn/box/Eff_ui_box_lightsweep"
local reward_stash_queue_component_path = "Root/Rect/BottomArea/RewardStashQueueComponent"
local box_path = "Root/Rect/BottomArea/CollectBoxBtn/box"
local main_show_reward_path = "Root/Rect/TopArea/RuleBtn/MainRewardShow"
local refresh_monster_path = "Root/Rect/BottomArea/RefreshMonster"
local info_btn_path = "Root/Rect/TopArea/ActBaseInfo/LW_Btn_Info"
local stash_reward_preview_root_path = "Root/Rect/BottomArea/CollectBoxBtn/box/StashRewardPreviewRoot"
local stash_reward_item_icon_path = "Root/Rect/BottomArea/CollectBoxBtn/box/StashRewardPreviewRoot/StashRewardItemIcon"
local stash_reward_item_num_text_path = "Root/Rect/BottomArea/CollectBoxBtn/box/StashRewardPreviewRoot/StashRewardItemNumText"
local btn_muti_type_change_path = "Root/Rect/BottomArea/AttackAllBtn/BtnMutiTypeChange"
local multi_type_change_eff_point_path = "Root/Rect/BottomArea/AttackAllBtn/MultiTypeChangeEffPoint"
local WAIT_MSG_MAX_TIME = 5
local STASH_REWARD_ROLL_SPEED = 0.2
local webmVideoPath = "Assets/Main/Video/s5_banner_01.webm"
local SuperShootKey = "SuperShootKey"

function UIActBountyHunterMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActBountyHunterMain:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:DestroyScene()
  base.OnDestroy(self)
end

function UIActBountyHunterMain:OnEnable()
  base.OnEnable(self)
  self.shadowDistance = RenderSetting.GetShadowDistance()
  RenderSetting.SetShadowDistance(12)
end

function UIActBountyHunterMain:OnDisable()
  base.OnDisable(self)
  if self.shadowDistance then
    RenderSetting.SetShadowDistance(self.shadowDistance)
  end
  if self.sceneViewer then
    self.sceneViewer:ClearAll()
  end
end

function UIActBountyHunterMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BountyHunterRefreshCountChange, self.RefreshRefreshCountInfo)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.BountyHunterScoreUpdate, self.OnScoreUpdate)
  self:AddUIListener(EventId.BountyHunterSelectMonsterByHand, self.ShowMonsterDetailInfo)
  self:AddUIListener(EventId.BountyHunterSelectMonster, self.ShowMonsterDetailInfo)
  self:AddUIListener(EventId.BountyHunterStartChangeScene, self.OnStartChangeScene)
  self:AddUIListener(EventId.BountyHunterStartChangeSceneFinish, self.OnStartChangeSceneFinish)
  self:AddUIListener(EventId.BountyHunterEnterBossBattle, self.OnEnterBossBattle)
  self:AddUIListener(EventId.BountyHunterExitBossBattle, self.OnExitBossBattle)
  self:AddUIListener(EventId.BountyHunterOnMonsterBeHit, self.OnMonsterEnterHurtState)
  self:AddUIListener(EventId.BountyHunterOnMonsterEnterDead, self.OnMonsterEnterDeadState)
  self:AddUIListener(EventId.BountyHunterStashRewardDataUpdate, self.OnBountyHunterStashRewardDataUpdate)
  self:AddUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnBountyHunterSuccessGetStashReward)
  self:AddUIListener(EventId.BountyHunterPlayStashRewardAni, self.ShowOneRewardIntoStashReward)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshExchangeShopRed)
  self:AddUIListener(EventId.BountyHunterTodayConsumeUpdate, self.OnTodayConsumeUpdate)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshTopBarResRed)
  self:AddUIListener(EventId.BountyHunterShopEventUpdate, self.OnShopEventDataUpdate)
  self:AddUIListener(EventId.BountyHunterBossEventUpdate, self.OnBossEventDataUpdate)
  self:AddUIListener(EventId.BountyHunterReceiveAttackTargetMessage, self.OnReceiveAttackTargetMessage)
  self:AddUIListener(EventId.BountyHunterReceiveRefreshStageMessage, self.OnReceiveRefreshStageMessage)
  self:AddUIListener(EventId.BountyHunterReceiveScreenShootMessage, self.OnReceiveScreenShootMessage)
  self:AddUIListener(EventId.BountyHunterReceiveActInfo, self.OnBountyHunterReceiveActInfo)
  self:AddUIListener(EventId.BountyHunterReceiveSuperShootMessage, self.OnReceiveSuperShootMessage)
  if self.sceneViewer then
    self.sceneViewer:M_OnAddListener()
  end
end

function UIActBountyHunterMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.BountyHunterRefreshCountChange, self.RefreshRefreshCountInfo)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.BountyHunterScoreUpdate, self.OnScoreUpdate)
  self:RemoveUIListener(EventId.BountyHunterSelectMonsterByHand, self.ShowMonsterDetailInfo)
  self:RemoveUIListener(EventId.BountyHunterSelectMonster, self.ShowMonsterDetailInfo)
  self:RemoveUIListener(EventId.BountyHunterStartChangeScene, self.OnStartChangeScene)
  self:RemoveUIListener(EventId.BountyHunterStartChangeSceneFinish, self.OnStartChangeSceneFinish)
  self:RemoveUIListener(EventId.BountyHunterEnterBossBattle, self.OnEnterBossBattle)
  self:RemoveUIListener(EventId.BountyHunterExitBossBattle, self.OnExitBossBattle)
  self:RemoveUIListener(EventId.BountyHunterOnMonsterBeHit, self.OnMonsterEnterHurtState)
  self:RemoveUIListener(EventId.BountyHunterOnMonsterEnterDead, self.OnMonsterEnterDeadState)
  self:RemoveUIListener(EventId.BountyHunterStashRewardDataUpdate, self.OnBountyHunterStashRewardDataUpdate)
  self:RemoveUIListener(EventId.BountyHunterSuccessGetStashReward, self.OnBountyHunterSuccessGetStashReward)
  self:RemoveUIListener(EventId.BountyHunterPlayStashRewardAni, self.ShowOneRewardIntoStashReward)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshExchangeShopRed)
  self:RemoveUIListener(EventId.BountyHunterTodayConsumeUpdate, self.OnTodayConsumeUpdate)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshTopBarResRed)
  self:RemoveUIListener(EventId.BountyHunterShopEventUpdate, self.OnShopEventDataUpdate)
  self:RemoveUIListener(EventId.BountyHunterBossEventUpdate, self.OnBossEventDataUpdate)
  self:RemoveUIListener(EventId.BountyHunterReceiveAttackTargetMessage, self.OnReceiveAttackTargetMessage)
  self:RemoveUIListener(EventId.BountyHunterReceiveRefreshStageMessage, self.OnReceiveRefreshStageMessage)
  self:RemoveUIListener(EventId.BountyHunterReceiveScreenShootMessage, self.OnReceiveScreenShootMessage)
  self:RemoveUIListener(EventId.BountyHunterReceiveActInfo, self.OnBountyHunterReceiveActInfo)
  self:RemoveUIListener(EventId.BountyHunterReceiveSuperShootMessage, self.OnReceiveSuperShootMessage)
  if self.sceneViewer then
    self.sceneViewer:M_OnRemoveListener()
  end
end

function UIActBountyHunterMain:ComponentDefine()
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
  self.rootAnim = self:AddComponent(UIAnimator, "")
  self.sceneViewer = self:AddComponent(BountyHunterSceneView, scene_viewer_root_path)
  self.txt_act_name = self:AddComponent(UIText, act_name_text_path)
  self.txt_times = self:AddComponent(UIText, remain_time_text_path)
  self.attackBtn = self:AddComponent(UIEventTrigger, attack_btn_path)
  self.attackBtn:OnPointerDown(BindCallback(self, self.OnPointerDown))
  self.attackBtn:OnPointerUp(BindCallback(self, self.OnPointerUp))
  self.atkBtnAni = self:AddComponent(UISimpleAnimation, attack_btn_path)
  self.costItemImg = self:AddComponent(UIImage, cost_item_img_path)
  self.costNumText = self:AddComponent(UIText, cost_num_text_path)
  self.specialAtkBtn = self:AddComponent(UIButton, attack_all_btn_path)
  self.specialAtkBtn:SetOnClick(function()
    self:OnSpecialAtkBtnClick()
  end)
  self.specialAtkBtn:SetSafeClickMode(true)
  self.atkAllCostItemImg = self:AddComponent(UIImage, cost_item_img_all_path)
  self.specialAtkCostNumText = self:AddComponent(UIText, cost_num_text_all_path)
  self.specialAtkBtnNameText = self:AddComponent(UIText, attack_all_text_path)
  self.rewardItemRoot = self:AddComponent(UIBaseContainer, reward_item_root_path)
  self.progressPhaseRewardItem = self:AddComponent(UIBaseContainer, bounty_hunter_phase_item_path)
  self.progressPhaseRewardItem.gameObject:GameObjectCreatePool()
  self.progressPhaseRewardItem:SetActive(false)
  self.phaseRewardSlider = self:AddComponent(UISlider, total_reward_slider_path)
  self.closeProgressPhaseRewardBtn = self:AddComponent(UIButton, close_total_reward_btn_path)
  self.closeProgressPhaseRewardBtn:SetOnClick(function()
    self:OnCloseProgressPhaseRewardBtn()
  end)
  self.closeProgressPhaseRewardSmallBtn1 = self:AddComponent(UIButton, close_total_reward_btn_small_path1)
  self.closeProgressPhaseRewardSmallBtn1:SetOnClick(function()
    self:OnCloseProgressPhaseRewardBtn()
  end)
  self.closeProgressPhaseRewardSmallBtn2 = self:AddComponent(UIButton, close_total_reward_btn_small_path2)
  self.closeProgressPhaseRewardSmallBtn2:SetOnClick(function()
    self:OnCloseProgressPhaseRewardBtn()
  end)
  self.closeProgressPhaseRewardRed = self:AddComponent(UIBaseComponent, total_reward_btn_red_path)
  self.curScoreInfoText = self:AddComponent(UIText, cur_score_progress_text_path)
  self.phaseRewardResItem = self:AddComponent(UICommonResItem, cur_score_progress_item_path)
  self.topBarCostItemImg = self:AddComponent(UIImage, cost_good_icon_path)
  self.topBarCostItemNumText = self:AddComponent(UIText, cost_value_text_path)
  self.topBarAddResBtn = self:AddComponent(UIButton, add_btn_path)
  self.topBarAddResBtn:SetOnClick(function()
    self:AddBtnClick()
  end)
  self.topBarAddResBtnRed = self:AddComponent(UIBaseComponent, add_btn_red_path)
  self.alreadyCollectRewardBtn = self:AddComponent(UIButton, collect_box_btn_path)
  self.alreadyCollectRewardBtn:SetOnClick(function()
    self:AlreadyCollectRewardBtnClick()
  end)
  self.alreadyCollectRewardRed = self:AddComponent(UIBaseComponent, collect_box_btn_red_path)
  self.uiRootObj = self:AddComponent(UIBaseContainer, rect_path)
  self.remainAtkCount = self:AddComponent(UIText, remain_atk_count_text_path)
  self.rewardBarAni = self:AddComponent(UISimpleAnimation, total_reward_area_path)
  self.rewardBarBtn = self:AddComponent(UIButton, total_reward_btn_path)
  self.rewardBarBtn:SetOnClick(function()
    self:ClickRewardBarBtn()
  end)
  self.bossHpBarItem = self:AddComponent(BountyHunterBossHpBarComponent, bounty_hunter_boss_hp_bar_path)
  self.boxRewardEffObj1 = self:AddComponent(UIBaseContainer, eff_ui_wurenji_rewards_path)
  self.boxRewardEffObj2 = self:AddComponent(UIBaseContainer, eff_ui_box_lightsweep_path)
  self.stashRewardQueueCpt = self:AddComponent(RewardStashQueueComponentComponent, reward_stash_queue_component_path)
  self.stashRewardQueueCpt:ReInit(function()
    self:PlayChestShakeAni()
  end)
  self.boxAni = self:AddComponent(UISimpleAnimation, box_path)
  self.btnRewardPreview = self:AddComponent(UIButton, "Root/Rect/TopArea/RewardPreviewBtn")
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.textRewardPreview = self:AddComponent(UITextMeshProUGUIEx, "Root/Rect/TopArea/RewardPreviewBtn/RewardPreviewText")
  self.btnRule = self:AddComponent(UIButton, "Root/Rect/TopArea/RuleBtn")
  self.btnRule:SetOnClick(function()
    self:OnBtnRuleClick()
  end)
  self.textRule = self:AddComponent(UITextMeshProUGUIEx, "Root/Rect/TopArea/RuleBtn/RuleText")
  self.compRedDotRule = self:AddComponent(UIBaseComponent, "Root/Rect/TopArea/RuleBtn/RedDotRule")
  self.compEventShopEntrance = self:AddComponent(LWUIActBountyHunterShopEntranceComponent, "Root/Rect/TopArea/LeftBtnLayout/ShopBtn")
  self.compEventBossTipEntrance = self:AddComponent(LWUIActBountyHunterBossEntranceComponent, "Root/Rect/TopArea/LeftBtnLayout/BossTipBtn")
  self.showRewardComp = self:AddComponent(BountyHunterMainRewardShowComponent, main_show_reward_path)
  self.refreshMonsterComp = self:AddComponent(UIActBountyHunterRefreshMonsterComponent, refresh_monster_path)
  self.infoBtn = self:AddComponent(UIButton, info_btn_path)
  self.infoBtn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.stashRewardPreviewRoot = self:AddComponent(UIBaseContainer, stash_reward_preview_root_path)
  self.stashRewardItemIcon = self:AddComponent(UIImage, stash_reward_item_icon_path)
  self.stashRewardItemNumText = self:AddComponent(UIText, stash_reward_item_num_text_path)
  self.stageRewardSliderCanvasGroup = self:AddComponent(UICanvasGroup, total_reward_slider_root_path)
  self.btn_muti_type_change = self:AddComponent(UIButton, btn_muti_type_change_path)
  self.btn_muti_type_change:SetOnClick(function()
    self:OnBtnMultiTypeChangeClick()
  end)
  self.change100RecruitEff = self:AddComponent(UIVfx, multi_type_change_eff_point_path, RECRUIT_100_BTN_CHANGE_EFF_PATH, {
    lifeType = UIVfxLifeType.Stay
  })
end

function UIActBountyHunterMain:ComponentDestroy()
  self.progressPhaseRewardItem.gameObject:GameObjectRecycleAll()
  self.rewardItemRoot:RemoveAllComponentes(BountyHunterPhaseItemComponent)
  self.rootAnim = nil
  self.btnRewardPreview = nil
  self.textRewardPreview = nil
  self.btnRule = nil
  self.textRule = nil
  self.compRedDotRule = nil
  self.compEventShopEntrance = nil
  self.compEventBossTipEntrance = nil
  self.phaseRewardResItem = nil
  self.closeProgressPhaseRewardSmallBtn1 = nil
  self.closeProgressPhaseRewardSmallBtn2 = nil
  self.closeProgressPhaseRewardBtn = nil
  self.topBarAddResBtnRed = nil
  self.closeProgressPhaseRewardRed = nil
  self.alreadyCollectRewardRed = nil
  self.showRewardComp = nil
  self.refreshMonsterComp = nil
  self.btn_muti_type_change = nil
  self.change100RecruitEff = nil
  if self.stashRewardRollTween then
    self.stashRewardRollTween:Kill()
    self.stashRewardRollTween = nil
  end
end

function UIActBountyHunterMain:DataDefine()
  self.lastAtkTimestamp = nil
  self.userActionLockDict = {}
  self.curAllStageRewardItem = {}
  self.isSuperShoot = false
  self.isSuperShootState = false
  self.onSuperShooting = false
  self.lastBossTargetUid = nil
end

function UIActBountyHunterMain:DataDestroy()
  self.sceneData = nil
  self.rewardBarOpen = nil
  self.lastAtkTimestamp = nil
  self.userActionLockDict = nil
  if self.waitRefreshMsgTimer then
    self.waitRefreshMsgTimer:Stop()
    self.waitRefreshMsgTimer = nil
  end
  self.curAllStageRewardItem = nil
  self.isSuperShoot = false
  self.isSuperShootState = false
  self.onSuperShooting = false
  self.lastBossTargetUid = nil
end

function UIActBountyHunterMain:SetData(activityId, enterAfterLoad)
  self:ClearAllTimer()
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    Logger.LogError("activityInfo is null! " .. activityId)
    self.uiRootObj:SetActive(false)
    return
  end
  self.bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(self.activityId)
  if not self.bountyHunterData then
    Logger.LogError("bountyHunterData is null! " .. activityId)
    self.uiRootObj:SetActive(false)
    return
  end
  self.isSuperShootState = self.bountyHunterData:HasShownSecondConfirm(SuperShootKey)
  if not self.uiRootObj.activeSelf then
    self.uiRootObj:SetActive(true)
  end
  self.bountyHunterTmpData = self.bountyHunterData.hunterActTmpData
  self.sceneData = self.bountyHunterData.sceneData
  self.enterAfterLoad = enterAfterLoad
  self:ClearAllUserAction()
  self:ResetRewardBarState()
  self:CreateScene(function()
    self:OnSceneViewCreateFinish()
  end)
  self:Update1000MS()
  self.showRewardComp:Show()
  self.showRewardComp:SetRewards(self.bountyHunterData:GetMainRewardShowData())
  self.refreshMonsterComp:ReInit(self.bountyHunterData, function()
    self:OnRefreshBtnClick()
  end)
  self:RefreshSuperShootState()
  self:RefreshView()
end

function UIActBountyHunterMain:ResetRewardBarState()
  self.rewardBarOpen = false
  self.rewardBarAni:Play("Init")
  self.stageRewardSliderCanvasGroup:SetInteractable(false)
end

function UIActBountyHunterMain:RefreshView()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self:RefreshTopBarResInfo()
  self:RefreshRewardProgress()
  self:RefreshAttackBtn()
  self:RefreshSpecialAtkBtn()
  self:RefreshRewardBtnState()
  self:RefreshExchangeShopRed()
  self:ClearAllStashReward()
  self:RefreshEventShopEntrance()
  self:RefreshTodayAttackLeftTimeText()
  self:HideAllBossUI(false)
  self:RefreshStashConvertItemNum(false)
  self:RefreshBossTipEntrance()
end

function UIActBountyHunterMain:OnBountyHunterStashRewardDataUpdate()
  self:RefreshRewardBtnState()
  self:RefreshStashConvertItemNum(true)
end

function UIActBountyHunterMain:OnBountyHunterSuccessGetStashReward()
  self:RefreshRewardBtnState()
  self:RefreshStashConvertItemNum(false)
end

function UIActBountyHunterMain:RefreshRewardBtnState()
  if not self.bountyHunterData then
    return
  end
  local curStashReward = self.bountyHunterData:GetCurStashRewardData()
  local isExistStashReward = curStashReward and 0 < #curStashReward
  self.boxRewardEffObj1:SetActive(isExistStashReward)
  self.boxRewardEffObj2:SetActive(isExistStashReward)
  self.alreadyCollectRewardRed:SetActive(isExistStashReward)
end

function UIActBountyHunterMain:OnScoreUpdate(activityId)
  if activityId ~= self.activityId then
    return
  end
  self:RefreshRewardProgress()
end

function UIActBountyHunterMain:RefreshRewardProgress()
  if not self.bountyHunterData then
    return
  end
  local curScore = self.bountyHunterData.score or 0
  local rewardInfo = self.bountyHunterData.phaseRewardList
  if not rewardInfo then
    return
  end
  local progressWidth = self.rewardItemRoot:GetSizeDelta().x
  local rewardSeparatorWidth = progressWidth / (#rewardInfo or 1)
  local curProgressValue = 0
  local progressPreStage = 1 / #rewardInfo
  local nextReward
  for i = 1, #rewardInfo do
    local isLastIndex = i == #rewardInfo
    local separatorLineLocalPosX = i * rewardSeparatorWidth * CommonUtil.ArabicAutoMirrorFactor()
    local rewardItem = self.curAllStageRewardItem[i]
    if not rewardItem then
      local progressItem = self.progressPhaseRewardItem.gameObject:GameObjectSpawn()
      progressItem.transform:SetParent(self.rewardItemRoot.transform)
      progressItem.transform:Set_localScale(1, 1, 1)
      progressItem.transform:Set_localPosition(separatorLineLocalPosX, 0, 0)
      local name = tostring(NameCount)
      progressItem.name = name
      NameCount = NameCount + 1
      rewardItem = self.rewardItemRoot:AddComponent(BountyHunterPhaseItemComponent, name)
      self.curAllStageRewardItem[i] = rewardItem
    end
    local params = {}
    params.rewardData = rewardInfo[i]
    local curRewardNeedScore = rewardInfo[i].needScore or 0
    params.curScore = curScore
    params.isReceived = self.bountyHunterData.hadReceiveRewardScoreDic[curRewardNeedScore]
    params.stageIndex = i
    params.isLastIndex = isLastIndex
    params.activityId = self.activityId
    rewardItem:ReInit(params)
    local curStageNeedScore = curRewardNeedScore or 0
    if curScore >= curStageNeedScore then
      curProgressValue = curProgressValue + progressPreStage
    else
      local preRewardNeedScore = 0
      if 1 < i and rewardInfo[i - 1] then
        preRewardNeedScore = rewardInfo[i - 1].needScore
      end
      if curScore >= preRewardNeedScore and curScore < curStageNeedScore then
        local overScore = curScore - preRewardNeedScore
        local curStageTotalScore = curStageNeedScore - preRewardNeedScore
        curProgressValue = curProgressValue + overScore / curStageTotalScore * progressPreStage
      end
    end
    if params.curScore >= params.rewardData.needScore then
      if not params.isReceived then
        nextReward = params.rewardData
      end
    elseif nextReward == nil then
      nextReward = params.rewardData
    end
    if isLastIndex and nextReward == nil then
      nextReward = params.rewardData
    end
  end
  self.phaseRewardSlider:SetValue(curProgressValue or 0)
  if nextReward then
    local rewardParam = {}
    rewardParam.rewardType = nextReward.type
    rewardParam.itemId = nextReward.itemId
    rewardParam.count = nextReward.num
    self.phaseRewardResItem:ReInit(rewardParam)
    self.curScoreInfoText:SetText(curScore .. "/" .. nextReward.needScore)
  end
  self.closeProgressPhaseRewardRed:SetActive(0 < self.bountyHunterData:GetRewardProgressRed())
end

function UIActBountyHunterMain:RefreshAttackBtn()
  self:PlayAtkBtnAni("Idle")
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    return
  end
  local costItemId = self.bountyHunterTmpData.cost_id
  local costItemNum = self.bountyHunterTmpData.cost_num
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(costItemId)
  self.costItemImg:LoadSprite(iconPath)
  local convertItemId = self.bountyHunterTmpData.convert_id
  local convertItemIconPath = DataCenter.ItemTemplateManager:GetIconPath(convertItemId)
  self.stashRewardItemIcon:LoadSprite(convertItemIconPath)
  local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
  if costItemNum <= haveNum then
    self.costNumText:SetText(string.format("<color=%s>%s</color>", "#FFFFFF", string.format("\195\151%s", costItemNum)))
  else
    self.costNumText:SetText(string.format("<color=%s>%s</color>", "#FF0000", string.format("\195\151%s", costItemNum)))
  end
end

function UIActBountyHunterMain:GetCurFullScreenCostItemNum()
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    Logger.LogError("UIActBountyHunterMain:GetCurFullScreenCostItemNum Error: bountyHunterData or bountyHunterTmpData is nil")
    return 0
  end
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:GetCurFullScreenCostItemNum Error: sceneViewer is nil")
    return 0
  end
  local singleAtkCost = self.bountyHunterTmpData.cost_num
  local bulletDmgVal = self.sceneViewer:GetSingleAtkDamage()
  local totalHp = 0
  local allMonsterDic = self.sceneData.allMonsterDataDic
  for _, v in pairs(allMonsterDic) do
    if v.itemType ~= BountyHunterItemType.Boss then
      totalHp = totalHp + v.curHp
    end
  end
  local needAtkCount = Mathf.Ceil(totalHp / bulletDmgVal)
  local fullScreenNeedItemNum = needAtkCount * singleAtkCost
  fullScreenNeedItemNum = math.max(singleAtkCost, fullScreenNeedItemNum)
  return fullScreenNeedItemNum
end

function UIActBountyHunterMain:GetCurBossLaserAtkCostItemNum()
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    return 0
  end
  local singleAtkCost = self.bountyHunterTmpData.cost_num
  local bulletDmgVal = self.bountyHunterData.hunterActTmpParaData.common_damage or 10
  local totalHp = 0
  local allMonsterDic = self.sceneData.allMonsterDataDic
  for _, v in pairs(allMonsterDic) do
    if v.itemType == BountyHunterItemType.Boss then
      totalHp = totalHp + v.curHp
    end
  end
  local needAtkCount = Mathf.Ceil(totalHp / bulletDmgVal)
  local laserAtkNeedItemNum = needAtkCount * singleAtkCost
  laserAtkNeedItemNum = math.max(singleAtkCost, laserAtkNeedItemNum)
  return laserAtkNeedItemNum
end

function UIActBountyHunterMain:GetCurBossLaserAtkCostAtkTimes()
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    return 0
  end
  local bulletDmgVal = self.bountyHunterData.hunterActTmpParaData.common_damage or 10
  local totalHp = 0
  local allMonsterDic = self.sceneData.allMonsterDataDic
  for _, v in pairs(allMonsterDic) do
    if v.itemType == BountyHunterItemType.Boss then
      totalHp = totalHp + v.curHp
    end
  end
  local needAtkCount = Mathf.Ceil(totalHp / bulletDmgVal)
  return needAtkCount
end

function UIActBountyHunterMain:GetCurFullScreenAttackCount()
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    return 0
  end
  local bulletDmgVal = self.bountyHunterData.hunterActTmpParaData.common_damage or 10
  local totalHp = 0
  local allMonsterDic = self.sceneData.allMonsterDataDic
  for _, v in pairs(allMonsterDic) do
    if v.itemType ~= BountyHunterItemType.Boss then
      totalHp = totalHp + v.curHp
    end
  end
  return math.max(1, Mathf.Ceil(totalHp / bulletDmgVal))
end

function UIActBountyHunterMain:RefreshRecoveryTimeInfo()
  if not self.bountyHunterData or not self.bountyHunterTmpData then
    return
  end
  local curRefreshCount = self.bountyHunterData:GetRefreshItemCount()
  local maxRefreshCount = self.bountyHunterTmpData.max_refreshtime or 0
  self.curRefreshValueText:SetText(curRefreshCount)
  if curRefreshCount >= maxRefreshCount then
    self.recoveryTimeText:SetActive(false)
    return
  end
  if not self.recoveryTimeText.activeSelf then
    self.recoveryTimeText:SetActive(true)
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.bountyHunterData.nextRecoveryTime - now
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.recoveryTimeText:SetText(countDownTimeStr)
end

function UIActBountyHunterMain:CreateScene(onCreateFinish)
  if not self.sceneData then
    return
  end
  self.sceneViewer:UpdateData(self.activityId)
  self.sceneViewer:CreateScene(onCreateFinish)
end

function UIActBountyHunterMain:EnterScene()
  self.sceneViewer:EnterScene()
  self.rootAnim:Play("V_ui_UIActBountyHunterMain_in")
  self:RefreshRefreshMonsterComp()
  if self.bountyHunterData and not self.bountyHunterData:HasShownFirstGuideUI() then
    self.bountyHunterData:SetHasShownFirstGuideUI()
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  end
end

function UIActBountyHunterMain:ShowScene()
  self.rootAnim:Play("V_ui_UIActBountyHunterMain_init_01")
end

function UIActBountyHunterMain:DestroyScene()
end

function UIActBountyHunterMain:RefreshTopContent()
end

function UIActBountyHunterMain:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo:GetShowEndTime() - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

function UIActBountyHunterMain:Update100MS()
  if self.sceneViewer then
  end
end

function UIActBountyHunterMain:OnIntroClick()
  if self.activityInfo and not string.IsNullOrEmpty(self.activityInfo.story) then
    UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.activityInfo.story))
  end
end

function UIActBountyHunterMain:ExecuteClickAttack()
  if self.sceneViewer:IsExistAnyEventInQueue() or self.sceneViewer:IsAnyEventPlayAni() then
    return
  end
  if self.sceneViewer and not self.sceneViewer:IsCanAttack() then
    return
  end
  self:ExecuteAttackAction()
  self:PlayAtkBtnAni("Click")
  self:ShowHunterLog("ExecuteClickAttack")
end

function UIActBountyHunterMain:IsInMonsterAttackCD()
  if not self.lastAtkTimestamp then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastAtkTimestamp < Const.HUNTER_ATTACK_INTERVAL then
    return true
  end
  return false
end

function UIActBountyHunterMain:IsInFullScreenAttackCD()
  if not self.lastFullAtkTimestamp then
    return false
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime - self.lastFullAtkTimestamp < Const.HUNTER_FULL_ATTACK_INTERVAL then
    return true
  end
  return false
end

function UIActBountyHunterMain:EnterAttackCD()
  self.lastAtkTimestamp = UITimeManager:GetInstance():GetServerTime()
end

function UIActBountyHunterMain:EnterFullAttackCD()
  self.lastFullAtkTimestamp = UITimeManager:GetInstance():GetServerTime()
end

function UIActBountyHunterMain:ExecuteAttackAction()
  local isInAtkCD = self:IsInMonsterAttackCD()
  if isInAtkCD then
    return
  end
  self:EnterAttackCD()
  if not self.bountyHunterData then
    return
  end
  if not self.sceneViewer or self.sceneViewer:GetCurBattleState() ~= BattleSceneState.InBattle then
    return
  end
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  if todayLeftTime == 0 then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  if self.bountyHunterTmpData then
    local costItemId = self.bountyHunterTmpData.cost_id
    local costItemNum = self.bountyHunterTmpData.cost_num
    local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
    if costItemNum > haveNum then
      self:OpenShopPanel()
      return
    end
  end
  local targetUid
  if self.sceneViewer then
    targetUid = self.sceneViewer:GetCurSelectMonsterUuid()
    local monsterItem = self.sceneViewer:GetMonsterItemByUuid(targetUid)
    if not monsterItem or monsterItem:IsDied() then
      self.sceneViewer:AutoSelectOneMonster()
      return
    end
    local autoSelectUuid = self.sceneViewer:GetAutoSelectMonsterUuid()
    if autoSelectUuid then
      local autoSelectMonsterItem = self.sceneViewer:GetMonsterItemByUuid(autoSelectUuid)
      if autoSelectMonsterItem then
        if autoSelectMonsterItem.monsterQuality == BountyMonsterQualityType.Boss and monsterItem.monsterQuality ~= BountyMonsterQualityType.Boss then
          UIUtil.ShowTipsId("activity_hunter_alert3")
          return
        elseif autoSelectMonsterItem.monsterQuality > monsterItem.monsterQuality then
          local qualityName1 = Const.MONSTER_QUALITY_2_NAME_KEY[autoSelectMonsterItem.monsterQuality]
          local qualityName2 = Const.MONSTER_QUALITY_2_NAME_KEY[monsterItem.monsterQuality]
          if qualityName1 then
            self.bountyHunterData:TryShowSecondConfirm(BountyHunterSecondConfirmKey.AttackNormalMonster, Localization:GetString("activity_hunter_alert2", Localization:GetString(qualityName1), Localization:GetString(qualityName2)), function()
              self:DoAttackOne(targetUid)
            end)
          end
          return
        elseif monsterItem.monsterQuality == BountyMonsterQualityType.NormalMonster and self.bountyHunterData and self.bountyHunterData.refreshCount and 0 < self.bountyHunterData:GetRefreshItemCount() then
          self.bountyHunterData:TryShowSecondConfirm(BountyHunterSecondConfirmKey.AttackWhenCanRefresh, Localization:GetString("activity_hunter_alert4"), function()
            self:DoAttackOne(targetUid)
          end)
          return
        end
      end
    end
  end
  if not targetUid then
    UIUtil.ShowTipsId("zombierush_memberList_tips_empty")
    self:ShowHunterLog("Not Find Attack Target")
    return
  end
  self:DoAttackOne(targetUid)
end

function UIActBountyHunterMain:DoAttackOne(targetUid)
  if self:IsAnyUserActionLocked() then
    UIUtil.ShowTipsId(120289)
    return
  end
  local attackCount = 1
  SFSNetwork.SendMessage(MsgDefines.BountyHunterAttackTarget, self.activityId, targetUid, attackCount)
  self:ShowHunterLog("DoAttackOne")
end

function UIActBountyHunterMain:DoLaserAttackOne(targetUid)
  if self:IsAnyUserActionLocked() then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.lastBossTargetUid == targetUid then
    UIUtil.ShowTipsId(120289)
    return
  end
  self.lastBossTargetUid = targetUid
  SFSNetwork.SendMessage(MsgDefines.BountyHunterKillBoss, self.activityId)
  self:ShowHunterLog("DoLaserAttackOne")
end

function UIActBountyHunterMain:AddBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:OpenShopPanel()
end

function UIActBountyHunterMain:OpenShopPanel()
  if not self.bountyHunterTmpData then
    return
  end
  local rewardPackGroupId = self.bountyHunterData:GetGiftPackId()
  if not rewardPackGroupId then
    return
  end
  local param = {}
  param.goldGiftPackageDataList = {}
  param.freeGiftPackageDataList = {}
  param.activityId = self.activityId
  param.exchangeGroupId = rewardPackGroupId
  param.nextRefreshTime = self.bountyHunterData.activityFreeRewardData.nextRefreshTime / 1000
  param.refreshTimeDuration = 86400
  param.exchangeGiftPackageIcon = "Assets/Main/Sprites/ItemIcons/lyt_shangjinlieren_zidan.png"
  
  function param.clickBuyFreeFunc(activityId, giftPackageId)
    local aid = tonumber(activityId)
    SFSNetwork.SendMessage(MsgDefines.BountyHunterReceiveFreeReward, aid)
  end
  
  param.topResBarItemIdList = {
    tonumber(self.bountyHunterTmpData.cost_id)
  }
  param.topResBarResTypeList = {
    ResourceType.Gold
  }
  local actEndTime = self.bountyHunterData:GetEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if UITimeManager:GetInstance():IsSameDayForServer(actEndTime // 1000, curTime // 1000) then
    param.emptyText = Localization:GetString("dailygift_buy_alert2")
  else
    param.emptyText = Localization:GetString("dailygift_buy_alert1")
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonActivityGiftPackage, {anim = true}, param)
end

function UIActBountyHunterMain:DoRefresh()
  if self.bountyHunterData == nil or self.sceneViewer == nil then
    return
  end
  if self.sceneViewer:IsAnyEventPlayAni() then
    return
  end
  if self.bountyHunterData:GetRefreshItemCount() <= 0 then
    local actEndTime = self.bountyHunterData:GetEndTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if UITimeManager:GetInstance():IsSameDayForServer(actEndTime, curTime) then
      UIUtil.ShowTipsId("activity_hunter_alert12")
    else
      local tomorrowZeroTime = UITimeManager:GetInstance():GetTomorrowZero()
      local leftTime = tomorrowZeroTime - curTime
      local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      local addCount = self.bountyHunterData:GetRefreshItemEverydayAddCount()
      UIUtil.ShowTips(Localization:GetString("activity_hunter_alert13", leftTimeStr, addCount))
    end
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self:RefreshScene()
end

function UIActBountyHunterMain:RefreshScene()
  if self.waitRefreshMsgTimer then
    UIUtil.ShowTipsId(120289)
    return
  end
  if self.sceneViewer:IsExistAnyEventInQueue() or self.sceneViewer:IsAnyEventPlayAni() then
    UIUtil.ShowTipsId("activity_hunter_alert15")
    return
  end
  self.waitRefreshMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.waitRefreshMsgTimer = nil
  end, WAIT_MSG_MAX_TIME)
  if self:IsAnyUserActionLocked() then
    UIUtil.ShowTipsId(120289)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BountyHunterRefreshStage, self.activityId)
end

function UIActBountyHunterMain:AlreadyCollectRewardBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActBountyHunterHistory, {anim = true}, self.activityId)
end

function UIActBountyHunterMain:RefreshTopBarResInfo()
  if not self.bountyHunterTmpData then
    return
  end
  local costItemId = self.bountyHunterTmpData.cost_id
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(costItemId)
  self.topBarCostItemImg:LoadSprite(iconPath)
  self:RefreshTopBarResNum()
  self:RefreshTopBarResRed()
end

function UIActBountyHunterMain:OnRefreshItems()
  self:RefreshTopBarResNum()
  self:RefreshAttackBtn()
  self:RefreshSuperShootState()
end

function UIActBountyHunterMain:RefreshTopBarResNum()
  if not self.bountyHunterTmpData then
    return
  end
  local costItemId = self.bountyHunterTmpData.cost_id
  local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
  self.topBarCostItemNumText:SetText(haveNum)
end

function UIActBountyHunterMain:RefreshTopBarResRed()
  if not self.bountyHunterData then
    return
  end
  self.topBarAddResBtnRed:SetActive(false)
end

function UIActBountyHunterMain:ShowMonsterDetailInfo(selectUuid)
end

function UIActBountyHunterMain:OnStartChangeScene()
end

function UIActBountyHunterMain:OnPointerDown()
  self.isClick = true
  self:ShowHunterLog("OnPointerDown")
end

function UIActBountyHunterMain:OnPointerUp()
  if self.isClick then
    self:ExecuteClickAttack()
  end
  self:ShowHunterLog("OnPointerUp")
end

function UIActBountyHunterMain:PlayAtkBtnAni(aniName)
  if self.atkBtnAni:IsPlaying(aniName) then
    self.atkBtnAni:Rewind(aniName)
  else
    self.atkBtnAni:Play(aniName)
  end
end

function UIActBountyHunterMain:ClickRewardBarBtn()
  if not self.rewardBarOpen then
    PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenProgressReward, {
      result_value = self.sceneViewer:IsInBossBattle()
    })
  end
  self:SetRewardBarState(not self.rewardBarOpen)
end

function UIActBountyHunterMain:OnCloseProgressPhaseRewardBtn()
  self:SetRewardBarState(not self.rewardBarOpen)
end

function UIActBountyHunterMain:SetRewardBarState(isOpen)
  self.rewardBarOpen = isOpen
  local aniName = self.rewardBarOpen and "Open" or "Close"
  if self.rewardBarAni:IsPlaying(aniName) then
    self.rewardBarAni:Rewind(aniName)
  else
    self.rewardBarAni:Play(aniName)
  end
  self.stageRewardSliderCanvasGroup:SetInteractable(self.rewardBarOpen)
end

function UIActBountyHunterMain:OnEnterBossBattle(monsterData)
  self:ResetRewardBarState()
  self.showRewardComp:Hide()
  self.bossHpBarItem:ShowHpBar(monsterData)
  self:RefreshRefreshMonsterComp()
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:OnExitBossBattle()
  self:HideAllBossUI(false)
  self.showRewardComp:Show()
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:RefreshSpecialAtkBtn()
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:RefreshSpecialAtkBtn Error: sceneViewer is nil")
    return
  end
  local costItemId = -1
  if self.bountyHunterTmpData then
    costItemId = self.bountyHunterTmpData.cost_id
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(costItemId)
    self.atkAllCostItemImg:LoadSprite(iconPath)
  end
  if costItemId <= 0 then
    Logger.LogError("UIActBountyHunterMain:RefreshSpecialAtkBtn Error: costItemId is invalid")
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  local costItemNum = self.bountyHunterTmpData and self.bountyHunterTmpData.cost_num or 10
  if self.sceneViewer:IsInBossBattle() then
    self:ShowBossMonsterSpecialAtkBtn(costItemId)
  elseif self.isSuperShoot and info and self.bountyHunterData and self.bountyHunterData:CanSuperShoot() and todayLeftTime >= info.costGoodsNum / costItemNum then
    self:ShowSuperShootSpecialAtkBtn()
  else
    self:ShowNormalMonsterSpecialAtkBtn(costItemId)
  end
  self.btn_muti_type_change:SetActive(not self.sceneViewer:IsInBossBattle() and self.bountyHunterData and self.bountyHunterData:CanSuperShoot() and info and todayLeftTime >= info.costGoodsNum / costItemNum)
end

function UIActBountyHunterMain:ShowNormalMonsterSpecialAtkBtn(costItemId)
  local fullScreenNeedItemNum = self:GetCurFullScreenCostItemNum()
  local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
  local textColor = "#FFFFFF"
  if fullScreenNeedItemNum <= haveNum then
    textColor = "#FFFFFF"
  else
    textColor = "#FF0000"
  end
  self.specialAtkCostNumText:SetText(string.format("<color=%s>%s</color>", textColor, string.format("\195\151%s", fullScreenNeedItemNum)))
  self.specialAtkBtnNameText:SetText(Localization:GetString("activity_hunter_mian_ui_btn5"))
  CS.UIGray.SetGray(self.specialAtkBtn.transform, false, true)
end

function UIActBountyHunterMain:ShowBossMonsterSpecialAtkBtn(costItemId)
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:ShowBossMonsterSpecialAtkBtn Error: sceneViewer is nil")
    return
  end
  local laserAtkNeedTimes = self:GetCurBossLaserAtkCostAtkTimes()
  local isCanLaserAtk = 1 < laserAtkNeedTimes
  if isCanLaserAtk then
    CS.UIGray.SetGray(self.specialAtkBtn.transform, false, true)
  else
    CS.UIGray.SetGray(self.specialAtkBtn.transform, true, false)
  end
  local laserAtkNeedItemNum = self:GetCurBossLaserAtkCostItemNum()
  local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
  local textColor = "#FFFFFF"
  if laserAtkNeedItemNum <= haveNum then
    textColor = "#FFFFFF"
  else
    textColor = "#FF0000"
  end
  self.specialAtkCostNumText:SetText(string.format("<color=%s>%s</color>", textColor, string.format("\195\151%s", laserAtkNeedItemNum)))
  self.specialAtkBtnNameText:SetLocalText("activity_hunter_mian_ui_btn7")
end

function UIActBountyHunterMain:ShowSuperShootSpecialAtkBtn()
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:ShowSuperShootSpecialAtkBtn Error: sceneViewer is nil")
    return
  end
  if not self.bountyHunterData then
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  if info == nil then
    return
  end
  local haveNum = DataCenter.ItemData:GetItemCount(info.goodsId)
  local textColor = "#FFFFFF"
  if haveNum >= info.costGoodsNum then
    textColor = "#FFFFFF"
  else
    textColor = "#FF0000"
  end
  self.specialAtkCostNumText:SetText(string.format("<color=%s>%s</color>", textColor, string.format("\195\151%s", info.costGoodsNum)))
  self.specialAtkBtnNameText:SetLocalText("activity_hunter_superbtn")
  CS.UIGray.SetGray(self.specialAtkBtn.transform, false, true)
end

function UIActBountyHunterMain:HideAllBossUI(isPlayAnim)
  self.bossHpBarItem:HideHpBar(isPlayAnim)
end

function UIActBountyHunterMain:OnMonsterEnterHurtState(hurtParams)
  if not hurtParams or not self.sceneViewer then
    return
  end
  local monsterUuid = hurtParams.uuid
  local monsterItem = self.sceneViewer:GetMonsterItemByUuid(monsterUuid)
  if monsterItem and monsterItem.monsterQuality == BountyMonsterQualityType.Boss then
    hurtParams.maxHp = monsterItem.maxHp
    self.bossHpBarItem:UpdateHpProgress(hurtParams)
  end
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:OnMonsterEnterDeadState(param)
  self:RefreshSpecialAtkBtn()
  self:RefreshRefreshMonsterComp()
  local monster = self.sceneViewer:GetMonsterItemByUuid(param.uuid)
  if monster and monster:IsBoss() then
    self:HideAllBossUI(true)
  end
end

function UIActBountyHunterMain:ClearAllStashReward()
  if not self.stashRewardQueueCpt then
    return
  end
  self.stashRewardQueueCpt:ClearAllRewardItem()
end

function UIActBountyHunterMain:ShowOneRewardIntoStashReward(flyRewardParam)
  if not (self.stashRewardQueueCpt and self.sceneViewer) or not self.sceneViewer.sceneCamera then
    return
  end
  local startWorldPos = flyRewardParam.startWorldPos
  local rtLocalPos = PosConverse.WorldToScreenPos(startWorldPos, self.sceneViewer.sceneCamera)
  local realLocalPosX = rtLocalPos.x - self.sceneViewer.rtContent.rectTransform.rect.width / 2
  local realLocalPosY = rtLocalPos.y - self.sceneViewer.rtContent.rectTransform.rect.height / 2
  local realWorldPos = self.sceneViewer.rtContent.transform:TransformPoint(realLocalPosX, realLocalPosY, 0)
  self.stashRewardQueueCpt:PushRewardToQueue(flyRewardParam.rewardData, realWorldPos, flyRewardParam.playJumpAnim)
end

function UIActBountyHunterMain:PlayChestShakeAni()
  if not self.boxAni then
    return
  end
  if self.boxAni:IsPlaying("Shake") then
    self.boxAni:Rewind("Shake")
  else
    self.boxAni:Play("Shake")
  end
end

function UIActBountyHunterMain:ShowHunterLog(info)
end

function UIActBountyHunterMain:RefreshExchangeShopRed()
  local isShow = self.bountyHunterData ~= nil and self.bountyHunterData:GetExchangeShopRed() > 0
  self.compRedDotRule:SetActive(isShow)
end

function UIActBountyHunterMain:RefreshEventShopEntrance()
  if self.activityId then
    self.compEventShopEntrance:SetData(self.activityId)
  end
end

function UIActBountyHunterMain:RefreshBossTipEntrance()
  if self.activityId and self.bountyHunterData then
    self.compEventBossTipEntrance:SetActive(self.bountyHunterData:GetEventBossDataCount() > 0)
    self.compEventBossTipEntrance:SetData(self.activityId, self.sceneViewer)
  else
    self.compEventBossTipEntrance:SetActive(false)
  end
end

function UIActBountyHunterMain:OnBtnRuleClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterExchange, {anim = true}, self.activityId)
  PostEventLog.Track(PostEventLog.Defines.BountyHunterOpenExchange)
end

function UIActBountyHunterMain:OnBtnRewardPreviewClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActBountyHunterDrop, {anim = true}, self.activityId)
end

function UIActBountyHunterMain:OnInfoBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.BountyHunterRules, {anim = true}, self.activityId)
end

function UIActBountyHunterMain:OnSpecialAtkBtnClick()
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:OnSpecialAtkBtnClick Error: sceneViewer is nil")
    return
  end
  if self.sceneViewer:IsInBossBattle() then
    self:SuperLaserAtk2BossBtnClick()
  elseif self.isSuperShoot then
    self:OnSuperShootBtnClick()
  else
    self:FullScreenAtkBtnClick()
  end
end

function UIActBountyHunterMain:FullScreenAtkBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self:IsInFullScreenAttackCD() or self:CheckIsAlreadyCastFullAtk4CurWave() then
    return
  end
  if self.bountyHunterTmpData == nil then
    return
  end
  if self.sceneViewer:IsAnyEventPlayAni() or self.sceneViewer:IsExistAnyEventInQueue() then
    return
  end
  if not self.sceneViewer or not self.bountyHunterData then
    return
  end
  if self.sceneViewer:GetCurBattleState() ~= BattleSceneState.InBattle then
    return
  end
  local fullAtkCostItemNum = self:GetCurFullScreenCostItemNum()
  local fullAtkTime = self:GetCurFullScreenAttackCount()
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  if fullAtkTime > todayLeftTime then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  local costItemId = self.bountyHunterTmpData.cost_id
  local costItemNum = self.bountyHunterTmpData.cost_num
  local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
  if fullAtkCostItemNum > haveNum then
    self:OpenShopPanel()
    return
  end
  if not self.sceneViewer:IsCanAttack() then
    return
  end
  if self.sceneViewer:IsInBossBattle() then
    UIUtil.ShowTipsId("activity_hunter_alert8")
    return
  end
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  if todayLeftTime == 0 then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  local itemName = DataCenter.ItemTemplateManager:GetName(costItemId)
  self.bountyHunterData:TryShowSecondConfirm(BountyHunterSecondConfirmKey.FirstFullAttack, Localization:GetString("activity_hunter_alert9", fullAtkCostItemNum, itemName), function()
    self:ExecuteFullScreenAttack()
  end)
end

function UIActBountyHunterMain:CheckIsAlreadyCastFullAtk4CurWave()
  if not self.sceneViewer then
    return
  end
  return self.sceneViewer:IsRepeatCastFullAtk2SameMonsterWave()
end

function UIActBountyHunterMain:ExecuteFullScreenAttack()
  if self:IsAnyUserActionLocked() then
    UIUtil.ShowTipsId("activity_hunter_alert15")
    return
  end
  self:EnterFullAttackCD()
  SFSNetwork.SendMessage(MsgDefines.BountyHunterScreenShoot, self.activityId)
end

function UIActBountyHunterMain:SuperLaserAtk2BossBtnClick()
  local isInAtkCD = self:IsInMonsterAttackCD()
  if isInAtkCD then
    return
  end
  self:EnterAttackCD()
  if not self.bountyHunterData then
    return
  end
  if not self.sceneViewer or self.sceneViewer:GetCurBattleState() ~= BattleSceneState.InBattle then
    return
  end
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  local laserCostTime = self:GetCurBossLaserAtkCostAtkTimes()
  if todayLeftTime < laserCostTime then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  if self.bountyHunterTmpData then
    local costItemId = self.bountyHunterTmpData.cost_id
    local costItemNum = self:GetCurBossLaserAtkCostItemNum()
    local haveNum = DataCenter.ItemData:GetItemCount(costItemId)
    if costItemNum > haveNum then
      self:OpenShopPanel()
      return
    end
  end
  local targetUid
  if self.sceneViewer then
    targetUid = self.sceneViewer:GetCurSelectMonsterUuid()
    local monsterItem = self.sceneViewer:GetMonsterItemByUuid(targetUid)
    if not monsterItem or monsterItem:IsDied() then
      self.sceneViewer:AutoSelectOneMonster()
      return
    end
    local autoSelectUuid = self.sceneViewer:GetAutoSelectMonsterUuid()
    if autoSelectUuid then
      local autoSelectMonsterItem = self.sceneViewer:GetMonsterItemByUuid(autoSelectUuid)
      if autoSelectMonsterItem and autoSelectMonsterItem.monsterQuality == BountyMonsterQualityType.Boss and monsterItem.monsterQuality ~= BountyMonsterQualityType.Boss then
        UIUtil.ShowTipsId("activity_hunter_alert3")
        return
      else
      end
    end
  end
  if not targetUid then
    UIUtil.ShowTipsId("zombierush_memberList_tips_empty")
    Logger.LogError("Not Find Attack Target")
    return
  end
  self:DoLaserAttackOne(targetUid)
end

function UIActBountyHunterMain:RefreshTodayAttackLeftTimeText()
  if not self.bountyHunterData then
    return
  end
  local leftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  self.remainAtkCount:SetActive(0 <= leftTime)
  if 0 <= leftTime then
    self.remainAtkCount:SetLocalText("activity_hunter_mian_ui_btn6", leftTime)
  end
end

function UIActBountyHunterMain:OnTodayConsumeUpdate()
  self:RefreshTodayAttackLeftTimeText()
end

function UIActBountyHunterMain:OnShopEventDataUpdate()
  self:RefreshEventShopEntrance()
end

function UIActBountyHunterMain:OnBossEventDataUpdate()
  self:RefreshBossTipEntrance()
end

function UIActBountyHunterMain:OnStartChangeSceneFinish()
  self:RefreshRefreshMonsterComp()
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:ClearAllUserAction()
  self.userActionLockDict = {}
end

function UIActBountyHunterMain:UnlockUserAction(msgType)
  if self.userActionLockDict then
    self.userActionLockDict[msgType] = nil
  end
end

function UIActBountyHunterMain:LockUserAction(msgType)
  if self.userActionLockDict then
    self.userActionLockDict[msgType] = true
  end
end

function UIActBountyHunterMain:IsUserActionLocked(msgType)
  if self.userActionLockDict and self.userActionLockDict[msgType] == true then
    return true
  end
  return false
end

function UIActBountyHunterMain:IsAnyUserActionLocked()
  if self.userActionLockDict then
    if self.userActionLockDict[MsgDefines.BountyHunterAttackTarget] == true then
      return true
    elseif self.userActionLockDict[MsgDefines.BountyHunterRefreshStage] == true then
      return true
    elseif self.userActionLockDict[MsgDefines.BountyHunterScreenShoot] == true then
      return true
    end
  end
  return false
end

function UIActBountyHunterMain:OnReceiveAttackTargetMessage()
  self:UnlockUserAction(MsgDefines.BountyHunterAttackTarget)
end

function UIActBountyHunterMain:OnReceiveRefreshStageMessage()
  self:UnlockUserAction(MsgDefines.BountyHunterRefreshStage)
  self:RefreshRefreshMonsterComp()
end

function UIActBountyHunterMain:OnReceiveScreenShootMessage()
  self:UnlockUserAction(MsgDefines.BountyHunterScreenShoot)
end

function UIActBountyHunterMain:ClearAllTimer()
  if self.sceneViewer then
    self.sceneViewer:ClearAllTimer()
  end
end

function UIActBountyHunterMain:IsReadyToEnter()
  if self.sceneViewer then
    return self.sceneViewer:IsReadyToEnter()
  end
  return false
end

function UIActBountyHunterMain:RefreshRefreshMonsterComp()
  local isOn = self:IsCanUseRefreshMonster()
  self.refreshMonsterComp:SetIsOn(isOn)
  self.refreshMonsterComp:RefreshCountText()
end

function UIActBountyHunterMain:IsCanUseRefreshMonster()
  if self.bountyHunterData == nil then
    return false
  end
  if self.bountyHunterData:GetRefreshItemCount() <= 0 then
    return false
  end
  if self.sceneViewer then
    local autoSelectUuid = self.sceneViewer:GetAutoSelectMonsterUuid()
    if autoSelectUuid then
      local autoSelectMonsterItem = self.sceneViewer:GetMonsterItemByUuid(autoSelectUuid)
      if autoSelectMonsterItem then
        if autoSelectMonsterItem.monsterQuality == BountyMonsterQualityType.Boss then
          return false
        elseif autoSelectMonsterItem.monsterQuality == BountyMonsterQualityType.EliteMonster then
          return false
        end
      end
    else
      return false
    end
  end
  return true
end

function UIActBountyHunterMain:OnRefreshBtnClick()
  if self.bountyHunterData == nil then
    return
  end
  if not self:IsCanUseRefreshMonster() then
    local param = {}
    param.alignObject = self.refreshMonsterComp.transform
    param.yPosFix = 50
    param.xPosFix = -10
    param.activityData = self.bountyHunterData
    param.showArrow = false
    param.target = self.refreshMonsterComp
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActBountyHunterRefreshMonsterTip, {anim = true}, param)
    return
  end
  if self.sceneViewer:IsExistAnyEventInQueue() or self.sceneViewer:IsAnyEventPlayAni() then
    UIUtil.ShowTipsId("btn_click_alert2")
    return
  end
  self:DoRefresh()
end

function UIActBountyHunterMain:OnSceneViewCreateFinish()
  if self.enterAfterLoad == true then
    self:EnterScene()
  end
end

function UIActBountyHunterMain:RefreshStashConvertItemNum(withAni)
  if not self.bountyHunterData then
    self.stashRewardPreviewRoot:SetActive(false)
    return
  end
  local curStashReward = self.bountyHunterData.stashRewardArr
  if not curStashReward or #curStashReward <= 0 then
    self.stashRewardItemNumText:SetText("0")
    self.stashRewardPreviewRoot:SetActive(false)
    return
  end
  local convertItemId = self.bountyHunterTmpData.convert_id
  local stashConvertItemCount = 0
  for _, v in ipairs(curStashReward) do
    if v.value and toInt(v.value.id) == convertItemId then
      stashConvertItemCount = v.value.num
      break
    end
  end
  if stashConvertItemCount <= 0 then
    self.stashRewardPreviewRoot:SetActive(false)
    return
  end
  if not self.stashRewardPreviewRoot.activeSelf then
    self.stashRewardPreviewRoot:SetActive(true)
  end
  if self.stashRewardRollTween then
    self.stashRewardRollTween:Kill()
    self.stashRewardRollTween = nil
  end
  if not withAni then
    self.stashRewardItemNumText:SetText(stashConvertItemCount)
  else
    local progress = toInt(self.stashRewardItemNumText.unity_tmpro.text)
    local to = stashConvertItemCount
    
    local function Getter()
      return progress
    end
    
    local function Setter(value)
      progress = value
      self.stashRewardItemNumText:SetText(Mathf.Floor(value))
    end
    
    local rollTime = (to - progress) * STASH_REWARD_ROLL_SPEED
    rollTime = Mathf.Clamp(0.2, 1.5, rollTime)
    self.stashRewardRollTween = DOTween.To(Getter, Setter, to, rollTime):OnComplete(function()
      self.stashRewardItemNumText:SetText(stashConvertItemCount)
      self.stashRewardRollTween = nil
    end):SetDelay(2)
  end
end

function UIActBountyHunterMain:OnBountyHunterReceiveActInfo()
  if not self.activityId then
    return
  end
  self:SetData(self.activityId, true)
end

function UIActBountyHunterMain:OnBtnMultiTypeChangeClick()
  if self.sceneViewer:IsInBossBattle() then
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  if info == nil then
    return
  end
  if not self.isSuperShoot and not self.bountyHunterData:CanSuperShoot() then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(info.goodsId)
    UIUtil.ShowTips(Localization:GetString("hunterbroad_alert_desc9", Localization:GetString(itemTemplate and itemTemplate.name or ""), info.superShootMinNum))
    return
  end
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  local costItemNum = self.bountyHunterTmpData and self.bountyHunterTmpData.cost_num or 10
  if not self.isSuperShoot and todayLeftTime < info.costGoodsNum / costItemNum then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  self.isSuperShoot = not self.isSuperShoot
  self.isSuperShootState = not self.isSuperShootState
  self.bountyHunterData:SetHasShownSecondConfirmState(SuperShootKey, self.isSuperShootState)
  if self.isSuperShoot then
    self.change100RecruitEff:Replay()
  else
    self.change100RecruitEff:Stop()
  end
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:OnSuperShootBtnClick()
  if not self.sceneViewer then
    Logger.LogError("UIActBountyHunterMain:OnSuperShootBtnClick Error: sceneViewer is nil")
    return 0
  end
  if not self.bountyHunterData then
    return
  end
  if self.onSuperShooting then
    return
  end
  if self.sceneViewer:GetCurBattleState() ~= BattleSceneState.InBattle then
    return
  end
  if self.sceneViewer:IsAnyEventPlayAni() or self.sceneViewer:IsExistAnyEventInQueue() then
    return
  end
  if self.sceneViewer:IsInBossBattle() then
    UIUtil.ShowTips(Localization:GetString("hunterbroad_alert_desc6"))
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  if info == nil then
    return
  end
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  local costItemNum = self.bountyHunterTmpData and self.bountyHunterTmpData.cost_num or 10
  if todayLeftTime < info.costGoodsNum / costItemNum then
    UIUtil.ShowTipsId("activity_hunter_alert7")
    return
  end
  if not self.bountyHunterData:CanSuperShoot() then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(info.goodsId)
    UIUtil.ShowTips(Localization:GetString("hunterbroad_alert_desc9", Localization:GetString(itemTemplate and itemTemplate.name or ""), info.superShootMinNum))
    return
  end
  
  local function CheckShopTimesMax()
    if self.bountyHunterData:CheckShopTimesMax() then
      self.bountyHunterData:TryShowSecondConfirm(BountyHunterSecondConfirmKey.BountyHunterSuperShootFoundShopMax, Localization:GetString("hunterbroad_alert_desc8"), function()
        self:ConfirmSuperShoot()
      end)
    else
      self:ConfirmSuperShoot()
    end
  end
  
  if self.bountyHunterData:CheckFinalDayShootCountEnough() then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(info.goodsId)
    self.bountyHunterData:TryShowSecondConfirm(BountyHunterSecondConfirmKey.BountyHunterFinalDaySuperShootMonster, Localization:GetString("hunterbroad_alert_desc1", Localization:GetString(itemTemplate and itemTemplate.name or "")), function()
      CheckShopTimesMax()
    end)
    return
  end
  CheckShopTimesMax()
end

function UIActBountyHunterMain:ConfirmSuperShoot()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBountyHunterSweepConfirm, {anim = true}, {
    data = self.bountyHunterData,
    callback = function(useRefreshItem)
      self:DoSuperShoot(useRefreshItem)
    end
  })
end

function UIActBountyHunterMain:DoSuperShoot(useRefreshItem)
  self.onSuperShooting = true
  self:RefreshSuperShootState()
  SFSNetwork.SendMessage(MsgDefines.BountyHunterBatchShoot, {
    activityId = self.activityId,
    useRefreshItem = useRefreshItem
  })
end

function UIActBountyHunterMain:RefreshSuperShootState()
  local info = self.bountyHunterData:GetSuperShootInfo()
  local todayLeftTime = self.bountyHunterData:GetTodayConsumeLeftTime()
  local costItemNum = self.bountyHunterTmpData and self.bountyHunterTmpData.cost_num or 10
  if self.isSuperShootState then
    self.isSuperShoot = self.bountyHunterData:CanSuperShoot() and todayLeftTime >= info.costGoodsNum / costItemNum
  else
    self.isSuperShoot = false
  end
  self:RefreshSpecialAtkBtn()
end

function UIActBountyHunterMain:OnReceiveSuperShootMessage()
  self.onSuperShooting = false
  self:RefreshRefreshMonsterComp()
end

return UIActBountyHunterMain
