local UILWSingleActivityContainerView = BaseClass("UILWSingleActivityContainerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonPersonalReward = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalReward")
local SeasonPersonalRewardNew = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonPersonalRewardNew")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local content_path = "Root/Container/Content"
local btn_back_black_path = "Root/BottomBar/BtnBackBlack"

function UILWSingleActivityContainerView:OnCreate()
  base.OnCreate(self)
  self.panelInstance = {}
  self.activityAssetPath = nil
  self.activityClass = nil
  self.activityId, self.titleTxt, self.param = self:GetUserData()
  self.activityId = tostring(self.activityId)
  self.ctrl:InitPanelStack()
  self:ComponentDefine()
  self:RefreshCurPanel(true)
  self.curPlayBgm = nil
  self.curPlayAmb = nil
end

function UILWSingleActivityContainerView:OnDestroy()
  self:StopCurPanelSound()
  self.panelInstance = nil
  self.btn_back_black = nil
  self.ctrl:DestroyPanelStack()
  base.OnDestroy(self)
end

function UILWSingleActivityContainerView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UILWSingleActivityContainerClosePanel, self.RemovePanelAndRefreshNext)
  self:AddUIListener(EventId.UILWSingleActivityContainerOpenPanel, self.PushNewPanel)
end

function UILWSingleActivityContainerView:OnRemoveListener()
  self:RemoveUIListener(EventId.UILWSingleActivityContainerClosePanel, self.RemovePanelAndRefreshNext)
  self:RemoveUIListener(EventId.UILWSingleActivityContainerOpenPanel, self.PushNewPanel)
  base.OnRemoveListener(self)
end

function UILWSingleActivityContainerView:OnEnable()
  base.OnEnable(self)
  if self.activityData ~= nil and not string.IsNullOrEmpty(self.activityData.plot) then
    local season = SeasonUtil.GetSeason()
    local key = "S" .. season .. "_PlayPlot_" .. self.activityId
    local cache = Setting:GetPrivateString(key)
    if cache ~= "ok" then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.activityData.plot,
        hideMainUI = true
      })
      Setting:SetPrivateString(key, "ok")
    end
  end
end

function UILWSingleActivityContainerView:OnDisable()
  base.OnDisable(self)
end

function UILWSingleActivityContainerView:ComponentDefine()
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.OnCustomKeyCodeEscape))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_back_black = self:AddComponent(UIButton, btn_back_black_path)
  self.btn_back_black:SetOnClick(BindCallback(self.ctrl, self.ctrl.OnCustomKeyCodeEscape))
  self.btn_back:SetActive(true)
  self.btn_back_black:SetActive(false)
  local config = DataCenter.SeasonDataManager:GetServerSeasonConfig()
  if config ~= nil and config.name then
    self.text_title:SetLocalText(config.name)
  elseif SeasonUtil.IsInSeasonCityStrongholdMode() then
    self.text_title:SetLocalText("season_ui_desc049")
  elseif SeasonUtil.IsInSeasonSnowMode() then
    self.text_title:SetLocalText("season_s2_name")
  end
end

