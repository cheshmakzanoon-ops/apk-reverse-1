local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local HeroSmallItem = require("UI.UIWorldPoint.Component.WorldPointHeroSmallItem")
local MonsterBuffComponent = require("UI.UIWorldPoint.Component.MonsterBuffComponent")
local ZMBossStateInfoItem = require("UI.UIWorldPoint.Component.ZMBossStateInfoItem")
local WorldMonsterDes = BaseClass("WorldMonsterDes", UIAsyncContainer)
local string_IsNullOrEmpty = string.IsNullOrEmpty
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local content2_path = "BuildInfo/ScrollView2/Viewport/Content2"
local content3_path = "BuildInfo/ScrollView3/Viewport/Content3"
local content4_path = "BuildInfo/ScrollView4/Viewport/Content4"
local scroll_path = "BuildInfo/ScrollView"
local scroll2_path = "BuildInfo/ScrollView2"
local scroll3_path = "BuildInfo/ScrollView3"
local scroll4_path = "BuildInfo/ScrollView4"
local time_txt_path = "BuildInfo/down/timeLabel"
local tips_path = "BuildInfo/tips"
local tips1_txt_path = "BuildInfo/tips/commendText"
local tips2_txt_path = "BuildInfo/tips/commendText2"
local boosreward_path = "BuildInfo/tips/BossReward"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/desTxt"
local power_rect_path = "BuildInfo/powerRecommend"
local power_txt_path = "BuildInfo/powerRecommend/Recommend_Power"
local rallyTip_rect_path = "BuildInfo/powerRecommend/RallyTip"
local rallyTip_txt_path = "BuildInfo/powerRecommend/RallyTip/RallyTipText"
local tip_path = "BuildInfo/down/simple_tip"
local down_path = "BuildInfo/down"
local first_kill_txt = "BuildInfo/FirstSkillTxt"
local ine_text_path = "BuildInfo/inev_layout/inev_text"
local ine_icon_done_path = "BuildInfo/inev_layout/icon_done"
local ine_btn_jump_path = "BuildInfo/inev_layout/btn_jump"
local possi_text_path = "BuildInfo/possi_text"
local possi_text_btn_path = "BuildInfo/possi_text/possi_text_btn"
local lineUp_text_path = "BuildInfo/lineUp_text"
local down_divide = "BuildInfo/divide"
local desc_content_path = "BuildInfo/descBg"
local desc_txt_path = "BuildInfo/descBg/descTxt"
local monster_buff_path = "BuildInfo/MonsterBuff"
local empty_path = "BuildInfo/empty"
local belong_user_path = "BuildInfo/belongUser"
local belong_desc_path = "BuildInfo/belongUser/belongDesc"
local belong_user_name_path = "BuildInfo/belongUser/belongUserName"
local viral_path = "BuildInfo/viralRoot"
local viral_btn_path = "BuildInfo/viralRoot/viral_txt/viral_btn"
local viral_txt_path = "BuildInfo/viralRoot/viral_txt"
local viral_img_path = "BuildInfo/viralRoot/viral_txt/viral_btn/viral_img"
local viral_img_ok_path = "BuildInfo/viralRoot/viral_txt/viral_btn/viral_img_ok"
local viral_bg_path = "BuildInfo/viralRoot/viral_bg"
local viral_btn_info_path = "BuildInfo/viralRoot/viral_btn_info"
local city_stronghold_root_path = "BuildInfo/CityStrongholdRoot"
local city_stronghold_monster_num_path = "BuildInfo/CityStrongholdRoot/monster/monsterNum"
local city_stronghold_btn_path = "BuildInfo/CityStrongholdRoot/monster"
local the_name_path = "Name/TheName"
local army_type_path = "Name/armyType"
local owner_name_path = "OwnerName"
local u_i_player_head_path = "OwnerName/UIPlayerHead"
local monster_name_path = "OwnerName/monsterName"
local limit_tip_path = "BuildInfo/limitTip"
local limt_tip_text_path = "BuildInfo/limitTip/limtTipText"
local infodes_path = "BuildInfo/Infodes"
local infodes_text_path = "BuildInfo/Infodes/InfodesText"
local protection_path = "BuildInfo/protection"
local protection_desc_path = "BuildInfo/protection/protectionDesc"
local protection_time_path = "BuildInfo/protection/protectionTime"
local protection_btn_path = "BuildInfo/protection/protectionBtn"
local z_m_boss_state_info_path = "BuildInfo/ZMBossStateInfo"
local march_time_path = "BuildInfo/marchTime"
local march_time_txt_path = "BuildInfo/marchTime/marchTimeTxt"
local alliance_text_path = "AllianceText"
local ARMY_TYPE_SPRITE = {
  [1] = "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_tanke.png",
  [2] = "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_feiji.png",
  [5] = "Assets/Main/Sprites/UI/UISearch/mjc_zhiye_icon_bai_huojian.png"
}
local animator_path = ""
local lvPowerTips = {
  [1] = 302017,
  [2] = 302018,
  [3] = 302019,
  [4] = 302020,
  [5] = 302021
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:OnReturnClick()
  self:DeleteTimer()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityStrongholdMonsterDetailRefresh, self.OnCityStrongholdMonsterDetailRefresh)
  self:AddUIListener(EventId.ActNuclearMonsterListUpdate, self.BehemothBossDataRefresh)
  self:AddUIListener(EventId.MonsterProtectionRefresh, self.OnMonsterProtectionRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CityStrongholdMonsterDetailRefresh, self.OnCityStrongholdMonsterDetailRefresh)
  self:RemoveUIListener(EventId.ActNuclearMonsterListUpdate, self.BehemothBossDataRefresh)
  self:RemoveUIListener(EventId.MonsterProtectionRefresh, self.OnMonsterProtectionRefresh)
end

