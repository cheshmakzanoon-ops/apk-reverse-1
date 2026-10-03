local UIItemRevertAuto = BaseClass("UIItemRevertAuto")
local btn_panel_path = "panel"
local btnswitch_path = "Root/FilterRoot/FilterGouGroup/TimeSwitch/BtnSwitch"
local texttimetype_path = "Root/FilterRoot/FilterGouGroup/TimeSwitch/TextTimeType"
local next_month_text_path = "Root/TopCard/GameObjectTime/ImageTime/TextTime"
local textcount_path = "Root/TopCard/TextRemain"
local uinewbutton_path = "Root/TopCard/GameObjectHistory/UINewButton"
local lw_btn_info_path = "Root/TopCard/LW_Btn_Info"
local lw_btn_close_path = "Root/TopBar/LW_Btn_Close"
local scroll_path = "Root/MiddleContentContainer/ChannelHolder/CScroll"
local ccontent_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/CContent"
local item_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/UIItemRevertItem"
local text_none_path = "Root/MiddleContentContainer/ChannelHolder/CScroll/CViewport/TextNone"
local text_filter_path = "Root/TopCard/GameObjectScreen/TextFilter"
local image_filter_open_path = "Root/TopCard/GameObjectScreen/ImageFilterOpen"
local image_filter_close_path = "Root/TopCard/GameObjectScreen/ImageFilterClose"
local button_filter_path = "Root/TopCard/GameObjectScreen/ButtonFilter"
local filter_full_close_btn_path = "Root/FilterRoot/FilterFullCloseBtn"
local filter_root_path = "Root/FilterRoot"
local filter_option1_path = "Root/FilterRoot/FilterGouGroup/GroupOptions/FilterOption (%d)"
local switch_option1_path = "Root/FilterRoot/FilterSwitchGroup/SwitchOption (%d)"
local UIItemRevertFilterOption = require("UI.UIItemRevert.Component.UIItemRevertFilterOption")
local UIItemRevertSwitchOption = require("UI.UIItemRevert.Component.UIItemRevertSwitchOption")

function UIItemRevertAuto:bind(view)
  view.btn_panel = view:AddComponent(UIButton, btn_panel_path)
  view.btn_btnswitch = view:AddComponent(UIButton, btnswitch_path)
  view.txt_texttimetype = view:AddComponent(UIText, texttimetype_path)
  view.txt_next_month = view:AddComponent(UIText, next_month_text_path)
  view.txt_textcount = view:AddComponent(UIText, textcount_path)
  view.btn_uinewbutton = view:AddComponent(UIButton, uinewbutton_path)
  view.btn_lw_btn_info = view:AddComponent(UIButton, lw_btn_info_path)
  view.btn_lw_btn_close = view:AddComponent(UIButton, lw_btn_close_path)
  view.itemScrollRect = view:AddComponent(UIScrollRect, scroll_path)
  view.compCContent = view:AddComponent(UIBaseContainer, ccontent_path)
  view.itemPrefab = view.transform:Find(item_path).gameObject
  view.text_none = view:AddComponent(UIText, text_none_path)
  view.text_filter = view:AddComponent(UITextMeshProUGUIEx, text_filter_path)
  view.image_filter_open = view:AddComponent(UIImage, image_filter_open_path)
  view.image_filter_close = view:AddComponent(UIImage, image_filter_close_path)
  view.button_filter = view:AddComponent(UIButton, button_filter_path)
  view.filter_full_close_btn = view:AddComponent(UIButton, filter_full_close_btn_path)
  view.filter_root = view:AddComponent(UIBaseContainer, filter_root_path)
  for i = 1, 6 do
    local optionPath = string.format(filter_option1_path, i)
    local option = view:AddComponent(UIItemRevertFilterOption, optionPath)
    if not view.filterOptions then
      view.filterOptions = {}
    end
    table.insert(view.filterOptions, option)
  end
  for i = 1, 2 do
    local switchPath = string.format(switch_option1_path, i)
    local switchOption = view:AddComponent(UIItemRevertSwitchOption, switchPath)
    if not view.switchOptions then
      view.switchOptions = {}
    end
    table.insert(view.switchOptions, switchOption)
  end
end

function UIItemRevertAuto:unbind(view)
  view.btn_panel = nil
  view.btn_btnswitch = nil
  view.txt_texttimetype = nil
  view.txt_next_month = nil
  view.txt_textcount = nil
  view.btn_uinewbutton = nil
  view.btn_lw_btn_info = nil
  view.btn_lw_btn_close = nil
  view.text_none = nil
  view.text_filter = nil
  view.image_filter_open = nil
  view.image_filter_close = nil
  view.button_filter = nil
  view.filter_full_close_btn = nil
  view.filter_root = nil
  view.filterOptions = nil
  view.switchOptions = nil
end

return UIItemRevertAuto
