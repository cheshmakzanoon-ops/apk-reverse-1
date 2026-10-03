local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local LWSeasonAttackSnowCityMain = BaseClass("LWSeasonAttackSnowCityMain", base)
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local Localization = CS.GameEntry.Localization
local city_icon_path = "RightView/icon/CityIcon"
local title_path = "RightView/Top/title"
local sub_title_path = "RightView/Top/subTitle"
local info_btn_path = "RightView/Top/InfoBtn"
local time_content_path = "RightView/Top/TimeBg"
local time_title_path = "RightView/icon/TimeBg/TimeTitle"
local remain_time_path = "RightView/icon/TimeBg/remainTime"
local rank_btn_path = "RightView/Top/RankBtn"
local gift_btn_path = "RightView/Top/GiftBtn"
local gift_text_path = "RightView/Top/GiftBtn/GiftIcon/GiftText"
local task_title_path = "RightView/Bottom/GameObject/TaskTitle"
local item_path = "RightView/Bottom/GameObject/Item"
local content_path = "RightView/Bottom/GameObject/ScrollView/Viewport/Content"
local building_path = "RightView/BottomAttack/GameObject/Build/building"
local bottom_path = "RightView/Bottom"
local bottom_attack_path = "RightView/BottomAttack"
local attack_title_path = "RightView/BottomAttack/AttackTitle"
local attack_city_icon_path = "RightView/BottomAttack/GameObject/Build/building/AttackCityIcon"
local text_path = "RightView/BottomAttack/GameObject/Build/Pos/Text"
local attack_detail_path = "RightView/BottomAttack/GameObject/Info/AttackDetail"
local scroll_view_path = "RightView/BottomAttack/GameObject/Info/ScrollView"
local content_attack_path = "RightView/BottomAttack/GameObject/Info/ScrollView/Viewport/ContentAttack"
local btn_jump_path = "RightView/BottomAttack/BtnJump"
local pos_path = "RightView/BottomAttack/GameObject/Build/Pos"
local red_point_path = "RightView/Top/GiftBtn/RedPoint"
local red_point_jump_path = "RightView/BottomAttack/BtnJump/RedPointJump"
local openTime_path = "RightView/Top/TimeBg/openTime"
local allianceInfo_path = "RightView/Top/allianceInfo"
local allianceName_path = "RightView/Top/allianceInfo/allianceName"
local allianceNum_path = "RightView/Top/allianceInfo/allianceNum"
local allianceAddContent_path = "RightView/Top/allianceAddContent"
local allianceAddTxt_path = "RightView/Top/allianceAddContent/allianceAddTxt"
local addAllianceBtn_path = "RightView/Top/allianceAddContent/allianceAddTxt/addAllianceBtn"
local season_path = "RightView/Season"
local season_title_path = "RightView/Season/season_title"
local season_city_info_path = "RightView/Season/season_cityInfo"
local season_reward_root_path = "RightView/Season/season_reward_root"
local season_reward_path = "RightView/Season/season_reward_root/season_reward"
local season_reward_count_path = "RightView/Season/season_reward_root/season_reward_count"
local season_reward_icon_path = "RightView/Season/season_reward_root/icon/season_reward_icon"
local season1_path = "RightView/Season1"
local season1_attack_title_path = "RightView/Season1/attack_title"
local season1_attack_time_path = "RightView/Season1/attack_time"
local season1_attack_city_icon_path = "RightView/Season1/AttackInfoRoot/attack_icon"
local season1_attack_city_name_path = "RightView/Season1/AttackInfoRoot/attack_name"
local season1_text_path = "RightView/Season1/AttackInfoRoot/Pos/attack_pos"
local season1_btn_attack_go_path = "RightView/Season1/AttackInfoRoot/BtnAttackGo"
local bg_path = "Mask/Bg"
local city_name_path = "RightView/Season1/cityName"
local season_stone_root_path = "RightView/Season/season_stone_root"
local season_stone_txt_path = "RightView/Season/season_stone_root/season_stone_txt"
local season_stone_icon_path = "RightView/Season/season_stone_root/icon/season_stone_icon"
local season_stone_count_path = "RightView/Season/season_stone_root/season_stone_count"
local needShowRedPoint = true
local ActivityState = {
  BeforeBattle = 1,
  InBattle = 2,
  AfterBattle = 3
}

function LWSeasonAttackSnowCityMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonAttackSnowCityMain:OnDestroy()
  DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SeasonCityWar, false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonAttackSnowCityMain:ComponentDefine()
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.title = self:AddComponent(UIText, title_path)
  self.sub_title = self:AddComponent(UIText, sub_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.time_content = self:AddComponent(UIBaseContainer, time_content_path)
  self.time_title = self:AddComponent(UIText, time_title_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetActive(false)
  self.detail_btn = self:AddComponent(UIButton, gift_btn_path)
  self.detail_text = self:AddComponent(UIText, gift_text_path)
  self.task_title = self:AddComponent(UIText, task_title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.detail_text:SetLocalText("456505")
  self.task_title:SetLocalText("456504")
  self.city_icon = self:AddComponent(UIRawImage, city_icon_path)
  self.theItem = self.transform:Find(item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.info_btn:SetOnClick(function()
    self:OnHelpBtnClick()
  end)
  self.detail_btn:SetOnClick(function()
    if needShowRedPoint then
      needShowRedPoint = false
      EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
    end
    self.red_point:SetActive(false)
    self:OnBtnDetailClick()
  end)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.bottom_attack = self:AddComponent(UIBaseContainer, bottom_attack_path)
  self.attack_title = self:AddComponent(UIText, attack_title_path)
  self.cityAttack = self:AddComponent(UIImage, attack_city_icon_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.attack_detail = self:AddComponent(UIText, attack_detail_path)
  self.scroll_view = self:AddComponent(UIImage, scroll_view_path)
  self.content_attack = self:AddComponent(UIBaseContainer, content_attack_path)
  self.building = self:AddComponent(UIButton, building_path)
  self.btn_jump = self:AddComponent(UIButton, btn_jump_path)
  self.pos = self:AddComponent(UIButton, pos_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point_jump = self:AddComponent(UIImage, red_point_jump_path)
  self.btn_jump:SetOnClick(function()
    self:JumpTo()
  end)
  self.building:SetOnClick(function()
    self:JumpTo()
  end)
  self.pos:SetOnClick(function()
    self:JumpTo()
  end)
  self.red_point:SetActive(needShowRedPoint and LWSeasonAttackSnowCityMain.ExistDeclareWar())
  self.red_point_jump:SetActive(false)
  self.openActivityTime = self:AddComponent(UIText, openTime_path)
  self.allianceInfo = self:AddComponent(UIBaseContainer, allianceInfo_path)
  self.allianceName = self:AddComponent(UIText, allianceName_path)
  self.allianceNum = self:AddComponent(UIText, allianceNum_path)
  self.allianceAddContent = self:AddComponent(UIBaseContainer, allianceAddContent_path)
  self.allianceAddTxt = self:AddComponent(UIText, allianceAddTxt_path)
  self.addAllianceBtn = self:AddComponent(UIButton, addAllianceBtn_path)
  self.addAllianceBtn:SetOnClick(function()
    self:OnAddAllianceBtnClick()
  end)
  self.allianceInfo:SetActive(false)
  self.allianceAddContent:SetActive(false)
  self.season = self:AddComponent(UIBaseContainer, season_path)
  self.season_title = self:AddComponent(UIText, season_title_path)
  self.season_city_info = self:AddComponent(UIText, season_city_info_path)
  self.season_reward_root = self:AddComponent(UIBaseContainer, season_reward_root_path)
  self.season_reward = self:AddComponent(UIText, season_reward_path)
  self.season_reward_count = self:AddComponent(UIText, season_reward_count_path)
  self.season_reward_icon = self:AddComponent(UIButton, season_reward_icon_path)
  self.season_reward_icon:SetOnClick(function()
    self:OnRewardShowClick()
  end)
  self.season1 = self:AddComponent(UIBaseContainer, season1_path)
  self.season1_attack_title = self:AddComponent(UIText, season1_attack_title_path)
  self.season1_attack_time = self:AddComponent(UIText, season1_attack_time_path)
  self.season1_attack_city_icon = self:AddComponent(UIImage, season1_attack_city_icon_path)
  self.season1_attack_city_name = self:AddComponent(UIText, season1_attack_city_name_path)
  self.season1_text = self:AddComponent(UITextMeshProUGUIEx, season1_text_path)
  self.season1_btn_attack_go = self:AddComponent(UIButton, season1_btn_attack_go_path)
  self.city_name = self:AddComponent(UIText, city_name_path)
  self.season1_btn_attack_go:SetOnClick(function()
    self:OnGotoBtnClick()
  end)
  self.season1:SetActive(false)
  self.season_stone_root = self:AddComponent(UIBaseContainer, season_stone_root_path)
  self.season_stone_icon = self:AddComponent(UIButton, season_stone_icon_path)
  self.season_stone_count = self:AddComponent(UITextMeshProUGUIEx, season_stone_count_path)
  self.season_stone_txt = self:AddComponent(UITextMeshProUGUIEx, season_stone_txt_path)
  self.season_stone_icon:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.isLocal = true
    param.desc = DataCenter.ResourceManager:GetResourceDescByType(ResourceType.AllianceStone)
    param.alignObject = self.season_stone_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
  self.season_stone_txt:SetText(Localization:GetString("season_s2_city_description_08") .. ":")
  self:RefreshActivityState()
end

function LWSeasonAttackSnowCityMain:OnGotoBtnClick()
  if self.thePreDeclareCity ~= nil then
    local cityPos = self.thePreDeclareCity.pos
    if cityPos ~= nil and cityPos.x ~= nil and cityPos.y ~= nil then
      local SourceServerId = LuaEntry.Player:GetSourceServerId()
      local v3 = SceneUtils.TileToWorld(cityPos, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, nil, nil, nil, SourceServerId)
    end
  end
end

function LWSeasonAttackSnowCityMain:OnRewardShowClick()
  local param = UIRewardTipView.ParamDataClass.New()
  param.position = self.season_reward_icon:GetPosition()
  local _screenPos = PosConverse.UIWorldToScreenPos(param.position)
  local ScreenSize = CS.UnityEngine.Screen
  if _screenPos.x * 2 < ScreenSize.width then
    param.deltaX = 30
    param.dir = UIRewardTipView.Direction.LEFT
  else
    param.deltaX = -30
    param.dir = UIRewardTipView.Direction.RIGHT
  end
  param.rewardList = DataCenter.SeasonDataManager:GetLootRewardList()
  param.totalVal = 0
  if param.rewardList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardTip, {anim = false}, param)
  end
end

function LWSeasonAttackSnowCityMain:JumpTo()
  if self.cityPos ~= nil and self.cityPos.x ~= nil and self.cityPos.y ~= nil then
    local SourceServerId = LuaEntry.Player:GetSourceServerId()
    local v3 = SceneUtils.TileToWorld(self.cityPos, ForceChangeScene.World)
    if self.cityInfo then
      UIUtil.GetTodayActiveCount("SeasonAttackCity" .. self.cityInfo.id, true)
      EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossAttackCityInfo)
    end
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(v3, nil, nil, nil, SourceServerId)
  end
end

function LWSeasonAttackSnowCityMain:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content_attack:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.city_name = nil
  self.title = nil
  self.sub_title = nil
  self.info_btn = nil
  self.time_content = nil
  self.time_title = nil
  self.remain_time = nil
  self.detail_btn = nil
  self.detail_text = nil
  self.task_title = nil
  self.content = nil
  self.theItem = nil
  self.openActivityTime = nil
  self.allianceInfo = nil
  self.allianceName = nil
  self.allianceNum = nil
  self.allianceAddContent = nil
  self.allianceAddTxt = nil
  self.addAllianceBtn = nil
  self.season1 = nil
  self.season1_attack_title = nil
  self.season1_attack_time = nil
  self.season1_attack_city_icon = nil
  self.season1_attack_city_name = nil
  self.season1_text = nil
  self.season1_btn_attack_go = nil
  self.season_stone_root = nil
  self.season_stone_txt = nil
  self.season_stone_icon = nil
  self.season_stone_count = nil
end

function LWSeasonAttackSnowCityMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:AddUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:AddUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:AddUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
end

function LWSeasonAttackSnowCityMain:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.UpdateData)
  self:RemoveUIListener(EventId.RefreshActivityRedDot, self.UpdateData)
  self:RemoveUIListener(EventId.GetActivityDetail, self.UpdateData)
  self:RemoveUIListener(EventId.ActivityAttackCityRankDataUpdate, self.RefreshRankView)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.RefreshRankView)
  base.OnRemoveListener(self)
end

function LWSeasonAttackSnowCityMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.thePreDeclareTime = nil
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.title:SetLocalText(self.activityData.activityName)
  self.sub_title:SetLocalText(self.activityData.desc_info)
  if not string.IsNullOrEmpty(self.activityData.activity_pic) then
    local path = "Assets/Main/TextureEx/Season/Activity/" .. self.activityData.activity_pic .. ".png"
    if CS.GameEntry.Resource:HasAsset(path) then
      self.bg:LoadSprite(path)
    else
      Logger.LogError(path)
    end
  end
  CS.GameEntry.Setting:SetBool("OpenedAttackCity_" .. LuaEntry.Player.uid, true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  if self.openLevel == nil then
    self:RefreshUI()
  end
  SFSNetwork.SendMessage(MsgDefines.GetCityWarRank, self.activityId, -1)
end

function LWSeasonAttackSnowCityMain:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.thePreDeclareTime then
    local remainTime = self.thePreDeclareTime - curTime
    if 0 < remainTime then
      self.season1_attack_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.remain_time:SetActive(false)
      self.time_title:SetActive(false)
      self.openTime = nil
    else
      self.thePreDeclareTime = nil
      self.season1:SetActive(false)
    end
  end
  if not (self.activityData and self.remain_time:GetActive()) or self.openTime == nil then
    return
  end
  local remainTime = self.openTime - curTime
  if 0 < remainTime then
    self.remain_time:SetActive(true)
    self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.remain_time:SetActive(false)
    self.time_title:SetActive(false)
    self.openTime = nil
    if self.sendMsgTime == nil or curTime > self.sendMsgTime + 5000 then
      self.sendMsgTime = curTime
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    end
  end
end

function LWSeasonAttackSnowCityMain:RefreshAttackUI(cityId, dataServer)
  self.bottom:SetActive(false)
  self.bottom_attack:SetActive(true)
  self.attack_title:SetLocalText("456520")
  local dataConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if dataServer == nil or dataServer.alId == nil or dataServer.alId == "" then
    self.scroll_view:SetActive(true)
    self.attack_detail:SetLocalText("456504")
    local extraRewards = DataCenter.RewardManager:ParseRewardsStr(dataConfig.show_reward)
    if extraRewards ~= nil then
      local goItem, theItem
      self.content_attack:RemoveComponents(UICommonResItem)
      self.theItem:GameObjectRecycleAll()
      for i, item in ipairs(extraRewards) do
        local levelName = "item_" .. i
        goItem = self.theItem:GameObjectSpawn(self.content_attack.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content_attack:AddComponent(UICommonResItem, levelName)
        theItem:ReInit(item)
      end
    end
    self.cityAttack:SetActive(true)
    self.cityAttack:LoadSprite(dataConfig:GetIconPath(true))
  else
    local txt1 = "<color=#f97077>[" .. dataServer.alAbbr .. "]" .. dataServer.alName .. "</color>"
    local txt2 = "<color=\"white\">" .. Localization:GetString("456518") .. "</color>"
    self.scroll_view:SetActive(false)
    self.attack_detail:SetText(txt1 .. txt2)
    self.cityAttack:SetActive(true)
    self.cityAttack:LoadSprite(dataConfig:GetIconPath(false))
  end
  self.cityAttack:SetNativeSize()
  if dataConfig ~= nil and dataConfig.pos ~= nil then
    self.text:SetText("<u>(" .. dataConfig.pos.x .. "," .. dataConfig.pos.y .. ")</u>")
  else
    self.text:SetText("")
  end
  self.dataConfig = dataConfig
  self.dataServer = dataServer
  self.cityPos = dataConfig.pos
end

function LWSeasonAttackSnowCityMain:ShowCityInfo(cityInfo)
  self.city_icon:LoadSprite(cityInfo:GetBigIconPath())
  self.season_title:SetText(string.format("<size=65>LV%s.</size>%s", cityInfo.level, Localization:GetString(cityInfo.name)))
  self.season_stone_root:SetActive(toInt(cityInfo.level) < 7)
  local str
  if toInt(cityInfo.force) > 0 then
    str = string.format("<color=#FFECD1>%s: </color>%s", Localization:GetString("season_influence"), string.GetFormattedSeparatorNum(toInt(cityInfo.force)))
  end
  if 0 < toInt(cityInfo.city_resistance_b) then
    if str then
      str = string.format([[
%s
<color=#FFECD1>%s: </color>%s]], str, Localization:GetString("803053"), string.GetFormattedSeparatorNum(toInt(cityInfo.city_resistance_b)))
    else
      str = string.format("<color=#FFECD1>%s: </color>%s", Localization:GetString("803053"), string.GetFormattedSeparatorNum(toInt(cityInfo.city_resistance_b)))
    end
  end
  if cityInfo.temperatureCfg and cityInfo.temperatureCfg.active_temperature_original ~= 0 then
    local msg = Localization:GetString("season_s2_storm_event_20", cityInfo.temperatureCfg.active_temperature_original)
    if str then
      str = string.format([[
%s
<color=#FFECD1>%s</color>]], str, msg)
    else
      str = string.format("<color=#FFECD1>%s</color>", msg)
    end
  end
  self.season_city_info:SetText(str or "")
  if cityInfo.season_snow_stone_value ~= 0 then
    self.season_stone_count:SetLocalText("390968", string.GetFormattedSeparatorNum(cityInfo.season_snow_stone_value))
  end
  self.cityInfo = cityInfo
  if cityInfo.loot_rewards == nil or cityInfo.loot_rewards == 0 then
    self.season_reward_root:SetActive(false)
  else
    self.season_reward_root:SetActive(true)
    self.season_reward:SetText(Localization:GetString("season_world_city_reward_box"))
    self.season_reward_count:SetText("\195\151" .. cityInfo.loot_rewards)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_reward_root.transform)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season.transform)
  if LuaEntry.Player:IsInAlliance() then
    local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. cityInfo.id, false)
    if click_count == 0 then
      self.red_point_jump:SetActive(true)
    end
  end
end

function LWSeasonAttackSnowCityMain:RefreshUI()
  local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
  if state == DeclareWarState.PreDeclare then
    local cityId = toInt(declareInfo.content)
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(cityId)
    self.thePreDeclareTime = protectTime
    self.thePreDeclareCity = cityMeta
    self.season1:SetActive(true)
    self.season:SetActive(false)
    self.season1_attack_title:SetLocalText("season_tips230")
    self.season1_attack_time:SetText("")
    self.city_name:SetText(string.format("<size=65>LV%s.</size>%s", cityMeta.level, Localization:GetString(cityMeta.name)))
  else
    self.season1:SetActive(false)
    self.season:SetActive(true)
  end
  local openLevel = 6
  local openTime = 0
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil and cityWarInfo.nextOpen ~= nil then
    openLevel = cityWarInfo.nextOpen.level or 6
    openTime = cityWarInfo.nextOpen.openTime or 0
    self.time_title:SetLocalText(456503, openLevel)
    self.remain_time:SetActive(true)
    self.time_title:SetActive(true)
    self.openTime = openTime
  else
    openLevel = 6
    self.time_title:SetLocalText(456515, openLevel)
    self.remain_time:SetActive(false)
    self.time_title:SetActive(true)
    self.openActivityTime:SetText("")
  end
  self.openLevel = openLevel
  self.detail_btn:SetActive(true)
  local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
  if DeclareWarDataList ~= nil then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    for _, WarData in ipairs(DeclareWarDataList) do
      if WarData.aId == allianceId then
        local cityId = tonumber(WarData.content)
        local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
        self.bottom:SetActive(false)
        self.bottom_attack:SetActive(true)
        self:RefreshAttackUI(cityId, cityWarInfo.cityInfoList[cityId])
        self:ShowCityInfo(cityInfo)
        return
      end
    end
  end
  local cityInfo = DataCenter.AllianceCityTemplateManager:GetCityByLevel(openLevel)
  self:ShowCityInfo(cityInfo)
  local show_reward = DataCenter.AllianceCityTemplateManager:GetFirstRewardByLevel(openLevel or 6)
  local extraRewards = DataCenter.RewardManager:ParseRewardsStr(show_reward)
  if extraRewards ~= nil then
    local goItem, theItem
    self.content:RemoveComponents(UICommonResItem)
    self.theItem:GameObjectRecycleAll()
    for i, item in ipairs(extraRewards) do
      local levelName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(UICommonResItem, levelName)
      theItem:ReInit(item)
    end
  end
  self.bottom:SetActive(true)
  self.bottom_attack:SetActive(false)
  self:RefreshActivityState()
  self.activityState = ActivityState.AfterBattle
  if self.activityState == ActivityState.AfterBattle then
    self.time_content:SetActive(false)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  elseif self.activityState == ActivityState.BeforeBattle then
    self.time_content:SetActive(true)
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(false)
  else
    self.time_content:SetActive(true)
    self.allianceInfo:SetActive(true)
    self.allianceAddContent:SetActive(true)
  end
  self:RefreshRankView()
  self:Update1000MS()
end

function LWSeasonAttackSnowCityMain:UpdateData()
  self:RefreshUI()
end

function LWSeasonAttackSnowCityMain:OnHelpBtnClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local msg = Localization:GetString(self.activityData.story)
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end
end

function LWSeasonAttackSnowCityMain:OnBtnDetailClick()
  if self.openLevel == 1 then
    UIUtil.ShowTipsId("456522")
  else
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
    SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityDetail)
  end
end

function LWSeasonAttackSnowCityMain.ExistDeclareWar()
  if LuaEntry.Player:IsInAlliance() then
    local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
    if data ~= nil then
      return needShowRedPoint
    end
  end
  return false
end

function LWSeasonAttackSnowCityMain:OnTargetBtnClick()
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil then
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = fightStartTime - curTime
    if 0 < deltaTime then
      UIUtil.ShowTipsId("456551")
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonAttackCityTargetInfo, {anim = true}, self.activityId)
    end
  end
end

function LWSeasonAttackSnowCityMain:RefreshRankView()
  if self.activityState ~= ActivityState.InBattle then
    return
  end
  local allianceuid = LuaEntry.Player.allianceId
  if allianceuid == "" then
    self.allianceInfo:SetActive(false)
    self.allianceAddContent:SetActive(true)
    self.allianceAddTxt:SetLocalText(456550)
  else
    self.allianceInfo:SetActive(true)
    self.allianceAddContent:SetActive(false)
    local rankData = DataCenter.ActivityAttackCityDataManager:GetRankData(self.activityId)
    local rankList = {}
    if rankData ~= nil then
      rankList = rankData.data
    end
    local selfData
    for i = 1, #rankList do
      if rankList[i].aid == allianceuid then
        selfData = rankList[i]
        break
      end
    end
    if selfData == nil then
      local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      self.allianceName:SetText(Localization:GetString(456528) .. " 0")
      self.allianceNum:SetText(Localization:GetString(456549))
    else
      self.allianceName:SetText(Localization:GetString(456528) .. " " .. selfData.score)
      self.allianceNum:SetText(Localization:GetString(456529) .. " " .. selfData.rank)
    end
  end
end

function LWSeasonAttackSnowCityMain:OnAddAllianceBtnClick()
  if LuaEntry.Player:IsInAlliance() == false then
    if LuaEntry.Player:IsFirstJoinAlliance() == true then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      return
    end
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
  end
end

function LWSeasonAttackSnowCityMain:RefreshActivityState()
  self.activityState = self:GetActivityState()
end

function LWSeasonAttackSnowCityMain:GetActivityState()
  local state = ActivityState.AfterBattle
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo ~= nil then
    local fightStartTime = cityWarInfo.fightStartTime
    local fightEndTime = cityWarInfo.fightEndTime
    if fightStartTime == nil then
      fightStartTime = 0
    end
    if fightEndTime == nil then
      fightEndTime = 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if fightStartTime > curTime then
      state = ActivityState.BeforeBattle
    elseif fightEndTime < curTime then
      state = ActivityState.AfterBattle
    else
      state = ActivityState.InBattle
    end
  end
  return state
end

return LWSeasonAttackSnowCityMain