local function ComponentDefine(self)
  self.the_name = self:AddComponent(UIText, the_name_path)
  self.army_type = self:AddComponent(UIImage, army_type_path)
  self.owner_name = self:AddComponent(UIBaseContainer, owner_name_path)
  self.u_i_player_head = self:AddComponent(UICommonHead, u_i_player_head_path)
  self.u_i_player_head:SetEnableClickShowInfo(true, true)
  self.monster_name = self:AddComponent(UITextMeshProUGUIEx, monster_name_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(1)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.content4 = self:AddComponent(UIBaseContainer, content4_path)
  self.possi_content = self:AddComponent(UIBaseContainer, content2_path)
  self.lineUp_content = self:AddComponent(UIBaseContainer, content3_path)
  self.scroll = self:AddComponent(UIBaseContainer, scroll_path)
  self.scroll4 = self:AddComponent(UIBaseContainer, scroll4_path)
  self.possi_scroll = self:AddComponent(UIBaseContainer, scroll2_path)
  self.lineUp_scroll = self:AddComponent(UIBaseContainer, scroll3_path)
  self.time_txt = self:AddComponent(UIText, time_txt_path)
  self.tips_txt = self:AddComponent(UIText, tips1_txt_path)
  self.tips2_txt = self:AddComponent(UIText, tips2_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.power_rect = self:AddComponent(UIBaseContainer, power_rect_path)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, power_txt_path)
  self.power_txt:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.power_txt, eventData)
  end)
  self.rallyTip_rect = self:AddComponent(UIBaseContainer, rallyTip_rect_path)
  self.rallyTip_txt = self:AddComponent(UIText, rallyTip_txt_path)
  self.tips_path = self:AddComponent(UIBaseContainer, tips_path)
  self.tip = self:AddComponent(UIText, tip_path)
  self.first_kill_txt = self:AddComponent(UIText, first_kill_txt)
  self.first_kill_txt:SetText("")
  self.ienv_txt = self:AddComponent(UIText, ine_text_path)
  self.ienv_icon_done = self:AddComponent(UIImage, ine_icon_done_path)
  self.ienv_btn_jump = self:AddComponent(UIButton, ine_btn_jump_path)
  self.ienv_btn_jump:SetOnClick(function()
    self:OnClickJump()
  end)
  self.possi_txt = self:AddComponent(UIText, possi_text_path)
  self.possi_text_btn = self:AddComponent(UIButton, possi_text_btn_path)
  self.possi_text_btn:SetOnClick(function()
    SeasonUtil.OpenSeasonActivityByType(EnumActivity.BloodyNight.Type, nil, true)
  end)
  self.lineUp_txt = self:AddComponent(UIText, lineUp_text_path)
  self.down_divide_obj = self:AddComponent(UIBaseContainer, down_divide)
  self.desc_content = self:AddComponent(UIBaseContainer, desc_content_path)
  self.desc_txt = self:AddComponent(UIText, desc_txt_path)
  self.monster_buff = self:AddComponent(MonsterBuffComponent, monster_buff_path)
  self.monster_buff:SetActive(false)
  self.emptyObj = self:AddComponent(UIImage, empty_path)
  self.belong_user_root = self:AddComponent(UIImage, belong_user_path)
  self.belong_user_desc = self:AddComponent(UIText, belong_desc_path)
  self.belong_user_name = self:AddComponent(UIText, belong_user_name_path)
  self.down = self:AddComponent(UIBaseContainer, down_path)
  self.viral = self:AddComponent(UIBaseContainer, viral_path)
  self.viral_btn = self:AddComponent(UIButton, viral_btn_path)
  self.viral_txt = self:AddComponent(UIText, viral_txt_path)
  self.viral_img = self:AddComponent(UIImage, viral_img_path)
  self.viral_img_ok = self:AddComponent(UIImage, viral_img_ok_path)
  self.viral_btn_info = self:AddComponent(UIButton, viral_btn_info_path)
  self.viral_bg = self:AddComponent(UIImage, viral_bg_path)
  self.viral_btn:SetOnClick(function()
    self:ShowResistanceDetail()
  end)
  self.viral_btn_info:SetOnClick(function()
    self:ShowResistanceDetail()
  end)
  self.city_stronghold_root = self:AddComponent(UIBaseContainer, city_stronghold_root_path)
  self.city_stronghold_monster_num = self:AddComponent(UIText, city_stronghold_monster_num_path)
  self.city_stronghold_btn = self:AddComponent(UIButton, city_stronghold_btn_path)
  self.city_stronghold_btn:SetOnClick(function()
    if self.data then
      local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(self.data.uuid)
      if theDetail and toInt(theDetail.curNum) > 0 then
        UIUtil.ShowTips(Localization:GetString("season_tips216", toInt(theDetail.curNum)))
      end
    end
  end)
  self.limit_tip = self:AddComponent(UIBaseContainer, limit_tip_path)
  self.limt_tip_text = self:AddComponent(UITextMeshProUGUIEx, limt_tip_text_path)
  self.infodes = self:AddComponent(UIBaseContainer, infodes_path)
  self.infodes_text = self:AddComponent(UITextMeshProUGUIEx, infodes_text_path)
  self.protection = self:AddComponent(UIBaseContainer, protection_path)
  self.protection_desc = self:AddComponent(UIText, protection_desc_path)
  self.protection_time = self:AddComponent(UIText, protection_time_path)
  self.protection_btn = self:AddComponent(UIButton, protection_btn_path)
  self.protection_btn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("invasion_shield_alliance"), self.protection_btn.transform.position, 0, -25, 0, nil, nil)
  end)
  self.protection_desc:SetLocalText("invasion_shield_time")
  self.z_m_boss_state_info = self:AddComponent(ZMBossStateInfoItem, z_m_boss_state_info_path)
  self.march_time = self:AddComponent(UIImage, march_time_path)
  self.march_time_txt = self:AddComponent(UITextMeshProUGUIEx, march_time_txt_path)
  self.alliance_text = self:AddComponent(UITextMeshProUGUIEx, alliance_text_path)
  self.model = {}
end

