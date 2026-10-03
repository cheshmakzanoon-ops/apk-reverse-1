local BanquetAttackMonster_Common1 = BaseClass("BanquetAttackMonster_Common1", UIBaseView)
local M = BanquetAttackMonster_Common1
local base = UIBaseView
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local Localization = CS.GameEntry.Localization
local flyRewardBoxPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/Prefab/Eff_ui_Easter2026_yanhui_box_fly_Variant.prefab"
local hitRewardBoxPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/Prefab/Eff_ui_Easter2026_yanhui_box_hit_Variant.prefab"
local AttackMonsterModelShowManager = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.AttackMonsterModelShowManager")
local RewardStashQueueComponentComponent = require("UI.UIActivityCenterTable.Component.BanquetAttackMonster.Component.RewardStashQueueComponentComponent")
local Logger = require("Framework.Logger.Logger")
local ViewState = {
  AttackMonster = 1,
  MonsterDead = 2,
  BoxDrop = 3,
  BoxIdle = 4,
  BoxConfirm = 5,
  FinBosViewCloseWaiting = 6,
  MonsterStart = 7
}
local StateEvent = {
  Timeout = 1,
  MonsterDead = 2,
  BoxConfirmClick = 3,
  AutoConfirmRequest = 4
}
local battleRawImgSizeX = 784
local battleRawImgSizeY = 1122
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
local red_switch_btn_path = "contentView/Rect_Bottom/BtnAutoAttackSwitch/redSwitchBtn"
local checkmark_path = "contentView/Rect_Bottom/BtnAutoAttackSwitch/redSwitchBtn/Background/Checkmark"
local txt_remaing_attack_times_path = "contentView/Rect_Bottom/TxtRemaingAttackTimes"
local btn_flower_train_path = "contentView/Top/BtnList/BtnFlowerTrain"
local btn_flower_train_icon_path = "contentView/Top/BtnList/BtnFlowerTrain/BtnFlowerTrainIcon"
local btn_flower_train_txt_path = "contentView/Top/BtnList/BtnFlowerTrain/BtnFlowerTrainTxt"
local btn_flower_train_red_point_path = "contentView/Top/BtnList/BtnFlowerTrain/BtnFlowerTrainRedPoint"
local btn_flower_train_red_num_path = "contentView/Top/BtnList/BtnFlowerTrain/BtnFlowerTrainRedPoint/BtnFlowerTrainRedNum"
local treasure_box_pos_path = "contentView/Top/BtnList/TreasureBoxPos"
local btn_treasureBox_path = "contentView/Top/BtnList/TreasureBoxPos/BtnTreasureBox"
local btn_treasureBox_red_point_path = "contentView/Top/BtnList/TreasureBoxPos/BtnTreasureBox/BtnTreasureBoxRedPoint"
local btn_treasureBox_red_num_path = "contentView/Top/BtnList/TreasureBoxPos/BtnTreasureBox/BtnTreasureBoxRedPoint/BtnTreasureBoxRedNum"
local bg1_path = "BgMask/Bg1"
local bg2_path = "BgMask/Bg2"
local box1_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani/root/Box1"
local box2_path = "contentView/centerContent/battleContent/monsterFinBox/box_ani/root/Box2"
local fly_box_effect_node_path = "contentView/Rect_Bottom/FlyBoxEffectNode"
local bubble_path = "contentView/centerContent/monsterPlotContent/PlotBubble/root/bubble"

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RequestAllUpgradeTreasureBox()
end

function M:OnDestroy()
  self:Componentdestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self.isWaitingAutoMonsterConfirm = false
  self.isPauseAutoAttackByMonsterDead = false
  self.stateTime = 0
  self.isDuringAutoAttack = false
  self:StopAutoAttack()
  if self.activityId and self.actListData then
    self:SetCurShowTempByDetailData()
    if self.actBanquetTemplate then
      self:OnModelShowStart()
      self:SetMondelShowCurData()
      self:OnRefresh()
    end
  end
end

function M:OnDisable()
  base.OnDisable(self)
  self:StopAnim()
  self:OnModelShowEnd()
  self.isDuringAutoAttack = false
  self:StopAutoAttack()
  self.isWaitingAutoMonsterConfirm = false
  self.isPauseAutoAttackByMonsterDead = false
  self.stateTime = 0
  self:ClearFinBoxTimer()
  self:ClearPushCameraTimer()
  self:ClearPullCameraTimer()
  self:ClearResumeAutoAttackTimer()
  self:StopSound()
end

function M:ComponentDefine()
  self._actName_txt = self:AddComponent(UIText, "contentView/Top/title")
  self._time_txt = self:AddComponent(UIText, "contentView/Top/TimeContent/openTime")
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
  self._donate_btn:SetOnClick(function()
    self:OnClickDonateBtn()
  end)
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
  self.btnAutoAttackCheck = self:AddComponent(UIImage, checkmark_path)
  self.btnAutoAttackSwitch = self:AddComponent(UIButton, red_switch_btn_path)
  self.btnAutoAttackSwitch:SetOnClick(function()
    if self.activityId == nil then
      return
    end
    if self.curState ~= ViewState.AttackMonster then
      return
    end
    local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
    isOnAutoAttack = not isOnAutoAttack
    DataCenter.ActBanquetV2Data:SetIsOnAutoAttack(self.activityId, isOnAutoAttack)
    self.btnAutoAttackCheck:SetActive(isOnAutoAttack)
    if not isOnAutoAttack then
      self.isDuringAutoAttack = false
      self:StopAutoAttack()
    end
  end)
  self.txtRemainAttackNum = self:AddComponent(UIText, txt_remaing_attack_times_path)
  self.textScoreTitle = self:AddComponent(UITextMeshProUGUIEx, "contentView/Top/ScorePart/ScoreTitle")
  self.textScoreTitle:SetLocalText("361001")
  self.textScoreNum = self:AddComponent(UITextMeshProUGUIEx, "contentView/Top/ScorePart/ScoreNum")
  self.stashRewardQueueCpt = self:AddComponent(RewardStashQueueComponentComponent, "contentView/Rect_Bottom/RewardBox/RewardStashQueueComponent")
  self.stashRewardQueueCpt:ReInit(function()
    self:PlayChestShakeAni()
  end)
  self.rewardBoxAni = self:AddComponent(UISimpleAnimation, "contentView/Rect_Bottom/RewardBox/CollectBoxBtn/box")
  self.btnRewardBoxNew = self:AddComponent(UIButton, "contentView/Rect_Bottom/RewardBox/CollectBoxBtn")
  self.btnRewardBoxNew:SetOnClick(function()
    self:OnBtnRewardBoxNew()
  end)
  self.rewardBoxEffectParam = {
    lifeType = UIVfxLifeType.Stay,
    duration = 1,
    onRemove = nil
  }
  self.btnRewardBoxEffect = self:AddComponent(UIVfx, "contentView/Rect_Bottom/RewardBox/CollectBoxEff", nil, self.rewardBoxEffectParam)
  self.boxRedPoint = self:AddComponent(UIImage, "contentView/Rect_Bottom/RewardBox/CollectBoxBtn/boxRedPoint")
  self.boxRedPoint:SetActive(false)
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.compCenterEffect = self:AddComponent(UIVfx, "contentView/CenterEffect")
  self.contentView = self:AddComponent(UIBaseContainer, "contentView")
  self.contentCanvasGroupView = self:AddComponent(UICanvasGroup, "contentView")
  self.btn_flower_train = self:AddComponent(UIButton, btn_flower_train_path)
  self.btn_flower_train:SetOnClick(function()
    self:OnBtnTreasureClick()
  end)
  self.btn_flower_train_icon = self:AddComponent(UIImage, btn_flower_train_icon_path)
  self.btnFlowerTrainRedDot = self:AddComponent(UIBaseContainer, btn_flower_train_red_point_path)
  self.btnFlowerTrainRedDotNum = self:AddComponent(UIText, btn_flower_train_red_num_path)
  self.btnFlowerTrainText = self:AddComponent(UIText, btn_flower_train_txt_path)
  self.btnFlowerTrainText:SetSizeDeltaXY(150, 50)
  self.btnFlowerTrainRedDot:SetActive(false)
  self.treasureBoxPos = self:AddComponent(UIBaseContainer, treasure_box_pos_path)
  self.btn_treasureBox = self:AddComponent(UIButton, btn_treasureBox_path)
  self.btn_treasureBox:SetOnClick(function()
    self:OnBtnTreasureBoxClick()
  end)
  self.btn_treasureBox_red_point = self:AddComponent(UIBaseContainer, btn_treasureBox_red_point_path)
  self.btn_treasureBox_red_num = self:AddComponent(UIText, btn_treasureBox_red_num_path)
  self.treasureBoxPos:SetActive(false)
  self.btn_treasureBox:SetActive(false)
  self.boxRawImage1 = self:AddComponent(UIRawImage, box1_path)
  self.boxRawImage2 = self:AddComponent(UIRawImage, box2_path)
  self.bloodCanvasGroup = self:AddComponent(UICanvasGroup, blood_content_path)
  self.bubble = self:AddComponent(UIImage, bubble_path)
  self.flyBoxEffectNode = self:AddComponent(UIBaseContainer, fly_box_effect_node_path)
