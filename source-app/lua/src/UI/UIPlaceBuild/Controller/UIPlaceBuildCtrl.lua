local UIPlaceBuildCtrl = BaseClass("UIPlaceBuildCtrl", UIBaseCtrl)

local function CloseSelf(self)
  DataCenter.GuideManager:SetNoShowUIMain(false)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlaceBuild, {
    anim = true,
    UIMainAnim = UIMainAnimType.ChangeAllShow
  })
  if CS.SceneManager.World then
    CS.SceneManager.World:QuitFocus(LookAtFocusTime)
  end
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function CheckCanGo(self, server, x, y)
  local canJump = false
  if server ~= nil and x ~= nil and y ~= nil and 0 <= x and 0 <= y and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
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
  GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), CS.SceneManager.World.Zoom, nil, nil, server)
end

UIPlaceBuildCtrl.CloseSelf = CloseSelf
UIPlaceBuildCtrl.Close = Close
UIPlaceBuildCtrl.CheckCanGo = CheckCanGo
UIPlaceBuildCtrl.OnJumpClick = OnJumpClick
return UIPlaceBuildCtrl
