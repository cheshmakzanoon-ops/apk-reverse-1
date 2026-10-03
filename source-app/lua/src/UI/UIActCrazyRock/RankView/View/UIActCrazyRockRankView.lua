local UIActCrazyRockRankView = BaseClass("UIActCrazyRockRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActCrazyRockRankItem = require("UI.UIActCrazyRock.RankView.Component.UIActCrazyRockRankItem")
local M = UIActCrazyRockRankView
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local defaultIndex = 1

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId = self:GetUserData()
  self:InitView()
end

function M:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgTopBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.scrollRect = self.viewSkin:AddComponent(self, UILoopListView2, 2)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compSelfContent = self.viewSkin:AddComponent(self, UIActCrazyRockRankItem, 4)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 6)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.compDropDown = self.viewSkin:AddComponent(self, TCCommonDropDown, 8)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.scrollRect:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function M:ComponentDestroy()
  self.viewSkin = nil
  self.imgTopBg = nil
  self.scrollRect = nil
  self.compContent = nil
  self.compSelfContent = nil
  self.textEmpty = nil
  self.imgBg = nil
  self.btnBack = nil
  self.compDropDown = nil
  self.textTitle = nil
end

function M:DataDefine()
  self.activityId = 0
  self.curRankArr = {}
end

function M:DataDestroy()
  self.activityId = nil
  self.curRankArr = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CrazyRockRecRankData, self.OnRecRankData)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CrazyRockRecRankData, self.OnRecRankData)
end

function M:OnBtnBackClick()
  self.ctrl:CloseSelf()
end

function M:InitView()
  self.textEmpty:SetLocalText("activity_99179_rank_blank_6")
  if not self.activityId or self.activityId == 0 then
    Logger.LogError("activityId is wrong")
    return
  end
  self.textEmpty:SetActive(true)
  self:SetBg()
  self:InitDropList()
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.curRankArr then
    return nil
  end
  local rankData = self.curRankArr[index]
  local item = loopScroll:NewListViewItem("ItemContent")
  local script = self.compContent:GetComponent(item.gameObject.name, UIActCrazyRockRankItem)
  if script == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    script = self.compContent:AddComponent(UIActCrazyRockRankItem, nameStr)
  end
  script:SetActive(true)
  script:SetData(rankData, self.activityId)
  return item
end

function M:RefreshScroll()
  if self.scrollRect == nil or #self.curRankArr == 0 then
    self.scrollRect:SetActive(false)
    self.textEmpty:SetActive(true)
  else
    self.textEmpty:SetActive(false)
    self.scrollRect:SetActive(true)
    self.scrollRect:SetListItemCount(#self.curRankArr, false, false)
    self.scrollRect:RefreshAllShownItem()
  end
end

function M:ClearScroll()
  self.compContent:RemoveComponents(UIActCrazyRockRankItem)
  self.scrollRect:ClearAllItems()
end

function M:OnRecRankData()
  local rankData = DataCenter.ActCrazyRockDataManager:GetRankData(self.activityId)
  if not rankData then
    Logger.LogError("rankData is nil")
    return
  end
  self.curRankArr = rankData.rankArr or {}
  self:RefreshScroll()
  self:RefreshSelfItem(rankData)
end

function M:RefreshSelfItem(rankData)
  local selfRankData = {}
  local owner = rankData.owner
  if not rankData.owner then
    Logger.LogError("rankData.owner is nil")
    return
  end
  selfRankData.score = owner.score
  selfRankData.rank = owner.rank
  selfRankData.name = LuaEntry.Player:GetName()
  selfRankData.abbr = LuaEntry.Player:IsInAlliance() and LuaEntry.Player:GetAllianceAbbr() or ""
  selfRankData.uid = LuaEntry.Player:GetUid()
  selfRankData.pic = LuaEntry.Player:GetPic()
  selfRankData.picVer = LuaEntry.Player:GetPicVer()
  selfRankData.serverId = LuaEntry.Player:GetServerId()
  selfRankData.accuracyRate = owner.accuracyRate
  selfRankData.isSelf = true
  self.compSelfContent:SetData(selfRankData, self.activityId)
end

function M:SetBg()
  if not self.activityId then
    Logger.LogError("activityId is nil")
    return
  end
  local lineData = LocalController:instance():getLine(TableName.Activity, self.activityId)
  if lineData == nil or string.IsNullOrEmpty(lineData.festival_interface_config) then
    Logger.LogError("Activity festival_interface_config is nil id:" .. self.activityId)
    return
  end
  local festivalPackagingCfgId = tonumber(lineData.festival_interface_config)
  lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalPackagingCfgId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. festivalPackagingCfgId)
    return
  end
  local bannerList = string.split(lineData.banner, "|")
  local imgPath = bannerList[2]
  self.imgTopBg:LoadSpriteAsyncWithCallback(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, imgPath))
  if not string.IsNullOrEmpty(lineData.bg) then
    self.imgBg:LoadSpriteAsync(DataCenter.ActivityListDataManager:GetActivityModLoadPath(activityThemPath, lineData.bg))
  end
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData and not string.IsNullOrEmpty(actData.festivalEntranceName) then
    self.textTitle:SetLocalText(actData.festivalEntranceName)
  else
    self.textTitle:SetLocalText("")
  end
end

function M:InitDropList()
  local musicConfig = DataCenter.ActCrazyRockDataManager:GetMusicConfig(self.activityId)
  if not musicConfig then
    Logger.LogError("musicConfig is nil")
    return
  end
  self.songRankList = {}
  local allText = Localization:GetString("activity_99179_rank_1")
  table.insert(self.songRankList, {songName = allText, songId = -1})
  local songList = musicConfig.song_list
  if string.IsNullOrEmpty(songList) then
    Logger.LogError("songList is nil")
    return
  end
  local songIdList = string.split(songList, ";")
  for _, songIdStr in ipairs(songIdList) do
    local songId = tonumber(songIdStr)
    local songData = DataCenter.ActCrazyRockDataManager:GetSongData(songId)
    if songData then
      table.insert(self.songRankList, {
        songName = Localization:GetString(songData.songNameKey),
        songId = songId
      })
    end
  end
  for _, v in pairs(self.songRankList) do
    self.compDropDown:Add(v.songName, true)
  end
  self.compDropDown:BindIndexChangeEvent(function(index)
    self:OnSelectSongRank(index)
  end)
  self.compDropDown:OnSelectIndexChange(defaultIndex)
end

function M:OnSelectSongRank(index)
  local songData = self.songRankList[index]
  if not songData then
    Logger.LogError("songData is nil index:" .. tostring(index))
    return
  end
  self.ctrl:RequestRankData(self.activityId, songData.songId)
end

return M
