local UILWSeasonOutpostAttackS6View = BaseClass("UILWSeasonOutpostAttackS6View", UIBaseView)
local base = UIBaseView
local FetchOutpostBattleInfoMessage = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
local FetchHeroEventCfgInfo = require("Net.Msgs.FetchHeroEventCfgInfoMessage")
local PopupPanel = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostAttackS6Popup")
local PutOutpost = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostAttackTab0S6")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local debugMode = false
local _lastOpenTab = 1
local text_title_path = "Root/TopBar/TextTitle"
local btn_back_path = "Root/BottomBar/BtnBack"
local content_path = "Root/Container/Content"
local banner_path = "Root/Container/banner"
local tab_item1_path = "Root/Container/Tab/TabItem1"
local tab_item2_path = "Root/Container/Tab/TabItem2"
local tab_item3_path = "Root/Container/Tab/TabItem3"
local title_text_path = "Root/TopInfoBar/TitleText"
local tick_path = "Root/TopInfoBar/Tick"
local tick_time_path = "Root/TopInfoBar/Tick/bg/TickTime"
local btn_rank1_path = "Root/TopInfoBar/BtnRank1"
local btn_rank_text1_path = "Root/TopInfoBar/BtnRank1/BtnRankText1"
local btn_rank2_path = "Root/TopInfoBar/BtnRank2"
local btn_rank_text2_path = "Root/TopInfoBar/BtnRank2/BtnRankText2"
local progress_path = "Root/TopInfoBar/progress"
local battle_step1_path = "Root/TopInfoBar/progress/progressBg/battleStep1"
local battle_step2_path = "Root/TopInfoBar/progress/progressBg/battleStep2"
local battle_step3_path = "Root/TopInfoBar/progress/progressBg/battleStep3"
local battle_step4_path = "Root/TopInfoBar/progress/progressBg/battleStep4"
local content_put_path = "Root/Container/ContentPut"
local red_point3_path = "Root/Container/Tab/TabItem3/RedPoint3"

function UILWSeasonOutpostAttackS6View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.pop_up_root:SetActive(false)
  self:InitData()
end

function UILWSeasonOutpostAttackS6View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonOutpostAttackS6View:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventCfgInfoUpdate)
  self:AddUIListener(EventId.OutpostBattleInfoUpdate, self.UpdateData)
end

function UILWSeasonOutpostAttackS6View:OnRemoveListener()
  self:RemoveUIListener(EventId.HeroEventCfgInfoUpdate, self.OnHeroEventCfgInfoUpdate)
  self:RemoveUIListener(EventId.OutpostBattleInfoUpdate, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonOutpostAttackS6View:ComponentDefine()
  self.pop_up_root = self:AddComponent(PopupPanel, "Root/PopUpRoot")
  self.top_info_bar = self:AddComponent(UIBaseContainer, "Root/TopInfoBar")
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("s6_outpost_tag_2")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.contentPut = self:AddComponent(PutOutpost, content_put_path)
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
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
  self.btn_rank1:SetActive(true)
  self.btn_rank2:SetActive(true)
  self.btn_rank_text1:SetLocalText("war_zone_outpost_93")
  self.btn_rank_text2:SetLocalText("390040")
  self.btn_rank1:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600010}
    })
  end)
  self.btn_rank2:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonOutpostRankS6, {anim = true, playEffect = false})
  end)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_item1.selecting then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
      end
      self:OnTabChanged(1)
    end
    self.tab_item1.selecting = false
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_item2.selecting then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
      end
      self:OnTabChanged(2)
    end
    self.tab_item2.selecting = false
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_item3.selecting then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
      end
      self:OnTabChanged(3)
    end
    self.tab_item3.selecting = false
  end)
  self.btn = self:AddComponent(UIButton, "ImgBg")
  self.btn:SetOnClick(function()
    if self.pop_up_root ~= nil then
      self.pop_up_root:SetActive(false)
    end
    if self.tabRoot2 ~= nil then
      self.tabRoot2:CleanSelect()
    end
  end)
  self.red_point3 = self:AddComponent(UIImage, red_point3_path)
  local isPutDay = false
  local lastOpenTab = toInt(_lastOpenTab)
  local dataList = DataCenter.SeasonOutpostManager:CalcPutData()
  local tabItem = self["tab_item" .. lastOpenTab]
  if dataList then
    local now = UITimeManager:GetInstance():GetServerTime()
    for _, data in ipairs(dataList) do
      if data and now >= data.put_start_time and now < data.put_end_time then
        isPutDay = true
        break
      end
    end
  end
  if isPutDay or lastOpenTab == 1 or tabItem == nil then
    self.tab_item1:SetIsOn(true)
    self.tab_item1.selecting = false
    if self.select_tab == nil then
      self:OnTabChanged(1)
    end
  else
    tabItem:SetIsOn(true)
    tabItem.selecting = false
    if self.select_tab == nil then
      self:OnTabChanged(lastOpenTab)
    end
  end
