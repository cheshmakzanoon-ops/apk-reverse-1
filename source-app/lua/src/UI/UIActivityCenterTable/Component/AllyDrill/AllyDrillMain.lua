local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local AllyDrillMain = BaseClass("AllyDrillMain", base)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local CalendarAddBtnContent = require("UI.LWUIActivityAlarmClock.Component.CalendarAddBtnContent")
local offline_toggle_path = "Content/Toggle/OfflineToggle"
local toggle_text_path = "Content/Toggle/ToggleText"
local box_path = "Content/Middle/Box"
local pos_path = "Content/Middle/Box/Pos"
local normalBg = "Assets/Main/TextureEx/UIActivityBg/AllyBoss/zyf_tongmengjunyan_diban.png"
local newBg = "Assets/Main/TextureEx/UIActivityBg/AllyBoss/cfm_tongmengjunyan_beijing.png"
local calendar_add_btn_content_path = "Content/Middle/timeZoneContent/timeZone/CalendarAddBtnContent"

function AllyDrillMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function AllyDrillMain:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllyDrillMain:ComponentDefine()
  self.boxRawImage = self:AddComponent(UIRawImage, box_path)
  self.box = self:AddComponent(UIButton, box_path)
  self.box:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.pos = self:AddComponent(UITextMeshProUGUIEx, pos_path)
  self.intro_btn = self:AddComponent(UIButton, "Content/Top/BtnList/InfoBtn")
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTipBtn()
  end)
  self.rank_btn = self:AddComponent(UIButton, "Content/Top/BtnList/BtnRank")
  self.rank_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickRankBtn()
  end)
  self.donate_btn = self:AddComponent(UIButton, "Content/Top/BtnList/BtnDonate")
  self.donate_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickDonateBtn()
  end)
  self.updateBoss_btn = self:AddComponent(UIButton, "Content/Top/BtnList/BtnUpdateBoss")
  self.updateBoss_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickUpdateBossTipBtn()
  end)
  self.go_btn = self:AddComponent(UIButton, "Content/BottomBtns/BtnGo")
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickGoBtn()
  end)
  self.go_txt = self:AddComponent(UIText, "Content/BottomBtns/BtnGo/GoText")
  self.title_txt = self:AddComponent(UIText, "Content/Middle/title")
  self.desc_txt = self:AddComponent(UIText, "Content/Middle/descBg/desc")
  self.time_txt = self:AddComponent(UIText, "Content/Middle/timeTxt")
  self.timeZone = self:AddComponent(UIText, "Content/Middle/timeZoneContent/timeZone")
  self.RedPointDonate = self:AddComponent(UIBaseComponent, "Content/Top/BtnList/BtnDonate/DonateRed")
  self.RedPointGo = self:AddComponent(UIBaseComponent, "Content/BottomBtns/BtnGo/GoRed")
  self.offline_toggle = self:AddComponent(UIToggle, offline_toggle_path)
  self.toggle_text = self:AddComponent(UITextMeshProUGUIEx, toggle_text_path)
  self.toggle_text:SetText(Localization:GetString("alliance_boss_tips_001"))
  self.offline_toggle:SetOnValueChanged(function(isOn)
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(2010218)
      return
    end
    if isOn ~= self.isAutoRally then
      DataCenter.AllyDrillDataManager:SendChangeAutoRally(isOn)
    end
  end)
  self.bgNormalContainer = self:AddComponent(UIBaseComponent, "bgMask/bgNormal")
  self.bgNormal = self:AddComponent(UIRawImage, "bgMask/bgNormal/bg")
  self.fgNormal = self:AddComponent(UIRawImage, "bgMask/bgNormal/fg")
  self.bgNewBoss = self:AddComponent(UIRawImage, "bgMask/bgNewBoss")
  self.calendar_add_btn_content = self:AddComponent(CalendarAddBtnContent, calendar_add_btn_content_path)
end

function AllyDrillMain:ComponentDestroy()
  self.offline_toggle = nil
  self.toggle_text = nil
  self.bgNewBoss = nil
  self.bgNormalContainer = nil
  self.bossSpecialType = nil
  self.bgNormal = nil
  self.fgNormal = nil
  self.isNewBoss = nil
  self.data = nil
  self.bossType = nil
  self.calendar_add_btn_content = nil
end