local function ComponentDestroy(self)
  self.animator = nil
  self.main_obj = nil
  self.des_obj = nil
  self.main_obj_canvas = nil
  self.des_obj_canvas = nil
  self.content = nil
  self.content4 = nil
  self.possi_content = nil
  self.scroll = nil
  self.scroll4 = nil
  self.possi_scroll = nil
  self.time_txt = nil
  self.tips_txt = nil
  self.tips2_txt = nil
  self.boosReward = nil
  self.des_txt = nil
  self.power_rect = nil
  self.power_txt = nil
  self.rallyTip_rect = nil
  self.rallyTip_txt = nil
  self.tips_path = nil
  self.tip = nil
  self.first_kill_txt = nil
  self.ienv_txt = nil
  self.ienv_icon_done = nil
  self.ienv_btn_jump = nil
  self.possi_txt = nil
  self.down_divide_obj = nil
  self.desc_content = nil
  self.desc_txt = nil
  self.emptyObj = nil
  self.belong_user_root = nil
  self.belong_user_desc = nil
  self.belong_user_name = nil
  self.city_stronghold_btn = nil
  self.city_stronghold_root = nil
  self.city_stronghold_monster_num = nil
  self.the_name = nil
  self.down = nil
  self.limit_tip = nil
  self.limt_tip_text = nil
  self.infodes = nil
  self.infodes_text = nil
  self.protection = nil
  self.protection_desc = nil
  self.protection_time = nil
  self.protection_btn = nil
  self.z_m_boss_state_info = nil
  self.march_time = nil
  self.march_time_txt = nil
  self.owner_name = nil
  self.u_i_player_head = nil
  self.monster_name = nil
  self.monster_buff = nil
  self.alliance_text = nil
end

local function DataDefine(self)
  self.data = nil
  self.updateNextSkillTime = false
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.protectionEndTime = 0
end

local function DataDestroy(self)
  self.data = nil
  self.updateNextSkillTime = nil
  self.protectionEndTime = nil
end

