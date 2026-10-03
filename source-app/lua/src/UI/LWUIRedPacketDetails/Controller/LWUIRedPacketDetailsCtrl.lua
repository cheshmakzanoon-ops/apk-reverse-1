local LWUIRedPacketDetailsCtrl = BaseClass("LWUIRedPacketDetailsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIRedPacketDetails)
end

local function getMax(arr)
  local max = arr[1].count
  local index = 1
  for i = 2, #arr do
    if max < arr[i].count then
      max = arr[i].count
      index = i
    end
  end
  return index
end

local function InitPlayers(players, num)
  if #players == num then
    local index = getMax(players)
    if index and players[index] then
      players[index].isBest = true
    end
  end
  return players
end

local function InitLuckyPacketPlayers(players, buffReceiverUid)
  if not buffReceiverUid then
    return players
  end
  for index, player_info in ipairs(players) do
    if player_info.uid == buffReceiverUid then
      players[index].isBest = true
    end
  end
  return players
end

LWUIRedPacketDetailsCtrl.CloseSelf = CloseSelf
LWUIRedPacketDetailsCtrl.InitPlayers = InitPlayers
LWUIRedPacketDetailsCtrl.InitLuckyPacketPlayers = InitLuckyPacketPlayers
return LWUIRedPacketDetailsCtrl