end

function M:Componentdestroy()
  self:StopAnim()
  self:ClearAllItem()
  if self.battle_content then
    self.battle_content:Delete()
    self.battle_content = nil
  end
  self.reward_boss_btn_ani = nil
  self.textScoreTitle = nil
  self.textScoreNum = nil
  self.stashRewardQueueCpt = nil
  self.rewardBoxAni = nil
  self.btnRewardBoxNew = nil
  self.compCenterEffect:Stop()
  self.compCenterEffect = nil
  self.contentView = nil
  self.btn_flower_train = nil
  self.btn_flower_train_icon = nil
  self.btnFlowerTrainRedDot = nil
  self.btnFlowerTrainRedDotNum = nil
  self.btnFlowerTrainText = nil
  self.bg2 = nil
  self.boxRawImage1 = nil
  self.boxRawImage2 = nil
  self.bloodCanvasGroup = nil
  self.bubble = nil
  self.treasureBoxPos = nil
  self.btn_treasureBox = nil
  self.btn_treasureBox_red_point = nil
  self.btn_treasureBox_red_num = nil
  self.flyBoxEffectNode = nil
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
  self:InitStateMachine()
  self.isAtkBossBtnDown = false
  self.atkBossBtnDownTime = 0
  self.isAtkBossHelpBtnDown = false
  self.atkBossHelpBtnDownTime = 0
  self.sendAtkBossTime = 0
  self.curAtkBossBulletNum = 1
  self.atkBossMsgDealList = {}
  self.atkBossMsgDealIndex = 1
  self.plotShowTime = 0
  self.pressTipShowTime = 0
  self.attackBtnPointDownTime = {}
  for i = 1, PressTriggerTime do
    self.attackBtnPointDownTime[i] = 0
  end
  self.isDuringAutoAttack = false
  self:StopAutoAttack()
  self.bulletFlyTimeOneSpeed = 0.6
  self.showFlowerTrainRedDot = false
  self.isWaitingAutoMonsterConfirm = false
  self.isPauseAutoAttackByMonsterDead = false
  self.resumeAutoAttackTimer = nil
  self.flyRewardBoxEffectNodeDefaultLocalPos = nil
  self.flyRewardBoxObj = nil
  self.hitBossEffectObj = nil
  self.flyRewardStartTimer = nil
  self.hitRewardShowTimer = nil
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
  self.curAtkBossBulletNum = nil
  self.atkBossMsgDealList = nil
  self.atkBossMsgDealIndex = nil
  self.plotShowTime = nil
  self.pressTipShowTime = nil
  self.attackBtnPointDownTime = nil
  self.isDuringAutoAttack = nil
  self.bulletFlyTimeOneSpeed = nil
  self.showFlowerTrainRedDot = nil
  self.isWaitingAutoMonsterConfirm = nil
  self.isPauseAutoAttackByMonsterDead = nil
  self:ClearResumeAutoAttackTimer()
  self.stateTransitionMap = nil
  self.globalStateTransitions = nil
  self.flyRewardBoxEffectNodeDefaultLocalPos = nil
  self.flyRewardBoxObj = nil
  self.hitBossEffectObj = nil
  self:ClearFlyRewardTimers()
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
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
  self:AddUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirm, self.OnFinBoxConfirmMsg)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:AddUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
  self:AddUIListener(EventId.OnRecUpgradeTreasureBox, self.OnRecUpgradeTreasureBox)
  self:AddUIListener(EventId.UpgradeTreasureBoxOnClose, self.OnUpgradeTreasureBoxClose)
  self:AddUIListener(EventId.BanquetLevelCreateSuccess, self.OnRecCreateLevel)
  self:AddUIListener(EventId.OnRecAutoUpgradeTreasureBoxClose, self.RefreshAutoUpgradeTreasureBoxNum)
  self:AddUIListener(EventId.RefreshAutoUpgradeTreasureBoxNum, self.RefreshAutoUpgradeTreasureBoxNum)
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
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  self:RemoveUIListener(EventId.ActBanquetAttackMonsterFinBoxConfirm, self.OnFinBoxConfirmMsg)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.RefreshItems, self.GetRefreshItemsMsg)
  self:RemoveUIListener(EventId.OnRecUpgradeTreasureBox, self.OnRecUpgradeTreasureBox)
  self:RemoveUIListener(EventId.UpgradeTreasureBoxOnClose, self.OnUpgradeTreasureBoxClose)
  self:RemoveUIListener(EventId.BanquetLevelCreateSuccess, self.OnRecCreateLevel)
  self:RemoveUIListener(EventId.OnRecAutoUpgradeTreasureBoxClose, self.RefreshAutoUpgradeTreasureBoxNum)
  self:RemoveUIListener(EventId.RefreshAutoUpgradeTreasureBoxNum, self.RefreshAutoUpgradeTreasureBoxNum)
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
  self.curAtkBossBulletNum = 1
  self.activityId = activityId
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.bg1:SetActive(false)
  self.bg2:SetActive(false)
  local showTemp = self.actListData:GetShowConfigTemp()
  if showTemp and not string.IsNullOrEmpty(showTemp.banner_effect) then
    self.compCenterEffect:PlayByStay(showTemp.banner_effect)
  end
  UIActivityCenterCommonUtil.SetTopViewColor(self._actName_txt.gameObject, nil, self._time_txt.gameObject, showTemp)
  self:SetCurShowTempByDetailData()
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.contentCanvasGroupView:SetAlpha(0)
  self.contentCanvasGroupView:SetInteractable(false)
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
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
  self.btnAutoAttackCheck:SetActive(DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId))
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
  local monsterIds = DataCenter.ActBanquetV2Data:GetMonsterTypeIdList()
  for k, v in ipairs(monsterIds) do
    local monsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(v)
    self.monsterTempList[v] = monsterTemp
  end
  self:SetCurMonsterTemp()
  self:SetPlotBg()
