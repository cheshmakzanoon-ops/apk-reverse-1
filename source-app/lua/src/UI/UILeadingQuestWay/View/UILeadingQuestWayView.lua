local UILeadingQuestWayView = BaseClass("UILeadingQuestWayView", UIBaseView)
local UILeadingQuestWayItem = require("UI.UILeadingQuestWay.Component.UILeadingQuestWayItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local black_path = "black"
local txt_title_path = "bg/top/txtTitle"
local btn_close_path = "bg/top/btnClose"
local scroll_view_path = "bg/bg2/ScrollView"

function UILeadingQuestWayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILeadingQuestWayView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UILeadingQuestWayView:OnAddListener()
  base.OnAddListener(self)
end

function UILeadingQuestWayView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILeadingQuestWayView:ComponentDefine()
  self.black = self:AddComponent(UIButton, black_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.txt_title:SetText(Localization:GetString("powerup_event_des011"))
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
end

function UILeadingQuestWayView:DataDefine()
end

function UILeadingQuestWayView:ComponentDestroy()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILeadingQuestWayItem)
  self.scrollCellPool = {}
  self.black = nil
  self.txt_title = nil
  self.btn_close = nil
  self.scroll_view = nil
end

function UILeadingQuestWayView:DataDestroy()
end

function UILeadingQuestWayView:ReInit()
  local config = DataCenter.LWLeadingQuestV2Manager:GetConfig()
  if config == nil then
    return
  end
  if self.typeArray == nil then
    self.typeArray = {}
    self.powerArray = {}
  else
    table.clear(self.typeArray)
    table.clear(self.powerArray)
  end
  table.insertto(self.typeArray, config.powerup_type)
  table.insertto(self.powerArray, config.recommend_power)
  local recommend = config.recommend_type
  local recommendPro = 0
  local minPro = 2
  local minType = 0
  for i, v in ipairs(self.typeArray) do
    local cur = DataCenter.LWLeadingQuestV2Manager:GetCurPower(v)
    local max = self.powerArray[i] or 0
    local pro = 0
    if 0 < max then
      pro = cur / max
    end
    if v == recommend then
      recommendPro = pro
    end
    if minPro > pro then
      minPro = pro
      minType = v
    end
  end
  if recommendPro < 1 then
    self.recommendType = recommend
  elseif minPro < 1 then
    self.recommendType = minType
  else
    self.recommendType = -1
  end
  local count = #self.typeArray
  if 0 < count and 0 < self.recommendType and self.recommendType ~= self.typeArray[1] then
    local index = table.indexof(self.typeArray, self.recommendType)
    if index then
      local firstType = self.typeArray[1]
      self.typeArray[1] = self.recommendType
      self.typeArray[index] = firstType
      local tmp = self.powerArray[index]
      local first = self.powerArray[1]
      self.powerArray[1] = tmp
      self.powerArray[index] = first
    end
  end
  self.scroll_view:SetTotalCount(count)
  if 0 < count then
    self.scroll_view:RefillCells()
  end
end

function UILeadingQuestWayView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scroll_view:AddComponent(UILeadingQuestWayItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local type = self.typeArray[index]
  local power = self.powerArray[index] or 0
  item:SetData(type, power, self.recommendType)
end

function UILeadingQuestWayView:OnItemDeleteCell(itemObj, index)
end

return UILeadingQuestWayView
