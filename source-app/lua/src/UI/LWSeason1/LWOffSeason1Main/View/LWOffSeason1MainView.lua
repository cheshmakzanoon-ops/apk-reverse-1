local LWOffSeason1MainView = BaseClass("LWOffSeason1MainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWOffSeason1MainItem = require("UI.LWSeason1.LWOffSeason1Main.Component.LWOffSeason1MainItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local content_path = "Root/ActivityList/Viewport/Content"
local left_path = "Root/ActivityList/Viewport/Content/left"
local middle_cell_path = "Root/ActivityList/Viewport/Content/left/MiddleCell"
local right_path = "Root/ActivityList/Viewport/Content/right"
local small_cell_path = "Root/ActivityList/Viewport/Content/right/SmallCell"
local activity_list_path = "Root/ActivityList"
local large_cell_path = "Root/ActivityList/Viewport/Content/left/LargeCell"

function LWOffSeason1MainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
  if DataCenter.SeasonDataManager.OffSeasonActivityPreviewInfos == nil then
    DataCenter.SeasonDataManager:GetOffSeasonActivityPreviewInfo()
  end
  self.scroll_view:AddValueChangeListener(function(vec)
    self:OnScrollValueChange()
  end)
end

function LWOffSeason1MainView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWOffSeason1MainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UILWSingleActivityContainerClose, self.UpdateData)
  self:AddUIListener(EventId.PreviewActivityOffSeasonGet, self.UpdateData)
end

function LWOffSeason1MainView:OnRemoveListener()
  self:RemoveUIListener(EventId.UILWSingleActivityContainerClose, self.UpdateData)
  self:RemoveUIListener(EventId.PreviewActivityOffSeasonGet, self.UpdateData)
  base.OnRemoveListener(self)
end