end

function M:SetCurMonsterTemp()
  local curMonsterId = DataCenter.ActBanquetV2Data:GetNewMonsterId()
  self.curMonsterTemp = self.monsterTempList[curMonsterId]
end

function M:SetPlotBg()
  if self.curMonsterTemp == nil then
    return
  end
  local bubble_color = self.curMonsterTemp.bubble_color
  if not string.IsNullOrEmpty(bubble_color) then
    local colorStr = string.split(bubble_color, ";")
    if #colorStr == 4 then
      local r = tonumber(colorStr[1])
      local g = tonumber(colorStr[2])
      local b = tonumber(colorStr[3])
      local a = tonumber(colorStr[4])
      self.bubble:SetColorRGBA255(r, g, b, a)
    end
  end
end

function M:OnRecCreateLevel()
  self.contentCanvasGroupView:SetAlpha(1)
  self.contentCanvasGroupView:SetInteractable(true)
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
    self:RefreshBattleContentView()
    self:SetCurViewStateAtEnter()
    self:SetMonsterFinBoxIdle()
    self:RefreshRemainAttackNum()
    self:RefreshBtnsVisible()
    self:RefreshPersonalRankScore(DataCenter.ActBanquetV2Data:GetActRankScore())
    self:ClearAllStashReward()
    self:RefreshFlowerTrainBtnVisible()
    self:RefreshCameraScene()
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

function M:InitStateMachine()
  self.stateTransitionMap = {
    [ViewState.AttackMonster] = {
      [StateEvent.MonsterDead] = function(view)
        local autoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
        if autoAttack then
          return ViewState.MonsterDead, 3
        end
        return ViewState.MonsterDead, 2.5
      end
    },
    [ViewState.MonsterDead] = {
      [StateEvent.Timeout] = function(view)
        local nextState, nextTime = view:ResolveAutoConfirmTransition()
        if nextState then
          return nextState, nextTime
        end
        return ViewState.BoxDrop, 0.8
      end
    },
    [ViewState.BoxDrop] = {
      [StateEvent.Timeout] = {
        state = ViewState.BoxIdle,
        time = 0
      }
    },
    [ViewState.BoxIdle] = {
      [StateEvent.BoxConfirmClick] = {
        state = ViewState.BoxConfirm,
        time = 1.2
      }
    },
    [ViewState.BoxConfirm] = {
      [StateEvent.Timeout] = {
        state = ViewState.FinBosViewCloseWaiting,
        time = 0
      }
    }
  }
  self.globalStateTransitions = {
    [StateEvent.AutoConfirmRequest] = function(view)
      if view.curState ~= ViewState.MonsterDead then
        return nil, 0
      end
      if view.stateTime and 0 < view.stateTime then
        return nil, 0
      end
      return view:ResolveAutoConfirmTransition()
    end
  }
end

function M:DispatchStateEvent(eventId, payload)
  local transConfig
  local map = self.stateTransitionMap and self.stateTransitionMap[self.curState]
  if map then
    transConfig = map[eventId]
  end
  if transConfig == nil and self.globalStateTransitions then
    transConfig = self.globalStateTransitions[eventId]
  end
  if transConfig == nil then
    return false
  end
  local nextState
  local nextTime = 0
  if type(transConfig) == "function" then
    nextState, nextTime = transConfig(self)
  elseif type(transConfig) == "table" then
    nextState = transConfig.state
    nextTime = transConfig.time or 0
  else
    nextState = transConfig
  end
  if nextState ~= nil then
    self:SwitchState(nextState, nextTime)
    return true
  end
  return false
end

function M:ResolveAutoConfirmTransition()
  if not self:ShouldAutoConfirmNextMonster() then
    return nil, 0
  end
  self.isWaitingAutoMonsterConfirm = true
  return ViewState.FinBosViewCloseWaiting, 0
end

function M:ShouldAutoConfirmNextMonster()
  if self.isWaitingAutoMonsterConfirm then
    return false
  end
  if not self.activityId or not self.actBanquetId then
    return false
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if not isOnAutoAttack then
    return false
  end
  return DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.GetReward
end

function M:SwitchState(newState, stateTime)
  local targetTime = stateTime or 0
  if self.curState == newState then
    self.stateTime = targetTime
    return
  end
  local oldState = self.curState
  self:OnStateExit(oldState, newState)
  self.curState = newState
  self.stateTime = targetTime
  self:OnStateEnter(newState, oldState)
end

function M:OnStateExit(oldState, newState)
end

function M:OnStateEnter(newState, oldState)
  if newState == ViewState.BoxIdle then
    self:SetMonsterFinBoxIdle()
  elseif newState == ViewState.BoxDrop then
    self:RefreshBattleContentView()
    self:SetMonsterFinBoxDrop()
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_idle1")
    self:DoCameraAni()
  elseif newState == ViewState.BoxConfirm then
    self:SetMonsterFinBoxOpen()
  elseif newState == ViewState.FinBosViewCloseWaiting and self.activityId and self.actBanquetId then
    local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
    local auto = isOnAutoAttack and 1 or 0
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2MonsterConfirm, self.activityId, self.actBanquetId, 0, DataCenter.ActBanquetV2Data:GetMonsterGroupId(), auto)
  end
end

function M:RefreshTitle(actListData)
  if not actListData then
    return
  end
  local name = not string.IsNullOrEmpty(actListData.bannerTittle) and actListData.bannerTittle or actListData.name
  self._actName_txt:SetLocalText(name)
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
  self.btnRewardBoxEffect:Stop()
end

function M:OnIntroClick()
  if self.actListData ~= nil and self.actListData.story ~= nil and self.actBanquetTemplate ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.actListData.story, self.actBanquetTemplate.add_score1[1], self.actBanquetTemplate.add_score1[2], self.actBanquetTemplate.add_score2[1], self.actBanquetTemplate.add_score2[2], self.actBanquetTemplate.add_score4, self.actBanquetTemplate.add_score3)
    if self.activityId == "99141" then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEasterRuesDetail, {anim = true}, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailCommon, {anim = true}, param)
    end
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
  local boxCount = #boxDataList
  self.progress_btn:SetActive(boxCount ~= 0)
  self.curScoreText:SetActive(boxCount ~= 0)
  self._slider:SetActive(boxCount ~= 0)
  if boxCount == 0 then
    return
  end
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
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBanquetItemDropProbability, {anim = true}, self.activityId)
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
  self:ShowFlowerCarRedDot()
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
  self.bossBorn_SoundHandle = DataCenter.LWSoundManager:PlaySound(91118, false)
  if self.isMonsterCreateFin then
    return
  end
  self.isMonsterCreateFin = true
  self:CheckCreateFin()
