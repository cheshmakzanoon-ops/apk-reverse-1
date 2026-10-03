local UIPositionTipCtrl = BaseClass("UIPositionTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentState(self)
  local showData = {}
  showData.serverId = LuaEntry.Player:GetSelfServerId()
  local carTilePos = CS.SceneManager.World.CurTilePosClamped
  showData.x = carTilePos.x
  showData.y = carTilePos.y
  return showData
end

local function CheckCanGo(self, server, x, y)
  local canJump = false
  if server ~= nil and x ~= nil and y ~= nil and server == LuaEntry.Player:GetSelfServerId() and 0 <= x and 0 <= y and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
    local data = CS.UnityEngine.Vector2Int(x, y)
    if CS.SceneManager.World:IsInMap(data) then
      canJump = true
    end
  end
  return canJump
end

local function OnJumpClick(self, server, x, y)
  local v2 = {}
  v2.x = x
  v2.y = y
  GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), CS.SceneManager.World.InitZoom)
  DataCenter.WorldFavoDataManager:SetLastGotoPos(tostring(server) .. ";" .. tostring(x) .. ";" .. tostring(y))
  self:CloseSelf()
end

UIPositionTipCtrl.CloseSelf = CloseSelf
UIPositionTipCtrl.Close = Close
UIPositionTipCtrl.GetCurrentState = GetCurrentState
UIPositionTipCtrl.CheckCanGo = CheckCanGo
UIPositionTipCtrl.OnJumpClick = OnJumpClick
return UIPositionTipCtrl
