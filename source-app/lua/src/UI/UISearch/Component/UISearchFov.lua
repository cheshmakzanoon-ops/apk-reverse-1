local base = UIAsyncContainer
local UISearchFov = BaseClass("UISearchFov", base)
local Localization = CS.GameEntry.Localization
local Gray = CS.UIGray
local ServerItem = require("UI.UISearch.Component.UISearchFovServerItem")
local FovItem = require("UI.UISearch.Component.UISearchFovItem")

function UISearchFov:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UISearchFov:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISearchFov:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTxtEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.horizontalInfinityScrollViewServersContent = self.viewSkin:AddComponent(self, HorizontalInfinityScrollView, 2)
  self.compServersContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.compServers = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compSearchRect = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.btnCancelSearch = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnCancelSearch:SetOnClick(function()
    self:OnBtnCancelSearchClick()
  end)
  self.inputFieldInputSearch = self.viewSkin:AddComponent(self, UIInput, 7)
  self.compFovs = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.gridInfinityScrollViewFovsContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 9)
  self.compFovsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compBookmarkArrow = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compBottomRect = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.btnShowBatch = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnShowBatch:SetOnClick(function()
    self:OnBtnShowBatchClick()
  end)
  self.textTmpShowBatch = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnDelete = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.textTmpDelAll = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnSelectAll = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnSelectAll:SetOnClick(function()
    self:OnBtnSelectAllClick()
  end)
  self.textTmpSelectAll = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.keyword = nil
  self.btnCancelSearch:SetActive(false)
  self.inputFieldInputSearch:SetText(nil)
  self.inputFieldInputSearch:SetOnValueChange(function(val)
    self.keyword = val
    self:RefreshSearchFilter()
  end)
  self.textTxtEmpty:SetLocalText(128007)
  self.textTmpSelectAll:SetLocalText("world_btn_1002")
  self.inMultiSelectMode = false
  self:InitServers()
  self:InitFovs()
end

function UISearchFov:ComponentDestroy()
  self:ClearServers()
  self:ClearFovs()
  self.viewSkin = nil
  self.textTxtEmpty = nil
  self.horizontalInfinityScrollViewServersContent = nil
  self.compServersContent = nil
  self.compServers = nil
  self.compSearchRect = nil
  self.btnCancelSearch = nil
  self.inputFieldInputSearch = nil
  self.compFovs = nil
  self.gridInfinityScrollViewFovsContent = nil
  self.compFovsContent = nil
  self.compBookmarkArrow = nil
  self.btnClose = nil
  self.compBottomRect = nil
  self.btnShowBatch = nil
  self.textTmpShowBatch = nil
  self.btnDelete = nil
  self.textTmpDelAll = nil
  self.btnSelectAll = nil
  self.textTmpSelectAll = nil
end

function UISearchFov:DataDefine()
  self.multiSelections = {}
end

function UISearchFov:DataDestroy()
  self.serverIdList = nil
  self.serverId2FovList = nil
  self.currentFovList = nil
  self.keyword = nil
  self:SaveServerRecord()
end

function UISearchFov:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

function UISearchFov:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  base.OnRemoveListener(self)
end

function UISearchFov:ReInit(tab, posX)
  self.curTab = tab
  self.currentSelectServer = self:GetRecordServer() or -1
  self.serverIdList, self.serverId2FovList = self.view.ctrl:GetMarkListByTab(self.curTab, self.keyword)
  if not self.serverId2FovList[self.currentSelectServer] then
    self.currentSelectServer = -1
  end
  self:ClearTempMultiSelections()
  self:RefreshServers()
  self:ResetPosition(posX)
  self:RefreshSelectServer()
  self:RefreshMultiSelect()
end

function UISearchFov:GetRecordServer()
  if not self.lastServerRecord then
    self.lastServerRecord = {}
  end
  local lastServer = self.lastServerRecord[self.curTab]
  if not lastServer then
    local key = string.format("Bookmark_record_%s", self.curTab)
    lastServer = CommonUtil.PlayerPrefsGetInt(key, -1)
  end
  self.lastServerRecord[self.curTab] = lastServer
  if CommonUtil.IsDebug() then
    Logger.Log(string.format("[Bookmark]%s\228\184\138\230\172\161\232\174\176\229\189\149\231\154\132\230\156\141\229\138\161\229\153\168\230\152\175\239\188\154%s", self.curTab, lastServer))
  end
  return lastServer
end

function UISearchFov:ResetPosition(posX)
  local arrowPosX = posX
  local arrowPosY = self.compBookmarkArrow.transform.position.y
  self.compBookmarkArrow.transform.position = Vector3.New(arrowPosX, arrowPosY, 0)
end

function UISearchFov:OnBtnCloseClick()
  if self.view then
    self.view:CloseBookMark()
  end
end

