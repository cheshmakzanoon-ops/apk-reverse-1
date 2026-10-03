local LWUIGoldTreeInfoComAuto = BaseClass("LWUIGoldTreeInfoComAuto")
local panel_str = "UICommonPopUpTitle/panel"
local closebtn_str = "UICommonPopUpTitle/CloseBtn"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local txt_cardtype_str = "area/Top/txt_cardType"
local btn_info_str = "area/btn_info"
local icon_str = "area/Top/reward/img/icon"
local txt_rewardcount_str = "area/Top/reward/txt_rewardCount"
local scrollview_str = "area/Center/ScrollView"
local content_str = "area/Center/ScrollView/Content"
local toggle_str = "area/Buttom/Toggle"
local txt_toggle_str = "area/Buttom/Toggle/txt_Toggle"
local txt_tip_str = "area/Buttom/txt_Tip"

function LWUIGoldTreeInfoComAuto:bind(view)
  view.btn_panel = view:AddComponent(UIButton, panel_str)
  view.btn_closebtn = view:AddComponent(UIButton, closebtn_str)
  view.title_text = view:AddComponent(UIText, title_text_path)
  view.g_top = {
    txt_cardType = view:AddComponent(UIText, txt_cardtype_str),
    btn_info = view:AddComponent(UIButton, btn_info_str),
    img_icon = view:AddComponent(UIImage, icon_str),
    txt_rewardCount = view:AddComponent(UIText, txt_rewardcount_str)
  }
  view.g_center = {
    sv_scrollview = view:AddComponent(UIScrollView, scrollview_str),
    content = view:AddComponent(UIBaseContainer, content_str)
  }
  view.g_bottom = {
    txt_Toggle = view:AddComponent(UIText, txt_toggle_str),
    txt_Tip = view:AddComponent(UIText, txt_tip_str),
    toggle_toggle = view:AddComponent(UIToggle, toggle_str)
  }
end

function LWUIGoldTreeInfoComAuto:unbind(view)
  view.btn_panel = nil
  view.btn_closebtn = nil
  view.title_text = nil
  view.g_top = nil
  view.g_center = nil
  view.g_bottom = nil
end

return LWUIGoldTreeInfoComAuto