end

local REWARD_BOX_EFFECT_PATH = "Assets/_Art_LastWar/Effect/Prefab/VX/wurenji/Eff_ui_wurenji_rewards.prefab"

function M:RefreshRedPoint()
  local levelRewardRed = DataCenter.ActBanquetV2Data:GetActLevelRewardRed()
  local cost1Red = DataCenter.ActBanquetV2Data:GetActCost1Red()
  local cost2Red = DataCenter.ActBanquetV2Data:GetActCost2Red()
  local taskRed = DataCenter.ActBanquetV2Data:GetActTaskRed()
  local jumpActRed = DataCenter.ActBanquetV2Data:JumpActRedNum()
  self.level_reward_red_point:SetActive(0 < levelRewardRed)
  self.level_reward_red_num:SetText("")
  local remainAttackTimes = DataCenter.ActBanquetV2Data:GetRemainAttackNum()
  self.cost1_red_point:SetActive(0 < cost1Red and 0 < remainAttackTimes)
  self.cost1_red_num:SetText("")
  self.open_box_red_point:SetActive(0 < cost1Red)
  self.cost2_red_point:SetActive(0 < cost2Red)
  self.cost2_red_num:SetText("")
  self.task_red_point:SetActive(0 < taskRed)
  self.task_red_num:SetText(tostring(taskRed))
  self.change_red_point:SetActive(0 < jumpActRed)
  self.change_red_num:SetText(tostring(jumpActRed))
  local rewardBoxRedNum = DataCenter.ActBanquetV2Data:GetRewardBoxRedNum()
  self.boxRedPoint:SetActive(0 < rewardBoxRedNum)
  if 0 < rewardBoxRedNum then
    self.btnRewardBoxEffect:Play(REWARD_BOX_EFFECT_PATH, self.rewardBoxEffectParam)
  else
    self.btnRewardBoxEffect:Stop()
  end
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
  if self.stateTime <= 0 then
    self:DispatchStateEvent(StateEvent.Timeout)
  end
end

function M:TryAutoConfirmNextMonster()
  return self:DispatchStateEvent(StateEvent.AutoConfirmRequest)
end

function M:OnGetScoreRewardMsg()
  self:OnRefresh()
end

function M:OnModelShowStart()
  local modelShowData = {
    monsterData = {},
    weaponData = {
      [0] = {
        modelPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/2026easter/Prefab/A_Hero_bubing02_easter_2026.prefab",
        firePoint = "A_Hero_bubing02_easter/Hero@bubing02_skin (1)/To_unity/DeformationSystem/Root/gun/firepoint",
        bulletType = BanquetAttackMonsterBulletType.Normal
      },
      [1] = {
        modelPath = "Assets/_Art_LastWar/Models/Cars/A_Hero_Hager/prefab/Hero_Hager_yanhui.prefab",
        firePoint = "A_Hero_Hager_01_skin/To_unity/DeformationSystem/Root/weapon/fire_point",
        bulletType = BanquetAttackMonsterBulletType.Special
      }
    }
  }
  local monsterIds = DataCenter.ActBanquetV2Data:GetMonsterTypeIdList()
  for k, v in ipairs(monsterIds) do
    if modelShowData.monsterData[v] == nil then
      local monsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(v)
      modelShowData.monsterData[v] = {monsterTemp = monsterTemp}
    end
  end
  self.battle_content:SetModelShowData(modelShowData)
  self.battle_content:StartShow(self.actBanquetTemplate)
end

function M:OnModelShowEnd()
  self.battle_content:EndShow()
end

function M:SetMondelShowCurData()
  if self.actBanquetTemplate == nil then
    return
  end
  local curMonsterId = DataCenter.ActBanquetV2Data:GetNewMonsterId()
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
    self:SwitchState(ViewState.BoxIdle, 0)
  else
    self:SwitchState(ViewState.AttackMonster, 0)
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
  local curButtleAniIsDoing = self:GetIsDoingBulletAni()
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
  self:RefreshRemainAttackNum()
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
  if msg.damageReward and #msg.damageReward > 0 and self:CheckFlyReward() then
    local damageRewardList = DataCenter.RewardManager:ReturnRewardParamForView(msg.damageReward)
    for i = 1, #damageRewardList do
      local damageReward = damageRewardList[i]
      if damageReward.rewardType == RewardType.GOODS or damageReward.rewardType == RewardType.RESOURCE_ITEM then
        local rewardType = damageReward.rewardType
        local itemId = damageReward.itemId
        local addNum = damageReward.count
        local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
        local flyPos = self.rewardBoxAni.transform.position
        local model = "Assets/_Art/Effect/prefab/ui/Common/FlyGoodsReverseDirPath.prefab"
        local targetPos = flyPos
        if self.stashRewardQueueCpt then
          targetPos.y = flyPos.y + self.stashRewardQueueCpt:GetMaxTargetHeight()
        end
        UIUtil.DoFlyWithoutLogic(pic, 1, self.damage_reward_pos.transform.position, targetPos, 80, 80, function()
          if self.actBanquetTemplate.attackBox_type and self.actBanquetTemplate.attackBox_type == 1 then
            self:ShowOneRewardIntoStashReward(msg.damageReward)
          end
          if self.rewardBoxAni then
            self:PlayChestShakeAni()
          end
        end, model, -1, 1, 0.001, 0.6)
      end
    end
  end
  local iconName = self.actBanquetTemplate.score_pic
  local iconPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, iconName)
  local flyPos = self.level_exp_fly_pos.transform.position
  local flyNum = math.floor(msg.score / 100)
  flyNum = math.max(flyNum, 1)
  flyNum = math.min(flyNum, 10)
  if self:CheckFlyReward() then
    UIUtil.DoFly(nil, flyNum, iconPath, self.damage_reward_pos.transform.position, flyPos, 80, 80, function()
      self:RefreshPersonalRankScore(msg.attackScore)
    end, nil, 1)
  end
  if bulletData.type == BanquetAttackMonsterBulletType.Normal then
    if not string.IsNullOrEmpty(self.curMonsterTemp.act_2_text) then
      self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_2_text))
    end
  elseif not string.IsNullOrEmpty(self.curMonsterTemp.act_3_text) then
    self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_3_text))
  end
  if 0 >= msg.blood then
    self.isAtkBossBtnDown = false
    self:SetAtkBossBtnScale()
    self:PauseAutoAttackWhenMonsterDead()
    local reward = msg.boosStageReward
    local rewardData = {reward = reward}
    DataCenter.RewardManager:ShowCommonReward(rewardData)
    self:DispatchStateEvent(StateEvent.MonsterDead)
    self.bossDie_SoundHandle = DataCenter.LWSoundManager:PlaySound(91117, false)
    self.battle_content.monsterModelManager:TryMonsterPlayDeadAni()
    if not string.IsNullOrEmpty(self.curMonsterTemp.act_4_text) then
      self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_4_text))
    end
  end
  self:RefreshBloodContent(msg.blood)
