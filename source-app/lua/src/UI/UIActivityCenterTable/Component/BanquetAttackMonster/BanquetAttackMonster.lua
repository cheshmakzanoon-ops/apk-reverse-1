local BanquetAttackMonster = BaseClass("BanquetAttackMonster", UIBaseView)
local M = BanquetAttackMonster
local base = UIBaseView
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local Localization = CS.GameEntry.Localization
local AttackMonsterModelShowManager = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.AttackMonsterModelShowManager")
local ViewState = {
  AttackMonster = 1,
  MonsterDead = 2,
  BoxDrop = 3,
  BoxIdle = 4,
  BoxConfirm = 5,
  FinBosViewCloseWaiting = 6,
  MonsterStart = 7
}
local battleRawImgSizeX = 760
local battleRawImgSizeY = 970
local AtkBossDeltaTime = 500
local AtkBossBulletAddTime = 2000
local AtkBossBulletNum = 6
local PlotShowTime = 0.8
local PressTipShowTime = 5
local PressTriggerTime = 3
local PressTriggerDeltaTime = 3000
local battle_raw_img_path = "contentView/centerContent/battleContent/battleRawImg"
local btn_drop_tip_path = "contentView/Top/BtnList/BtnDropTip"
local btn_task_path = "contentView/Top/BtnList/BtnTask"
local btn_change_path = "contentView/Top/BtnList/BtnChange"
local progress_btn_path = "contentView/Top/progressBtn"
local progress_res_item_path = "contentView/Top/progressBtn/progressResItem"
local damage_reward_pos_path = "contentView/centerContent/battleContent/damageRewardPos"
local monster_name_path = "contentView/centerContent/bloodContent/monsterName"
local monster_blood_bg_path = "contentView/centerContent/bloodContent/monsterBloodBg"
local monster_blood_img_path = "contentView/centerContent/bloodContent/monsterBloodBg/monsterBloodImg"
local monster_blood_val_path = "contentView/centerContent/bloodContent/monsterBloodVal"
local img_cost_item1_path = "contentView/Rect_Bottom/DonateBtn/costItemContent/ImgCostItem1"
local text_cost1_path = "contentView/Rect_Bottom/DonateBtn/costItemContent/TextCost1"
local attack_boss_btn_path = "contentView/Rect_Bottom/attackBossBtn"
local attack_boss_btn_icon_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/attackBossBtnIcon"
local attack_boss_btn_txt_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/attackBossBtnTxt"
local reward_boss_btn_path = "contentView/Rect_Bottom/rewardBossBtn"
local monster_fin_box_path = "contentView/centerContent/battleContent/monsterFinBox"
local eff_ui_attack_boss_btn_icon1_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/Eff_ui_attackBossBtnIcon1"
local eff_ui_attack_boss_btn_icon2_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/Eff_ui_attackBossBtnIcon2"
local box_ani_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani"
local eff_ui_yanhui_baoxiangdiaoluo_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani/Eff_ui_yanhui_baoxiangdiaoluo"
local eff_ui_yanhui_baoxiangidle1_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani/root/Eff_ui_yanhui_baoxiangidle1"
local eff_ui_yanhui_baoxiangidle2_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani/root/Eff_ui_yanhui_baoxiangidle2"
local eff_ui_yanhui_baoxiangkaiqi1_path = "contentView/centerContent/battleContent/monsterFinBox/Eff_ui_yanhui_baoxiangkaiqi1"
local eff_ui_yanhui_baoxiangkaiqi2_path = "contentView/centerContent/battleContent/monsterFinBox/Eff_ui_yanhui_baoxiangkaiqi2"
local plot_bubble_path = "contentView/centerContent/monsterPlotContent/PlotBubble"
local plot_txt_content_path = "contentView/centerContent/monsterPlotContent/PlotBubble/root/bubble/plotTxtContent"
local blood_content_path = "contentView/centerContent/bloodContent"
local monster_plot_content_path = "contentView/centerContent/monsterPlotContent"
local level_reward_red_point_path = "contentView/Top/progressBtn/levelRewardRedPoint"
local level_reward_red_num_path = "contentView/Top/progressBtn/levelRewardRedPoint/levelRewardRedNum"
local task_red_point_path = "contentView/Top/BtnList/BtnTask/taskRedPoint"
local task_red_num_path = "contentView/Top/BtnList/BtnTask/taskRedPoint/taskRedNum"
local change_red_point_path = "contentView/Top/BtnList/BtnChange/changeRedPoint"
local change_red_num_path = "contentView/Top/BtnList/BtnChange/changeRedPoint/changeRedNum"
local cost1_red_point_path = "contentView/Rect_Bottom/DonateBtn/cost1RedPoint"
local cost1_red_num_path = "contentView/Rect_Bottom/DonateBtn/cost1RedPoint/cost1RedNum"
local cost2_red_point_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/cost2RedPoint"
local cost2_red_num_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/cost2RedPoint/cost2RedNum"
local eff_ui_eff_ui_attack_boss1_path = "contentView/Rect_Bottom/attackBossBtn/attackBossBtnBg/Eff_ui_Eff_ui_attackBoss1"
local eff_ui_reward_boss_btn_path = "contentView/Rect_Bottom/rewardBossBtn/box/Eff_ui_rewardBossBtn"
local eff_ui_donate_btn1_path = "contentView/Rect_Bottom/DonateBtn/Eff_ui_DonateBtn1"
local level_exp_fly_pos_path = "contentView/Top/ScoreSlider/levelExpFlyPos"
local open_box_btn_path = "contentView/Rect_Bottom/OpenBoxBtn"
local press_tip_content_path = "contentView/Rect_Bottom/PressTipContent"
local press_tip_root_ani_path = "contentView/Rect_Bottom/PressTipContent/PressTipRoot/PressTipRootAni"
local press_tip_txt_path = "contentView/Rect_Bottom/PressTipContent/PressTipRoot/PressTipRootAni/TipContent/PressTipTxt"
local touch_boss_btn_path = "contentView/centerContent/battleContent/touchBossBtn"
local open_box_red_point_path = "contentView/Rect_Bottom/OpenBoxBtn/openBoxRedPoint"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:Componentdestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
end

function M:OnDisable()
  base.OnDisable(self)
  self:StopAnim()
  self:OnModelShowEnd()
end

