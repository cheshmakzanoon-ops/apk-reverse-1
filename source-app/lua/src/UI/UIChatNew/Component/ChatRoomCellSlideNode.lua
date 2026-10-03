local ChatRoomCellSlideNode = BaseClass("ChatRoomCellSlideNode")

function ChatRoomCellSlideNode:__init(...)
  local param = {
    ...
  }
  self._scrollRectList = {}
  if table.length(param) > 0 then
    param = param[1]
  end
  self._chatView = param.chatview
  local _scrollRect1 = param.mScrollRect1
  self._scrollRectList[#self._scrollRectList + 1] = _scrollRect1
  self._curRoomCell = nil
  self._isMovingChatPanel = false
  self._isDragChild = false
  self._d0 = 0.3
  self._isComplete = true
  self._touchScreenPosX = 0
  self._moveDistance = 0.0375 * Screen.width
  self._touchBeganPosition = nil
end

function ChatRoomCellSlideNode:GetMoveDeltaX()
  local deltaX = 0
  if CS.SDKManager.IS_UNITY_EDITOR() then
    deltaX = CS.UnityEngine.Input:GetAxis("Mouse X")
  elseif CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS() then
    deltaX = CS.UnityEngine.Input:GetTouch(0).deltaPosition.x
  end
  return deltaX
end

function ChatRoomCellSlideNode:StopAllMovement()
  self._isComplete = true
  for _, v in pairs(self._scrollRectList) do
    v:StopMovement()
  end
end

function ChatRoomCellSlideNode:OnBeginDrag(eventData)
  self:StopAllMovement()
  self._chatRoomCellList = self._chatView:GetRoomNodeList()
  local touchDeltaPosition = eventData.delta
  self._touchScreenPosX = eventData.position.x
  self._curRoomCell = nil
  if Mathf.Abs(touchDeltaPosition.x) < Mathf.Abs(touchDeltaPosition.y) then
    self:OnBeginDragVertical(eventData)
  end
end

function ChatRoomCellSlideNode:OnBeginDragVertical(eventData)
  self._isHorizontal = false
  for _, v in pairs(self._scrollRectList) do
    v:OnBeginDrag(eventData)
  end
end

function ChatRoomCellSlideNode:OnDrag(eventData)
  self:OnDragVertical(eventData)
end

function ChatRoomCellSlideNode:OnDragVertical(eventData)
  for _, v in pairs(self._scrollRectList) do
    v:OnDrag(eventData)
  end
end

function ChatRoomCellSlideNode:OnEndDrag(eventData)
  self:OnEndDragVertical(eventData)
end

function ChatRoomCellSlideNode:OnEndDragVertical(eventData)
  for _, v in pairs(self._scrollRectList) do
    v:OnEndDrag(eventData)
  end
end

return ChatRoomCellSlideNode
