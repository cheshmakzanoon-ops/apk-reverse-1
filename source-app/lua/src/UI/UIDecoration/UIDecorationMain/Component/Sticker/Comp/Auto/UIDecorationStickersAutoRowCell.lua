local p_comp_sticker_left_path = "p_comp_sticker_left"
local p_comp_sticker_right_path = "p_comp_sticker_right"
local UIDecorationStickersAutoStickerCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoStickerCell")
local base = UIBaseContainer
local UIDecorationStickersAutoRowCell = BaseClass("UIDecorationStickersAutoRowCell", UIBaseContainer)

function UIDecorationStickersAutoRowCell:ComponentDefine()
  self.p_comp_sticker_left = self:AddComponent(UIDecorationStickersAutoStickerCell, p_comp_sticker_left_path)
  self.p_comp_sticker_right = self:AddComponent(UIDecorationStickersAutoStickerCell, p_comp_sticker_right_path)
end

function UIDecorationStickersAutoRowCell:ComponentDestroy()
  self.p_comp_sticker_left = nil
  self.p_comp_sticker_right = nil
end

function UIDecorationStickersAutoRowCell:DataDefine()
end

function UIDecorationStickersAutoRowCell:DataDestroy()
end

function UIDecorationStickersAutoRowCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersAutoRowCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersAutoRowCell:OnAddListener()
  base.OnAddListener(self)
end

function UIDecorationStickersAutoRowCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDecorationStickersAutoRowCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UIDecorationStickersAutoRowCell:InitData(data)
  if data ~= nil then
    self.Cells = data.Cells or {}
    self.Tab = data.Tab
    return table.count(self.Cells) > 0
  end
  return false
end

function UIDecorationStickersAutoRowCell:InitUi()
  self:InitSticker(self.p_comp_sticker_left, self.Cells[1])
  self:InitSticker(self.p_comp_sticker_right, self.Cells[2])
end

function UIDecorationStickersAutoRowCell:InitSticker(comp, cellData)
  if comp == nil then
    return
  end
  if cellData == nil then
    comp:SetActive(false)
    return
  end
  comp:SetActive(true)
  local stickerData = {}
  stickerData.Cell = cellData.Cell
  stickerData.Index = cellData.Index
  comp:ReInit(stickerData)
end

return UIDecorationStickersAutoRowCell
