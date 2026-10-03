local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIWorldSiegeRewardCell = require("UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeRewardCell")
local WorldSiegeAllianceScoreCell = require("UI.LWWorld.UIWorldSiegePointSeason.Component.WorldSiegeAllianceScoreCell")
local UIWorldSiegePointSeasonInfo = BaseClass("UIWorldSiegePointSeasonInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local UIWorldOccupyHistoryItem = require("UI.LWWorld.UIWorldOccupyHistory.Component.UIWorldOccupyHistoryItem")
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local luaPath_campDestroy = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegePointCompCampDestroy"
local prefabPath_campDestroy = "Assets/Main/SeasonRes/S6/Prefabs/WorldUI/UIWorldSiegePointCompCampDestroy.prefab"
local main_obj_path = "BuildInfo"
local dynamic_root_path = "BuildInfo/DynamicRoot"
local des_obj_path = "BuildDetails"
local build_des_path = "BuildInfo/buildDes"
local city_soldier_des_path = "BuildInfo/buildDes/soldierlayout/citySoliderDes"
local btn_alliance_path = "BuildInfo/buildDes/soldierlayout/btn_alliance"
local city_alliance_name_path = "BuildInfo/buildDes/soldierlayout/NameText"
local city_add_des_path = "BuildInfo/buildDes/layout1/cityAddDes"
local city_add_num_path = "BuildInfo/buildDes/layout1/cityAddNum"
local city_add_num_des_path = "BuildInfo/buildDes/layout1/cityAddNumDes"
local city_add_num_des_1_btn_path = "BuildInfo/buildDes/layout1/cityAddNumDesBtn1"
local common_btn_detail_1_path = "BuildInfo/buildDes/layout1/cityAddNumDesBtn1/Common_btn_detail_1"
local layout2_obj_path = "BuildInfo/buildDes/layout2"
local city_add_des_2_path = "BuildInfo/buildDes/layout2/cityAddDes2"
local city_add_num_2_path = "BuildInfo/buildDes/layout2/cityAddNum2"
local city_add_num_des_2_path = "BuildInfo/buildDes/layout2/cityAddNumDes2"
local layout3_obj_path = "BuildInfo/buildDes/layout3"
local city_add_des_3_path = "BuildInfo/buildDes/layout3/cityAddDes3"
local city_add_num_3_path = "BuildInfo/buildDes/layout3/cityAddNum3"
local city_add_num_des_btn_path = "BuildInfo/buildDes/layout3/cityAddNumDesBtn3"
local layout4_obj_path = "BuildInfo/buildDes/layout4"
local city_add_des_4_path = "BuildInfo/buildDes/layout4/cityAddDes4"
local city_add_num_4_path = "BuildInfo/buildDes/layout4/cityAddNum4"
local layout5_path = "BuildInfo/buildDes/layout5"
local city_add_des5_path = "BuildInfo/buildDes/layout5/cityAddDes5"
local city_add_num5_path = "BuildInfo/buildDes/layout5/cityAddNum5"
local layout6_path = "BuildInfo/buildDes/layout6"
local city_add_des6_path = "BuildInfo/buildDes/layout6/cityAddDes6"
local city_add_num6_path = "BuildInfo/buildDes/layout6/cityAddNum6"
local layout7_path = "BuildInfo/buildDes/layout7"
local city_add_des7_path = "BuildInfo/buildDes/layout7/cityAddDes7"
local city_add_num7_path = "BuildInfo/buildDes/layout7/cityAddNum7"
local city_add_num_des_btn7_path = "BuildInfo/buildDes/layout7/cityAddNumDesBtn7"
local layout8_path = "BuildInfo/buildDes/layout8"
local city_add_des8_path = "BuildInfo/buildDes/layout8/cityAddDes8"
local city_add_num8_path = "BuildInfo/buildDes/layout8/cityAddNum8"
local city_add_num_des_btn8_path = "BuildInfo/buildDes/layout8/cityAddNumDesBtn8"
local time_obj_path = "BuildInfo/timelayout"
local time_label_path = "BuildInfo/timelayout/timeLabel"
local time_info_btn_path = "BuildInfo/timelayout/timeLabel/timeInfoBtn"
local first_occupy_obj_path = "BuildInfo/firstOccupy"
local first_occupy_detail_btn_path = "BuildInfo/firstOccupy/Image"
local first_occupy_name_path = "BuildInfo/firstOccupy/allianceName"
local first_occupy_data_path = "BuildInfo/firstOccupy/allianceData"
local tips_obj_path = "BuildInfo/tipslayout"
local tips_txt_path = "BuildInfo/tipslayout/tipsLabel"
local declareWarList_rect_path = "BuildInfo/Rect_DeclareWarList"
local declareWarList_btn_path = "BuildInfo/Rect_DeclareWarList/Btn_DeclareWarList"
local warList_txt_path = "BuildInfo/Rect_DeclareWarList/Btn_DeclareWarList/Txt_WarList"
local hp_bar_root = "BuildInfo/buildHp"
local hp_bar_path = "BuildInfo/buildHp/HPBar"
local hp_bar_text_path = "BuildInfo/buildHp/HPLabel"
local shield_bar_path = "BuildInfo/buildHp/ShieldBar"
local shield_bar_text_path = "BuildInfo/buildHp/ShieldLabel"
local head_path = "BuildInfo/buildHp/Head"
local shield_icon_path = "BuildInfo/buildHp/ShieldIcon"
local alliance_score_path = "BuildInfo/allianceScore"
local alliance_score_title_path = "BuildInfo/allianceScore/Top/allianceScoreTitle"
local alliance_score_info_btn_path = "BuildInfo/allianceScore/Top/allianceScoreDetailBtn"
local alliance_score_close_btn_path = "BuildInfo/allianceScore/Top/allianceScoreCloseBtn"
local detail_title_path = "BuildDetails/ScrollView/Viewport/Content/detailTitle/detailDesTitle"
local des_txt_path = "BuildDetails/ScrollView/Viewport/Content/detailTitle/desTxt"
local atk_obj_path = "BuildDetails/ScrollView/Viewport/Content/atkObj"
local atk_name_des_path = "BuildDetails/ScrollView/Viewport/Content/atkObj/Image/atkNameTxt"
local atk_num_des_path = "BuildDetails/ScrollView/Viewport/Content/atkObj/Image/atkNumTxt"
local atk_content_path = "BuildDetails/ScrollView/Viewport/Content/atkObj/atkContent"
local kill_reward_title_path = "BuildDetails/ScrollView/Viewport/Content/killRewardTitle"
local kill_reward_title_txt_path = "BuildDetails/ScrollView/Viewport/Content/killRewardTitle/killDesTxt"
local kill_reward_content_path = "BuildDetails/ScrollView/Viewport/Content/killRewardContent"
local occupy_reward_title_path = "BuildDetails/ScrollView/Viewport/Content/occupyRewardTitle"
local occupy_reward_title_txt_path = "BuildDetails/ScrollView/Viewport/Content/occupyRewardTitle/occupyDesTxt"
local occupy_reward_content_path = "BuildDetails/ScrollView/Viewport/Content/occupyRewardContent"
local occupy_history_path = "OccupyHistory"
local occupy_history_btn_path = "OccupyHistory/BtnMore"
local king_throne_path = "BuildInfo/kingThrone"
local btn_detail_path = "BuildInfo/kingThrone/btnDetail"
local slider1_path = "BuildInfo/kingThrone/Slider1"
local slider_value1_path = "BuildInfo/kingThrone/Slider1/SliderValue1"
local server_value1_path = "BuildInfo/kingThrone/Slider1/ServerValue1"
local slider2_path = "BuildInfo/kingThrone/Slider2"
local slider_value2_path = "BuildInfo/kingThrone/Slider2/SliderValue2"
local server_value2_path = "BuildInfo/kingThrone/Slider2/ServerValue2"
local fill1_path = "BuildInfo/kingThrone/Slider1/Fill Area/Fill1"
local fill2_path = "BuildInfo/kingThrone/Slider2/Fill Area/Fill2"
local icon_camp_a_path = "BuildInfo/kingThrone/IconCampA"
local icon_camp_b_path = "BuildInfo/kingThrone/IconCampB"
local loot_info_path = "BuildInfo/lootInfo"
local season_loot_root_path = "BuildInfo/lootInfo/season_reward_root"
local season_loot_path = "BuildInfo/lootInfo/season_reward_root/season_reward"
local season_loot_icon_path = "BuildInfo/lootInfo/season_reward_root/icon/season_reward_icon"
local season_loot_count_path = "BuildInfo/lootInfo/season_reward_root/season_reward_count"
local viral_path = "BuildInfo/viral"
local viral_btn_path = "BuildInfo/viral/viral_btn"
local viral_txt_path = "BuildInfo/viral/viral_txt"
local viral_img_path = "BuildInfo/viral/viral_btn/viral_img"
local viral_img_ok_path = "BuildInfo/viral/viral_btn/viral_img_ok"
local viral_bg_path = "BuildInfo/viral/viral_bg"
local work_nuclear_path = "BuildInfo/workNuclear"
local work_icon_nuclear_path = "BuildInfo/workNuclear/work_icon_nuclear"
local status1_nuclear_path = "BuildInfo/workNuclear/status1Nuclear"
local status2_nuclear_path = "BuildInfo/workNuclear/status2Nuclear"
local status0_nuclear_path = "BuildInfo/workNuclear/status0Nuclear"
local nuclear_btn_path = "BuildInfo/workNuclear/status0Nuclear/NuclearBtn"
local city_force_path = "BuildInfo/cityForce"
local city_force_detail_btn_path = "BuildInfo/cityForce/bg/forceDetailBtn"
local city_force_btn_path = "BuildInfo/cityForce/bg/cityForceBtn"
local city_force_icon_path = "BuildInfo/cityForce/cityForceIcon"
local city_force_value_path = "BuildInfo/cityForce/cityForceValue"
local stronghold_add_path = "BuildInfo/strongholdAdd"
local stronghold_add_btn_path = "BuildInfo/strongholdAdd/bg/strongholdAddBtn"
local stronghold_add_icon_path = "BuildInfo/strongholdAdd/strongholdAddIcon"
local stronghold_add_value_path = "BuildInfo/strongholdAdd/strongholdAddValue"
local soldierlayout_path = "BuildInfo/buildDes/soldierlayout"
local dynamic_root_1_path = "BuildInfo/DynamicRoot_1"
local dynamic_root_2_path = "BuildInfo/DynamicRoot_2"
local build_des_fold_path = "BuildInfo/buildDesFold"
local build_des_fold_btn_path = "BuildInfo/buildDesFold/layout6/buildDesFoldBtn"
local fold_state_icon_path = "BuildInfo/buildDesFold/layout6/buildDesFoldBtn/foldStateIcon"
local attack_build_des_title_path = "BuildInfo/attackBuildDesTitle"
local attack_build_des_title_btn_path = "BuildInfo/attackBuildDesTitle/Image/attackBuildDesTitleBtn"
local attack_build_des_detail_btn_path = "BuildInfo/attackBuildDesTitle/Image/attackBuildDesDetailBtn"
local layout_dynamic_root_path = "DynamicRoot"
local layout_dynamic2_root_path = "DynamicRoot2"
local animator_path = ""
local build_reset_hp_path = "BuildInfo/buildResetHp"
local reset_shield_bar_path = "BuildInfo/buildResetHp/ResetShieldBar"
local reset_shield_label_path = "BuildInfo/buildResetHp/ResetShieldLabel"

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
  base.OnDisable(self)
end

function UIWorldSiegePointSeasonInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:AddUIListener(EventId.ActNuclearScoreUpdate, self.ActNuclearScoreUpdateCall)
  self:AddUIListener(EventId.UIAsyncLoadDynamicPrefabFinish, self.OnAsyncLoadFinish)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function UIWorldSiegePointSeasonInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:RemoveUIListener(EventId.ActNuclearScoreUpdate, self.ActNuclearScoreUpdateCall)
  self:RemoveUIListener(EventId.UIAsyncLoadDynamicPrefabFinish, self.OnAsyncLoadFinish)
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

function UIWorldSiegePointSeasonInfo:OnAsyncLoadFinish()
  if ComponentIsValid(self.dynamicRoot) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.dynamicRoot.rectTransform)
  end
  if ComponentIsValid(self.main_obj) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.main_obj.rectTransform)
  end
  if ComponentIsValid(self) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  end
  if self.view and self.view.AutoFitUI then
    pcall(self.view.AutoFitUI, self.view, 0.1)
  end
