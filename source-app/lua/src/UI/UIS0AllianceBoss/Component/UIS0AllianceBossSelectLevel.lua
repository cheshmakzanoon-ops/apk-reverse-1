local base = UIBaseContainer
local UIS0AllianceBossSelectLevel = BaseClass("UIS0AllianceBossSelectLevel", UIBaseContainer)
local UIS0AllianceBossSelectLeveItem = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossSelectLeveItem")

function UIS0AllianceBossSelectLevel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossSelectLevel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossSelectLevel:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.item = self.viewSkin:AddComponent(self, UIS0AllianceBossSelectLeveItem, 2)
  self.scrollView = self.viewSkin:AddComponent(self, UILoopListView2, 3)
  self.animArrow = self.viewSkin:AddComponent(self, UIAnimator, 4)
  self.animKuang = self.viewSkin:AddComponent(self, UIAnimator, 5)
  self.items = {}
  self.scrollView:InitListView(0, function(listView, index)
    return self:OnGetItemByIndex(listView, index)
  end)
  self.scrollView:SetOnSnapItemFinished(function(listView, item)
    self:OnItemSnapFinish(listView, item)
  end)
  self.scrollView:SetOnSnapNearestChanged(function(listView, item)
    self:OnItemSnapNearestChanged(listView, item)
  end)
  self.scrollView:SetOnEndDragAction(function(listView, item)
    self:OnEndDrag(listView, item)
  end)
end

function UIS0AllianceBossSelectLevel:ComponentDestroy()
  self.items = nil
  self.compContent:RemoveComponents(UIS0AllianceBossSelectLeveItem)
  self.scrollView:ClearAllItems()
  self.viewSkin = nil
  self.compContent = nil
  self.item = nil
  self.scrollView = nil
  self.animArrow = nil
  self.animKuang = nil
end

function UIS0AllianceBossSelectLevel:OnEnable()
  base.OnEnable(self)
  self.animArrow:Play("V_ui_S0_AllianceBossSelectLevel_arrow_idle")
  self.animKuang:Play("V_ui_S0_AllianceBossSelectLevel_kuang_idle")
end

function UIS0AllianceBossSelectLevel:DataDefine()
  self.dataList = nil
  self.maxDifficulty = nil
  self.curSelectIndex = nil
  self.uiName = nil
  self.showRedPoint = nil
  self.difficultyIds = nil
end

function UIS0AllianceBossSelectLevel:DataDestroy()
  if self.arrowTimer then
    self.arrowTimer:Stop()
    self.arrowTimer = nil
  end
  if self.kuangTimer then
    self.kuangTimer:Stop()
    self.kuangTimer = nil
  end
  self.dataList = nil
  self.maxDifficulty = nil
  self.curSelectIndex = nil
  self.uiName = nil
  self.showRedPoint = nil
  self.difficultyIds = nil
end

function UIS0AllianceBossSelectLevel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossOnLevelItemClick, self.OnItemSelectChanged)
end

