local LWUIActEasterEggMessageView = BaseClass("LWUIActEasterEggMessageView", UIBaseView)
local M = LWUIActEasterEggMessageView
local LWUIActEasterEggMessageItem = require("UI.LWUIActEasterEgg.LWUIActEasterEggMessage.Component.LWUIActEasterEggMessageItem")
local CommentRequestDelta = 10
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function M:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.EasterEggChatOnClickZone)
  self:ClearScroll()
  self:ClearMyCommentData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "panel")
  self.btnPanel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnTip = self:AddComponent(UIButton, "Root/TipBtn")
  self.btnTip:SetOnClick(function()
    self:OnBtnTipClick()
  end)
  self.btnLWClose = self:AddComponent(UIButton, "Root/LW_Btn_Close")
  self.btnLWClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.imgTabItemSelectSend = self:AddComponent(UIImage, "Root/TabHolder/TabContent/TabItemSend/TabItemSelectSend")
  self.imgTabItemUnSelectSend = self:AddComponent(UIImage, "Root/TabHolder/TabContent/TabItemSend/TabItemUnSelectSend")
  self.textTabItemSend = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItemSend/TabItemTextSend")
  self.imgTabItemSelectReceive = self:AddComponent(UIImage, "Root/TabHolder/TabContent/TabItemReceive/TabItemSelectReceive")
  self.imgTabItemUnSelectReceive = self:AddComponent(UIImage, "Root/TabHolder/TabContent/TabItemReceive/TabItemUnSelectReceive")
  self.textTabItemReceive = self:AddComponent(UITextMeshProUGUIEx, "Root/TabHolder/TabContent/TabItemReceive/TabItemTextReceive")
  self.scroll = self:AddComponent(UILoopListView2, "Root/ScrollRect")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ScrollRect/Viewport/Content")
  self.textCoinNum = self:AddComponent(UITextMeshProUGUIEx, "Root/CoinNode/LayOut/CoinNum")
  self.textTodayAdd = self:AddComponent(UITextMeshProUGUIEx, "Root/CoinNode/LayOut/TodayAddText")
  self.compLWUIActEasterEggMessageItem = self:AddComponent(LWUIActEasterEggMessageItem, "Root/LWUIActEasterEggMessageItem")
  self.btnManage = self:AddComponent(UIButton, "ManageBtn")
  self.btnManage:SetOnClick(function()
    self:OnBtnManageClick()
  end)
  self.btnReturn = self:AddComponent(UIButton, "ReturnBtn")
  self.btnReturn:SetOnClick(function()
    self:OnBtnReturnClick()
  end)
  self.btnDelete = self:AddComponent(UIButton, "DeleteBtn")
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.compEmptyNode = self:AddComponent(UIBaseContainer, "EmptyNode")
  self.textEmpty = self:AddComponent(UITextMeshProUGUIEx, "EmptyNode/EmptyText")
  self.textManageBtn = self:AddComponent(UITextMeshProUGUIEx, "ManageBtn/ManageBtnText")
  self.textReturnBtn = self:AddComponent(UITextMeshProUGUIEx, "ReturnBtn/ReturnBtnText")
  self.textDeleteBtn = self:AddComponent(UITextMeshProUGUIEx, "DeleteBtn/DeleteBtnText")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Title")
  self.toggleTabItemSend = self:AddComponent(UIToggle, "Root/TabHolder/TabContent/TabItemSend")
  self.toggleTabItemReceive = self:AddComponent(UIToggle, "Root/TabHolder/TabContent/TabItemReceive")
  self.compSelectAllNode = self:AddComponent(UIBaseContainer, "SelectAllNode")
  self.btnSelectAll = self:AddComponent(UIButton, "SelectAllNode/SelectAllBtn")
  self.btnSelectAll:SetOnClick(function()
    self:OnBtnSelectAllClick()
  end)
  self.imgSelect = self:AddComponent(UIImage, "SelectAllNode/SelectImg")
  self.textSelectAll = self:AddComponent(UITextMeshProUGUIEx, "SelectAllNode/SelectAllText")
  self.gotoBtn = self:AddComponent(UIButton, "EmptyNode/GoToBtn")
  self.gotoBtn:SetOnClick(function()
    self:ClickGoToBtn()
  end)
  self.coinNode = self:AddComponent(UITextMeshProUGUIEx, "Root/CoinNode")
  self.compEmptyNode:SetActive(false)
  self.toggleTabItemSend:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(ActEasterMessageTab.Send)
    end
  end)
  self.toggleTabItemReceive:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(ActEasterMessageTab.Comment)
    end
  end)
  self.scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  
  function self.scroll.unity_looplistview2.mOnDragingAction()
    self:OnDragAction()
  end
