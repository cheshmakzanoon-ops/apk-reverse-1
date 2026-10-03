local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonInfo = BaseClass("SeasonInfo", base)
local Localization = CS.GameEntry.Localization
local RectTransformCSType = typeof(CS.UnityEngine.RectTransform)
local LWSeasonWeekInfo = require("UI.LWSeason.LWSeasonWeekInfo")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local ui_open_count = 0
local btn_season_devote_path = "BtnSeasonDevote"
local remain_time_path = "TimeBg/remainTime"
local time_des_path = "TimeBg/timeDes"
local game_object_path = "GameObject"
local bg_mask_path = "BgRoot/bg_mask"
local bg_path = "BgRoot/Bg"
local title_path = "title"
local info_btn_path = "InfoBtn"
local btn_desc_path = "GameObject/BtnDesc"
local btn_reward_path = "GameObject/BtnReward"
local btn_group_path = "GameObject/BtnGroup"
local btn_hero_path = "GameObject/BtnHero"
local btn_battle_pass_path = "GameObject/BtnBattlePass"
local btn_jobs_path = "GameObject/BtnJobs"
local btn_world_event_path = "GameObject/BtnWorldEvent"
local btn_rank_path = "GameObject/BtnRank"
local btn_farmer_path = "GameObject/BtnFarmer"
local week_info_path = "WeekInfo"
local week_tip_path = "WeekTip"
local desc_btn_path = "DescBtn"
local reward_red_point_path = "GameObject/BtnReward/RewardRedPoint"
local job_red_point_path = "GameObject/BtnJobs/JobRedPoint"
local btn_achivement_path = "GameObject/BtnAchivement"
local achivement_red_point_path = "GameObject/BtnAchivement/AchivementRedPoint"
local title_s2_path = "titleS2"
local remain_time_s2_path = "TimeBg/remainTimeS2"
local icon_job_path = "GameObject/BtnJobs/iconJob"
local btn_text_job_path = "GameObject/BtnJobs/BtnTextJob"