function M:ComponentDefine()
  self._actName_txt = self:AddComponent(UIText, "contentView/Top/title")
  self._time_txt = self:AddComponent(UIText, "contentView/Top/RemainTimeContent/RemainTimeText")
  self.intro_btn = self:AddComponent(UIButton, "contentView/Top/InfoBtn")
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self.reward_btn = self:AddComponent(UIButton, "contentView/Top/RewardBtn")
  self.reward_btn_txt = self:AddComponent(UIText, "contentView/Top/RewardBtn/RewardBtnText")
  self.reward_btn_txt:SetLocalText(458131)
  self.reward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickReward()
  end)
  self._donate_btn = self:AddComponent(UIButton, "contentView/Rect_Bottom/DonateBtn")
  self._donate_btn_txt = self:AddComponent(UIText, "contentView/Rect_Bottom/DonateBtn/DonateBtnText")
  self._donate_btn_txt:SetLocalText("activity_newparty_desc6")
  self._slider = self:AddComponent(UISlider, "contentView/Top/ScoreSlider")
  self._slider_txt = self:AddComponent(UIText, "contentView/Top/ScoreSlider/ScoreText")
  self.curScoreText = self:AddComponent(UIText, "contentView/Top/CurScoreText")
  self._slider_effect = self:AddComponent(UIBaseContainer, "contentView/Top/ScoreSlider/Fill Area/Fill/Eff_ui_ganenjie_jindutiao_faguang")
  self._slider_effect_particle = self._slider_effect.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  self._slider_effect:SetActive(false)
  self._open_tip_txt = self:AddComponent(UIText, "contentView/Top/OpenTipText")
  self._desc_tip_txt = self:AddComponent(UIText, "contentView/Rect_Bottom/DescTipText")
  self._desc_tip_txt:SetText("")
  self.itemBar1 = self:AddComponent(UITopItem, "contentView/Top/ItemBar1")
  self.rankRewardList = {}
  self.content = self:AddComponent(UIBaseContainer, "contentView/Top/rankRewardShow/rankRewardShowContent")
  self.uiCommonResItem = self:AddComponent(UICommonResItem, "contentView/Top/rankRewardShow/UICommonResItem")
  self.uiCommonResItem:SetActive(false)
  self.uiCommonResItem.gameObject:GameObjectCreatePool()
  self.battle_content = AttackMonsterModelShowManager.New()
  self.battle_raw_img = self:AddComponent(UIRawImage, battle_raw_img_path)
  self.battle_raw_img:SetActive(false)
  self.battle_content:SetRawImgData(self.battle_raw_img, battleRawImgSizeX, battleRawImgSizeY)
  self.btn_drop_tip = self:AddComponent(UIButton, btn_drop_tip_path)
  self.btn_task = self:AddComponent(UIButton, btn_task_path)
  self.btn_change = self:AddComponent(UIButton, btn_change_path)
  self.btn_drop_tip:SetOnClick(function()
    self:OnDropTipClick()
  end)
  self.btn_task:SetOnClick(function()
    self:OnTaskClick()
  end)
  self.btn_change:SetOnClick(function()
    self:OnChangeClick()
  end)
  self.progress_btn = self:AddComponent(UIButton, progress_btn_path)
  self.progress_res_item = self:AddComponent(UICommonResItem, progress_res_item_path)
  self.progress_btn:SetOnClick(function()
    self:OnProgressBtnClick()
  end)
  self.atk_boss_content = self:AddComponent(UIEventTrigger, "contentView/Rect_Bottom/DonateBtn")
  self.atk_boss_content:OnPointerDown(function()
    self:AttackBtnPointDown()
  end)
  self.atk_boss_content:OnPointerUp(function()
    self:AttackBtnPointUp()
  end)
  self.damage_reward_pos = self:AddComponent(UIBaseContainer, damage_reward_pos_path)
  self.blood_content = self:AddComponent(UIBaseContainer, blood_content_path)
  self.monster_name = self:AddComponent(UITextMeshProUGUIEx, monster_name_path)
  self.monster_blood_bg = self:AddComponent(UIImage, monster_blood_bg_path)
  self.monster_blood_img = self:AddComponent(UIImage, monster_blood_img_path)
  self.monster_blood_val = self:AddComponent(UITextMeshProUGUIEx, monster_blood_val_path)
  self.monster_plot_content = self:AddComponent(UIBaseContainer, monster_plot_content_path)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.text_cost1 = self:AddComponent(UIText, text_cost1_path)
  self.attack_boss_btn_icon = self:AddComponent(UIImage, attack_boss_btn_icon_path)
  self.attack_boss_btn_txt = self:AddComponent(UIText, attack_boss_btn_txt_path)
  self.attack_boss_btn = self:AddComponent(UIEventTrigger, attack_boss_btn_path)
  self.attack_boss_btn:OnPointerDown(function()
    self:AttackBtn2PointDown()
  end)
  self.attack_boss_btn:OnPointerUp(function()
    self:AttackBtn2PointUp()
  end)
  self.reward_boss_btn = self:AddComponent(UIButton, reward_boss_btn_path)
  self.reward_boss_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:BossRewardBtnClick()
  end)
  self.reward_boss_btn:SetActive(false)
  self.monster_fin_box = self:AddComponent(UIButton, monster_fin_box_path)
  self.monster_fin_box:SetOnClick(function()
    self:OnMonsterFinBoxClick()
  end)
  self.monster_fin_box:SetActive(false)
  self.reward_boss_btn_ani = self:AddComponent(UIAnimator, reward_boss_btn_path)
  self.eff_ui_attack_boss_btn_icon1 = self:AddComponent(UIBaseContainer, eff_ui_attack_boss_btn_icon1_path)
  self.eff_ui_attack_boss_btn_icon2 = self:AddComponent(UIBaseContainer, eff_ui_attack_boss_btn_icon2_path)
  self.box_ani = self:AddComponent(UIAnimator, box_ani_path)
  self.eff_ui_yanhui_baoxiangdiaoluo = self:AddComponent(UIBaseContainer, eff_ui_yanhui_baoxiangdiaoluo_path)
  self.eff_ui_yanhui_baoxiangidle1 = self:AddComponent(UIBaseContainer, eff_ui_yanhui_baoxiangidle1_path)
  self.eff_ui_yanhui_baoxiangidle2 = self:AddComponent(UIBaseContainer, eff_ui_yanhui_baoxiangidle2_path)
  self.eff_ui_yanhui_baoxiangkaiqi1 = self:AddComponent(UIBaseContainer, eff_ui_yanhui_baoxiangkaiqi1_path)
  self.eff_ui_yanhui_baoxiangkaiqi2 = self:AddComponent(UIBaseContainer, eff_ui_yanhui_baoxiangkaiqi2_path)
  self.plot_bubble = self:AddComponent(UIBaseContainer, plot_bubble_path)
  self.plot_txt_content = self:AddComponent(UIText, plot_txt_content_path)
  self.plot_bubble.transform:DOKill()
  self.level_reward_red_point = self:AddComponent(UIImage, level_reward_red_point_path)
  self.level_reward_red_num = self:AddComponent(UIText, level_reward_red_num_path)
  self.task_red_point = self:AddComponent(UIImage, task_red_point_path)
  self.task_red_num = self:AddComponent(UIText, task_red_num_path)
  self.change_red_point = self:AddComponent(UIImage, change_red_point_path)
  self.change_red_num = self:AddComponent(UIText, change_red_num_path)
  self.cost1_red_point = self:AddComponent(UIImage, cost1_red_point_path)
  self.cost1_red_num = self:AddComponent(UIText, cost1_red_num_path)
  self.cost2_red_point = self:AddComponent(UIImage, cost2_red_point_path)
  self.cost2_red_num = self:AddComponent(UIText, cost2_red_num_path)
  self.eff_ui_donate_btn1 = self:AddComponent(UIBaseContainer, eff_ui_donate_btn1_path)
  self.eff_ui_eff_ui_attack_boss1 = self:AddComponent(UIBaseContainer, eff_ui_eff_ui_attack_boss1_path)
  self.eff_ui_reward_boss_btn = self:AddComponent(UIBaseContainer, eff_ui_reward_boss_btn_path)
  self.eff_ui_donate_btn1:SetActive(false)
  self.eff_ui_eff_ui_attack_boss1:SetActive(false)
  self.eff_ui_reward_boss_btn:SetActive(false)
  self.level_exp_fly_pos = self:AddComponent(UIBaseContainer, level_exp_fly_pos_path)
  self.open_box_btn = self:AddComponent(UIButton, open_box_btn_path)
  self.open_box_btn:SetOnClick(function()
    self:OnMonsterFinBoxClick()
  end)
  self.open_box_btn:SetActive(false)
  self.press_tip_content = self:AddComponent(UIBaseContainer, press_tip_content_path)
  self.press_tip_root_ani = self:AddComponent(UIBaseContainer, press_tip_root_ani_path)
  self.press_tip_txt = self:AddComponent(UITextMeshProUGUIEx, press_tip_txt_path)
  self.press_tip_root_ani.transform:DOKill()
  self.press_tip_content:SetActive(false)
  self.touch_boss_btn = self:AddComponent(UIButton, touch_boss_btn_path)
  self.touch_boss_btn:SetOnClick(function()
    self:OnTouchBossBtnClick()
  end)
  self.open_box_red_point = self:AddComponent(UIImage, open_box_red_point_path)
