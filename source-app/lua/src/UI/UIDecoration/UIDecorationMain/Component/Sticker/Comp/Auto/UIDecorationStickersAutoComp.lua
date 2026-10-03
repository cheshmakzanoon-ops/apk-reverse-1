local p_list_sticker_path = "p_list_sticker"
local content_path = "p_list_sticker/Viewport/Content"
local p_sticker_show_path = "p_sticker_show"
local UIDecorationStickersAutoStickerShowComp = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoStickerShowComp")
local UIDecorationStickersAutoStickerCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoStickerCell")
local UIDecorationStickersAutoRowCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoRowCell")
local UIDecorationStickersAutoTitleCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoTitleCell")
local base = UIBaseContainer
local UIDecorationStickersAutoComp = BaseClass("UIDecorationStickersAutoComp", UIBaseContainer)

function UIDecorationStickersAutoComp:ComponentDefine()
  self.p_list_sticker = self:AddComponent(UILoopListView2, p_list_sticker_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_sticker_show = self:AddComponent(UIDecorationStickersAutoStickerShowComp, p_sticker_show_path)
  self.p_list_sticker:InitListView(0, function(listView, index)
    return self:TryGetCell(listView, index)
  end)
end

function UIDecorationStickersAutoComp:ComponentDestroy()
  self.items = {}
  self:ClearList()
  self.p_list_sticker = nil
  self.content = nil
  self.p_sticker_show = nil
end

function UIDecorationStickersAutoComp:DataDefine()
  self.items = {}
  self.IsDetail = false
  self.DetailData = nil
end

function UIDecorationStickersAutoComp:DataDestroy()
  self.items = {}
  self.IsDetail = false
  self.DetailData = nil
end

function UIDecorationStickersAutoComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersAutoComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersAutoComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationStickerAutoStickerClick, self.OnStickerClicked)
  self:AddUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
end

