local UILWBargainShopShareCtrl = BaseClass("UILWBargainShopShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBargainShopShare, {anim = true})
end

local function GetPlayers(data, callBack)
  local count = data.template.bargain_num
  local playerList = {}
  local player
  for i = 1, count do
    player = data.helpPlayers[i] or {}
    player.currency = data.template.currency
    player.callBack = callBack
    table.insert(playerList, player)
  end
  return playerList
end

UILWBargainShopShareCtrl.GetPlayers = GetPlayers
UILWBargainShopShareCtrl.CloseSelf = CloseSelf
return UILWBargainShopShareCtrl