end

function M:Componentdestroy()
  self:StopAnim()
  self:ClearAllItem()
  if self.battle_content then
    self.battle_content:Delete()
    self.battle_content = nil
  end
  self.reward_boss_btn_ani = nil
end

function M:ClearAllItem()
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.uiCommonResItem.gameObject:GameObjectRecycleAll()
  self.rankRewardList = {}
end

function M:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self.isMonsterCreateFin = false
  self.isWeaponCreateFin = false
  self.isAttackMsgCallBack = false
  self.sendAttackMsgWaitTime = 0
  self.actBanquetTemplate = nil
  self.monsterTempList = nil
  self.curMonsterState = BanquetAttackMonsterState.Normal
  self.costBulletType = BanquetAttackMonsterBulletType.None
  self.curMonsterTemp = nil
  self.curState = ViewState.AttackMonster
  self.stateTime = 0
  self.isAtkBossBtnDown = false
  self.atkBossBtnDownTime = 0
  self.isAtkBossHelpBtnDown = false
  self.atkBossHelpBtnDownTime = 0
  self.sendAtkBossTime = 0
  self.isWaitingAtkBossMsgBack = false
  self.curAtkBossBulletNum = 1
  self.atkBossMsgDealList = {}
  self.atkBossMsgDealIndex = 1
  self.plotShowTime = 0
  self.pressTipShowTime = 0
  self.attackBtnPointDownTime = {}
  for i = 1, PressTriggerTime do
    self.attackBtnPointDownTime[i] = 0
  end
end

function M:DataDestroy()
  self:DeleteTimer()
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self.isMonsterCreateFin = nil
  self.isWeaponCreateFin = nil
  self.isAttackMsgCallBack = nil
  self.sendAttackMsgWaitTime = nil
  self.curMonsterState = nil
  self.isAtkBossBtnDown = nil
  self.atkBossBtnDownTime = nil
  self.isAtkBossHelpBtnDown = nil
  self.atkBossHelpBtnDownTime = nil
  self.sendAtkBossTime = nil
  self.isWaitingAtkBossMsgBack = nil
  self.curAtkBossBulletNum = nil
  self.atkBossMsgDealList = nil
  self.atkBossMsgDealIndex = nil
  self.plotShowTime = nil
  self.pressTipShowTime = nil
  self.attackBtnPointDownTime = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetActBanquetDetailInfo, self.OnGetActDetailMsg)
  self:AddUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
  self:AddUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:AddUIListener(EventId.ActBanquetAttackMonsterCreateMonsterFin, self.OnCreateMonsterFin)
  self:AddUIListener(EventId.ActBanquetAttackMonsterCreateWeaponFin, self.OnCreateWeaponFin)
  self:AddUIListener(EventId.ActBanquetAttackMonsterBulletFin, self.OnBulletFinCallBack)
  self:AddUIListener(EventId.ActBanquetAttackMonsterBattle, self.GetBossBattleMsg)
  self:AddUIListener(EventId.ActBanquetAttackMonsterDamageRewardGet, self.GetDamageRewardMsg)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnRefresh)
  self:AddUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirm, self.OnFinBoxConfirmMsg)
  self:AddUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirmClose, self.OnFinBoxConfirmViewClose)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:AddUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetActBanquetDetailInfo, self.OnGetActDetailMsg)
  self:RemoveUIListener(EventId.ActBanquetScoreRewardReceive, self.OnGetScoreRewardMsg)
  self:RemoveUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterCreateMonsterFin, self.OnCreateMonsterFin)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterCreateWeaponFin, self.OnCreateWeaponFin)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterBulletFin, self.OnBulletFinCallBack)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterBattle, self.GetBossBattleMsg)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterDamageRewardGet, self.GetDamageRewardMsg)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnRefresh)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirm, self.OnFinBoxConfirmMsg)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirmClose, self.OnFinBoxConfirmViewClose)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
end

function M:OnFreeRewardReceive()
  self:RefreshRedPoint()
end

local function StartPassDayTimer(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 1
  self.passDayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnPassDay()
  end, delayS)
end

function M:SetData(activityId)
  local isBattleRawImgShow = false
  if self.battle_content.sceneLoadRequest == nil then
    isBattleRawImgShow = false
  else
    isBattleRawImgShow = true
  end
  self.isMonsterCreateFin = isBattleRawImgShow
  self.isWeaponCreateFin = isBattleRawImgShow
  self.isAttackMsgCallBack = isBattleRawImgShow
  self.battle_raw_img:SetActive(isBattleRawImgShow)
  self.costBulletType = BanquetAttackMonsterBulletType.None
  self.sendAttackMsgWaitTime = 0
  self.atkBossMsgDealList = {}
  self.atkBossMsgDealIndex = 1
  self.isAtkBossBtnDown = false
  self:SetAtkBossBtnScale()
  self.atkBossBtnDownTime = 0
  self.sendAtkBossTime = 0
  self.isWaitingAtkBossMsgBack = false
  self.curAtkBossBulletNum = 1
  self.activityId = activityId
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self:SetCurShowTempByDetailData()
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2Info, tonumber(activityId))
  StartPassDayTimer(self)
  self:OnModelShowStart()
  self:SetMondelShowCurData()
  self:SetCurViewStateAtEnter()
  self:StopPlotShow()
  self:StopPressTipShow()
  self.eff_ui_donate_btn1:SetActive(false)
  self.eff_ui_eff_ui_attack_boss1:SetActive(false)
  self.eff_ui_reward_boss_btn:SetActive(false)
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = true
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
  PostEventLog.Track(PostEventLog.Defines.BanquetAttackMonsterOpen, {})
