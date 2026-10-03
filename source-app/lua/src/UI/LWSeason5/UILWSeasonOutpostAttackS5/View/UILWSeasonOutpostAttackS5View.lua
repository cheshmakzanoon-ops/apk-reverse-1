local UILWSeasonOutpostAttackS5View = BaseClass("UILWSeasonOutpostAttackS5View", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local NineNationOutpostId = {
  707,
  711,
  716,
  1022,
  0,
  968,
  1274,
  1279,
  1283
}
local FetchOutpostBattleInfoMessage = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
local CityItem = require("UI.LWSeason5.UILWSeasonOutpostAttackS5.Component.UILWSeasonOutpostAttackS5Item")
local PopupPanel = require("UI.LWSeason5.UILWSeasonOutpostAttackS5.Component.UILWSeasonOutpostAttackS5Popup")
local PlayerReward = require("UI.LWSeason5.UILWSeasonOutpostAttackS5.Component.UILWSeasonOutpostAttackS5PlayerReward")
local panel_path = "panel"
local text_title_path = "Root/TopBar/TextTitle"
local title_text_path = "Root/TopBar/TitleText"
local tick_path = "Root/TopBar/Tick"
local tick_time_path = "Root/TopBar/Tick/bg/TickTime"
local btn_rank1_path = "Root/TopBar/BtnRank1"
local btn_rank_text1_path = "Root/TopBar/BtnRank1/BtnRankText1"
local btn_rank2_path = "Root/TopBar/BtnRank2"
local btn_rank_text2_path = "Root/TopBar/BtnRank2/BtnRankText2"
local progress_path = "Root/TopBar/progress"
local battle_step01_path = "Root/TopBar/progress/progressBg/battleStep01"
local battle_step2_path = "Root/TopBar/progress/progressBg/battleStep2"
local battle_step3_path = "Root/TopBar/progress/progressBg/battleStep3"
local battle_step02_path = "Root/TopBar/progress/progressBg/battleStep02"
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
local scroll_view_path = "Root/ScrollView"
local btn_back_path = "Root/BottomBar/BtnBack"
local pop_up_root_path = "Root/TopBar/ZoneRoot/PopUpRoot"
local event_blocker_path = "Root/EventBlocker"
local loading_path = "Root/TopBar/loading"
local banner_path = "Root/banner"

function UILWSeasonOutpostAttackS5View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.scroll_view:SetVerticalNormalizedPosition(1)
  self.attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
  self.mySourceServerId = LuaEntry.Player:GetSourceServerId()
  self.cityId, self.serverId = SeasonUtil.GetOutpostId(self.mySourceServerId)
  self.text_title:SetLocalText("war_zone_outpost_1")
  self.btn_rank1:SetActive(true)
  self.btn_rank2:SetActive(true)
  self.btn_rank_text1:SetLocalText("war_zone_outpost_93")
  self.btn_rank_text2:SetLocalText("390040")
  self.btn_rank1:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
    local msg = Localization:GetString("war_zone_outpost_90")
    UIUtil.ShowDetail(msg, nil, nil, true, true)
  end)
  self.btn_rank2:SetOnClick(function()
    self.pop_up_root:SetActive(false)
    self.event_blocker:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonOutpostRankS5, {anim = true, playEffect = false})
  end)
  self.battle_step01:SetOnClick(function()
    self:ShowStageInfo(1, self.battle_step01)
  end)
  self.battle_step2:SetOnClick(function()
    self:ShowStageInfo(2, self.battle_step2)
  end)
  self.battle_step3:SetOnClick(function()
    self:ShowStageInfo(3, self.battle_step3)
  end)
  self.battle_step02:SetOnClick(function()
    self:ShowStageInfo(2, self.battle_step02)
  end)
  self.house1:SetMapIndex(1, NineNationOutpostId[1], self.attackActData, self.pop_up_root)
  self.house2:SetMapIndex(2, NineNationOutpostId[2], self.attackActData, self.pop_up_root)
  self.house3:SetMapIndex(3, NineNationOutpostId[3], self.attackActData, self.pop_up_root)
  self.house4:SetMapIndex(4, NineNationOutpostId[4], self.attackActData, self.pop_up_root)
  self.house5:SetMapIndex(5, 0, nil, nil)
  self.house6:SetMapIndex(6, NineNationOutpostId[6], self.attackActData, self.pop_up_root)
  self.house7:SetMapIndex(7, NineNationOutpostId[7], self.attackActData, self.pop_up_root)
  self.house8:SetMapIndex(8, NineNationOutpostId[8], self.attackActData, self.pop_up_root)
  self.house9:SetMapIndex(9, NineNationOutpostId[9], self.attackActData, self.pop_up_root)
  self:UpdateData(FetchOutpostBattleInfoMessage.GetBattleInfo(true, true))
end

function UILWSeasonOutpostAttackS5View:ShowStageInfo(index, btn)
  self.pop_up_root:SetActive(false)
  self.event_blocker:SetActive(false)
  if self.battleInfo == nil or btn == nil or self.battleInfo.stage == nil then
    return
  end
  local tips = {
    "war_zone_outpost_21",
    "war_zone_outpost_91",
    "war_zone_outpost_92"
  }
  local battle_stage_time = self.battleInfo.stage[index]
  if battle_stage_time == nil then
    return
  end
  local title = Localization:GetString("war_zone_outpost_24")
  local timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(battle_stage_time, false, false)
  local msg = Localization:GetString(tips[index], timeStr)
  UIUtil.ShowButtonTips(btn, title, msg, true)
