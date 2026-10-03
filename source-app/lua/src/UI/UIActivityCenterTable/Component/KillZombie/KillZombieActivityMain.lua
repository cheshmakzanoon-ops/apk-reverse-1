local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local KillZombieActivityMain = BaseClass("KillZombieActivityMain", base)
local Localization = CS.GameEntry.Localization
local PersonReward = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonReward")
local PersonTask = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonTask")
local PersonLevel = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonLevel")
local PersonTaskV2 = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonLevelV2")
local PersonTip = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityPersonTip")
local KillZombieActivityALPanel = require("UI.UIActivityCenterTable.Component.KillZombie.KillZombieActivityALPanel")
local KillZombieActivityALKirovPanel = require("UI.UIActivityCenterTable.Component.KillZombie.AllianceKirov.KillZombieActivityALKirovPanel")
local toggle1_path = "RightView/TabHolder/Tab/toggle1"
local toggle2_path = "RightView/TabHolder/Tab/toggle2"
local toggle1_on_path = "RightView/TabHolder/Tab/toggle1/on1"
local toggle2_on_path = "RightView/TabHolder/Tab/toggle2/on2"
local red_point1_path = "RightView/TabHolder/Tab/toggle1/RedPoint1"
local red_point2_path = "RightView/TabHolder/Tab/toggle2/RedPoint2"
local toggle_txt_on1_path = "RightView/TabHolder/Tab/toggle1/on1/toggle_txt_on1"
local toggle_txt_on2_path = "RightView/TabHolder/Tab/toggle2/on2/toggle_txt_on2"
local toggle_txt_off1_path = "RightView/TabHolder/Tab/toggle1/toggle_txt_off1"
local toggle_txt_off2_path = "RightView/TabHolder/Tab/toggle2/toggle_txt_off2"
local root_personal_path = "RightView/RootPersonal"
local root_personal_banner_path = "RightView/RootPersonal/banner"
local title_path = "RightView/Top/title"
local remain_time_path = "RightView/Top/TimeRoot/Bg/remainTime"
local info_btn_path = "RightView/Top/InfoBtn"
local help_btn_path = "RightView/Top/HelpBtn"
local gift_btn_path = "RightView/Top/GiftBtn"
local gift_red_point_path = "RightView/Top/GiftBtn/RedPoint"
local tip_root_v2_path = "RightView/TipRootV2"
local person_basic_traill_toggle1_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle1"
local person_advance_traill_toggle2_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle2"
local person_basic_traill_toggle1_on_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle1/person_on1"
local person_advance_traill_toggle2_on_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle2/person_on2"
local person_basic_traill_red_point1_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle1/personRedPoint1"
local person_advance_traill_red_point2_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle2/personRedPoint2"
local person_basic_traill_toggle_txt_on1_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle1/person_on1/persontoggle_txt_on1"
local person_advance_traill_toggle_txt_on2_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle2/person_on2/persontoggle_txt_on2"
local person_basic_traill_toggle_txt_off1_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle1/persontoggle_txt_off1"
local person_advance_traill_toggle_txt_off2_path = "RightView/RootPersonal/TaskScrollView/TrailTabHolder/Tab/persontoggle2/persontoggle_txt_off2"
local root_alliance_path = "RightView/PanelRoot/RootAlliance"
local panel_root_path = "RightView/PanelRoot"
local person_basic_trial_banner = "Assets/Main/TextureEx/UIActivityKillZombieCommon/FX_jiangjunshilian_banner.png"
local person_advance_trial_banner = "Assets/Main/TextureEx/UIActivityKillZombieCommon/FX_jiangjunshilian_banner2.png"
local AL_KIROV_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/KillZombie/RootAllianceKirov.prefab"

function KillZombieActivityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.KillZombieDataPull)
end

