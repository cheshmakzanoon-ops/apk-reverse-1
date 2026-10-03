local LWActMeteoriteGuideView = BaseClass("LWActMeteoriteGuideView", UIBaseView)
local base = UIBaseView
local LWActMeteoriteGuideItemBig = require("UI.LWActMeteorite.Component.Guide.LWActMeteoriteGuideItemBig")
local LWActMeteoriteGuideItemSmall = require("UI.LWActMeteorite.Component.Guide.LWActMeteoriteGuideItemSmall")
local closeBtn_path = "Common_bg_orange/CloseBtn"
local closeBg_path = "panel"
local toggle_base_path = "Common_bg_orange/Common_bg_orange2/TogView/Toggle"
local scroll_view_path = "Common_bg_orange/Common_bg_orange2/ScrollView"
local content_path = "Common_bg_orange/Common_bg_orange2/ScrollView/Viewport/Content"

function LWActMeteoriteGuideView:OnCreate()
  base.OnCreate(self)
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  for i = 1, 3 do
    local toggle = self:AddComponent(UIToggle, toggle_base_path .. i)
    if i == 1 then
      toggle:SetIsOn(true)
    end
    toggle:SetOnValueChanged(function(action)
      if action then
        if self.curPage == i then
          return
        end
        self.curPage = i
        self:RefreshView()
      end
    end)
  end
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.curPage = 1
  self.guideList = {}
  self.items = {}
  self:RefreshView()
end

function LWActMeteoriteGuideView:OnDestroy()
  self:ClearAllItem()
  self.title = nil
  self.close_btn = nil
  self.closeBg = nil
  self.scroll_view = nil
  self.content = nil
  self.curPage = 1
  self.maxCnt = 0
  base.OnDestroy(self)
end

function LWActMeteoriteGuideView:ClearAllItem()
  self.content:RemoveComponents(LWActMeteoriteGuideItemBig)
  self.content:RemoveComponents(LWActMeteoriteGuideItemSmall)
  self.scroll_view:ClearAllItems()
  self.guideList = {}
  self.items = {}
end

function LWActMeteoriteGuideView:RefreshView()
  self.guideList = DataCenter.ActMeteoriteBattleManager:GetTemplateGuideByPage(self.curPage)
  self.maxCnt = #self.guideList
  self.scroll_view:SetListItemCount(self.maxCnt, false, false)
  self.scroll_view:RefreshAllShownItem()
end

function LWActMeteoriteGuideView:TryGetScrollItem(listview, index)
  index = index + 1
  if index < 1 or index > self.maxCnt then
    return nil
  end
  local csItem, theScript
  local data = self.guideList[index]
  if data.type == 2 then
    csItem = listview:NewListViewItem("ItemBig")
    theScript = LWActMeteoriteGuideItemBig
  else
    csItem = listview:NewListViewItem("ItemSmall")
    theScript = LWActMeteoriteGuideItemSmall
  end
  if csItem then
    csItem.gameObject:SetActive(true)
    local item = self.items[csItem]
    if item == nil then
      local nameStr = "Item" .. UIUtil.GetLoopListItemIndex()
      csItem.gameObject.name = nameStr
      item = self.content:AddComponent(theScript, nameStr)
      self.items[csItem] = item
    end
    if item ~= nil then
      item:SetData(data)
    end
  end
  return csItem
end

return LWActMeteoriteGuideView