end

local function ComponentDefine(self)
  self.layoutRoot = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "")
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.build_des = self:AddComponent(UIBaseContainer, build_des_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.btn_alliance = self:AddComponent(UIButton, btn_alliance_path)
  self.btn_alliance:SetOnClick(function()
    self:SwitchAllianceScore(true)
  end)
  self.time_obj = self:AddComponent(UIBaseContainer, time_obj_path)
  self.time_txt = self:AddComponent(UIText, time_label_path)
  self.time_info_btn = self:AddComponent(UIButton, time_info_btn_path)
  self.time_info_btn:SetOnClick(function()
    RailwayUtil.OnClickTradeStationBattleDetailBtn(self.data.pointId)
  end)
  self.city_soldier_des = self:AddComponent(UIText, city_soldier_des_path)
  self.city_soldier_des:SetLocalText(300696)
  self.city_add_des = self:AddComponent(UIText, city_add_des_path)
  self.layout2_obj = self:AddComponent(UIBaseContainer, layout2_obj_path)
  self.city_add_des_2 = self:AddComponent(UIText, city_add_des_2_path)
  self.city_add_des_2:SetLocalText(300698)
  self.layout3_obj = self:AddComponent(UIBaseContainer, layout3_obj_path)
  self.city_add_des_3 = self:AddComponent(UIText, city_add_des_3_path)
  self.city_add_des_3:SetLocalText(302014)
  self.layout4_obj = self:AddComponent(UIBaseContainer, layout4_obj_path)
  self.city_add_des_4 = self:AddComponent(UIText, city_add_des_4_path)
  self.city_add_des_4:SetText(Localization:GetString("390963") .. ": ")
  self.city_add_num_4 = self:AddComponent(UIText, city_add_num_4_path)
  self.layout5 = self:AddComponent(UIBaseContainer, layout5_path)
  self.city_add_des5 = self:AddComponent(UIText, city_add_des5_path)
  self.city_add_num5 = self:AddComponent(UIText, city_add_num5_path)
  self.layout6 = self:AddComponent(UIBaseContainer, layout6_path)
  self.city_add_des6 = self:AddComponent(UIText, city_add_des6_path)
  self.city_add_num6 = self:AddComponent(UIText, city_add_num6_path)
  self.layout5:SetActive(false)
  self.layout6:SetActive(false)
  self.city_add_num_des = self:AddComponent(UIText, city_add_num_des_path)
  self.city_add_num = self:AddComponent(UIText, city_add_num_path)
  self.common_btn_detail_1 = self:AddComponent(UIButton, common_btn_detail_1_path)
  self.city_add_num_des_1_btn = self:AddComponent(UIButton, city_add_num_des_1_btn_path)
  self.city_add_num_des_1_btn:SetOnClick(function()
    self:OnCityValueClick()
  end)
  self.common_btn_detail_1:SetOnClick(function()
    self:OnCityValueClick()
  end)
  self.city_add_num_des_2 = self:AddComponent(UIText, city_add_num_des_2_path)
  self.city_add_num_2 = self:AddComponent(UIText, city_add_num_2_path)
  self.city_add_num_3 = self:AddComponent(UIText, city_add_num_3_path)
  self.city_add_num_des_btn = self:AddComponent(UIButton, city_add_num_des_btn_path)
  self.city_add_num_des_btn:SetOnClick(function()
    self:OnDesClick()
  end)
  self.city_alliance_name = self:AddComponent(UIText, city_alliance_name_path)
  self.first_occupy_obj = self:AddComponent(UIBaseContainer, first_occupy_obj_path)
  self.first_occupy_name = self:AddComponent(UIText, first_occupy_name_path)
  self.first_occupy_data = self:AddComponent(UIText, first_occupy_data_path)
  self.first_occupy_detail_btn = self:AddComponent(UIButton, first_occupy_detail_btn_path)
  self.first_occupy_detail_btn:SetOnClick(function()
    local firstOccupyInfo
    if self.serverData then
      if LuaEntry.Player:AtHomeNow() then
        firstOccupyInfo = self.serverData.firstOccupyInfo
      else
        firstOccupyInfo = self.serverData.firstCrossOccupyInfo
      end
    end
    if firstOccupyInfo then
      local name = firstOccupyInfo.alName
      local aid = firstOccupyInfo.aid
      if name and aid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, name, aid, firstOccupyInfo.serverId)
      end
    end
  end)
  self.tips_obj = self:AddComponent(UIBaseContainer, tips_obj_path)
  self.tips_txt = self:AddComponent(UIText, tips_txt_path)
  self.declareWarList_rect = self:AddComponent(UIBaseComponent, declareWarList_rect_path)
  self.declareWarList_btn = self:AddComponent(UIButton, declareWarList_btn_path)
  self.warList_txt = self:AddComponent(UIText, warList_txt_path)
  self.warList_txt:SetLocalText(143549)
  self.declareWarList_btn:SetOnClick(function()
    self:OnClickDeclareWarList()
  end)
  self.des_obj_canvas = self:AddComponent(UICanvasGroup, des_obj_path)
  self.des_obj = self:AddComponent(UIBaseContainer, des_obj_path)
  self.atk_content = self:AddComponent(UIBaseContainer, atk_content_path)
  self.atk_obj = self:AddComponent(UIBaseContainer, atk_obj_path)
  self.atk_obj:SetActive(false)
  self.des_obj_canvas:SetAlpha(0)
  self.des_obj:SetActive(false)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(300706)
  self.detail_title = self:AddComponent(UIText, detail_title_path)
  self.detail_title:SetLocalText(300705)
  self.atk_name_des = self:AddComponent(UIText, atk_name_des_path)
  self.atk_name_des:SetLocalText(300717)
  self.atk_num_des = self:AddComponent(UIText, atk_num_des_path)
  self.atk_num_des:SetLocalText(300718)
  self.kill_reward_title_obj = self:AddComponent(UIBaseContainer, kill_reward_title_path)
  self.kill_reward_title_txt = self:AddComponent(UIText, kill_reward_title_txt_path)
  self.kill_reward_title_txt:SetLocalText(300729)
  self.kill_reward_content = self:AddComponent(UIBaseContainer, kill_reward_content_path)
  self.occupy_reward_title_obj = self:AddComponent(UIBaseContainer, occupy_reward_title_path)
  self.occupy_reward_title_txt = self:AddComponent(UIText, occupy_reward_title_txt_path)
  self.occupy_reward_title_txt:SetLocalText(300730)
  self.occupy_reward_content = self:AddComponent(UIBaseContainer, occupy_reward_content_path)
  self.occupy_history = self:AddComponent(UIWorldOccupyHistoryItem, occupy_history_path)
  self.occupy_history_btn = self:AddComponent(UIButton, occupy_history_btn_path)
  self.occupy_history_btn:SetOnClick(function()
    self:OnClickOccupyHistory()
  end)
  self.hpBarRoot = self:AddComponent(UIBaseContainer, hp_bar_root)
  self.hpBar = self:AddComponent(UISlider, hp_bar_path)
  self.hpBarText = self:AddComponent(UIText, hp_bar_text_path)
  self.shieldBar = self:AddComponent(UISlider, shield_bar_path)
  self.shieldBarText = self:AddComponent(UIText, shield_bar_text_path)
  self.hpBarHead = self:AddComponent(UIImage, head_path)
  self.hpBarShieldIcon = self:AddComponent(UIImage, shield_icon_path)
  self.allianceScoreContent = self:AddComponent(UIBaseContainer, alliance_score_path)
  self.allianceScoreTitle = self:AddComponent(UIText, alliance_score_title_path)
  self.allianceScoreInfoBtn = self:AddComponent(UIButton, alliance_score_info_btn_path)
  self.allianceScoreCloseBtn = self:AddComponent(UIButton, alliance_score_close_btn_path)
  self.allianceScoreTitle:SetLocalText("season_city_battle_tips004")
  self.allianceScoreInfoBtn:SetOnClick(function()
    self:OnAllianceScoreRankDesClick()
  end)
  self.allianceScoreCloseBtn:SetOnClick(function()
    self:SwitchAllianceScore(false)
  end)
  self.king_throne_root = self:AddComponent(UIImage, king_throne_path)
  self.king_throne_root:SetActive(false)
  self.king_throne_detail = self:AddComponent(UIButton, btn_detail_path)
  self.slider1 = self:AddComponent(UISlider, slider1_path)
  self.slider_value1 = self:AddComponent(UIText, slider_value1_path)
  self.server_value1 = self:AddComponent(UIText, server_value1_path)
  self.slider2 = self:AddComponent(UISlider, slider2_path)
  self.slider_value2 = self:AddComponent(UIText, slider_value2_path)
  self.server_value2 = self:AddComponent(UIText, server_value2_path)
  self.fill1 = self:AddComponent(UIImage, fill1_path)
  self.fill2 = self:AddComponent(UIImage, fill2_path)
  self.king_throne_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIUtil.DestroyWorldSiegePoint()
    UIManager:GetInstance():OpenWindow(UIWindowNames.CrossOccupyRankDetail, {anim = true}, self.data and self.data.serverId)
  end)
  self.king_throne_detail:SetActive(true)
  self.icon_camp_a = self:AddComponent(UIImage, icon_camp_a_path)
  self.icon_camp_b = self:AddComponent(UIImage, icon_camp_b_path)
  self.loot_info = self:AddComponent(UIBaseContainer, loot_info_path)
  self.season_loot_root = self:AddComponent(UIBaseContainer, season_loot_root_path)
  self.season_loot_desc = self:AddComponent(UIText, season_loot_path)
  self.season_loot_icon = self:AddComponent(UIButton, season_loot_icon_path)
  self.season_loot_count = self:AddComponent(UIText, season_loot_count_path)
  self.season_loot_icon:SetOnClick(function()
    self:OnRewardShowClick()
  end)
  self.loot_info:SetActive(true)
  self.viral = self:AddComponent(UIBaseContainer, viral_path)
  self.viral_btn = self:AddComponent(UIButton, viral_btn_path)
  self.viral_txt = self:AddComponent(UIText, viral_txt_path)
  self.viral_img = self:AddComponent(UIImage, viral_img_path)
  self.viral_img_ok = self:AddComponent(UIImage, viral_img_ok_path)
  self.viral_bg = self:AddComponent(UIImage, viral_bg_path)
  self.viral_btn:SetOnClick(function()
    if self.data.selfPercent >= 0 then
      UIUtil.ShowTipsId("season_tiles_popui_info007")
      return
    end
    UIUtil.ShowResistanceDetail(self.data.selfPercent, self.data.otherPercent)
  end)
  self.viral:SetActive(false)
  self.layout7 = self:AddComponent(UIBaseContainer, layout7_path)
  self.city_add_des7 = self:AddComponent(UITextMeshProUGUIEx, city_add_des7_path)
  self.city_add_num7 = self:AddComponent(UITextMeshProUGUIEx, city_add_num7_path)
  self.city_add_num_des_btn7 = self:AddComponent(UIButton, city_add_num_des_btn7_path)
  self.layout7:SetActive(false)
  self.city_add_num_des_btn7:SetOnClick(function()
    self:OnLayout7DesClick()
  end)
  self.layout8 = self:AddComponent(UIBaseContainer, layout8_path)
  self.city_add_des8 = self:AddComponent(UITextMeshProUGUIEx, city_add_des8_path)
  self.city_add_num8 = self:AddComponent(UITextMeshProUGUIEx, city_add_num8_path)
  self.city_add_num_des_btn8 = self:AddComponent(UIButton, city_add_num_des_btn8_path)
  self.layout8:SetActive(false)
  self.city_add_num_des_btn8:SetOnClick(function()
    self:OnLayout8DesClick()
  end)
  self.work_nuclear = self:AddComponent(UIBaseContainer, work_nuclear_path)
  self.work_icon_nuclear = self:AddComponent(UIImage, work_icon_nuclear_path)
  self.status1_nuclear = self:AddComponent(UITextMeshProUGUIEx, status1_nuclear_path)
  self.status2_nuclear = self:AddComponent(UITextMeshProUGUIEx, status2_nuclear_path)
  self.status0_nuclear = self:AddComponent(UITextMeshProUGUIEx, status0_nuclear_path)
  self.nuclear_btn = self:AddComponent(UIButton, nuclear_btn_path)
  self.nuclear_btn:SetOnClick(function()
    if LuaEntry.Player:AtHomeNow() then
      SeasonUtil.OpenSeasonActivityByType(EnumActivity.SeasonNuclearPowerPlantActivity.Type)
    end
  end)
  self.work_nuclear:SetActive(false)
  self.status0_nuclear:SetActive(true)
  self.status1_nuclear:SetActive(false)
  self.status2_nuclear:SetActive(false)
  self.city_force = self:AddComponent(UIBaseContainer, city_force_path)
  self.city_force_btn = self:AddComponent(UIButton, city_force_btn_path)
  self.city_force_detail_btn = self:AddComponent(UIButton, city_force_detail_btn_path)
  self.city_force_icon = self:AddComponent(UIImage, city_force_icon_path)
  self.city_force_value = self:AddComponent(UITextMeshProUGUIEx, city_force_value_path)
  self.city_force_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    if self.data then
      param.desc = self.data.forceTipKey or "season_s1_add_city_info01"
    else
      param.desc = "season_s1_add_city_info01"
    end
    param.alignObject = self.city_force_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.city_force_detail_btn:SetOnClick(function()
    if self.data and self.data.forceTipUI then
      UIManager:GetInstance():OpenWindow(self.data.forceTipUI)
    end
  end)
  self.stronghold_add = self:AddComponent(UIBaseContainer, stronghold_add_path)
  self.stronghold_add_btn = self:AddComponent(UIButton, stronghold_add_btn_path)
  self.stronghold_add_icon = self:AddComponent(UIImage, stronghold_add_icon_path)
  self.stronghold_add_value = self:AddComponent(UITextMeshProUGUIEx, stronghold_add_value_path)
  self.stronghold_add_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_s1_add_city_info02"
    param.alignObject = self.stronghold_add_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.soldierlayout = self:AddComponent(UIBaseContainer, soldierlayout_path)
  self.dynamic_root_1 = self:AddComponent(UIImage, dynamic_root_1_path)
  self.dynamic_root_2 = self:AddComponent(UIImage, dynamic_root_2_path)
  self.build_des_fold = self:AddComponent(UIBaseContainer, build_des_fold_path)
  self.build_des_fold_btn = self:AddComponent(UIButton, build_des_fold_btn_path)
  self.fold_state_icon = self:AddComponent(UIImage, fold_state_icon_path)
  self.attack_build_des_title = self:AddComponent(UIBaseContainer, attack_build_des_title_path)
  self.attack_build_des_title:SetActive(false)
  self.attack_build_des_title_btn = self:AddComponent(UIButton, attack_build_des_title_btn_path)
  self.attack_build_des_title_btn:SetOnClick(function()
    self:SwitchAllianceScore(true)
  end)
  self.attack_build_des_detail_btn = self:AddComponent(UIButton, attack_build_des_detail_btn_path)
  self.attack_build_des_detail_btn:SetOnClick(function()
    self:OnAllianceScoreRankDesTitle2Click()
  end)
  self.buildDesFolderOpen = true
  self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
  self.build_des_fold_btn:SetSafeClickMode(true)
  self.build_des_fold_btn:SetOnClick(function()
    self:BuildDesFolderClick()
  end)
  self.build_des_fold:SetActive(false)
  self.tranLayoutDynamicRoot = self.transform:Find(layout_dynamic_root_path)
  self.tranLayoutDynamicRoot2 = self.transform:Find(layout_dynamic2_root_path)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(dynamic_root_2_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
    self.dCompAssistance2 = UIAsyncLoaderBridge.New(self, "dCompAssistance2", self.tranLayoutDynamicRoot2, UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
  end
  self.build_reset_hp = self:AddComponent(UIBaseContainer, build_reset_hp_path)
  self.reset_shield_bar = self:AddComponent(UISlider, reset_shield_bar_path)
  self.reset_shield_label = self:AddComponent(UITextMeshProUGUIEx, reset_shield_label_path)
  self.build_reset_hp:SetActive(false)
  self.dynamicCampDestroy = UIAsyncLoaderBridge.New(self, "dynamicCampDestroy", self.dynamicRoot or self.transform:Find(dynamic_root_path), prefabPath_campDestroy, luaPath_campDestroy, false)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
  self.work_nuclear = nil
  self.work_icon_nuclear = nil
  self.status1_nuclear = nil
  self.status2_nuclear = nil
  self.status0_nuclear = nil
  self.nuclear_btn = nil
  self.city_force = nil
  self.city_force_detail_btn = nil
  self.city_force_btn = nil
  self.city_force_icon = nil
  self.city_force_value = nil
  self.stronghold_add = nil
  self.stronghold_add_btn = nil
  self.stronghold_add_icon = nil
  self.stronghold_add_value = nil
  self.soldierlayout = nil
  self.dynamic_root_1 = nil
  self.dynamic_root_2 = nil
  self.build_des_fold = nil
  self.build_des_fold_btn = nil
  self.fold_state_icon = nil
  self.time_info_btn = nil
  if self.dCompAssistance2 then
    self.dCompAssistance2:Delete()
    self.dCompAssistance2 = nil
  end
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
  self.build_reset_hp = nil
  self.reset_shield_bar = nil
  self.reset_shield_label = nil
  self.dCompAssistance = nil
  self.attack_build_des_title = nil
  self.attack_build_des_title_btn = nil
  self.attack_build_des_detail_btn = nil
  if self.dynamicCampDestroy then
    self.dynamicCampDestroy:Delete()
    self.dynamicCampDestroy = nil
  end
end

local function DataDefine(self)
  self.data = nil
  self.showTimeState = AllianceCityShowTimeState.None
  self.endTime = 0
  self.timeStr = ""
end

local function DataDestroy(self)
  self.data = nil
  if CS.SceneManager.World then
    CS.SceneManager.World:SetFocusPoint(-1)
  end
end

function UIWorldSiegePointSeasonInfo:OnRewardShowClick()
  if ComponentIsValid(self.season_loot_icon) then
    UIUtil.ShowLootRewardList(self.season_loot_icon:GetPosition())
  end
end

local function SetKillRewardDestroy(self)
  self.kill_reward_content:RemoveComponents(UIWorldSiegeRewardCell)
  if self.killModel ~= nil then
    for k, v in pairs(self.killModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.killModel = {}
end

local function SetOccupyRewardDestroy(self)
  self.occupy_reward_content:RemoveComponents(UIWorldSiegeRewardCell)
  if self.occupyModel ~= nil then
    for k, v in pairs(self.occupyModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.occupyModel = {}
end

function UIWorldSiegePointSeasonInfo:UpdateThroneOccupy()
  local buildPointInfo = self.data.CrossKingBuildPointInfo
  if not buildPointInfo or #buildPointInfo == 0 or self.data.buildStartTime == nil or self.data.buildStartTime == 0 then
    self.throneKingOccupyPoint = nil
    self.king_throne_root:SetActive(false)
    return
  end
  local isBattleMember = SeasonUtil.IsBattleMember(self.data.serverId)
  if not isBattleMember and (buildPointInfo == nil or #buildPointInfo < 2) then
    self.throneKingOccupyPoint = nil
    self.king_throne_root:SetActive(false)
    return
  end
  local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.data.serverId)
  local addPoint = SeasonUtil.GetWorldBattlePointSpeed(self.data.serverId)
  local ownerServerId = self.data.ownerServerId
  local ownerAllianceId = self.data.allianceId
  local ownerAbbr = self.data.alAbbr
  local enemyServer, enemyAllianceId, enemyAbbr = SeasonUtil.GetMyEnemyServerNow(ownerServerId, ownerAllianceId)
  for _, v in ipairs(buildPointInfo) do
    if not SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
      enemyServer = v.serverId
      enemyAllianceId = v.allianceId
      enemyAbbr = v.allianceAbbr
      break
    end
  end
  local ownerPoint = {
    buildPoint = 0,
    serverId = ownerServerId,
    buildSpeed = addPoint,
    campId = 0,
    allianceId = ownerAllianceId,
    allianceAbbr = ownerAbbr
  }
  local targetPoint = {
    buildPoint = 0,
    serverId = enemyServer,
    buildSpeed = addPoint,
    campId = 0,
    allianceId = enemyAllianceId,
    allianceAbbr = enemyAbbr
  }
  for _, v in ipairs(buildPointInfo) do
    if SeasonUtil.IsAlly(ownerServerId, v.serverId, ownerAllianceId, v.allianceId) then
      if v.buildPoint >= ownerPoint.buildPoint then
        ownerPoint = v
      end
    elseif SeasonUtil.IsAlly(enemyServer, v.serverId, enemyAllianceId, v.allianceId) and v.buildPoint >= targetPoint.buildPoint then
      targetPoint = v
    end
  end
  local myRate = ownerPoint.buildPoint / totalPoint
  local targetRate = targetPoint.buildPoint / totalPoint
  self.slider1:SetValue(myRate * 100)
  self.slider_value1:SetText(math.floor(myRate * 10000) * 0.01 .. "%")
  self.slider2:SetValue(targetRate * 100)
  self.slider_value2:SetText(math.floor(targetRate * 10000) * 0.01 .. "%")
  self.throneKingOccupyPoint = ownerPoint.buildPoint
  self.throneKingOccupyPointAdd = ownerPoint.buildSpeed
  local campIconA, campIconB
  if SeasonUtil.SeasonHasFactionWar(self.data.seasonType) then
    campIconA = DataCenter.ZoneWarManager:GetCampIcon(ownerPoint.serverId, ownerPoint.campId)
    campIconB = DataCenter.ZoneWarManager:GetCampIcon(targetPoint.serverId, targetPoint.campId)
  end
  if campIconA or campIconB then
    if campIconA then
      self.icon_camp_a:LoadSprite(campIconA or "")
      self.icon_camp_a:SetNativeSize()
      self.icon_camp_a:SetActive(true)
    else
      self.icon_camp_a:SetActive(false)
    end
    if campIconB then
      self.icon_camp_b:LoadSprite(campIconB or "")
      self.icon_camp_b:SetNativeSize()
      self.icon_camp_b:SetActive(true)
    else
      self.icon_camp_b:SetActive(false)
    end
    self.server_value1:SetActive(false)
    self.server_value2:SetActive(false)
    if self.data.seasonType == SeasonMapType.NineNationRainforest then
      self.icon_camp_a:SetLocalScaleXYZ(0.38, 0.38, 0.38)
      self.icon_camp_b:SetLocalScaleXYZ(0.38, 0.38, 0.38)
    else
      self.icon_camp_a:SetLocalScaleXYZ(0.25, 0.25, 0.25)
      self.icon_camp_b:SetLocalScaleXYZ(0.25, 0.25, 0.25)
    end
  else
    self.server_value1:SetActive(true)
    self.server_value2:SetActive(true)
    self.icon_camp_a:SetActive(false)
    self.icon_camp_b:SetActive(false)
  end
  local AIsEnemy = false
  local BIsEnemy = true
  if isBattleMember then
    AIsEnemy = not SeasonUtil.IsAlly(ownerPoint.serverId, nil, ownerPoint.allianceId)
    BIsEnemy = not SeasonUtil.IsAlly(targetPoint.serverId, nil, targetPoint.allianceId)
  end
  local colorA, colorA32 = SeasonUtil.GetWorldBattleColor(AIsEnemy)
  local colorB, colorB32 = SeasonUtil.GetWorldBattleColor(BIsEnemy)
  self.fill1:SetColor(colorA)
  self.fill2:SetColor(colorB)
  self.server_value1:SetText(SeasonUtil.GetWorldBattleName(ownerPoint, true, AIsEnemy, self.data and self.data.serverId))
  self.server_value2:SetText(SeasonUtil.GetWorldBattleName(targetPoint, true, BIsEnemy, self.data and self.data.serverId))
  self.king_throne_root:SetActive(true)
  self:Update1000MS()
end

function UIWorldSiegePointSeasonInfo:Update1000MS()
  if self.throneKingOccupyPoint ~= nil and self.data.isCrossServerThrone then
    local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(self.data.serverId)
    local addPoint = self.throneKingOccupyPointAdd or SeasonUtil.GetWorldBattlePointSpeed(self.data.serverId)
    local Seconds = UITimeManager:GetInstance():GetServerSeconds() - self.data.buildStartTime
    local pointNow = self.throneKingOccupyPoint + addPoint * Seconds
    local rate = math.min(pointNow / totalPoint, 1.0)
    self.slider1:SetValue(rate * 100)
    self.slider_value1:SetText(math.floor(rate * 10000) * 0.01 .. "%")
  end
  self:UpdateTime()
end

function UIWorldSiegePointSeasonInfo:ShowKingOccupyProgress()
  if self.data and self.data.isCrossServerThrone then
    local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(self.data.serverId)
    if currentData then
      local serverBuildPoint = currentData.serverBuildPoint
      if serverBuildPoint then
        self.data.CrossKingBuildPointInfo = serverBuildPoint
        self.data.buildStartTime = currentData.serverBuildStartTime
        self:UpdateThroneOccupy()
      end
    end
    return
  end
end

function UIWorldSiegePointSeasonInfo:ActNuclearScoreUpdateCall()
  self:RefreshNuclearScore(false)
end

local function InitData(self, param)
  self.data = param
  self.hideRewardShow = not self:CanShowReward(self.data.serverId, self.data.type)
  self.layoutRoot:SetPaddingTop(5)
  self.tranLayoutDynamicRoot.gameObject:SetActive(false)
  if self.data.type == WorldAllianceCityType.MissileFactory then
    self.des_txt:SetLocalText(801474)
    self.main_obj:SetActive(false)
    self.king_throne_root:SetActive(false)
    self.tranLayoutDynamicRoot.gameObject:SetActive(true)
    if self.MissileFactoryRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeMissileFactorySeason"
      local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/ThroneMissileFactory.prefab"
      self.MissileFactoryRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.tranLayoutDynamicRoot)
    end
    self.MissileFactoryRoot:InitData(param)
    self.layoutRoot:SetPaddingTop(45)
    return
  elseif self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    self.des_txt:SetLocalText(801474)
    self.main_obj:SetActive(false)
    self.king_throne_root:SetActive(false)
    self.tranLayoutDynamicRoot.gameObject:SetActive(true)
    if self.BatteryRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeBattery"
      local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/ThroneCityBattery.prefab"
      self.BatteryRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.tranLayoutDynamicRoot)
    end
    self.BatteryRoot:InitData(param)
    self.occupy_history:SetActive(false)
    return
  else
    if self.data.type == WorldAllianceCityType.City and DataCenter.AllianceBaseDataManager:IsR4orR5() then
      DataCenter.AllianceDeclareWarManager:SetWarCityParam(nil)
      SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), self.data.cityId)
    end
    if self.dynamicRoot == nil then
      self.dynamicRoot = self:AddComponent(UIBaseContainer, dynamic_root_path)
    end
    if self.data.isKingCity and self.data.isCrossServerThrone then
      self.des_txt:SetLocalText("season_ui_desc048")
    elseif param and param.meta and param.meta.desc then
      self.des_txt:SetLocalText(param.meta.desc)
    else
      self.des_txt:SetLocalText(300706)
    end
    if self.dynamicRoot and self.dynamicRoot.transform then
      if self.data.isKingCity then
        local showOfficial = true
        if SeasonUtil.GetSeasonType(false, false, self.data.serverId) == SeasonMapType.NineNation and DataCenter.SeasonDataManager:GetNinePalacesIndex(LuaEntry.Player:GetCurServerId(), ServerEnum.View) == 5 then
          local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.data.serverId)
          local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(GovOfficialType.Center, seasonSubType)
          if #templates <= 0 then
            showOfficial = false
          end
        end
        if showOfficial and self.KingRoot == nil then
          local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.KingInfoRoot"
          local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/Component/KingInfoRoot.prefab"
          self.KingRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
        end
      elseif self.data.type == WorldAllianceCityType.City then
        if DataCenter.SeasonFarmerManager:IsOpen() then
          if self.CityAttachmentRoot == nil then
            local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.CityAttachmentBuildList"
            local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/Component/AttachmentBuildList.prefab"
            self.CityAttachmentRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
          end
          self.CityAttachmentRoot:ReInit(self.data)
        end
      elseif self.data.type == WorldAllianceCityType.Stronghold then
        if self.data.meta:IsBank() and DataCenter.SeasonBankManager:IsCurOpen(true) then
          if self.StrongholdBankRoot == nil then
            local luaPath = "UI.LWSeason5.LWBank.Group.BankPoint"
            local prefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Bank/Group/BankPoint.prefab"
            self.StrongholdBankRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamic_root_1)
          end
          self.StrongholdBankRoot:ReInit(self.data)
        elseif self.data.seasonType == SeasonMapType.NineNationRainforest then
          if self.StrongholdPondRoot == nil then
            local luaPath = "UI.UIFishing.StrongholdPond"
            local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/StrongholdPond.prefab"
            self.StrongholdPondRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamic_root_1)
          end
          self.StrongholdPondRoot:ReInit(self.data)
        end
      elseif self.data.type == WorldAllianceCityType.Altar then
        if self.CityAltarRoot == nil then
          local luaPath = "UI.LWSeason6.UILWSeasonCityAltar.Map.SeasonCityAltarPointComp"
          local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/CityAltar/S6CityAltarPointInfo.prefab"
          self.CityAltarRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamic_root_1)
        end
        if self.CityAltarRoot ~= nil then
          self.CityAltarRoot:ReInit(self.data)
        end
      elseif self.data.type == WorldAllianceCityType.GoldTree then
        if DataCenter.SeasonGoldTreeManager:IsActive() then
          if self.GoldTreeRoot == nil then
            local luaPath = "UI.LWSeason.LWSeasonGoldTree.Component.GoldTreePoint"
            local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/Component/GoldTreePoint.prefab"
            self.GoldTreeRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
          end
          self.GoldTreeRoot:ReInit(self.data)
        end
      elseif self.data.type == WorldAllianceCityType.Mountain then
        if self.SaintMountainRoot == nil then
          local luaPath = "UI.LWSeason4.SaintMountain.SaintMountainPointComponent"
          local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/SaintMountain/SaintMountainPoint.prefab"
          self.SaintMountainRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
        end
        self.SaintMountainRoot:Refresh(self.data)
      end
    end
    self.main_obj:SetActive(true)
    self:UpdateThroneOccupy()
  end
  self.work_nuclear:SetActive(self.data.isKingCity and SeasonUtil.IsInSeasonSnowMode() and LuaEntry.Player:AtHomeNow())
  local nameStr = Localization:GetString("season_city_mori")
  if self.data.state == AllianceCityState.OCCUPIED or self.data.state == AllianceCityState.SERVER_OCCUPIED then
    local ownerServerId = self.data.ownerServerId
    if ownerServerId ~= nil and ownerServerId ~= 0 then
      nameStr = "#" .. ownerServerId .. " [" .. self.data.alAbbr .. "]" .. self.data.alName
    else
      nameStr = "[" .. self.data.alAbbr .. "]" .. self.data.alName
    end
  else
    self.btn_alliance:SetActive(false)
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
  if string.IsNullOrEmpty(self.data.avatar) then
    self.hpBarHead:LoadSprite("Assets/Main/Sprites/UI/UIAttackCity/Mjc_saijijianzhu_juntuanicon_02.png")
  elseif CS.GameEntry.Resource:HasAsset(self.data.avatar) then
    self.hpBarHead:LoadSprite(self.data.avatar)
  end
  local srcServer = self.data.ownerServerId
  local otherServerPlayer = srcServer ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId()
  if self.data.isInAlliance and self.data.allianceId == LuaEntry.Player:GetAllianceUid() then
    self.viral:SetActive(false)
    self.city_alliance_name:SetText("<color=#0091e8>" .. nameStr .. "</color>")
  elseif otherServerPlayer then
    self.city_alliance_name:SetText("<color=#e64141>" .. nameStr .. "</color>")
  else
    self.city_alliance_name:SetText("<color=#2A2830>" .. nameStr .. "</color>")
  end
  self.city_add_num_des:SetLocalText(self.data.buffDes)
  self.city_add_num_des:SetColorHex("#000000")
  self.city_add_num:SetText(" " .. tostring(self.data.buffAddNum or ""))
  self.city_add_num:SetColorHex("#000000")
  if self.data.buffDes2 ~= nil then
    self.layout2_obj:SetActive(true)
    self.city_add_num_des_2:SetLocalText(self.data.buffDes2)
    self.city_add_num_2:SetText(" " .. self.data.buffAddNum2)
  else
    self.layout2_obj:SetActive(false)
  end
  if self.data.dead_rate ~= nil and self.data.dead_rate ~= "" then
    self.layout3_obj:SetActive(true)
    self.city_add_num_3:SetText(self.data.dead_rate)
  else
    self.layout3_obj:SetActive(false)
  end
  if not string.IsNullOrEmpty(self.data.allianceId) then
    self.layout6:SetActive(false)
    self.city_add_des6:SetLocalText("season_tips106")
    self.city_add_num6:SetText("+?%")
  else
    self.layout6:SetActive(false)
  end
  if self.data.isKingCity and self.data.state == AllianceCityState.DESTROY then
    local force_num = toInt(self.data.destroy_force)
    if 0 < force_num then
      local value = string.GetFormattedSeparatorNum(force_num)
      local formatStr = "<color=#E52727>%s</color>"
      self.layout5:SetActive(true)
      self.city_add_des5:SetTextFormat(formatStr, Localization:GetString("season_alliance_loot_has"))
      self.city_add_num5:SetTextFormat(formatStr, value)
      self.city_force:SetActive(true)
      self.city_force_value:SetTextFormat(formatStr, Localization:GetString("season_s1_add_city_desc01", value))
    else
      self.layout5:SetActive(false)
      self.city_force:SetActive(false)
    end
  else
    local force_num = toInt(self.data.force)
    if 0 < force_num and not self:CityDestroyED() then
      local value = string.GetFormattedSeparatorNum(force_num)
      self.layout5:SetActive(true)
      self.city_add_des5:SetLocalText("season_alliance_loot_has")
      self.city_add_num5:SetText(value)
      self.city_force:SetActive(true)
      self.city_force_value:SetLocalText("season_s1_add_city_desc01", value)
    else
      self.layout5:SetActive(false)
      self.city_force:SetActive(false)
    end
  end
  self.city_force_detail_btn:SetActive(self.data ~= nil and self.data.forceTipUI ~= nil)
  if not self.data.isKingCity and self.data.stronghold_max ~= nil and self.data.stronghold_max ~= 0 and not self:CityDestroyED() then
    self.stronghold_add:SetActive(true)
    self.stronghold_add_value:SetText(Localization:GetString("season_s1_add_city_desc02") .. "+" .. self.data.stronghold_max)
  else
    self.stronghold_add:SetActive(false)
  end
  local theServerId = LuaEntry.Player:GetCurServerId()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId, theServerId)
  local speed = cityTemplate:getIntValue("alliance_res_speed")
  self.city_add_num_4:SetText(speed .. "/h")
  self.first_occupy_obj:SetActive(false)
  if self.data.isKingCity or self.data.type == WorldAllianceCityType.Mountain or self.hideRewardShow then
    self:ShowReward(false)
  elseif self.data.state == AllianceCityState.NEUTRAL or self.data.state == AllianceCityState.SERVER_NEUTRAL then
    self:ShowReward(not self.hideRewardShow)
  else
    self:ShowReward(false)
  end
  local showTips = not self.data.isCrossServerThrone and self.data.type ~= WorldAllianceCityType.TradingStation and self.data.type ~= WorldAllianceCityType.GoldTree and self.data.type ~= WorldAllianceCityType.Mountain and self:CityDestroyED()
  self.tips_obj:SetActive(showTips)
  if showTips then
    if self:CityDestroyED() then
      self.tips_txt:SetLocalText("season_s6_activity_1200112_desc15")
      self.tips_txt:SetColor(Color.New(0.9176, 0.2588, 0.2588, 1))
      self.tips_obj:SetActive(true)
    elseif self.data.isInAlliance == true then
      if not self.data.recommend_power or 0 >= self.data.recommend_power then
        self.tips_obj:SetActive(false)
      else
        local tips = Localization:GetString("302070", string.GetFormattedSeparatorNum(self.data.recommend_power))
        self.tips_txt:SetText(tips)
        self.tips_txt:SetColor(Color.New(0.7176471, 0.4, 0.1882353, 1))
        self.tips_obj:SetActive(true)
      end
    else
      self.tips_txt:SetLocalText(300707)
      self.tips_txt:SetColor(Color.New(0.9176, 0.2588, 0.2588, 1))
      self.tips_obj:SetActive(true)
    end
  end
  local warDataList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.cityId)
  if next(warDataList) then
    self.declareWarList_rect:SetActive(false)
  else
    self.declareWarList_rect:SetActive(false)
  end
  if self.data.kill_reward_list and 0 < #self.data.kill_reward_list then
    self.kill_reward_title_obj:SetActive(true)
    self:SetKillRewardDestroy()
    local list = self.data.kill_reward_list
    if list ~= nil then
      do
        local num = 0
        for i = 1, table.length(list) do
          num = num + 1
          self.killModel[i] = self:GameObjectInstantiateAsync(UIAssets.LWWorldSiegeRewardCell, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.kill_reward_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = tostring(NameCount)
            NameCount = NameCount + 1
            local cell = self.kill_reward_content:AddComponent(UIWorldSiegeRewardCell, go.name)
            cell:RefreshData(list[i], i)
          end)
        end
      end
    end
  else
    self.kill_reward_title_obj:SetActive(false)
  end
  if self.data.destroy_reward_list and 0 < #self.data.destroy_reward_list then
    self.occupy_reward_title_obj:SetActive(true)
    self:SetOccupyRewardDestroy()
    local list = self.data.destroy_reward_list
    if list ~= nil then
      do
        local num = 0
        for i = 1, table.length(list) do
          num = num + 1
          self.occupyModel[i] = self:GameObjectInstantiateAsync(UIAssets.LWWorldSiegeRewardCell, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.occupy_reward_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = tostring(NameCount)
            NameCount = NameCount + 1
            local cell = self.occupy_reward_content:AddComponent(UIWorldSiegeRewardCell, go.name)
            cell:RefreshData(list[i], i)
          end)
        end
      end
    end
  else
    self.occupy_reward_title_obj:SetActive(false)
  end
  local serverId = LuaEntry.Player:GetSelfServerId()
  if serverId == nil or serverId == 0 or serverId == -1 or self:CityDestroyED() then
    self.loot_info:SetActive(false)
  elseif LuaEntry.Player:IsInSourceServer() then
    if self.data.loot_rewards == nil or self.data.loot_rewards == 0 then
      self.loot_info:SetActive(false)
    else
      self.loot_info:SetActive(true)
      self.season_loot_desc:SetText(Localization:GetString("season_world_city_reward_box"))
      self.season_loot_count:SetText("x" .. self.data.loot_rewards)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_loot_root.transform)
    end
  elseif self.data.sever_loot_reward == nil or self.data.sever_loot_reward == 0 then
    self.loot_info:SetActive(false)
  else
    self.loot_info:SetActive(true)
    self.season_loot_desc:SetText(Localization:GetString("season_world_city_reward_box"))
    self.season_loot_count:SetText("x" .. self.data.sever_loot_reward)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_loot_root.transform)
  end
  if self.data.isKingCity then
    self.hpBarRoot:SetActive(false)
  elseif self.data.type == 1 then
    local showHp = true
    local serverData = self.view.ctrl:GetAllianceCityDetail(self.data.cityId)
    if serverData and serverData.attackList and 0 < #serverData.attackList then
      showHp = false
    end
    if self.data.state == AllianceCityState.DESTROY then
      showHp = false
    end
    self.hpBarRoot:SetActive(showHp)
    self:RefreshHpBar()
  else
    self.hpBarRoot:SetActive(false)
  end
  self:CheckShowScoreOrBuildDesc()
  self.time_info_btn:SetActive(false)
  self.soldierlayout:SetActive(self.data.type ~= WorldAllianceCityType.TradingStation)
  if self.data.type == WorldAllianceCityType.TradingStation then
    self.time_info_btn:SetActive(self.data and self.data.tradeData and self.data.tradeData:GetTimeState() == AllianceCityShowTimeState.TradeBattle)
    self.city_add_des:SetLocalText("season_s3_trade_city002")
    self.city_add_num_des:SetLocalText(self.data.lordBuffDes)
    self.city_add_num:SetText(" " .. self.data.lordBuffAdd)
    self.layout2_obj:SetActive(true)
    self.city_add_des_2:SetLocalText("season_s3_trade_city024")
    self.city_add_num_des_2:SetLocalText("season_s3_trade_city025", self.data.alliance_discount * 100)
    self.city_add_num_2:SetActive(false)
    self.city_add_des8:SetLocalText("season_s3_trade_city001")
    self.city_add_num8:SetText(tostring(self.data.tax_rate * 100) .. "%")
    self.layout8:SetActive(true)
    if self.TradingStationLordInfoRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.TradingStationLordInfo"
      local prefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/LWUIWorld/TradeLordInfo.prefab"
      self.TradingStationLordInfoRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamic_root_1)
      self.TradingStationLordInfoRoot:SetData(self.data)
    end
    if self.TradeShopInfoRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.TradeShopInfo"
      local prefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/LWUIWorld/TradeShopInfo.prefab"
      self.TradeShopInfoRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
      self.TradeShopInfoRoot:SetData(self.data)
    end
  else
    self.city_add_num_2:SetActive(true)
  end
  if self.data and self.data.pointId then
    CS.SceneManager.World:SetFocusPoint(self.data.pointId)
  end
  self:SetCityBattleS1RestShow()