function UISearchFov:ClearServers()
  self.compServersContent:RemoveComponents(ServerItem)
  self.horizontalInfinityScrollViewServersContent:DestroyChildNode()
  self.allServerItems = {}
  self.validServerItems = {}
end

function UISearchFov:InitServers()
  self:ClearServers()
  self.horizontalInfinityScrollViewServersContent:Init(BindCallback(self, self.OnInitServerItem), BindCallback(self, self.OnUpdateServerItem), BindCallback(self, self.OnDestroyServerItem))
end

function UISearchFov:OnInitServerItem(go, index)
  local item = self.compServersContent:AddComponent(ServerItem, go)
  item:SetActive(false)
  self.allServerItems[go] = item
end

function UISearchFov:OnUpdateServerItem(go, index)
  local cellItem = self.allServerItems[go]
  if cellItem then
    cellItem:SetActive(true)
    local serverId = self.serverIdList[index + 1]
    cellItem:ReInit(self, index, serverId)
    cellItem:UpdateCurrentSelected(self.currentSelectServer)
    self.validServerItems[go] = cellItem
  end
end

function UISearchFov:OnDestroyServerItem(go, index)
  if self.validServerItems[go] then
    self.validServerItems[go] = nil
  end
end

function UISearchFov:ChangeServerImpl(serverId)
  self.currentSelectServer = serverId
  self:RecordServer(self.currentSelectServer)
  self:ClearTempMultiSelections()
  self:RefreshSelectServer()
  self:RefreshMultiSelect()
  if self.validServerItems then
    for k, v in pairs(self.validServerItems) do
      if v then
        v:UpdateCurrentSelected(self.currentSelectServer)
      end
    end
  end
  self:RefreshServerTogglePos()
end