function KillZombieActivityMain:OnDestroy()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.KillZombie, false)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function KillZombieActivityMain:ComponentDefine()
  self.tip_root_v2 = self:AddComponent(PersonTip, tip_root_v2_path)
  self.tip_root_v2:SetActive(false)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle_txt_on1 = self:AddComponent(UIText, toggle_txt_on1_path)
  self.toggle_txt_on2 = self:AddComponent(UIText, toggle_txt_on2_path)
  self.toggle_txt_off1 = self:AddComponent(UIText, toggle_txt_off1_path)
  self.toggle_txt_off2 = self:AddComponent(UIText, toggle_txt_off2_path)
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
  self.root_personal = self:AddComponent(UIButton, root_personal_path)
  self.title = self:AddComponent(UIText, title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.help_btn = self:AddComponent(UIButton, help_btn_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.gift_red_point = self:AddComponent(UIImage, gift_red_point_path)
  self.personalBannerImg = self:AddComponent(UIRawImage, root_personal_banner_path)
  self.personBascitoggle1 = self:AddComponent(UIToggle, person_basic_traill_toggle1_path)
  self.personAdvancetoggle2 = self:AddComponent(UIToggle, person_advance_traill_toggle2_path)
  self.personBasictoggle_txt_on1 = self:AddComponent(UIText, person_basic_traill_toggle_txt_on1_path)
  self.personAdvancetoggle_txt_on2 = self:AddComponent(UIText, person_advance_traill_toggle_txt_on2_path)
  self.personBasictoggle_txt_off1 = self:AddComponent(UIText, person_basic_traill_toggle_txt_off1_path)
  self.personAdvancetoggle_txt_off2 = self:AddComponent(UIText, person_advance_traill_toggle_txt_off2_path)
  self.personBasicred_point1 = self:AddComponent(UIImage, person_basic_traill_red_point1_path)
  self.personAdvancered_point2 = self:AddComponent(UIImage, person_advance_traill_red_point2_path)
  self.personBasictoggle_txt_on1:SetLocalText("challenge_zombie_003")
  self.personBasictoggle_txt_off1:SetLocalText("challenge_zombie_003")
  self.personAdvancetoggle_txt_on2:SetLocalText("challenge_zombie_004")
  self.personAdvancetoggle_txt_off2:SetLocalText("challenge_zombie_004")
  self.toggle1On = self:AddComponent(UIImage, toggle1_on_path)
  self.toggle2On = self:AddComponent(UIImage, toggle2_on_path)
  self.persontoggle1On = self:AddComponent(UIImage, person_basic_traill_toggle1_on_path)
  self.persontoggle2On = self:AddComponent(UIImage, person_advance_traill_toggle2_on_path)
  self.personal_task_scroll_view = self:AddComponent(PersonTaskV2, "RightView/RootPersonal/TaskScrollView")
  self.mPersonReward = self:AddComponent(PersonReward, "RightView/RootPersonal/reward")
  self.mPersonTask = self:AddComponent(PersonTask, "RightView/RootPersonal/task")
  self.panel_root = self:AddComponent(UIBaseContainer, panel_root_path)
  if DataCenter.ActivityKillZombieManager.isNewFuncOpen then
    self:ShowAlKirovPanelAsync()
  else
    self.root_alliance = self:AddComponent(KillZombieActivityALPanel, root_alliance_path)
    self.root_alliance:SetActive(true)
  end
  self.toggle_txt_on1:SetLocalText("2010205")
  self.toggle_txt_off1:SetLocalText("2010205")
  self.toggle_txt_on2:SetLocalText("2010206")
  self.toggle_txt_off2:SetLocalText("2010206")
  self.toggle1On:SetActive(false)
  self.toggle2On:SetActive(false)
  self.persontoggle1On:SetActive(false)
  self.persontoggle2On:SetActive(false)
  self.toggle1:SetIsOn(false)
  self.toggle1:SetOnValueChanged(function(tf)
    self.toggle1On:SetActive(tf)
    if tf then
      self:SelectTab(1)
    end
  end)
  self.toggle2:SetIsOn(false)
  self.toggle2:SetOnValueChanged(function(tf)
    self.toggle2On:SetActive(tf)
    if tf then
      self:SelectTab(2)
    end
  end)
  self.personBascitoggle1:SetIsOn(false)
  self.personBascitoggle1:SetOnValueChanged(function(tf)
    self.persontoggle1On:SetActive(tf)
    if tf then
      self:SelectTrailTab(0)
    end
  end)
  self.personAdvancetoggle2:SetIsOn(false)
  self.personAdvancetoggle2:SetOnValueChanged(function(tf)
    self.persontoggle2On:SetActive(tf)
    if tf then
      self:SelectTrailTab(1)
    end
  end)
  self.personBasicred_point1:SetActive(false)
  self.personAdvancered_point2:SetActive(false)
  self.info_btn:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.help_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.gift_btn:SetOnClick(function()
    self:OnShowGiftBtnClick()
  end)
  self.red_point1:SetActive(false)
  self.red_point2:SetActive(false)
end

function KillZombieActivityMain:RefreshRedPoint()
  local act_red_point1 = false
  local act_red_point2 = false
  local yes = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.KillZombie)
  local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
  if yes and kill_zombie_AL ~= nil then
    local mgr = DataCenter.ActivityKillZombieManager
    for k, v in pairs(kill_zombie_AL) do
      if v ~= nil and v.status == 0 and mgr:CanInvokeBossZombie(k) and DataCenter.AllianceBaseDataManager:IsR4orR5() then
        act_red_point2 = true
        break
      end
    end
  end
  local kill_zombie_User = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_User ~= nil then
    local user_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    if user_difficulty_select == 0 then
      act_red_point1 = true
    elseif yes and kill_zombie_User.finish == 0 then
      act_red_point1 = true
    elseif DataCenter.ActivityKillZombieManager:HasPersonMonsterReward() then
      act_red_point1 = true
    end
  end
  if DataCenter.ActivityKillZombieManager:GetNewChallengeRedPoint() then
    act_red_point2 = true
  end
  self.red_point1:SetActive(act_red_point1)
  self.red_point2:SetActive(act_red_point2)
end

function KillZombieActivityMain:ComponentDestroy()
  self.toggle1:SetIsOnWithoutNotify(false)
  self.toggle2:SetIsOnWithoutNotify(false)
  self.personBascitoggle1:SetIsOnWithoutNotify(false)
  self.personAdvancetoggle2:SetIsOnWithoutNotify(false)
  self.tip_root_v2:SetActive(false)
  self.timeCD = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.toggle_txt1 = nil
  self.toggle_txt2 = nil
  self.red_point1 = nil
  self.red_point2 = nil
  self.root_personal = nil
  self.title = nil
  self.remain_time = nil
  self.info_btn = nil
  self.help_btn = nil
  self.gift_btn = nil
  self.level_btn_go = nil
  self.mPersonReward = nil
  self.mPersonTask = nil
  self.mPersonLevel = nil
  self.root_alliance = nil
  self.personBascitoggle1 = nil
  self.personAdvancetoggle2 = nil
  self.personBasictoggle_txt_on1 = nil
  self.personAdvancetoggle_txt_on2 = nil
  self.personBasictoggle_txt_off1 = nil
  self.personAdvancetoggle_txt_off2 = nil
  self.personBasicred_point1 = nil
  self.personAdvancered_point2 = nil
  self.personal_task_scroll_view = nil
  self.panel_root = nil
end

function KillZombieActivityMain:OnEnable()
  base.OnEnable(self)
  self:RefreshUI()
end

function KillZombieActivityMain:OnDisable()
  base.OnDisable(self)
end

function KillZombieActivityMain:DataDefine()
  self.alKirovPanelReq = nil
end

function KillZombieActivityMain:DataDestroy()
  self.alKirovPanelReq = nil
end

function KillZombieActivityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.OnUpdateTask)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  self:AddUIListener(EventId.MonsterChallengedTaskReward, self.UpdateData)
  self:AddUIListener(EventId.MonsterChallengeUpdate, self.UpdateData)