function UILWSingleActivityContainerView:RefreshCurPanel(needPush)
  local seasonType = SeasonUtil.GetSeasonType()
  if self.activityId == "SeasonMain" then
    self.activityData = nil
    self.activityAssetPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonMainPage.prefab"
    self.activityClass = require("UI.LWSeason.LWSeasonMain.Component.SeasonInfo.SeasonInfo")
    self:LoadActivityAsset(needPush)
  elseif self.activityId == "SeasonScoreReward" then
    local achievementGroup = SeasonUtil.GetSeasonAchievementsGroup()
    local isFarmer = false
    if self.param then
      local config = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
      achievementGroup = toInt(config.season_achievements)
      isFarmer = true
    end
    if seasonType == SeasonMapType.CityStronghold and achievementGroup == 0 then
      local data = {}
      local panelData = {}
      panelData.type = SeasonScoreRewardPanelType.PersonalContributeAchievement
      panelData.key = "393080"
      table.insert(data, panelData)
      panelData = {}
      panelData.type = SeasonScoreRewardPanelType.AllianceStrongholdAchivement
      panelData.key = "129046"
      table.insert(data, panelData)
      self.activityData = data
      self.activityAssetPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonPersonalReward.prefab"
      self.activityClass = SeasonPersonalReward
      self:LoadActivityAsset(needPush)
    elseif achievementGroup ~= 0 then
      local achieveData = DataCenter.SeasonRewardDataManager:GetAchievementsGroups(SeasonAchivementFlagFilter.Personal_Alliance, achievementGroup)
      local paramData = {}
      paramData.achieveData = {}
      for key, value in pairs(achieveData) do
        local data = {}
        data.type = toInt(value.id)
        data.key = value.tab_title
        data.title = value.title
        data.icon = value.icon
        data.value = value.value
        data.description = value.description
        data.flag = value.flag
        data.banner = value.bg
        table.insert(paramData.achieveData, data)
      end
      self.activityId = "SeasonPersonalRewardNew"
      paramData.isFarmer = isFarmer
      self.activityData = paramData
      self.activityAssetPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonPersonalRewardNew.prefab"
      self.activityClass = SeasonPersonalRewardNew
      self:LoadActivityAsset(needPush)
    end
  else
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if data and data.id then
      local showBlackButton = data.type == EnumActivity.SeasonFactionSelectionActivity.Type or data.type == EnumActivity.OFF_SEASON_DIG_REWARD.Type
      local handlerData = SeasonUtil.GetSeasonActivityContentHandler(data.type, data.subViewType)
      if handlerData == nil then
        handlerData = DataCenter.ActivityListDataManager:GetActivityShowData(data.id)
      elseif handlerData.cls == nil and handlerData.clsPath ~= nil then
        handlerData.cls = require(handlerData.clsPath)
      end
      self.btn_back:SetActive(not showBlackButton)
      self.btn_back_black:SetActive(showBlackButton)
      if handlerData and data.type == EnumActivity.SeasonPeriodicCard.Type then
        local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, data.para)
        if weekConfig and not string.IsNullOrEmpty(weekConfig.show_type) then
          handlerData.assetPath = weekConfig.show_type
        end
      end
      if handlerData ~= nil and handlerData.assetPath ~= nil and handlerData.cls ~= nil then
        self.activityAssetPath = handlerData.assetPath
        self.activityClass = handlerData.cls
      end
      if CommonUtil.IsEditor() then
        Logger.LogInfo("<color=#00FF00FF>\229\189\147\229\137\141\230\137\147\229\188\128\231\154\132\232\181\155\229\173\163\230\180\187\229\138\168\231\177\187\229\158\139:" .. data.type .. " \230\180\187\229\138\168id:" .. data.id .. "</color>")
        if handlerData == nil then
          Logger.LogInfo("<color=#00FF00FF>\229\189\147\229\137\141\230\137\147\229\188\128\231\154\132\232\181\155\229\173\163\230\180\187\229\138\168\230\178\161\230\137\190\229\136\176 UI \229\174\154\228\185\137</color>")
        end
        if handlerData and handlerData.assetPath then
          Logger.LogInfo("<color=#00FF00FF>\229\189\147\229\137\141\230\137\147\229\188\128\231\154\132\232\181\155\229\173\163\230\180\187\229\138\168\233\162\132\229\136\182\228\189\147:" .. handlerData.assetPath .. "</color>")
        end
        if handlerData and handlerData.clsPath then
          Logger.LogInfo("<color=#00FF00FF>\229\189\147\229\137\141\230\137\147\229\188\128\231\154\132\232\181\155\229\173\163\230\180\187\229\138\168\232\132\154\230\156\172:" .. handlerData.clsPath .. "</color>")
        else
          local clsPath = DataCenter.ActivityListDataManager:DebuggerGetActivityShowData(data.id)
          if clsPath then
            Logger.LogInfo("<color=#00FF00FF>\229\189\147\229\137\141\230\137\147\229\188\128\231\154\132\232\181\155\229\173\163\230\180\187\229\138\168\232\132\154\230\156\172:" .. clsPath .. "</color>")
          end
        end
      end
      self.activityData = data
      self:LoadActivityAsset(needPush)
      if data.type == EnumActivity.ActMigration.Type then
        self.titleTxt = Localization:GetString("migration_activity_name_10001")
      end
      DataCenter.ActivityTipsManager:RecordSeenUI(data.activityId, data.type)
    else
      self.activityData = nil
    end
  end
  if not string.IsNullOrEmpty(self.titleTxt) then
    self.text_title:SetText(self.titleTxt)
  end
  if SeasonUtil.SeasonHasCampMasterServer(seasonType) then
    self.btn_back:SetActive(false)
    self.btn_back_black:SetActive(true)
  end
end