end

local function CheckShowScoreOrBuildDesc(self)
  local serverData = self.view.ctrl:GetAllianceCityDetail(self.view.ctrl.cityId)
  if serverData and serverData.attackList and #serverData.attackList > 0 then
    self.allianceScoreContent:SetActive(true)
    self.build_des:SetActive(false)
    self:RefreshAllianceScore(serverData)
  else
    self.allianceScoreContent:SetActive(false)
    self.btn_alliance:SetActive(false)
    if self.data.type == WorldAllianceCityType.TradingStation then
      self.build_des_fold:SetActive(true)
      self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
      self.buildDesFolderOpen = false
      self.build_des:SetActive(self.buildDesFolderOpen)
    elseif self.data.type == WorldAllianceCityType.Altar then
      self.build_des:SetActive(false)
    elseif self.data.type == WorldAllianceCityType.City then
      local notWar = true
      local declareList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.cityId)
      if declareList and 0 < table.count(declareList) then
        local endTime = 0
        for k, v in ipairs(declareList) do
          endTime = math.max(self.endTime, (v.et or 0) * 0.001)
        end
        notWar = endTime <= 0
      end
      if notWar then
        self.build_des_fold:SetActive(true)
        self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
        self.buildDesFolderOpen = false
        self.build_des:SetActive(self.buildDesFolderOpen)
      else
        self.build_des:SetActive(true)
      end
    elseif self.data.type == WorldAllianceCityType.Stronghold then
      if self.data.meta:IsBank() and DataCenter.SeasonBankManager:IsCurOpen(true) and self.StrongholdBankRoot and self.StrongholdBankRoot.alreadyLoaded and not self.StrongholdBankRoot:GetActive() then
        self.build_des_fold:SetActive(false)
        self.buildDesFolderOpen = true
      elseif self.data.seasonType == SeasonMapType.NineNation then
        local info = self.serverData
        if not (info and info.assistanceList) or 0 >= #info.assistanceList then
          self.build_des_fold:SetActive(false)
          self.buildDesFolderOpen = true
        else
          self.build_des_fold:SetActive(true)
          self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
          self.buildDesFolderOpen = false
        end
      else
        self.build_des_fold:SetActive(true)
        self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
        self.buildDesFolderOpen = false
      end
      self.build_des:SetActive(self.buildDesFolderOpen)
    elseif self.data.type == WorldAllianceCityType.GoldTree or self.data.type == WorldAllianceCityType.Mountain then
      self.build_des:SetActive(false)
      self.build_des_fold:SetActive(false)
    else
      self.build_des:SetActive(true)
    end
  end
  self:RefreshOccupyHistory(serverData)
  self:RefreshCityValue(serverData)
  self:RefreshSuppliesNum(serverData)