end

function KillZombieActivityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskSuccess, self.OnUpdateTask)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.OnRefreshActivityRedDot)
  self:RemoveUIListener(EventId.MonsterChallengedTaskReward, self.UpdateData)
  self:RemoveUIListener(EventId.MonsterChallengeUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function KillZombieActivityMain:OnUpdateTask()
  self:RefreshUI()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function KillZombieActivityMain:UpdateData()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonConfirm) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonConfirm)
  end
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data == nil then
    return
  end
  self:RefreshUI()
  local activeDifficulty = CS.GameEntry.Setting:GetBool("KillZombieActiveDifficulty_" .. LuaEntry.Player.uid, false)
  self.gift_red_point:SetActive(activeDifficulty or DataCenter.ActivityKillZombieManager:HasPersonMonsterReward())
end

function KillZombieActivityMain:OnRefreshActivityRedDot()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data == nil then
    return
  end
  self:RefreshRedPoint()
  local activeDifficulty = CS.GameEntry.Setting:GetBool("KillZombieActiveDifficulty_" .. LuaEntry.Player.uid, false)
  self.gift_red_point:SetActive(activeDifficulty or DataCenter.ActivityKillZombieManager:HasPersonMonsterReward())
end

function KillZombieActivityMain:PerformClickTab(tabIndex)
  if tabIndex == 1 then
    self.toggle1:SetIsOn(true)
  elseif tabIndex == 2 then
    self.toggle2:SetIsOn(true)
  else
    self.toggle1:SetIsOn(true)
  end