end

function UILWSeasonOutpostAttackS5View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackS5View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OutpostBattleInfoUpdate, self.UpdateData)
end

function UILWSeasonOutpostAttackS5View:OnRemoveListener()
  self:RemoveUIListener(EventId.OutpostBattleInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostAttackS5View:ComponentDefine()
  self.banner = self:AddComponent(UIButton, banner_path)
  self.loading = self:AddComponent(UIImage, loading_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
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
  self.battle_step01 = self:AddComponent(UIButton, battle_step01_path)
  self.battle_step2 = self:AddComponent(UIButton, battle_step2_path)
  self.battle_step3 = self:AddComponent(UIButton, battle_step3_path)
  self.battle_step02 = self:AddComponent(UIButton, battle_step02_path)
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
  self.scroll_view = self:AddComponent(PlayerReward, scroll_view_path)
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

function UILWSeasonOutpostAttackS5View:ComponentDestroy()
  self.scroll_view:SetVerticalNormalizedPosition(1)
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
  self.battle_step01 = nil
  self.battle_step2 = nil
  self.battle_step3 = nil
  self.battle_step02 = nil
  self.house1 = nil
  self.house2 = nil
  self.house3 = nil
  self.house4 = nil
  self.house5 = nil
  self.house6 = nil
  self.house7 = nil
  self.house8 = nil
  self.house9 = nil
  self.scroll_view = nil
  self.btn_back = nil
  self.pop_up_root = nil
  self.event_blocker = nil
  self.loading = nil
end

function UILWSeasonOutpostAttackS5View:Update1000MS()
  local remainTime = 0
  if self.battleStartTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    remainTime = self.battleStartTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1022")
      self.battleStartTime = nil
    end
  elseif self.battleEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    remainTime = self.battleEndTime - curTime
    if 0 < remainTime then
      self.tick:SetActive(true)
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
      self.tick_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.tick:SetActive(false)
      self.tick_time:SetText("--:--:--")
      self.title_text:SetLocalText("winter_battlefield_interface_tips1023")
      self.battleEndTime = nil
    end
  else
    self.tick:SetActive(false)
    self.tick_time:SetText("--:--:--")
    self.title_text:SetLocalText("activity_endalerttips1")
  end
end

function UILWSeasonOutpostAttackS5View:UpdateData(battleInfo)
  self.battleInfo = battleInfo
  if battleInfo == nil then
    self.tick:SetActive(false)
    self.progress:SetActive(false)
    self.scroll_view:SetActive(false)
    self.title_text:SetText("")
    self.zone_root:SetActive(false)
    self.btn_rank1:SetActive(true)
    self.btn_rank2:SetActive(false)
    self.loading:SetActive(true)
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local battle_stage_list = battleInfo.stage
  local now = UITimeManager:GetInstance():GetServerTime()
  local next_start_time = 0
  local max_battle_count = #battle_stage_list
  local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.tick:SetActive(true)
  self.progress:SetActive(true)
  local activeIndex = 0
  for i, v in ipairs(battle_stage_list) do
    activeIndex = i
    if v <= now then
      if now < v + max_battle_time then
        self.battleEndTime = v + max_battle_time
        break
      end
    elseif next_start_time == 0 then
      next_start_time = v
      self.battleStartTime = v
      break
    end
  end
  self.battle_step01:SetActive(1 < max_battle_count)
  self.battle_step2:SetActive(2 < max_battle_count)
  self.battle_step3:SetActive(2 < max_battle_count)
  self.battle_step02:SetActive(max_battle_count == 2)
  self.battle_step01:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar04.png")
  self.battle_step2:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar04.png")
  self.battle_step3:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar04.png")
  self.battle_step02:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar04.png")
  self.battle_step01:SetSizeDeltaXY(48, 48)
  self.battle_step2:SetSizeDeltaXY(48, 48)
  self.battle_step3:SetSizeDeltaXY(48, 48)
  self.battle_step02:SetSizeDeltaXY(48, 48)
  if activeIndex == 1 then
    self.progress:SetValue(0)
    self.battle_step01:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar03.png")
    self.battle_step01:SetSizeDeltaXY(70, 70)
  elseif activeIndex == max_battle_count then
    self.progress:SetValue(1)
    self.battle_step02:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar03.png")
    self.battle_step3:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar03.png")
    self.battle_step02:SetSizeDeltaXY(70, 70)
    self.battle_step3:SetSizeDeltaXY(70, 70)
  else
    self.progress:SetValue(0.5)
    self.battle_step2:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/KingBattleS5/FX_S5_QSZ_bar03.png")
    self.battle_step2:SetSizeDeltaXY(70, 70)
  end
  self:Update1000MS()
  self.house1:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house2:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house3:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house4:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house6:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house7:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house8:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.house9:ReInit(battleInfo.outpostInfoList, now, self.battleEndTime)
  self.loading:SetActive(false)
  self.zone_root:SetActive(true)
  self.btn_rank1:SetActive(true)
  self.btn_rank2:SetActive(true)
  self.scroll_view:SetActive(true)
  self.scroll_view:ReInit(self, battleInfo, self.battleStartTime)
end

return UILWSeasonOutpostAttackS5View