end

function M:OnGetActDetailMsg()
  self:SetCurShowTempByDetailData()
  if self.battle_content.sceneLoadRequest == nil then
    self:OnModelShowStart()
  end
  self:OnRefresh()
end

function M:SetCurShowTempByDetailData()
  self.actBanquetId = DataCenter.ActBanquetV2Data.actBanquetId
  self.actBanquetTemplate = DataCenter.ActBanquetV2Data.actBanquetTemplate
  if self.actBanquetTemplate == nil then
    return
  end
  self.monsterTempList = {}
  local monsterIds = self.actBanquetTemplate.monster_order
  for k, v in ipairs(monsterIds) do
    local monsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(v)
    self.monsterTempList[v] = monsterTemp
  end
  self:SetCurMonsterTemp()
end

function M:SetCurMonsterTemp()
  local curMonsterIndex = DataCenter.ActBanquetV2Data.index
  local curMonsterId = self.actBanquetTemplate.monster_order[curMonsterIndex + 1]
  self.curMonsterTemp = self.monsterTempList[curMonsterId]
end

function M:OnRefresh()
  if self.actListData then
    self:RefreshTime(self.actListData)
    self:AddTimer(self.actListData)
    self:RefreshBanquetLevel(true)
    self:RefreshTitle(self.actListData)
    self:ShowScore(false)
    self:RefreshOpenTips()
    self:RefreshRedPoint()
    self:RefreshTopItem()
    self:RefreshRankRewardShow()
    self:SetMondelShowCurData()
    self:RefreshBattleContentView()
    self:SetCurViewStateAtEnter()
    self:SetMonsterFinBoxIdle()
  end
end

function M:RefreshRankRewardShow()
  self:ClearAllItem()
  local rank_reward_show_list = DataCenter.ActBanquetV2Data.actBanquetTemplate.rank_reward_show_list
  for k, v in ipairs(rank_reward_show_list) do
    local index = k
    local item = self.uiCommonResItem.gameObject:GameObjectSpawn(self.content.transform)
    item.name = index
    local obj = self.content:AddComponent(UICommonResItem, item.name)
    obj:SetActive(true)
    obj:ReInit(v)
    obj:SetImgQuailtyShow(false)
    obj:SetItemCountActive(false)
    self.rankRewardList[index] = obj
  end
end

function M:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function M:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
    UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
    end, nil, function()
      EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
    end)
  else
    self._time_txt:SetColor(WhiteColor)
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
  end
end

function M:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function M:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2Info, self.activityId)
end

function M:RefreshTitle(actListData)
  self._actName_txt:SetLocalText(actListData.name)
end

function M:OnRefreshScore(isAdd, reward)
  self:ShowScore(isAdd, reward)
end

function M:ShowScore(isAdd, rewards)
  local score = DataCenter.ActBanquetV2Data:GetActScore()
  local nextTargetScore = DataCenter.ActBanquetV2Data:GetActNextTargetScore()
  local curLevel = DataCenter.ActBanquetV2Data:GetCurBanquetLevel()
  local maxLevel = DataCenter.ActBanquetV2Data:GetBanquetMaxLevel()
  if score then
    self._slider_effect:SetActive(isAdd)
    self._slider_effect_particle:Play()
    if nextTargetScore then
      self._slider_txt:SetText(score .. "/" .. nextTargetScore)
      self.curScoreText:SetLocalText("2000275", curLevel)
      self:StopAnim()
      self.sequence = CS.DG.Tweening.DOTween.Sequence()
      self.sequence:AppendInterval(0.2)
      self.sequence:Append(self._slider:DOValue(score / nextTargetScore, 0.6))
      self.sequence:AppendInterval(0.2)
      self.sequence:AppendCallback(function()
        if rewards then
          DataCenter.RewardManager:ShowCommonReward({reward = rewards})
        end
      end)
    else
      self._slider:SetValue(1)
      self._slider_txt:SetText(score)
      self.curScoreText:SetLocalText("2000275", maxLevel)
      if rewards then
        DataCenter.RewardManager:ShowCommonReward({reward = rewards})
      end
    end
  end
end

function M:StopAnim()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function M:OnIntroClick()
  if self.actListData ~= nil and self.actListData.story ~= nil and self.actBanquetTemplate ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.actListData.story, self.actBanquetTemplate.add_score1[1], self.actBanquetTemplate.add_score1[2], self.actBanquetTemplate.add_score2[1], self.actBanquetTemplate.add_score2[2], self.actBanquetTemplate.add_score4, self.actBanquetTemplate.add_score3)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function M:OnClickReward()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.BanquetAttackMonsterRankAndReward, {anim = true}, toInt(self.activityId), self.actBanquetId)
  end
end

function M:RefreshTopItem()
  self.itemBar1:RefreshData()
end

function M:RefreshBanquetLevel(isInit)
  local scoreRewardIndex = -1
  local level = DataCenter.ActBanquetV2Data.banquetLevel
  local boxDataList = DataCenter.ActBanquetV2Data:GetActScoreList()
  local maxCanGetIndex = 1
  for i = 1, #boxDataList do
    local param = boxDataList[i]
    if param and level >= param.targetLevel then
      if param.state ~= 1 then
        scoreRewardIndex = i
        break
      end
      maxCanGetIndex = i
    end
  end
  if scoreRewardIndex < 0 then
    scoreRewardIndex = maxCanGetIndex
  end
  local targetParam = boxDataList[scoreRewardIndex]
  local targetRewardList = targetParam.reward
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(targetRewardList)
  if showList and 0 < #showList then
    self.progress_res_item:ReInit(showList[1])
  end
end

function M:RefreshOpenTips()
  if self.actBanquetTemplate == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local openDays = UITimeManager:GetInstance():GetBetweenDaysForServer(self.actListData.startTime / 1000, curTime / 1000)
  local openDic = DataCenter.ActBanquetV2Data.actBanquetTemplate.open_dic
  for k, v in ipairs(openDic) do
    if k > openDays + 1 then
      local endDayTime = self.actListData.startTime / 1000 + (k - 1) * 86400
      self._open_tip_txt:SetLocalText("thanksactivity_UI065", UITimeManager:GetInstance():SecondToFmtString(endDayTime - curTime / 1000))
      return
    end
  end
  self._open_tip_txt:SetText("")
