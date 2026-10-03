local UITCViewCardDeckPanelCtrl = BaseClass("UITCViewCardDeckPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCViewCardDeckPanel)
end

function UITCViewCardDeckPanelCtrl:CardsToSlotData(cards)
  local slotData = {}
  if not cards then
    return slotData
  end
  for _, v in ipairs(cards) do
    local slotId = v.slot
    slotData[slotId] = v
  end
  return slotData
end

UITCViewCardDeckPanelCtrl.CloseSelf = CloseSelf
return UITCViewCardDeckPanelCtrl
