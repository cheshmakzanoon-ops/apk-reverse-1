local LWSeason3MainItem = BaseClass("LWSeason3MainItem", UIAsyncContainer)
local base = UIAsyncContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local UIArabicImageMirror = require("Framework.UI.Component.UIArabicImageMirror")
local lock_path = "Lock"
local info_btn_path = "Lock/InfoBtn"
local detail_btn_path = "Lock/DetailBtn"
local tips_path = "Lock/Tips"
local time_path = "Lock/TimeBg/Time"
local open_path = "Open"
local title_path = "Open/Title"
local tick_time_path = "Open/Tick/bg/TickTime"
local red_point_path = "RedPoint"
local red_num_path = "RedPoint/RedNum"

function LWSeason3MainItem:OnCreate()
  base.OnCreate(self)
  self.enterEffectShown = false
  self.flash_effect = self:AddComponent(UIBaseContainer, "FlashEffect")
  self.breath_effect = self:AddComponent(UIBaseContainer, "BreathEffect")
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_num = self:AddComponent(UIText, red_num_path)
  self.btn = self:AddComponent(UIButton, "")
  self.img = self:AddComponent(UIRawImage, "")
  self.canvas = self:AddComponent(UICanvasGroup, "")
  self.btn:SetOnClick(function()
    if self.activeNode == self.lockRoot then
      return
    end
    SeasonUtil.OpenSeasonActivity(self.data)
  end)
  self.lockRoot = self:AddComponent(UIBaseComponent, lock_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.info_btn:SetOnClick(function()
    if self.activeNode ~= self.lockRoot or self.data == nil then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonActivityDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.data.id)
  end)
  self.detail_btn:SetOnClick(function()
    if self.activeNode ~= self.lockRoot or self.data == nil or self.data.ppt_show == nil then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, self.data.ppt_show)
  end)
  self.detail_btn:SetActive(false)
  self.openRoot = self:AddComponent(UIBaseComponent, open_path)
  self.titleOpen = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.tick_time = self:AddComponent(UITextMeshProUGUIEx, tick_time_path)
  self.activeNode = self.lockRoot
  self.lockRoot:SetActive(true)
  self.openRoot:SetActive(false)
  self.red_num:SetText("")
  self.red_point:SetActive(false)
  self.flash_effect:SetActive(false)
  self.breath_effect:SetActive(false)
end

function LWSeason3MainItem:OnDestroy()
  base.OnDestroy(self)
  self.lockRoot:SetActive(false)
  self.openRoot:SetActive(false)
  self.red_point:SetActive(false)
  self.flash_effect:SetActive(false)
  self.breath_effect:SetActive(false)
  self.red_point = nil
  self.red_num = nil
  self.flash_effect = nil
  self.breath_effect = nil
end

function LWSeason3MainItem:ReInit(theRowIndex, data, tabIdentify, skipAnim)
  if tabIdentify then
    self.activityId = tostring(tabIdentify)
  elseif data and data.activityId then
    self.activityId = tostring(data.activityId)
  elseif data and data.id then
    self.activityId = tostring(data.id)
  else
    self.activityId = "Unknown"
  end
  self.data = data
  self.activeNode = nil
  self.skipAnim = skipAnim
  self.theRowIndex = theRowIndex
  if data == nil then
    if SeasonUtil.IsInSeasonPrepareMode() then
      self.endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
    else
      self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    end
  elseif data and type(data.GetValidType) == "function" and data:GetValidType() == ActivityValidType.Now then
    local useOriginalEndTime = self.data.type == EnumActivity.SeasonSelectLocationGame.Type
    if SeasonUtil.IsInSeasonPrepareMode() and not useOriginalEndTime then
      self.endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
    else
      self.endTime = data.endTime or DataCenter.SeasonDataManager:GetSeasonEndTime()
    end
  else
    self.endTime = data.startTime
  end
  self:UpdateData()
end

