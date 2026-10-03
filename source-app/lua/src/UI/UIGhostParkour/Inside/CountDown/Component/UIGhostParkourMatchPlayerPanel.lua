local base = UIBaseContainer
local UIGhostParkourMatchPlayerPanel = BaseClass("UIGhostParkourMatchPlayerPanel", base)
local UIGhostParkourMatchPlayerItem = require("UI.UIGhostParkour.Inside.CountDown.Component.UIGhostParkourMatchPlayerItem")
local title_txt_path = "TitleTxt"
local container_path = "Container"
local match_player_item_path = "MatchPlayerItem"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
  self.container = self:AddComponent(UIBaseContainer, container_path)
  self.item = self.transform:Find(match_player_item_path).gameObject
  self.item:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self.title_txt = nil
  self.container:RemoveComponents(UIGhostParkourMatchPlayerItem)
  self.container = nil
  self.item:GameObjectRecycleAll()
  self.item = nil
end

function UIGhostParkourMatchPlayerPanel:InitItem(param, isPlayback)
  if param == nil then
    Logger.LogError("GhostParkour -- [InitItem] player info is nil")
    return
  end
  if isPlayback then
    if param.firstInfo and param.firstInfo.markFlag ~= 1 then
      self:SpawnOneItem(1, param.firstInfo, true)
    end
    if param.otherInfo and param.otherInfo.markFlag ~= 1 then
      self:SpawnOneItem(2, param.otherInfo)
    end
    return
  end
  local matchList = param.matchList
  if matchList then
    local selfData = {}
    local player = LuaEntry.Player
    selfData.uid = player:GetUid()
    selfData.pic = player:GetPic()
    selfData.picver = player:GetPicVer()
    local allianceId = player:GetAllianceUid()
    if string.IsNullOrEmpty(allianceId) then
      selfData.abbr = ""
    else
      selfData.abbr = player:GetAllianceAbbr()
    end
    selfData.name = player:GetName()
    selfData.score = param.score
    selfData.tier = param.tier
    self:SpawnOneItem(1, selfData, true)
    local count = matchList and #matchList or 0
    for i = 1, count do
      local data = matchList[i]
      if data and data.markFlag ~= 1 then
        self:SpawnOneItem(i + 1, data)
      end
    end
  end
end

function UIGhostParkourMatchPlayerPanel:SpawnOneItem(index, data, isSelf)
  if data == nil then
    return
  end
  local goItem = self.item:GameObjectSpawn(self.container.transform)
  goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
  goItem:SetActive(true)
  local theItem = self.container:AddComponent(UIGhostParkourMatchPlayerItem, goItem.name)
  theItem:ReInit(index, data, isSelf)
end

UIGhostParkourMatchPlayerPanel.OnCreate = OnCreate
UIGhostParkourMatchPlayerPanel.OnDestroy = OnDestroy
UIGhostParkourMatchPlayerPanel.ComponentDefine = ComponentDefine
UIGhostParkourMatchPlayerPanel.ComponentDestroy = ComponentDestroy
return UIGhostParkourMatchPlayerPanel
