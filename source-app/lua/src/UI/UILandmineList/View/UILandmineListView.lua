local base = UIBaseView
local UILandmineListView = BaseClass("UILandmineListView", base)
local LandmineItem = require("UI.UILandmineList.Component.LandmineItem")
local Screen = CS.UnityEngine.Screen
local scroll_path = "Bookmark_Bg/ScrollView"
local content_path = "Bookmark_Bg/ScrollView/Viewport/Content"
local empty_txt_path = "Bookmark_Bg/TxtEmpty"
local panel_bg_path = "Bookmark_Bg"
local panel_arrow_path = "Bookmark_Arrow"
local this_path = ""
local title_path = "Bookmark_Bg/Title"
local itemCellH = 89

function UILandmineListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ResetPosition()
  self:RefreshLandmineList()
end

function UILandmineListView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILandmineListView:ComponentDefine()
  self.empty_txt = self:AddComponent(UIText, empty_txt_path)
  self.panel_bg = self:AddComponent(UIImage, panel_bg_path)
  self.panel_arrow = self:AddComponent(UIImage, panel_arrow_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.close_bg = self:AddComponent(UIButton, "CloseBg")
  self.close_bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("season_mastery_s2_landmine_1")
end

function UILandmineListView:ComponentDestroy()
  self:ClearScroll()
  self.empty_txt = nil
  self.ScrollView = nil
  self.content = nil
  self.panel_bg = nil
  self.panel_arrow = nil
  self.animator = nil
  self.sign = nil
  self.close_bg = nil
  self.title = nil
end

function UILandmineListView:DataDefine()
  self.list = {}
  SFSNetwork.SendMessage(MsgDefines.WorldTriggerGetUserList)
end

function UILandmineListView:DataDestroy()
  self.list = nil
end

function UILandmineListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyTriggerListRefresh, self.RefreshLandmineList)
end

function UILandmineListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MyTriggerListRefresh, self.RefreshLandmineList)
end

function UILandmineListView:RefreshLandmineList()
  self:ClearScroll()
  self.list = DataCenter.MasteryManager:GetLandmineList()
  table.sort(self.list, function(a, b)
    return a.endTime < b.endTime
  end)
  if #self.list > 0 then
    self.empty_txt:SetText("")
  else
    self.empty_txt:SetLocalText("season_mastery_s2_landmine_2")
  end
  self.ScrollView:SetTotalCount(#self.list)
  if #self.list > 0 then
    self.ScrollView:RefillCells()
  end
end

function UILandmineListView:ResetPosition()
  local pos = self:GetUserData()
  local panelPosX = self.panel_bg.transform.position.x
  self.panel_arrow.transform.position = Vector3.New(pos.x, pos.y, 0)
  self.panel_bg.transform.position = Vector3.New(panelPosX, pos.y, 0)
end

function UILandmineListView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(LandmineItem, itemObj)
  cellItem:SetItemShow(self.list[index])
end

function UILandmineListView:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, LandmineItem)
end

function UILandmineListView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(LandmineItem)
end

return UILandmineListView