end

function KillZombieActivityMain:SelectTab(index)
  if self.tabActive == index then
    return
  end
  self.tabActive = index
  self.tip_root_v2:SetActive(false)
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data == nil then
    self.root_personal:SetActive(false)
    self.panel_root:SetActive(false)
    return
  end
  self.root_personal:SetActive(index == 1)
  self.panel_root:SetActive(index == 2)
  self.gift_btn:SetActive(index == 1)
  self.personal_task_scroll_view:StopDelayPoster()
  if index == 1 then
    local kill_zombie_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    local kill_zombie_difficulty_max = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
    local curDifficultyMaxLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(kill_zombie_difficulty_max)
    local curDifficultyLevelMin, curDifficultyLevelMax = DataCenter.ActivityKillZombieManager:GetMinMaxDifficultyWithTypeAndDifficultyLevel(1, curDifficultyMaxLevel)
    local overCurLevelDifficultyMax = kill_zombie_difficulty_max > curDifficultyLevelMax
    local nextDifficultyLevelOpened = DataCenter.ActivityKillZombieManager:IsDifficultyLevelOpenedBySeasonTime(1, curDifficultyMaxLevel + 1)
    local playerRecordMaxDiffcultyLevel = CommonUtil.PlayerPrefsGetInt(SettingKeys.PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL, 0)
    if curDifficultyMaxLevel > playerRecordMaxDiffcultyLevel then
      playerRecordMaxDiffcultyLevel = curDifficultyMaxLevel
      CommonUtil.PlayerPrefsSetInt(SettingKeys.PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL, playerRecordMaxDiffcultyLevel)
    end
    self.personal_task_scroll_view:StopDelayPoster()
    if kill_zombie_difficulty_select ~= 0 then
      self.personal_task_scroll_view:SetActive(false)
      self.mPersonReward:SetData(self.activityData)
      self.mPersonTask:SetData(self.activityData)
      self.mPersonReward:SetActive(true)
      self.mPersonTask:SetActive(true)
      self.personBascitoggle1:SetActive(false)
      self.personAdvancetoggle2:SetActive(false)
      local curDifficultyLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(kill_zombie_difficulty_select)
      self:SetPersonBanner(curDifficultyLevel)
      self.trailtabActive = curDifficultyLevel
      self:RefreshUI()
    else
      self.personBascitoggle1:SetActive(true)
      local advanceIsOpen = LuaEntry.DataConfig:CheckSwitch("new_challenge_zombie_open")
      self.personAdvancetoggle2:SetActive(0 < playerRecordMaxDiffcultyLevel and advanceIsOpen)
      self.mPersonReward:SetActive(false)
      self.mPersonTask:SetActive(false)
      local selectDifficultyLevel = math.max(playerRecordMaxDiffcultyLevel, curDifficultyMaxLevel)
      self:PerformClickTrailTab(selectDifficultyLevel)
      if advanceIsOpen and overCurLevelDifficultyMax and nextDifficultyLevelOpened and playerRecordMaxDiffcultyLevel < curDifficultyMaxLevel + 1 then
        self:OpenAdvanceTrailTipsWindow()
      end
    end
  elseif index == 2 then
    if self.root_alliance then
      self.root_alliance:SetData(self.activityData)
    end
    self:CheckFirstShowHowToPlay()
  end
end

function KillZombieActivityMain:PerformClickTrailTab(trailTab)
  if trailTab == 0 then
    self.personBascitoggle1:SetIsOn(true)
  elseif trailTab == 1 then
    self.personAdvancetoggle2:SetIsOn(true)
  end
end

function KillZombieActivityMain:OpenAdvanceTrailTipsWindow()
  if self.AdvanceTraillParam == nil then
    self.AdvanceTraillParam = {}
    self.AdvanceTraillParam.titleTxt = "challenge_zombie_007"
    self.AdvanceTraillParam.contentTxt = "challenge_zombie_008"
    self.AdvanceTraillParam.confirmTxt = "challenge_zombie_btn02"
    self.AdvanceTraillParam.cancelTxt = "challenge_zombie_btn01"
    self.AdvanceTraillParam.contentDoTime = 2
    self.AdvanceTraillParam.heroSpinePath = "Assets/Main/Prefabs/HeroSpinPrefabs/hero_icon_Nimitz.prefab"
    
    function self.AdvanceTraillParam.confirmCallBack()
      local nextSelectTrail = self:BreakThroughNextTrailLevel()
      self:PerformClickTrailTab(nextSelectTrail)
    end
    
    function self.AdvanceTraillParam.cancelCallBack()
      self:BreakThroughNextTrailLevel()
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIKillZombieAdvanceTrail, {anim = false}, self.AdvanceTraillParam)
end