end

function M:OnDropTipClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BanquetAttackMonsterRateReward, {anim = true}, self.activityId)
end

function M:OnTaskClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.BanquetAttackMonsterTask, {anim = true}, self.activityId)
end

function M:OnChangeClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  if self.actListData then
    local jumpTo = self.actListData:GetFirstActiveJumpTo()
    if 0 < jumpTo then
      GoToUtil.GoActWindow({jumpTo}, false)
    end
  end
end

function M:OnProgressBtnClick()
  local canClick = self:CanClickBtn()
  if not canClick then
    return
  end
  PostEventLog.Track(PostEventLog.Defines.BanquetAttackMonsterLevelRewardOpen, {})
  local targetPos = self.progress_btn.transform.position
  UIManager:GetInstance():OpenWindow(UIWindowNames.BanquetAttackMonsterLevelReward, {anim = true}, self.activityId, targetPos)
end

function M:Update1000MS()
  self:RefreshOpenTips()
end

function M:OnCreateWeaponFin()
  if self.isWeaponCreateFin then
    return
  end
  self.isWeaponCreateFin = true
  self:CheckCreateFin()
end

function M:CheckCreateFin()
  if self.isMonsterCreateFin and self.isWeaponCreateFin then
    TimerManager:GetInstance():DelayFrameInvoke(function()
      self.battle_raw_img:SetActive(true)
    end, 2)
  end
end

function M:OnCreateMonsterFin()
  if self.isMonsterCreateFin then
    return
  end
  self.isMonsterCreateFin = true
  self:CheckCreateFin()
end

function M:RefreshRedPoint()
  local levelRewardRed = DataCenter.ActBanquetV2Data:GetActLevelRewardRed()
  local cost1Red = DataCenter.ActBanquetV2Data:GetActCost1Red()
  local cost2Red = DataCenter.ActBanquetV2Data:GetActCost2Red()
  local taskRed = DataCenter.ActBanquetV2Data:GetActTaskRed()
  local jumpActRed = DataCenter.ActBanquetV2Data:JumpActRedNum()
  self.level_reward_red_point:SetActive(0 < levelRewardRed)
  self.level_reward_red_num:SetText("")
  self.cost1_red_point:SetActive(0 < cost1Red)
  self.cost1_red_num:SetText("")
  self.open_box_red_point:SetActive(0 < cost1Red)
  self.cost2_red_point:SetActive(0 < cost2Red)
  self.cost2_red_num:SetText("")
  self.task_red_point:SetActive(0 < taskRed)
  self.task_red_num:SetText(tostring(taskRed))
  self.change_red_point:SetActive(0 < jumpActRed)
  self.change_red_num:SetText(tostring(jumpActRed))
end

function M:CanClickBtn()
  local canClick = true
  return canClick
end

function M:Update()
  self.battle_content:OnUpdate()
  local deltaTime = Time.deltaTime
  if self.stateTime > 0 then
    self.stateTime = self.stateTime - deltaTime
    if self.stateTime <= 0 then
      self:TryStateChange()
    end
  end
  if 0 < self.plotShowTime then
    self.plotShowTime = self.plotShowTime - deltaTime
    if 0 >= self.plotShowTime then
      self:StopPlotShow()
    end
  end
  if 0 < self.pressTipShowTime then
    self.pressTipShowTime = self.pressTipShowTime - deltaTime
    if 0 >= self.pressTipShowTime then
      self:StopPressTipShow()
    end
  end
end

function M:TryStateChange()
  if self.curState == ViewState.BoxDrop then
    if self.stateTime <= 0 then
      self.curState = ViewState.BoxIdle
      self.stateTime = 0
      self:SetMonsterFinBoxIdle()
    end
  elseif self.curState == ViewState.BoxConfirm then
    if self.stateTime <= 0 then
      self.curState = ViewState.FinBosViewCloseWaiting
      self.stateTime = 0
      SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2MonsterConfirm, self.activityId, self.actBanquetId, DataCenter.ActBanquetV2Data.index)
    end
  elseif self.curState == ViewState.MonsterDead and self.stateTime <= 0 then
    self.curState = ViewState.BoxDrop
    self.stateTime = 0.8
    self:RefreshBattleContentView()
    self:SetMonsterFinBoxDrop()
  end
end

function M:OnGetScoreRewardMsg()
  self:OnRefresh()
end

function M:OnModelShowStart()
  if self.actBanquetTemplate == nil then
    return
  end
  local modelShowData = {
    monsterData = {},
    weaponData = {
      [0] = {
        modelPath = "Assets/_Art_LastWar/Models/Characters/Soldier/bubing02/prefab/A_Hero_bubing02_yanhui.prefab",
        firePoint = "Hero@bubing02_skin (1)/To_unity/DeformationSystem/Root/gun/firepoint",
        bulletType = BanquetAttackMonsterBulletType.Normal
      },
      [1] = {
        modelPath = "Assets/_Art_LastWar/Models/Cars/A_Hero_Hager/prefab/Hero_Hager_yanhui.prefab",
        firePoint = "A_Hero_Hager_01_skin/To_unity/DeformationSystem/Root/weapon/fire_point",
        bulletType = BanquetAttackMonsterBulletType.Special
      }
    }
  }
  local monsterIds = self.actBanquetTemplate.monster_order
  for k, v in ipairs(monsterIds) do
    if modelShowData.monsterData[v] == nil then
      local monsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(v)
      modelShowData.monsterData[v] = {monsterTemp = monsterTemp}
    end
  end
  self.battle_content:SetModelShowData(modelShowData)
  self.battle_content:StartShow()
end

function M:OnModelShowEnd()
  self.battle_content:EndShow()
end

function M:SetMondelShowCurData()
  if self.actBanquetTemplate == nil then
    return
  end
  local curMonsterIndex = DataCenter.ActBanquetV2Data.index
  local curMonsterId = self.actBanquetTemplate.monster_order[curMonsterIndex + 1]
  local curMonsterState = DataCenter.ActBanquetV2Data.state
  local curData = {
    monsterData = {curMonsterId = curMonsterId, curMonsterState = curMonsterState}
  }
  self.battle_content:SetCurData(curData)
end

function M:SetCurViewStateAtEnter()
  if self.actBanquetTemplate == nil then
    return
  end
  local curMonsterState = DataCenter.ActBanquetV2Data.state
  if curMonsterState == BanquetAttackMonsterState.GetReward then
    self.curState = ViewState.BoxIdle
    self.stateTime = 0
  else
    self.curState = ViewState.AttackMonster
    self.stateTime = 0
  end
end