function UILWSingleActivityContainerView:LoadActivityAsset(push)
  if self.activityData == nil and self.activityId ~= "SeasonMain" or self.activityAssetPath == nil or self.activityClass == nil then
    return
  end
  if push then
    self.ctrl:PushPanelInfo(self.activityId, self.activityClass, self.activityData, self.titleTxt, self.param)
  end
  local cacheCell = self.panelInstance[self.activityId]
  if cacheCell then
    if cacheCell.com then
      cacheCell.com:SetActive(true)
      cacheCell.com:SetData(self.activityId, self.activityData)
      if self.activityData and type(self.activityData.PlayLoginSound) == "function" then
        self.activityData:PlayLoginSound()
      end
      if self.activityData and self.activityData.season_activity_bgm and self.activityData.season_activity_bgm > 0 then
        DataCenter.LWUIBGMManager:PlayActivityBGM(self.activityId, self.activityData.season_activity_bgm)
      end
      if self.activityData and self.activityData.season_activity_amb and 0 < self.activityData.season_activity_amb then
        DataCenter.LWUIBGMManager:PlayActivityAmb(self.activityId, self.activityData.season_activity_amb)
      end
      return
    elseif cacheCell.req then
      return
    end
  else
    self.panelInstance[self.activityId] = {}
  end
  local activityIdCache = self.activityId
  local activityAssetData = self:GameObjectInstantiateAsync(self.activityAssetPath, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local rectTransform = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    go.transform:SetParent(self.content.transform)
    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local goName = tostring(activityIdCache)
    if CommonUtil.IsEditor() and self.activityAssetPath then
      goName = string.format("[%s]%s", goName, PathUtil.GetFileNameWithoutExtension(self.activityAssetPath))
    end
    go.name = goName
    rectTransform:Set_offsetMin(0, 0)
    rectTransform:Set_offsetMax(0, 0)
    local panelInfo = self.ctrl:GetPanelInfoByActivityId(activityIdCache)
    local cell = self.content:AddComponent(panelInfo.activityClass, goName)
    local thePanelInfo = self.ctrl:GetCurPanelInfo()
    if thePanelInfo.activityId == activityIdCache then
      cell:SetData(thePanelInfo.activityId, thePanelInfo.activityData)
      if thePanelInfo.activityData and type(thePanelInfo.activityData.PlayLoginSound) == "function" then
        thePanelInfo.activityData:PlayLoginSound()
      end
      cell:SetActive(true)
      if thePanelInfo.activityData and thePanelInfo.activityData.season_activity_bgm and 0 < thePanelInfo.activityData.season_activity_bgm then
        DataCenter.LWUIBGMManager:PlayActivityBGM(activityIdCache, thePanelInfo.activityData.season_activity_bgm)
      end
      if thePanelInfo.activityData and thePanelInfo.activityData.season_activity_amb and 0 < thePanelInfo.activityData.season_activity_amb then
        DataCenter.LWUIBGMManager:PlayActivityAmb(activityIdCache, thePanelInfo.activityData.season_activity_amb)
      end
    else
      cell:SetActive(false)
    end
    self.panelInstance[activityIdCache].com = cell
  end)
  self.panelInstance[self.activityId].req = activityAssetData
end

function UILWSingleActivityContainerView:StopCurPanelSound()
  local curId = self.activityId
  local curData = self.activityData
  if not curId or not curData then
    return
  end
  if curData.season_activity_bgm and curData.season_activity_bgm > 0 then
    DataCenter.LWUIBGMManager:StopActivityBGM(curId)
  end
  if curData.season_activity_amb and 0 < curData.season_activity_amb then
    DataCenter.LWUIBGMManager:StopActivityAmb(curId)
  end
end

function UILWSingleActivityContainerView:StopActivityBGM()
  local curData = self.activityData
  if curData and curData.season_activity_bgm and curData.season_activity_bgm > 0 then
    DataCenter.LWUIBGMManager:StopActivityBGM(self.activityId)
  end
end

function UILWSingleActivityContainerView:StopActivityAmb()
  local curData = self.activityData
  if curData and curData.season_activity_amb and curData.season_activity_amb > 0 then
    DataCenter.LWUIBGMManager:StopActivityAmb(self.activityId)
  end
end

function UILWSingleActivityContainerView:HideCurPanel()
  self:StopCurPanelSound()
  local cacheCell = self.panelInstance[self.activityId]
  if cacheCell and cacheCell.com then
    cacheCell.com:SetActive(false)
  end
end

function UILWSingleActivityContainerView:PushNewPanel(data)
  self:HideCurPanel()
  self.activityAssetPath = nil
  self.activityClass = nil
  self.activityId = tostring(data.activityId)
  self.titleTxt = data.titleTxt
  self.param = data.param
  self:RefreshCurPanel(true)
end

function UILWSingleActivityContainerView:RemovePanelAndRefreshNext()
  self:HideCurPanel()
  self.activityAssetPath = nil
  self.activityClass = nil
  local panelInfo = self.ctrl:GetCurPanelInfo()
  self.activityId = panelInfo.activityId
  self.titleTxt = panelInfo.titleTxt
  self.param = panelInfo.param
  self:RefreshCurPanel()
end

return UILWSingleActivityContainerView
