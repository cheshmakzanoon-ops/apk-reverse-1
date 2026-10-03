local UISeasonBtn = BaseClass("UISeasonBtn", UIAsyncContainer)
local base = UIAsyncContainer
local Setting = CS.GameEntry.Setting
local UISeasonBtnEffect = require("UI.LWMainUI.Component.UIMainTop.UISeasonBtnEffect")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local bg_path = "Bg"
local icon_path = "Bg/icon"
local btn_text_path = "BtnText"
local red_point_num_path = "RedPointNum"
local text_path = "RedPointNum/Text"
local activity_goto_tip_path = "ActivityGotoTip"
local tip_txt_path = "ActivityGotoTip/tipTxt"
local goto_btn_path = "ActivityGotoTip/gotoBtn"

function UISeasonBtn:UpdateData()
  self:RefreshShowState()
end

function UISeasonBtn:RefreshShowState()
  if not self:AsyncLoadDone() then
    return false
  end
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  local mainLv = DataCenter.BuildManager.MainLv
  self.seasonStartTime = nil
  self.BloodyNightStartTime = nil
  if config and mainLv and mainLv >= SEASON_MIN_LEVEL and SeasonUtil.IsOpen() then
    local theType = config.type
    local season_icon = config.season_icon
    if string.IsNullOrEmpty(config.season_icon) or string.sub(season_icon, 1, 7) == "Assets/" then
    else
      season_icon = string.format("Assets/Main/Sprites/UI/UISeason/Sprites/%s.png", config.season_icon)
      if not CS.GameEntry.Resource:HasAsset(season_icon) then
        season_icon = string.format("Assets/Main/Sprites/UI/UIMain/LWMainUI/%s.png", config.season_icon)
      end
    end
    self.isLondonSeason1 = config.season_icon == "Mjc_saiji2_zhujiemian_cion_new"
    self.seasonType = theType
    if self.effectMgr == nil then
      self.effectMgr = UISeasonBtnEffect.CreateEffectManager(self.bg, function(view, go, lua, callback_param)
        if go and self.seasonType == SeasonMapType.Darkness and self.bg then
          self.bg:SetAlpha(0)
        end
      end)
    end
    if self.isLondonSeason1 then
      SeasonUtil.UpdateActivityContentHandler()
    end
    if config.season_step then
      self.btnText:SetLocalText("season_main_UI108", config.season_step)
    else
      self.btnText:SetText("")
    end
    if theType == SeasonMapType.Darkness then
      if self.effectMgr and self.effectMgr:AsyncLoadDone() then
        self.bg:SetAlpha(0)
      else
        self.bg:SetAlpha(1)
        if DataCenter.BloodyNightDataManager:IsBloodyNight() then
          self.bg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIMain/LWMainUI/ljq_s4_rukoutubiao_xueye.png")
        else
          self.bg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIMain/LWMainUI/ljq_s4_rukoutubiao.png")
        end
      end
      local state, BNTemplate, startTime, endTime = DataCenter.BloodyNightDataManager:GetBloodyNightState()
      if state == BloodyNightState.Silent then
        self.BloodyNightStartTime = endTime
      else
        self.BloodyNightStartTime = nil
      end
      self.BloodyNightState = state
      if self.BloodyNightStartTime == nil and self.BloodyMoonPreEffect ~= nil then
        self.BloodyMoonPreEffect:Delete()
        self.BloodyMoonPreEffect = nil
      end
    else
      self.bg:SetAlpha(1)
      if not string.IsNullOrEmpty(season_icon) then
        self.bg:LoadSpriteAsync(season_icon)
      end
    end
    if SeasonUtil.IsInSeasonPrepareMode() then
      local season_pre_icon = config.season_pre_icon
      if not string.IsNullOrEmpty(season_pre_icon) then
        if string.sub(season_pre_icon, 1, 7) == "Assets/" then
          self.bg:LoadSpriteAsync(season_pre_icon)
        else
          local iconPath = string.format("Assets/Main/Sprites/UI/UIMain/LWMainUI/%s.png", season_pre_icon)
          if not CS.GameEntry.Resource:HasAsset(iconPath) then
            iconPath = string.format("Assets/Main/Sprites/UI/UISeason/Sprites/%s.png", season_pre_icon)
          end
          if CS.GameEntry.Resource:HasAsset(iconPath) then
            self.bg:LoadSpriteAsync(iconPath)
          end
        end
      end
      self.nextSeasonStartTime = DataCenter.SeasonDataManager.nextSeasonStartTime
    end
    if self.effectMgr then
      self.effectMgr:ReInit()
    end
    self:SetActive(true)
    self:TryShowTips()
    if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
      self:OnRedPointRefresh()
    end
    self:Update1000MS()
    return true
  end
  self:SetActive(false)
  self.redPoint:SetActive(false)
  return false