function UIDecorationStickersAutoComp:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationStickerAutoStickerClick, self.OnStickerClicked)
  self:RemoveUIListener(EventId.DecorationStickerIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

function UIDecorationStickersAutoComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UIDecorationStickersAutoComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.IsDetail = false
    return true
  end
  return false
end

function UIDecorationStickersAutoComp:InitUi()
  self:InitList()
  self:ShowList()
end

function UIDecorationStickersAutoComp:ShowDetail(data)
  if data == nil or data.Cell == nil then
    return
  end
  self.IsDetail = true
  self.DetailData = data
  self:RefreshIcons(false)
  self.p_list_sticker:SetActive(false)
  self.p_sticker_show:SetActive(true)
  local detailData = {}
  detailData.Cell = data.Cell
  detailData.Index = data.Index
  detailData.Total = table.count(self.ConfigCells)
  detailData.IsDetail = true
  self.p_sticker_show:ReInit(detailData)
end

function UIDecorationStickersAutoComp:ShowList()
  self.IsDetail = false
  self:RefreshIcons(true)
  self.p_list_sticker:SetActive(true)
  self.p_sticker_show:SetActive(false)
end

function UIDecorationStickersAutoComp:InitList()
  self.ConfigCells = self:GetConfigCells()
  self.DataList = self:GetDataList()
  if self.DataList == nil or #self.DataList <= 0 then
    self:ClearList()
  else
    self.p_list_sticker:SetListItemCount(#self.DataList, false, false)
    self.p_list_sticker:RefreshAllShownItem()
  end
end

function UIDecorationStickersAutoComp:ClearList()
  self.content:RemoveComponents(UIDecorationStickersAutoTitleCell)
  self.content:RemoveComponents(UIDecorationStickersAutoRowCell)
  self.p_list_sticker:ClearAllItems()
end

function UIDecorationStickersAutoComp:TryGetCell(listView, index)
  local dataList = self.DataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem, script
  local data = dataList[index]
  if data.Type == 0 then
    csItem = listView:NewListViewItem("p_template_sticker_group_title")
    script = UIDecorationStickersAutoTitleCell
  else
    csItem = listView:NewListViewItem("p_template_sticker_cell_two")
    script = UIDecorationStickersAutoRowCell
  end
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local name = "Cell_" .. NameCount
    csItem.gameObject.name = name
    self.items[csItem] = self.content:AddComponent(script, name)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(data.Data)
  end
  return csItem
end

function UIDecorationStickersAutoComp:GetConfigCells()
  local autoType = -1
  if self.Data ~= nil then
    if checknumber(self.Data.Tab) == 2 then
      autoType = 1
    elseif checknumber(self.Data.Tab) == 3 then
      autoType = 2
    end
  end
  local cells = {}
  LocalController:instance():visitTable(TableName.AUTO_STICKER, function(id, cell)
    if checknumber(cell.type) == autoType and (autoType == 1 or autoType == 2 and DataCenter.LWSticker3DManager:IsSpecialStickerFuncOpen(cell.special_param)) then
      table.insert(cells, DeepCopy(cell))
    end
  end)
  table.sort(cells, function(a, b)
    return a.order < b.order
  end)
  return cells
end

function UIDecorationStickersAutoComp:GetDataList()
  local list = {}
  local rowData = {}
  local index = 1
  local lastGroup = ""
  for _, cell in pairs(self.ConfigCells) do
    if cell.group_name ~= lastGroup then
      if not table.IsNullOrEmpty(rowData) then
        table.insert(list, {
          Type = 1,
          Data = {
            Cells = rowData,
            Tab = self.Data.Tab
          }
        })
        rowData = {}
      end
      table.insert(list, {
        Type = 0,
        Data = {
          GroupName = CS.GameEntry.Localization:GetString(cell.group_name),
          Info = cell.group_tips
        }
      })
      lastGroup = cell.group_name
    end
    table.insert(rowData, {Cell = cell, Index = index})
    if table.count(rowData) >= 2 then
      table.insert(list, {
        Type = 1,
        Data = {
          Cells = rowData,
          Tab = self.Data.Tab
        }
      })
      rowData = {}
    end
    index = index + 1
  end
  if 0 < table.count(rowData) then
    table.insert(list, {
      Type = 1,
      Data = {
        Cells = rowData,
        Tab = self.Data.Tab
      }
    })
  end
  return list
end

function UIDecorationStickersAutoComp:GetSelectStickerDecorationId(allDecorations)
  if table.count(allDecorations) == 0 then
    return -1
  end
  if not self.IsDetail or self.DetailData == nil or self.DetailData.Cell == nil then
    return -1
  end
  local stickerId = checknumber(DataCenter.LWSticker3DManager:GetAutoStickerId(self.DetailData.Cell.auto_send_param))
  for _, decoration in pairs(allDecorations) do
    if decoration.type == DecorationType.DecorationType_Emoji and checknumber(decoration.customVariable) == stickerId then
      return decoration.id
    end
  end
  return -1
end

function UIDecorationStickersAutoComp:TryBack()
  if self.IsDetail then
    self:ShowList()
    return true
  end
  return false
end

function UIDecorationStickersAutoComp:OnStickerClicked(evt)
  if evt == nil or evt.Cell == nil then
    return
  end
  self:ShowDetail(evt)
end

function UIDecorationStickersAutoComp:TryShowPre()
  if not self.IsDetail or self.DetailData == nil then
    return
  end
  local index = checknumber(self.DetailData.Index) - 1
  if index < 1 then
    return
  end
  local configCell = self.ConfigCells[index]
  local data = {}
  data.Cell = configCell
  data.Index = index
  self:ShowDetail(data)
end

function UIDecorationStickersAutoComp:TryShowNext()
  if not self.IsDetail or self.DetailData == nil then
    return
  end
  local index = checknumber(self.DetailData.Index) + 1
  if index > table.count(self.ConfigCells) then
    return
  end
  local configCell = self.ConfigCells[index]
  local data = {}
  data.Cell = configCell
  data.Index = index
  self:ShowDetail(data)
end

function UIDecorationStickersAutoComp:OnSelectEvent(decorationId)
  if self.DetailData == nil then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
  if template ~= nil then
    local stickerTemplate = DataCenter.ChatEmojiTemplateManager:GetStickerTempData(tonumber(template.customVariable))
    if stickerTemplate ~= nil then
      local stickerId = checknumber(stickerTemplate.id)
      local autoType = checknumber(self.DetailData.Cell.auto_send_param)
      DataCenter.LWSticker3DManager:SetAutoStickerId(autoType, stickerId, true)
    end
  end
end

function UIDecorationStickersAutoComp:RefreshIcons(hide)
  if self.holder ~= nil then
    self.holder:RefreshIcons(hide)
  end
end

return UIDecorationStickersAutoComp