end

local function RefreshAllianceScore(self, serverData)
  local attackList = serverData.attackList
  if self.data.isKingCity then
    self:SetAllianceScoreCellsDestroy()
    self.allianceScoreContent:SetActive(false)
    self.btn_alliance:SetActive(false)
    self.build_des:SetActive(true)
    return
  end
  self:SetAllianceScoreCellsDestroy()
  self.rankModels = {}
  if attackList ~= nil and 0 < #attackList then
    local num = 0
    local LWWorldSiegeUserCell = "Assets/Main/Prefabs/UI/LWWorld/WorldSiegeAllianceScoreCell_S1.prefab"
    pcall(function()
      table.sort(attackList, function(a, b)
        return a.point > b.point
      end)
    end)
    for i = 1, table.length(attackList) do
      num = num + 1
      self.rankModels[i] = self:GameObjectInstantiateAsync(LWWorldSiegeUserCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.allianceScoreContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.allianceScoreContent:AddComponent(WorldSiegeAllianceScoreCell, nameStr)
        cell:RefreshData(attackList[i], i)
      end)
    end
  else
    self.allianceScoreContent:SetActive(false)
    self.btn_alliance:SetActive(false)
    self.build_des:SetActive(true)
  end
end

local function SetAllianceScoreCellsDestroy(self)
  self.allianceScoreContent:RemoveComponents(WorldSiegeAllianceScoreCell)
  if self.rankModels ~= nil then
    for k, v in pairs(self.rankModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rankModels = {}
end

local function SwitchAllianceScore(self, isOpen)
  local serverData = self.view.ctrl:GetAllianceCityDetail(self.view.ctrl.cityId)
  local canOpen = false
  if serverData and serverData.attackList and #serverData.attackList > 0 then
    canOpen = true
  end
  if isOpen and canOpen then
    self.build_des:SetActive(false)
    self.allianceScoreContent:SetActive(true)
    self:RefreshAllianceScore(serverData)
    self.attack_build_des_title:SetActive(false)
  else
    self.build_des:SetActive(true)
    self.allianceScoreContent:SetActive(false)
    self.attack_build_des_title:SetActive(true)
  end
end

local function RefreshHpBar(self)
  if self.data.type ~= 1 then
    return
  end
  local showHp = true
  local serverData = self.view.ctrl:GetAllianceCityDetail(self.data.cityId)
  if serverData and serverData.attackList and #serverData.attackList > 0 then
    showHp = false
  end
  if not showHp then
    self.hpBarRoot:SetActive(false)
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.data.uuid)
  if info ~= nil then
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if allianceCityPointInfo ~= nil then
      local pointId = info.mainIndex
      local cityId = allianceCityPointInfo.cityId
      local theServerId = LuaEntry.Player:GetCurServerId()
      local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, theServerId)
      if cityTemplate ~= nil then
        local maxDurability = cityTemplate:getIntValue("wall")
        local durability = allianceCityPointInfo.durability or 0
        local lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime or 0
        local cityRecoverSpeed = cityTemplate:getIntValue("wall_recover")
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local addNum = (curTime - lastDurabilityTime) * toInt(cityRecoverSpeed)
        local realDurabilityNum = durability + math.max(addNum, 0)
        if self.serverData and self.serverData.attachmentList then
          local defaultDurability = maxDurability
          for k, v in ipairs(self.serverData.attachmentList) do
            if v and v.cityId == cityId and v.state == 1 then
              local buildData = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(v.buildId)
              if buildData and buildData.durability then
                local str1, str2 = string.match(buildData.durability, "([^:,;|]+)[:,;|]([^:,;|]+)")
                if str1 ~= nil and str2 ~= nil then
                  if str1 == "1" then
                    maxDurability = maxDurability + toInt(str2)
                  elseif str1 == "2" then
                    maxDurability = maxDurability + (tonumber(str2) or 0) * defaultDurability
                  end
                else
                  maxDurability = maxDurability + toInt(buildData.durability)
                end
              end
            end
          end
        end
        local curNum = math.min(realDurabilityNum, maxDurability)
        self.shieldBar:SetValue(curNum / maxDurability)
        self.shieldBarText:SetText(Mathf.Round(curNum) .. "/" .. Mathf.Round(maxDurability))
        local serverData = self.view.ctrl:GetAllianceCityDetail(self.view.ctrl.cityId)
        if serverData ~= nil then
          self.hpBar:SetValue(serverData.armyCur / serverData.armyMax)
          self.hpBarText:SetText(Mathf.Round(serverData.armyCur) .. "/" .. Mathf.Round(serverData.armyMax))
        end
      end
    end
  end
