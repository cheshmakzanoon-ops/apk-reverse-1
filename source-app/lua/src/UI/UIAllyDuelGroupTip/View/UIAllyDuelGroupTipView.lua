local UIAllyDuelGroupTipView = BaseClass("UIAllyDuelGroupTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllyDuelGroupTipItem = require("UI.UIAllyDuelGroupTip.Component.UIAllyDuelGroupTipItem")
local black_path = "black"
local closeBtn_path = "bg/CloseBtn"
local txt_title_path = "bg/bg_top/txtTitle"
local scroll_view_path = "bg/bg_2/desc/ScrollView"
local content_path = "bg/bg_2/desc/ScrollView/content"

function UIAllyDuelGroupTipView:OnCreate()
  base.OnCreate(self)
  self.conditionList = {}
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIAllyDuelGroupTipView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelGroupTipView:OnAddListener()
  base.OnAddListener(self)
end

function UIAllyDuelGroupTipView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAllyDuelGroupTipView:ComponentDefine()
  self.black = self:AddComponent(UIButton, black_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
end

function UIAllyDuelGroupTipView:DataDefine()
end

function UIAllyDuelGroupTipView:ComponentDestroy()
  self.black = nil
  self.closeBtn = nil
  self.txt_title = nil
  self.scroll_view = nil
  self.content = nil
end

function UIAllyDuelGroupTipView:DataDestroy()
  self:ClearScroll()
end

function UIAllyDuelGroupTipView:OnInitScroll(go, index)
  local item = self.scroll_view:AddComponent(UIAllyDuelGroupTipItem, go)
  self.conditionList[go] = item
end

function UIAllyDuelGroupTipView:OnUpdateScroll(go, index)
  if self.list == nil or self.list[index + 1] == nil then
    go:SetActive(false)
    return
  end
  local data = self.list[index + 1]
  local item = self.conditionList[go]
  go:SetActive(true)
  item:RefreshData(data, index + 1)
end

function UIAllyDuelGroupTipView:OnDestroyScrollItem(go, index)
end

function UIAllyDuelGroupTipView:ReInit()
  local param = self:GetUserData()
  self.groupId = param.groupId
  self.list = param.listInGroup
  if self.list then
    self.content:SetItemCount(#self.list)
    self.content:MoveItemByIndex(0)
  else
    self.content:SetItemCount(0)
  end
end

function UIAllyDuelGroupTipView:ClearScroll()
  self.scroll_view:RemoveComponents(UIAllyDuelGroupTipItem)
  self.content:DestroyChildNode()
end

return UIAllyDuelGroupTipView
