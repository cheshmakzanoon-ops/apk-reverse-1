local LWSeason4MainView = BaseClass("LWSeason4MainView", UIBaseView)
local base = UIBaseView
local LWSeason4MainItem = require("UI.LWSeason4.LWSeason4Main.Component.LWSeason4MainItem")
local LWSeasonMainBanner = require("UI.LWSeasonShared.Component.LWSeasonMainBanner")
local LWSeasonUpgradeLog = require("UI.LWSeasonShared.Component.LWSeasonUpgradeLog")
local btn_back_path = "Root/BottomBar/BtnBackBlack"
local text_title_path = "Root/TopBar/TextTitle"
local content_path = "Root/ActivityList/Viewport/Content"
local left_path = "Root/ActivityList/Viewport/Content/left"
local right_path = "Root/ActivityList/Viewport/Content/right"
local activity_list_path = "Root/ActivityList"
local btn_rank_path = "Root/BottomBar/BtnRank"
local btn_upgrade_log_path = "Root/TopBar/TopBtns/BtnUpgradeLog"
local btn_news_path = "Root/TopBar/TopBtns/BtnNews"
local banner_path = "Root/ActivityList/banner"
local viewport_path = "Root/ActivityList/Viewport"

function LWSeason4MainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  DataCenter.SeasonDataManager:GetActivityPreviewInfo()
  self.scroll_view:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
  self.scroll_view:SetVerticalNormalizedPosition(1)
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetCrossDeclareWarInfo)
  end
  self:UpdateData(false)
  self.btn_upgrade_log:RefreshSeasonUpgradeState()
  self.isPlayingSeasonPrepareBGM = false
  if not SeasonUtil.IsInSeason() then
    local bgmId = DataCenter.SeasonDataManager:GetSeasonPrepareBGMSoundId()
    if bgmId ~= nil then
      DataCenter.LWSoundManager:PlaySound(bgmId, false, true)
      self.isPlayingSeasonPrepareBGM = true
    end
  end
end

function LWSeason4MainView:OnDestroy()
  if self.isPlayingSeasonPrepareBGM then
    CommonUtil.PlayGameBgMusic()
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeason4MainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPassDay, self.UpdateData)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:AddUIListener(EventId.UILWSingleActivityContainerClose, self.OnSingleActivityContainerClose)
end

function LWSeason4MainView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnPassDay, self.UpdateData)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.UpdateData)
  self:RemoveUIListener(EventId.UILWSingleActivityContainerClose, self.OnSingleActivityContainerClose)
  base.OnRemoveListener(self)
end

function LWSeason4MainView:OnEnable()
  base.OnEnable(self)
  self:PlayAnim("Default")
end

function LWSeason4MainView:OnDisable()
  self:PlayAnim("close")
  base.OnDisable(self)
end

function LWSeason4MainView:OnSingleActivityContainerClose()
  self:UpdateData(true)
end

function LWSeason4MainView:ComponentDefine()
  local config = DataCenter.SeasonDataManager:GetServerSeasonConfig()
  self.actCellList = nil
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  if config ~= nil and config.name then
    self.text_title:SetLocalText(config.name)
  elseif SeasonUtil.IsInSeasonCityStrongholdMode() then
    self.text_title:SetLocalText("season_ui_desc049")
  elseif SeasonUtil.IsInSeasonSnowMode() then
    self.text_title:SetLocalText("season_s2_name")
  end
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank)
  end)
  self.scroll_view = self:AddComponent(UIScrollRect, activity_list_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.right = self:AddComponent(UIBaseContainer, right_path)
  self.viewport = self:AddComponent(UIImage, viewport_path)
  self.banner = self:AddComponent(LWSeasonMainBanner, banner_path)
  self.simpleAnimation = self:AddComponent(UISimpleAnimation, "")
  self.btn_upgrade_log = self:AddComponent(LWSeasonUpgradeLog, btn_upgrade_log_path)
  self.btn_upgrade_log:SetActive(false)
  self.btn_news = self:AddComponent(UIButton, btn_news_path)
  self.btn_news:SetActive(false)
  self.btn_news:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWNewsCenter, {anim = false}, {
      tabType = ChatNewsCenterTabType.StrategyGuide
    })
  end)
  local userSeasonInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local guideId = userSeasonInfo and userSeasonInfo:GetSeasonGuideId()
  self.btn_news:SetActive(0 < guideId)