end

local function CheckCurTime(self)
  self.state = AllianceCityShowTimeState.None
  self.endTime = 0
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.data ~= nil and self.serverData ~= nil and self.data.type ~= WorldAllianceCityType.Stronghold and self.data.type ~= WorldAllianceCityType.TradingStation then
    if self.data.isKingCity or self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon then
      local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.data.uuid)
      if pointInfo ~= nil then
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if allianceCityPointInfo ~= nil then
          local timeOpen = allianceCityPointInfo.openTime or 0
          local timeEnd = allianceCityPointInfo.protectTime or 0
          if curTime > timeOpen and curTime < timeEnd then
            self.endTime = 0
            self.state = AllianceCityShowTimeState.KingMode
          elseif curTime > timeOpen and curTime > timeEnd then
            self.endTime = 0
            self.state = AllianceCityShowTimeState.KingMode
          else
            self.endTime = timeOpen
            self.state = AllianceCityShowTimeState.Lock
          end
        end
      end
    end
    if self.state == AllianceCityShowTimeState.None then
      if self.data.openTime ~= nil and curTime > self.data.openTime and self.data.openTime ~= -1 then
        if curTime > self.data.protectTime then
          local recoverTime = self.serverData.battleStartTime / 1000 + self.data.monsterRecoverTime
          if curTime <= recoverTime then
            self.state = AllianceCityShowTimeState.Recover
            self.endTime = recoverTime
          end
        else
          self.state = AllianceCityShowTimeState.UnAttack
          self.endTime = self.data.protectTime
        end
      else
        self.state = AllianceCityShowTimeState.Lock
        self.endTime = self.data.openTime
      end
    end
  end
  if self.data.type == WorldAllianceCityType.TradingStation then
    local curTimeState = self.data.tradeData:GetTimeState()
    if curTimeState == AllianceCityShowTimeState.TradeLock then
      self.endTime = self.data.tradeData.battleStartTime / 1000
      self.state = AllianceCityShowTimeState.TradeLock
    elseif curTimeState == AllianceCityShowTimeState.TradeBattle then
      self.endTime = self.data.tradeData.battleEndTime / 1000
      self.state = AllianceCityShowTimeState.TradeBattle
    else
      self.endTime = -1
      self.state = AllianceCityShowTimeState.TradeOver
    end
  end
  if self.data and self.data.isGivingUp then
    self.state = AllianceCityShowTimeState.GiveUp
    self.endTime = self.data.givingUpEndTime / 1000
  elseif (self.state == AllianceCityShowTimeState.None or self.state == AllianceCityShowTimeState.Recover) and self.data.type == WorldAllianceCityType.City then
    local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(self.data.cityId)
    if myAlCityInfo ~= nil then
      local declareList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.cityId)
      if declareList and 0 < table.count(declareList) then
        self.endTime = 0
        for k, v in ipairs(declareList) do
          self.endTime = math.max(self.endTime, (v.et or 0) * 0.001)
        end
        if self.endTime <= 0 then
          self.endTime = nil
          self.time_obj:SetActive(false)
          self.state = AllianceCityShowTimeState.None
        else
          self.timeStr = Localization:GetString("season_city_war_tips02")
          self.state = AllianceCityShowTimeState.DeclareWar
          self.time_obj:SetActive(true)
        end
        return
      end
    else
      local declareInfo = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if declareInfo and declareInfo.et and declareInfo.content and toInt(self.data.cityId) == toInt(declareInfo.content) then
        self.timeStr = Localization:GetString("season_city_war_tips01")
        self.state = AllianceCityShowTimeState.DeclareWar
        self.time_obj:SetActive(true)
        self.endTime = declareInfo.et * 0.001
        return
      end
    end
  end
  if self.state == AllianceCityShowTimeState.Recover then
    self.time_obj:SetActive(false)
    self.state = AllianceCityShowTimeState.None
  elseif self.state == AllianceCityShowTimeState.UnAttack then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("300701") .. ": "
  elseif self.state == AllianceCityShowTimeState.Lock then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("372111", "")
  elseif self.state == AllianceCityShowTimeState.GiveUp then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("393058", "")
  elseif self.state == AllianceCityShowTimeState.TradeLock then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("season_s3_trade_city006")
  elseif self.state == AllianceCityShowTimeState.TradeBattle then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("season_s3_trade_city026")
  else
    self.time_obj:SetActive(false)
  end
