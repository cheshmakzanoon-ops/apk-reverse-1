local base = UIBaseContainer
local RecordScrollViewComponent = BaseClass("RecordScrollViewComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RecordItem = require("UI.UIGhostParkour.Outside.RecordPop.Component.RecordCellComponent")

function RecordScrollViewComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function RecordScrollViewComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RecordScrollViewComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ScrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function RecordScrollViewComponent:ComponentDestroy()
  self.viewSkin = nil
  self.ScrollView = nil
  self.content = nil
end

function RecordScrollViewComponent:DataDefine()
  self.showDatalist = {}
  self.attackList = nil
  self.defenseList = nil
end

function RecordScrollViewComponent:DataDestroy()
  self:ClearScroll()
  self.showDatalist = nil
  self.records = nil
  self.attackList = nil
  self.defenseList = nil
end

function RecordScrollViewComponent:OnAddListener()
  base.OnAddListener(self)
end

function RecordScrollViewComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function RecordScrollViewComponent:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(RecordItem)
  self.showDatalist = {}
end

function RecordScrollViewComponent:RefreshList(recordType)
  self.records = DataCenter.LWGhostParkourDataManager:GetGhostParkourRecord()
  self:ClearScroll()
  if self.records and type(self.records) == "table" then
    if recordType == GhostParkourRecordType.All then
      self.showDatalist = self.records.array
    else
      self.showDatalist = self:GetOtherList(recordType)
    end
    if self.showDatalist and #self.showDatalist > 0 then
      self.ScrollView:SetTotalCount(#self.showDatalist)
      self.ScrollView:RefillCells()
    end
  end
end

function RecordScrollViewComponent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(RecordItem, itemObj)
  cellItem:SetData(self.showDatalist[index], index)
end

function RecordScrollViewComponent:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, RecordItem)
end

function RecordScrollViewComponent:GetOtherList(type)
  self.attackList = {}
  self.defenseList = {}
  if self.records and self.records.array then
    for _, record in ipairs(self.records.array) do
      if record.attackInfo and record.attackInfo.uid == LuaEntry.Player.uid then
        table.insert(self.attackList, record)
      else
        table.insert(self.defenseList, record)
      end
    end
  end
  if type == GhostParkourRecordType.Attack then
    return self.attackList
  elseif type == GhostParkourRecordType.Defense then
    return self.defenseList
  end
end

return RecordScrollViewComponent