function AllyDrillMain:OnEnable()
  base.OnEnable(self)
  DataCenter.AllyDrillDataManager:SendMsgAllianceBossActInfo()
  local allianceId = LuaEntry.Player.allianceId
  local selfRank = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself() and DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself().rank or 0
  if allianceId and 4 <= selfRank then
    DataCenter.AllyDrillDataManager:SendGetLastTimeInfo(allianceId)
  end
end

function AllyDrillMain:OnDisable()
  base.OnDisable(self)
end

function AllyDrillMain:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
  self:AddUIListener(EventId.OnAllyDrillStageChange, self.Refresh)
  self:AddUIListener(EventId.OnAllyDrillDonateSuccess, self.OnDonateSuccess)
  self:AddUIListener(EventId.OnAllyDrillAutoRallyChanged, self.OnAllyDrillAutoRallyChanged)
end

function AllyDrillMain:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
  self:RemoveUIListener(EventId.OnAllyDrillStageChange, self.Refresh)
  self:RemoveUIListener(EventId.OnAllyDrillDonateSuccess, self.OnDonateSuccess)
  self:RemoveUIListener(EventId.OnAllyDrillAutoRallyChanged, self.OnAllyDrillAutoRallyChanged)
end

function AllyDrillMain:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  self:Refresh()
end

function AllyDrillMain:Refresh()
  self.stage, self.timeStamp = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
  if not LuaEntry.Player:IsInAlliance() then
    self.go_txt:SetLocalText(2010366)
  elseif self.stage == AllyDrillStage.SelectStage then
    self.go_txt:SetLocalText(2010366)
  elseif self.stage == AllyDrillStage.PrepareStage then
    self.go_txt:SetLocalText(2010367)
  elseif self.stage == AllyDrillStage.ReadyStage then
    self.go_txt:SetLocalText(2010368)
  elseif self.stage == AllyDrillStage.AttackStage then
    self.go_txt:SetLocalText(2010367)
  else
    self.go_txt:SetLocalText(2010367)
  end
  self.RedPointDonate:SetActive(DataCenter.AllyDrillDataManager:HasRedDotOnDonateBtn())
  self.RedPointGo:SetActive(DataCenter.AllyDrillDataManager:HasRedDotOnGoBtn())
  self:RefreshAutoRally()
  self.bgNewBoss:SetActive(false)
  self.bgNormalContainer:SetActive(false)
  self.isNewBoss = DataCenter.AllyDrillDataManager:IsNewBoss()
  self.bossType = DataCenter.AllyDrillDataManager:GetBossType()
  if self.isNewBoss then
    self.bgNewBoss:SetActive(true)
    local bossBg = ""
    local bossTitle = ""
    local bossDesc = ""
    local titleAndDes = self.data.para_1
    if not string.IsNullOrEmpty(titleAndDes) then
      local titleAndDescArr = string.split(titleAndDes, "|")
      if titleAndDescArr then
        if titleAndDescArr[1] then
          bossTitle = titleAndDescArr[1]
        end
        if titleAndDescArr[2] then
          bossDesc = titleAndDescArr[2]
        end
      end
    end
    if self.bossType == AllyDrillBoss.HugeSandWorm then
      bossBg = "Assets/Main/TextureEx/UIActivityBg/AllyBossSandWorm/lrb_shachongjunyan_banner.png"
      self.bossSpecialType = WorldMonsterSpecialType.AllyDrillHugeSandWorm
    elseif self.bossType == AllyDrillBoss.RoadHog then
      bossBg = "Assets/Main/SeasonRes/Shared/Textures/MadCowDrill/wxy_s5_tongmengjunyan_banner.png"
      self.bossSpecialType = WorldMonsterSpecialType.AllyDrillRoadHog
    end
    self.bgNewBoss:LoadSpriteAuto(bossBg)
    self.title_txt:SetLocalText(bossTitle)
    self.desc_txt:SetLocalText(bossDesc)
    self:CheckBossUpdateNotice()
    self.updateBoss_btn:SetActive(true)
  else
    self.title_txt:SetLocalText(self.data.bannerTittle)
    self.desc_txt:SetLocalText(self.data.desc_info)
    self.bgNormalContainer:SetActive(true)
    local showNewBg = DataCenter.AllyDrillDataManager:GetShowNewBackground()
    local bg = showNewBg and newBg or normalBg
    self.bgNormal:LoadSprite(bg)
    self.fgNormal:SetActive(not showNewBg)
    self:CheckLevelTipShow()
    self.updateBoss_btn:SetActive(false)
    self.bossSpecialType = WorldMonsterSpecialType.AllyDrill
  end
  self:ShowCalendatBtnContent()
  self:Update1000MS()