end

function M:OnBulletFinCallBack()
  self:OnAtkBossBulletDataFin()
end

function M:PauseAutoAttackWhenMonsterDead()
  if not self.activityId then
    return
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if not isOnAutoAttack then
    return
  end
  self.isPauseAutoAttackByMonsterDead = true
  self:ClearResumeAutoAttackTimer()
  self:StopAutoAttack()
end

function M:TryResumeAutoAttackAfterMonsterRefresh()
  if not self.isPauseAutoAttackByMonsterDead then
    return
  end
  self.isPauseAutoAttackByMonsterDead = false
  if not self.activityId or self.actBanquetTemplate == nil then
    return
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if not isOnAutoAttack then
    return
  end
  if DataCenter.ActBanquetV2Data.state ~= BanquetAttackMonsterState.Normal then
    return
  end
  local delayTime = 0
  if self.battle_content and self.battle_content.monsterModelManager then
    delayTime = self.battle_content.monsterModelManager:GetCurMonsterEnterAniTime()
  end
  if 0 < delayTime then
    self:ClearResumeAutoAttackTimer()
    self.resumeAutoAttackTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:ResumeAutoAttackAfterMonsterBornAni()
      self:ClearResumeAutoAttackTimer()
    end, delayTime)
    return
  end
  self:ResumeAutoAttackAfterMonsterBornAni()
end

function M:ResumeAutoAttackAfterMonsterBornAni()
  if not self.activityId or self.actBanquetTemplate == nil then
    return
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if not isOnAutoAttack then
    return
  end
  if DataCenter.ActBanquetV2Data.state ~= BanquetAttackMonsterState.Normal then
    return
  end
  if DataCenter.ActBanquetV2Data:GetRemainAttackNum() <= 0 or self:IfLackNormalAttackItem() then
    self.isDuringAutoAttack = false
    self:StopAutoAttack()
    return
  end
  self.isDuringAutoAttack = true
  self:StartAutoAttack()
end

function M:ClearResumeAutoAttackTimer()
  if self.resumeAutoAttackTimer then
    self.resumeAutoAttackTimer:Stop()
    self.resumeAutoAttackTimer = nil
  end
end

function M:AutoAttackNormalAgain()
  if not (self.actBanquetTemplate ~= nil and self.activityId) or self.actListData == nil then
    self:StopAutoAttack()
    return
  end
  if DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.GetReward then
    self:TryAutoConfirmNextMonster()
    return
  end
  if DataCenter.ActBanquetV2Data:GetRemainAttackNum() <= 0 then
    self:StopAutoAttack()
    return
  end
  self.costBulletType = BanquetAttackMonsterBulletType.Normal
  if DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.Normal then
    self:TrySendAtkBossMsgByAutoAttack()
  end
end

function M:AttackBtnPointDown()
  if self.actBanquetTemplate and self.actBanquetTemplate.attackSpeed_type == 1 then
    return
  end
  self:StopAutoAttack()
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
  if self:IfLackNormalAttackItem() then
    self:StopPressTipShow()
  else
    self:SetPressTime(curTime)
  end
  self:Update100MS()
end

function M:AttackBtnPointUp()
  if self.actBanquetTemplate and self.actBanquetTemplate.attackSpeed_type == 1 then
    return
  end
  self:CheckStartAutoAttack()
  self.isAtkBossBtnDown = false
  self:SetAtkBossBtnScale()
end

function M:CheckStartAutoAttack()
  if self.isDuringAutoAttack then
    self.isDuringAutoAttack = false
    return
  end
  if self.activityId == nil then
    Logger.LogError("\230\150\176\231\137\136\231\155\155\229\174\180Common1\239\188\140\229\188\128\229\167\139\232\135\170\229\138\168\230\148\187\229\135\187\230\151\182\239\188\140activityId\228\184\186\231\169\186")
    return
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if not isOnAutoAttack then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.atkBossBtnDownTime + AtkBossBulletAddTime then
    return
  end
  local costData = self.actBanquetTemplate.cost_item
  local onceNeedNum = self.actBanquetTemplate.unit_num
  local curNum = 0
  local maxCanBulletNum = 0
  if costData == nil then
    return
  end
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  end
  if maxCanBulletNum <= 0 then
    return
  end
  self.isDuringAutoAttack = true
  self:StartAutoAttack()
end

function M:StopAutoAttack()
  if self.autoAttackTimer then
    self.autoAttackTimer:Stop()
    self.autoAttackTimer = nil
  end
end

function M:StartAutoAttack()
  if self.autoAttackTimer then
    self.autoAttackTimer:Stop()
  end
  self.autoAttackTimer = TimerManager:GetInstance():GetTimer(self.bulletFlyTimeOneSpeed, function()
    self:AutoAttackNormalAgain()
  end, self, false, false, false)
  self.autoAttackTimer:Start()
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
          SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, 0, 1, BanquetAttackMonsterBulletType.Special, DataCenter.ActBanquetV2Data:GetMonsterGroupId())
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
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, 0, costNum, self.costBulletType, DataCenter.ActBanquetV2Data:GetMonsterGroupId())
    isSuccess = true
  end
  return isSuccess
end

function M:TrySendAtkBossMsgByAutoAttack()
  if self.actBanquetTemplate == nil then
    return
  end
  if self.costBulletType == BanquetAttackMonsterBulletType.None then
    return
  end
  local costData
  local onceNeedNum = 0
  local curNum = 0
  local maxCanBulletNum = 0
  if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
    costData = self.actBanquetTemplate.cost_item
    onceNeedNum = self.actBanquetTemplate.unit_num
  end
  if costData == nil then
    return
  end
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
    maxCanBulletNum = math.floor(curNum / onceNeedNum)
  end
  if 0 < maxCanBulletNum then
    self.curAtkBossBulletNum = 1
    local useNum = math.min(self.curAtkBossBulletNum, maxCanBulletNum)
    local costNum = useNum * onceNeedNum
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, 0, costNum, self.costBulletType, DataCenter.ActBanquetV2Data:GetMonsterGroupId())
  else
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      LWResourceLackUtil:GotoResourceItemLack(costData[2], onceNeedNum - curNum)
    else
      LWResourceLackUtil:GotoGoodsItemLack(costData[2], onceNeedNum - curNum)
    end
    if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
      PostEventLog.Track(PostEventLog.Defines.BanquetAttackMonsterCost1LackOpen, {})
    end
    self.isDuringAutoAttack = false
    self:StopAutoAttack()
  end
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
  if self.isAtkBossBtnDown ~= false and curTime > self.sendAtkBossTime + AtkBossDeltaTime and DataCenter.ActBanquetV2Data.state == BanquetAttackMonsterState.Normal then
    if curTime > self.atkBossBtnDownTime + AtkBossBulletAddTime then
      self.curAtkBossBulletNum = self.curAtkBossBulletNum * 2
      self.curAtkBossBulletNum = math.min(self.curAtkBossBulletNum, AtkBossBulletNum)
    end
    local isSendSuccess = self:TrySendAtkBossMsg()
    if isSendSuccess then
      self.sendAtkBossTime = curTime
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
  if not string.IsNullOrEmpty(costItem2PicPath) then
    self.attack_boss_btn_icon:LoadSprite(costItem2PicPath)
  end
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    self.itemBar1:SetData(nil, costData[2])
  elseif costData[1] == BanquetAttackMonsterCostType.Goods then
    self.itemBar1:SetData(costData[2])
  end
  self.curMonsterTemp.blood_pos = -157
  self.blood_content:SetAnchoredPositionXY(0, self.curMonsterTemp.blood_pos)
  if #self.curMonsterTemp.plot_pos == 2 then
    local posX = 13
    local posY = 335
    self.monster_plot_content:SetAnchoredPositionXY(posX, posY)
  else
    self.monster_plot_content:SetAnchoredPositionXY(0, self.curMonsterTemp.plot_pos[1])
  end
  self:RefreshBloodContent()
  self:RefreshCostNumContent()
  self:ClearFinBoxTimer()
  self.finBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:RefreshMonsterFinBox()
  end, 0.7)
