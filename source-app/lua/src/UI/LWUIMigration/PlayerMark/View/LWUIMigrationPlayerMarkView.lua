local LWUIMigrationPlayerMarkView = BaseClass("LWUIMigrationPlayerMarkView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.ActMigrationManager
local LWUIMigrationPlayerMarkItem = require("UI.LWUIMigration.PlayerMark.Component.LWUIMigrationPlayerMarkItem")
local LWUIMigrationPlayerMarkTog = require("UI.LWUIMigration.PlayerMark.Component.LWUIMigrationPlayerMarkTog")
local IMG_UP_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_1.png"
local IMG_DOWN_PATH = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_xiao_2.png"
local ALL_SERVER_ID = 0

function LWUIMigrationPlayerMarkView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigrationPlayerMarkView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigrationPlayerMarkView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compInputField = self.viewSkin:AddComponent(self, UIInput, 3)
  self.btnSearch = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnSearch:SetOnClick(function()
    self:OnBtnSearchClick()
  end)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 6)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgGroupArr = self.viewSkin:AddComponent(self, UIImage, 9)
  self.btnGroup = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnGroup:SetOnClick(function()
    self:OnBtnGroupClick()
  end)
  self.compGroupContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compGroupCell = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.btnGroupContent = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnGroupContent:SetOnClick(function()
    self:OnBtnGroupContentClick()
  end)
end

function LWUIMigrationPlayerMarkView:ComponentDestroy()
  self.viewSkin = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.compInputField = nil
  self.btnSearch = nil
  self.textGroup = nil
  self.compScrollView = nil
  self.compContent = nil
  self.textEmpty = nil
  self.imgGroupArr = nil
  self.btnGroup = nil
  self.compGroupContent = nil
  self.compGroupCell = nil
  self.btnGroupContent = nil
end

function LWUIMigrationPlayerMarkView:DataDefine()
  self.compGroupCell:SetActive(false)
  self.group_cell = self.compGroupCell.gameObject
  self.group_cell:GameObjectCreatePool()
  self.groupCells = {}
  self.curIdx = 1
  self.curServerId = ALL_SERVER_ID
  self.togCb = BindCallback(self, self.SetTog)
  self.compScrollView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  self.compInputField:SetOnValueChange(function(value)
    if string.IsNullOrEmpty(value) then
      self:OnRefreshSearchResult(nil)
    end
  end)
  self.serverDic = DataCenter.ActMigrationManager:GetAllMarkUids()
  self:OnRefreshSearchResult(nil)
end

function LWUIMigrationPlayerMarkView:DataDestroy()
  self.compGroupContent:RemoveComponents(LWUIMigrationPlayerMarkTog)
  self.group_cell:GameObjectRecycleAll()
  self.group_cell = nil
  self.compContent:RemoveComponents(LWUIMigrationPlayerMarkItem)
  self.compScrollView:ClearAllItems()
  self.searchUids = nil
  self.groupCells = nil
  self.serverDic = nil
end

function LWUIMigrationPlayerMarkView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActMigrationMarkPlayerUpdate, self.OnRefreshMigrationSign)
  self:AddUIListener(EventId.ActMigrationMarkPlayerSearchUpdate, self.OnRefreshSearchResult)
end

function LWUIMigrationPlayerMarkView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActMigrationMarkPlayerUpdate, self.OnRefreshMigrationSign)
  self:RemoveUIListener(EventId.ActMigrationMarkPlayerSearchUpdate, self.OnRefreshSearchResult)
  base.OnRemoveListener(self)
end

function LWUIMigrationPlayerMarkView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIMigrationPlayerMarkView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function LWUIMigrationPlayerMarkView:OnBtnSearchClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local content = self.compInputField:GetText()
  if string.IsNullOrEmpty(content) then
    self:OnRefreshSearchResult(nil)
    return
  end
  ActMgr:ReqPlayerMarkSearch(content)
end

function LWUIMigrationPlayerMarkView:OnBtnGroupClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.groupShow = not self.groupShow
  self:RefreshGroupSel()
end

function LWUIMigrationPlayerMarkView:OnBtnGroupContentClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.groupShow = false
  self:RefreshGroupSel()
end

function LWUIMigrationPlayerMarkView:OnRefreshMigrationSign(uid)
  local serverId = ActMgr:GetPlayerMark(uid)
  if serverId ~= nil then
    return
  end
  local oldServerId = self:GetUidServerId(uid)
  self:RemoveUidFromServer(ALL_SERVER_ID, uid)
  if oldServerId ~= nil then
    self:RemoveUidFromServer(oldServerId, uid)
  end
  self:RebuildServerIds()
end

function LWUIMigrationPlayerMarkView:OnRefreshSearchResult(uids)
  if uids == nil then
    self.searchUids = nil
  else
    self.searchUids = {}
    for _, uid in ipairs(uids) do
      table.insert(self.searchUids, uid)
    end
  end
  self:RebuildServerIds()
end

function LWUIMigrationPlayerMarkView:GetCurUids()
  if self.searchUids ~= nil then
    return self.searchUids
  end
  local serverId = self.serverIds[self.curIdx]
  if serverId == nil then
    return {}
  end
  local uids = self.serverDic[serverId]
  return uids or {}
