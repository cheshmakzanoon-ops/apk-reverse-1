local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local CounterAttackMain = BaseClass("CounterAttackMain", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Mask/bg"
local btn_reward_path = "Content/Top/BtnList/BtnReward"
local btn_reward_text_path = "Content/Top/BtnList/BtnReward/BtnRewardIcon/BtnRewardText"
local btn_reward_red_path = "Content/Top/BtnList/BtnReward/BtnRewardRed"
local btn_info_path = "Content/Top/BtnList/BtnInfo"
local btn_tip_path = "Content/Top/BtnList/BtnTip"
local btn_info_text_path = "Content/Top/BtnList/BtnInfo/BtnInfoIcon/BtnInfoText"
local btn_rank_path = "Content/Top/BtnList/BtnRank"
local btn_rank_text_path = "Content/Top/BtnList/BtnRank/BtnRankIcon/BtnRankText"
local title_path = "Content/Top/title"
local act_time_path = "Content/Top/actTime"
local city_root_path = "Content/Middle/CityRoot"
local city_bg_path = "Content/Middle/CityRoot/cityBg"
local city_bg_raw_path = "Content/Middle/CityRoot/cityBgRaw"
local city_icon_raw_path = "Content/Middle/CityRoot/cityIconRaw"
local city_icon_path = "Content/Middle/CityRoot/cityIcon"
local city_name_path = "Content/Middle/CityRoot/cityName"
local attack_pos_path = "Content/Middle/CityRoot/attack_pos"
local state_txt_path = "Content/Middle/stateTxt"
local desc_bg_path = "Content/Middle/descBg"
local desc_time_path = "Content/Middle/descBg/descTime"
local desc_path = "Content/Middle/descBg/desc"
local descReward_path = "Content/Middle/descReward"
local rewardTime_path = "Content/Middle/descReward/rewardTime"
local btn_go_path = "Content/Middle/BtnGo"
local go_text_path = "Content/Middle/BtnGo/GoText"
local middle_path = "Content/Middle"
local empty_path = "Content/Empty"

function CounterAttackMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function CounterAttackMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CounterAttackMain:ComponentDefine()
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRewardBtn()
  end)
  self.btn_reward_text = self:AddComponent(UITextMeshProUGUIEx, btn_reward_text_path)
  self.btn_reward_text:SetLocalText("2010321")
  self.btn_reward_red = self:AddComponent(UIImage, btn_reward_red_path)
  self.btn_tip = self:AddComponent(UIButton, btn_tip_path)
  self.btn_tip:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTipBtn()
  end)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.btn_info:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickInfoBtn()
  end)
  self.btn_info_text = self:AddComponent(UITextMeshProUGUIEx, btn_info_text_path)
  self.btn_info_text:SetLocalText("gogncheng_liantu_tips1001")
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRankBtn()
  end)
  self.btn_rank:SetActive(false)
  self.btn_rank_text = self:AddComponent(UITextMeshProUGUIEx, btn_rank_text_path)
  self.btn_rank_text:SetLocalText("390040")
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.act_time = self:AddComponent(UITextMeshProUGUIEx, act_time_path)
  self.city_root = self:AddComponent(UIBaseComponent, city_root_path)
  self.city_icon = self:AddComponent(UIImage, city_icon_path)
  self.city_name = self:AddComponent(UITextMeshProUGUIEx, city_name_path)
  self.attack_pos = self:AddComponent(UITextMeshProUGUIEx, attack_pos_path)
  self.attack_pos_btn = self:AddComponent(UIButton, attack_pos_path)
  self.attack_pos_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.state_txt = self:AddComponent(UITextMeshProUGUIEx, state_txt_path)
  self.desc_bg = self:AddComponent(UIImage, desc_bg_path)
  self.desc_time = self:AddComponent(UITextMeshProUGUIEx, desc_time_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.descReward = self:AddComponent(UITextMeshProUGUIEx, descReward_path)
  self.rewardTimeTxt = self:AddComponent(UITextMeshProUGUIEx, rewardTime_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.go_text:SetLocalText("110003")
  self.middle = self:AddComponent(UIBaseComponent, middle_path)
  self.empty = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.city_bg = self:AddComponent(UIImage, city_bg_path)
  self.city_bg_raw = self:AddComponent(UIRawImage, city_bg_raw_path)
  self.city_icon_raw = self:AddComponent(UIRawImage, city_icon_raw_path)
end

function CounterAttackMain:ComponentDestroy()
  self.desc_bg = nil
  self.city_bg = nil
  self.city_bg_raw = nil
  self.city_icon_raw = nil
end

function CounterAttackMain:OnEnable()
  base.OnEnable(self)
end

function CounterAttackMain:OnDisable()
  base.OnDisable(self)
end

function CounterAttackMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnCounterAttackActInfo, self.Refresh)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:AddUIListener(EventId.OnCounterAttackRoundAwardPoint, self.RefreshAwardRedPoint)
  end
end

function CounterAttackMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnCounterAttackActInfo, self.Refresh)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:RemoveUIListener(EventId.OnCounterAttackRoundAwardPoint, self.RefreshAwardRedPoint)
  end
