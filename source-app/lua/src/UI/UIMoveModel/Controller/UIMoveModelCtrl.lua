local UIMoveModelCtrl = BaseClass("UIMoveModelCtrl", UIBaseCtrl)
local CS = _ENV.CS
local SceneManager = CS.SceneManager
local UnityEngine = CS.UnityEngine

local function CloseSelf(self)
  DataCenter.GuideManager:SetNoShowUIMain(false)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMoveModel, {
    anim = true,
    UIMainAnim = UIMainAnimType.ChangeAllShow
  })
  if CS.SceneManager.World then
    CS.SceneManager.World:QuitFocus(LookAtFocusTime)
  end
end

local function CheckCanGo(self, server, x, y)
  local canJump = false
  if server ~= nil and x ~= nil and y ~= nil and 0 <= x and 0 <= y and x <= SceneManager.World.TileCount.x - 1 and y <= SceneManager.World.TileCount.y - 1 then
    local data = UnityEngine.Vector2Int(x, y)
    if SceneManager.World:IsInMap(data) then
      canJump = true
    end
  end
  return canJump
end

local function OnJumpClick(self, server, x, y)
  local v2 = {}
  v2.x = x
  v2.y = y
  GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), SceneManager.World.Zoom, nil, nil, server)
end

UIMoveModelCtrl.CloseSelf = CloseSelf
UIMoveModelCtrl.CheckCanGo = CheckCanGo
UIMoveModelCtrl.OnJumpClick = OnJumpClick
return UIMoveModelCtrl