function M:GetIsDoingBulletAni()
  local isDoingBulletAni = true
  local msgLen = #self.atkBossMsgDealList
  if msgLen < self.atkBossMsgDealIndex then
    isDoingBulletAni = false
  else
    isDoingBulletAni = true
  end
  return isDoingBulletAni
end

function M:OnAtkBossBulletDataStart(data)
  self.battle_content:BulletDataStart(data)
end

function M:GetBossBattleMsg(msg)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curButtleAniIsDoing = self:GetIsDoingBulletAni()
  self.isWaitingAtkBossMsgBack = false
  self.curMonsterState = msg.state
  local damageDetailList = msg.damageDetail
  if damageDetailList and 0 < #damageDetailList then
    for k, v in ipairs(damageDetailList) do
      table.insert(self.atkBossMsgDealList, {
        data = v,
        speed = #damageDetailList,
        type = msg.type
      })
    end
  end
  if not curButtleAniIsDoing then
    self:OnAtkBossBulletDataStart(self.atkBossMsgDealList[self.atkBossMsgDealIndex])
  end
  self:RefreshCostNumContent()
  self:RefreshBanquetLevel(true)
  self:ShowScore(false)
end

function M:OnAtkBossBulletDataFin()
  local msgLen = #self.atkBossMsgDealList
  if 0 < msgLen then
    if msgLen >= self.atkBossMsgDealIndex then
      local curIndex = self.atkBossMsgDealIndex
      local dealMsg = self.atkBossMsgDealList[curIndex]
      self:DealBossBattleMsg(dealMsg.data, dealMsg)
      self.atkBossMsgDealIndex = curIndex + 1
      if msgLen >= self.atkBossMsgDealIndex then
        self:OnAtkBossBulletDataStart(self.atkBossMsgDealList[self.atkBossMsgDealIndex])
      end
    end
    if msgLen < self.atkBossMsgDealIndex then
      self.atkBossMsgDealList = {}
      self.atkBossMsgDealIndex = 1
    end
  end
end

function M:DealBossBattleMsg(msg, bulletData)
  local damageRewardList = DataCenter.RewardManager:ReturnRewardParamForView(msg.damageReward)
  for k, v in ipairs(damageRewardList) do
    if v.rewardType == RewardType.GOODS or v.rewardType == RewardType.RESOURCE_ITEM then
      local rewardType = v.rewardType
      local itemId = v.itemId
      local addNum = v.count
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      local flyPos = self.reward_boss_btn.transform.position
      local flyNum = math.floor(addNum / 10)
      flyNum = math.max(flyNum, 1)
      flyNum = math.min(flyNum, 10)
      local model = "Assets/_Art/Effect/prefab/ui/Common/FlyGoodsReverseDirPath.prefab"
      UIUtil.DoFlyWithoutLogic(pic, flyNum, self.damage_reward_pos.transform.position, flyPos, 80, 80, function()
        if self.reward_boss_btn_ani == nil then
          return
        end
        self.reward_boss_btn_ani:Play("Eff_ui_BanquetAttackMonster2")
        self.eff_ui_reward_boss_btn:SetActive(false)
        self.eff_ui_reward_boss_btn:SetActive(true)
      end, model, -1, 1, 0.001, 0.6)
    end
  end
  local iconName = self.actBanquetTemplate.score_pic
  local iconPath = string.format(LoadPath.ItemPath, iconName)
  local flyPos = self.level_exp_fly_pos.transform.position
  local flyNum = math.floor(msg.score / 100)
  flyNum = math.max(flyNum, 1)
  flyNum = math.min(flyNum, 10)
  UIUtil.DoFly(nil, flyNum, iconPath, self.damage_reward_pos.transform.position, flyPos, 80, 80, nil, nil, 1)
  if bulletData.type == BanquetAttackMonsterBulletType.Normal then
    if not string.IsNullOrEmpty(self.curMonsterTemp.act_2_text) then
      self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_2_text))
    end
  elseif not string.IsNullOrEmpty(self.curMonsterTemp.act_3_text) then
    self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_3_text))
  end
  if msg.blood <= 0 then
    self.isAtkBossBtnDown = false
    self:SetAtkBossBtnScale()
    local reward = msg.boosStageReward
    local rewardData = {reward = reward}
    DataCenter.RewardManager:ShowCommonReward(rewardData)
    self.curState = ViewState.MonsterDead
    self.stateTime = 0.5
    self.battle_content.monsterModelManager:TryMonsterPlayDeadAni()
    if not string.IsNullOrEmpty(self.curMonsterTemp.act_4_text) then
      self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_4_text))
    end
  end
  self:RefreshBloodContent(msg.blood)
  self:RefreshBossDamageRewardView()
end

function M:OnBulletFinCallBack()
  self:OnAtkBossBulletDataFin()
end

function M:AttackBtnPointDown()
  if self.isAtkBossBtnDown then
    return
  end
  if self.actBanquetTemplate == nil then
    return
  end
  if DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.GetReward then
    UIUtil.ShowTipsId("activity_newparty_desc17")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.isAtkBossBtnDown = true
  self:SetAtkBossBtnScale()
  self.atkBossBtnDownTime = curTime
  self.curAtkBossBulletNum = 1
  self.costBulletType = BanquetAttackMonsterBulletType.Normal
  self:SetPressTime(curTime)
  self:Update100MS()
end

function M:AttackBtnPointUp()
  self.isAtkBossBtnDown = false
  self:SetAtkBossBtnScale()
end

function M:AttackBtn2PointDown()
  if self.isAtkBossBtnDown then
    return
  end
  if self.actBanquetTemplate == nil then
    return
  end
  if DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.GetReward then
    UIUtil.ShowTipsId("activity_newparty_desc17")
    return
  end
  self.eff_ui_eff_ui_attack_boss1:SetActive(false)
  self.eff_ui_eff_ui_attack_boss1:SetActive(true)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.isAtkBossBtnDown = true
  self:SetAtkBossBtnScale()
  self.atkBossBtnDownTime = curTime
  self.curAtkBossBulletNum = 1
  self.costBulletType = BanquetAttackMonsterBulletType.Special
  self:Update100MS()
end

function M:AttackBtn2PointUp()
  self.isAtkBossBtnDown = false
  self:SetAtkBossBtnScale()
end

