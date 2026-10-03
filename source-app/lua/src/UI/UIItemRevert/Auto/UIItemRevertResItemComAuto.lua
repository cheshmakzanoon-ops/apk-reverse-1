local UIItemRevertResItemComAuto = BaseClass("UIItemRevertResItemComAuto")
local uicommonresitem_path = "UICommonResItem"
local textremaining_path = "TextRemaining"

function UIItemRevertResItemComAuto:bind(view)
  view.bind_uicommonresitem = view:AddComponent(UICommonResItem, uicommonresitem_path)
  view.txt_textremaining = view:AddComponent(UIText, textremaining_path)
end

function UIItemRevertResItemComAuto:unbind(view)
  view.bind_uicommonresitem = nil
  view.txt_textremaining = nil
end

return UIItemRevertResItemComAuto
