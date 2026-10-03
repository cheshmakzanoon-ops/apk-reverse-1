local UILWSeasonRainforestKingBattleView = BaseClass("UILWSeasonRainforestKingBattleView", UIBaseView)
local base = UIBaseView
local RewardUtil = require("Util.RewardUtil")
local FetchHeroEventCfgInfo = require("Net.Msgs.FetchHeroEventCfgInfoMessage")
local UIGray = CS.UIGray
local debugMode = false
local Localization = CS.GameEntry.Localization
local CityItem = require("UI.LWSeason6.UILWSeasonRainforestKingBattle.Component.UILWSeasonRainforestKingBattleItem")
local PlayerRewardV2 = require("UI.LWSeason6.UILWSeasonRainforestKingBattle.Component.UILWSeasonRainforestKingPlayerRewardV2")
local PopupPanel = require("UI.LWSeason6.UILWSeasonRainforestKingBattle.Component.UILWSeasonRainforestKingItemPopup")
local text_title_path = "Root/TopBar/TextTitle"
local title_text_path = "Root/TopBar/TitleText"
local tick_path = "Root/TopBar/Tick"
local tick_time_path = "Root/TopBar/Tick/bg/TickTime"
local btn_rank1_path = "Root/TopBar/BtnRank1"
local btn_rank_text1_path = "Root/TopBar/BtnRank1/BtnRankText1"
local btn_rank2_path = "Root/TopBar/BtnRank2"
local btn_rank_text2_path = "Root/TopBar/BtnRank2/BtnRankText2"
local progress_path = "Root/TopBar/progress"
local zone_root_path = "Root/TopBar/ZoneRoot"
local house1_path = "Root/TopBar/ZoneRoot/House1"
local house2_path = "Root/TopBar/ZoneRoot/House2"
local house3_path = "Root/TopBar/ZoneRoot/House3"
local house4_path = "Root/TopBar/ZoneRoot/House4"
local house5_path = "Root/TopBar/ZoneRoot/House5"
local house6_path = "Root/TopBar/ZoneRoot/House6"
local house7_path = "Root/TopBar/ZoneRoot/House7"
local house8_path = "Root/TopBar/ZoneRoot/House8"
local house9_path = "Root/TopBar/ZoneRoot/House9"
local btn_back_path = "Root/BottomBar/BtnBack"
local pop_up_root_path = "Root/TopBar/ZoneRoot/PopUpRoot"
local event_blocker_path = "Root/EventBlocker"
local loading_path = "Root/TopBar/loading"
local banner_path = "Root/banner"
local battle_step1_path = "Root/TopBar/progress/battleStep1"
local battle_step2_path = "Root/TopBar/progress/battleStep2"
local battle_step3_path = "Root/TopBar/progress/battleStep3"
local battle_step4_path = "Root/TopBar/progress/battleStep4"
local battle_step5_path = "Root/TopBar/progress/battleStep5"
local score_player_reward_s6_path = "Root/ScorePlayerRewardS6"
local RainforestKingCityId = {
  321,
  332,
  343,
  1059,
  1103,
  1088,
  1823,
  1834,
  1845
}