function SeasonInfo:OnCreate()
  base.OnCreate(self)
  local season, seasonWeek = DataCenter.SeasonDataManager:GetSeasonWeekInfo()
  self.icon_job = self:AddComponent(UIImage, icon_job_path)
  self.btn_text_job = self:AddComponent(UITextMeshProUGUIEx, btn_text_job_path)
  self.btnRootContainer = self:AddComponent(UIGridLayoutGroup, game_object_path)
  self.btn_season_devote = self:AddComponent(UIButton, btn_season_devote_path)
  self.title_s2 = self:AddComponent(UITextMeshProUGUIEx, title_s2_path)
  self.remain_time_s2 = self:AddComponent(UITextMeshProUGUIEx, remain_time_s2_path)
  self.BgRoot = self:AddComponent(UIBaseContainer, "BgRoot")
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.week_info = self:AddComponent(LWSeasonWeekInfo, week_info_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
  self.title = self:AddComponent(UIText, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.btn_desc = self:AddComponent(UIButton, btn_desc_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_group = self:AddComponent(UIButton, btn_group_path)
  self.btn_hero = self:AddComponent(UIButton, btn_hero_path)
  self.btn_battle_pass = self:AddComponent(UIButton, btn_battle_pass_path)
  self.btn_jobs = self:AddComponent(UIButton, btn_jobs_path)
  self.btn_world_event = self:AddComponent(UIButton, btn_world_event_path)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_achivement = self:AddComponent(UIButton, btn_achivement_path)
  self.btn_farmer = self:AddComponent(UIButton, btn_farmer_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoBtnClick))
  self.btn_desc:SetOnClick(BindCallback(self, self.OnDescBtnClick))
  self.btn_reward:SetOnClick(BindCallback(self, self.OnRewardBtnClick))
  self.btn_group:SetOnClick(BindCallback(self, self.OnGroupBtnClick))
  self.btn_hero:SetOnClick(BindCallback(self, self.OnHeroBtnClick))
  self.btn_battle_pass:SetOnClick(BindCallback(self, self.OnBattlePassBtnClick))
  self.btn_jobs:SetOnClick(BindCallback(self, self.OnJobsBtnClick))
  self.btn_world_event:SetOnClick(BindCallback(self, self.OnWorldEventBtnClick))
  self.btn_rank:SetOnClick(BindCallback(self, self.OnRank))
  self.btn_achivement:SetOnClick(BindCallback(self, self.OnAchievementBtnClick))
  self.time_des = self:AddComponent(UIText, time_des_path)
  self.week_tip = self:AddComponent(UIButton, week_tip_path)
  self.reward_red_point = self:AddComponent(UIBaseContainer, reward_red_point_path)
  self.job_red_point = self:AddComponent(UIBaseContainer, job_red_point_path)
  self.achivement_red_point = self:AddComponent(UIBaseContainer, achivement_red_point_path)
  self.btn_hero:SetActive(SeasonUtil.IsInSeasonDesertMode())
  self.btn_achivement:SetActive(not SeasonUtil.IsInSeasonDesertMode() and not SeasonUtil.IsInSeasonPrepareMode())
  if DataCenter.SeasonFarmerManager:IsOpen() then
    self.btn_farmer:SetOnClick(BindCallback(self, self.OnFarmerBtnClick))
    self.btn_farmer:SetActive(true)
  else
    self.btn_farmer:SetActive(false)
  end
  self.week_tip:SetOnClick(function()
    UIUtil.GetWeekActiveCount("season_trend_donate_red", true)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, seasonWeek)
  end)
  if seasonWeek and 1 <= seasonWeek and seasonWeek <= 8 then
    self.WeekBtn = self:AddComponent(UIButton, "WeekTip/w" .. seasonWeek)
    self.WeekTxt = self:AddComponent(UIText, "WeekTip/w" .. seasonWeek .. "/txt" .. seasonWeek)
    self.tipRedPoint = self:AddComponent(UIText, "WeekTip/w" .. seasonWeek .. "/RedPoint" .. seasonWeek)
    self:RefreshRedPoint()
    self.WeekBtn:SetActive(true)
    self.WeekTxt:SetLocalText("801425", seasonWeek)
    self.WeekBtn:SetOnClick(function()
      UIUtil.GetWeekActiveCount("season_trend_donate_red", true)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, seasonWeek)
    end)
  end
  self.bg_mask = self:AddComponent(UIImage, bg_mask_path)
  self.desc_btn = self:AddComponent(UIButton, desc_btn_path)
  self.desc_btn:SetActive(false)
  self.btn_season_devote:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonAllianceRank, {anim = true, hideTop = true})
  end)
  self.btn_season_devote:SetActive(false)
  self.time_des:SetActive(false)
  self:OnCheckSeasonDevoteData()
  local mainBgPath
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer then
    mainBgPath = infoPlayer:GetMainBgPath()
    if string.IsNullOrEmpty(mainBgPath) then
      mainBgPath = nil
    end
  end
  local seasonType = SeasonUtil.GetSeasonSubdivisionType(true)
  self.bg_mask:SetActive(seasonType == SeasonMapType.NineNation)
  if seasonType == SeasonMapType.NineNation then
    pcall(function()
      local mask = self.BgRoot.transform:GetComponent(typeof(CS.UnityEngine.UI.RectMask2D))
      if IsNotNull(mask) then
        local currentPadding = mask.padding
        currentPadding.y = -1000
        mask.padding = currentPadding
      end
    end)
  end
  if seasonType == SeasonMapType.Mummy then
    local effectPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/mask_s3.prefab"
    self.mummy_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.BgRoot, function(view, go, lua, callback_param)
      local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTF ~= nil then
        rectTF:Set_localScale(1, 1, 1)
        rectTF:Set_offsetMin(0, 0)
        rectTF:Set_offsetMax(0, 0)
        rectTF:Set_pivot(0.5, 0.5)
        local ScreenSize = CS.UnityEngine.Screen
        if ScreenSize and ScreenSize.height ~= nil and 0 < ScreenSize.height and ScreenSize.width / ScreenSize.height >= 0.5625 then
          go.transform.offsetMin = Vector2.New(13, -130)
          go.transform.offsetMax = Vector2.New(-13, 0)
        else
          go.transform.offsetMin = Vector2.New(13, 0)
          go.transform.offsetMax = Vector2.New(-13, 0)
        end
      end
      self.mummy_anim = self:AddComponent(UISimpleAnimation, go)
      if ui_open_count == 0 then
        ui_open_count = 1
        self.mummy_anim:Play("init")
        self.mummy_anim:PlayQueued("idle")
      else
        self.mummy_anim:Play("idle")
      end
    end)
    self.bg:SetActive(false)
  elseif seasonType == SeasonMapType.Snow then
    self.bg:LoadSprite("Assets/Main/TextureEx/Season/S2/cfm_saiji_S2_zhujiemian_biejing.png")
    local effectPath = "Assets/Main/Prefabs/UI/LWSeason2/mask_partical.prefab"
    self.snow_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.bg)
    self.bg:SetAlpha(1)
    self.bg:SetNativeSize()
  elseif seasonType == SeasonMapType.CityStronghold then
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config and config.season_icon == "Mjc_saiji2_zhujiemian_cion_new" then
      self.bg:LoadSprite("Assets/Main/TextureEx/Season/Bg1/cfm_saiji_zhujiemian_beijing_1.png")
      local effectPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonMainPage_Bg/Eff_ui_stronghold.prefab"
      self.season_london_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.bg)
    else
      self.bg:LoadSprite("Assets/Main/TextureEx/Season/Bg1/Mjc_saiji2_zhujiemian_banner.png")
    end
    self.bg:SetAlpha(1)
    self.bg:SetNativeSize()
  elseif seasonType == SeasonMapType.Darkness then
    self.bg:SetAlpha(0)
    local effectPath = "Assets/Main/Prefabs/UI/LWSeason/SeasonMainPage_Bg/Eff_ui_darkness.prefab"
    self.season_darkness_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.BgRoot)
  elseif seasonType == SeasonMapType.NineNation then
    local effectPath = "Assets/Main/SeasonRes/S5/Prefabs/VX/Eff_ui_S5_loading_enviroment.prefab"
    self.bg:SetAlpha(0)
    self.season_darkness_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.BgRoot, function(view, go, lua, callback_param)
      local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
      if rectTF ~= nil then
        rectTF:Set_offsetMin(0, rectTF.offsetMin.y)
        rectTF:Set_offsetMax(0, rectTF.offsetMax.y)
      end
      if self.bg_mask then
        self.bg_mask:SetAsLastSibling()
      end
    end)
    self.bg_mask:SetColorHex("#834934")
  elseif seasonType == SeasonMapType.NineNationRainforest then
    local effectPath = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_ui_S6_Loading.prefab"
    self.bg:SetAlpha(0)
    self.season_darkness_effect = self:LoadComponentAsync(UIAsyncContainer, effectPath, self.BgRoot, function(view, go, lua, callback_param)
      go:SetActive(false)
      go:SetActive(true)
    end)
  elseif not string.IsNullOrEmpty(mainBgPath) then
    self.bg:SetAlpha(1)
    self.bg:LoadSprite(mainBgPath)
    self.bg:SetNativeSize()
  end
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.week_info:SetActive(false)
    self.week_tip:SetActive(false)
    self.btn_jobs:SetActive(false)
    self.btn_rank:SetActive(false)
  else
    self.week_info:SetActive(true)
    self.week_tip:SetActive(true)
    self.btn_jobs:SetActive(true)
    self.btn_rank:SetActive(true)
    if self:TryShowTacticalCard(seasonType) then
      self.icon_job:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/CommonS5/icon/LXY_saijizhiye_icon.png")
      self.btn_text_job:SetLocalText("season_main_UI105")
    end
  end
  if self.btnRootContainer then
    local theContainer = self.btnRootContainer
    local theTransform = theContainer.transform
    if theTransform ~= nil then
      local activeRectTransform = {}
      local childCnt = theTransform.childCount
      for i = 0, childCnt - 1 do
        local child = theTransform:GetChild(i)
        if child and child.gameObject then
          local go = child.gameObject
          if go.activeInHierarchy then
            local rect = go:GetComponent(RectTransformCSType)
            if rect then
              table.insert(activeRectTransform, rect)
            end
          end
        end
      end
      local activeCount = #activeRectTransform
      if activeCount <= 6 then
        theContainer:SetEnable(true)
        theContainer:SetConstraintCount(3)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(theTransform)
      elseif activeCount == 7 then
        theContainer:SetEnable(false)
        for index, rect in ipairs(activeRectTransform) do
          rect:Set_anchorMin(0.5, 0)
          rect:Set_anchorMax(0.5, 0)
          if index < 4 then
            rect:Set_anchoredPosition(200 * index - 400, 335, 0)
          else
            rect:Set_anchoredPosition(200 * (index - 3) - 500, 135, 0)
          end
          rect:Set_sizeDelta(148, 148)
        end
      else
        theContainer:SetEnable(true)
        theContainer:SetConstraintCount(4)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(theTransform)
      end
    end
  end
  self:InitRedPoint()