end

local function OnClickDeclareWarList(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareWarList, {anim = true}, self.data.cityId)
end

local function UpdateTime(self)
  if self.endTime and self.state and self.endTime > 0 and self.state ~= AllianceCityShowTimeState.None then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      self.time_txt:SetText(self.timeStr .. UITimeManager:GetInstance():SecondToFmtString(deltaTime))
    else
      self.time_txt:SetText(self.timeStr .. "00:00:00")
    end
  elseif self.endTime == -1 then
    self.time_txt:SetLocalText(120105)
  end
end

function UIWorldSiegePointSeasonInfo:RefreshNuclearScore(sendFlag)
  local seasonSnow = SeasonUtil.IsInSeasonSnowMode()
  if self.data and self.data.isKingCity and seasonSnow then
    local max = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
    if sendFlag and DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen() then
      local curServerId = LuaEntry.Player:GetCurServerId()
      SFSNetwork.SendMessage(MsgDefines.NuclearServerScoreView, curServerId)
    end
    local actNuclearScore = DataCenter.WorldAllianceCityDataManager:GetThroneNuclearScore(LuaEntry.Player:GetCurServerId())
    if max <= actNuclearScore then
      self.status0_nuclear:SetLocalText("season_s2_activity_1000047_description_29")
      self.nuclear_btn:SetActive(false)
    else
      local msg = Localization:GetString("season_s2_throne_tips01") .. "\n"
      local percent = string.percentage(actNuclearScore, max, 2)
      self.status0_nuclear:SetText(msg .. Localization:GetString("season_s2_throne_tips02", percent))
      self.nuclear_btn:SetActive(true)
    end
  end