end

function AllyDrillMain:ShowCalendatBtnContent()
  if self.stage == AllyDrillStage.PrepareStage and self.timeStamp then
    local startTime = toInt(self.timeStamp / 1000)
    local endTime = startTime
    self.calendar_add_btn_content:SetActive(true)
    self.calendar_add_btn_content:SetDataWithDefautValue(1, startTime, endTime, CalendarSourcePath.Activity)
  else
    self.calendar_add_btn_content:SetActive(false)
  end
end

function AllyDrillMain:OnAllyDrillAutoRallyChanged()
  self:RefreshAutoRally(true)
end

function AllyDrillMain:RefreshAutoRally(tip)
  self.isAutoRally = DataCenter.AllyDrillDataManager:GetAutoRally()
  self.offline_toggle:SetIsOn(self.isAutoRally)
  if tip then
    if self.isAutoRally then
      UIUtil.ShowTips(Localization:GetString("alliance_boss_tips_006"))
    else
      UIUtil.ShowTips(Localization:GetString("alliance_boss_tips_007"))
    end
  end
end

function AllyDrillMain:Update1000MS()
  local timeTxtStr = Localization:GetString(2010333)
  local timeZoneStr = ""
  self.box:SetActive(false)
  if self.stage and self.timeStamp then
    local now = UITimeManager:GetInstance():GetServerTime()
    local countdown = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.timeStamp - now)
    local timeStamp = UITimeManager:GetInstance():TimeStampToTimeForLocal(self.timeStamp)
    if not LuaEntry.Player:IsInAlliance() then
      timeTxtStr = Localization:GetString(302049) .. ": " .. countdown
      timeZoneStr = Localization:GetString(2010345, timeStamp)
    elseif self.stage == AllyDrillStage.SelectStage or self.stage == AllyDrillStage.PrepareStage then
      timeTxtStr = Localization:GetString(2010331, countdown)
      timeZoneStr = Localization:GetString(2010345, timeStamp)
    elseif self.stage == AllyDrillStage.ReadyStage then
      timeTxtStr = Localization:GetString(2010396, countdown)
      timeZoneStr = Localization:GetString(2010345, timeStamp)
    elseif self.stage == AllyDrillStage.AttackStage then
      if self.bossType == AllyDrillBoss.TankBoss or self.bossType == AllyDrillBoss.RoadHog then
        timeTxtStr = Localization:GetString(2010329, countdown)
        timeZoneStr = Localization:GetString(2010345, timeStamp)
      elseif self.bossType == AllyDrillBoss.HugeSandWorm then
        local s3Data = DataCenter.AllyDrillDataManager:GetNewBossData()
        local bossIsAlive = s3Data.stage < 3 or s3Data.stage == 3 and s3Data.curHp > 0
        if bossIsAlive then
          timeTxtStr = Localization:GetString(2010329, countdown)
          timeZoneStr = Localization:GetString(2010345, timeStamp)
        end
      end
    elseif (self.stage == AllyDrillStage.SettleStage or self.stage == AllyDrillStage.End) and self.bossType == AllyDrillBoss.RoadHog then
      self.box:SetActive(true)
      if not self.showBox then
        self.showBox = true
        self.boxRawImage:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Textures/MadCowDrill/zxl_s5junyan_baoxiang.png")
      end
      local actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
      if actInfo and actInfo.data then
        local bossPointId = actInfo.data.bossPointId
        local bossServerId = actInfo.data.bossServerId
        local tile = SceneUtils.IndexToTilePos(bossPointId, ForceChangeScene.World)
        self.pos:SetText(UIUtil.FormatServerPosition(bossServerId, tile.x, tile.y))
      else
        self.pos:SetText("")
      end
    end
  end
  self.time_txt:SetText(timeTxtStr)
  self.timeZone:SetText(timeZoneStr)
end

