local LWUIGoldLotteryItemComAuto = BaseClass("LWUIGoldLotteryItemComAuto")
local lwuigoldlotteryitem_str = ""
local buyed_str = "buyed"
local canbuy_str = "canBuy"
local locked_str = "locked"
local tx_bugcount_str = "canBuy/tx_bugCount"
local locktime_str = "locked/lockTime"
local notbuymaturity_str = "notBuymaturity"

function LWUIGoldLotteryItemComAuto:bind(view)
  view.btn_lwuigoldlotteryitem = view:AddComponent(UIButton, lwuigoldlotteryitem_str)
  view.buyed = view:AddComponent(UIBaseContainer, buyed_str)
  view.canbuy = view:AddComponent(UIBaseContainer, canbuy_str)
  view.locked = view:AddComponent(UIBaseContainer, locked_str)
  view.txt_tx_bugcount = view:AddComponent(UIText, tx_bugcount_str)
  view.txt_locktime = view:AddComponent(UIText, locktime_str)
  view.notbuymaturity = view:AddComponent(UIBaseContainer, notbuymaturity_str)
end

function LWUIGoldLotteryItemComAuto:unbind(view)
  view.btn_lwuigoldlotteryitem = nil
  view.buyed = nil
  view.canbuy = nil
  view.locked = nil
  view.txt_tx_bugcount = nil
  view.txt_locktime = nil
  view.notbuymaturity = nil
end

return LWUIGoldLotteryItemComAuto