end

function M:ClearFinBoxTimer()
  if self.finBoxTimer then
    self.finBoxTimer:Stop()
    self.finBoxTimer = nil
  end
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

function M:SetFinBoxImageDoFade(endValue, duration)
  self.boxRawImage1:DOFade(endValue, duration)
  self.boxRawImage2:DOFade(endValue, duration)
end

function M:SetFinBoxImageAlpha(alpha)
  if self.boxRawImage1 then
    local color = self.boxRawImage1:GetColor()
    color.a = alpha
    self.boxRawImage1:SetColor(color)
  end
  if self.boxRawImage2 then
    local color = self.boxRawImage2:GetColor()
    color.a = alpha
    self.boxRawImage2:SetColor(color)
  end
end

function M:SetCameraAtOutPos()
  self:ClearPushCameraTimer()
  if self.battle_content and self.battle_content.camera then
    self.battle_content:PlayShowMonsterCameraPush()
  end
  self.bloodCanvasGroup:FadeOut(0.3)
  self:ClearPushCameraTimer()
  self.bgTimer1 = TimerManager:GetInstance():DelayInvoke(function()
    self.battle_content:ShowWeapon(false)
  end, 0.3)
  self:ClearFinBoxTimer()
  self.finBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.monster_fin_box:SetActive(DataCenter.ActBanquetV2Data.blood <= 0)
    self:SetFinBoxImageAlpha(0)
    self:SetFinBoxImageDoFade(1, 0.5)
  end, 0.6)
end

function M:SetCameraAtInPos()
  if self.battle_content and self.battle_content.camera then
    self.battle_content:PlayShowMonsterCameraPull()
  end
  self:ClearPullCameraTimer()
  self:SetFinBoxImageAlpha(0)
  self.bgTimer2 = TimerManager:GetInstance():DelayInvoke(function()
    self.bloodCanvasGroup:FadeIn(0.5)
    self.battle_content:ShowWeapon(true)
  end, 0.1)
end

function M:ClearPushCameraTimer()
  if self.bgTimer1 then
    self.bgTimer1:Stop()
    self.bgTimer1 = nil
  end
end

function M:ClearPullCameraTimer()
  if self.bgTimer2 then
    self.bgTimer2:Stop()
    self.bgTimer2 = nil
  end
end

function M:StopSound()
  if self.bossDie_SoundHandle then
    DataCenter.LWSoundManager:StopSound(self.bossDie_SoundHandle)
    self.bossDie_SoundHandle = nil
  end
  if self.bossBorn_SoundHandle then
    DataCenter.LWSoundManager:StopSound(self.bossBorn_SoundHandle)
    self.bossBorn_SoundHandle = nil
  end
end

function M:DoCameraAni()
  if DataCenter.ActBanquetV2Data.blood <= 0 then
    self:SetCameraAtOutPos()
  else
    self:SetCameraAtInPos()
  end
end

function M:RefreshCameraScene()
  self.monster_fin_box:SetActive(DataCenter.ActBanquetV2Data.blood <= 0)
  local bloodLessThanZero = DataCenter.ActBanquetV2Data.blood <= 0
  if bloodLessThanZero then
    self:SetFinBoxImageAlpha(1)
    self.bloodCanvasGroup:SetAlpha(0)
    self.battle_content:ShowWeapon(false)
    self.battle_content:ShowHouBoxRender(false)
    self.battle_content:PlayCameraPushIdle()
  end
end

function M:RefreshMonsterFinBox()
  self.open_box_btn:SetActive(DataCenter.ActBanquetV2Data.blood <= 0)
  self._donate_btn:SetActive(DataCenter.ActBanquetV2Data.blood > 0)
  self:StopPressTipShow()
end

function M:SetMonsterFinBoxDrop()
  if DataCenter.ActBanquetV2Data.blood > 0 then
    return
  end
  self.eff_ui_yanhui_baoxiangidle1:SetActive(false)
  self.eff_ui_yanhui_baoxiangidle2:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi1:SetActive(false)
  self.eff_ui_yanhui_baoxiangkaiqi2:SetActive(false)
  if self.curMonsterTemp.type == BanquetAttackMonsterBossType.Normal then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_idle1")
  elseif self.curMonsterTemp.type == BanquetAttackMonsterBossType.Special then
    self.box_ani:Play("Eff_ui_BanquetAttackMonster3_diaoluo1")
  end
end

function M:SetMonsterFinBoxIdle()
  if DataCenter.ActBanquetV2Data.blood > 0 then
    return
  end
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
  DataCenter.LWSoundManager:PlaySound(91110, false)
end

function M:GetDamageRewardMsg(t)
  if t.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  DataCenter.ActBanquetV2Data:ClearExtraReward()
  DataCenter.ActBanquetV2Data:PareseHistoryInfo(t)
  EventManager:GetInstance():Broadcast(EventId.BanquetSuccessGetStashReward, true)
end

function M:BossRewardBtnClick()
  SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2ExtraReward, self.activityId)
end

function M:OnMonsterFinBoxClick()
  self:DispatchStateEvent(StateEvent.BoxConfirmClick)
end

function M:OnFinBoxConfirmMsg(t)
  self.isWaitingAutoMonsterConfirm = false
  local dropType = DataCenter.ActBanquetV2Data:GetDropType()
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if dropType and dropType == BanquetDropType.Normal or isOnAutoAttack then
    if t.killReward ~= nil then
      TimerManager:GetInstance():DelayInvoke(function()
        local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(t.killReward)
        self:OnFinBoxConfirmViewClose(t, rewardList)
      end, 2)
    end
    self:RefreshRedPoint()
  end
end