function KillZombieActivityMain:BreakThroughNextTrailLevel()
  local kill_zombie_difficulty_max = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_MAX, 0)
  local curDifficultyMaxLevel = DataCenter.ActivityKillZombieManager.GetDifficultyLevel(kill_zombie_difficulty_max)
  local nextDifficultyLevel = curDifficultyMaxLevel + 1
  CommonUtil.PlayerPrefsSetInt(SettingKeys.PERSON_KILLZOMBIE_MAX_DIFFICULTY_LEVEL, nextDifficultyLevel)
  local selectDifficultyLevel = math.max(nextDifficultyLevel, curDifficultyMaxLevel)
  local advanceIsOpen = LuaEntry.DataConfig:CheckSwitch("new_challenge_zombie_open")
  self.personAdvancetoggle2:SetActive(0 < nextDifficultyLevel and advanceIsOpen)
  return selectDifficultyLevel
end

function KillZombieActivityMain:SetPersonBanner(difficultyLevel)
  if not self.trailtabActive or self.trailtabActive ~= difficultyLevel then
    local bannerPath = person_basic_trial_banner
    if difficultyLevel == 1 then
      bannerPath = person_advance_trial_banner
    end
    self.personalBannerImg:LoadSprite(bannerPath)
  end
end

function KillZombieActivityMain:SelectTrailTab(difficultyLevel)
  self:SetPersonBanner(difficultyLevel)
  self.trailtabActive = difficultyLevel
  self.tip_root_v2:SetActive(false)
  self.personalTaskList = DataCenter.ActivityKillZombieManager:GetDatasWithTypeAndDifficultyLevel(1, difficultyLevel)
  local dataValid = self.personalTaskList ~= nil and self.personalTaskList.data ~= nil
  self.personal_task_scroll_view:SetActive(dataValid)
  self:RefreshUI()
end

function KillZombieActivityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.activityName)
  CS.GameEntry.Setting:SetBool("OpenedKillZombieActivity_" .. LuaEntry.Player.uid, true)
  self.tip_root_v2:SetActive(false)
  if not self.tabActive then
    local tab = 1
    if DataCenter.ActivityKillZombieManager.isNewFuncOpen then
      local newAlData = DataCenter.ActivityKillZombieManager.newAlData
      if newAlData and newAlData.bossUuid ~= nil and newAlData.bossUuid > 0 then
        tab = 2
      end
    end
    self:PerformClickTab(tab)
  else
    self:PerformClickTab(self.tabActive)
  end
  self:RefreshRedPoint()
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function KillZombieActivityMain:RefreshUI()
  if self.tabActive == 2 then
    if self.root_alliance then
      self.root_alliance:RefreshUI()
    end
  elseif self.tabActive == 1 then
    local kill_zombie_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    if kill_zombie_difficulty_select ~= 0 then
      self.personal_task_scroll_view:SetActive(false)
      self.mPersonReward:SetData(self.activityData)
      self.mPersonTask:SetData(self.activityData)
      self.mPersonReward:SetActive(true)
      self.mPersonTask:SetActive(true)
    else
      self.tip_root_v2:SetActive(false)
      self.personal_task_scroll_view:SetActive(true)
      self.personal_task_scroll_view:ReInit(self.tip_root_v2, self.personalTaskList, self.trailtabActive)
      self.mPersonReward:SetActive(false)
      self.mPersonTask:SetActive(false)
    end
  end
  self:RefreshRedPoint()
  self:Update1000MS()
end

function KillZombieActivityMain:Update1000MS()
  if self.activityData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.remain_time:SetText("00:00:00")
    end
  end
end

function KillZombieActivityMain:OnHelpBtnClick()
  if self.activityData ~= nil then
    local param = {}
    param.activityData = self.activityData
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityKillZombieHelpPopup, {anim = true}, param)
  end
end

