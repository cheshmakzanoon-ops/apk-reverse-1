local p_comp_sticker_show_path = "p_comp_sticker_show"
local p_text_auto_sticker_desc_path = "p_text_auto_sticker_desc"
local p_btn_sticker_show_left_path = "p_btn_sticker_show_left"
local p_btn_sticker_show_right_path = "p_btn_sticker_show_right"
local UIDecorationStickersAutoStickerCell = require("UI.UIDecoration.UIDecorationMain.Component.Sticker.Comp.Auto.UIDecorationStickersAutoStickerCell")
local base = UIBaseContainer
local UIDecorationStickersAutoStickerShowComp = BaseClass("UIDecorationStickersAutoStickerShowComp", UIBaseContainer)

function UIDecorationStickersAutoStickerShowComp:ComponentDefine()
  self.p_comp_sticker_show = self:AddComponent(UIDecorationStickersAutoStickerCell, p_comp_sticker_show_path)
  self.p_text_auto_sticker_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_auto_sticker_desc_path)
  self.p_btn_sticker_show_left = self:AddComponent(UIButton, p_btn_sticker_show_left_path)
  self.p_btn_sticker_show_left:SetOnClick(BindCallback(self, self.OnClickLeft))
  self.p_btn_sticker_show_right = self:AddComponent(UIButton, p_btn_sticker_show_right_path)
  self.p_btn_sticker_show_right:SetOnClick(BindCallback(self, self.OnClickRight))
end

function UIDecorationStickersAutoStickerShowComp:ComponentDestroy()
  self.p_comp_sticker_show = nil
  self.p_text_auto_sticker_desc = nil
  self.p_btn_sticker_show_left = nil
  self.p_btn_sticker_show_right = nil
end

function UIDecorationStickersAutoStickerShowComp:DataDefine()
end

function UIDecorationStickersAutoStickerShowComp:DataDestroy()
end

function UIDecorationStickersAutoStickerShowComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDecorationStickersAutoStickerShowComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationStickersAutoStickerShowComp:OnAddListener()
  base.OnAddListener(self)
end

function UIDecorationStickersAutoStickerShowComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDecorationStickersAutoStickerShowComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UIDecorationStickersAutoStickerShowComp:InitData(data)
  if data ~= nil and data.Cell ~= nil then
    self.Data = data
    return true
  end
  return false
end

function UIDecorationStickersAutoStickerShowComp:InitUi()
  self.p_text_auto_sticker_desc:SetLocalText(self.Data.Cell.desc)
  self.p_btn_sticker_show_left:SetActive(self.Data.Index > 1)
  self.p_btn_sticker_show_right:SetActive(self.Data.Index < self.Data.Total)
end

function UIDecorationStickersAutoStickerShowComp:UpdateData()
  local stickerId = self.Data ~= nil and DataCenter.LWSticker3DManager:GetAutoStickerId(self.Data.Cell.auto_send_param) or 0
  self.StickerCell = LocalController:instance():tryGetLine(TableName.LW_Sticker, stickerId)
  self.HasSticker = self.StickerCell ~= nil
  return true
end

function UIDecorationStickersAutoStickerShowComp:UpdateUi()
  local data = {}
  data.Cell = self.Data.Cell
  data.Index = self.Data.Index
  data.IsDetail = self.Data.IsDetail
  self.p_comp_sticker_show:ReInit(data)
end

function UIDecorationStickersAutoStickerShowComp:OnClickLeft()
  self.holder:TryShowPre()
end

function UIDecorationStickersAutoStickerShowComp:OnClickRight()
  self.holder:TryShowNext()
end

return UIDecorationStickersAutoStickerShowComp