end

function SeasonInfo:TryShowTacticalCard(seasonType)
  self.canShowTacticalCard = false
  if seasonType ~= SeasonMapType.Darkness and seasonType ~= SeasonMapType.NineNation and seasonType ~= SeasonMapType.NineNationRainforest then
    return true
  end
  if not TacticalCardUtil.IsFunctionOpen() then
    return true
  end
  local isOpen = DataCenter.MasteryManager:Enabled()
  if isOpen then
    local data = DataCenter.MasteryManager:GetData()
    if data == nil then
      return true
    elseif data.home_id == 0 then
      return true
    end
  end
  self.canShowTacticalCard = true
  SeasonRedPointUtils.HideMasteryRedPoint()
  self.job_red_point:SetActive(false)
  self.icon_job:LoadSpriteAsync("Assets/Main/SeasonRes/S5/Sprites/CommonS5/icon/LXY_saijizhanshu_icon.png")
  self.btn_text_job:SetLocalText("battle_box_get_skill")
  return false
end

function SeasonInfo:OnCheckSeasonDevoteData()
  if not SeasonUtil.IsInSeasonPrepareMode() and LuaEntry.Player:IsInAlliance() then
    local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
    if existDevoteData then
      self.btn_season_devote:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    elseif self.hasCheckDevoteData ~= true then
      self.hasCheckDevoteData = true
      SFSNetwork.SendMessage(MsgDefines.CheckSeasonDevoteData, LuaEntry.Player:GetAllianceUid())
    end
  end