function LWSeason3MainItem:UpdateData()
  if self.red_point == nil or IsNull(self.gameObject) then
    return
  end
  local data = self.data
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.skipAnim then
    self.hasFadeInAnim = true
    self.canvas:SetAlpha(1)
    self:SetLocalScaleXYZ(1, 1, 1)
  else
    self.hasFadeInAnim = false
    self.canvas:SetAlpha(0)
    self:SetLocalScaleXYZ(0.7, 0.7, 1)
  end
  if data == nil then
    self.enterEffectShown = true
    self.lockRoot:SetActive(false)
    self.openRoot:SetActive(true)
    self.img:LoadSprite("Assets/Main/SeasonRes/S3/Textures/Activity/lyt_S3_saijirukou_l_01.png")
    self.activeNode = self.openRoot
    if SeasonUtil.IsInSeasonPrepareMode() then
      self.endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
    else
      self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
    end
    if curTime > self.endTime then
      self.endTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
      self.titleOpen:SetText(Localization:GetString("372118"))
    else
      local config = DataCenter.SeasonDataManager:GetSeasonConfig()
      if config and config.season_step then
        self.titleOpen:SetLocalText("season_main_UI108", config.season_step)
      else
        self.titleOpen:SetLocalText("100356")
      end
    end
  else
    if data and type(data.GetValidType) == "function" and data:GetValidType() == ActivityValidType.Now then
      self.activeNode = self.openRoot
      self.lockRoot:SetActive(false)
      self.openRoot:SetActive(true)
      self.titleOpen:SetLocalText(data.name)
      if SeasonUtil.IsInSeasonPrepareMode() then
        self.endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
      else
        self.endTime = data.endTime or DataCenter.SeasonDataManager:GetSeasonEndTime()
      end
      if data.preview_time and 0 < toInt(data.preview_time) and UITimeManager:GetInstance():IsSameDayForServer(tonumber(data.startTime) * 0.001, curTime * 0.001) then
        local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
        local count = UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFlashEffect" .. self.activityId, false)
        self.enterEffectShown = 0 < count
      else
        self.enterEffectShown = true
      end
      self:TryShowBreathEffect()
    else
      self.enterEffectShown = true
      self.activeNode = self.lockRoot
      self.lockRoot:SetActive(true)
      self.openRoot:SetActive(false)
      self.tips:SetLocalText(data.name)
      self.endTime = data.startTime
    end
    local seasonIconPath = SeasonUtil.GetSeasonShowIconPath(data)
    if seasonIconPath then
      if CS.GameEntry.Resource:HasAsset(seasonIconPath) then
        self.img:LoadSpriteAuto(seasonIconPath)
      else
        Logger.LogError(seasonIconPath)
      end
    end
  end
  self:Update1000MS()
  self:SetRedPoint()
  self:InitRedPoint()
  if self.activityId == "SeasonInfo" then
    self:ShowFadeInEffect(true)
  elseif not self:HasFadeInEffectShown() then
    local cell_pos = self.transform.position
    local screenPos = PosConverse.UIWorldToScreenPos(cell_pos)
    self:ShowFadeInEffect(screenPos.y > 100)
  end
end

function LWSeason3MainItem:Update1000MS()
  if self.endTime ~= nil and self.activeNode ~= nil then
    local time_txt
    if self.activeNode == self.lockRoot then
      time_txt = self.time
    elseif self.activeNode == self.openRoot then
      time_txt = self.tick_time
    end
    if time_txt ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.endTime - curTime
      if 0 < remainTime then
        time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        time_txt:SetText("00:00:00")
        if self.notifyParent ~= true then
          self.notifyParent = true
          self:SetActive(false)
        end
      end
    end
  end
end

function LWSeason3MainItem:OnEnable()
  base.OnEnable(self)
  self:SetRedPoint()
  if self.gameObject then
    if self.imageMirror == nil then
      self.imageMirror = self:AddComponent(UIArabicImageMirror, "")
    end
    if self.imageMirror then
      self.imageMirror:SetEnable(self.data ~= nil and self.data.enter_banner_unmirror ~= 1 and CommonUtil.IsArabicAutoMirrorOpen())
    end
  end
end

function LWSeason3MainItem:OnDisable()
  base.OnDisable(self)
end

