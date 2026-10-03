local ComicManager = BaseClass("ComicManager")

function ComicManager:__init()
  self.readMap = {}
  self.archiveMap = {}
  self.curPlotGroupId = nil
  self:AddListener()
end

function ComicManager:__delete()
  self.readMap = nil
  self.archiveMap = nil
  self:RemoveListener()
end

function ComicManager:Init(message)
  if message.archive then
    local archiveObj = message.archive
    if archiveObj[tostring(ArchiveSaveType.Comic)] then
      self:OnReadOrArchiveComicHandler(archiveObj[tostring(ArchiveSaveType.Comic)])
    end
  end
end

function ComicManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.OnEnterWorldFromCity, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.GF_plot_group_done, self.OnPlotGroupDone)
end

function ComicManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorldFromCity, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.GF_plot_group_done, self.OnPlotGroupDone)
end

function ComicManager:OnEnterWorld()
  local season = DataCenter.SeasonDataManager:GetSeason() or 0
  local prefStr = FirstEnterWorldKey .. LuaEntry.Player.uid .. season
  local mainLevel = DataCenter.BuildManager:GetMaxBuildingLevel(BuildingTypes.FUN_BUILD_MAIN)
  local groupIdList = DataCenter.ComicTemplateManager:GetGroupIdByTypeAndParam(EComicShowType.GameSeason, {season, mainLevel})
  if not table.IsNullOrEmpty(groupIdList) then
    local groupId = groupIdList[1]
    if groupId ~= 1 and groupId ~= 2 and groupId ~= 3 then
      prefStr = prefStr .. groupId
    end
  end
  local isFirstEnterWorld = CS.GameEntry.Setting:GetBool(prefStr, true)
  if isFirstEnterWorld then
    if table.IsNullOrEmpty(groupIdList) then
      UIUtil.CheckEventTrigger(OpMode.EnterWorld)
    else
      local templateGroup = DataCenter.ComicTemplateManager:GetGroupTemplate(groupIdList[1])
      if 0 < season and templateGroup and 0 < templateGroup.plot_id then
        DataCenter.ComicManager.curPlotGroupId = templateGroup.plot_id
      else
        DataCenter.ComicManager.curPlotGroupId = nil
        UIUtil.CheckEventTrigger(OpMode.EnterWorld)
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWComic, {anim = false}, groupIdList[1])
      CS.GameEntry.Setting:SetBool(prefStr, false)
    end
  end
end

local function OnPlotGroupDone(groupId)
  if DataCenter.ComicManager.curPlotGroupId == groupId then
    UIUtil.CheckEventTrigger(OpMode.EnterWorld)
  end
  DataCenter.ComicManager.curPlotGroupId = nil
end

function ComicManager:OnReadOrArchiveSingleComic(comicIdList, isRead)
  local selfMap
  if isRead then
    selfMap = self.readMap
  else
    selfMap = self.archiveMap
  end
  for k, v in pairs(comicIdList) do
    selfMap[v] = 1
  end
  local oneData = {}
  oneData.readMap = self.readMap
  oneData.archiveMap = self.archiveMap
  SFSNetwork.SendMessage(MsgDefines.ArchiveSave, ArchiveSaveType.Comic, oneData)
end

function ComicManager:OnReadOrArchiveComicHandler(message)
  if message.readList then
    self.readMap = {}
    for k, v in pairs(message.readList) do
      self.readMap[v] = 1
    end
  end
  if message.archiveList then
    self.archiveMap = {}
    for k, v in pairs(message.archiveList) do
      self.archiveMap[v] = 1
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ReadNewComic)
end

function ComicManager:GetAllReadOrArchiveSingleComic(isRead)
  return isRead and self.readMap or self.archiveMap
end

function ComicManager:IsAnyUnArchiveComic()
  local readComicMap = self:GetAllReadOrArchiveSingleComic(true)
  local archiveComicMap = self:GetAllReadOrArchiveSingleComic(false)
  for k, v in pairs(readComicMap) do
    if archiveComicMap[k] == nil then
      return true
    end
  end
  return false
end

ComicManager.OnPlotGroupDone = OnPlotGroupDone
return ComicManager
