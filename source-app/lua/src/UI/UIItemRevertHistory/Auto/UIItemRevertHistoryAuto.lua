local UIItemRevertHistoryAuto = BaseClass("UIItemRevertHistoryAuto")
local panel_path = "panel"
local textnone_path = "Root/MiddleContentContainer/ChannelHolder/textNone"
local ccontent_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CContent"
local cscroll_path = "Root/MiddleContentContainer/ChannelHolder/CScroll"
local lw_btn_close_path = "Root/TopBar/LW_Btn_Close"

function UIItemRevertHistoryAuto:bind(view)
  view.btn_panel = view:AddComponent(UIButton, panel_path)
  view.txt_textNone = view:AddComponent(UIText, textnone_path)
  view.itemGridInfinityScrollView = view:AddComponent(GridInfinityScrollView, ccontent_path)
  view.itemScrollRect = view:AddComponent(UIScrollRect, cscroll_path)
  view.btn_LW_Btn_Close = view:AddComponent(UIButton, lw_btn_close_path)
end

function UIItemRevertHistoryAuto:unbind(view)
  view.btn_panel = nil
  view.txt_textNone = nil
  view.btn_LW_Btn_Close = nil
end

return UIItemRevertHistoryAuto