function LWSeason3MainItem:OnAddListener()
  base.OnAddListener(self)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:AddUIListener(EventId.LWSeasonWeekCardTabRedPoint, self.WeekDataUpdate)
  self:AddUIListener(EventId.LWSeasonHeroPromoteTabRedPoint, self.HeroPromoteUpdate)
  self:AddUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.BattlePassUpdate)
  self:AddUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnCrossAttackCityInfoUpdate)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfoUpdate)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarInfoUpdate)
  self:AddUIListener(EventId.OnCounterAttackActInfo, self.SetRedPoint)
  self:AddUIListener(EventId.OnCounterAttackRoundAwardPoint, self.SetRedPoint)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.SeasonMainTab)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.SeasonMainTab)
  self:AddUIListener(EventId.SnowStormTaskSuccessReward, self.SetRedPoint)
  self:AddUIListener(EventId.ActNuclearTaskRedStateChange, self.SetRedPoint)
  self:AddUIListener(EventId.DiggingGameRedUpdate, self.SetRedPoint)
  self:AddUIListener(EventId.SeasonGreenCityProgressInfo, self.SetRedPoint)
  self:AddUIListener(EventId.EveDecisiveBattleInfo, self.SetRedPoint)
  self:AddUIListener(EventId.OnSandWormHuntRewardRefresh, self.SetRedPoint)
  self:AddUIListener(EventId.SeasonRefreshWastelandBoxInfo, self.SetRedPoint)
  self:AddUIListener(EventId.SeasonRefreshWastelandDataChange, self.SetRedPoint)
end

function LWSeason3MainItem:OnRemoveListener()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    base.OnRemoveListener(self)
    return
  end
  self:RemoveUIListener(EventId.LWSeasonWeekCardTabRedPoint, self.WeekDataUpdate)
  self:RemoveUIListener(EventId.LWSeasonHeroPromoteTabRedPoint, self.HeroPromoteUpdate)
  self:RemoveUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.BattlePassUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnCrossAttackCityInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnCrossDeclareWarInfoUpdate)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarRedPointUpdate, self.OnCrossDeclareWarInfoUpdate)
  self:RemoveUIListener(EventId.OnCounterAttackActInfo, self.SetRedPoint)
  self:RemoveUIListener(EventId.OnCounterAttackRoundAwardPoint, self.SetRedPoint)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.SeasonMainTab)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.SeasonMainTab)
  self:RemoveUIListener(EventId.SnowStormTaskSuccessReward, self.SetRedPoint)
  self:RemoveUIListener(EventId.ActNuclearTaskRedStateChange, self.SetRedPoint)
  self:RemoveUIListener(EventId.DiggingGameRedUpdate, self.SetRedPoint)
  self:RemoveUIListener(EventId.SeasonGreenCityProgressInfo, self.SetRedPoint)
  self:RemoveUIListener(EventId.EveDecisiveBattleInfo, self.SetRedPoint)
  self:RemoveUIListener(EventId.OnSandWormHuntRewardRefresh, self.SetRedPoint)
  self:RemoveUIListener(EventId.SeasonRefreshWastelandBoxInfo, self.SetRedPoint)
  self:RemoveUIListener(EventId.SeasonRefreshWastelandDataChange, self.SetRedPoint)
  base.OnRemoveListener(self)
end

function LWSeason3MainItem:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  if self.activityId == "SeasonInfo" then
    self:BindRedPointUI(self.red_point, self.red_num, {
      RedDef.Season,
      RedDef.SeasonMainTab
    })
    return
  end
  if self.data and self.data.instanceOf and self.data:instanceOf("ActivityInfoData") then
    local redPointDef = ActivityRedPointDefs[self.data.type]
    if redPointDef then
      self:BindRedPointUI(self.red_point, self.red_num, {
        RedDef.Season,
        tostring(self.activityId)
      })
    end
  end
end