local function SetAllCellDestroy(self)
  self.content:RemoveComponents(RewardItem)
  self.possi_content:RemoveComponents(RewardItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v then
        for key, value in pairs(v) do
          if v ~= nil then
            self:GameObjectDestroy(value)
          end
        end
      end
    end
  end
  self.model = {}
end

local function SetAllHeroSmallCellDestroy(self)
  self.lineUp_content:RemoveComponents(HeroSmallItem)
  if self.heroSmallModel ~= nil then
    for k, v in pairs(self.heroSmallModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.heroSmallModel = {}
end

local function RefreshData(self, param)
  self.data = param
  self.des_txt:SetLocalText(self.data.des)
  self.tips2_txt:SetActive(false)
  self.down:SetActive(true)
  self.tips_path:SetActive(true)
  self.tip:SetActive(false)
  self.tips_txt:SetActive(true)
  self.z_m_boss_state_info:SetActive(false)
  self.march_time:SetActive(false)
  self.owner_name:SetActive(false)
  self.possi_text_btn:SetActive(false)
  self.alliance_text:SetActive(false)
  self.limit_tip:SetActive(self.data.marchType == NewMarchType.BEHEMOTH_BOSS)
  local isPowerRectShow = self.view.ctrl.type == WorldPointUIType.Boss or self.view.ctrl.type == WorldPointUIType.Aisilla or self.view.ctrl.type == WorldPointUIType.ZoneMobilizationBoss
  self.power_rect:SetActive(isPowerRectShow)
  if self.view.ctrl.type == WorldPointUIType.Monster or self.view.ctrl.type == WorldPointUIType.Boss or self.view.ctrl.type == WorldPointUIType.Aisilla then
    if self.data.marchType == NewMarchType.RUNNING_MUMMY then
      self.the_name:SetActive(false)
      self.owner_name:SetActive(true)
      self.monster_name:SetLocalText(self.data.name, self.data.ownerName)
      self.u_i_player_head:SetHeadAndFrame(self.data.ownerUid, self.data.pic, self.data.picVer, nil, self.data.headSkinId, self.data.headSkinET)
      self.march_time:SetActive(true)
    elseif self.data.marchType == NewMarchType.MUMMY then
      self.the_name:SetActive(false)
      self.owner_name:SetActive(true)
      self.monster_name:SetLocalText(self.data.name, self.data.ownerName)
      self.u_i_player_head:SetHeadAndFrame(self.data.ownerUid, self.data.pic, self.data.picVer, nil, self.data.headSkinId, self.data.headSkinET)
    else
      self.the_name:SetActive(true)
      self.the_name:SetLocalText(self.data.name)
    end
  elseif self.view.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
    self.the_name:SetActive(true)
    self.the_name:SetText(self.data.name)
  else
    self.the_name:SetActive(false)
  end
  self.rallyTip_rect:SetActive(false)
  if self.view.ctrl.type == WorldPointUIType.Monster then
    self.time_txt:SetActive(not CS.SceneManager:IsInCity())
    if self.data.belongSelf then
      self.tips_txt:SetText("")
    elseif self.data.canAttack == 2 then
      self.tips_txt:SetLocalText("season_tips226")
    elseif self.data.canAttack == 1 then
      self.tips_txt:SetText(self.data.recommend_power)
    else
      self.tips_txt:SetLocalText(128008, self.data.attackMaxLv)
    end
    if CS.SceneManager:IsInWorld() then
      self:AddTimer()
      self:RefreshTime()
    end
    self.tip:SetActive(true)
    local attackMonster = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_MONSTER)
    self.tip:SetText(math.floor(attackMonster))
    if param.monsterType == LWWorldMonsterType.S4TankBN or param.monsterType == LWWorldMonsterType.S4AirplaneBN or param.monsterType == LWWorldMonsterType.S4MissileBN then
      UIUtil.CheckEventTrigger(OpMode.ClickBtnBloodyNightMonster)
    end
  elseif self.view.ctrl.type == WorldPointUIType.Explore then
    self.time_txt:SetActive(false)
    self.tips_txt:SetText(self.data.recommend_power)
    local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.data.uuid)
    if detectEventData ~= nil then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectEventData.eventId)
      if config ~= nil and (config.type == DetectEventType.DetectEventPVE or config.type == DetectEventType.HeroTrial) and not string.IsNullOrEmpty(config.para2) then
        local k9 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k9")
        if 0 < k9 then
          self.tip:SetActive(false)
          self.tip:SetText(math.floor(k9))
        end
      end
    end
  elseif self.view.ctrl.type == WorldPointUIType.DetectEventPVE then
    self.time_txt:SetActive(false)
    self.tip:SetActive(false)
    self.tips_path:SetActive(false)
  elseif self.view.ctrl.type == WorldPointUIType.DetectEventFakePVP then
    self.time_txt:SetActive(false)
    self.tips_txt:SetText(self.data.recommend_power)
    self.down:SetActive(false)
  elseif self.view.ctrl.type == WorldPointUIType.Boss then
    self.time_txt:SetActive(true)
    self.tip:SetActive(self.data.marchType ~= NewMarchType.SANDFISH and self.data.marchType ~= NewMarchType.RUNNING_MUMMY and self.data.marchType ~= NewMarchType.MUMMY)
    local attackMonster = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.RALLY_FOR_BOSS)
    if param.wasFrozen then
      attackMonster = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k16", 5)
    elseif param.special == WorldMonsterSpecialType.GoldenBeetleBoss then
      attackMonster = 10
    elseif param.special == WorldMonsterSpecialType.S4RunningBoss then
      attackMonster = 0
    end
    self:AddTimer()
    self:RefreshTime()
    if self.data.special == WorldMonsterSpecialType.CityStrongholdBOSS then
      if self.data.canAttack == 2 then
        self.tips_txt:SetActive(true)
        if LuaEntry.Player:IsInAlliance() then
          self.tips_txt:SetLocalText("season_tips226")
        else
          self.tips_txt:SetLocalText("300707")
        end
      else
        self.tips_txt:SetActive(false)
      end
    elseif DataCenter.LWActivityLockhartManager:IsLockHartBoss(self.data.special) then
      local maxLockhartUnlockLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
      local needShowTip = maxLockhartUnlockLevel < self.data.level
      if needShowTip then
        self.tips_txt:SetActive(true)
        self.tips_txt:SetLocalText("activity_luoha_desc_firstKill", maxLockhartUnlockLevel, Localization:GetString(self.data.name))
      else
        self.tips_txt:SetActive(false)
      end
    else
      self.tips_txt:SetActive(false)
    end
    if self.data.marchType == NewMarchType.BEHEMOTH_BOSS then
      self.limt_tip_text:SetText(self.data.limitDes)
      self.tips_path:SetActive(false)
      self.time_txt:SetActive(false)
      attackMonster = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.ATTACK_MONSTER)
    end
    self.tip:SetText(math.floor(attackMonster))
    if self.data.marchType == NewMarchType.RUNNING_MUMMY then
      self.power_txt:SetLocalText("season_mastery_s3_UI_22", UIUtil.MakeJumpLink(self.data.targetPos))
    elseif self.data.marchType == NewMarchType.MUMMY then
      self.down:SetActive(false)
      if self.data.targetPos == self.data.point then
        self.power_txt:SetText("")
      else
        self.power_txt:SetLocalText("season_mastery_s3_UI_22", UIUtil.MakeJumpLink(self.data.targetPos))
      end
    elseif self.data.limit and DataCenter.BuildManager.MainLv < self.data.limit then
      local limitTip = Localization:GetString("143574", self.data.limit)
      self.power_txt:SetText(limitTip)
    else
      self.power_txt:SetText(self.data.recommend_power)
    end
    if param.monsterType == LWWorldMonsterType.S4RunningBoss then
      if DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetCurServerId()) then
        UIUtil.CheckEventTrigger(OpMode.ClickBtnBloodyNightBoss)
      end
    elseif param.monsterType == LWWorldMonsterType.S4BossBN then
      UIUtil.CheckEventTrigger(OpMode.ClickBtnBloodyNightMonster)
    end
  elseif self.view.ctrl.type == WorldPointUIType.Sample then
    self.time_txt:SetActive(true)
    self:AddTimer()
    self:RefreshTime()
    self.tips_txt:SetText("")
    local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.data.uuid)
    if detectEventData ~= nil then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectEventData.eventId)
      if config ~= nil and config.type == DetectEventType.DetectEventPickGarbage then
        local k10 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k10")
        if 0 < k10 then
          self.tip:SetActive(true)
          self.tip:SetText(math.floor(k10))
        end
      end
    end
  elseif self.view.ctrl.type == WorldPointUIType.Rescue then
    if self.data.refreshTime ~= nil then
      self.time_txt:SetActive(true)
      self:AddTimer()
      self:RefreshTime()
    else
      self.time_txt:SetActive(false)
    end
  elseif self.view.ctrl.type == WorldPointUIType.MonsterLock then
    if self.data.refreshTime ~= nil then
      self.time_txt:SetActive(true)
      self:AddTimer()
      self:RefreshTime()
    else
      self.time_txt:SetActive(false)
    end
    self.tips_txt:SetText(self.data.recommend_power)
  elseif self.view.ctrl.type == WorldPointUIType.PickGarbage then
    self.time_txt:SetActive(true)
    self:AddTimer()
    self:RefreshTime()
    self.tips_txt:SetText("")
    local k8 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k8")
    if 0 < k8 then
      self.tip:SetActive(true)
      self.tip:SetText(math.floor(k8))
    end
  elseif self.view.ctrl.type == WorldPointUIType.SingleMapGarbage then
    self.time_txt:SetActive(false)
    self.tips_txt:SetText("")
  elseif self.view.ctrl.type == WorldPointUIType.Aisilla then
    self.time_txt:SetActive(true)
    self.tip:SetActive(true)
    local attackMonster = MarchUtil.GetCostStaminaByTargetType(MarchTargetType.MONSTER_INVASION_BOSS)
    self.tip:SetText(math.floor(attackMonster))
    self:AddTimer()
    self:RefreshTime()
    self.tips_txt:SetActive(true)
    self.tips_txt:SetText(DataCenter.ActivityMonsterInvasionDataManager:GetAttackNumContext())
    if self.data.limit and DataCenter.BuildManager.MainLv < self.data.limit then
      local limitTip = Localization:GetString("143574", self.data.limit)
      self.power_txt:SetText(limitTip)
    else
      self.power_txt:SetText(self.data.recommend_power)
    end
    self.alliance_text:SetActive(true)
    self.alliance_text:SetLocalText("challenge_zombie_boss_title_alliance", self.data.allianceAbbr, self.data.allianceName)
  elseif self.view.ctrl.type == WorldPointUIType.ZoneMobilizationBoss then
    self.z_m_boss_state_info:RefreshData(self.data.uuid)
    self.time_txt:SetActive(true)
    self.tip:SetActive(true)
    local attackMonster = LuaEntry.DataConfig:TryGetNum("zone_mobilization", "k19")
    self.tip:SetText(math.floor(attackMonster))
    self.tips_path:SetActive(false)
    self:AddTimer()
    self:RefreshTime()
    if self.data.limit and DataCenter.BuildManager.MainLv < self.data.limit then
      local limitTip = Localization:GetString("143574", self.data.limit)
      self.power_txt:SetText(limitTip)
    else
      self.power_txt:SetText(self.data.recommend_power)
    end
  elseif self.view.ctrl.type == WorldPointUIType.DetectAttackCityS0Monster then
    self.down:SetActive(true)
    self.time_txt:SetActive(true)
    self:AddTimer()
    self:RefreshTime()
    self.tips_txt:SetText("")
  end
  if self.data.special == WorldMonsterSpecialType.CityStrongholdPVE or self.data.special == WorldMonsterSpecialType.CityStrongholdPVP or self.data.special == WorldMonsterSpecialType.CityStrongholdBOSS then
    self.time_txt:SetActive(false)
  end
  self.down_divide_obj:SetActive(false)
  local show_down = self.tip:GetActive() or self.time_txt:GetActive()
  if show_down then
    self.down_divide_obj:SetActive(true)
    self.emptyObj:SetActive(true)
  end
  self.belong_user_root:SetActive(false)
  self.protection:SetActive(false)
  local special = self.data.special
  if special == WorldMonsterSpecialType.IndividualChallengeBoss or special == WorldMonsterSpecialType.AllyChallengeBoss then
    if self.data.allianceUid ~= nil and self.data.allianceAbbr ~= nil and self.data.allianceName ~= nil then
      self.emptyObj:SetActive(true)
      self.belong_user_root:SetActive(true)
      self.belong_user_desc:SetActive(true)
      self.belong_user_name:SetActive(true)
      self.belong_user_desc:SetLocalText("2010226")
      self.belong_user_name:SetText("<" .. self.data.allianceAbbr .. ">" .. self.data.allianceName)
    elseif self.data.ownerName ~= nil then
      self.emptyObj:SetActive(true)
      self.belong_user_root:SetActive(true)
      self.belong_user_desc:SetActive(true)
      self.belong_user_name:SetActive(true)
      self.belong_user_desc:SetLocalText("2010226")
      self.belong_user_name:SetText(self.data.ownerName)
    else
      local userinfo = ChatInterface.getUserData(self.data.belongUid, true)
      if userinfo ~= nil then
        self.emptyObj:SetActive(true)
        self.belong_user_root:SetActive(true)
        self.belong_user_desc:SetActive(true)
        self.belong_user_name:SetActive(true)
        self.belong_user_desc:SetLocalText("2010226")
        if userinfo.svipLevel ~= nil and type(userinfo.svipLevel) == "number" and 0 < userinfo.svipLevel then
          self.belong_user_name:SetText("[VIP]" .. userinfo.userName)
        else
          self.belong_user_name:SetText(userinfo.userName)
        end
      end
    end
    if isPowerRectShow then
      self.power_txt:SetActive(true)
      self.power_txt:SetText(self.data.recommend_power)
    else
      self.tips_txt:SetActive(true)
      self.tips_txt:SetText(self.data.recommend_power)
    end
  elseif special == WorldMonsterSpecialType.MonsterInvasionBoss then
    local serverId = self.view.ctrl.serverId
    SFSNetwork.SendMessage(MsgDefines.MonsterInvasionBossDetail, serverId, self.data.uuid)
    self:RefreshMonsterProtection(self.data)
  elseif special == WorldMonsterSpecialType.SuperRunningBoss then
    if not string.IsNullOrEmpty(self.data.ownerName) then
      self.emptyObj:SetActive(true)
      self.belong_user_root:SetActive(true)
      self.belong_user_desc:SetActive(true)
      self.belong_user_name:SetActive(true)
      self.belong_user_desc:SetLocalText("monster_invasion_finder")
      self.belong_user_name:SetText(self.data.ownerName)
    end
  elseif special == WorldMonsterSpecialType.Crocodile and not string.IsNullOrEmpty(self.data.ownerName) then
    self.emptyObj:SetActive(true)
    self.belong_user_root:SetActive(true)
    self.belong_user_desc:SetActive(true)
    self.belong_user_name:SetActive(true)
    self.belong_user_desc:SetLocalText("monster_invasion_finder")
    self.belong_user_name:SetText(self.data.ownerName)
  end
  self:SetAllCellDestroy()
  self.ienv_icon_done:SetActive(false)
  self.ienv_btn_jump:SetActive(false)
  self.ienv_btn_state = false
  if self.data.firstRewardStr then
    if self.data.special == WorldMonsterSpecialType.RunningMonster or self.data.special == WorldMonsterSpecialType.GoldenBeetleBoss then
      DataCenter.RunningBossDataManager:ReqTodaySkill()
      self:RefreshRunningBossText()
    else
      self.ienv_txt:SetLocalText(800305)
      self.possi_txt:SetLocalText(2000056)
      self:AddRewardToContainer(self.data.firstRewardStr, self.content)
      self:AddRewardToContainer(self.data.rewardStr, self.possi_content)
    end
  elseif self.data.special == WorldMonsterSpecialType.SuperRunningBoss then
    self:RefreshSuperRunningBossText()
  else
    if self.data.special == WorldMonsterSpecialType.MonsterInvasionBoss then
      self.ienv_txt:SetLocalText(2901039)
      self.possi_txt:SetLocalText(2901040)
    elseif self.data.special == WorldMonsterSpecialType.ZoneMobilizationBoss then
      self.ienv_txt:SetLocalText("zone_mobilization_kill_boss_reward")
    elseif self.data.special == WorldMonsterSpecialType.S4RunningBoss then
      self.ienv_txt:SetLocalText(2000056)
      self.possi_txt:SetLocalText("skill_reward_blood_monster")
      self.possi_text_btn:SetActive(true)
    else
      self.ienv_txt:SetLocalText(2000056)
      self.possi_txt:SetLocalText(2000057)
    end
    self:AddRewardToContainer(self.data.rewardStr, self.content)
    self:AddRewardToContainer(self.data.possiRewardStr, self.possi_content)
  end
  self.scroll4:SetActive(false)
  if (self.data.firstRewardStr == nil or table.length(self.data.firstRewardStr) == 0) and (self.data.rewardStr == nil or table.length(self.data.rewardStr) == 0) and (self.data.possiRewardStr == nil or table.length(self.data.possiRewardStr) == 0) then
    self.ienv_txt:SetActive(false)
    self.possi_txt:SetActive(false)
    self.scroll:SetActive(false)
    self.possi_scroll:SetActive(false)
    self.desc_content:SetActive(true)
    self.desc_txt:SetLocalText(string.IsNullOrEmpty(self.data.special_info) and self.data.des or self.data.special_info)
  else
    self.ienv_txt:SetActive(true)
    self.possi_txt:SetActive(true)
    self.scroll:SetActive(true)
    self.possi_scroll:SetActive(true)
    self.desc_content:SetActive(false)
  end
  if self.data.possiRewardStr == nil or #self.data.possiRewardStr == 0 then
    self.possi_txt:SetActive(false)
    self.possi_scroll:SetActive(false)
  end
  if self.data.special == WorldMonsterSpecialType.RunningMonster or self.data.special == WorldMonsterSpecialType.GoldenBeetleBoss or self.data.special == WorldMonsterSpecialType.SuperRunningBoss then
    if self.data.special == WorldMonsterSpecialType.GoldenBeetleBoss and self.data.possiRewardStr and 0 < table.length(self.data.possiRewardStr) then
      self.scroll:SetActive(true)
      self.scroll4:SetActive(false)
      self.possi_txt:SetActive(true)
      self.possi_scroll:SetActive(true)
    else
      self.scroll:SetActive(false)
      self.scroll4:SetActive(true)
      self.possi_txt:SetActive(false)
      self.possi_scroll:SetActive(false)
    end
    self.ienv_txt:SetActive(true)
    self.rallyTip_rect:SetActive(false)
    if CS.SceneManager.World ~= nil then
      local marchData = CS.SceneManager.World:GetMarch(self.data.uuid)
      if marchData then
        local num = marchData.monsterRallyNum
        if 0 < num then
          self.rallyTip_rect:SetActive(true)
          if 99 < num then
            self.rallyTip_txt:SetText("(99+)")
          else
            self.rallyTip_txt:SetText("(" .. num .. ")")
          end
        end
      end
    end
  elseif self.data.special == WorldMonsterSpecialType.InvasionBigBoss then
    self.possi_txt:SetActive(false)
    self.possi_scroll:SetActive(false)
  end
  self:SetAllHeroSmallCellDestroy()
  if self.view.ctrl.type == WorldPointUIType.DetectEventFakePVP then
    self.lineUp_txt:SetActive(false)
    self.lineUp_scroll:SetActive(false)
  else
    self.lineUp_txt:SetActive(false)
    self.lineUp_scroll:SetActive(false)
  end
  if self.data.resistance and 0 < self.data.resistance then
    self.viral:SetActive(true)
    local str1 = string.format("%s/%s", string.GetFormattedSeparatorNum(toInt(self.data.selfValue)), string.GetFormattedSeparatorNum(toInt(self.data.resistance)))
    local str2 = Localization:GetString("season_tiles_popui_info004", str1)
    local str3 = ""
    if 0 > self.data.selfPercent then
      self.viral_img:SetActive(true)
      self.viral_img_ok:SetActive(false)
      str3 = Localization:GetString("season_tiles_popui_info005", string.GetFormattedPercentStr(self.data.selfPercent))
      self.viral_txt:SetText(str2 .. " " .. str3)
      self.viral_bg:SetColorRGBA(1, 0.8901960784313725, 0.8745098039215686, 1)
    else
      self.viral_img:SetActive(false)
      self.viral_img_ok:SetActive(true)
      self.viral_txt:SetText("<color=#0e9500>" .. str2 .. "</color>")
      self.viral_bg:SetColorRGBA(0.8745098039215686, 1, 0.9647058823529412, 1)
    end
  else
    self.viral:SetActive(false)
  end
  if self.data.marchType == NewMarchType.BEHEMOTH_BOSS then
    self:RefreshBehemothBossReward(true)
  else
    self.infodes:SetActive(false)
  end
  self:OnCityStrongholdMonsterDetailRefresh()
  self.army_type:SetActive(false)
  local template = param.monsterTemplate
  if template and (template.dark_buff or template.blood_buff) and SeasonUtil.GetCurWorldSeasonType(true) == SeasonMapType.Darkness then
    local statusIds = {}
    if template.blood_buff and DataCenter.BloodyNightDataManager:IsBloodyNight(LuaEntry.Player:GetCurServerId()) then
      table.extendArray(statusIds, template.blood_buff)
    end
    if template.dark_buff and DataCenter.BloodyNightDataManager:GetBloodyNightState(LuaEntry.Player:GetCurServerId()) ~= BloodyNightState.None and 0 > CS.LightDataManager.GetInstance():GetMaxLightLevelInPointId(param.point) then
      table.extendArray(statusIds, template.dark_buff)
    end
    local trend = 0 >= DataCenter.LWSeasonTrendsManager:GetEffectValue(EffectDefine.TACTICAL_CARD_UNLOCK)
    local personal = 0 >= LuaEntry.Effect:GetGameEffect(EffectDefine.TACTICAL_CARD_UNLOCK)
    if trend and personal then
      SFSNetwork.SendMessage(MsgDefines.LwSeasonTrendInfo)
      for i = #statusIds, 1, -1 do
        if statusIds[i] == StatusId.BloodyNightDropMoreAward or statusIds[i] == StatusId.BloodyNightGetMoreAward then
          table.remove(statusIds, i)
        end
      end
    end
    if 0 < #statusIds then
      self.monster_buff:SetActive(true)
      self.monster_buff:SetData(statusIds)
    else
      self.monster_buff:SetActive(false)
    end
  elseif template and template.type and ARMY_TYPE_SPRITE[template.type] and self.data.special == WorldMonsterSpecialType.Normal and SeasonUtil.GetCurWorldSeasonType(true) == SeasonMapType.NineNation then
    self.army_type:SetActive(true)
    self.army_type:LoadSpriteAsync(ARMY_TYPE_SPRITE[template.type])
  end