end

function LWUIMigrationPlayerMarkView:GetUidServerId(uid)
  for serverId, list in pairs(self.serverDic) do
    if serverId ~= ALL_SERVER_ID and table.indexof(list, uid) ~= false then
      return serverId
    end
  end
end

function LWUIMigrationPlayerMarkView:RemoveUidFromServer(serverId, uid)
  if serverId == ALL_SERVER_ID and self.searchUids ~= nil then
    table.removebyvalue(self.searchUids, uid)
  end
  local uids = self.serverDic[serverId]
  if uids ~= nil then
    if 0 < #uids then
      table.removebyvalue(uids, uid)
    end
    if #uids == 0 then
      self.serverDic[serverId] = nil
    end
  end
end

function LWUIMigrationPlayerMarkView:GetSelectedServerId()
  if self.serverIds == nil then
    return ALL_SERVER_ID
  end
  return self.serverIds[self.curIdx] or ALL_SERVER_ID
end

function LWUIMigrationPlayerMarkView:RebuildServerIds()
  local ids = {}
  local keepServerId = self.searchUids == nil and (self.curServerId or self:GetSelectedServerId()) or ALL_SERVER_ID
  if self.searchUids == nil then
    local keys = table.keys(self.serverDic)
    if table.IsNotEmpty(self.serverDic) then
      for i, sId in ipairs(keys) do
        local uids = self.serverDic[sId]
        if uids ~= nil and 0 < #uids then
          table.insert(ids, sId)
        end
      end
      table.sort(ids, function(a, b)
        return a < b
      end)
    end
  end
  if table.IsNullOrEmpty(ids) then
    ids = {ALL_SERVER_ID}
  end
  self.serverIds = ids
  self:RefreshCurIdx(keepServerId)
end

function LWUIMigrationPlayerMarkView:RefreshCurIdx(curServerId)
  self.curIdx = 1
  if curServerId ~= nil then
    local idx = table.indexof(self.serverIds, curServerId)
    if idx ~= false then
      self.curIdx = idx
    end
  end
  self:SetTog(self.curIdx, true)
end

function LWUIMigrationPlayerMarkView:SetTog(idx, bForce)
  if not bForce and self.curIdx == idx then
    self.groupShow = false
    self:RefreshGroupSel()
    return
  end
  local groupCnt = #self.serverIds
  self.curIdx = math.max(1, math.min(idx, 0 < groupCnt and groupCnt or 1))
  local sId = self.serverIds[self.curIdx]
  if self.searchUids == nil then
    self.curServerId = sId
  end
  local str = sId == ALL_SERVER_ID and Localization:GetString("151110") or Localization:GetString(208236, sId)
  self.textGroup:SetText(str)
  self.groupShow = false
  self:RefreshGroupSel()
  self:RefreshList()
end

function LWUIMigrationPlayerMarkView:RefreshList()
  local uids = self:GetCurUids()
  local l = #uids
  self.compScrollView:SetActive(0 < l)
  self.textEmpty:SetActive(l == 0)
  if 0 < l then
    self.compScrollView:SetListItemCount(l, false, false)
    self.compScrollView:RefreshAllShownItem()
  else
    self.compScrollView:SetListItemCount(0, false, false)
  end
end

function LWUIMigrationPlayerMarkView:OnGetItemByIndex(loopScroll, index)
  local i = index + 1
  local uids = self:GetCurUids()
  if i < 1 or i > #uids then
    return nil
  end
  local item = loopScroll:NewListViewItem("LWUIMigrationPlayerMarkItem")
  local cell = self.compContent:GetComponent(item.gameObject.name, LWUIMigrationPlayerMarkItem)
  if cell == nil then
    item.name = UIUtil.GetLoopListItemIndex("Item_")
    cell = self.compContent:AddComponent(LWUIMigrationPlayerMarkItem, item.name)
  end
  cell:SetActive(true)
  cell:SetPlayer(uids[i])
  return item
end

function LWUIMigrationPlayerMarkView:RefreshGroupSel()
  self.imgGroupArr:LoadSpriteAuto(self.groupShow and IMG_UP_PATH or IMG_DOWN_PATH)
  self.imgGroupArr:SetActive(true)
  self.compGroupContent:SetActive(self.groupShow)
  if not self.groupShow then
    return
  end
  local groupCount = #self.serverIds
  local max = math.max(#self.groupCells, groupCount)
  for i = 1, max do
    local cell = self.groupCells[i]
    local id = self.serverIds[i]
    if id ~= nil then
      if cell then
        cell:SetActive(true)
      else
        local obj = self.group_cell:GameObjectSpawn(self.compGroupContent.transform)
        obj.name = "tog" .. i
        cell = self.compGroupContent:AddComponent(LWUIMigrationPlayerMarkTog, obj.name)
        self.groupCells[i] = cell
      end
      cell:SetActive(true)
      cell:SetData(i, id, i == self.curIdx, self.togCb)
    elseif cell then
      cell:SetActive(false)
    end
  end
end

return LWUIMigrationPlayerMarkView