end

function M:ComponentDestroy()
  self.btnPanel = nil
  self.btnTip = nil
  self.btnLWClose = nil
  self.imgTabItemSelectSend = nil
  self.imgTabItemUnSelectSend = nil
  self.textTabItemSend = nil
  self.imgTabItemSelectReceive = nil
  self.imgTabItemUnSelectReceive = nil
  self.textTabItemReceive = nil
  self.scroll = nil
  self.compContent = nil
  self.textCoinNum = nil
  self.textTodayAdd = nil
  self.compLWUIActEasterEggMessageItem = nil
  self.btnManage = nil
  self.btnReturn = nil
  self.btnDelete = nil
  self.compEmptyNode = nil
  self.textEmpty = nil
  self.textManageBtn = nil
  self.textReturnBtn = nil
  self.textDeleteBtn = nil
  self.textTitle = nil
  self.toggleTabItemSend = nil
  self.toggleTabItemReceive = nil
  self.compSelectAllNode = nil
  self.btnSelectAll = nil
  self.imgSelect = nil
  self.textSelectAll = nil
  self.gotoBtn = nil
  self.coinNode = nil
end

function M:DataDefine()
  self.curChannel = ActEasterMessageTab.Send
  self.mySendEggsArr = {}
  self.myCommentEggsArr = {}
  self.itemIndex = 0
  self.commentRequestBeginIndex = 1
  self.canRequestComment = true
  self.reachLimit = false
end

function M:DataDestroy()
  self.curChannel = nil
  self.mySendEggsArr = nil
  self.myCommentEggsArr = nil
  self.itemIndex = nil
  self.commentRequestBeginIndex = nil
  self.canRequestComment = nil
  self.reachLimit = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EasterEggGetActivityGetMyPostEggsInfo, self.RefreshView)
  self:AddUIListener(EventId.EasterEggGetActivityEggsInfoSelect, self.onRecSelect)
  self:AddUIListener(EventId.EasterEggGetActivityGetMyCommentInfo, self.RefreshView)
  self:AddUIListener(EventId.EasterEggGetActivityDeleteEggs, self.RefreshView)
end

function M:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EasterEggGetActivityGetMyPostEggsInfo, self.RefreshView)
  self:RemoveUIListener(EventId.EasterEggGetActivityEggsInfoSelect, self.onRecSelect)
  self:RemoveUIListener(EventId.EasterEggGetActivityGetMyCommentInfo, self.RefreshView)
  self:RemoveUIListener(EventId.EasterEggGetActivityDeleteEggs, self.RefreshView)
end

function M:OnBtnTipClick()
  local postEggsInfo = DataCenter.ActEasterEggManager:GetMyPostEggsInfo()
  if postEggsInfo then
    self.coinNode:SetActive(true)
    local todayNum = postEggsInfo.todayPraiseNum + postEggsInfo.todayCommentNum
    self.textTodayAdd:SetText(Localization:GetString("activity_99144_ui_22", todayNum))
  end
  local eggConfig = DataCenter.ActEasterEggManager:GetEggConfigData()
  local coinsThumbsLimit = eggConfig.coinsThumbsLimit
  local coinsCommitLimit = eggConfig.coinsCommitLimit
  local coinsThumbs = postEggsInfo.todayPraiseNum
  local coinsCommit = postEggsInfo.todayCommentNum
  local param = {}
  param.type = "desc"
  param.title = ""
  param.desc = Localization:GetString("activity_99144_ui_23", coinsThumbs, coinsThumbsLimit, coinsCommit, coinsCommitLimit)
  param.isLocal = true
  param.alignObject = self.btnTip
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function M:OnBtnManageClick()
  self:EnterEditState()
end

function M:OnBtnReturnClick()
  self:ExitEditState()
end