end

function LWSeason4MainView:ComponentDestroy()
  self.btn_back = nil
  self.scroll_view = nil
  self.btn_rank = nil
  self.banner = nil
  self.viewport = nil
end

function LWSeason4MainView:PlayAnim(name)
  if self.simpleAnimation then
    if self.simpleAnimation:IsPlaying(name) then
      self.simpleAnimation:Rewind(name)
    else
      self.simpleAnimation:Play(name)
    end
  end
end

function LWSeason4MainView:OnScrollValueChange()
  if self.actCellList ~= nil then
    for _, cell in ipairs(self.actCellList) do
      if cell:AsyncLoadDone() and not cell:HasEnterEffectShown() then
        local cell_pos = cell.transform.position
        local screenPos = PosConverse.UIWorldToScreenPos(cell_pos)
        if screenPos.y > 138 then
          cell:ShowEnterEffect()
        end
      end
    end
  end
  if self.theItemList then
    for _, cell in ipairs(self.theItemList) do
      if cell:AsyncLoadDone() and not cell:HasFadeInEffectShown() then
        local cell_pos = cell.transform.position
        local screenPos = PosConverse.UIWorldToScreenPos(cell_pos)
        cell:ShowFadeInEffect(screenPos.y > 100)
      end
    end
  end
end

