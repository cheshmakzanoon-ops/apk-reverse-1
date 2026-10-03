local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIWorldSiegeRewardCell = require("UI.LWWorld.UIWorldSiegePoint.Component.UIWorldSiegeRewardCell")
local WorldSiegeAllianceScoreCell = require("UI.LWWorld.UIWorldSiegePoint.Component.WorldSiegeAllianceScoreCell")
local UIWorldSiegePointInfo = BaseClass("UIWorldSiegePointInfo", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIWorldOccupyHistoryItem = require("UI.LWWorld.UIWorldOccupyHistory.Component.UIWorldOccupyHistoryItem")
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local build_des_path = "BuildInfo/buildDes"
local reward_item_path = "BuildInfo/rewardItem"
local city_soldier_des_path = "BuildInfo/buildDes/soldierlayout/citySoliderDes"
local btn_alliance_path = "BuildInfo/buildDes/soldierlayout/btn_alliance"
local city_alliance_name_path = "BuildInfo/buildDes/soldierlayout/NameText"
local city_add_des_path = "BuildInfo/buildDes/layout1/cityAddDes"
local city_add_num_path = "BuildInfo/buildDes/layout1/cityAddNum"
local city_add_num_des_path = "BuildInfo/buildDes/layout1/cityAddNumDes"
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
local time_obj_path = "BuildInfo/timelayout"
local reward_txt_path = "BuildInfo/rewardItem/rewardText"
local reward_content_path = "BuildInfo/rewardItem/ScrollView/Viewport/rewardContent"
local first_occupy_obj_path = "BuildInfo/firstOccupy"
local first_occupy_detail_btn_path = "BuildInfo/firstOccupy/Image"
local first_occupy_name_path = "BuildInfo/firstOccupy/allianceName"
local first_occupy_data_path = "BuildInfo/firstOccupy/allianceData"
local tips_txt_path = "BuildInfo/tipsLayout"
local declareWarList_rect_path = "BuildInfo/Rect_DeclareWarList"
local declareWarList_btn_path = "BuildInfo/Rect_DeclareWarList/Btn_DeclareWarList"
local warList_txt_path = "BuildInfo/Rect_DeclareWarList/Btn_DeclareWarList/Txt_WarList"
local hp_bar_root = "BuildInfo/buildHp"
local hp_bar_path = "BuildInfo/buildHp/HpBarNode/HPBar"
local hp_bar_text_path = "BuildInfo/buildHp/HpBarNode/HPLabel"
local shield_bar_path = "BuildInfo/buildHp/ShieldBarNode/ShieldBar"
local shield_bar_text_path = "BuildInfo/buildHp/ShieldBarNode/ShieldLabel"
local alliance_scroll_path = "BuildInfo/allianceScoreScroll"
local alliance_score_path = "BuildInfo/allianceScoreScroll/Viewport/allianceScore"
local alliance_score_title_path = "BuildInfo/allianceScoreScroll/Viewport/allianceScore/Top/allianceScoreTitle"
local alliance_score_info_btn_path = "BuildInfo/allianceScoreScroll/Viewport/allianceScore/Top/allianceScoreDetailBtn"
local alliance_score_close_btn_path = "BuildInfo/allianceScoreScroll/Viewport/allianceScore/Top/allianceScoreCloseBtn"
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
local king_path = "BuildInfo/king"
local king_icon_path = "BuildInfo/king/king_icon"
local king_name_text_path = "BuildInfo/king/king_name"
local king_manage_btn_path = "BuildInfo/king/king_btn"
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
local dynamic_root_1_path = "BuildInfo/DynamicRoot_1"
local layout_dynamic2_root_path = "DynamicRoot2"
local animator_path = ""

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

function UIWorldSiegePointInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function UIWorldSiegePointInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.KingOccupyProgressRefresh, self.ShowKingOccupyProgress)
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