end

function UIWorldSiegePointSeasonInfo:ShowReward(showIt)
  if self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon or self.data.type == WorldAllianceCityType.MissileFactory then
    return
  end
  if showIt then
    if self.dynamicRoot == nil then
      self.dynamicRoot = self:AddComponent(UIBaseContainer, dynamic_root_path)
    end
    if self.RewardListRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeReward"
      local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/Component/RewardListSeason.prefab"
      self.RewardListRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
    end
    if self.RewardListRoot ~= nil and self.data and self.data.serverId then
      if self.data.type == WorldAllianceCityType.City and DataCenter.SeasonCampDestroyManager:IsEnemyServer(self.data.serverId) then
        self.RewardListRoot:ReInit(self.data.destroyRewardStr, self.data.alliance_destroy_reward_show, self.data)
      else
        self.RewardListRoot:ReInit(self.data.rewardStr, self.data.the_show_reward_str, self.data)
      end
    end
  end
  if self.RewardListRoot ~= nil then
    self.RewardListRoot:SetActive(showIt)
  end
  self.isRewardShown = showIt
end

function UIWorldSiegePointSeasonInfo:CityDestroyED()
  if not self.data then
    return
  end
  return self.data.state == AllianceCityState.DESTROY
end

local function RefreshData(self, data, cityType)
  self.serverData = data
  local isDestroy = false
  if self:CityDestroyED() and data and data.ruinObj then
    isDestroy = true
    self.dynamicCampDestroy:RefreshData(data, self.data)
    self.dynamicCampDestroy:SetActive(true)
  else
    self.dynamicCampDestroy:SetActive(false)
  end
  if self.serverData ~= nil then
    if cityType == WorldAllianceCityType.TradingStation then
      self:CheckCurTime()
      return
    end
    if self.CityAttachmentRoot ~= nil then
      self.CityAttachmentRoot:RefreshData(data)
    end
    self:CheckFirstOccupy()
    self:CheckCurTime()
    self:UpdateTime()
    self:RefreshHpBar()
    self:RefreshAllianceScore(self.serverData)
    self:CheckShowScoreOrBuildDesc()
    self:RefreshNuclearScore(true)
    self:RefreshAssistance(self.serverData)
    self:RefreshCityBattleS1RestInfo()
  end
  if isDestroy then
    self.build_des_fold:SetActive(false)
  end
end

function UIWorldSiegePointSeasonInfo:RefreshAssistance(info)
  if not self.dCompAssistance or not self.dCompAssistance2 then
    return
  end
  local usedComp2 = self.data.type == WorldAllianceCityType.MissileFactory or self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon
  if not (info and info.assistanceList) or #info.assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
    self.dCompAssistance2:SetActive(false)
  elseif usedComp2 then
    self.dCompAssistance:SetActive(false)
    self.dCompAssistance2:SetActive(true)
    self.dCompAssistance2:Setup({
      isCity = true,
      pointId = self.data.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
  else
    self.dCompAssistance2:SetActive(false)
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.data.pointId,
      cityId = info.cityId,
      assistanceList = info.assistanceList,
      maxMember = info.maxAssistance,
      memberCount = info.currAssistance,
      totalPower = info.assistanceTotalPower,
      limit = 10
    })
  end
end

function UIWorldSiegePointSeasonInfo:OnAssistanceDetailInfo(pointId)
  if not self.data then
    return
  end
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.data.pointId then
    WorldBattleUtil.TryRequestCityInfo(self.data.cityId)
  end
end

local function CheckFirstOccupy(self)
  if self.serverData ~= nil then
    local firstOccupyInfo
    if LuaEntry.Player:AtHomeNow() then
      firstOccupyInfo = self.serverData.firstOccupyInfo
    else
      firstOccupyInfo = self.serverData.firstCrossOccupyInfo
    end
    if firstOccupyInfo ~= nil then
      if firstOccupyInfo.firstOccupyTime ~= nil and firstOccupyInfo.firstOccupyTime > 0 then
        self:ShowReward(false)
        self.loot_info:SetActive(false)
        if self.data ~= nil and (self.data.state == AllianceCityState.NEUTRAL or self.data.state == AllianceCityState.SERVER_NEUTRAL) then
          local nameStr = Localization:GetString("100206") .. "(" .. Localization:GetString("302131") .. ")"
          self.city_alliance_name:SetText(nameStr)
        end
      end
      if firstOccupyInfo.alAbbr ~= nil and firstOccupyInfo.alAbbr ~= "" then
        self.first_occupy_obj:SetActive(true)
        self:ShowReward(false)
        self.loot_info:SetActive(false)
        local nameStr = UIUtil.FormatServerAllianceName(firstOccupyInfo.serverId, firstOccupyInfo.alAbbr, firstOccupyInfo.alName)
        self.first_occupy_name:SetText(nameStr)
        local second = 0
        if firstOccupyInfo.firstOccupyTime > 0 then
          second = math.floor(firstOccupyInfo.firstOccupyTime / 1000)
        end
        local timeStr = UITimeManager:GetInstance():GetTimeToMD(second)
        self.first_occupy_data:SetText(Localization:GetString("300728", timeStr))
        return
      end
    end
    self.first_occupy_obj:SetActive(false)
    self:ShowReward(not self.data.isKingCity and not self.hideRewardShow)
  end
end

local function RefreshOccupyHistory(self, serverData)
  if self.data.type == WorldAllianceCityType.CrossZoneOutpost or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    self.occupy_history:SetActive(false)
    return
  end
  if self.data.type == WorldAllianceCityType.MissileFactory then
    if self.MissileFactoryRoot then
      self.MissileFactoryRoot:RefreshOccupyData(serverData)
    end
    self.occupy_history:SetActive(false)
    return
  end
  if self.data.state ~= AllianceCityState.SERVER_OCCUPIED and self.data.state ~= AllianceCityState.SERVER_BUILD_THRONE or serverData == nil or serverData.latestOccupy == nil then
    self.occupy_history:SetActive(false)
    return
  end
  self.occupy_history:ReInit(1, serverData.latestOccupy)
  self.occupy_history:SetActive(true)
end

local function OnClickOccupyHistory(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldOccupyHistory, {anim = true}, self.data.uuid)
end

function UIWorldSiegePointSeasonInfo:ReAutoFitUI()
  if self.view.ReAutoFitUI then
    self.view:ReAutoFitUI()
  end
end

local function OnInfoClick(self)
  local theServerId = LuaEntry.Player:GetCurServerId()
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.data.cityId, theServerId)
  local desc = cityMeta.desc
  self.des_txt:SetLocalText(desc)
  self.detail_title:SetActive(false)
  self.main_obj_canvas:SetAlpha(0)
  self.des_obj_canvas:SetAlpha(1)
  if self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    if self.BatteryRoot then
      self.BatteryRoot:OnInfoClick()
    end
    return
  end
  if self.data.type == WorldAllianceCityType.MissileFactory then
    if self.MissileFactoryRoot then
      self.MissileFactoryRoot:OnInfoClick()
    end
    return
  end
  self.des_obj:SetActive(true)
end

local function OnReturnClick(self)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(0)
  if self.data.type == WorldAllianceCityType.Canon or self.data.type == WorldAllianceCityType.CrossZoneOutpostCanon then
    if self.BatteryRoot then
      self.BatteryRoot:OnReturnClick()
    end
    return
  end
  if self.data.type == WorldAllianceCityType.MissileFactory then
    if self.MissileFactoryRoot then
      self.MissileFactoryRoot:OnReturnClick()
    end
    return
  end
  self.des_obj:SetActive(false)
end

local function OnAllianceClick(self)
  if self.data ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.data.alName, self.data.allianceId)
  end
end

local function OnDesClick(self)
  self:ShowBubble(Localization:GetString("302015"), self.city_add_num_des_btn)
end

local function OnAllianceScoreRankDesClick(self)
  local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self:ShowBubble(Localization:GetString("season_city_battle_tips002", k5, k6), self.allianceScoreInfoBtn, 420, 0.2)
end