end

function CounterAttackMain:SetData(activityId)
  DataCenter.CounterAttackDataManager:SendMsgActivityInfo(true)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self.title:SetLocalText(self.data.activityName)
  self:Refresh()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:RefreshAwardRedPoint()
  else
    self:BindRedPointUI(self.btn_reward_red, nil, {
      RedDef.Season,
      tostring(self.activityId),
      RedDef.SeasonCounterAttackAward
    })
  end
end

function CounterAttackMain:RefreshAwardRedPoint()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.btn_reward_red:SetActive(DataCenter.CounterAttackDataManager:GetAwardRedPoint() > 0)
end

function CounterAttackMain:Refresh()
  self.actEndTime = DataCenter.CounterAttackDataManager:GetActEndTime()
  self.nextEventTime = nil
  self.rewardTime = nil
  if not LuaEntry.Player:IsInAlliance() then
    self.empty:SetActive(true)
    self.empty:SetLocalText("300707")
    self.middle:SetActive(false)
    self.btn_rank:SetActive(false)
    return
  end
  self.langKeyConfig = DataCenter.CounterAttackDataManager:GetLangKey()
  self.stage = DataCenter.CounterAttackDataManager:GetStage()
  self.cityMeta = DataCenter.CounterAttackDataManager:GetCityMeta()
  self.type = DataCenter.CounterAttackDataManager:GetType()
  self.descReward:SetLocalText(self.langKeyConfig.countdown_dialog)
  if SeasonUtil.IsInSeasonMummyMode() then
    self.descReward:SetColorRGBA255(218, 191, 133, 255)
    self.rewardTimeTxt:SetColorRGBA255(218, 191, 133, 255)
    self.desc_bg:SetColorRGBA(0, 0, 0, 1)
  else
    self.descReward:SetColorRGBA255(115, 130, 160, 255)
    self.rewardTimeTxt:SetColorRGBA255(115, 130, 160, 255)
    self.desc_bg:SetColorRGBA(1, 1, 1, 1)
  end
  if not string.IsNullOrEmpty(self.langKeyConfig.bg) then
    self.bg:LoadSprite(self.langKeyConfig.bg)
  end
  if self.stage ~= CounterAttackStage.WarmUp and self.cityMeta == nil then
    self.empty:SetActive(true)
    self.empty:SetLocalText(self.langKeyConfig.noaim_dialog)
    self.middle:SetActive(false)
    self.btn_rank:SetActive(false)
    return
  end
  self.empty:SetActive(false)
  self.middle:SetActive(true)
  if self.stage ~= CounterAttackStage.WarmUp and self.cityMeta then
    self.city_root:SetActive(true)
    self.btn_go:SetActive(true)
    self.city_bg:SetActive(true)
    self.city_icon:SetActive(true)
    self.city_bg_raw:SetActive(false)
    self.city_icon_raw:SetActive(false)
    local serverId = LuaEntry.Player:GetSourceServerId()
    if self.type == CounterAttackType.AllianceCity then
      local cityName = "#" .. serverId .. " " .. Localization:GetString("140205", self.cityMeta.level, Localization:GetString(self.cityMeta.name))
      self.city_name:SetText(cityName)
      self.city_icon:LoadSprite(self.cityMeta:GetIconPath(false))
      self.pos = self.cityMeta.pos
      self.attack_pos:SetText(UIUtil.FormatServerPosition(serverId, self.pos.x, self.pos.y))
    else
      self.city_name:SetLocalText(self.cityMeta.name)
      self.city_icon:LoadSprite(self.cityMeta:GetIconPath())
      local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
      if theStoveCenter then
        self.pos = SceneUtils.IndexToTilePos(theStoveCenter.pointId, ForceChangeScene.World)
        self.attack_pos:SetText(UIUtil.FormatServerPosition(serverId, self.pos.x, self.pos.y))
      else
        self.attack_pos:SetText("")
      end
      if self.type == CounterAttackType.AllianceStove then
      elseif self.type == CounterAttackType.GreenCenter then
        self.city_bg:SetActive(false)
        self.city_icon:SetActive(false)
        self.city_bg_raw:SetActive(true)
        self.city_icon_raw:SetActive(true)
        self.city_bg_raw:LoadSprite("Assets/Main/SeasonRes/S3/Textures/CounterAttack/wxy_S3_juntuanfangong_jianzhufaguang.png")
        self.city_icon_raw:LoadSprite("Assets/Main/SeasonRes/S3/Textures/CounterAttack/wxy_S3_juntuanfangong_jianzhu.png")
      end
    end
  else
    self.city_root:SetActive(false)
    self.btn_go:SetActive(false)
  end
  if self.stage == CounterAttackStage.WarmUp then
    self.state_txt:SetText("")
    self.rewardTime = DataCenter.CounterAttackDataManager:GetStageEndTime()
    self.desc:SetLocalText(self.langKeyConfig.pretime_dialog)
    self.btn_rank:SetActive(false)
  elseif self.stage == CounterAttackStage.Assemble then
    DataCenter.CounterAttackDataManager:SetFirstSeenAssemble()
    self.state_txt:SetLocalText(self.langKeyConfig.gathertime_dialog)
    self.nextEventTime = DataCenter.CounterAttackDataManager:GetStageEndTime()
    self.desc:SetLocalText(self.langKeyConfig.attacktime_dialog)
    self.btn_rank:SetActive(false)
  elseif self.stage == CounterAttackStage.Attack then
    DataCenter.CounterAttackDataManager:SetFirstSeenAttack()
    local state = DataCenter.CounterAttackDataManager:GetState()
    if state == CounterAttackState.Fighting then
      self.nextRound, self.nextEventTime = DataCenter.CounterAttackDataManager:GetNextRound()
      local totalRound = DataCenter.CounterAttackDataManager:GetTotalRound()
      self.state_txt:SetLocalText(self.langKeyConfig.attackstart_dialog)
      if 0 < self.nextRound then
        self.desc:SetLocalText("season_activity1000016_desc008", self.nextRound, totalRound)
      else
        self.desc:SetLocalText(self.langKeyConfig.end_dialog)
      end
    elseif state == CounterAttackState.Win then
      self.state_txt:SetLocalText("season_activity1000016_desc011")
      self.desc:SetLocalText(self.langKeyConfig.win_dialog)
    elseif state == CounterAttackState.Lose then
      self.state_txt:SetLocalText("season_activity1000016_desc012")
      self.desc:SetLocalText(self.langKeyConfig.lose_dialog)
    end
    self.btn_rank:SetActive(true)
  elseif self.stage == CounterAttackStage.Settle or self.stage == CounterAttackStage.End then
    local state = DataCenter.CounterAttackDataManager:GetState()
    if state == CounterAttackState.Lose then
      self.state_txt:SetLocalText("season_activity1000016_desc012")
      self.desc:SetLocalText(self.langKeyConfig.lose_dialog)
    else
      self.state_txt:SetLocalText("season_activity1000016_desc011")
      self.desc:SetLocalText(self.langKeyConfig.win_dialog)
    end
    self.btn_rank:SetActive(true)
  end
  self.desc_time:SetActive(self.nextEventTime)
  self.rewardTimeTxt:SetActive(self.rewardTime)
  self.descReward:SetActive(self.rewardTime)
  self:Update1000MS()
