local UIActSlotMachineTipPicComp = BaseClass("UIActSlotMachineTipPicComp", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIActSlotMachineTipPicCell = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipPicCell")
local UIActSlotMachineTipPicToggleCell = require("UI.UIActSlotMachine.UIActSlotMachineTip.Component.UIActSlotMachineTipPicToggleCell")
local tipDetailItem_path = "tipDetailItem"
local scroll_view_path = "ScrollView"
local toggle_item_path = "toggleItem"
local toggle_content_path = "toggleContent"
local scroll_content_path = "ScrollView/Viewport/ScrollContent"
local desc_path = "textScroll/viewport/content/desc"

function UIActSlotMachineTipPicComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineTipPicComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function GetScrollItem(self, listview, index)
  index = index + 1
  if index < 1 or index > #self.showData then
    return nil
  end
  local item = listview:NewListViewItem("tipDetailItem")
  local script = self.scroll_content:GetComponent(item.gameObject.name, UIActSlotMachineTipPicCell)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.scroll_content:AddComponent(UIActSlotMachineTipPicCell, objectName)
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

function UIActSlotMachineTipPicComp:ComponentDefine()
  self.desc = self:AddComponent(UIText, desc_path)
end

function UIActSlotMachineTipPicComp:ComponentDestroy()
  self.desc = nil
end

function UIActSlotMachineTipPicComp:DataDefine()
  self.showData = {}
  self.selectIndex = 1
  self.itemIndex = 1
end

function UIActSlotMachineTipPicComp:DataDestroy()
  self.showData = nil
  self.selectIndex = nil
  self.itemIndex = nil
end

function UIActSlotMachineTipPicComp:ClearAllItem()
  self.toggle_content:RemoveComponents(UIActSlotMachineTipPicToggleCell)
  for _, v in ipairs(self.toggle_content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.toggle_item.gameObject:GameObjectRecycleAll()
  self.toggle_item_list = {}
  self.scroll_content:RemoveComponents(UIActSlotMachineTipPicCell)
  self.scroll_view:ClearAllItems()
end

function UIActSlotMachineTipPicComp:SetData(param)
  self.param = param
  self:InitView()
end

function UIActSlotMachineTipPicComp:InitShowData()
  self.showData = {}
  local temp = self.param.activityDetailData.infoTemp
  if temp == nil then
    return
  end
  local data = temp.pic_rule
  local dataList = string.string2array_s(data, ";", "|")
  for k, v in ipairs(dataList) do
    local data = {
      img = v[1],
      txt = v[2]
    }
    table.insert(self.showData, data)
  end
end

function UIActSlotMachineTipPicComp:InitView()
  if self.param and self.param.activityInfo then
    self.desc:SetLocalText(self.param.activityInfo.story)
  else
    self.desc:SetText("")
  end
end

function UIActSlotMachineTipPicComp:Refresh()
  for i = 1, #self.toggle_item_list do
    local obj = self.toggle_item_list[i]
    obj:SetBeSelectData(self.selectIndex)
  end
end

return UIActSlotMachineTipPicComp