function UILWSeasonRainforestKingBattleView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:InitData()
  self.mySourceServerId = LuaEntry.Player:GetSourceServerId()
  self.cityId, self.cityPos = SeasonUtil.GetKingCityId(self.mySourceServerId)
  self.text_title:SetLocalText("season_s6_activity_1200116_name")
  self.btn_rank1:SetActive(true)
  self.btn_rank2:SetActive(true)
  self.btn_rank_text1:SetLocalText("war_zone_outpost_93")
  self.btn_rank_text2:SetLocalText("390040")
  self.btn_rank1:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
    local msg = Localization:GetString("season_s6_activity_1200116_rule")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
  self.btn_rank2:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRainforestKingBattleRank, {anim = true, playEffect = false})
  end)
  self.battle_step1:SetOnClick(function()
    self:ShowStageInfo(1, self.battle_step1)
  end)
  self.battle_step2:SetOnClick(function()
    self:ShowStageInfo(2, self.battle_step2)
  end)
  self.battle_step3:SetOnClick(function()
    self:ShowStageInfo(3, self.battle_step3)
  end)
  self.battle_step4:SetOnClick(function()
    self:ShowStageInfo(4, self.battle_step4)
  end)
  self.battle_step5:SetOnClick(function()
    self:ShowStageInfo(5, self.battle_step5)
  end)
  self.house1:SetMapIndex(1, RainforestKingCityId[1], self.attackActData, self.pop_up_root)
  self.house2:SetMapIndex(2, RainforestKingCityId[2], self.attackActData, self.pop_up_root)
  self.house3:SetMapIndex(3, RainforestKingCityId[3], self.attackActData, self.pop_up_root)
  self.house4:SetMapIndex(4, RainforestKingCityId[4], self.attackActData, self.pop_up_root)
  self.house5:SetMapIndex(5, 0, nil, nil)
  self.house6:SetMapIndex(6, RainforestKingCityId[6], self.attackActData, self.pop_up_root)
  self.house7:SetMapIndex(7, RainforestKingCityId[7], self.attackActData, self.pop_up_root)
  self.house8:SetMapIndex(8, RainforestKingCityId[8], self.attackActData, self.pop_up_root)
  self.house9:SetMapIndex(9, RainforestKingCityId[9], self.attackActData, self.pop_up_root)
  local data = DataCenter.SeasonRainforestKingBattleManager:GetBattleInfo(true, true)
  self:UpdateData(data)
end

function UILWSeasonRainforestKingBattleView:ShowStageInfo(index, btn)
  self.pop_up_root:SetActive(false)
  self.event_blocker:SetActive(false)
  if self.timeDataList == nil or btn == nil or index > #self.timeDataList then
    return
  end
  local stage = self.timeDataList[index]
  if stage == nil or stage.index ~= index then
    return
  end
  local title
  local timeStartStr = UITimeManager:GetInstance():GetServerTimeByUTC(stage.start_time, false, false)
  local msg = Localization:GetString("110129", "\n" .. timeStartStr)
  UIUtil.ShowButtonTips(btn, title, msg, true)
end

function UILWSeasonRainforestKingBattleView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingBattleView:OnEnable()
  base.OnEnable(self)
  if self.destroyRewardId ~= nil and self.destroyRewardId ~= "" and self.destroyRewardId ~= "nil" then
    DataCenter.ClientRewardToServerDataManager:GetRewardById(self.destroyRewardId, 20260212)
  end
end

function UILWSeasonRainforestKingBattleView:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonRainforestKingBattleView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEventDataUpdate, self.OnHeroEventInfoUpdate)
  self:AddUIListener(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventInfoUpdate)
  self:AddUIListener(EventId.RainforestKingBattleInfoUpdate, self.OnActivityInfoUpdate)
  self:AddUIListener(EventId.CommonGetServerReward, self.OnGetRewardDetail)
  self:AddUIListener(EventId.HeroEventClaimBoxReward, self.OnHeroEventInfoUpdate)
end

function UILWSeasonRainforestKingBattleView:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroEventDataUpdate, self.OnHeroEventInfoUpdate)
  self:RemoveUIListener(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventInfoUpdate)
  self:RemoveUIListener(EventId.RainforestKingBattleInfoUpdate, self.OnActivityInfoUpdate)
  self:RemoveUIListener(EventId.CommonGetServerReward, self.OnGetRewardDetail)
  self:RemoveUIListener(EventId.HeroEventClaimBoxReward, self.OnHeroEventInfoUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonRainforestKingBattleView:ComponentDefine()
  self.playerReward = self:AddComponent(PlayerRewardV2, score_player_reward_s6_path)
  self.banner = self:AddComponent(UIButton, banner_path)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.tick = self:AddComponent(UIImage, tick_path)
  self.tick_time = self:AddComponent(UITextMeshProUGUIEx, tick_time_path)
  self.btn_rank1 = self:AddComponent(UIButton, btn_rank1_path)
  self.btn_rank_text1 = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text1_path)
  self.btn_rank2 = self:AddComponent(UIButton, btn_rank2_path)
  self.btn_rank_text2 = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text2_path)
  self.progress = self:AddComponent(UISlider, progress_path)
  self.battle_step1 = self:AddComponent(UIButton, battle_step1_path)
  self.battle_step2 = self:AddComponent(UIButton, battle_step2_path)
  self.battle_step3 = self:AddComponent(UIButton, battle_step3_path)
  self.battle_step4 = self:AddComponent(UIButton, battle_step4_path)
  self.battle_step5 = self:AddComponent(UIButton, battle_step5_path)
  self.zone_root = self:AddComponent(UIBaseContainer, zone_root_path)
  self.house1 = self:AddComponent(CityItem, house1_path)
  self.house2 = self:AddComponent(CityItem, house2_path)
  self.house3 = self:AddComponent(CityItem, house3_path)
  self.house4 = self:AddComponent(CityItem, house4_path)
  self.house5 = self:AddComponent(CityItem, house5_path)
  self.house6 = self:AddComponent(CityItem, house6_path)
  self.house7 = self:AddComponent(CityItem, house7_path)
  self.house8 = self:AddComponent(CityItem, house8_path)
  self.house9 = self:AddComponent(CityItem, house9_path)
  self.pop_up_root = self:AddComponent(PopupPanel, pop_up_root_path)
  self.event_blocker = self:AddComponent(UIButton, event_blocker_path)
  self.event_blocker:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
  end)
  self.pop_up_root:SetActive(false)
  self.event_blocker:SetActive(false)
  self.pop_up_root:SetBlocker(self.event_blocker)
  self.banner:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
  end)
