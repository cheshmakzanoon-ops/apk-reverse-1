local LWUIGTInfoItemComAuto = BaseClass("LWUIGTInfoItemComAuto")
local firstnametxt_str = "info/firstNameTxt"
local img_card_str = "card/img_card"
local img_card1_str = "card/img_card1"
local img_card2_str = "card/img_card2"
local img_card3_str = "card/img_card3"
local img_card4_str = "card/img_card4"
local uicommonhead_str = "player/UICommonHead"
local bgother_str = "bgOther"
local bgself_str = "bgSelf"
local lotterycount_str = "info/Image/lotteryCount"

function LWUIGTInfoItemComAuto:bind(view)
  view.txt_firstnametxt = view:AddComponent(UIText, firstnametxt_str)
  view.mul_img_card = {
    view:AddComponent(UIImage, img_card_str),
    view:AddComponent(UIImage, img_card1_str),
    view:AddComponent(UIImage, img_card2_str),
    view:AddComponent(UIImage, img_card3_str),
    view:AddComponent(UIImage, img_card4_str)
  }
  view.bind_uicommonhead = view:AddComponent(UICommonHead, uicommonhead_str)
  view.img_bgother = view:AddComponent(UIImage, bgother_str)
  view.img_bgself = view:AddComponent(UIImage, bgself_str)
  view.txt_lotterycount = view:AddComponent(UIText, lotterycount_str)
end

function LWUIGTInfoItemComAuto:unbind(view)
  view.txt_firstnametxt = nil
  view.mul_img_card = nil
  view.bind_uicommonhead = nil
  view.img_bgother = nil
  view.img_bgself = nil
  view.txt_lotterycount = nil
end

return LWUIGTInfoItemComAuto