local function ComponentDefine(self)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.main_obj = self:AddComponent(UIBaseContainer, main_obj_path)
  self.build_des = self:AddComponent(UIBaseContainer, "BuildInfo/Effect")
  self.reward_item = self:AddComponent(UIBaseContainer, reward_item_path)
  self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.main_obj_canvas = self:AddComponent(UICanvasGroup, main_obj_path)
  self.main_obj_canvas:SetAlpha(1)
  self.btn_alliance = self:AddComponent(UIButton, btn_alliance_path)
  self.btn_alliance:SetOnClick(function()
    self:SwitchAllianceScore(true)
  end)
  self.time_obj = self:AddComponent(UIBaseContainer, time_obj_path)
  self.time_txt = self:AddComponent(UIText, "BuildInfo/timelayout/timeLabel")
  self.time_desc = self:AddComponent(UIText, "BuildInfo/timelayout/timeDesc")
  self.city_soldier_des = self:AddComponent(UIText, city_soldier_des_path)
  self.city_soldier_des:SetLocalText(300696)
  self.city_add_des = self:AddComponent(UIText, city_add_des_path)
  self.city_add_des:SetLocalText(300698)
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
  self.reward_txt = self:AddComponent(UIText, reward_txt_path)
  self.reward_txt:SetLocalText(300702)
  self.city_add_num_des = self:AddComponent(UIText, city_add_num_des_path)
  self.city_add_num = self:AddComponent(UIText, city_add_num_path)
  self.city_add_num_des_2 = self:AddComponent(UIText, city_add_num_des_2_path)
  self.city_add_num_2 = self:AddComponent(UIText, city_add_num_2_path)
  self.city_add_num_3 = self:AddComponent(UIText, city_add_num_3_path)
  self.city_add_num_des_btn = self:AddComponent(UIButton, city_add_num_des_btn_path)
  self.city_add_num_des_btn:SetOnClick(function()
    self:OnDesClick()
  end)
  self.city_alliance_name = self:AddComponent(UIText, city_alliance_name_path)
  self.ownerNode = self:AddComponent(UIImage, "BuildInfo/Owner")
  self.ownerName = self:AddComponent(UIText, "BuildInfo/Owner/Content/OwnerName")
  self.ownerFlag = self:AddComponent(UIImage, "BuildInfo/Owner/OwnerFlag")
  self.ownerTxt = self:AddComponent(UIText, "BuildInfo/Effect/ownerTxt")
  self.numTxt = self:AddComponent(UIText, "BuildInfo/Effect/numTxt")
  self.descTxt = self:AddComponent(UIText, "BuildInfo/Effect/descTxt")
  self.btnLayout = self:AddComponent(UIBaseComponent, "BuildInfo/btnLayout")
  self.tipTxt = self:AddComponent(UIBaseComponent, "BuildInfo/buildHp/TipTxt")
  self.first_occupy_obj = self:AddComponent(UIBaseContainer, first_occupy_obj_path)
  self.first_occupy_name = self:AddComponent(UIText, first_occupy_name_path)
  self.first_occupy_data = self:AddComponent(UIText, first_occupy_data_path)
  self.first_occupy_detail_btn = self:AddComponent(UIButton, first_occupy_detail_btn_path)
  self.first_occupy_detail_btn:SetOnClick(function()
    local name = self.serverData.firstOccupyInfo.alName
    local aid = self.serverData.firstOccupyInfo.aid
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, name, aid)
  end)
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
  self.allianceScroll = self:AddComponent(UILayoutElement, alliance_scroll_path)
  self.allianceScoreContent = self:AddComponent(UIBaseContainer, alliance_score_path)
  self.allianceScoreTitle = self:AddComponent(UIText, alliance_score_title_path)
  self.allianceScoreInfoBtn = self:AddComponent(UIButton, alliance_score_info_btn_path)
  self.allianceScoreCloseBtn = self:AddComponent(UIButton, alliance_score_close_btn_path)
  self.allianceScoreOpenBtn = self:AddComponent(UIButton, "BuildInfo/Effect/allianceScoreOpenBtn")
  self.allianceScoreTitle:SetLocalText(302320)
  self.allianceScoreInfoBtn:SetOnClick(function()
    self:OnAllianceScoreRankDesClick()
  end)
  self.allianceScoreCloseBtn:SetOnClick(function()
    self:SwitchAllianceScore(false)
  end)
  self.allianceScoreOpenBtn:SetOnClick(function()
    self:SwitchAllianceScore(true)
  end)
  self.king_root = self:AddComponent(UIImage, king_path)
  self.king_name_text = self:AddComponent(UIText, king_name_text_path)
  self.king_manage_btn = self:AddComponent(UIButton, king_manage_btn_path)
  self.king_manage_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIUtil.DestroyWorldSiegePoint()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMain, {anim = true}, self.view.ctrl.serverId, self.view.ctrl.cityId)
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
  self.tranLayoutDynamicRoot2 = self.transform:Find(layout_dynamic2_root_path)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(dynamic_root_1_path), UIAssets.UIWorldPointComp_PlayerAssistanceCompFat, lua_path_assistance, true)
    self.dCompAssistance2 = UIAsyncLoaderBridge.New(self, "dCompAssistance2", self.tranLayoutDynamicRoot2, UIAssets.UIWorldPointComp_PlayerAssistanceCompFat, lua_path_assistance, true)
  end
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
  if self.dCompAssistance2 then
    self.dCompAssistance2:Delete()
    self.dCompAssistance2 = nil
  end
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
end