end

function UILWSeasonRainforestKingBattleView:ComponentDestroy()
  self.banner = nil
  self.text_title = nil
  self.title_text = nil
  self.tick = nil
  self.tick_time = nil
  self.btn_rank1 = nil
  self.btn_rank_text1 = nil
  self.btn_rank2 = nil
  self.btn_rank_text2 = nil
  self.progress = nil
  self.battle_step1 = nil
  self.battle_step2 = nil
  self.battle_step3 = nil
  self.battle_step4 = nil
  self.battle_step5 = nil
  self.house1 = nil
  self.house2 = nil
  self.house3 = nil
  self.house4 = nil
  self.house5 = nil
  self.house6 = nil
  self.house7 = nil
  self.house8 = nil
  self.house9 = nil
  self.btn_back = nil
  self.pop_up_root = nil
  self.event_blocker = nil
  self.loading = nil
  self.playerReward = nil
end

function UILWSeasonRainforestKingBattleView:OnGetRewardDetail(data)
  if data.type == 20260212 and self.destroyRewardId then
    self.playerReward:SetRewardDetail(data, self.destroyRewardId)
  end
end

function UILWSeasonRainforestKingBattleView:Update1000MS()
  local remainTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.battleStartTime and curTime < self.battleStartTime then
    remainTime = self.battleStartTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      return
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
    end
  end
  if self.battleEndTime and curTime < self.battleEndTime then
    remainTime = self.battleEndTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      return
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
    end
  else
    self.tick:SetActive(false)
    self.tick_time:SetText("--:--:--")
    self.title_text:SetLocalText("activity_endalerttips1")
  end
end

function UILWSeasonRainforestKingBattleView:OnHeroEventInfoUpdate()
  local data = DataCenter.SeasonRainforestKingBattleManager:GetBattleInfo(false, false)
  if data then
    self:UpdateData(data)
  end
end

function UILWSeasonRainforestKingBattleView:OnActivityInfoUpdate()
  local data = DataCenter.SeasonRainforestKingBattleManager:GetBattleInfo(false, false)
  if data then
    self:UpdateData(data)
  end
end

function UILWSeasonRainforestKingBattleView:InitData()
  local now = UITimeManager:GetInstance():GetServerTime()
  self.actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonRainforestKingBattle.Type)
  if debugMode and self.actData == nil then
    self.actData = {
      para = "4",
      startTime = now - 2 * OneDayTime * 1000,
      endTime = now + 28 * OneDayTime * 1000,
      para_2 = "109021711"
    }
  end
  if self.actData == nil then
    return
  end
  if self.actData.para_2 == nil or self.actData.para_2 == "" then
    self.actData.para_2 = "109021711"
  end
  if self.actData.para_1 then
    local heroEventIdList = string.split_ii_array(self.actData.para_1, "|")
    for _, heroEventId in ipairs(heroEventIdList) do
      FetchHeroEventCfgInfo.GetCfgInfo(heroEventId, true)
    end
  end
  self.destroyRewardId = tostring(self.actData.para_2)
  self.attackActData = self.actData
  local startTime = UITimeManager:GetInstance():WeekZero(self.actData.startTime)
  local cycleCount = toInt(self.actData.para)
  local dataList = {}
  local battleMaxTime = DataCenter.SeasonRainforestKingBattleManager:TryGetNum("k1", 14400) * 1000
  local battleDay, battleStartTime = DataCenter.SeasonRainforestKingBattleManager:GetBattleStartTime()
  local battleTimeOffset = (battleDay - 1) * OneDayTime * 1000 + battleStartTime
  local oneWeek = OneWeekTime * 1000
  for i = 1, cycleCount do
    local stage_start_time = startTime + (i - 1) * oneWeek
    table.insert(dataList, {
      index = i,
      start_time = stage_start_time,
      end_time = stage_start_time + oneWeek,
      battle_start_time = stage_start_time + battleTimeOffset,
      battle_end_time = stage_start_time + battleTimeOffset + battleMaxTime
    })
  end
  self.timeDataList = dataList