function UISearchFov:OnClickedServer(serverId)
  if serverId == self.currentSelectServer then
    return
  end
  if self.inMultiSelectMode and self.multiSelections and table.count(self.multiSelections) > 0 then
    local sId = serverId
    UIUtil.ShowMessage(Localization:GetString("world_tip10020"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:ChangeServerImpl(sId)
    end)
    return
  end
  self:ChangeServerImpl(serverId)
end

function UISearchFov:RefreshServers()
  if not self.serverIdList or #self.serverIdList <= 1 then
    self.compServers:SetActive(false)
  else
    self.compServers:SetActive(true)
    self.horizontalInfinityScrollViewServersContent:SetItemCount(#self.serverIdList)
    self:RefreshServerTogglePos()
  end
end

function UISearchFov:RecordServer(serverId)
  if not self.lastServerRecord then
    self.lastServerRecord = {}
  end
  self.lastServerRecord[self.curTab] = serverId
end

function UISearchFov:SaveServerRecord()
  if self.lastServerRecord then
    for k, v in pairs(self.lastServerRecord) do
      local key = string.format("Bookmark_record_%s", k)
      local server = tonumber(v) or -1
      CommonUtil.PlayerPrefsSetInt(key, server)
    end
  end
end

function UISearchFov:RefreshSelectServer()
  if not self.serverId2FovList[self.currentSelectServer] then
    self.currentSelectServer = -1
  end
  self.currentFovList = self.serverId2FovList[self.currentSelectServer] or {}
  self.gridInfinityScrollViewFovsContent:SetItemCount(#self.currentFovList)
  self.textTxtEmpty:SetActive(#self.currentFovList <= 0)
  self.compBottomRect:SetActive(self.curTab < 3 and #self.currentFovList > 0)
end

function UISearchFov:ClearFovs()
  self.compFovsContent:RemoveComponents(FovItem)
  self.gridInfinityScrollViewFovsContent:DestroyChildNode()
  self.allFovItems = {}
  self.validFovItems = {}
end

function UISearchFov:InitFovs()
  self:ClearFovs()
  self.gridInfinityScrollViewFovsContent:Init(BindCallback(self, self.OnInitFovItem), BindCallback(self, self.OnUpdateFovItem), BindCallback(self, self.OnDestroyFovItem))
end

function UISearchFov:OnInitFovItem(go, index)
  local item = self.compFovsContent:AddComponent(FovItem, go)
  item:SetActive(false)
  self.allFovItems[go] = item
end

function UISearchFov:OnUpdateFovItem(go, index)
  local cellItem = self.allFovItems[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    local fov = self.currentFovList[theIndex]
    cellItem:ReInit(self, theIndex, fov)
    self.validFovItems[go] = cellItem
  end
end

function UISearchFov:OnDestroyFovItem(go)
  if self.validFovItems[go] then
    self.validFovItems[go] = nil
  end
end

function UISearchFov:RefreshMarkList()
  self.serverIdList, self.serverId2FovList = self.view.ctrl:GetMarkListByTab(self.curTab, self.keyword)
  if self.currentSelectServer and not self.serverId2FovList[self.currentSelectServer] and self.serverId2FovList[-1] then
    self:OnClickedServer(-1)
  end
  self:RefreshServers()
  self:RefreshSelectServer()
end

function UISearchFov:OnBtnShowBatchClick()
  self:SetBatchMode(not self.inMultiSelectMode)
end

function UISearchFov:SetBatchMode(enable)
  self.inMultiSelectMode = enable
  self:ClearTempMultiSelections()
  self:RefreshMultiSelect()
  if self.validFovItems then
    for k, v in pairs(self.validFovItems) do
      if v then
        v:OnMultiSelectModeChanged(self.inMultiSelectMode)
      end
    end
  end
end

function UISearchFov:RefreshMultiSelect()
  local showBottom = self.serverId2FovList ~= nil and self.curTab and self.curTab < 3
  showBottom = showBottom and self.serverId2FovList[-1] and #self.serverId2FovList[-1] > 0
  self.compBottomRect:SetActive(showBottom)
  if not showBottom then
    return
  end
  if self.inMultiSelectMode then
    self.textTmpShowBatch:SetLocalText("393109")
    local ct = table.count(self.multiSelections)
    if ct <= 0 then
      self.textTmpDelAll:SetLocalText("btn_delete")
    else
      self.textTmpDelAll:SetLocalText("world_btn_1001", ct)
    end
    Gray.SetGray(self.btnDelete.transform, ct <= 0, 0 < ct)
    self.btnDelete:SetActive(true)
    self.btnSelectAll:SetActive(true)
  else
    self.textTmpShowBatch:SetLocalText("poll_multiple")
    self.btnDelete:SetActive(true)
    self.btnSelectAll:SetActive(true)
    self.textTmpDelAll:SetLocalText("btn_delete")
    Gray.SetGray(self.btnDelete.transform, true, false)
  end
end

function UISearchFov:GetMultiSelectMode()
  return self.inMultiSelectMode
end

function UISearchFov:ClearTempMultiSelections()
  self.multiSelections = {}
end

function UISearchFov:GetMultiCount()
  if not self.multiSelections then
    return 0
  end
  return table.count(self.multiSelections)
end

function UISearchFov:SetMultiSelection(server, pos, selected)
  local id = SceneUtils.EncodeWorldPos(server, pos)
  if selected then
    self.multiSelections[id] = selected
  else
    self.multiSelections[id] = nil
  end
  self:RefreshMultiSelect()
end

function UISearchFov:GetMultiSelected(server, pos)
  local id = SceneUtils.EncodeWorldPos(server, pos)
  return self.multiSelections[id]
end

function UISearchFov:OnBtnDeleteClick()
  if self.inMultiSelectMode then
    local ct = self.multiSelections and table.count(self.multiSelections) or 0
    if ct <= 0 then
      return
    end
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("world_tips_1003", ct), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local list = {}
      local mgr = DataCenter.WorldFavoDataManager
      for k, v in pairs(self.multiSelections) do
        local serverId, pointId = SceneUtils.DecodeWorldPos(k)
        if serverId and pointId then
          local _ = mgr:GetBookmark(pointId, serverId, true)
          if _ then
            table.insert(list, _)
          end
        end
      end
      if 0 < #list then
        self.view.ctrl:DelBookMarkBatch(list)
      end
      self:SetBatchMode(false)
    end, function()
    end)
  end
end

function UISearchFov:RefreshSearchFilter()
  self:RefreshMarkList()
  self.btnCancelSearch:SetActive(not string.IsNullOrEmpty(self.keyword))
end

function UISearchFov:OnBtnCancelSearchClick()
  self.keyword = nil
  self.inputFieldInputSearch:SetText(nil)
  self:RefreshSearchFilter()
end

function UISearchFov:OnBtnSelectAllClick()
  if not self.currentFovList then
    return
  end
  if not self.inMultiSelectMode then
    self:SetBatchMode(true)
  end
  self:ClearTempMultiSelections()
  for k, v in ipairs(self.currentFovList) do
    local server = v.server
    local pos = v.pos
    local id = SceneUtils.EncodeWorldPos(server, pos)
    self.multiSelections[id] = true
  end
  self:RefreshMultiSelect()
  if self.validFovItems then
    for k, v in pairs(self.validFovItems) do
      if v then
        v:RefreshSelectState()
      end
    end
  end
end

function UISearchFov:RefreshServerTogglePos()
  if not self.currentSelectServer then
    return
  end
  local idx = 0
  for k, v in ipairs(self.serverIdList) do
    if self.currentSelectServer == v then
      idx = k
    end
  end
  if 0 < idx and self.horizontalInfinityScrollViewServersContent then
    TimerManager:GetInstance():DelayFrameInvoke(function()
      self.horizontalInfinityScrollViewServersContent:FocusItemByIndex(idx - 1)
    end, 2)
  end
end

return UISearchFov