local function DataDefine(self)
  self.data = nil
  self.showTimeState = AllianceCityShowTimeState.None
  self.endTime = 0
  self.timeStr = ""
  CS.SceneManager.World:SetFocusPoint(-1)
end

local function DataDestroy(self)
  self.data = nil
end

local function SetRewardCellDestroy(self)
  self.reward_content:RemoveComponents(UICommonResItem)
  if self.rewardModel ~= nil then
    for k, v in pairs(self.rewardModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModel = {}
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

function UIWorldSiegePointInfo:UpdateThroneOccupy()
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
  local campIconA = DataCenter.ZoneWarManager:GetCampIcon(ownerPoint.serverId, ownerPoint.campId)
  local campIconB = DataCenter.ZoneWarManager:GetCampIcon(targetPoint.serverId, targetPoint.campId)
  if campIconA or campIconB then
    self.icon_camp_a:LoadSprite(campIconA or "")
    self.icon_camp_a:SetNativeSize()
    self.icon_camp_b:LoadSprite(campIconB or "")
    self.icon_camp_b:SetNativeSize()
    self.icon_camp_a:SetActive(true)
    self.icon_camp_b:SetActive(true)
    self.server_value1:SetActive(false)
    self.server_value2:SetActive(false)
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

function UIWorldSiegePointInfo:Update1000MS()
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

function UIWorldSiegePointInfo:ShowKingOccupyProgress()
  if self.data.isCrossServerThrone then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local currentData = DataCenter.GovernmentManager:GetKingOccupyPlayer(curServerId)
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

local function InitData(self, param)
  self.data = param
  if self.data.type == WorldAllianceCityType.Canon then
    self.des_txt:SetLocalText(801474)
    self.main_obj:SetActive(false)
    self.king_throne_root:SetActive(false)
    if self.BatteryRoot == nil then
      local luaPath = "UI.LWWorld.UIWorldSiegePointSeason.Component.UIWorldSiegeBattery"
      local prefabPath = "Assets/Main/Prefabs/UI/LWWorld/ThroneCityBattery.prefab"
      self.BatteryRoot = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath)
    end
    self.BatteryRoot:SetActive(true)
    self.BatteryRoot:InitData(param)
    return
  else
    if self.BatteryRoot ~= nil then
      self.BatteryRoot:SetActive(false)
    end
    if self.data.type == WorldAllianceCityType.City and DataCenter.AllianceBaseDataManager:IsR4orR5() then
      DataCenter.AllianceDeclareWarManager:SetWarCityParam(nil)
      SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), self.data.cityId)
    end
    if self.data.isKingCity and self.data.isCrossServerThrone then
      self.des_txt:SetLocalText("season_ui_desc048")
    else
      self.des_txt:SetLocalText(300706)
    end
    self.main_obj:SetActive(true)
    self:UpdateThroneOccupy()
  end
  local nameStr
  if (self.data.state == AllianceCityState.OCCUPIED or self.data.state == AllianceCityState.SERVER_OCCUPIED) and not string.IsNullOrEmpty(self.data.alAbbr) then
    nameStr = "[" .. self.data.alAbbr .. "]" .. self.data.alName
    self.ownerFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.data.icon))
    self.btn_alliance:SetActive(true)
    self.ownerNode:SetActive(true)
  else
    nameStr = Localization:GetString("new_city_activity_tips1013")
    self.btn_alliance:SetActive(false)
    self.ownerNode:SetActive(false)
  end
  self.ownerName:SetText(nameStr)
  self.ownerTxt:SetText(nameStr)
  self.numTxt:SetText(self.data.buffAddNum)
  self.descTxt:SetLocalText(self.data.buffDes)
  self.city_alliance_name:SetText(nameStr)
  self.city_add_num_des:SetLocalText(self.data.buffDes)
  self.city_add_num:SetText(" " .. tostring(self.data.buffAddNum or ""))
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
  self:RefreshHpBar()
  local speed = GetTableData(TableName.WorldCity, self.data.cityId, "alliance_res_speed")
  self.city_add_num_4:SetText(speed .. "/h")
  self.first_occupy_obj:SetActive(false)
  if self.data.state == AllianceCityState.NEUTRAL then
    self.reward_item:SetActive(true)
    self:SetRewardCellDestroy()
    local list = self.data.rewardStr
    if list ~= nil then
      do
        local num = 0
        for i = 1, table.length(list) do
          num = num + 1
          self.rewardModel[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            local transform = go.transform
            go:SetActive(true)
            transform:SetParent(self.reward_content.transform)
            transform:Set_sizeDelta(150, 150)
            transform:Set_localScale(0.75, 0.75, 0.75)
            transform:Set_pivot(0, 1)
            local nameString = tostring(NameCount)
            go.name = nameString
            NameCount = NameCount + 1
            local cell = self.reward_content:AddComponent(UICommonResItem, nameString)
            cell:ReInit(list[i])
          end)
        end
      end
    end
  else
    self.reward_item:SetActive(false)
  end
  if self.data.isInAlliance == true then
    local tips = Localization:GetString("302070", string.GetFormattedSeparatorNum(self.data.recommend_power))
    self.tips_txt:SetText(tips)
    self.tips_txt:SetColor(Color.New(0.44, 0.44, 0.44, 1))
  else
    self.tips_txt:SetLocalText(300707)
    self.tips_txt:SetColor(Color.New(0.9176, 0.2588, 0.2588, 1))
  end
  self.tips_txt:SetActive(not self.data.isCrossServerThrone)
  local warDataList = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.cityId)
  if next(warDataList) then
    self.declareWarList_rect:SetActive(false)
  else
    self.declareWarList_rect:SetActive(false)
  end
  if self.data.kill_reward_list and #self.data.kill_reward_list > 0 then
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
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.kill_reward_content:AddComponent(UIWorldSiegeRewardCell, nameStr)
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
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.occupy_reward_content:AddComponent(UIWorldSiegeRewardCell, nameStr)
            cell:RefreshData(list[i], i)
          end)
        end
      end
    end
  else
    self.occupy_reward_title_obj:SetActive(false)
  end
  self.hpBarRoot:SetActive(true)
  if self.data.isKingCity then
    local curPresident = DataCenter.GovernmentManager:GetCurPresident(LuaEntry.Player:GetCurServerId())
    self.king_root:SetActive(true)
    self.hpBarRoot:SetActive(false)
    self.king_manage_btn:SetActive(LuaEntry.Player:IsInSourceServer())
    if curPresident == nil then
      if LuaEntry.Player:IsPresident() then
        self.king_name_text:SetText(LuaEntry.Player:GetName())
      else
        self.king_name_text:SetLocalText("391071")
        local curServerId = LuaEntry.Player:GetCurServerId()
        local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
        local pointInfo = CS.SceneManager.World:GetPointInfo(kingCityPosIndex)
        if pointInfo ~= nil then
          local curTime = UITimeManager:GetInstance():GetServerSeconds()
          local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
          if allianceCityPointInfo ~= nil then
            local timeOpen = allianceCityPointInfo.openTime
            local timeEnd = allianceCityPointInfo.protectTime
            if curTime > timeOpen and curTime < timeEnd then
              self.king_name_text:SetLocalText("457017")
            end
          end
        end
      end
    else
      local presidentName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(curPresident.uid, curPresident.name)
      if string.IsNullOrEmpty(curPresident.allianceAbbr) then
      else
        presidentName = "[" .. curPresident.allianceAbbr .. "]" .. presidentName
      end
      self.king_name_text:SetText(presidentName)
    end
  else
    self.king_root:SetActive(false)
  end
  self:CheckShowScoreOrBuildDesc()
  if self.data and self.data.pointId then
    CS.SceneManager.World:SetFocusPoint(self.data.pointId)
  end
