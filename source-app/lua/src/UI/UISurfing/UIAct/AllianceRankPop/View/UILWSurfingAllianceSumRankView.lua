local UILWSurfingAllianceSumRankView = BaseClass("UILWSurfingAllianceSumRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PlayerRankItem = require("UI.UISurfing.UIAct.AllianceRankPop.Component.UILWAlRankItem")

function UILWSurfingAllianceSumRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:SendMsg()
end

function UILWSurfingAllianceSumRankView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSurfingAllianceSumRankView:ComponentDefine()
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
  self.showListScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compSelfData = self:AddComponent(PlayerRankItem, "rankContent/SelfData")
  self.rankItem.gameObject:SetActive(false)
  self.rankItemPool = self.rankItem.gameObject
  self.rankItemPool:GameObjectCreatePool()
  self.rankItems = {}
end

function UILWSurfingAllianceSumRankView:ComponentDestroy()
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

function UILWSurfingAllianceSumRankView:DataDefine()
  self.type = SurfingBattleRankType.AllianceBpRank
  self.rankInfo = nil
  self.rankList = {}
  self.itemIndex = 0
end

function UILWSurfingAllianceSumRankView:DataDestroy()
  self:ClearContent()
  self.rankInfo = nil
  self.type = nil
  self.rankList = nil
end

function UILWSurfingAllianceSumRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SurfingRefreshRankInfo, self.RefreshRankData)
  self:AddUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
end

function UILWSurfingAllianceSumRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SurfingRefreshRankInfo, self.RefreshRankData)
  self:RemoveUIListener(EventId.SurfingRefreshActInfoByRound, self.SendMsg)
  base.OnRemoveListener(self)
end

function UILWSurfingAllianceSumRankView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingAllianceSumRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWSurfingAllianceSumRankView:RefreshRankData(type)
  if self.type == type then
    self.rankInfo = DataCenter.LWSurfingDataManager:GetSurfingRankInfo(self.type)
    if self.rankInfo then
      self:UpdateScrollView()
    end
  end
end

function UILWSurfingAllianceSumRankView:UpdateScrollView()
  self.rankList = self.rankInfo.rankList
  if self.rankList then
    if #self.rankList == 0 then
      self.showListScroll:SetActive(false)
    else
      self.showListScroll:SetActive(true)
      self.showListScroll:SetListItemCount(#self.rankList, false, false)
      self.showListScroll:RefreshAllShownItem()
    end
  end
  if self.rankInfo and self.rankInfo.selfRank then
    self.compSelfData:ReInit(self.rankInfo.selfRank, true)
  end
end

function UILWSurfingAllianceSumRankView:OnGetItemByIndex(loopScroll, index)
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

function UILWSurfingAllianceSumRankView:ClearContent()
  self.content:RemoveComponents(PlayerRankItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.showListScroll:ClearAllItems()
end

function UILWSurfingAllianceSumRankView:SendMsg()
  local round = DataCenter.LWSurfingDataManager:GetRound()
  DataCenter.LWSurfingDataManager:GetParkourRankInfo(round, self.type, 1, 100)
end

return UILWSurfingAllianceSumRankView