function M:OnBtnDeleteClick()
  local deleteIdList = {}
  for k, v in pairs(self.curChannelEggArr) do
    if v and v.selected then
      table.insert(deleteIdList, v:GetId())
    end
  end
  self:ExitEditState()
  if table.count(deleteIdList) == 0 then
    return
  end
  local type
  if self.curChannel == ActEasterMessageTab.Send then
    type = ActEasterEggDeleteType.DeleteMyEggs
  elseif self.curChannel == ActEasterMessageTab.Comment then
    type = ActEasterEggDeleteType.DeleteMyComments
  end
  self.ctrl:RequestDeleteEggs(type, deleteIdList)
end

function M:InitView()
  self.textTitle:SetLocalText("activity_99144_ui_19")
  self.textTabItemSend:SetLocalText("activity_99144_ui_20")
  self.textTabItemReceive:SetLocalText("activity_99144_ui_21")
  self.textSelectAll:SetLocalText("activity_99144_ui_28")
  self.textReturnBtn:SetLocalText("activity_99144_ui_29")
  self.textManageBtn:SetLocalText("activity_99144_ui_24")
  self.textDeleteBtn:SetLocalText("activity_99144_ui_30")
  self.curChannel = ActEasterMessageTab.Send
  self:OnTabChanged(ActEasterMessageTab.Send)
  local eggConfigData = DataCenter.ActEasterEggManager:GetEggConfigData()
  local thumbUpGiveItemId = eggConfigData.thumbUpGiveItemId
  local itemNum = DataCenter.ItemData:GetItemCount(thumbUpGiveItemId)
  self.textCoinNum:SetText(itemNum)
  self.compSelectAllNode:SetActive(false)
  self.imgSelect:SetActive(false)
  self.ctrl:SetSelectAll(false)
  self.btnTip:SetActive(true)
  self.btnDelete:SetActive(false)
  self.btnManage:SetActive(true)
  self.btnReturn:SetActive(false)
  self.coinNode:SetActive(false)
end

function M:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.curChannelEggArr then
    return nil
  end
  local eggInfo = self.curChannelEggArr[index]
  local item = loopScroll:NewListViewItem("LWUIActEasterEggMessageItem")
  local script = self.compContent:GetComponent(item.gameObject.name, LWUIActEasterEggMessageItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(LWUIActEasterEggMessageItem, objectName)
  end
  script:SetActive(true)
  script:RefreshByEggInfo(eggInfo, self.curChannel, self.ctrl)
  return item
end

function M:OnTabChanged(tab)
  self.imgTabItemSelectSend:SetActive(tab == ActEasterMessageTab.Send)
  self.imgTabItemUnSelectSend:SetActive(tab ~= ActEasterMessageTab.Send)
  self.imgTabItemSelectReceive:SetActive(tab == ActEasterMessageTab.Comment)
  self.imgTabItemUnSelectReceive:SetActive(tab ~= ActEasterMessageTab.Comment)
  self.curChannel = tab
  if self.curChannel == ActEasterMessageTab.Send then
    if table.count(self.mySendEggsArr) == 0 then
      self.ctrl:RequestMyPostEggsInfo()
    else
      self:RefreshView()
    end
  elseif self.curChannel == ActEasterMessageTab.Comment then
    if table.count(self.myCommentEggsArr) == 0 then
      self:RequestMyCommentEggsInfo()
    else
      self:RefreshView()
    end
  end
  self:ExitEditState()
end

function M:RefreshView()
  if self.curChannel == ActEasterMessageTab.Send then
    local postEggsInfo = DataCenter.ActEasterEggManager:GetMyPostEggsInfo()
    self.curChannelEggArr = self.ctrl:WarpViewData(postEggsInfo.eggArr)
    self.textEmpty:SetLocalText("activity_99144_ui_25")
  elseif self.curChannel == ActEasterMessageTab.Comment then
    local commentEggs = DataCenter.ActEasterEggManager:GetMyCommentEggsInfo()
    if not commentEggs then
      return
    end
    self.curChannelEggArr = self.ctrl:WarpViewData(commentEggs.commentArr)
    self.textEmpty:SetLocalText("activity_99144_ui_26")
    self.canRequestComment = true
    self.commentRequestBeginIndex = self.commentRequestBeginIndex + CommentRequestDelta
    if table.length(self.curChannelEggArr) < self.commentRequestBeginIndex then
      self.reachLimit = true
    end
  end
  local postEggsInfo = DataCenter.ActEasterEggManager:GetMyPostEggsInfo()
  if postEggsInfo then
    self.coinNode:SetActive(true)
    local todayNum = postEggsInfo.todayPraiseNum + postEggsInfo.todayCommentNum
    self.textTodayAdd:SetText(Localization:GetString("activity_99144_ui_22", todayNum))
  end
  if self.scroll == nil or #self.curChannelEggArr == 0 then
    self.scroll:SetActive(false)
    self.compEmptyNode:SetActive(true)
  else
    self.compEmptyNode:SetActive(false)
    self.scroll:SetActive(true)
    self.scroll:SetListItemCount(#self.curChannelEggArr, false, false)
    self.scroll:RefreshAllShownItem()
  end
end

function M:ClearScroll()
  self.compContent:RemoveComponents(LWUIActEasterEggMessageItem)
  self.scroll:ClearAllItems()
  self.scroll.unity_looplistview2.mOnDragingAction = nil
end

function M:EnterEditState()
  self.compSelectAllNode:SetActive(true)
  self.imgSelect:SetActive(false)
  self.ctrl:SetSelectAll(false)
  self.btnTip:SetActive(false)
  self.ctrl:SetInEditMode(true)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityMyEggsInfoEnterEdit)
  self.btnDelete:SetActive(true)
  self.btnManage:SetActive(false)
  self.btnReturn:SetActive(true)
end

function M:ExitEditState()
  self.compSelectAllNode:SetActive(false)
  self.btnTip:SetActive(true)
  self.ctrl:SetInEditMode(false)
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityMyEggsInfoExitEdit)
  self.btnDelete:SetActive(false)
  self.btnManage:SetActive(true)
  self.btnReturn:SetActive(false)