end

function UISeasonBtn:Update1000MS()
  if self.nextSeasonStartTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.nextSeasonStartTime - curTime
    if 0 < deltaTime then
      self.btnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.nextSeasonStartTime = nil
      self.btnText:SetLocalText("372617")
    end
  end
  self:CheckBloodyNightEffect()
end

function UISeasonBtn:CheckBloodyNightEffect()
  if self.BloodyNightStartTime == nil then
    if self.BloodyMoonPreEffect ~= nil then
      self.BloodyMoonPreEffect:Delete()
      self.BloodyMoonPreEffect = nil
    end
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.BloodyNightStartTime - curTime
    if remainTime < 4000 then
      if self.BloodyMoonPreEffect == nil then
        local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
        if mainUI then
          local view = mainUI.View
          if view and view.rectTransform then
            local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VX/Eff_xueye_pingmu.prefab"
            local rectSize = view.rectTransform.rect
            local scaleWidth = rectSize.width / DefaultScreenWidth
            local scaleHeight = rectSize.height / DefaultScreenHeight
            self.BloodyMoonPreEffect = UIAsyncNode.New("eff_xueye_pre", view.transform, effectPath, function(go)
              if IsNotNull(go) then
                go.transform:Set_localPosition(0, 0, 0)
                go.transform:Set_localScale(scaleWidth, scaleHeight, 1)
              end
            end)
          end
        end
      end
    elseif remainTime <= 0 then
      self.BloodyNightStartTime = nil
      if self.BloodyMoonPreEffect ~= nil then
        self.BloodyMoonPreEffect:Delete()
        self.BloodyMoonPreEffect = nil
      end
    end
  end
end

function UISeasonBtn:TryShowTips()
  self.tip_root:SetActive(false)
end

function UISeasonBtn:OnBtnClick()
  if not SeasonUtil.CheckSeasonResource() then
    local packageId, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(false)
    if packageId and 0 < packageId and needInPreviewMode then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonResourceDownload, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, packageId)
      return
    end
  end
  local soundId = DataCenter.SeasonDataManager:GetSeasonMainUIButtonSoundId()
  if soundId then
    DataCenter.LWSoundManager:PlaySound(soundId, false)
  end
  self.tip_root:SetActive(false)
  local info = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if info == nil then
    UIUtil.ShowTipsId("season_tips168")
    return
  end
  if info:ServerInReady() and SeasonUtil.IsInSeason() then
    self:TryShowMainUI(false)
    return
  end
  local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
  if seasonConfig == nil then
    UIUtil.ShowTipsId("season_tips168")
    return
  end
  if info:ClientInReady() or seasonConfig == nil or seasonConfig.pre_plot == nil or seasonConfig.pre_plot == "" or seasonConfig.pre_plot == 0 then
    self:TryShowMainUI(true)
  elseif seasonConfig and seasonConfig.pre_plot then
    local plotId = toInt(seasonConfig.pre_plot)
    local nextSeasonStartTime = toInt(self.nextSeasonStartTime)
    if self.effectMgr then
      self.effectMgr:TryShowPlotEffect(function()
        self:TryShowPlot(nextSeasonStartTime, plotId)
      end)
    else
      self:TryShowPlot(nextSeasonStartTime, plotId)
    end
  else
    SeasonUtil.OpenSeasonMain(true)
  end
end

function UISeasonBtn:TryShowPlot(nextSeasonStartTime, plotId)
  local key = string.format("SPP_%s_%s", nextSeasonStartTime, plotId)
  local alreadyShownPlot = Setting:GetPrivateBool(key, false)
  if alreadyShownPlot then
    self:TryShowMainUI(true)
  else
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    Setting:SetPrivateBool(key, true)
  end
end

function UISeasonBtn:TryShowMainUI(includePreview)
  if self.effectMgr then
    self.effectMgr:TryShowOpenEffect(function()
      SeasonUtil.OpenSeasonMain(includePreview)
    end)
  else
    SeasonUtil.OpenSeasonMain(includePreview)
  end
end

function UISeasonBtn:OnCloseUI(uiName)
  if self.effectMgr then
    self.effectMgr:OnCloseUI(uiName)
  end
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) and string.startswith(uiName, "LWSeason") then
    self:OnRedPointRefresh()
  end