function M:DoFlyToTreasureBox()
  if not self.flyBoxEffectNode or not self.treasureBoxPos then
    return
  end
  self:ClearFlyRewardTimers()
  if self.flyRewardBoxObj and not IsNull(self.flyRewardBoxObj) then
    self.flyRewardBoxObj.transform:SetParent(self.flyBoxEffectNode.transform, false)
    self.flyRewardBoxObj.transform.localPosition = Vector3.zero
    self.flyRewardBoxObj:SetActive(false)
    self:ShowFlyEff()
  else
    self.flyRewardBoxReq = self:GameObjectInstantiateAsync(flyRewardBoxPath, function(req)
      if not req or req.gameObject == nil or IsNull(req.gameObject) then
        return
      end
      self.flyRewardBoxObj = req.gameObject
      self.flyRewardBoxObj.transform:SetParent(self.flyBoxEffectNode.transform, false)
      self.flyRewardBoxObj.transform.localPosition = Vector3.zero
      self.flyRewardBoxObj:SetActive(false)
      if self.flyRewardStartTimer == nil then
        self:ShowFlyEff()
      end
    end)
  end
  if self.hitBossEffectObj and not IsNull(self.hitBossEffectObj) then
    self.hitBossEffectObj.transform:SetParent(self.treasureBoxPos.transform, false)
    self.hitBossEffectObj.transform.localPosition = Vector3.zero
    self.hitBossEffectObj:SetActive(false)
    self:ShowHitEff()
  else
    self.hitBoxReq = self:GameObjectInstantiateAsync(hitRewardBoxPath, function(req)
      if not req or req.gameObject == nil or IsNull(req.gameObject) then
        return
      end
      self.hitBossEffectObj = req.gameObject
      self.hitBossEffectObj:SetActive(false)
      self.hitBossEffectObj.transform:SetParent(self.treasureBoxPos.transform, false)
      self.hitBossEffectObj.transform.localPosition = Vector3.zero
      if self.hitRewardShowTimer == nil then
        self:ShowHitEff()
      end
    end)
  end
end

function M:ShowHitEff()
  self.hitRewardShowTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.hitRewardShowTimer = nil
    if not self.hitBossEffectObj or IsNull(self.hitBossEffectObj) then
      return
    end
    self.hitBossEffectObj:SetActive(false)
    self.hitBossEffectObj:SetActive(true)
  end, 1.6)
end

function M:ShowFlyEff()
  if not self.flyRewardBoxObj or IsNull(self.flyRewardBoxObj) then
    return
  end
  if not self.flyRewardBoxEffectNodeDefaultLocalPos then
    self.flyRewardBoxEffectNodeDefaultLocalPos = self.flyRewardBoxObj.transform.localPosition
  end
  self.flyRewardBoxObj.transform:Set_localPosition(self.flyRewardBoxEffectNodeDefaultLocalPos.x, self.flyRewardBoxEffectNodeDefaultLocalPos.y, self.flyRewardBoxEffectNodeDefaultLocalPos.z)
  local targetPos = self.treasureBoxPos.transform.position
  self.flyRewardStartTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.flyRewardStartTimer = nil
    self.flyRewardBoxObj:SetActive(true)
    local fly = self.flyRewardBoxObj.gameObject:GetComponent(typeof(CS.UIGoodsFly))
    local flyTrans = self.flyRewardBoxObj.transform
    local parent = flyTrans.parent
    local startPos = flyTrans.localPosition
    local destPos = parent:InverseTransformPoint(self.treasureBoxPos.transform.position)
    destPos.z = startPos.z
    destPos.y = destPos.y + 30
    fly:DoParabolaAnimLocal(destPos, startPos, function()
      self:RefreshAutoTreasureBoxRedDotState()
      self.flyRewardBoxObj:SetActive(false)
    end)
  end, 0.6)
end

function M:ClearFlyRewardTimers()
  if self.flyRewardStartTimer then
    self.flyRewardStartTimer:Stop()
    self.flyRewardStartTimer = nil
  end
  if self.hitRewardShowTimer then
    self.hitRewardShowTimer:Stop()
    self.hitRewardShowTimer = nil
  end
end

function M:PlayAutoRewardBoxFlyToTreasureBox()
  if not self.btn_treasureBox then
    return
  end
  local currentAutoBoxNum = DataCenter.UpgradeTreasureBoxManager:GetAutoBoxNum()
  local needForceLayoutRefresh = currentAutoBoxNum == 1
  self:StartFly(needForceLayoutRefresh)
end

function M:StartFly(needForceLayoutRefresh)
  if not self.treasureBoxPos then
    return
  end
  if needForceLayoutRefresh then
    self.treasureBoxPos:SetActive(true)
    CS.UnityEngine.Canvas.ForceUpdateCanvases()
    local parent = self.treasureBoxPos.transform.parent
    if parent and not IsNull(parent) then
      local parentRect = parent:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if parentRect and not IsNull(parentRect) then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(parentRect)
      end
    end
    local targetRect = self.treasureBoxPos.transform:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if targetRect and not IsNull(targetRect) then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(targetRect)
    end
    CS.UnityEngine.Canvas.ForceUpdateCanvases()
    TimerManager:GetInstance():DelayInvoke(function()
      self:DoFlyToTreasureBox()
    end, 0.1)
  else
    self:DoFlyToTreasureBox()
  end
end

function M:OnFinBoxConfirmViewClose(msg, rewardList)
  self.battle_content.monsterModelManager.SetMonsterPlayEnterAtCallBack = true
  self:SetCurMonsterTemp()
  self:RefreshBattleContentView()
  self:SetMondelShowCurData()
  self:SetCurViewStateAtEnter()
  if rewardList and 0 < #rewardList and self:CheckFlyReward() then
    for k, v in ipairs(rewardList) do
      if v.rewardType == RewardType.GOODS or v.rewardType == RewardType.RESOURCE_ITEM then
        local rewardType = v.rewardType
        local itemId = v.itemId
        local addNum = v.count
        local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
        local flyPos = self.reward_boss_btn.transform.position
        local targetPos = flyPos
        if self.stashRewardQueueCpt then
          targetPos.y = flyPos.y + self.stashRewardQueueCpt:GetMaxTargetHeight()
        end
        UIUtil.DoFly(rewardType, 1, pic, self.damage_reward_pos.transform.position, targetPos, 80, 80, function()
          if self.actBanquetTemplate.attackBox_type and self.actBanquetTemplate.attackBox_type == 1 then
            self:ShowOneRewardIntoStashReward(msg.killReward)
          end
          if self.rewardBoxAni then
            self:PlayChestShakeAni()
          end
        end, nil, 1)
      end
    end
  end
  if not string.IsNullOrEmpty(self.curMonsterTemp.act_5_text) then
    self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_5_text))
  end
  self:TryResumeAutoAttackAfterMonsterRefresh()
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

function M:RefreshRemainAttackNum()
  self.txtRemainAttackNum:SetText(DataCenter.ActBanquetV2Data:GetRemainAttackNum())
end

function M:RefreshPersonalRankScore(rankScore)
  self.textScoreNum:SetText(rankScore)
end

function M:RefreshBtnsVisible()
  self.btn_change:SetActive(self.actBanquetTemplate and self.actBanquetTemplate.is_show_convert ~= 0)
  self.btn_task:SetActive(self.actBanquetTemplate and self.actBanquetTemplate.is_show_task ~= "")
  self.attack_boss_btn:SetActive(self.actBanquetTemplate and self.actBanquetTemplate.support_isopen ~= 0)
end

