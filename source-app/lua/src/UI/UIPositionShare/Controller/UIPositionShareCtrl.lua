local UIPositionShareCtrl = BaseClass("UIPositionShareCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionShare, {
    anim = true,
    UIMainAnim = UIMainAnimType.LeftRightBottomShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetParamByType(share_param)
  if share_param.type == ShareType.Pos or share_param.type == nil then
    if not string.IsNullOrEmpty(share_param.pos) then
      local pos = SceneUtils.IndexToTilePos(share_param.pos, ForceChangeScene.World)
      share_param.pos = nil
      share_param.x = pos.x
      share_param.y = pos.y
    end
  elseif share_param.type == ShareType.BargainShop then
  end
  return share_param
end

local function GetChatList(self)
  local _chatRoomManager = ChatInterface.getRoomMgr()
  return _chatRoomManager:GetShareRoom()
end

UIPositionShareCtrl.CloseSelf = CloseSelf
UIPositionShareCtrl.Close = Close
UIPositionShareCtrl.GetChatList = GetChatList
UIPositionShareCtrl.GetParamByType = GetParamByType
return UIPositionShareCtrl