function LWSeason4MainView:UpdateData(skipAnim)
  if self.viewport and self.viewport.rectTransform then
    local canShowBanner = false
    if not SeasonUtil.IsInSeasonPrepareMode() then
      local theSeasonType = SeasonUtil.GetSeasonType()
      local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(theSeasonType)
      local factionSelectionActivityType = SeasonUtil.GetFactionSelectionActivityType(theSeasonType)
      local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionSelectionActivityType)
      if table.count(dataList) > 0 then
        canShowBanner = true
      else
        dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
        if table.count(dataList) > 0 then
          canShowBanner = true
        else
          local seasonSettleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if seasonSettleTime <= curTime then
            canShowBanner = true
          end
        end
      end
    end
    self.banner:SetActive(canShowBanner)
    if canShowBanner then
      self.viewport.rectTransform:Set_offsetMin(0, 10)
      self.viewport.rectTransform:Set_offsetMax(0, -187)
      self.banner:RefreshData()
    else
      self.viewport.rectTransform:Set_offsetMin(0, 10)
      self.viewport.rectTransform:Set_offsetMax(0, -5)
    end
  end
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.btn_rank:SetActive(false)
  else
    self.btn_rank:SetActive(true)
  end
  local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/LargeCell.prefab"
  if self.large == nil then
    self.large = UIBaseComponent.LoadComponentAsync(self, LWSeason4MainItem, prefabPath, self.content.transform)
  end
  self.large:ReInit(1, nil, "SeasonInfo", skipAnim)
  self.large:SetAsFirstSibling()
  self.actCellList = {}
  local ActivityIds = {}
  if SeasonUtil.IsInSeasonPrepareMode() then
    ActivityIds = DataCenter.SeasonDataManager:GetPrepareActivityIds()
  else
    ActivityIds = DataCenter.SeasonDataManager:GetActivityIds()
  end
  local activityList = self.ctrl:GetActivityGroupList()
  for i, v in ipairs(activityList) do
    if v and v.name and v.id then
      ActivityIds[tostring(v.id)] = false
    end
  end
  local notOpenList = {}
  local seasonActivity = DataCenter.SeasonDataManager.ActivityPreviewInfos or {}
  local timeMgr = UITimeManager:GetInstance()
  local curTime = timeMgr:GetServerTime()
  for activityId, v in pairs(ActivityIds) do
    if v then
      local previewInfo = seasonActivity[tostring(activityId)]
      if previewInfo and type(previewInfo) == "table" and previewInfo.startTime and previewInfo.previewTime then
        if curTime >= previewInfo.previewTime and curTime < previewInfo.startTime then
          local tmp = {id = activityId}
          tmp.startTime = previewInfo.startTime
          
          function tmp.GetValidType()
            return ActivityValidType.Later
          end
          
          ActivityInfoData.FetchActivityConfigData(tmp, activityId)
          table.insert(notOpenList, tmp)
        elseif curTime < previewInfo.previewTime then
          Logger.Log(string.format("[\232\181\155\229\173\163\230\180\187\229\138\168] %s \232\191\152\230\178\161\229\136\176\233\162\132\232\167\136\230\151\182\233\151\180", activityId))
        elseif curTime > previewInfo.startTime then
          Logger.Log(string.format("[\232\181\155\229\173\163\230\180\187\229\138\168] %s \229\183\178\231\187\143\230\173\163\229\188\143\229\188\128\230\148\190\228\189\134\230\152\175\230\156\141\229\138\161\229\153\168\230\178\161\228\184\139\229\143\145\230\180\187\229\138\168\230\149\176\230\141\174", activityId))
        end
      end
    end
  end
  table.sort(notOpenList, function(a, b)
    if a.order ~= b.order then
      return a.order < b.order
    else
      return false
    end
  end)
  for k, v in pairs(notOpenList) do
    table.insert(activityList, v)
  end
  local left_height = 0
  local right_height = 0
  local theParent
  local theLeftCount = 2
  local theRightCount = 2
  local theActiveCount = 0
  local theItemList = {}
  local actIdList = {}
  local theActList = self.theActList or {}
  local minRefreshTime = curTime + OneDayTime * 1000
  for i, v in ipairs(activityList) do
    if v and v.name and v.id and v.type ~= EnumActivity.SeasonFarmer.Type then
      local season_show_type = toInt(v.season_show_type or 2)
      if season_show_type == 2 then
        prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/MiddleCell.prefab"
      else
        prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/SmallCell.prefab"
      end
      if left_height <= right_height then
        theParent = self.left
        if season_show_type == 2 then
          left_height = left_height + 389 + 7
          theLeftCount = theLeftCount + 2
        else
          left_height = left_height + 191 + 7
          theLeftCount = theLeftCount + 1
        end
        theActiveCount = theLeftCount
      else
        theParent = self.right
        if season_show_type == 2 then
          right_height = right_height + 389 + 7
          theRightCount = theRightCount + 2
        else
          right_height = right_height + 191 + 7
          theRightCount = theRightCount + 1
        end
        theActiveCount = theRightCount
      end
      local theItem = theActList[v.id]
      if theItem == nil then
        theItem = UIBaseComponent.LoadComponentAsync(self, LWSeason4MainItem, prefabPath, theParent.transform)
        theActList[v.id] = theItem
      elseif theItem:AsyncLoadDone() and theItem.nodeParent ~= theParent then
        theItem.transform:SetParent(theParent.transform)
      end
      theItem:ReInit(math.ceil(theActiveCount / 2), v, nil, skipAnim)
      theItem:SetActive(true)
      theItem:SetAsLastSibling()
      theItem.nodeParent = theParent
      actIdList[v.id] = true
      if v.startTime and v.preview_time and 0 < toInt(v.preview_time) and timeMgr:IsSameDayForServer(tonumber(v.startTime) * 0.001, curTime * 0.001) then
        table.insert(self.actCellList, theItem)
      end
      if not skipAnim then
        table.insert(theItemList, theItem)
      end
      if theItem and theItem.endTime ~= nil and minRefreshTime > theItem.endTime then
        minRefreshTime = theItem.endTime
      end
    end
  end
  for k, v in pairs(theActList) do
    if actIdList[k] ~= true then
      self:RemoveAsyncComponent(v)
      theActList[k] = nil
    end
  end
  self.theActList = theActList
  self.theItemList = theItemList
  self.nextRefreshTime = math.max(minRefreshTime, curTime + 5000)
  self.content:SetSizeDeltaXY(788, math.max(left_height, right_height) + 400)
  self:OnScrollValueChange()
end

function LWSeason4MainView:Update1000MS()
  if self.nextRefreshTime ~= nil and self.nextRefreshTime ~= 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.nextRefreshTime - curTime
    if remainTime < 0 then
      self.nextRefreshTime = nil
      self:UpdateData(true)
    end
  end
end

return LWSeason4MainView
