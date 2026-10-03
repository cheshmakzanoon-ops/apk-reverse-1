local base = UIBaseView
local UIArenaHistoryView = BaseClass("UIArenaHistoryView", base)
local Localization = CS.GameEntry.Localization
local ArenaHistoryItem = require("UI.UIArenaHistory.Component.ArenaHistoryItem")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local challengeTimes_path = "offset/top/challengeTimes"
local ticketCount_path = "offset/top/tickets/ticketNum"
local buyTicketBtn_path = "offset/top/tickets/Common_btn_add"
local svHistory_path = "offset/ScrollView"
local historyContent_path = "offset/ScrollView/Viewport/Content"
local empty_paty = "offset/emptyTip"
local refreshBtn_path = "offset/refreshBtn"
local refreshBtnTxt_path = "offset/refreshBtn/refreshBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
  DataCenter.ArenaManager:SetOpenHistoryTime()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(390264)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.challengeTimesN = self:AddComponent(UIText, challengeTimes_path)
  self.ticketCountN = self:AddComponent(UIText, ticketCount_path)
  self.buyTicketBtnN = self:AddComponent(UIButton, buyTicketBtn_path)
  self.buyTicketBtnN:SetOnClick(function()
    self:OnClickBuyTicketBtn()
  end)
  self.svHistoryN = self:AddComponent(UIScrollView, svHistory_path)
  self.svHistoryN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.svHistoryN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.targetContentN = self:AddComponent(UIBaseContainer, historyContent_path)
  self.emptyN = self:AddComponent(UIText, empty_paty)
  self.emptyN:SetLocalText(372266)
  self.refreshBtnN = self:AddComponent(UIButton, refreshBtn_path)
  self.refreshBtnN:SetActive(false)
  self.refreshBtnN:SetOnClick(function()
    self:OnClickRefreshBtn()
  end)
  self.refreshBtnTxtN = self:AddComponent(UIText, refreshBtnTxt_path)
  self.refreshBtnTxtN:SetLocalText(110028)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.challengeTimesN = nil
  self.ticketCountN = nil
  self.buyTicketBtnN = nil
  self.svHistoryN = nil
  self.targetContentN = nil
end

local function DataDefine(self)
  self.historyList = {}
  self.curDetailIndex = nil
  self.historyItemsDic = {}
end

local function DataDestroy(self)
  self.historyList = nil
  self.curDetailIndex = nil
  self.historyItemsDic = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnUpdateArenaHistoryInfo, self.RefreshAll)
  self:AddUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnUpdateArenaHistoryInfo, self.RefreshAll)
  self:RemoveUIListener(EventId.OnUpdateArenaBaseInfo, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function InitData(self)
  self:RefreshAll()
  SFSNetwork.SendMessage(MsgDefines.GetArenaBattleHistory)
end

local function RefreshAll(self)
  self:RefreshTicket()
  self.historyList = DataCenter.ArenaManager:GetHistoryList()
  if #self.historyList > 0 then
    self.svHistoryN:SetActive(true)
    self.svHistoryN:SetTotalCount(#self.historyList)
    self.svHistoryN:RefillCells()
    self.emptyN:SetActive(false)
  else
    self.svHistoryN:SetActive(false)
    self.emptyN:SetActive(true)
  end
end

local function RefreshTicket(self)
  local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena", "k2")
  self.challengeTimesN:SetText(Localization:GetString("372262", maxChallengeTimes - selfInfo.fightTimes .. "/" .. maxChallengeTimes))
  local good = DataCenter.ItemData:GetItemById(ArenaTicketId)
  local num = good and good.count or 0
  self.ticketCountN:SetText(num)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svHistoryN:AddComponent(ArenaHistoryItem, itemObj)
  local param = {}
  param.index = index
  param.isShowHeroes = index == self.curDetailIndex
  
  function param.callback(targetIndex)
    self:JumpToIndex(targetIndex)
  end
  
  cellItem:SetItem(self.historyList[index], param)
  self.historyItemsDic[index] = cellItem
end

local function JumpToIndex(self, targetIndex)
  if self.curDetailIndex and self.historyItemsDic[self.curDetailIndex] then
    self.historyItemsDic[self.curDetailIndex]:ShowHeroesByExternal(false)
  end
  if not self.curDetailIndex or targetIndex ~= self.curDetailIndex then
    self.historyItemsDic[targetIndex]:ShowHeroesByExternal(true)
    self.svHistoryN:ScrollToCell(targetIndex, 1000)
    self.curDetailIndex = targetIndex
  else
    self.curDetailIndex = nil
    TimerManager:GetInstance():DelayInvoke(function()
      self.svHistoryN:StopMovement()
    end, 0.1)
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.historyItemsDic[index] = nil
  self.svHistoryN:RemoveComponent(itemObj.name, ArenaHistoryItem)
end

local function ClearScroll(self)
  self.svHistoryN:ClearCells()
  self.svHistoryN:RemoveComponents(ArenaHistoryItem)
end

local function OnClickBuyTicketBtn(self)
  local price = DataCenter.ArenaManager:GetTicketPrice()
  local str = Localization:GetString("372261", price)
  UIUtil.ShowBuyMessage(str, 2, nil, nil, function()
    SFSNetwork.SendMessage(MsgDefines.BuyArenaTicket)
  end, nil, nil, nil, price, nil)
end

local function OnClickRefreshBtn(self)
  SFSNetwork.SendMessage(MsgDefines.GetArenaBattleHistory)
end

UIArenaHistoryView.OnCreate = OnCreate
UIArenaHistoryView.OnDestroy = OnDestroy
UIArenaHistoryView.OnAddListener = OnAddListener
UIArenaHistoryView.OnRemoveListener = OnRemoveListener
UIArenaHistoryView.ComponentDefine = ComponentDefine
UIArenaHistoryView.ComponentDestroy = ComponentDestroy
UIArenaHistoryView.DataDefine = DataDefine
UIArenaHistoryView.DataDestroy = DataDestroy
UIArenaHistoryView.InitData = InitData
UIArenaHistoryView.RefreshAll = RefreshAll
UIArenaHistoryView.RefreshTicket = RefreshTicket
UIArenaHistoryView.OnItemMoveIn = OnItemMoveIn
UIArenaHistoryView.JumpToIndex = JumpToIndex
UIArenaHistoryView.OnItemMoveOut = OnItemMoveOut
UIArenaHistoryView.ClearScroll = ClearScroll
UIArenaHistoryView.OnClickRefreshBtn = OnClickRefreshBtn
UIArenaHistoryView.OnClickBuyTicketBtn = OnClickBuyTicketBtn
return UIArenaHistoryView