end

function WorldMonsterDes:OnCityStrongholdMonsterDetailRefresh()
  if self.data.special ~= WorldMonsterSpecialType.CityStrongholdPVE then
    self.city_stronghold_root:SetActive(false)
    return
  end
  local theDetail = DataCenter.SeasonDataManager:GetMonsterDetail(self.data.uuid)
  if theDetail and toInt(theDetail.curNum) > 0 then
    self.city_stronghold_root:SetActive(true)
    self.city_stronghold_monster_num:SetText("x" .. theDetail.curNum)
  else
    self.city_stronghold_root:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.city_stronghold_btn.transform)
end

local function AddRewardToContainer(self, list, container)
  if list ~= nil and container then
    container:RemoveComponents(RewardItem)
    if self.model[container] then
      for _, v in pairs(self.model[container]) do
        if v ~= nil then
          v:Destroy()
        end
      end
    end
    self.model[container] = {}
    local num = 0
    local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
    for i = 1, table.length(list) do
      num = num + 1
      self.model[container][i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(150, 150)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:SetSeasonType(seasonType)
        cell:RefreshData(list[i], self.view.ctrl.type)
      end)
    end
    if self.data.exp ~= nil and self.data.exp > 0 then
      self.model[container][num + 1] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local oneData = {}
        oneData.count = self.data.exp
        oneData.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
        oneData.iconName = "Assets/Main/Sprites/ItemIcons/item230001.png"
        oneData.itemFlag = ""
        oneData.rewardType = RewardType.EXP
        oneData.itemName = Localization:GetString("100083")
        oneData.itemDesc = Localization:GetString("302010", string.GetFormattedSeperatorNum(self.data.exp))
        oneData.isLocal = true
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:SetSeasonType(seasonType)
        cell:RefreshData(oneData)
      end)
    end
  end