function M:RefreshFlowerTrainBtnVisible()
  if self.actBanquetTemplate == nil then
    self.btn_flower_train:SetActive(false)
    return
  end
  local isOpen = self.actBanquetTemplate.is_show_treasure
  self.btn_flower_train:SetActive(isOpen)
  local path = self.actBanquetTemplate.treasure_btn_pic
  if not string.IsNullOrEmpty(path) then
    self.btn_flower_train_icon:LoadSprite(path)
    self.btn_flower_train_icon:SetNativeSize()
  end
  local name = self.actBanquetTemplate.treasure_btn_name
  if not string.IsNullOrEmpty(name) then
    self.btnFlowerTrainText:SetLocalText(name)
  end
end

function M:ClearAllStashReward()
  if not self.stashRewardQueueCpt then
    return
  end
  self.stashRewardQueueCpt:ClearAllRewardItem()
end

function M:ShowOneRewardIntoStashReward(rewardData)
  if not self.stashRewardQueueCpt then
    return
  end
  self.stashRewardQueueCpt:PushRewardToQueue(rewardData)
end

function M:PlayChestShakeAni()
  if not self.rewardBoxAni then
    return
  end
  if self.rewardBoxAni:IsPlaying("Shake") then
    self.rewardBoxAni:Rewind("Shake")
  else
    self.rewardBoxAni:Play("Shake")
  end
end

function M:CheckFlyReward()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.BanquetAttackMonsterRankAndReward) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWGoodsLack) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBanquetItemDropProbability) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActBanquetAttackMonsterHistory) then
    return false
  end
  return true
end

function M:OnBtnRewardBoxNew()
  local param = {}
  param.activityId = self.activityId
  param.partyNewId = self.actBanquetId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActBanquetAttackMonsterHistory, {anim = true}, param)
end

function M:OnBtnTreasureClick()
  Logger.Log("\230\137\147\229\188\128\232\138\177\232\189\166\229\136\151\232\161\168" .. tostring(self.actListData.festivalEntrance))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainCommonGroupShow, self.actListData.festivalEntrance, self.activityId, self.actBanquetId)
end

function M:OnClickDonateBtn()
  if self.actBanquetTemplate and self.actBanquetTemplate.attackSpeed_type == 2 then
    return
  end
  local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
  if isOnAutoAttack then
    local costData = self.actBanquetTemplate.cost_item
    local onceNeedNum = self.actBanquetTemplate.unit_num
    local curNum = 0
    local maxCanBulletNum = 0
    if costData == nil then
      return
    end
    if costData[1] == BanquetAttackMonsterCostType.Resource then
      curNum = LuaEntry.Resource:GetCntByResType(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    else
      curNum = DataCenter.ItemData:GetItemCount(costData[2])
      maxCanBulletNum = math.floor(curNum / onceNeedNum)
    end
    if maxCanBulletNum <= 0 then
      return
    end
    self.isDuringAutoAttack = true
    self:StartAutoAttack()
  else
    self.costBulletType = BanquetAttackMonsterBulletType.Normal
    local onceNeedNum = 0
    if self.costBulletType == BanquetAttackMonsterBulletType.Normal then
      onceNeedNum = self.actBanquetTemplate.unit_num
    end
    SFSNetwork.SendMessage(MsgDefines.ActivityFoodPartyV2AttackMonster, tonumber(self.activityId), self.actBanquetTemplate.id, 0, 1 * onceNeedNum, self.costBulletType, DataCenter.ActBanquetV2Data:GetMonsterGroupId())
  end
end

function M:RequestAllUpgradeTreasureBox()
  SFSNetwork.SendMessage(MsgDefines.GetUpgradeBoxInfo)
end

function M:OnRecUpgradeTreasureBox()
  self:StopAutoAttack()
  self.isDuringAutoAttack = false
end

function M:ShowFlowerCarRedDot()
  if not self.actBanquetTemplate then
    return
  end
  local id = self.actBanquetTemplate.treasure_id
  local isExistFlowerArrived = FlowerTrainUtils.IsExistSelfFlowerTrainArrived(id)
  if isExistFlowerArrived ~= self.showFlowerTrainRedDot then
    self.showFlowerTrainRedDot = isExistFlowerArrived
    self.btnFlowerTrainRedDot:SetActive(isExistFlowerArrived)
  end
end

function M:IfLackNormalAttackItem()
  if self.actBanquetTemplate == nil then
    return true
  end
  local costData = self.actBanquetTemplate.cost_item
  local onceNeedNum = self.actBanquetTemplate.unit_num
  local curNum = 0
  if costData == nil then
    return true
  end
  if costData[1] == BanquetAttackMonsterCostType.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(costData[2])
  else
    curNum = DataCenter.ItemData:GetItemCount(costData[2])
  end
  return onceNeedNum > curNum
end

function M:OnUpgradeTreasureBoxClose(isAuto)
  self.isWaitingAutoMonsterConfirm = false
  local dropType = DataCenter.ActBanquetV2Data:GetDropType()
  if not dropType or dropType == BanquetDropType.UpgradeTreasureBox then
    if not isAuto then
      self.battle_content.monsterModelManager.SetMonsterPlayEnterAtCallBack = true
      self:SetCurMonsterTemp()
      self:RefreshBattleContentView()
      self:DoCameraAni()
      self:SetMondelShowCurData()
      self:SetCurViewStateAtEnter()
      if not string.IsNullOrEmpty(self.curMonsterTemp.act_5_text) then
        self:StarPlotShow(Localization:GetString(self.curMonsterTemp.act_5_text))
      end
    end
    self.battle_content:RefreshScene()
  end
  self:TryResumeAutoAttackAfterMonsterRefresh()
end

function M:RefreshAutoUpgradeTreasureBoxNum(ifRecOneOnAuto)
  if ifRecOneOnAuto then
    self:PlayAutoRewardBoxFlyToTreasureBox()
  else
    self:RefreshAutoTreasureBoxRedDotState()
  end
end

function M:RefreshAutoTreasureBoxRedDotState()
  local autoBoxNum = DataCenter.UpgradeTreasureBoxManager:GetAutoBoxNum()
  self.treasureBoxPos:SetActive(0 < autoBoxNum)
  self.btn_treasureBox:SetActive(0 < autoBoxNum)
  self.btn_treasureBox_red_num:SetText(autoBoxNum)
end

function M:OnBtnTreasureBoxClick()
  if self.activityId then
    local isOnAutoAttack = DataCenter.ActBanquetV2Data:GetIsOnAutoAttack(self.activityId)
    local isOpenNonAutoBox = self.curState and self.curState == ViewState.BoxConfirm or self.curState and self.curState == ViewState.FinBosViewCloseWaiting
    if isOpenNonAutoBox then
      return
    end
    if isOnAutoAttack and (self.isDuringAutoAttack or self.isPauseAutoAttackByMonsterDead or self.isWaitingAutoMonsterConfirm) then
      UIUtil.ShowTipsId("box_click_alert3")
      return
    end
  end
  local treasureBoxData = DataCenter.UpgradeTreasureBoxManager:GetFirstAutoBoxData()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeTreasureBoxView, {anim = true, playEffect = 91111}, treasureBoxData)
end

return M