function LWOffSeason1MainView:ComponentDefine()
  self.actCellList = nil
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItemM = self.transform:Find(middle_cell_path).gameObject
  self.theItemM:GameObjectCreatePool()
  self.theItemS = self.transform:Find(small_cell_path).gameObject
  self.theItemS:GameObjectCreatePool()
  self.theItemLarge = self.transform:Find(large_cell_path).gameObject
  self.theItemLarge:GameObjectCreatePool()
  self.scroll_view = self:AddComponent(UIScrollRect, activity_list_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.left = self:AddComponent(UIBaseContainer, left_path)
  self.right = self:AddComponent(UIBaseContainer, right_path)
end

function LWOffSeason1MainView:ComponentDestroy()
  self.left:RemoveComponents(LWOffSeason1MainItem)
  self.right:RemoveComponents(LWOffSeason1MainItem)
  self.theItemM:GameObjectRecycleAll()
  self.theItemS:GameObjectRecycleAll()
  self.theItemLarge:GameObjectRecycleAll()
  self.btn_back = nil
  self.scroll_view = nil
end

function LWOffSeason1MainView:OnScrollValueChange()
end

function LWOffSeason1MainView:UpdateData()
  self.left:RemoveComponents(LWOffSeason1MainItem)
  self.right:RemoveComponents(LWOffSeason1MainItem)
  self.theItemM:GameObjectRecycleAll()
  self.theItemS:GameObjectRecycleAll()
  self.theItemLarge:GameObjectRecycleAll()
  local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
  local data = DataCenter.SeasonTemplateManager:GetConfigData(seasonId)
  if data == nil then
    return
  end
  self.text_title:SetLocalText(data.truce_name)
  self.actCellList = {}
  local ActivityIds = {}
  for k, v in pairs(data.truceEnterActivityList) do
    ActivityIds[v] = true
  end
  local activityList = self.ctrl:GetActivityGroupList()
  local showActivityList = {}
  for k, v in pairs(activityList) do
    if v and v.id and ActivityIds[toInt(v.id)] then
      table.insert(showActivityList, v)
    end
  end
  self:CheckChampionDuelPreheatData(showActivityList)
  local timeMgr = UITimeManager:GetInstance()
  local curTime = timeMgr:GetServerTime()
  local notOpenList = {}
  local seasonActivity = DataCenter.SeasonDataManager.OffSeasonActivityPreviewInfos or {}
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
    table.insert(showActivityList, v)
  end
  local left_height = 0
  local right_height = 0
  local theParent, theTemplate
  local needPosY = 0
  local cgData
  for i, v in ipairs(showActivityList) do
    if v and v.name and v.id and v.type ~= EnumActivity.SeasonFarmer.Type then
      local season_show_type = toInt(v.season_show_type or 2)
      if season_show_type == 2 then
        theTemplate = self.theItemM
      elseif season_show_type == 3 then
        theTemplate = self.theItemS
      elseif season_show_type == 1 then
        theTemplate = self.theItemLarge
      end
      if season_show_type == 1 then
        theParent = self.left
        if left_height <= right_height then
          needPosY = right_height
          right_height = right_height + 389 + 7
          left_height = right_height
        else
          needPosY = left_height
          left_height = left_height + 389 + 7
          right_height = left_height
        end
      elseif left_height <= right_height then
        theParent = self.left
        needPosY = left_height
        if season_show_type == 2 then
          left_height = left_height + 389 + 7
        elseif season_show_type == 3 then
          left_height = left_height + 191 + 7
        end
      else
        theParent = self.right
        needPosY = right_height
        if season_show_type == 2 then
          right_height = right_height + 389 + 7
        elseif season_show_type == 3 then
          right_height = right_height + 191 + 7
        end
      end
      NameCount = NameCount + 1
      local goItem = theTemplate:GameObjectSpawn(theParent.transform)
      goItem.name = "cell_" .. NameCount
      goItem:SetActive(true)
      local theItem = theParent:AddComponent(LWOffSeason1MainItem, goItem.name)
      theItem:ReInit(v)
      theItem:SetAnchoredPositionXY(0, -needPosY)
      if v.startTime and v.preview_time and 0 < toInt(v.preview_time) and timeMgr:IsSameDayForServer(tonumber(v.startTime) * 0.001, curTime * 0.001) then
        table.insert(self.actCellList, theItem)
      end
    end
    local isExist, cData = self:CheckIsExistCG(v)
    if isExist and cData and not cgData then
      cgData = cData
    end
  end
  self.content:SetSizeDeltaXY(788, math.max(left_height, right_height) + 400)
  self:OnScrollValueChange()
  self:PlayTargetCGVideo(cgData)
end

function LWOffSeason1MainView:PlayTargetCGVideo(cgData)
  if not cgData then
    return
  end
  local plotId = cgData.plotId
  local cgPath = cgData.cgPath
  
  local function playPlotFunc()
    if 0 < plotId then
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
    end
  end
  
  if string.IsNullOrEmpty(cgPath) then
    playPlotFunc()
    return
  end
  local params = {}
  params.path = cgPath
  params.onVideoCloseCallback = playPlotFunc
  UIManager:GetInstance():OpenWindow(UIWindowNames.FullScreenVideoView, {anim = true}, params)
end

function LWOffSeason1MainView:CheckIsExistCG(activityData)
  if not activityData then
    return false
  end
  local plotStr = activityData.plot
  local plotStrArr = string.split(plotStr, "|")
  if #plotStrArr < 2 then
    return false
  end
  local key = "CG_" .. activityData.activityId
  local cache = Setting:GetPrivateString(key)
  if cache ~= "ok" then
    Setting:SetPrivateString(key, "ok")
    local cgData = {}
    cgData.plotId = tonumber(plotStrArr[1])
    cgData.cgPath = plotStrArr[2]
    return true, cgData
  end
  return false
end

function LWOffSeason1MainView:CheckChampionDuelPreheatData(list)
  if not LuaEntry.Player:AtHomeNow() then
    local acts = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ChampionDuelMain.Type)
    for _, v in pairs(acts) do
      self:RemoveActInfoById(v.id, list)
    end
  end
end

function LWOffSeason1MainView:RemoveActInfoById(checkId, list)
  local have = true
  while have do
    have = false
    for i, v in ipairs(list) do
      if v.id == checkId then
        table.remove(list, i)
        have = true
        break
      end
    end
  end
end

return LWOffSeason1MainView