function M:TrySendAtkBossMsg()
  local isSuccess = false
  if self.actBanquetTemplate == nil then
    return isSuccess
  end
  if self.costBulletType == BanquetAttackMonsterBulletType.None then
    return isSuccess
  end
  local canUseBulletNum = self.curAtkBossBulletNum
  local costData
  local onceNeedNum = 0
  local curNum = 0
  local maxCanBulletNum = 0
  if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
    costData = self.actBanquetTemplate.cost_item
    onceNeedNum = self.actBanquetTemplate.unit_num
  elseif self.costBulletType == BanquetAttackMonsterBulletType.Special then
    costData = self.actBanquetTemplate.cost_item2
    onceNeedNum = self.actBanquetTemplate.unit_num2
  end
  if costData == nil then
    return isSuccess
  end
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  end
  if self.costBulletType == BanquetAttackMonsterBulletType.Special and 0 < maxCanBulletNum then
    local useNum = math.min(canUseBulletNum, maxCanBulletNum)
    local specialBulletDamage = self.actBanquetTemplate.special_damage[1][1]
    local curBlood = DataCenter.ActBanquetV2Data.blood
    local curBulletDamage = useNum * specialBulletDamage
    if curBlood < curBulletDamage then
      if specialBulletDamage > curBlood then
        UIUtil.ShowNoToggleSecondMessage(Localization:GetString("100378"), Localization:GetString("activity_newparty_desc21"), 2, "", "", function()
          SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, DataCenter.ActBanquetV2Data.index, 1, BanquetAttackMonsterBulletType.Special)
        end, function(needSellConfirm)
        end, function()
        end, nil, nil, nil, nil, nil, nil, false)
        return isSuccess
      else
        canUseBulletNum = math.floor(curBlood / specialBulletDamage)
      end
    end
  end
  if maxCanBulletNum <= 0 then
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      LWResourceLackUtil:GotoResourceItemLack(costData[2], onceNeedNum - curNum)
    else
      LWResourceLackUtil:GotoGoodsItemLack(costData[2], onceNeedNum - curNum)
    end
    isSuccess = false
    if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
      PostEventLog.Track(PostEventLog.Defines.BanquetAttackMonsterCost1LackOpen, {})
    elseif self.costBulletType == BanquetAttackMonsterBulletType.Special then
      PostEventLog.Track(PostEventLog.Defines.BanquetAttackMonsterCost2LackOpen, {})
    end
  else
    local useNum = math.min(canUseBulletNum, maxCanBulletNum)
    local costNum = useNum * onceNeedNum
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, DataCenter.ActBanquetV2Data.index, costNum, self.costBulletType)
    isSuccess = true
  end
  return isSuccess
end

function M:Update100MS()
  if not self.activityId then
    return
  end
  if self.actListData == nil then
    return
  end
  if self.actBanquetTemplate == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isAtkBossBtnDown ~= false and curTime > self.sendAtkBossTime + AtkBossDeltaTime and self.isWaitingAtkBossMsgBack == false and DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.Normal then
    if curTime > self.atkBossBtnDownTime + AtkBossBulletAddTime then
      self.curAtkBossBulletNum = self.curAtkBossBulletNum * 2
      self.curAtkBossBulletNum = math.min(self.curAtkBossBulletNum, AtkBossBulletNum)
    end
    local isSendSuccess = self:TrySendAtkBossMsg()
    if isSendSuccess then
      self.sendAtkBossTime = curTime
      self.isWaitingAtkBossMsgBack = true
      if curTime > self.atkBossBtnDownTime + AtkBossDeltaTime then
        local preIsTriggerPress = DataCenter.ActBanquetV2Data:GetIsTriggerPress()
        if preIsTriggerPress == false then
          DataCenter.ActBanquetV2Data:SetIsTriggerPress()
          self:StopPressTipShow()
        end
      end
    else
      self.isAtkBossBtnDown = false
      self:SetAtkBossBtnScale()
    end
  end
end

function M:SetAtkBossBtnScale()
  local pressScale = 0.9
  local normalScale = 1
  if self.isAtkBossBtnDown == true then
    if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
      self.atk_boss_content:SetLocalScaleXYZ(pressScale, pressScale, pressScale)
      self.attack_boss_btn:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
    elseif self.costBulletType == BanquetAttackMonsterBulletType.Special then
      self.atk_boss_content:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
      self.attack_boss_btn:SetLocalScaleXYZ(pressScale, pressScale, pressScale)
    else
      self.atk_boss_content:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
      self.attack_boss_btn:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
    end
  else
    self.atk_boss_content:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
    self.attack_boss_btn:SetLocalScaleXYZ(normalScale, normalScale, normalScale)
  end
end

function M:RefreshBattleContentView()
  self.monster_name:SetLocalText(self.curMonsterTemp.name)
  local costItem1PicPath = ""
  local costData = self.actBanquetTemplate.cost_item
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    costItem1PicPath = DataCenter.RewardManager:GetPicByType(ResTypeToReward[costData[2]], 0)
  elseif costData[1] == BanquetAttackMonsterCostType.Goods then
    costItem1PicPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(costData[2]))
  end
  self.img_cost_item1:LoadSprite(costItem1PicPath)
  local costItem2PicPath = ""
  local costData2 = self.actBanquetTemplate.cost_item2
  if costData2[1] == BanquetAttackMonsterCostType.Resource then
    costItem2PicPath = DataCenter.RewardManager:GetPicByType(ResTypeToReward[costData2[2]], 0)
  elseif costData2[1] == BanquetAttackMonsterCostType.Goods then
    costItem2PicPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(costData2[2]))
  end
  self.attack_boss_btn_icon:LoadSprite(costItem2PicPath)
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    self.itemBar1:SetData(nil, costData[2])
  elseif costData[1] == BanquetAttackMonsterCostType.Goods then
    self.itemBar1:SetData(costData[2])
  end
  self.blood_content:SetAnchoredPositionXY(0, self.curMonsterTemp.blood_pos)
  if #self.curMonsterTemp.plot_pos == 2 then
    self.monster_plot_content:SetAnchoredPositionXY(self.curMonsterTemp.plot_pos[1], self.curMonsterTemp.plot_pos[2])
  else
    self.monster_plot_content:SetAnchoredPositionXY(0, self.curMonsterTemp.plot_pos[1])
  end
  self:RefreshBloodContent()
  self:RefreshCostNumContent()
  self:RefreshBossDamageRewardView()
  self:RefreshMonsterFinBox()
end

function M:RefreshBloodContent(inputBlood)
  local viewW = 390
  local viewH = 19
  local showBlood = 0
  if inputBlood then
    showBlood = inputBlood
  else
    showBlood = DataCenter.ActBanquetV2Data.blood
  end
  local maxBlood = self.curMonsterTemp.blood
  local showRate = showBlood / maxBlood
  showRate = math.min(showRate, 1)
  showRate = math.max(showRate, 0)
  self.monster_blood_val:SetText(showBlood .. "/" .. maxBlood)
  self.monster_blood_img:SetSizeDeltaXY(viewW * showRate, viewH)
end

function M:RefreshCostNumContent()
  local costData
  local onceNeedNum = 0
  local curNum = 0
  costData = self.actBanquetTemplate.cost_item
  onceNeedNum = self.actBanquetTemplate.unit_num
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
  end
  self.text_cost1:SetText(curNum .. "/" .. onceNeedNum)
  costData = self.actBanquetTemplate.cost_item2
  onceNeedNum = self.actBanquetTemplate.unit_num2
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
  end
  self.attack_boss_btn_txt:SetText(curNum .. "/" .. onceNeedNum)
  local isCost2Enough = onceNeedNum <= curNum
  self.eff_ui_attack_boss_btn_icon1:SetActive(isCost2Enough)
  self.eff_ui_attack_boss_btn_icon2:SetActive(isCost2Enough)
  self.itemBar1:RefreshData()