end

local function CheckShowScoreOrBuildDesc(self)
  local serverData = self.view.ctrl:GetAllianceCityDetail(self.view.ctrl.cityId)
  if serverData and serverData.attackList and #serverData.attackList > 0 then
    self.allianceScroll:SetActive(true)
    self.btn_alliance:SetActive(true)
    self.build_des:SetActive(false)
    self:RefreshAllianceScore(serverData)
    self.allianceScoreOpenBtn:SetActive(not self.data.isKingCity)
    self.tipTxt:SetActive(true)
  else
    self.allianceScroll:SetActive(false)
    self.btn_alliance:SetActive(false)
    self.build_des:SetActive(true)
    self.allianceScoreOpenBtn:SetActive(false)
    self.tipTxt:SetActive(false)
  end
  self:RefreshOccupyHistory(serverData)
end

local function RefreshAllianceScore(self, serverData)
  local attackList = serverData.attackList
  if self.data.isKingCity then
    self.allianceScroll:SetActive(false)
    self.btn_alliance:SetActive(false)
    self.build_des:SetActive(true)
    return
  end
  self:SetAllianceScoreCellsDestroy()
  self.rankModels = {}
  if attackList ~= nil and 0 < #attackList then
    if #attackList <= 3 then
      self.allianceScroll:SetPreferredHeight(48 + #attackList * 46)
    else
      self.allianceScroll:SetPreferredHeight(186)
    end
    local num = 0
    table.sort(attackList, function(a, b)
      return a.point > b.point
    end)
    local max = math.max(1, attackList[1].point)
    for i = 1, table.length(attackList) do
      num = num + 1
      self.rankModels[i] = self:GameObjectInstantiateAsync(UIAssets.LWWorldSiegeUserCell, function(request)
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
        cell:RefreshData(attackList[i], i, max)
      end)
    end
  else
    self.allianceScroll:SetActive(false)
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
  self.btn_alliance:SetActive(canOpen)
  if isOpen and canOpen then
    self.build_des:SetActive(false)
    self.allianceScroll:SetActive(true)
    self:RefreshAllianceScore(serverData)
  else
    self.build_des:SetActive(true)
    self.allianceScroll:SetActive(false)
  end
end

local function RefreshHpBar(self)
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.data.uuid)
  if info ~= nil then
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(info.PointType, info.extraInfo, info)
    if allianceCityPointInfo ~= nil then
      local pointId = info.mainIndex
      local cityId = allianceCityPointInfo.cityId
      local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, cityId)
      if cityTemplate ~= nil then
        local tileX = cityTemplate.size
        local tileY = cityTemplate.size
        local maxDurability = cityTemplate:getValue("wall")
        local durability = allianceCityPointInfo.durability
        local lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime
        local cityRecoverSpeed = cityTemplate:getValue("wall_recover")
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local addNum = (curTime - lastDurabilityTime) * toInt(cityRecoverSpeed)
        local realDurabilityNum = durability + math.max(addNum, 0)
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
  if self.data ~= nil and self.serverData ~= nil then
    if self.data.type == WorldAllianceCityType.King or self.data.type == WorldAllianceCityType.Canon then
      local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.data.uuid)
      if pointInfo ~= nil then
        local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
        if allianceCityPointInfo ~= nil then
          local timeOpen = allianceCityPointInfo.openTime
          local timeEnd = allianceCityPointInfo.protectTime
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
          local warDuration = LuaEntry.DataConfig:TryGetNum("alliance_declare_war", "k4", 2)
          local recoverTime = self.serverData.battleStartTime / 1000 + warDuration * 3600
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
  if self.data and self.data.isGivingUp then
    self.state = AllianceCityShowTimeState.GiveUp
    self.endTime = self.data.givingUpEndTime / 1000
  end
  if self.state == AllianceCityShowTimeState.Recover then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("new_city_activity_battle_tips1036") .. ": "
  elseif self.state == AllianceCityShowTimeState.UnAttack then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("300701") .. ": "
  elseif self.state == AllianceCityShowTimeState.Lock then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("372111", "")
  elseif self.state == AllianceCityShowTimeState.GiveUp then
    self.time_obj:SetActive(true)
    self.timeStr = Localization:GetString("393058", "")
  else
    self.time_obj:SetActive(false)
  end
  self.time_desc:SetText(self.timeStr)
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

