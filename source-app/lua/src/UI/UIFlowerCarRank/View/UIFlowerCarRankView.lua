local UIFlowerCarRankView = BaseClass("UIFlowerCarRankView", UIBaseView)
local base = UIBaseView
local FlowerCarRankItem = require("UI.UIFlowerCarRank.Component.FlowerCarRankItem")
local head1_path = "safeArea/bg/headBg/head1"
local head2_path = "safeArea/bg/headBg/head2"
local head3_path = "safeArea/bg/headBg/head3"
local bot_text_path = "safeArea/bg/BotText"

function UIFlowerCarRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIFlowerCarRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIFlowerCarRankView:ComponentDefine()
  self.closeBtn = self:AddComponent(UIButton, "closeBg")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "safeArea/bg/AllyRankPage/AllyScroll/ViewPort/AllyContent")
  self.loopListView = self:AddComponent(UILoopListView2, "safeArea/bg/AllyRankPage/AllyScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.selfRank = self:AddComponent(FlowerCarRankItem, "safeArea/bg/myRankItem")
  self.emptyTxt = self:AddComponent(UITextMeshProUGUIEx, "safeArea/bg/AllyRankPage/EmptyTxt")
  self.emptyTxt:SetLocalText("371004")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safeArea/bg/titleText")
  self.titleText:SetLocalText("456006")
  self.head1 = self:AddComponent(UITextMeshProUGUIEx, head1_path)
  self.head1:SetLocalText("361013")
  self.head2 = self:AddComponent(UITextMeshProUGUIEx, head2_path)
  self.head2:SetLocalText("100184")
  self.head3 = self:AddComponent(UITextMeshProUGUIEx, head3_path)
  self.head3:SetLocalText("110186")
  self.bot_text = self:AddComponent(UITextMeshProUGUIEx, bot_text_path)
  self.bot_text:SetLocalText("season_s4_monster_tips35")
end

function UIFlowerCarRankView:ComponentDestroy()
  self:RemoveRanks()
end

function UIFlowerCarRankView:DataDefine()
  self.uuid = self:GetUserData()
end

function UIFlowerCarRankView:DataDestroy()
  self.ranks = nil
  self.selfRank = nil
end

function UIFlowerCarRankView:OnEnable()
  base.OnEnable(self)
end

function UIFlowerCarRankView:OnDisable()
  base.OnDisable(self)
end

function UIFlowerCarRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FlowerCarRankRefresh, self.Refresh)
end

function UIFlowerCarRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.FlowerCarRankRefresh, self.Refresh)
end

function UIFlowerCarRankView:Init()
  self:Refresh()
end

function UIFlowerCarRankView:Refresh()
  self:RefreshData()
  self:RefreshView()
end

function UIFlowerCarRankView:RefreshData()
  self.ranksData, self.myRankData = DataCenter.FlowerCarDataManager:GetRankData(self.uuid)
end

function UIFlowerCarRankView:RefreshView()
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

function UIFlowerCarRankView:GetScrollItem(listview, index)
  local dataList = self.ranksData
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("FlowerCarRankItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "FlowerCarRankItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(FlowerCarRankItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function UIFlowerCarRankView:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(FlowerCarRankItem)
  self.loopListView:ClearAllItems()
end

return UIFlowerCarRankView
