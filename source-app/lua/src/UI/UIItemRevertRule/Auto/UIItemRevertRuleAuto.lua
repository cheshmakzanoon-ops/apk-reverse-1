local UIItemRevertRuleAuto = BaseClass("UIItemRevertRuleAuto")
local btn_panel_path = "panel"
local lw_btn_close_path = "Root/TopBar/LW_Btn_Close"
local text8_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/Text8"
local raw_image8_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RawImage8"
local remaining1_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RawImage7/Remaining1"
local remaining2_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RawImage7/Remaining2"
local viptext1_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RawImage7/VipText1"
local viptext2_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent/RawImage7/VipText2"

function UIItemRevertRuleAuto:bind(view)
  view.btn_panel = view:AddComponent(UIButton, btn_panel_path)
  view.btn_LW_Btn_Close = view:AddComponent(UIButton, lw_btn_close_path)
  view.text8 = view:AddComponent(UIBaseContainer, text8_path)
  view.raw_image8 = view:AddComponent(UIBaseContainer, raw_image8_path)
  view.remaining1 = view:AddComponent(UITextMeshProUGUIEx, remaining1_path)
  view.remaining2 = view:AddComponent(UITextMeshProUGUIEx, remaining2_path)
  view.viptext1 = view:AddComponent(UITextMeshProUGUIEx, viptext1_path)
  view.viptext2 = view:AddComponent(UITextMeshProUGUIEx, viptext2_path)
end

function UIItemRevertRuleAuto:unbind(view)
  view.btn_panel = nil
  view.btn_LW_Btn_Close = nil
  view.text8 = nil
  view.raw_image8 = nil
  view.remaining1 = nil
  view.remaining2 = nil
  view.viptext1 = nil
  view.viptext2 = nil
end

return UIItemRevertRuleAuto