end

local function AddHeroToContainer(self, list, container)
  if list ~= nil and container then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.heroSmallModel[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointHeroSmallItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(84, 84)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(HeroSmallItem, nameStr)
        cell:RefreshData(list[i])
      end)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.data == nil or self.data.refreshTime == nil then
    self.time_txt:SetText("")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.data.refreshTime - curTime
  if self.data ~= nil and 0 < deltaTime then
    self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
  else
    self.time_txt:SetText("")
  end
end

local function OnInfoClick(self)
  if self.animator then
    self.animator:Enable(true)
    self.animator:Play("switchEnter", 0, 0)
  end
end

local function OnReturnClick(self)
  if self.animator then
    self.animator:Enable(true)
    self.animator:Play("switchOut", 0, 0)
  end
end

local function RefreshSuperRunningBossText(self, state)
  if self.data and self.data.special == WorldMonsterSpecialType.SuperRunningBoss then
    if state ~= nil then
      self.ienv_btn_state = state
    else
      self.ienv_btn_state = false
    end
    self.ienv_btn_jump:SetActive(true)
    self.ienv_icon_done:SetActive(false)
    if self.ienv_btn_state then
      self.ienv_txt:SetText(Localization:GetString("running_boss_willy_005"))
      self.ienv_btn_jump:SetLocalScaleXYZ(-1, 1, 1)
      self:AddRewardToContainer(self.data.possiRewardStr, self.content4)
    else
      self.ienv_txt:SetText(Localization:GetString("running_boss_willy_004"))
      self.ienv_btn_jump:SetLocalScaleXYZ(1, 1, 1)
      self:AddRewardToContainer(self.data.restrictedRewardStr, self.content4)
    end
  end