end

function M:RefreshBossDamageRewardView()
  self.reward_boss_btn:SetActive(#DataCenter.ActBanquetV2Data.extraReward > 0)
end

function M:RefreshMonsterFinBox()
  self.monster_fin_box:SetActive(DataCenter.ActBanquetV2Data.blood <= 0)
  self.open_box_btn:SetActive(DataCenter.ActBanquetV2Data.blood <= 0)
  self._donate_btn:SetActive(DataCenter.ActBanquetV2Data.blood > 0)
  self:StopPressTipShow()
end

function M:SetMonsterFinBoxDrop()
  if DataCenter.ActBanquetV2Data.blood > 0 then
    return
  end
  self.eff_ui_yanhui_baoxiangdiaoluo:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle1:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle2:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi1:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi2:SetActive(false)
  self.eff_ui_yanhui_baoxiangdiaoluo:SetActive(true)
  if self.curMonsterTemp.type == BanquetAttackMonsterBossType.Normal then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster2_diaoluo1")
  elseif self.curMonsterTemp.type == BanquetAttackMonsterBossType.Special then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_diaoluo1")
  end
end

function M:SetMonsterFinBoxIdle()
  if DataCenter.ActBanquetV2Data.blood > 0 then
    return
  end
  self.eff_ui_yanhui_baoxiangdiaoluo:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle1:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle2:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi1:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi2:SetActive(false)
  if self.curMonsterTemp.type == BanquetAttackMonsterBossType.Normal then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster2_idle1")
    self.eff_ui_yanhui_baoxiangidle1:SetActive(true)
  elseif self.curMonsterTemp.type == BanquetAttackMonsterBossType.Special then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_idle1")
    self.eff_ui_yanhui_baoxiangidle2:SetActive(true)
  end
end

function M:SetMonsterFinBoxOpen()
  if DataCenter.ActBanquetV2Data.blood > 0 then
    return
  end
  self.eff_ui_yanhui_baoxiangdiaoluo:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle1:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle2:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi1:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi2:SetActive(false)
  if self.curMonsterTemp.type == BanquetAttackMonsterBossType.Normal then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster2_kaiqi1")
    self.eff_ui_yanhui_baoxiangkaiqi1:SetActive(true)
  elseif self.curMonsterTemp.type == BanquetAttackMonsterBossType.Special then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_kaiqi1")
    self.eff_ui_yanhui_baoxiangkaiqi2:SetActive(true)
  end
end

function M:GetDamageRewardMsg(t)
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActBanquetV2Data:ClearExtraReward()
  self:RefreshBossDamageRewardView()
end

function M:BossRewardBtnClick()
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2ExtraReward, self.activityId)
end

function M:OnMonsterFinBoxClick()
  if self.curState ~= ViewState.BoxIdle then
    return
  end
  self.curState = ViewState.BoxConfirm
  self.stateTime = 0.7
  self:SetMonsterFinBoxOpen()
end

function M:OnFinBoxConfirmMsg(t)
  if t.killReward ~= nil then
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(t.killReward)
    UIManager:GetInstance():OpenWindow(UIWindowNames.BanquetAttackMonsterFinRewardGet, {anim = false}, {rewardList = rewardList}, t)
  end
end

function M:OnFinBoxConfirmViewClose(msg)
  self.battle_content.monsterModelManager.SetMonsterPlayEnterAtCallBack = true
  self:SetCurMonsterTemp()
  self:RefreshBattleContentView()
  self:SetMondelShowCurData()
  self:SetCurViewStateAtEnter()
  local damageRewardList = msg.rewardList
  for k, v in ipairs(damageRewardList) do
    if v.rewardType == RewardType.GOODS or v.rewardType == RewardType.RESOURCE_ITEM then
      local rewardType = v.rewardType
      local itemId = v.itemId
      local addNum = v.count
      local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
      local flyPos = self.reward_boss_btn.transform.position
      local flyNum = math.floor(addNum / 10)
      flyNum = math.max(flyNum, 1)
      flyNum = math.min(flyNum, 10)
      UIUtil.DoFly(rewardType, flyNum, pic, self.damage_reward_pos.transform.position, flyPos, 80, 80, function()
        if self.reward_boss_btn_ani == nil then
          return
        end
        self.reward_boss_btn_ani:Play("Eff_ui_BanquetAttackMonster2")
        self.eff_ui_reward_boss_btn:SetActive(false)
        self.eff_ui_reward_boss_btn:SetActive(true)
      end, nil, 1)
    end
  end
  if not string.IsNullOrEmpty(self.curMonsterTemp.act_5_text) then
    self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_5_text))
  end
end

function M:StopPlotShow()
  self.plot_bubble:SetActive(false)
  self.plot_bubble.transform:DOKill()
  self.plotShowTime = 0
end

function M:StarPlotShow(txt)
  self.plot_txt_content:SetText(txt)
  self.plot_bubble:SetActive(true)
  self.plot_bubble.transform:DOKill()
  self.plot_bubble.transform:DOLocalRotate(Vector3(0, 0, 2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
  self.plotShowTime = PlotShowTime
end

function M:StopPressTipShow()
  self.press_tip_content:SetActive(false)
  self.press_tip_root_ani.transform:DOKill()
  self.pressTipShowTime = 0
end

function M:StarPressTipShow()
  self.press_tip_content:SetActive(true)
  self.press_tip_root_ani.transform:DOKill()
  self.press_tip_root_ani.transform:DOLocalRotate(Vector3(0, 0, 2), 0.05):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
  self.pressTipShowTime = PressTipShowTime
end

function M:SetPressTime(time)
  for i = 1, PressTriggerTime - 1 do
    self.attackBtnPointDownTime[i] = self.attackBtnPointDownTime[i + 1]
  end
  self.attackBtnPointDownTime[PressTriggerTime] = time
  if self.attackBtnPointDownTime[PressTriggerTime] < self.attackBtnPointDownTime[1] + PressTriggerDeltaTime then
    local preIsTriggerPress = DataCenter.ActBanquetV2Data:GetIsTriggerPress()
    if preIsTriggerPress == false then
      self:StarPressTipShow()
    end
  end
end

function M:GetRefreshItemsMsg()
  self:RefreshCostNumContent()
end

function M:OnTouchBossBtnClick()
  if self.actBanquetTemplate == nil then
    return
  end
  if self.curState ~= ViewState.AttackMonster then
    return
  end
  if DataCenter.ActBanquetV2Data.blood <= 0 then
    return
  end
  self.battle_content.monsterModelManager:TryMonsterPlayTouchAttackedAni()
end

return M
