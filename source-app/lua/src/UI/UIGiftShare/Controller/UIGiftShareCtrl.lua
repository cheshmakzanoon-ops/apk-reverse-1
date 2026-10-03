local UIGiftShareCtrl = BaseClass("UIGiftShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGiftShare, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIGiftShareCtrl:CheckIsEmojiFormatMsg(msg)
  if string.IsNullOrEmpty(msg) then
    return false
  end
  if string.startswith(msg, "<lwEmoji:") and string.endswith(msg, ":>") then
    return true
  end
  return false
end

UIGiftShareCtrl.CloseSelf = CloseSelf
UIGiftShareCtrl.Close = Close
return UIGiftShareCtrl