end

function SeasonInfo:OnDestroy()
  if self.btn_farmer_red then
    self.btn_farmer_red:Delete()
    self.btn_farmer_red = nil
  end
  if self.WeekBtn then
    self.WeekBtn:SetActive(false)
  end
  if self.tipRedPoint then
    self.tipRedPoint:SetActive(false)
  end
  self.bg_mask = nil
  self.title_s2 = nil
  self.remain_time_s2 = nil
  self.bg = nil
  self.WeekBtn = nil
  self.desc_btn = nil
  self.time_des = nil
  self.btn_achivement = nil
  self.achivement_red_point = nil
  base.OnDestroy(self)
end

function SeasonInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CloseUI, self.RefreshRed)
  self:AddUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.RefreshRedPoint)
  self:AddUIListener(EventId.LWSeasonTrendsDonateSuccess, self.RefreshRedPoint)
end

function SeasonInfo:OnRemoveListener()
  self:RemoveUIListener(EventId.CloseUI, self.RefreshRed)
  self:RemoveUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    base.OnRemoveListener(self)
    return
  end
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshRed)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.LWSeasonTrendsDonateSuccess, self.RefreshRedPoint)
  base.OnRemoveListener(self)
end

function SeasonInfo:OnEnable()
  base.OnEnable(self)
  self:RefreshRed()
  self:RefreshRedPoint()
end

function SeasonInfo:OnDisable()
  base.OnDisable(self)
end

function SeasonInfo:SetData(activityId)
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId(true)
  local name = GetTableData(TableName.LW_Season, seasonId, "name", "803000")
  self.activityId = activityId
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.endTime = DataCenter.SeasonDataManager.nextSeasonStartTime
  else
    self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.endTime then
    self.endTime = DataCenter.SeasonDataManager:GetSeasonEndTime()
    self.time_des:SetActive(true)
    self.time_des:SetText(Localization:GetString("372118"))
  end
  if SeasonUtil.GetSeasonType(true) == SeasonMapType.Snow then
    self.title_s2:SetLocalText(name or 803000)
    self.title:SetActive(false)
    self.title_s2:SetActive(true)
    self.remain_time:SetActive(false)
    self.remain_time_s2:SetActive(true)
  else
    self.title:SetLocalText(name or 803000)
    self.title:SetActive(true)
    self.title_s2:SetActive(false)
    self.remain_time:SetActive(true)
    self.remain_time_s2:SetActive(false)
  end
  self:Update1000MS()
