local UILWAllianceListView = BaseClass("UILWAllianceListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAllianceListItem = require("UI.UILWAlliance.UILWAllianceList.Component.UILWAllianceListItem")
local close_btn_path = "Root/BottomBar/BtnBack"
local title_text_path = "Root/TopBar/TextTitle"
local search_input_path = "Root/Content/ContentHolder/ContentJoinHolder/FindArea/FindInputField"
local search_btn_path = "Root/Content/ContentHolder/ContentJoinHolder/FindArea/FindClickBtn"
local al_content = "Root/Content/ContentHolder/ContentJoinHolder/Scroll/Viewport/Content"
local al_item = "Root/Content/ContentHolder/ContentJoinHolder/Scroll/Viewport/UILWAllianceListItem"
local input_title_path = "Root/Content/ContentHolder/ContentJoinHolder/FindArea/FindRemindTxt"
local ranking_btn_path = "Root/Content/ContentHolder/ContentJoinHolder/RankingBtn"
local scroll_path = "Root/Content/ContentHolder/ContentJoinHolder/Scroll"

function UILWAllianceListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.AlSearch, 1, 1, "", 0, true)
end

function UILWAllianceListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceListView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText(455058)
  self.searchInput = self:AddComponent(UIInput, search_input_path)
  self.searchInput:SetOnValueChange(function(value)
    self:SearchIptOnValueChange(value)
  end)
  self.searchBtn = self:AddComponent(UIButton, search_btn_path)
  self.searchBtn:SetOnClick(function()
    self:OnSearchClick()
  end)
  self.alContent = self:AddComponent(UIBaseContainer, al_content)
  self.inputTitleTxt = self:AddComponent(UIText, input_title_path)
  self.inputTitleTxt:SetLocalText(454133)
  self.ranking_btn = self:AddComponent(UIButton, ranking_btn_path)
  self.ranking_btn:SetOnClick(function()
    self:OnRankingClick()
  end)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UILWAllianceListView:ComponentDestroy()
  self.returnBtn = nil
  self.closeBtn = nil
  self.titleText = nil
  self.searchInput = nil
  self.searchBtn = nil
  self.alContent = nil
  self.alItemPrefab = nil
  self.scroll = nil
end

function UILWAllianceListView:DataDefine()
  self.searchInputValue = ""
  self.allSearchAlUidList = {}
end

function UILWAllianceListView:DataDestroy()
  self:ClearScroll()
  self.searchInputValue = nil
  self.allSearchAlUidList = nil
end

function UILWAllianceListView:OnEnable()
  base.OnEnable(self)
end

function UILWAllianceListView:OnDisable()
  base.OnDisable(self)
end

function UILWAllianceListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.RefreshSearchAlList)
end

function UILWAllianceListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.RefreshSearchAlList)
end

function UILWAllianceListView:SearchIptOnValueChange(value)
  self.searchInputValue = value
  self:OnSearchClick()
end

function UILWAllianceListView:OnSearchClick()
  if self.searchInputValue == nil or self.searchInputValue == "" then
    self.ctrl:SendAlSearchMessageToServer(1, 1, "", 0, true)
  else
    self.ctrl:SendAlSearchMessageToServer(1, 1, self.searchInputValue, 0)
  end
end

function UILWAllianceListView:RefreshSearchAlList()
  self.allSearchAlUidList = self.ctrl:GetAllSearchAlIdList()
  if table.count(self.allSearchAlUidList) <= 0 then
    self.scroll:SetActive(false)
    return
  end
  self.scroll:SetActive(true)
  self.scroll:SetTotalCount(#self.allSearchAlUidList)
  self.scroll:RefillCells()
end

function UILWAllianceListView:OnRankingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankDetailList, {anim = true, hideTop = false}, 0, RankType.AlliancePower)
end

local function OnItemMoveIn(self, itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll:AddComponent(UILWAllianceListItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.ctrl:GetOneAlByUid(self.allSearchAlUidList[index]))
end

local function OnItemMoveOut(self, itemObj, index)
end

local function ClearScroll(self)
  self.scroll:ClearCells()
  self.scroll:RemoveComponents(UILWAllianceListItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.allSearchAlUidList = {}
end

UILWAllianceListView.OnItemMoveIn = OnItemMoveIn
UILWAllianceListView.OnItemMoveOut = OnItemMoveOut
UILWAllianceListView.ClearScroll = ClearScroll
return UILWAllianceListView
