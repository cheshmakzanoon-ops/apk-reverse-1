local LWUIMasterySkillDetailView = BaseClass("LWUIMasterySkillDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIMasterySkillDetailCell = require("UI.LWUIMasterySkillDetail.Component.LWUIMasterySkillDetailCell")
local LWUIMasterySkillDetailToggleCell = require("UI.LWUIMasterySkillDetail.Component.LWUIMasterySkillDetailToggleCell")
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local l_w_u_i_mastery_skill_detail_item_path = "Root/LWUIMasterySkillDetailItem"
local scroll_view_path = "Root/ScrollView"
local toggle_item_path = "Root/toggleItem"
local toggle_content_path = "Root/toggleContent"
local scroll_content_path = "Root/ScrollView/Viewport/ScrollContent"

local function OnCreate(self)
  base.OnCreate(self)
  self.masteryId = self:GetUserData()
  self.itemIndex = 0
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function GetScrollItem(self, listview, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local item = listview:NewListViewItem("LWUIMasterySkillDetailItem")
  local script = self.scroll_content:GetComponent(item.gameObject.name, LWUIMasterySkillDetailCell)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.scroll_content:AddComponent(LWUIMasterySkillDetailCell, objectName)
  end
  script:SetData(self.showData[index])
  return item
end

local function OnItemSnapFinish(self, listView, item)
  self.selectIndex = item.ItemIndex + 1
  self:Refresh()
end

local function OnItemSnapNearestChanged(self, listView, item)
  self.selectIndex = item.ItemIndex + 1
  self:Refresh()
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn = self:AddComponent(UIButton, "UICommonMiniPopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.LWUI_mastery_skill_detail_item = self:AddComponent(UIBaseContainer, l_w_u_i_mastery_skill_detail_item_path)
  self.LWUI_mastery_skill_detail_item:SetActive(false)
  self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListViewParam(0, function(listview, index)
    return GetScrollItem(self, listview, index)
  end)
  self.scroll_view:SetOnSnapItemFinished(function(listView, item)
    OnItemSnapFinish(self, listView, item)
  end)
  self.scroll_view:SetOnSnapNearestChanged(function(listView, item)
    OnItemSnapNearestChanged(self, listView, item)
  end)
  self.toggle_content = self:AddComponent(UIBaseContainer, toggle_content_path)
  self.toggle_item = self:AddComponent(UIButton, toggle_item_path)
  self.toggle_item:SetActive(false)
  self.toggle_item.gameObject:GameObjectCreatePool()
  self.toggle_item_list = {}
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.return_btn = nil
  self.close_btn = nil
  self.LWUI_mastery_skill_detail_item = nil
  self.scroll_view = nil
  self.scroll_content = nil
  self.toggle_item = nil
  self.toggle_content = nil
end

local function DataDefine(self)
  self.showData = {}
  self.selectIndex = 1
end

local function DataDestroy(self)
  self.masteryId = nil
  self.showData = nil
  self.selectIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ClearAllItem(self)
  self.toggle_content:RemoveComponents(LWUIMasterySkillDetailToggleCell)
  for _, v in ipairs(self.toggle_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.toggle_item.gameObject:GameObjectRecycleAll()
  self.toggle_item_list = {}
  self.scroll_content:RemoveComponents(LWUIMasterySkillDetailCell)
  self.scroll_view:ClearAllItems()
end

local function ReInit(self)
  self:ClearAllItem()
  self:InitShowData()
  self:InitView()
  self:Refresh()
end

local function InitShowData(self)
  self.showData = {}
  local temp = DataCenter.MasteryManager:GetTempLevelOneByMasteryGroupId(self.masteryId)
  if temp == nil then
    return
  end
  if temp.skill <= 0 then
    return
  end
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(temp.skill)
  if skillTemp == nil then
    return
  end
  for k, v in ipairs(skillTemp.guide_img_list) do
    local descTxt = ""
    if k <= #skillTemp.guide_description_list then
      descTxt = skillTemp.guide_description_list[k]
    end
    local data = {img = v, txt = descTxt}
    table.insert(self.showData, data)
  end
end

local function InitView(self)
  local showNum = #self.showData
  if 0 < showNum then
    for i = 1, showNum do
      local item = self.toggle_item.gameObject:GameObjectSpawn(self.toggle_content.transform)
      item.name = i
      local obj = self.toggle_content:AddComponent(LWUIMasterySkillDetailToggleCell, item.name)
      obj:SetActive(true)
      self.toggle_item_list[i] = obj
      obj:SetData(i, self.selectIndex, function(index)
        self:OnToggleBtnClick(index)
      end)
    end
  end
  if 0 < showNum then
    self.scroll_view:SetListItemCount(showNum, false, false)
    self.scroll_view:RefreshAllShownItem()
  end
end

local function Refresh(self)
  for i = 1, #self.toggle_item_list do
    local obj = self.toggle_item_list[i]
    obj:SetBeSelectData(self.selectIndex)
  end
end

local function OnToggleBtnClick(self, index)
end

LWUIMasterySkillDetailView.OnCreate = OnCreate
LWUIMasterySkillDetailView.OnDestroy = OnDestroy
LWUIMasterySkillDetailView.ComponentDefine = ComponentDefine
LWUIMasterySkillDetailView.ComponentDestroy = ComponentDestroy
LWUIMasterySkillDetailView.DataDefine = DataDefine
LWUIMasterySkillDetailView.DataDestroy = DataDestroy
LWUIMasterySkillDetailView.OnAddListener = OnAddListener
LWUIMasterySkillDetailView.OnRemoveListener = OnRemoveListener
LWUIMasterySkillDetailView.ClearAllItem = ClearAllItem
LWUIMasterySkillDetailView.ReInit = ReInit
LWUIMasterySkillDetailView.InitShowData = InitShowData
LWUIMasterySkillDetailView.InitView = InitView
LWUIMasterySkillDetailView.Refresh = Refresh
LWUIMasterySkillDetailView.OnToggleBtnClick = OnToggleBtnClick
return LWUIMasterySkillDetailView