end

function UILWSeasonOutpostAttackS6View:ComponentDestroy()
  self.img_bg = nil
  self.pop_up_root = nil
  self.top_info_bar = nil
  self.banner = nil
  self.text_title = nil
  self.btn_back = nil
  self.content = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.title_text = nil
  self.tick = nil
  self.tick_time = nil
  self.btn_rank1 = nil
  self.btn_rank2 = nil
  self.progress = nil
  self.battle_step1 = nil
  self.battle_step2 = nil
  self.battle_step3 = nil
  self.battle_step4 = nil
  self.contentPut = nil
  self.red_point3 = nil
end

function UILWSeasonOutpostAttackS6View:OnHeroEventCfgInfoUpdate()
  if self.select_tab == 3 and self.tabRoot3 ~= nil then
    self.tabRoot3:ReInit(debugMode, self.attackActData, self.battleInfo, self.battleStartTime, self.battleEndTime)
  end
  self:SetRedPoint()
end

function UILWSeasonOutpostAttackS6View:SetRedPoint()
  if self.red_point3 then
    if FetchOutpostBattleInfoMessage and FetchOutpostBattleInfoMessage.HasRed() then
      self.red_point3:SetActive(true)
    else
      self.red_point3:SetActive(false)
    end
  end
end

function UILWSeasonOutpostAttackS6View:OnTabChanged(tabIndex)
  _lastOpenTab = tabIndex
  self.select_tab = tabIndex
  self.top_info_bar:SetActive(tabIndex ~= 1)
  self.pop_up_root:SetActive(false)
  self.contentPut:SetActive(tabIndex == 1)
  self.content:SetActive(tabIndex ~= 1)
  if self.tabRoot2 ~= nil then
    self.tabRoot2:CleanSelect()
  end
  if tabIndex == 1 then
    if self.tabRoot2 ~= nil then
      self.tabRoot2:SetActive(false)
    end
    if self.tabRoot3 ~= nil then
      self.tabRoot3:SetActive(false)
    end
    self.contentPut:ReInit()
    self.banner:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_03_banner.png")
  elseif tabIndex == 2 then
    if self.tabRoot1 ~= nil then
      self.tabRoot1:SetActive(false)
    end
    if self.tabRoot3 ~= nil then
      self.tabRoot3:SetActive(false)
    end
    if self.tabRoot2 == nil then
      local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostAttackTab2S6")
      local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostAttackInfoS6.prefab"
      self.tabRoot2 = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
    end
    self.tabRoot2:SetActive(true)
    self.tabRoot2:SetPopUpNode(self.pop_up_root)
    self.tabRoot2:ReInit(debugMode, self.attackActData, self.battleInfo, self.battleStartTime, self.battleEndTime)
    self.banner:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_04_banner.png")
  elseif tabIndex == 3 then
    if self.tabRoot1 ~= nil then
      self.tabRoot1:SetActive(false)
    end
    if self.tabRoot2 ~= nil then
      self.tabRoot2:SetActive(false)
    end
    if self.tabRoot3 == nil then
      local lua = require("UI.LWSeason6.Outpost.UILWSeasonOutpostAttackS6.Component.UILWSeasonOutpostAttackTab3S6")
      local prefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/LWSeason6/Outpost/Component/OutpostAttackRewardS6.prefab"
      self.tabRoot3 = UIBaseComponent.LoadComponentAsync(self, lua, prefabPath, self.content)
    end
    self.tabRoot3:SetActive(true)
    self.tabRoot3:ReInit(debugMode, self.attackActData, self.battleInfo, self.battleStartTime, self.battleEndTime)
    self.banner:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_04_banner.png")
  end
  self.banner:SetNativeSize()
  self:SetRedPoint()
end

function UILWSeasonOutpostAttackS6View:ShowStageInfo(index, btn)
  if btn == nil then
    return
  end
  if self.battleInfo then
    local battle_stage_list = self.battleInfo.stage
    if battle_stage_list ~= nil and battle_stage_list[index] ~= nil then
      local start_time = toInt(battle_stage_list[index])
      if 0 < start_time then
        local title = Localization:GetString("s6_war_zone_outpost_1", "")
        local timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(start_time, false, false)
        UIUtil.ShowButtonTips(btn, title, timeStr, true)
        return
      end
    end
  end