end

function CounterAttackMain:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  local countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.actEndTime - now)
  self.act_time:SetText(countdown)
  if self.nextEventTime then
    countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.nextEventTime - now)
    self.desc_time:SetText(countdown)
    if now > self.nextEventTime then
      DataCenter.CounterAttackDataManager:SendMsgActivityInfo()
    end
  end
  if self.rewardTime then
    countdown = UITimeManager:GetInstance():MilliSecondToFmtString(self.rewardTime - now)
    self.rewardTimeTxt:SetText(countdown)
  end
end

function CounterAttackMain:ClickRewardBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICounterAttackReward, {anim = true})
end

function CounterAttackMain:ClickInfoBtn()
  local activities = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.CounterAttack.Type)
  if activities and activities[1] and activities[1].ppt_show then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = true}, activities[1].ppt_show)
  end
end

function CounterAttackMain:ClickTipBtn()
  local param = {}
  param.activityRulesStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function CounterAttackMain:ClickRankBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICounterAttackRank, {anim = true})
  end
end

function CounterAttackMain:ClickGoBtn()
  if self.pos then
    GoToUtil.GotoWorldPos(SceneUtils.TileToWorld(self.pos, ForceChangeScene.World))
    GoToUtil.CloseAllWindows()
  end
end

return CounterAttackMain