end

function UISeasonBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
  self:AddUIListener(EventId.BloodyNightSelfRefresh, self.RefreshShowState)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:AddUIListener(EventId.OutpostBattleInfoUpdate, self.OnRedPointRefresh)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonMainEntranceRedPoint, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWMasterySkillUp, self.OnRedPointRefresh)
  self:AddUIListener(EventId.MasteryUseSkill, self.OnRedPointRefresh)
  self:AddUIListener(EventId.LWMasteryChangeMsgGet, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnCounterAttackActInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnCounterAttackRoundAwardPoint, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SnowStormTaskSuccessReward, self.OnRedPointRefresh)
  self:AddUIListener(EventId.ActNuclearTaskRedStateChange, self.OnRedPointRefresh)
  self:AddUIListener(EventId.DiggingGameRedUpdate, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SeasonGreenCityProgressInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SeasonGoldTreeInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.GoldTreeOpenCard, self.OnRedPointRefresh)
  self:AddUIListener(EventId.EveDecisiveBattleInfo, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnSandWormHuntRewardRefresh, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnJungleTrialRewardRefresh, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnJungleTrialBoxRefresh, self.OnRedPointRefresh)
  self:AddUIListener(EventId.OnBloodyNightTaskRedRefresh, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnRedPointRefresh)
  self:AddUIListener(EventId.RefreshItems, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SeasonVirusBossReddot, self.OnRedPointRefresh)
  self:AddUIListener(EventId.SeasonRefreshWastelandDataChange, self.OnRedPointRefresh)
end

function UISeasonBtn:OnDestroy()
  self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
  self:RemoveUIListener(EventId.BloodyNightSelfRefresh, self.RefreshShowState)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:ComponentDestroy()
    base.OnDestroy(self)
    return
  end
  self:RemoveUIListener(EventId.OutpostBattleInfoUpdate, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonMainEntranceRedPoint, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonBattlePassTabRedPoint, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonCrossAttackCityInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonCrossDeclareWarInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWMasterySkillUp, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.MasteryUseSkill, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.LWMasteryChangeMsgGet, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnCounterAttackActInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnCounterAttackRoundAwardPoint, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SnowStormTaskSuccessReward, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.ActNuclearTaskRedStateChange, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.DiggingGameRedUpdate, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SeasonGreenCityProgressInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SeasonGoldTreeInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.GoldTreeOpenCard, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.EveDecisiveBattleInfo, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnSandWormHuntRewardRefresh, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnJungleTrialRewardRefresh, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnJungleTrialBoxRefresh, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.OnBloodyNightTaskRedRefresh, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SeasonTetrisGetInfoPayloadUpdate, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SeasonVirusBossReddot, self.OnRedPointRefresh)
  self:RemoveUIListener(EventId.SeasonRefreshWastelandDataChange, self.OnRedPointRefresh)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonBtn:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPointUI(self.redPoint, self.redText, {
    RedDef.Season
  })
end

function UISeasonBtn:OnRedPointRefresh()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  local count = 0
  if self.nextSeasonStartTime == nil and SeasonUtil.IsInSeason() then
    count = DataCenter.SeasonDataManager:GetRedPointCount()
  elseif SeasonUtil.GetSeason() == 0 and SeasonUtil.IsInSeasonPrepareMode() then
    count = SeasonRedPointUtils.GetVirusResearchRedPoint() and 1 or 0
    if count == 0 then
      count = SeasonRedPointUtils.GetVirusBossRedPoint() and 1 or 0
    end
  end
  self.redPoint:SetActive(0 < count)
  self.redText:SetActive(0 < count)
  self.redText:SetText(tostring(count))
end

function UISeasonBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_num_path)
  self.redText = self:AddComponent(UIText, text_path)
  self.tip_root = self:AddComponent(UIBaseContainer, activity_goto_tip_path)
  self.tip_txt = self:AddComponent(UIText, tip_txt_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.goto_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.tip_root:SetActive(false)
  self:InitRedPoint()
end

function UISeasonBtn:ComponentDestroy()
  if self.BloodyMoonPreEffect ~= nil then
    self.BloodyMoonPreEffect:Delete()
    self.BloodyMoonPreEffect = nil
  end
  self.bg = nil
  self.icon = nil
  self.btnText = nil
  self.redPoint = nil
  self.redText = nil
  self.tip_root = nil
  self.tip_txt = nil
  self.goto_btn = nil
  self.effectMgr = nil
end

return UISeasonBtn
