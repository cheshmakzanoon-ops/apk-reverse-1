local LWUIGoldRankItemComAuto = BaseClass("LWUIGoldRankItemComAuto")
local empty_str = "empty"
local show_str = "show"
local title_str = "title"
local btn_info_str = "btn_Info"
local txt_cardtype_str = "title/txt_cardType"
local txt_reward_str = "title/txt_reward"
local sign_str = "show/sign"
local item_player_str = "item/item_player"
local sv_str = "show/sv"
local notpeople_str = "notPeople"
local content_path = "show/sv/content"

function LWUIGoldRankItemComAuto:bind(view)
  view.empty = view:AddComponent(UIBaseContainer, empty_str)
  view.show = view:AddComponent(UIBaseContainer, show_str)
  view.title = view:AddComponent(UIBaseContainer, title_str)
  view.btn_Info = view:AddComponent(UIButton, btn_info_str)
  view.txt_cardType = view:AddComponent(UIText, txt_cardtype_str)
  view.txt_reward = view:AddComponent(UIText, txt_reward_str)
  view.img_sign = view:AddComponent(UIImage, sign_str)
  view.item_player = view:AddComponent(UIBaseContainer, item_player_str)
  view.sv_sv = view:AddComponent(UIScrollView, sv_str)
  view.notpeople = view:AddComponent(UIBaseContainer, notpeople_str)
  view.content = view:AddComponent(UIBaseContainer, content_path)
end

function LWUIGoldRankItemComAuto:unbind(view)
  view.empty = nil
  view.show = nil
  view.title = nil
  view.btn_Info = nil
  view.txt_cardType = nil
  view.txt_reward = nil
  view.img_sign = nil
  view.item_player = nil
  view.sv_sv = nil
  view.notpeople = nil
  view.content = nil
end

return LWUIGoldRankItemComAuto
