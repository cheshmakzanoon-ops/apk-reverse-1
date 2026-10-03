local UIItemRevertConfirmAuto = BaseClass("UIItemRevertConfirmAuto")
local btn_panel_path = "panel"
local lw_btn_close_path = "Root/LW_Btn_Close"
local textremainingtime_path = "Root/TextRemainingTime"
local textremainingcount_path = "Root/TextRemainingCount"
local content_path = "Root/Scroll View/Viewport/Content"
local uiitemrevertresitem_path = "Root/Scroll View/Viewport/Content/UICommonResItem"
local lw_btn_common_newcancel_path = "Root/GoBtn1/LW_Btn_Common_NewCancel"
local lw_btn_common_newconfirm_path = "Root/GoBtn2/LW_Btn_Common_NewConfirm"
local leftuiitemrevertresitem_path = "Root/UICommonResItem"
local arrow_left1_path = "Root/ArrowLeft1"
local arrow_left2_path = "Root/ArrowLeft2"
local arrow_left3_path = "Root/ArrowLeft3"

function UIItemRevertConfirmAuto:bind(view)
  view.btn_panel = view:AddComponent(UIButton, btn_panel_path)
  view.btn_LW_Btn_Close = view:AddComponent(UIButton, lw_btn_close_path)
  view.txt_RemainingTime = view:AddComponent(UIText, textremainingtime_path)
  view.txt_RemainingCount = view:AddComponent(UIText, textremainingcount_path)
  view.rTran_Content = view:AddComponent(UIBaseContainer, content_path)
  view.revertItemPrefab = view.transform:Find(uiitemrevertresitem_path).gameObject
  view.btn_LW_Btn_Common_NewCancel = view:AddComponent(UIButton, lw_btn_common_newcancel_path)
  view.btn_LW_Btn_Common_NewConfirm = view:AddComponent(UIButton, lw_btn_common_newconfirm_path)
  view.bind_LeftUIItemRevertResItem = view:AddComponent(UICommonResItem, leftuiitemrevertresitem_path)
  view.arrow_left1 = view:AddComponent(UIBaseContainer, arrow_left1_path)
  view.arrow_left2 = view:AddComponent(UIBaseContainer, arrow_left2_path)
  view.arrow_left3 = view:AddComponent(UIBaseContainer, arrow_left3_path)
end

function UIItemRevertConfirmAuto:unbind(view)
  view.btn_panel = nil
  view.btn_LW_Btn_Close = nil
  view.btn_LW_Btn_Common_New = nil
  view.bind_LeftUIItemRevertResItem = nil
  view.txt_RemainingCount = nil
  view.txt_RemainingTime = nil
  view.btn_LW_Btn_Common_NewCancel = nil
  view.btn_LW_Btn_Common_NewConfirm = nil
  view.arrow_left1 = nil
  view.arrow_left2 = nil
  view.arrow_left3 = nil
end

return UIItemRevertConfirmAuto