function UIS0AllianceBossSelectLevel:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossOnLevelItemClick, self.OnItemSelectChanged)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossSelectLevel:InitView(maxDifficulty, curSelectIndex, uiName)
  self.curSelectIndex = curSelectIndex or 1
  self.maxDifficulty = maxDifficulty
  local difficultyDic = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  local ids = {}
  for i, v in pairs(difficultyDic) do
    ids[#ids + 1] = i
  end
  table.sort(ids)
  self.difficultyIds = ids
  self.uiName = uiName
  self.showRedPoint = uiName == "Main"
  if 0 < maxDifficulty then
    self.scrollView:SetListItemCount(maxDifficulty, false, false)
    self.scrollView:MovePanelToItemIndex(self.curSelectIndex - 1, 0)
  end
end

function UIS0AllianceBossSelectLevel:OnGetItemByIndex(loopScroll, index)
  if self.difficultyIds == nil or #self.difficultyIds <= 0 then
    return nil
  end
  local count = self.maxDifficulty
  index = index + 1
  if index < 1 or count < index then
    return nil
  end
  local item = loopScroll:NewListViewItem("S0AllianceBossSelectLeveNum")
  local data = self.difficultyIds[index]
  if self.items[item] == nil then
    local nameStr = "Cell" .. UIUtil.GetLoopListItemIndex()
    item.gameObject.name = nameStr
    self.items[item] = self.compContent:AddComponent(UIS0AllianceBossSelectLeveItem, item.gameObject.name)
  end
  if self.items[item] ~= nil then
    local isSelect = data == self.curSelectIndex
    self.items[item]:SetData(data, isSelect, self.uiName, self.showRedPoint)
  end
  return item
end

function UIS0AllianceBossSelectLevel:OnItemSnapFinish(loopScroll, item)
  if self.animIndex == 2 then
    self.animIndex = 3
    local _, duration1 = self.animArrow:PlayAnimationReturnTime("V_ui_S0_AllianceBossSelectLevel_arrow_change")
    if 0 < duration1 then
      self.arrowTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.animArrow:Play("V_ui_S0_AllianceBossSelectLevel_arrow_idle")
        if self.arrowTimer then
          self.arrowTimer:Stop()
          self.arrowTimer = nil
        end
      end, duration1)
    else
      self.animArrow:Play("V_ui_S0_AllianceBossSelectLevel_arrow_idle")
    end
    local _, duration2 = self.animKuang:PlayAnimationReturnTime("V_ui_S0_AllianceBossSelectLevel_kuang_stop")
    if 0 < duration2 then
      self.kuangTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.animIndex = 1
        self.animKuang:Play("V_ui_S0_AllianceBossSelectLevel_kuang_idle")
        if self.kuangTimer then
          self.kuangTimer:Stop()
          self.kuangTimer = nil
        end
      end, duration2)
    else
      self.animIndex = 1
      self.animKuang:Play("V_ui_S0_AllianceBossSelectLevel_kuang_idle")
    end
  end
end

function UIS0AllianceBossSelectLevel:OnItemSnapNearestChanged(loopScroll, item)
  if self.animIndex ~= 2 then
    self.animIndex = 2
    self.animArrow:Play("V_ui_S0_AllianceBossSelectLevel_arrow_slide")
    self.animKuang:Play("V_ui_S0_AllianceBossSelectLevel_kuang_slide")
  end
  self.curSelectIndex = item.ItemIndex + 1
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossOnLevelSelectChanged, {
    value = self.curSelectIndex,
    uiName = self.uiName
  })
end

function UIS0AllianceBossSelectLevel:OnEndDrag(loopScroll, item)
  self.scrollView:MovePanelToItemIndex(self.curSelectIndex - 1, 0.1)
end

function UIS0AllianceBossSelectLevel:OnItemSelectChanged(param)
  if param and param.uiName == self.uiName then
    self.curSelectIndex = param.value
    self.scrollView:MovePanelToItemIndex(self.curSelectIndex - 1, 0.1)
  end
end

function UIS0AllianceBossSelectLevel:RefreshSelectedItem(index)
  self.curSelectIndex = index
  self.scrollView:MovePanelToItemIndex(self.curSelectIndex - 1, 0)
end

function UIS0AllianceBossSelectLevel:OnPageLeft()
  local index = self.curSelectIndex - 1
  if 1 <= index then
    self.curSelectIndex = index
    self.scrollView:SetSnapTargetItemIndex(index - 1)
  end
end

function UIS0AllianceBossSelectLevel:OnPageRight()
  local index = self.curSelectIndex + 1
  if index <= self.maxDifficulty then
    self.curSelectIndex = index
    self.scrollView:SetSnapTargetItemIndex(index - 1)
  end
end

return UIS0AllianceBossSelectLevel