end

function SeasonInfo:OnRank()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank)
end

function SeasonInfo:OnInfoBtnClick()
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config and config.desc then
    local txt
    for item in string.gmatch(config.desc, "([^;]+);?") do
      if txt == nil then
        txt = Localization:GetString(item)
      else
        txt = txt .. [[



]] .. Localization:GetString(item)
      end
    end
    if txt then
      UIUtil.ShowDetail(txt, nil, false, true, true)
    end
  end
end

function SeasonInfo:OnDescBtnClick()
  local config = DataCenter.SeasonDataManager:GetServerSeasonConfig()
  local pptValue = config and (SeasonUtil.IsInSeasonPrepareMode() and config.season_ppt_pre_start or config.season_ppt_manual)
  if pptValue then
    local data = DataCenter.LWWorldTipManager:GetDataBySeason(pptValue)
    if data ~= nil and table.count(data) > 0 then
      local param = {}
      param.dataWeek = data
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonIntroduction, {anim = false}, param)
      return
    end
  end
  if SeasonUtil.GetSeasonType(true) == SeasonMapType.Snow then
    UIUtil.ShowTipsId(302109)
    return
  end
  local LW_Season_Id = SeasonUtil.GetSeasonId(true)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonHint, {anim = false}, LW_Season_Id)
end

function SeasonInfo:OnRewardBtnClick()
  local seasonType = SeasonUtil.GetSeasonSubdivisionType(true)
  if seasonType == SeasonMapType.NineNationRainforest then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWS6Reward, {anim = false})
  elseif seasonType == SeasonMapType.NineNation then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason5Reward, {anim = false})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonReward, {anim = false})
  end
  DataCenter.LWSoundManager:PlaySound(1000109, false)
end

function SeasonInfo:OnGroupBtnClick()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
  local seasonType = SeasonMapType.Nothing
  if seasonInfo ~= nil then
    seasonType = seasonInfo:GetServerSubdivisionType(true)
  end
  if seasonType == SeasonMapType.NineNationRainforest then
    local myCampId = 0
    if seasonInfo:InPreviewMode() then
      local curActStage = DataCenter.SeasonSelectCampManager:GetCurActState()
      if curActStage == DataCenter.SeasonSelectCampManager.ActState.EndShow then
        local serverCamp = DataCenter.SeasonSelectCampManager:GetCurServerCamp()
        local serverZone = DataCenter.SeasonSelectCampManager:GetCurServerZone()
        if serverCamp and serverZone and seasonInfo then
          local data = {}
          for serverId, campId in pairs(serverCamp) do
            local theServerId = checknumber(serverId)
            data[serverId] = {serverId = theServerId, campId = campId}
            if theServerId == mySourceServerId then
              myCampId = campId
            end
          end
          for serverId, mapIndex in pairs(serverZone) do
            local info = data[serverId]
            if info == nil then
              data[serverId] = {
                serverId = checknumber(serverId),
                mapIndex = mapIndex
              }
            else
              info.mapIndex = mapIndex
            end
          end
          if myCampId == 1 or myCampId == 2 then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMapDetailV6, {anim = true, playEffect = false}, mySourceServerId, data, myCampId)
            return
          end
        end
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup)
      return
    end
    myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
    if myCampId == 1 or myCampId == 2 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMapDetailV6, {anim = true, playEffect = false}, mySourceServerId)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup)
    end
  elseif seasonType == SeasonMapType.NineNation and seasonInfo:InNormalMode() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMapDetailV2, {anim = true, playEffect = false}, mySourceServerId)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonServerGroup)
  end
end

function SeasonInfo:OnHeroBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonHeroList, 1)
end

function SeasonInfo:OnBattlePassBtnClick()
end