function AllyDrillMain:ClickTipBtn()
  if not self.data then
    return
  end
  local param = {}
  param.activityId = self.activityId
  param.activityRulesStr = ""
  if self.isNewBoss then
    param.activityRulesStr = Localization:GetString(self.data.para_3)
  elseif self.data.story ~= nil then
    param.activityRulesStr = Localization:GetString(self.data.story)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function AllyDrillMain:ClickGoBtn()
  AllyDrillUtil.TryJumpToMyAllyDrillBase()
end

function AllyDrillMain:ClickDonateBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  elseif self.stage == AllyDrillStage.SelectStage then
    UIUtil.ShowTipsId(2010347)
    local param = {}
    param.positionType = PositionType.World
    param.position = self.go_btn.position
    DataCenter.ArrowManager:ShowArrow(param)
  elseif self.stage == AllyDrillStage.PrepareStage or self.stage == AllyDrillStage.ReadyStage or self.stage == AllyDrillStage.AttackStage then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillDonate, {anim = true})
  elseif self.stage == AllyDrillStage.SettleStage or self.stage == AllyDrillStage.End then
    UIUtil.ShowTipsId(2010333)
  end
end

function AllyDrillMain:ClickUpdateBossTipBtn()
  if not self.bossSpecialType then
    return
  end
  local titleKey = ""
  local descKey = ""
  if self.bossSpecialType == WorldMonsterSpecialType.AllyDrillHugeSandWorm or self.bossSpecialType == WorldMonsterSpecialType.AllyDrillRoadHog then
    local titleAndDes = self.data.para_2
    if not string.IsNullOrEmpty(titleAndDes) then
      local titleAndDescArr = string.split(titleAndDes, "|")
      if titleAndDescArr then
        if titleAndDescArr[1] then
          titleKey = titleAndDescArr[1]
        end
        if titleAndDescArr[2] then
          descKey = titleAndDescArr[2]
        end
      end
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.AllyDrillUpdateBoss, {anim = true}, self.bossSpecialType, titleKey, descKey)
end

function AllyDrillMain:ClickRankBtn()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
  elseif self.stage == AllyDrillStage.SelectStage then
    UIUtil.ShowTipsId(2010347)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillRank, {anim = true})
  end
end

function AllyDrillMain:OnDonateSuccess(msg)
  self.RedPointDonate:SetActive(msg.item.count >= 10)
end

function AllyDrillMain:CheckLevelTipShow()
  local hasShow = Setting:GetPrivateBool(SettingKeys.ALLY_DRILL_LEVEL_TIP, false)
  if hasShow then
    return
  end
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  if DataCenter.AllyDrillDataManager:GetBossType() ~= AllyDrillBoss.TankBoss then
    return
  end
  local maxRevealLevel = DataCenter.AllyDrillDataManager:GetMaxRevealLevel()
  local actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
  local next = 1
  if actInfo.openDifficultyLevel ~= nil then
    local cur = actInfo.openDifficultyLevel > 0 and actInfo.openDifficultyLevel or 1
    next = cur + 1
  elseif actInfo.data and actInfo.data.difficultyLevel then
    next = tonumber(actInfo.data.difficultyLevel) or 1
  end
  next = Mathf.Min(next, maxRevealLevel)
  local nextMeta = DataCenter.AllyDrillDataManager:GetAllyDrillTankCfg(next)
  if not nextMeta or nextMeta.stage == 1 then
    return
  end
  if not DataCenter.AllyDrillDataManager:GetNewStageAB() then
    return
  end
  if 0 < nextMeta.show_condition then
    local seasonCondition = 0
    local cfg = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetSourceServerId())
    if cfg ~= nil then
      local seasonId = cfg.seasonId
      if cfg:InHaltMode() then
        seasonCondition = seasonId
      else
        seasonCondition = Mathf.Max(seasonId - 1, 0)
      end
    end
    if seasonCondition < nextMeta.show_condition then
      return
    end
  end
  Setting:SetPrivateBool(SettingKeys.ALLY_DRILL_LEVEL_TIP, true)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWAllyDrillLevelTip)
end

function AllyDrillMain:CheckBossUpdateNotice()
  if not self.bossSpecialType then
    return
  end
  local key = SettingKeys.ALLY_DRILL_NEW_BOSS .. self.bossSpecialType
  local hasShow = Setting:GetPrivateBool(key, false)
  if hasShow then
    return
  end
  Setting:SetPrivateBool(key, true)
  self:ClickUpdateBossTipBtn()
end

return AllyDrillMain