end

function M:ClickGoToBtn()
  if self.curChannel == ActEasterMessageTab.Send then
    EventManager:GetInstance():Broadcast(EventId.EasterEggChatRemindThrow)
  elseif self.curChannel == ActEasterMessageTab.Comment then
    EventManager:GetInstance():Broadcast(EventId.EasterEggChatRemindGet)
  end
  self.ctrl:CloseSelf()
end

function M:OnBtnSelectAllClick()
  local selectAll = self.ctrl:GetSelectAll()
  local curSelect = not selectAll
  self.ctrl:SetSelectAll(curSelect)
  self.imgSelect:SetActive(curSelect)
  for k, v in pairs(self.curChannelEggArr) do
    if v then
      v.selected = curSelect
    end
  end
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityEggsInfoSelectAll)
end

function M:onRecSelect()
  local selectAll = true
  for k, v in pairs(self.curChannelEggArr) do
    if v and not v.selected then
      selectAll = false
      break
    end
  end
  self.ctrl:SetSelectAll(selectAll)
  self.imgSelect:SetActive(selectAll)
end

function M:RequestMyCommentEggsInfo()
  local startIndex = self.commentRequestBeginIndex
  local endIndex = startIndex + CommentRequestDelta
  self.ctrl:RequestMyCommentEggsInfo(startIndex, endIndex)
end

function M:CheckLastChatItemToBottom()
  if not self.curChannelEggArr then
    return false
  end
  local isBottom = false
  local lastMaxCount = table.length(self.curChannelEggArr)
  local lastChatItem = self.scroll:GetShownItemByItemIndex(lastMaxCount - 1)
  if lastChatItem == nil then
    return isBottom
  end
  local pos = self.scroll:GetItemCornerPosInViewPort(lastChatItem)
  isBottom = Mathf.Abs(pos.y) - lastChatItem.ItemSizeWithPadding <= self.scroll.unity_looplistview2.ViewPortSize
  return isBottom
end

function M:OnDragAction()
  if self:CheckLastChatItemToBottom() and self.curChannel == ActEasterMessageTab.Comment and self.canRequestComment and not self.reachLimit then
    self.canRequestComment = false
    self:RequestMyCommentEggsInfo()
  end
end

function M:ClearMyCommentData()
  DataCenter.ActEasterEggManager:ClearMyCommentEggsData()
end

return LWUIActEasterEggMessageView