end

function UILWSeasonOutpostAttackS6View:InitData()
  local now = UITimeManager:GetInstance():GetServerTime()
  self.attackActData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostAttack.Type)
  if debugMode and self.attackActData == nil then
    self.attackActData = {
      para = "1;5;10;15",
      para_1 = OneDayTime,
      startTime = now - 5 * OneDayTime * 1000,
      endTime = now + 20 * OneDayTime * 1000,
      para_2 = 400001
    }
    FetchHeroEventCfgInfo.GetCfgInfo(400001, true, false)
  end
  if self.attackActData == nil then
    self:UpdateData(FetchOutpostBattleInfoMessage.GetBattleInfo(true, true))
    return
  end
  local startTime = self.attackActData.startTime
  local dayList = string.split_ii_array(self.attackActData.para, ";")
  local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
  local dataList = {}
  local dataCount = #dayList
  for i = 1, dataCount do
    local battleInfo = {
      index = i,
      battle_start_time = 0,
      battle_end_time = 0
    }
    battleInfo.battle_start_time = startTime + dayList[i] * OneDayTime * 1000
    battleInfo.battle_end_time = battleInfo.battle_start_time + max_battle_time
    table.insert(dataList, battleInfo)
  end
  self.curIndex = dataCount
  self.battleCount = dataCount
  for i = 1, dataCount do
    local battleInfo = dataList[i]
    if now < battleInfo.battle_end_time then
      if now < battleInfo.battle_start_time then
        self.battleStartTime = battleInfo.battle_start_time
      else
        self.battleEndTime = battleInfo.battle_end_time
      end
      self.curIndex = i
      break
    end
  end
  self.dataList = dataList
  self:TryUpdateProgress()
  FetchHeroEventCfgInfo.GetCfgInfo(toInt(self.attackActData.para_2), true, false)
  self:UpdateData(FetchOutpostBattleInfoMessage.GetBattleInfo(true, true))
end

function UILWSeasonOutpostAttackS6View:TryUpdateProgress()
  if self.curIndex == 1 then
    self.progress:SetValue(0)
  elseif self.curIndex == self.battleCount then
    self.progress:SetValue(1)
  elseif self.curIndex > 1 and self.curIndex <= self.battleCount then
    local value = (self.curIndex - 1) / (self.battleCount - 1)
    self.progress:SetValue(value)
  end
  self:UpdateProgress(1, self.battle_step1)
  self:UpdateProgress(2, self.battle_step2)
  self:UpdateProgress(3, self.battle_step3)
  self:UpdateProgress(4, self.battle_step4)
end

function UILWSeasonOutpostAttackS6View:UpdateData(battleInfo)
  if debugMode and battleInfo == nil then
    battleInfo = {}
  end
  self.battleInfo = battleInfo
  if battleInfo == nil then
    self.tick:SetActive(false)
    self.title_text:SetText("")
    return
  end
  local battle_stage_list = battleInfo.stage
  if battle_stage_list == nil then
    self.tick:SetActive(false)
    self.title_text:SetText("")
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local next_start_time = 0
  local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
  self.battleStartTime = nil
  self.battleEndTime = nil
  self.tick:SetActive(true)
  self.progress:SetActive(true)
  local activeIndex = 0
  for i, start_time in ipairs(battle_stage_list) do
    activeIndex = i
    if start_time <= now then
      if now < start_time + max_battle_time then
        self.battleStartTime = start_time
        self.battleEndTime = start_time + max_battle_time
        break
      end
    elseif next_start_time == 0 then
      next_start_time = start_time
      self.battleStartTime = start_time
      self.battleEndTime = start_time + max_battle_time
      break
    end
  end
  self.curIndex = activeIndex
  self:TryUpdateProgress()
  self:OnHeroEventCfgInfoUpdate()
end

function UILWSeasonOutpostAttackS6View:UpdateProgress(index, battle_step)
  if self.curIndex == index then
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_3.png")
  elseif index > self.curIndex then
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_1.png")
  else
    battle_step:LoadSpriteAsync("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_QSZ_bar_yuanxing_2.png")
  end
  battle_step:SetActive(self.battleCount ~= 0 and index <= self.battleCount)
end

function UILWSeasonOutpostAttackS6View:Update1000MS()
  local remainTime = 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.battleEndTime and (self.battleStartTime == nil or curTime > self.battleStartTime) then
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
  elseif self.battleStartTime then
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
  else
    self.tick:SetActive(false)
    self.tick_time:SetText("--:--:--")
    self.title_text:SetLocalText("activity_endalerttips1")
  end
end

return UILWSeasonOutpostAttackS6View