local function OnAllianceScoreRankDesTitle2Click(self)
  local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
  local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
  self:ShowBubble(Localization:GetString("season_city_battle_tips002", k5, k6), self.attack_build_des_detail_btn, 420, 0.2)
end

function UIWorldSiegePointSeasonInfo:ShowBubble(content, parent, width, pivot)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = parent.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = content
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = width or 180
  param.pivot = pivot or 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function UIWorldSiegePointSeasonInfo:CanShowReward(serverId, cityType)
  if cityType == WorldAllianceCityType.City then
    if self:CityDestroyED() then
      return false
    end
    local myFatherServer = LuaEntry.Player:GetSourceServerId()
    local seasonType = SeasonUtil.GetSeasonType(true, true)
    if myFatherServer ~= serverId and seasonType == SeasonMapType.NineNationRainforest then
      local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
      local campId = DataCenter.SeasonFactionWarDataManager:GetCampIdByServerId(serverId)
      if myCampId == campId then
        local sever_loot_reward = self.data.sever_loot_reward or 0
        if sever_loot_reward <= 0 then
          return false
        end
      end
    end
  end
  if LuaEntry.Player:AtHomeNow() then
    return true
  end
  local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
  local seasonType = seasonInfo and seasonInfo:GetServerType(true)
  if not seasonType or seasonType < SeasonMapType.CityStronghold then
    return false
  end
  if seasonType == SeasonMapType.CityStronghold then
    return true
  end
  if seasonType == SeasonMapType.Snow then
    return false
  end
  if seasonType == SeasonMapType.Mummy or seasonType == SeasonMapType.Darkness then
    return cityType == WorldAllianceCityType.TradingStation
  end
  return true
end

function UIWorldSiegePointSeasonInfo:RefreshCityValue(serverData)
  local seasonType = SeasonUtil.GetSeasonType()
  if serverData and seasonType == SeasonMapType.Mummy and DataCenter.SeasonGreenManager:IsGreenCity(self.data.cityId) then
    self.city_add_des:SetLocalText("season_oasis_UI_2")
    self.city_add_num_des_1_btn:SetActive(true)
    return
  end
  self.city_add_des:SetLocalText(300698)
  self.city_add_num_des_1_btn:SetActive(false)
  self.hasGhost = false
  if serverData and self.data and self.data.type == WorldAllianceCityType.City and seasonType == SeasonMapType.Darkness then
    if serverData.hasGhost then
      self.city_add_num_des:SetColorHex("#fd7156")
      self.city_add_num:SetColorHex("#fd7156")
      self.city_add_num_des_1_btn:SetActive(true)
      self.hasGhost = true
    else
      self.city_add_num_des:SetColorHex("#000000")
      self.city_add_num:SetColorHex("#000000")
    end
  end
end

function UIWorldSiegePointSeasonInfo:OnCityValueClick()
  if self.hasGhost then
    UIUtil.ShowButtonTips(self.city_add_num_des_1_btn, nil, "season_s4_monster_tips26", false)
  elseif SeasonUtil.CurServerTypeInSeason() == SeasonMapType.Mummy then
    self:ShowBubble(Localization:GetString("season_oasis_UI_1", DataCenter.SeasonGreenManager.cityGreenCondition), self.city_add_num_des_1_btn)
  end
end

function UIWorldSiegePointSeasonInfo:RefreshSuppliesNum(serverData)
  local seasonType = SeasonUtil.CurServerTypeInSeason()
  if seasonType == SeasonMapType.Mummy and DataCenter.SeasonGreenManager:IsGreenCity(self.data.cityId) then
    local selfCity = self.data.isInAlliance and self.data.allianceId == LuaEntry.Player:GetAllianceUid()
    local tData = selfCity and serverData and serverData.suppliesNum or -1
    local num = 0 <= tData and tostring(tData) or "???"
    self.city_add_des7:SetLocalText("season_oasis_UI_25")
    self.city_add_num7:SetText(num)
    self.layout7:SetActive(true)
    return
  end
  self.layout7:SetActive(false)
end

function UIWorldSiegePointSeasonInfo:OnLayout7DesClick()
  local selfCity = self.data.isInAlliance and self.data.allianceId == LuaEntry.Player:GetAllianceUid()
  local seasonType = SeasonUtil.CurServerTypeInSeason()
  if seasonType == SeasonMapType.Snow then
    self:ShowBubble(Localization:GetString(selfCity and "season_s2_ice_supplies_7" or "season_s2_ice_supplies_8"), self.city_add_num_des_btn7)
  elseif seasonType == SeasonMapType.Mummy then
    self:ShowBubble(Localization:GetString(selfCity and "season_oasis_UI_26" or "season_oasis_UI_27"), self.city_add_num_des_btn7)
  end
end

function UIWorldSiegePointSeasonInfo:OnLayout8DesClick()
  if self.data.type == WorldAllianceCityType.TradingStation then
    self:ShowBubble(Localization:GetString("season_s3_trade_city003"), self.city_add_num_des_btn8)
    return
  end
end

function UIWorldSiegePointSeasonInfo:BuildDesFolderClick()
  if self.buildDesFolderOpen then
    self.buildDesFolderOpen = false
    self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png")
  else
    self.buildDesFolderOpen = true
    self.fold_state_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png")
  end
  self.build_des:SetActive(self.buildDesFolderOpen)
  self.view:AutoFitUI(1)
end

function UIWorldSiegePointSeasonInfo:SetCityBattleS1RestShow()
  if self.data.type == WorldAllianceCityType.City and DataCenter.OffSeason1RecaptureManager.serverActivityOpen then
    self.hpBarRoot:SetActive(false)
    self:ShowReward(false)
    self.city_force:SetActive(false)
    self.stronghold_add:SetActive(false)
    self.loot_info:SetActive(false)
    self.viral:SetActive(false)
    self.tips_obj:SetActive(false)
    self.build_reset_hp:SetActive(true)
  end
end

function UIWorldSiegePointSeasonInfo:RefreshCityBattleS1RestInfo()
  local rankData
  if DataCenter.OffSeason1RecaptureManager.serverActivityOpen and self.serverData and self.serverData.cityBattleS1RestInfo then
    self.hpBarRoot:SetActive(false)
    self:ShowReward(false)
    self.city_force:SetActive(false)
    self.stronghold_add:SetActive(false)
    self.loot_info:SetActive(false)
    self.viral:SetActive(false)
    self.tips_obj:SetActive(false)
    self.build_reset_hp:SetActive(true)
    local info = self.serverData.cityBattleS1RestInfo
    if info then
      if info.status == RecaptureActCityBattleCityStatus.MONSTER_OCCUPIED then
        local nameStr = Localization:GetString("activity_name_1000016")
        self.city_alliance_name:SetText("<color=#2A2830>" .. nameStr .. "</color>")
      elseif info.status == RecaptureActCityBattleCityStatus.SERVER_OCCUPIED then
        local nameStr = LuaEntry.Player:GetCurServerId()
        if self.data.ownerServerId and self.data.ownerServerId ~= 0 then
          nameStr = self.data.ownerServerId
        end
        self.city_alliance_name:SetText("<color=#0e9500>#" .. nameStr .. "</color>")
      end
    end
    self.reset_shield_bar:SetValue(info.hp / 100)
    self.reset_shield_label:SetText(string.percentage(info.hp, 100, 2))
    if self.serverData.cityBattleS1RestInfo.ranks then
      rankData = self.serverData.cityBattleS1RestInfo.ranks
    end
  end
  if rankData and 0 < #rankData then
    if self.dynamicRoot == nil then
      self.dynamicRoot = self:AddComponent(UIBaseContainer, dynamic_root_path)
    end
    if self.queenOfBloodRank == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeQueenOfBloodRank"
      local prefabPath = "Assets/Main/Sprites/UI/LWOffSeason1/LWWorld/Component/QueenOfBloodRank.prefab"
      self.queenOfBloodRank = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.dynamicRoot)
    end
    self.queenOfBloodRank:ReInit(rankData)
  elseif self.queenOfBloodRank and self.queenOfBloodRank:AsyncLoadDone() then
    self.queenOfBloodRank:SetActive(false)
  end
end

UIWorldSiegePointSeasonInfo.OnCreate = OnCreate
UIWorldSiegePointSeasonInfo.OnDestroy = OnDestroy
UIWorldSiegePointSeasonInfo.OnEnable = OnEnable
UIWorldSiegePointSeasonInfo.OnDisable = OnDisable
UIWorldSiegePointSeasonInfo.ComponentDefine = ComponentDefine
UIWorldSiegePointSeasonInfo.ComponentDestroy = ComponentDestroy
UIWorldSiegePointSeasonInfo.DataDefine = DataDefine
UIWorldSiegePointSeasonInfo.DataDestroy = DataDestroy
UIWorldSiegePointSeasonInfo.RefreshData = RefreshData
UIWorldSiegePointSeasonInfo.OnReturnClick = OnReturnClick
UIWorldSiegePointSeasonInfo.OnInfoClick = OnInfoClick
UIWorldSiegePointSeasonInfo.InitData = InitData
UIWorldSiegePointSeasonInfo.CheckCurTime = CheckCurTime
UIWorldSiegePointSeasonInfo.UpdateTime = UpdateTime
UIWorldSiegePointSeasonInfo.CheckFirstOccupy = CheckFirstOccupy
UIWorldSiegePointSeasonInfo.OnAllianceClick = OnAllianceClick
UIWorldSiegePointSeasonInfo.SetKillRewardDestroy = SetKillRewardDestroy
UIWorldSiegePointSeasonInfo.SetOccupyRewardDestroy = SetOccupyRewardDestroy
UIWorldSiegePointSeasonInfo.OnClickOccupyHistory = OnClickOccupyHistory
UIWorldSiegePointSeasonInfo.RefreshOccupyHistory = RefreshOccupyHistory
UIWorldSiegePointSeasonInfo.OnDesClick = OnDesClick
UIWorldSiegePointSeasonInfo.OnClickDeclareWarList = OnClickDeclareWarList
UIWorldSiegePointSeasonInfo.RefreshHpBar = RefreshHpBar
UIWorldSiegePointSeasonInfo.RefreshAllianceScore = RefreshAllianceScore
UIWorldSiegePointSeasonInfo.SwitchAllianceScore = SwitchAllianceScore
UIWorldSiegePointSeasonInfo.SetAllianceScoreCellsDestroy = SetAllianceScoreCellsDestroy
UIWorldSiegePointSeasonInfo.OnAllianceScoreRankDesClick = OnAllianceScoreRankDesClick
UIWorldSiegePointSeasonInfo.OnAllianceScoreRankDesTitle2Click = OnAllianceScoreRankDesTitle2Click
UIWorldSiegePointSeasonInfo.CheckShowScoreOrBuildDesc = CheckShowScoreOrBuildDesc
return UIWorldSiegePointSeasonInfo