local function RefreshData(self, data)
  self.serverData = data
  if self.serverData ~= nil then
    self:CheckRewardItem()
    self:CheckCurTime()
    self:UpdateTime()
    self:RefreshHpBar()
    self:RefreshAllianceScore(self.serverData)
    self:CheckShowScoreOrBuildDesc()
    self:RefreshAssistance(self.serverData)
  end
end

function UIWorldSiegePointInfo:OnAssistanceDetailInfo(pointId)
  if not self.data then
    return
  end
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.data.pointId then
    WorldBattleUtil.TryRequestCityInfo(self.data.cityId)
  end
end

local function CheckFirstOccupy(self)
  if self.serverData ~= nil and self.serverData.firstOccupyInfo ~= nil then
    if self.serverData.firstOccupyInfo.firstOccupyTime ~= nil and self.serverData.firstOccupyInfo.firstOccupyTime > 0 and self.data ~= nil and self.data.state == AllianceCityState.NEUTRAL then
      local nameStr = Localization:GetString("100206") .. "(" .. Localization:GetString("302131") .. ")"
      self.city_alliance_name:SetText(nameStr)
    end
    if self.serverData.firstOccupyInfo.alAbbr ~= nil and self.serverData.firstOccupyInfo.alAbbr ~= "" then
      self.first_occupy_obj:SetActive(true)
      local nameStr = "[" .. self.serverData.firstOccupyInfo.alAbbr .. "]" .. self.serverData.firstOccupyInfo.alName
      self.first_occupy_name:SetText(nameStr)
      local second = 0
      if self.serverData.firstOccupyInfo.firstOccupyTime > 0 then
        second = math.floor(self.serverData.firstOccupyInfo.firstOccupyTime / 1000)
      end
      local timeStr = UITimeManager:GetInstance():GetTimeToMD(second)
      self.first_occupy_data:SetText(Localization:GetString("300728", timeStr))
      return
    end
  end
  self.first_occupy_obj:SetActive(false)
