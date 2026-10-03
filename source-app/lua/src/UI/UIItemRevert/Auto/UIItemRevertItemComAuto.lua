local UIItemRevertItemComAuto = BaseClass("UIItemRevertItemComAuto")
local txt_textitemtime_path = "TopGroup/Top/TextItemTime"
local textremaining_path = "TopGroup/TextRemaining"
local uicommonresitem_path = "TopGroup/UICommonResItem"
local lw_btn_common_new_path = "TopGroup/gBtn/LW_Btn_Common_New"
local content_path = "TopGroup/Scroll View/Viewport/Content"
local uiitemrevertresitem_path = "TopGroup/Scroll View/Viewport/Content/UIItemRevertResItem"
local con_activity_path = "BotActivity"
local text_closetime_path = "BotActivity/TextCloseTime"
local com_chip_path = "BotChip"
local text_chip_path = "BotChip/TextChip"
local com_card_path = "BotCard"
local text_card_path = "BotCard/TextCard"
local com_shop_path = "BotShopNum"
local text_shopnum_path = "BotShopNum/TextShopNum"

function UIItemRevertItemComAuto:bind(view)
  view.txt_textitemtime = view:AddComponent(UIText, txt_textitemtime_path)
  view.txt_textremaining = view:AddComponent(UIText, textremaining_path)
  view.bind_uicommonresitem = view:AddComponent(UICommonResItem, uicommonresitem_path)
  view.rtrancontent = view:AddComponent(UIBaseContainer, content_path)
  view.revertItemPrefab = view.transform:Find(uiitemrevertresitem_path).gameObject
  view.btn_lw_btn_common_new = view:AddComponent(UIButton, lw_btn_common_new_path)
  view.con_activity = view:AddComponent(UIBaseContainer, con_activity_path)
  view.txt_closetime = view:AddComponent(UIText, text_closetime_path)
  view.con_chip = view:AddComponent(UIBaseContainer, com_chip_path)
  view.text_chip = view:AddComponent(UITextMeshProUGUIEx, text_chip_path)
  view.con_card = view:AddComponent(UIBaseContainer, com_card_path)
  view.text_card = view:AddComponent(UITextMeshProUGUIEx, text_card_path)
  view.con_shop = view:AddComponent(UIBaseContainer, com_shop_path)
  view.text_shopnum = view:AddComponent(UITextMeshProUGUIEx, text_shopnum_path)
end

function UIItemRevertItemComAuto:unbind(view)
  view.txt_textitemtime = nil
  view.txt_textremaining = nil
  view.bind_uicommonresitem = nil
  view.btn_lw_btn_common_new = nil
  view.con_activity = nil
  view.txt_closetime = nil
  view.con_chip = nil
  view.text_chip = nil
  view.con_card = nil
  view.text_card = nil
  view.con_shop = nil
  view.text_shopnum = nil
end

return UIItemRevertItemComAuto