function LWSeason3MainItem:SetRedPoint()
  local disRed = CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE)
  if self.activityId == "WeekCard" then
    if disRed then
      self.red_point:SetActive(SeasonRedPointUtils.GetWeekCardTabBtn(self.data))
    end
    return
  end
  if self.activityId == "SeasonInfo" then
    if disRed then
      self.red_point:SetActive(SeasonRedPointUtils.SeasonMainTab())
      self.red_num:SetActive(false)
    end
    return
  end
  if not (self.data and self.data.instanceOf) or not self.data:instanceOf("ActivityInfoData") then
    return
  end
  if not disRed and ActivityRedPointDefs[self.data.type] then
    return
  end
  if self.data.type == EnumActivity.BattlePass_new.Type then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonBattlePassTabRedPoint(self.data.activityId))
  elseif self.data.type == EnumActivity.SeasonPeriodicCard.Type then
    self.red_point:SetActive(DataCenter.SeasonDataManager:WeekCardNeedRedPoint())
  elseif self.data.type == EnumActivity.ActHeroPromotion.Type then
    self.red_point:SetActive(SeasonRedPointUtils.SeasonHeroPromotionRedPoint(self.data.activityId))
  elseif self.data.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
    local count = SeasonRedPointUtils.GetCrossAttackCityRedPoint()
    self.red_num:SetText(tostring(count))
    self.red_num:SetActive(1 < count)
    self.red_point:SetActive(0 < count)
  elseif self.data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
    local count, countALL = SeasonRedPointUtils.GetCrossDeclareWarRedPoint(nil)
    self.red_num:SetText(tostring(count))
    self.red_num:SetActive(1 < count)
    self.red_point:SetActive(0 < count)
  elseif self.data.type == EnumActivity.SeasonAttackCityActivity.Type then
    local count = 0
    if LuaEntry.Player:IsInAlliance() then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data and data.content then
        local click_count = UIUtil.GetTodayActiveCount("SeasonAttackCity" .. data.content, false)
        if click_count == 0 then
          count = 1
        end
      end
    end
    self.red_num:SetActive(false)
    self.red_point:SetActive(0 < count)
  elseif self.data.type == EnumActivity.CounterAttack.Type then
    self.red_num:SetActive(false)
    self.red_point:SetActive(0 < DataCenter.CounterAttackDataManager:GetAwardRedPoint() or DataCenter.CounterAttackDataManager:GetFirstSeenRedPoint())
  elseif self.data.type == EnumActivity.SandWormHunt.Type then
    self.red_num:SetActive(false)
    self.red_point:SetActive(DataCenter.SandWormHuntDataManager:GetCanReceive() or DataCenter.SandWormHuntDataManager:GetFirstSeenRedPoint())
  elseif self.data.type == EnumActivity.SeasonSynthesis.Type then
    local can_show_red = SeasonUtil.SynthesisRemainRedPoint(self.data)
    self.red_num:SetActive(false)
    self.red_point:SetActive(can_show_red)
  elseif self.data.type == EnumActivity.SnowStormComing.Type then
    local flag = false
    local state = DataCenter.SeasonSnowStormDataManager:GetActivityStateData()
    if state ~= ActivitySnowStormState.SnowStorm then
      local curActivity = DataCenter.SeasonSnowStormDataManager.curActivity
      if curActivity then
        local configId = curActivity.cfgId
        local eventConfig = LocalController:instance():getLine(TableName.StormEvent, configId)
        if eventConfig then
          for index, value in ipairs(eventConfig.quest) do
            local taskData = DataCenter.TaskManager:FindTaskInfo(value)
            if taskData and taskData.state == TaskState.CanReceive then
              flag = true
              break
            end
          end
        end
      end
    end
    self.red_num:SetActive(false)
    self.red_point:SetActive(flag)
  elseif self.data.type == EnumActivity.SeasonNuclearPowerPlantActivity.Type then
    self.red_num:SetActive(false)
    self.red_point:SetActive(DataCenter.SeasonNuclearPowerPlantDataManager:GetActivityTaskRedState())
  elseif self.data.type == EnumActivity.SeasonPreview.Type then
    self.red_num:SetActive(false)
    self.red_point:SetActive(DataCenter.SeasonPreviewManager:GetActivityTaskRedState())
  elseif self.data.type == EnumActivity.SeasonKillMonsterRank.Type or self.data.type == EnumActivity.SeasonStrongholdRank.Type or self.data.type == EnumActivity.SeasonAttackWorldDesertActivity.Type then
    local rewardCount = DataCenter.LWSeasonWastelandDataManager:GetRedCount(self.activityId)
    self.red_point:SetActive(0 < rewardCount)
    self.red_num:SetActive(false)
  elseif self.data.type == EnumActivity.DiggingGame.Type then
    local diggingCount = DataCenter.DiggingDataManager:GetRedCount()
    if 0 < diggingCount then
      self.red_point:SetActive(true)
      self.red_num:SetText(tostring(diggingCount))
      self.red_num:SetActive(true)
    else
      self.red_point:SetActive(false)
      self.red_num:SetActive(false)
    end
  elseif self.data.type == EnumActivity.SeasonGreen.Type then
    local rewardCount = DataCenter.SeasonGreenManager:GetRedCount()
    if 0 < rewardCount then
      self.red_point:SetActive(true)
      self.red_num:SetText(tostring(rewardCount))
      self.red_num:SetActive(true)
    else
      self.red_point:SetActive(false)
      self.red_num:SetActive(false)
    end
  elseif self.data.type == EnumActivity.SeasonLastWar.Type then
    self.red_num:SetActive(false)
    local tasks = DataCenter.ActivityListDataManager:GetExtraData(EVE_DECISIVE_BATTLE_TASK)
    if tasks then
      for _, task in pairs(tasks) do
        if task and task.state == TaskState.CanReceive then
          self.red_point:SetActive(true)
          return
        end
      end
    end
    self.red_point:SetActive(false)
  end