end

function UILWSeasonRainforestKingBattleView:UpdateData(battleInfo)
  local activeIndex = 0
  local heroEventData
  local heroEventUserData = {
    score = 0,
    scoreRewardIndex = {}
  }
  if battleInfo then
    heroEventData = FetchHeroEventCfgInfo.GetCfgInfo(battleInfo.heroEventId, true)
    heroEventUserData = RewardUtil.FetchHeroEventData(battleInfo.curUuid) or {
      score = 0,
      scoreRewardIndex = {}
    }
  end
  self.battleInfo = battleInfo
  if self.timeDataList then
    local now = UITimeManager:GetInstance():GetServerTime()
    self.battleStartTime = nil
    self.battleEndTime = nil
    self.nextStageTime = nil
    self.playerReward:ShowScore(false)
    for k, v in ipairs(self.timeDataList) do
      if now > v.start_time and now <= v.end_time then
        if now < v.battle_start_time then
          self.battleStartTime = v.battle_start_time
          self.battleEndTime = v.battle_end_time
        elseif now < v.battle_end_time then
          self.playerReward:ShowScore(true)
          self.battleStartTime = v.battle_start_time
          self.battleEndTime = v.battle_end_time
        else
          self.playerReward:ShowScore(true)
          local nextData = self.timeDataList[k + 1]
          if nextData ~= nil then
            self.nextStageTime = nextData.start_time
          end
        end
        activeIndex = k
        break
      end
    end
    self:Update1000MS()
  end
  if battleInfo == nil or self.timeDataList == nil then
    self.tick:SetActive(false)
    self.progress:SetActive(false)
    self.title_text:SetText("")
    self.zone_root:SetActive(false)
    self.btn_rank1:SetActive(true)
    self.btn_rank2:SetActive(false)
    self.loading:SetActive(true)
    return
  end
  local max_battle_count = #self.timeDataList
  local now = UITimeManager:GetInstance():GetServerTime()
  for i = 1, 5 do
    local battle_step_node = self["battle_step" .. i]
    if battle_step_node then
      battle_step_node:SetActive(i <= max_battle_count)
      if i == activeIndex then
        battle_step_node:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar03.png")
        battle_step_node:SetSizeDeltaXY(70, 70)
      else
        battle_step_node:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar04.png")
        battle_step_node:SetSizeDeltaXY(48, 48)
      end
    end
  end
  self.progress:SetValue((activeIndex - 1) / (max_battle_count - 1))
  self.house1:ReInit(self.battleStartTime, self.battleEndTime)
  self.house2:ReInit(self.battleStartTime, self.battleEndTime)
  self.house3:ReInit(self.battleStartTime, self.battleEndTime)
  self.house4:ReInit(self.battleStartTime, self.battleEndTime)
  self.house6:ReInit(self.battleStartTime, self.battleEndTime)
  self.house7:ReInit(self.battleStartTime, self.battleEndTime)
  self.house8:ReInit(self.battleStartTime, self.battleEndTime)
  self.house9:ReInit(self.battleStartTime, self.battleEndTime)
  self.loading:SetActive(false)
  self.zone_root:SetActive(true)
  self.btn_rank1:SetActive(true)
  self.btn_rank2:SetActive(true)
  if heroEventData ~= nil then
    self.playerReward:SetActive(true)
    self.playerReward:ReInit(self.attackActData, heroEventData, heroEventUserData, self.battleStartTime)
  else
    self.playerReward:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.progress.rectTransform)
end

return UILWSeasonRainforestKingBattleView
