local UIGhostParkourRecordListView = BaseClass("UIGhostParkourRecordListView", UIBaseView)
local PlayerItem = require("UI.UIGhostParkour.Outside.RecordInMain.Component.UIGhostParkourRecordListItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIGhostParkourRecordListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
end

function UIGhostParkourRecordListView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRecordListView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.allScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 1)
  self.btnSkipAnim = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSkipAnim:SetOnClick(function()
    self:OnBtnSkipAnimClick()
  end)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.allScrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIGhostParkourRecordListView:ComponentDestroy()
  self.viewSkin = nil
  self.allScrollView = nil
  self.btnSkipAnim = nil
  self.content = nil
end

function UIGhostParkourRecordListView:DataDefine()
end

function UIGhostParkourRecordListView:DataDestroy()
  self:ClearScroll()
  self.allDataList = nil
end

function UIGhostParkourRecordListView:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourRecordListView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourRecordListView:OnBtnSkipAnimClick()
  self.ctrl:CloseSelf()
end

function UIGhostParkourRecordListView:InitData()
  self.allDataList = DataCenter.LWGhostParkourDataManager:GetNewRecordList() or {}
  if self.allDataList and not table.IsNullOrEmpty(self.allDataList) and #self.allDataList > 0 then
    self.allScrollView:SetActive(true)
    self.allScrollView:StopMovement()
    self.allScrollView:SetListItemCount(#self.allDataList, false, false)
    self.allScrollView:RefreshAllShownItem()
    self:ClearAllDataDelay()
    self.allDataDelay = TimerManager:GetInstance():DelayInvoke(function()
      self.allDataDelay = nil
      if self.allScrollView then
        local scrollRect = self.allScrollView.unity_looplistview2.ScrollRect
        if scrollRect and scrollRect.verticalNormalizedPosition > 0.1 then
          self.allDataTween = scrollRect:DOVerticalNormalizedPos(0, 3)
        end
      end
    end, 0.5)
  else
    self.allScrollView:SetActive(false)
  end
  DataCenter.LWGhostParkourDataManager:ClearNewRecordList()
end

function UIGhostParkourRecordListView:ClearAllDataDelay()
  if self.allDataDelay then
    self.allDataDelay:Stop()
    self.allDataDelay = nil
  end
  if self.allDataTween then
    self.allDataTween:Kill()
    self.allDataTween = nil
  end
end

function UIGhostParkourRecordListView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.allDataList then
    return nil
  end
  local data = self.allDataList[index]
  local prefabName = "UIGhostParkourRecordListItem"
  local itemScript = PlayerItem
  local item = loopScroll:NewListViewItem(prefabName)
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex()
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  if script.SetItem then
    script:SetItem(data)
  end
  return item
end

function UIGhostParkourRecordListView:ClearScroll()
  if self.allScrollView then
    self.allScrollView:ClearAllItems()
  end
  self.content:RemoveComponents(PlayerItem)
end

return UIGhostParkourRecordListView