end

function LWSeason3MainItem:OnCrossAttackCityInfoUpdate()
  if self.data and self.data.type == EnumActivity.SeasonCrossAttackCityActivity.Type then
    self:SetRedPoint()
  end
end

function LWSeason3MainItem:OnCrossDeclareWarInfoUpdate()
  if self.data and self.data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
    self:SetRedPoint()
  end
end

function LWSeason3MainItem:WeekDataUpdate(cardId)
  if self.data and self.data.type == EnumActivity.SeasonPeriodicCard.Type then
    self:SetRedPoint()
  end
  if self.data and self.activityId == "WeekCard" and tostring(self.data) == tostring(cardId) then
    self:SetRedPoint()
  end
end

function LWSeason3MainItem:BattlePassUpdate(activityId)
  if self.data and self.data.activityId == tostring(activityId) then
    self:SetRedPoint()
  end
end

function LWSeason3MainItem:HeroPromoteUpdate(activityId)
  self:SetRedPoint()
end

function LWSeason3MainItem:SeasonMainTab()
  self:SetRedPoint()
end

function LWSeason3MainItem:TryShowBreathEffect()
  if self.data then
    if self.data.type == EnumActivity.SeasonAttackCityActivity.Type then
      local DeclareWarDataList = DataCenter.AllianceDeclareWarManager:GetAllianceDeclareWarData()
      if DeclareWarDataList ~= nil then
        local allianceId = LuaEntry.Player:GetAllianceUid()
        for _, WarData in ipairs(DeclareWarDataList) do
          if WarData.aId == allianceId then
            self.breath_effect:SetActive(true)
            return
          end
        end
      end
    elseif self.data.type == EnumActivity.SeasonCrossDeclareWarActivity.Type then
      local data = DataCenter.SeasonDataManager.CrossDeclareWarInfo
      if data ~= nil and (data.declareList and table.count(data.declareList) > 0 or data.beDeclareList and 0 < table.count(data.beDeclareList)) then
        self.breath_effect:SetActive(true)
      end
    elseif self.data.type == EnumActivity.CounterAttack.Type then
      self.breath_effect:SetActive(DataCenter.CounterAttackDataManager:GetStage() == CounterAttackStage.Attack and DataCenter.CounterAttackDataManager:GetState() == 1)
    end
  else
    self.breath_effect:SetActive(false)
  end
end

function LWSeason3MainItem:ShowEnterEffect()
  if self.enterEffectShown ~= true then
    self.flash_effect:SetActive(false)
    self.enterEffectShown = true
    local theSeasonStartTime = DataCenter.SeasonDataManager:GetSeasonStartTime()
    UIUtil.GetActiveCount(theSeasonStartTime, "SeasonFlashEffect" .. self.activityId, true)
  end
end

function LWSeason3MainItem:HasEnterEffectShown()
  return self.enterEffectShown
end

function LWSeason3MainItem:HasFadeInEffectShown()
  return self.hasFadeInAnim
end

function LWSeason3MainItem:ShowFadeInEffect(useAnim)
  if self.hasFadeInAnim ~= true then
    self.hasFadeInAnim = true
    if useAnim then
      self.canvas:SetAlpha(0)
      self:SetLocalScaleXYZ(0.8, 0.8, 1)
      local delayTime = toInt(self.theRowIndex) * 0.06
      local sequence = DOTween.Sequence()
      sequence:AppendInterval(delayTime)
      sequence:Append(self.transform:DOScale(Vector3.New(1.03, 1.03, 1), 0.14))
      sequence:Join(self.canvas.unity_canvas_group:DOFade(1, 0.14))
      sequence:Append(self.transform:DOScale(Vector3.New(1, 1, 1), 0.333))
    else
      self.canvas:SetAlpha(1)
      self:SetLocalScaleXYZ(1, 1, 1)
    end
  end
end

return LWSeason3MainItem