function SeasonInfo:OnJobsBtnClick()
  SeasonRedPointUtils.HideMasteryRedPoint()
  self.job_red_point:SetActive(false)
  if self.canShowTacticalCard then
    SFSNetwork.SendMessage(MsgDefines.FetchUserCardBoxList)
    TacticalCardUtil.OpenTacticalCardMain()
    return
  end
  local isOpen = DataCenter.MasteryManager:Enabled()
  if isOpen then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMastery, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIUtil.ShowTipsId("season_mastery_error_code_01")
  end
end

function SeasonInfo:OnWorldEventBtnClick()
  UIUtil.GetWeekActiveCount("season_trend_donate_red", true)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTrendsMain, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

function SeasonInfo:OnAchievementBtnClick()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
    EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {
      activityId = "SeasonScoreReward"
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, "SeasonScoreReward")
  end
end

function SeasonInfo:OnFarmerBtnClick()
  local activityId = DataCenter.SeasonFarmerManager:IsOpen() and DataCenter.SeasonFarmerManager:GetActivityId()
  if activityId == nil then
    return
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
    EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {activityId = activityId})
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, activityId)
  end
end

function SeasonInfo:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if SeasonUtil.GetSeasonType(true) == SeasonMapType.Snow then
      if 0 < remainTime then
        self.remain_time_s2:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        self.remain_time_s2:SetText("")
      end
    elseif 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.remain_time:SetText("")
    end
  end
end

function SeasonInfo:InitRedPoint()
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self:BindRedPointUI(self.tipRedPoint, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonTrendsReward
  })
  self:BindRedPointUI(self.reward_red_point, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonMainReward
  })
  self:BindRedPointUI(self.achivement_red_point, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonPersonalReward
  })
  self:BindRedPointUI(self.job_red_point, nil, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonMastery
  })
  self:BindRedPoint(self.CheckFarmerRedPoint, {
    RedDef.Season,
    RedDef.SeasonMainTab,
    RedDef.SeasonFarmer
  })
end

function SeasonInfo:CheckFarmerRedPoint(count)
  if count <= 0 then
    if ComponentIsValid(self.btn_farmer_red) then
      self.btn_farmer_red:SetActive(false)
    end
    return
  end
  if self.btn_farmer_red == nil then
    self.btn_farmer_red = UIAsyncContainer.New(self, self.btn_farmer.transform, "Assets/Main/Prefabs/UI/ChatNew/RedPoint.prefab", SeasonInfo.OnRedPointCreated)
  elseif ComponentIsValid(self.btn_farmer_red) then
    self.btn_farmer_red:SetActive(true)
  end
end

function SeasonInfo:RefreshRedPoint()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  if self.tipRedPoint then
    self.tipRedPoint:SetActive(SeasonRedPointUtils.SeasonTrendRewardRedPoint())
  end
end

function SeasonInfo:RefreshRed()
  if not CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    return
  end
  self.reward_red_point:SetActive(SeasonRedPointUtils.SeasonMainRewardBtnRed())
  self.achivement_red_point:SetActive(SeasonRedPointUtils.SeasonScoreEnterRedState())
  self.job_red_point:SetActive(SeasonRedPointUtils.IsShowMasteryRedPoint() and not self.canShowTacticalCard)
  local farmerAchievement = SeasonUtil.CheckSeasonFarmerAchievement()
  if DataCenter.SeasonFarmerManager:CountOfBuildReward() > 0 or farmerAchievement then
    if self.btn_farmer_red == nil then
      self.btn_farmer_red = UIAsyncContainer.New(self, self.btn_farmer.transform, "Assets/Main/Prefabs/UI/ChatNew/RedPoint.prefab", SeasonInfo.OnRedPointCreated)
    elseif ComponentIsValid(self.btn_farmer_red) then
      self.btn_farmer_red:SetActive(true)
    end
  elseif ComponentIsValid(self.btn_farmer_red) then
    self.btn_farmer_red:SetActive(false)
  end
end

function SeasonInfo.OnRedPointCreated(view, go, sc)
  if sc and GameObjectIsValid(go) then
    go.transform:Set_localPosition(38, 41, 0)
    if view and sc == view.btn_farmer_red then
      local farmerAchievement = SeasonUtil.CheckSeasonFarmerAchievement()
      go:SetActive(0 < DataCenter.SeasonFarmerManager:CountOfBuildReward() or farmerAchievement)
    end
  end
end

return SeasonInfo
