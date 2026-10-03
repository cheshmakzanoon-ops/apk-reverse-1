local UICounterAttackRankView = BaseClass("UICounterAttackRankView", UIBaseView)
local base = UIBaseView
local CounterAttackRankItem = require("UI.UICounterAttack.UICounterAttackRank.Component.CounterAttackRankItem")

function UICounterAttackRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UICounterAttackRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICounterAttackRankView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "safeArea/AllyRankPage/AllyScroll/ViewPort/AllyContent")
  self.loopListView = self:AddComponent(UILoopListView2, "safeArea/AllyRankPage/AllyScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.selfRank = self:AddComponent(CounterAttackRankItem, "safeArea/AllyRankPage/SelfObj")
  self.emptyTxt = self:AddComponent(UITextMeshProUGUIEx, "safeArea/AllyRankPage/EmptyTxt")
  self.emptyTxt:SetLocalText("2010371")
  self.emptyTxt2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/AllyRankPage/EmptyTxt2")
  self.emptyTxt2:SetLocalText("2010369")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleText")
  self.titleText:SetLocalText("390040")
end

function UICounterAttackRankView:ComponentDestroy()
  self:RemoveRanks()
end

function UICounterAttackRankView:DataDefine()
end

function UICounterAttackRankView:DataDestroy()
  self.ranks = nil
  self.selfRank = nil
end

function UICounterAttackRankView:OnEnable()
  base.OnEnable(self)
end

function UICounterAttackRankView:OnDisable()
  base.OnDisable(self)
end

function UICounterAttackRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnCounterAttackPersonRank, self.Refresh)
end

function UICounterAttackRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnCounterAttackPersonRank, self.Refresh)
end

function UICounterAttackRankView:Init()
  DataCenter.CounterAttackDataManager:SendMsgPersonRank()
  self:Refresh()
end

function UICounterAttackRankView:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function UICounterAttackRankView:RefreshData()
  self.ranksData, self.myRankData = DataCenter.CounterAttackDataManager:GetRankData()
end

function UICounterAttackRankView:RefreshView()
  self:RemoveRanks()
  local rankList = self.ranksData
  self.emptyTxt:SetActive(not rankList or #rankList == 0)
  if rankList and 0 < #rankList then
    self.loopListView:SetListItemCount(#rankList, false, false)
    self.loopListView:RefreshAllShownItem()
  end
  if self.myRankData then
    self.selfRank:SetActive(true)
    self.selfRank:Refresh(self.myRankData)
  else
    self.selfRank:SetActive(false)
  end
end

function UICounterAttackRankView:GetScrollItem(listview, index)
  local dataList = self.ranksData
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("NormalRankItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "NormalRankItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(CounterAttackRankItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function UICounterAttackRankView:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(CounterAttackRankItem)
  self.loopListView:ClearAllItems()
end

return UICounterAttackRankView
