local UIItemRevertHistoryItemComAuto = BaseClass("UIItemRevertHistoryItemComAuto")
local textremaining_path = "Top/TextItemTime"
local uicommonresitem_path = "UICommonResItem"
local content_path = "Scroll View/Viewport/Content"
local uiitemrevertresitem_path = "Scroll View/Viewport/Content/UICommonResItem"

function UIItemRevertHistoryItemComAuto:bind(view)
  view.txt_TextRemaining = view:AddComponent(UIText, textremaining_path)
  view.bind_UICommonResItem = view:AddComponent(UICommonResItem, uicommonresitem_path)
  view.rtrancontent = view:AddComponent(UIBaseContainer, content_path)
  view.revertItemPrefab = view.transform:Find(uiitemrevertresitem_path).gameObject
end

function UIItemRevertHistoryItemComAuto:unbind(view)
  view.txt_TextRemaining = nil
  view.bind_UICommonResItem = nil
end

return UIItemRevertHistoryItemComAuto
