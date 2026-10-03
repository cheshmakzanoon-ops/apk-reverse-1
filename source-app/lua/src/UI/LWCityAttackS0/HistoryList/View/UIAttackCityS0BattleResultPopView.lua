local UIAttackCityS0BattleResultPopView = BaseClass("UIAttackCityS0BattleResultPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local recordItem = require("UI.LWCityAttackS0.HistoryList.Component.UIAttackCityS0BattleResultCell")

function UIAttackCityS0BattleResultPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.AttackCityS0DataManager:GetAllianceRankMsg()
end

function UIAttackCityS0BattleResultPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattleResultPopView:ComponentDefine()
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
  self.scrollView = self:AddComponent(UILoopListView2, "UICommonPopUpTitle/safearea/ResultObj/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "UICommonPopUpTitle/safearea/ResultObj/ScrollView/Viewport/Content")
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIAttackCityS0BattleResultPopView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.scrollView = nil
  self.content = nil
  self.textEmpty = nil
end

function UIAttackCityS0BattleResultPopView:DataDefine()
  self.itemIndex = 1
end

function UIAttackCityS0BattleResultPopView:DataDestroy()
  self:ClearScroll()
  self.recordList = nil
  self.itemIndex = nil
end

function UIAttackCityS0BattleResultPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityS0ThreeRankInfo, self.UpdateList)
  self:AddUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.UpdateList)
end

function UIAttackCityS0BattleResultPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityS0ThreeRankInfo, self.UpdateList)
  self:RemoveUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.UpdateList)
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattleResultPopView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIAttackCityS0BattleResultPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIAttackCityS0BattleResultPopView:UpdateList()
  self.recordList = DataCenter.AttackCityS0DataManager:GetAllianceNormalRankInfo()
  self:ShowScroll()
end

function UIAttackCityS0BattleResultPopView:ShowScroll()
  if table.IsNullOrEmpty(self.recordList) then
    self.scrollView:SetActive(false)
    self.textEmpty.gameObject:SetActive(true)
  else
    self.scrollView:SetActive(true)
    self.textEmpty.gameObject:SetActive(false)
    self.scrollView:SetListItemCount(#self.recordList, false, false)
    self.scrollView:RefreshAllShownItem()
  end
end

function UIAttackCityS0BattleResultPopView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.recordList then
    return nil
  end
  local packData = self.recordList[index]
  local item = loopScroll:NewListViewItem("UIAttackCityS0BattleResultCell")
  local script = self.content:GetComponent(item.gameObject.name, recordItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.content:AddComponent(recordItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(packData)
  return item
end

function UIAttackCityS0BattleResultPopView:ClearScroll()
  self.content:RemoveComponents(recordItem)
  self.scrollView:ClearAllItems()
end

return UIAttackCityS0BattleResultPopView