end

local function RefreshRunningBossText(self, state)
  local isDone = false
  local count = 1
  local need = 1
  local flag = false
  if self.data and self.data.special == WorldMonsterSpecialType.RunningMonster then
    flag = true
    isDone = DataCenter.RunningBossDataManager.todaySkill
    count = DataCenter.RunningBossDataManager.todayCount
    need = DataCenter.RunningBossDataManager.needCount
  elseif self.data and self.data.special == WorldMonsterSpecialType.GoldenBeetleBoss then
    flag = true
    isDone = DataCenter.RunningBossDataManager.mummyTodaySkill
    count = DataCenter.RunningBossDataManager.mummyTodayCount
    need = DataCenter.RunningBossDataManager.mummyNeedCount
  end
  if flag then
    if state ~= nil then
      self.ienv_btn_state = state
    else
      self.ienv_btn_state = isDone
    end
    self.ienv_btn_jump:SetActive(true)
    local determinedReward
    if self.ienv_btn_state then
      self.ienv_txt:SetText(Localization:GetString("311052"))
      self.ienv_icon_done:SetActive(false)
      self.ienv_btn_jump:SetLocalScaleXYZ(-1, 1, 1)
      determinedReward = self.data.restrictedRewardStr
    else
      self.ienv_txt:SetText(Localization:GetString("801713") .. "(" .. count .. "/" .. need .. ")")
      self.ienv_icon_done:SetActive(isDone)
      self.ienv_btn_jump:SetLocalScaleXYZ(1, 1, 1)
      determinedReward = self.data.firstRewardStr
    end
    if self.data.special == WorldMonsterSpecialType.GoldenBeetleBoss and self.data.possiRewardStr and table.length(self.data.possiRewardStr) > 0 then
      self.scroll4:SetActive(false)
      self.scroll:SetActive(true)
      self:AddRewardToContainer(determinedReward, self.content)
      self.possi_txt:SetActive(true)
      self.possi_txt:SetLocalText(2000057)
      self.possi_scroll:SetActive(true)
      self:AddRewardToContainer(self.data.possiRewardStr, self.possi_content)
    else
      self:AddRewardToContainer(determinedReward, self.content4)
    end
  end
end

function WorldMonsterDes:OnClickJump()
  self.ienv_btn_state = not self.ienv_btn_state
  if self.data.special == WorldMonsterSpecialType.SuperRunningBoss then
    RefreshSuperRunningBossText(self, self.ienv_btn_state)
  else
    RefreshRunningBossText(self, self.ienv_btn_state)
  end
end

