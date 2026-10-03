local UIGhostParkourAllianceRewardRankView = BaseClass("UIGhostParkourAllianceRewardRankView", UIBaseView)
local PlayerRankItem = require("UI.UIGhostParkour.Outside.BattlePassRewardRank.Component.UIRewardRankItem")
local base = UIBaseView

function UIGhostParkourAllianceRewardRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SendMsg()
end

function UIGhostParkourAllianceRewardRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourAllianceRewardRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textRankDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textNameDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textValueDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.rankItem = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.showListScroll = self.viewSkin:AddComponent(self, UILoopListView2, 8)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compSelfData = self.viewSkin:AddComponent(self, PlayerRankItem, 10)
  self.showListScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.rankItem.gameObject:SetActive(false)
  self.rankItemPool = self.rankItem.gameObject
  self.rankItemPool:GameObjectCreatePool()
  self.rankItems = {}
end

function UIGhostParkourAllianceRewardRankView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textRankDes = nil
  self.textNameDes = nil
  self.textValueDes = nil
  self.rankItem = nil
  self.showListScroll = nil
  self.content = nil
  self.compSelfData = nil
end

function UIGhostParkourAllianceRewardRankView:DataDefine()
  self.itemIndex = 1
end

function UIGhostParkourAllianceRewardRankView:DataDestroy()
  self.rankInfo = nil
  self.rankList = nil
  self.itemIndex = nil
end

function UIGhostParkourAllianceRewardRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GhostParkourAllianceBPRankRefresh, self.RefreshRankData)
  self:AddUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
end

function UIGhostParkourAllianceRewardRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.GhostParkourAllianceBPRankRefresh, self.RefreshRankData)
  self:RemoveUIListener(EventId.GhostParkourRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UIGhostParkourAllianceRewardRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourAllianceRewardRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourAllianceRewardRankView:RefreshRankData()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  self.rankInfo = DataCenter.LWGhostParkourDataManager:GetAllianceBpRankInfo(round)
  if self.rankInfo then
    self:UpdateScrollView()
  end
end

function UIGhostParkourAllianceRewardRankView:UpdateScrollView()
  self.rankList = self.rankInfo.ranks
  if self.rankList then
    if #self.rankList == 0 then
      self.showListScroll:SetActive(false)
    else
      self.showListScroll:SetActive(true)
      self.showListScroll:SetListItemCount(#self.rankList, false, false)
      self.showListScroll:RefreshAllShownItem()
    end
  end
  if self.rankInfo and self.rankInfo.self then
    self.compSelfData:ReInit(self.rankInfo.self, true)
  end
end

function UIGhostParkourAllianceRewardRankView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankList then
    return nil
  end
  local ShowInfo = self.rankList[index]
  local item = loopScroll:NewListViewItem("UILWAlRankItem")
  local script = self.content:GetComponent(item.gameObject.name, PlayerRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(PlayerRankItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(ShowInfo)
  return item
end

function UIGhostParkourAllianceRewardRankView:ClearContent()
  self.content:RemoveComponents(PlayerRankItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.showListScroll:ClearAllItems()
end

function UIGhostParkourAllianceRewardRankView:SendMsg()
  local round = DataCenter.LWGhostParkourDataManager:GetGhostParkourRound()
  DataCenter.LWGhostParkourDataManager:SendGhostParkourBPRankInfoMessage(round)
end

return UIGhostParkourAllianceRewardRankView
