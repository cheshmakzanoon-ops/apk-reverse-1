local WorldBookmarkItemCell = require("UI.UIMainMapPointToSelect.Component.WorldBookmarkItemCell")
local WorldBookmarkServerListItemCell = require("UI.UISearch.Component.WorldBookmarkServerListItemCell")
local WorldBookmarkItem = BaseClass("WorldBookmarkItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local scroll_path = "Bookmark_Bg/ScrollView"
local content_path = "Bookmark_Bg/ScrollView/Viewport/Content"
local empty_txt_path = "Bookmark_Bg/TxtEmpty"
local panel_bg_path = "Bookmark_Bg"
local panel_arrow_path = "Bookmark_Arrow"
local this_path = ""
local btn_returnTop_path = "Bookmark_Bg/Btn_ReturnTop"
local close_Btn = "CloseBtn"
local close_bg = "CloseBg"
local server_scroll_view_path = "Bookmark_Bg/ServerScrollView"
local server_content_path = "Bookmark_Bg/ServerScrollView/Viewport/ServerContent"
local itemCellH = 89

local function OnCreate(self)
  base.OnCreate(self)
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.panel_bg = self:AddComponent(UIImage, panel_bg_path)
  self.panel_arrow = self:AddComponent(UIImage, panel_arrow_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.goServerList = self.transform:Find(server_scroll_view_path).gameObject
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.list = {}
  self.listAll = {}
  self.serverList = {}
  self.currentSelectServer = -1
  self.serverListItems = {}
  self.animator = self:AddComponent(UIAnimator, this_path)
  self._returnTop_btn = self:AddComponent(UIButton, btn_returnTop_path)
  self._returnTop_btn:SetOnClick(function()
    self:OnClickReturnTop()
  end)
  self.close_btn = self:AddComponent(UIButton, close_Btn)
  self.close_btn:SetOnClick(function()
    self.view:CloseBookMark()
  end)
  self.close_bg = self:AddComponent(UIButton, close_bg)
  self.close_bg:SetOnClick(function()
    self.view:CloseBookMark()
  end)
  self.serverListInited = false
  self:RefreshServerList()
end

local function OnDestroy(self)
  self.empty_txt = nil
  self.ScrollView = nil
  self.content = nil
  self.list = nil
  self.listAll = nil
  self.serverList = nil
  self.panel_bg = nil
  self.panel_arrow = nil
  self.animator = nil
  self.sign = nil
  self.currentSelectServer = -1
  base.OnDestroy(self)
end

local function RefreshMarkList(self)
  self.sign = 0
  self._returnTop_btn:SetActive(false)
  self:ClearScroll()
  self.serverList, self.listAll = self.view.ctrl:GetMarkListByTab(self.curTab)
  self:RefreshSelectServer()
  self:RefreshServerList()
end

function WorldBookmarkItem:RefreshSelectServer()
  if not self.listAll[self.currentSelectServer] then
    self.currentSelectServer = -1
  end
  self.list = self.listAll[self.currentSelectServer] or {}
  local deltaY = 0
  local itemNum = 2
  if #self.list > 0 then
    self.empty_txt:SetText("")
    if #self.list > 4 then
      deltaY = 475
    else
      if #self.list > 2 then
        itemNum = #self.list
      end
      deltaY = itemNum * itemCellH + 60 + #self.list * 8
    end
    self.sign = 5 / #self.list
  else
    self.empty_txt:SetLocalText(128007)
    deltaY = itemNum * itemCellH + 76
  end
  self.ScrollView:SetTotalCount(#self.list)
  if #self.list > 0 then
    self.ScrollView:RefillCells()
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.animator:Play("CommonPopup_movein", 0, 0)
end

local function OnDisable(self)
  self:SaveServerRecord()
  self:ClearScroll()
  self:ClearServerList()
  self.animator:Play("CommonPopup_moveout", 0, 0)
  base.OnDisable(self)
end

local function ReInit(self, tab, posX)
  self.curTab = tab
  self.currentSelectServer = self:GetRecordServer() or -1
  self:RefreshMarkList()
  self:ResetPosition(posX)
  self:TryAutoScrollToLast()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  self.parentSizeX = Screen.width / scaleFactor
  self.parentSizeY = Screen.height / scaleFactor
  self.close_bg:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
  self.close_bg:SetPosition(self.view:GetPosition())
end

function WorldBookmarkItem:TryAutoScrollToLast()
  if self.currentSelectServer > 0 and self.ServerScrollView and self.serverList then
    local idx = 0
    for k, v in ipairs(self.serverList) do
      if v == self.currentSelectServer then
        idx = k
        break
      end
    end
    if 0 < idx then
      self.ServerScrollView:ScrollToCell(idx, 10000)
    else
      self:RecordServer(-1)
    end
  end
end

local function ResetPosition(self, posX)
  local arrowPosX = posX
  local arrowPosY = self.panel_arrow.transform.position.y
  local panelPosX = posX
  local panelPosY = self.panel_bg.transform.position.y
  local rect = self.panel_bg.rectTransform.rect
  local scale = Screen.height / 750
  local screenWidth = Screen.width
  local halfRectWidth = rect.width / 2 * scale
  local maxX = screenWidth - halfRectWidth - 30
  panelPosX = math.min(panelPosX, maxX)
  self.panel_arrow.transform.position = Vector3.New(arrowPosX, arrowPosY, 0)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(WorldBookmarkItemCell, itemObj)
  cellItem:SetItemShow(self.list[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, WorldBookmarkItemCell)
end

local function OnDrag(self, eventData)
  if self.sign and self.sign ~= 0 and #self.list > 10 then
    if self.ScrollView:GetVerticalNormalizedPosition() > self.sign then
      self._returnTop_btn:SetActive(true)
    else
      self._returnTop_btn:SetActive(false)
    end
  end
end

local function OnClickReturnTop(self)
  self._returnTop_btn:SetActive(false)
  self.ScrollView:ScrollToCell(1, 10000)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(WorldBookmarkItemCell)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function WorldBookmarkItem:ClearServerList()
  if self.ServerScrollView then
    self.ServerScrollView:ClearCells()
    self.ServerScrollView:RemoveComponents(WorldBookmarkServerListItemCell)
  end
  self.serverListItems = {}
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

function WorldBookmarkItem:InitServerList()
  if self.serverListInited then
    return
  end
  self.serverListInited = true
  self.ServerScrollView = self:AddComponent(UIScrollView, server_scroll_view_path)
  self.ServerScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnServerListItemMoveIn(itemObj, index)
  end)
  self.ServerScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnServerListItemMoveOut(itemObj, index)
  end)
  self.serverContent = self:AddComponent(UIBaseContainer, server_content_path)
end

function WorldBookmarkItem:OnServerListItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ServerScrollView:AddComponent(WorldBookmarkServerListItemCell, itemObj)
  local serverId = self.serverList[index]
  cellItem:Refresh(self, index, self.serverList[index], serverId == self.currentSelectServer)
  self.serverListItems[index] = cellItem
end

function WorldBookmarkItem:OnServerListItemMoveOut(itemObj, index)
  self.ServerScrollView:RemoveComponent(itemObj.name, WorldBookmarkServerListItemCell)
  self.serverListItems[index] = nil
end

function WorldBookmarkItem:RefreshServerList()
  local showServerList = #self.serverList > 2
  if showServerList then
    self.goServerList:SetActive(true)
    self.ScrollView.rectTransform:Set_offsetMax(0, -82)
    self:InitServerList()
    self.ServerScrollView:SetTotalCount(#self.serverList)
    self.ServerScrollView:RefillCells()
  else
    self.goServerList:SetActive(false)
    self.ScrollView.rectTransform:Set_offsetMax(0, -22)
  end
end

function WorldBookmarkItem:OnClickedServer(serverId)
  if serverId == self.currentSelectServer then
    return
  end
  self.currentSelectServer = serverId
  for k, v in pairs(self.serverListItems) do
    if v then
      local serverId = self.serverList[k]
      v:Refresh(self, k, serverId, serverId == self.currentSelectServer)
    end
  end
  self:RefreshSelectServer()
  self:RecordServer(self.currentSelectServer)
end

function WorldBookmarkItem:SaveServerRecord()
  if self.lastServerRecord then
    for k, v in pairs(self.lastServerRecord) do
      local key = string.format("Bookmark_record_%s", k)
      local server = tonumber(v) or -1
      CommonUtil.PlayerPrefsSetInt(key, server)
    end
  end
end

function WorldBookmarkItem:GetRecordServer()
  if not self.lastServerRecord then
    self.lastServerRecord = {}
  end
  local lastServer = self.lastServerRecord[self.curTab]
  if not lastServer then
    local key = string.format("Bookmark_record_%s", self.curTab)
    lastServer = CommonUtil.PlayerPrefsGetInt(key, -1)
  end
  self.lastServerRecord[self.curTab] = lastServer
  return lastServer
end

function WorldBookmarkItem:RecordServer(serverId)
  if not self.lastServerRecord then
    self.lastServerRecord = {}
  end
  self.lastServerRecord[self.curTab] = serverId
end

WorldBookmarkItem.OnCreate = OnCreate
WorldBookmarkItem.OnDestroy = OnDestroy
WorldBookmarkItem.RefreshMarkList = RefreshMarkList
WorldBookmarkItem.OnEnable = OnEnable
WorldBookmarkItem.OnDisable = OnDisable
WorldBookmarkItem.OnItemMoveIn = OnItemMoveIn
WorldBookmarkItem.OnItemMoveOut = OnItemMoveOut
WorldBookmarkItem.ClearScroll = ClearScroll
WorldBookmarkItem.OnAddListener = OnAddListener
WorldBookmarkItem.OnRemoveListener = OnRemoveListener
WorldBookmarkItem.ReInit = ReInit
WorldBookmarkItem.ResetPosition = ResetPosition
WorldBookmarkItem.OnDrag = OnDrag
WorldBookmarkItem.OnClickReturnTop = OnClickReturnTop
return WorldBookmarkItem