function WorldMonsterDes:RefreshBehemothBossReward(flag)
  self.ienv_txt:SetActive(false)
  self.desc_content:SetActive(false)
  self.infodes:SetActive(true)
  self.power_rect:SetActive(false)
  self.scroll:SetActive(false)
  local nextTime = self.data.nextSkillTime or 0
  local now = UITimeManager:GetInstance():GetServerTime()
  if nextTime > now then
    self.updateNextSkillTime = true
    local str = UITimeManager:GetInstance():SecondToFmtString((nextTime - now) / 1000)
    local hurt = DataCenter.SeasonNuclearPowerPlantDataManager:GetMonsterSkillHurt(self.data.uuid)
    self.infodes_text:SetText(Localization:GetString("season_s2_activity_1000047_description_24", str, hurt))
  else
    self.updateNextSkillTime = false
    self.infodes_text:SetText("")
  end
end

function WorldMonsterDes:BehemothBossDataRefresh()
  self:RefreshBehemothBossReward()
end

function WorldMonsterDes:ShowResistanceDetail()
  local needTip = self.data.marchType == NewMarchType.MONSTER or self.data.marchType == NewMarchType.BOSS
  if needTip and UIUtil.ShowResistanceWarning(self.data, false, nil) then
    return
  end
  if self.data.selfPercent >= 0 then
    UIUtil.ShowTipsId("season_tiles_popui_info007")
  else
    UIUtil.ShowResistanceDetail(self.data.selfPercent, self.data.otherPercent)
  end
end

function WorldMonsterDes:OnMonsterProtectionRefresh(msg)
  if self.data and self.data.uuid and self.data.uuid == msg.uuid then
    self:RefreshMonsterProtection(msg, true)
  end
end

function WorldMonsterDes:RefreshMonsterProtection(data, onMsg)
  local ownerName
  if data and not string_IsNullOrEmpty(data.ownerName) then
    ownerName = data.ownerName
    if onMsg and not string_IsNullOrEmpty(data.allianceAbbr) then
      ownerName = "[" .. data.allianceAbbr .. "]" .. ownerName
    end
  elseif self.data and not string_IsNullOrEmpty(self.data.belongUid) then
    local userinfo = ChatInterface.getUserData(self.data.belongUid, true)
    if userinfo ~= nil then
      ownerName = userinfo.userName
      if not string.IsNullOrEmpty(userinfo.allianceSimpleName) then
        ownerName = "[" .. userinfo.allianceSimpleName .. "]" .. ownerName
      end
    end
  end
  if not string_IsNullOrEmpty(ownerName) then
    self.emptyObj:SetActive(true)
    self.belong_user_root:SetActive(true)
    self.belong_user_desc:SetActive(true)
    self.belong_user_name:SetActive(true)
    self.belong_user_desc:SetLocalText("monster_invasion_finder")
    self.belong_user_name:SetText(ownerName)
  end
  if data and data.isProtected ~= nil then
    self.data.isProtected = data.isProtected
  end
  if data and not data.isProtected then
    self.protectionEndTime = 0
  else
    self.protectionEndTime = DataCenter.MonsterProtectionManager:GetMonsterProtectionEndTime(data.uuid)
  end
  self:UpdateProtectionEndTime()
end

function WorldMonsterDes:GetProtectedState(data)
  if self.data and self.data.isProtected ~= nil then
    return self.data.isProtected
  end
  return true
end

function WorldMonsterDes:Update1000MS()
  if self.updateNextSkillTime then
    local nextTime = self.data.nextSkillTime or 0
    local now = UITimeManager:GetInstance():GetServerTime()
    if nextTime > now then
      local str = UITimeManager:GetInstance():SecondToFmtString((nextTime - now) / 1000)
      local hurt = DataCenter.SeasonNuclearPowerPlantDataManager:GetMonsterSkillHurt(self.data.uuid)
      self.infodes_text:SetText(Localization:GetString("season_s2_activity_1000047_description_24", str, hurt))
    else
      self.updateNextSkillTime = false
      self.infodes_text:SetText("")
    end
  end
  self:UpdateProtectionEndTime()
  if self.data and self.data.endTime and self.data.marchType == NewMarchType.RUNNING_MUMMY then
    local now = UITimeManager:GetInstance():GetServerTime()
    local str = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.data.endTime - now)
    self.march_time_txt:SetText(str)
  end
end

local function UpdateProtectionEndTime(self)
  if self.protectionEndTime and self.protectionEndTime > 0 then
    local diff = self.protectionEndTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < diff then
      self.protection:SetActive(true)
      self.data.isProtected = true
      self.protection_time:SetText(UITimeManager:GetInstance():SecondToFmtString(diff / 1000))
    else
      self.protectionEndTime = nil
      self.protection:SetActive(false)
      self.data.isProtected = false
    end
  else
    self.protection:SetActive(false)
  end
end

WorldMonsterDes.OnCreate = OnCreate
WorldMonsterDes.OnDestroy = OnDestroy
WorldMonsterDes.OnEnable = OnEnable
WorldMonsterDes.OnDisable = OnDisable
WorldMonsterDes.OnRemoveListener = OnRemoveListener
WorldMonsterDes.OnAddListener = OnAddListener
WorldMonsterDes.ComponentDefine = ComponentDefine
WorldMonsterDes.ComponentDestroy = ComponentDestroy
WorldMonsterDes.DataDefine = DataDefine
WorldMonsterDes.DataDestroy = DataDestroy
WorldMonsterDes.AddTimer = AddTimer
WorldMonsterDes.DeleteTimer = DeleteTimer
WorldMonsterDes.RefreshTime = RefreshTime
WorldMonsterDes.RefreshData = RefreshData
WorldMonsterDes.AddRewardToContainer = AddRewardToContainer
WorldMonsterDes.AddHeroToContainer = AddHeroToContainer
WorldMonsterDes.SetAllCellDestroy = SetAllCellDestroy
WorldMonsterDes.SetAllHeroSmallCellDestroy = SetAllHeroSmallCellDestroy
WorldMonsterDes.OnReturnClick = OnReturnClick
WorldMonsterDes.OnInfoClick = OnInfoClick
WorldMonsterDes.RefreshRunningBossText = RefreshRunningBossText
WorldMonsterDes.UpdateProtectionEndTime = UpdateProtectionEndTime
WorldMonsterDes.RefreshSuperRunningBossText = RefreshSuperRunningBossText
return WorldMonsterDes