function KillZombieActivityMain:OnShowGiftBtnClick()
  if self.activityData ~= nil then
    local param = {}
    param.activityData = self.activityData
    param.curSelectTrail = self.trailtabActive
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityKillZombieActionReward, {anim = true}, param)
  end
  local activeDifficulty = CS.GameEntry.Setting:GetBool("KillZombieActiveDifficulty_" .. LuaEntry.Player.uid, false)
  if activeDifficulty == true then
    CS.GameEntry.Setting:SetBool("KillZombieActiveDifficulty_" .. LuaEntry.Player.uid, false)
  end
  self.gift_red_point:SetActive(false)
end

function KillZombieActivityMain:OnInfoBtnClick()
  if DataCenter.ActivityKillZombieManager.isNewFuncOpen and DataCenter.ActivityKillZombieManager:TryShowHowToPlay(self.activityData) then
    return
  end
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function KillZombieActivityMain.GetEventCanRewardCount()
  local mgr = DataCenter.ActivityKillZombieManager
  local activityList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KillZombieActivity.Type)
  if activityList == nil or #activityList == 0 then
    return 0
  end
  local yes = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.KillZombie)
  local count = 0
  local rewardCount = 0
  if mgr.isNewFuncOpen then
    if mgr:GetNewChallengeRedPoint() then
      rewardCount = rewardCount + 1
    end
  else
    local kill_zombie_AL = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_AL_INFO)
    if kill_zombie_AL ~= nil then
      for k, v in pairs(kill_zombie_AL) do
        if v ~= nil and v.status == 0 and mgr:CanInvokeBossZombie(k) and DataCenter.AllianceBaseDataManager:IsR4orR5() then
          rewardCount = rewardCount + 1
        end
      end
    end
  end
  local kill_zombie_User = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_User ~= nil then
    local user_difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
    if user_difficulty_select == 0 then
      count = count + 1
    elseif yes and kill_zombie_User.finish == 0 then
      count = count + 1
    end
  end
  if DataCenter.ActivityKillZombieManager:HasPersonMonsterReward() then
    rewardCount = rewardCount + 1
  end
  return count + rewardCount, rewardCount, count
end

function KillZombieActivityMain.IsAllMonsterDie()
  local kill_zombie_data = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_ACTIVITY_PLAYER_INFO)
  if kill_zombie_data == nil then
    return true
  end
  return kill_zombie_data.finish == 1
end

function KillZombieActivityMain.OnMainUIClick()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KillZombieActivity.Type)
  if dataList == nil or #dataList == 0 then
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    return
  end
  DataCenter.ActivityKillZombieManager:JumpToPersonMonster()
end

function KillZombieActivityMain.CanShowKillZombieIcon()
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KillZombieActivity.Type)
  if dataList == nil or #dataList == 0 then
    return false
  end
  local difficulty_select = DataCenter.ActivityListDataManager:GetExtraData(KILL_ZOMBIE_PLAYER_DIFFICULTY_SELECT, 0)
  if difficulty_select == 0 then
    return false
  end
  return not KillZombieActivityMain.IsAllMonsterDie()
end

function KillZombieActivityMain:ShowAlKirovPanelAsync()
  if self.alKirovPanelReq == nil then
    self.alKirovPanelReq = self:GameObjectInstantiateAsync(AL_KIROV_PREFAB_PATH, function(request)
      if request.isError then
        return
      end
      if self.panel_root then
        local go = request.gameObject
        go.transform:SetParent(self.panel_root.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.root_alliance = self.panel_root:AddComponent(KillZombieActivityALKirovPanel, go.name)
        self.root_alliance:SetOffsetMinXY(0, 0)
        self.root_alliance:SetOffsetMaxXY(0, 0)
        self.root_alliance:SetData(self.activityData)
      end
    end)
  elseif self.root_alliance then
    self.root_alliance:RefreshUI()
  end
end

function KillZombieActivityMain:CheckFirstShowHowToPlay()
  if DataCenter.ActivityKillZombieManager.isNewFuncOpen then
    local notFirst = CS.GameEntry.Setting:GetBool(SettingKeys.AL_CHALLENGE_NOT_FIRST_OPEN_PANEL, false)
    if not notFirst then
      DataCenter.ActivityKillZombieManager:TryShowHowToPlay(self.activityData)
      CS.GameEntry.Setting:SetBool(SettingKeys.AL_CHALLENGE_NOT_FIRST_OPEN_PANEL, true)
    end
  end
end

return KillZombieActivityMain
