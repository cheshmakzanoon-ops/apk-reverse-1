local UISandWormRankView = BaseClass("UISandWormRankView", UIBaseView)
local base = UIBaseView
local SandWormRankItem = require("UI.UISandWormHunt.UISandWormRank.Component.SandWormRankItem")

function UISandWormRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UISandWormRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISandWormRankView:ComponentDefine()
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
  self.selfRank = self:AddComponent(SandWormRankItem, "safeArea/AllyRankPage/SelfObj")
  self.emptyTxt = self:AddComponent(UITextMeshProUGUIEx, "safeArea/AllyRankPage/EmptyTxt")
  self.emptyTxt:SetLocalText("2010371")
  self.emptyTxt2 = self:AddComponent(UITextMeshProUGUIEx, "safeArea/AllyRankPage/EmptyTxt2")
  self.emptyTxt2:SetLocalText("371004")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleText")
  self.titleText:SetLocalText("season_activity_1000069_desc28")
end

function UISandWormRankView:ComponentDestroy()
  self:RemoveRanks()
end

function UISandWormRankView:DataDefine()
end

function UISandWormRankView:DataDestroy()
  self.ranks = nil
  self.selfRank = nil
end

function UISandWormRankView:OnEnable()
  base.OnEnable(self)
end

function UISandWormRankView:OnDisable()
  base.OnDisable(self)
end

function UISandWormRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SandWormRankRefresh, self.Refresh)
end

function UISandWormRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SandWormRankRefresh, self.Refresh)
end

function UISandWormRankView:Init()
  DataCenter.SandWormHuntDataManager:FetchRankData()
  self:Refresh()
end

function UISandWormRankView:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function UISandWormRankView:RefreshData()
  self.ranksData, self.myRankData = DataCenter.SandWormHuntDataManager:GetRankData()
end

function UISandWormRankView:RefreshView()
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

function UISandWormRankView:GetScrollItem(listview, index)
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
    self.items[csItem] = self.content:AddComponent(SandWormRankItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function UISandWormRankView:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(SandWormRankItem)
  self.loopListView:ClearAllItems()
end

return UISandWormRankView