end

local function CheckRewardItem(self)
  if self.serverData ~= nil then
    local firstOccupyInfo
    if LuaEntry.Player:AtHomeNow() then
      firstOccupyInfo = self.serverData.firstOccupyInfo
    else
      firstOccupyInfo = self.serverData.firstCrossOccupyInfo
    end
    if firstOccupyInfo ~= nil then
      if firstOccupyInfo.firstOccupyTime ~= nil and firstOccupyInfo.firstOccupyTime > 0 then
        self.reward_item:SetActive(false)
      end
      if firstOccupyInfo.alAbbr ~= nil and firstOccupyInfo.alAbbr ~= "" then
        self.reward_item:SetActive(false)
      end
    end
  end
end

local function RefreshOccupyHistory(self, serverData)
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

function UIWorldSiegePointInfo:RefreshAssistance(info)
  if not self.dCompAssistance or not self.dCompAssistance2 then
    return
  end
  local usedComp2 = self.data.type == WorldAllianceCityType.Canon
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

function UIWorldSiegePointInfo:ReAutoFitUI()
end

local function OnInfoClick(self)
  local desc = GetTableData("lw_worldcity", self.data.cityId, "desc")
  if not string.IsNullOrEmpty(desc) then
    self.des_txt:SetLocalText(desc)
    self.detail_title:SetActive(false)
  end
  self.main_obj_canvas:SetAlpha(0)
  self.des_obj_canvas:SetAlpha(1)
  if self.data.type == WorldAllianceCityType.Canon then
    if self.BatteryRoot then
      self.BatteryRoot:OnInfoClick()
    end
    return
  end
  self.des_obj:SetActive(true)
