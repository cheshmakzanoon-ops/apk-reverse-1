local UIWorldTrendItem = require("UI.UIWorldTrend.Component.UIWorldTrendItem")
local UIWorldTrendView = BaseClass("UIWorldTrendView", UIBaseView)
local base = UIBaseView
local closeBtn = "safeArea/topLeftLayer/closeBg/closeBtn"
local Txt_Title = "safeArea/topLeftLayer/closeBg/Txt_Title"
local Content = "safeArea/ScrollView/Viewport/Content"
local ScrollView = "safeArea/ScrollView"

function UIWorldTrendView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnRefresh()
end

function UIWorldTrendView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, closeBtn)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
  self._title_txt = self:AddComponent(UIText, Txt_Title)
  self._title_txt:SetLocalText(302088)
  self.content = self:AddComponent(UIBaseContainer, Content)
  self.scroll_view = self:AddComponent(UIScrollView, ScrollView)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function UIWorldTrendView:DataDefine()
  self.data = {}
  self.modelTask = {}
  self.cellList = {}
end

function UIWorldTrendView:OnDestroy()
  self:ClearScroll()
  self.content = nil
  self.close_btn = nil
  base.OnDestroy(self)
end

function UIWorldTrendView:OnEnable()
  base.OnEnable(self)
end

function UIWorldTrendView:OnDisable()
  base.OnDisable(self)
end

function UIWorldTrendView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldTrendUpdate, self.UpdateEvent)
end

function UIWorldTrendView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldTrendUpdate, self.UpdateEvent)
end

function UIWorldTrendView:OnRefresh()
  self.data = DataCenter.WorldTrendManager:GetDataInfo()
  local targetIndex = DataCenter.WorldTrendManager:CheckJumpCell()
  if next(self.data) then
    self.scroll_view:SetTotalCount(#self.data)
    self.scroll_view:RefillCells(targetIndex)
  end
end

function UIWorldTrendView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIWorldTrendItem, itemObj)
  local taskConf = self.data[index]
  cellItem:RefreshData(taskConf)
  self.cellList[self.data[index].id] = cellItem
end

function UIWorldTrendView:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIWorldTrendItem)
end

function UIWorldTrendView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIWorldTrendItem)
end

function UIWorldTrendView:UpdateEvent(id)
  self.data = DataCenter.WorldTrendManager:GetDataInfo()
  if next(self.cellList) then
    for i = 1, #self.data do
      if self.data[i].id == tostring(id) then
        self.cellList[tostring(id)]:RefreshData(self.data[i])
        break
      end
    end
  end
end

return UIWorldTrendView