end

local function OnReturnClick(self)
  self.main_obj_canvas:SetAlpha(1)
  self.des_obj_canvas:SetAlpha(0)
  if self.data.type == WorldAllianceCityType.Canon then
    if self.BatteryRoot then
      self.BatteryRoot:OnReturnClick()
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
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.city_add_num_des_btn.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("302015")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnAllianceScoreRankDesClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.allianceScoreInfoBtn.transform.position + Vector3.New(0, -30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("302307")
  param.dir = UIHeroTipView.Direction.BELOW
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

UIWorldSiegePointInfo.OnCreate = OnCreate
UIWorldSiegePointInfo.OnDestroy = OnDestroy
UIWorldSiegePointInfo.OnEnable = OnEnable
UIWorldSiegePointInfo.OnDisable = OnDisable
UIWorldSiegePointInfo.ComponentDefine = ComponentDefine
UIWorldSiegePointInfo.ComponentDestroy = ComponentDestroy
UIWorldSiegePointInfo.DataDefine = DataDefine
UIWorldSiegePointInfo.DataDestroy = DataDestroy
UIWorldSiegePointInfo.RefreshData = RefreshData
UIWorldSiegePointInfo.OnReturnClick = OnReturnClick
UIWorldSiegePointInfo.OnInfoClick = OnInfoClick
UIWorldSiegePointInfo.InitData = InitData
UIWorldSiegePointInfo.CheckCurTime = CheckCurTime
UIWorldSiegePointInfo.UpdateTime = UpdateTime
UIWorldSiegePointInfo.SetRewardCellDestroy = SetRewardCellDestroy
UIWorldSiegePointInfo.CheckFirstOccupy = CheckFirstOccupy
UIWorldSiegePointInfo.OnAllianceClick = OnAllianceClick
UIWorldSiegePointInfo.SetKillRewardDestroy = SetKillRewardDestroy
UIWorldSiegePointInfo.SetOccupyRewardDestroy = SetOccupyRewardDestroy
UIWorldSiegePointInfo.OnClickOccupyHistory = OnClickOccupyHistory
UIWorldSiegePointInfo.RefreshOccupyHistory = RefreshOccupyHistory
UIWorldSiegePointInfo.OnDesClick = OnDesClick
UIWorldSiegePointInfo.OnClickDeclareWarList = OnClickDeclareWarList
UIWorldSiegePointInfo.RefreshHpBar = RefreshHpBar
UIWorldSiegePointInfo.RefreshAllianceScore = RefreshAllianceScore
UIWorldSiegePointInfo.SwitchAllianceScore = SwitchAllianceScore
UIWorldSiegePointInfo.SetAllianceScoreCellsDestroy = SetAllianceScoreCellsDestroy
UIWorldSiegePointInfo.OnAllianceScoreRankDesClick = OnAllianceScoreRankDesClick
UIWorldSiegePointInfo.CheckShowScoreOrBuildDesc = CheckShowScoreOrBuildDesc
UIWorldSiegePointInfo.CheckRewardItem = CheckRewardItem
return UIWorldSiegePointInfo
