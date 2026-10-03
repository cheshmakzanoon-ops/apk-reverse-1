local UIAllianceStarMainChatPanel = BaseClass("UIAllianceStarMainChatPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceStarMainChatBottom = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainChatBottom")
local UIAllianceStarMainChatMiddle = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainChatMiddle")
local UIAllianceStarMainChatBottomPrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarMainChatBottom.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:CreateChatData()
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.middle = self:AddComponent(UIAllianceStarMainChatMiddle, "middle")
end

local function ComponentDestroy(self)
  self.middle = nil
  self.chatBottom = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.chatRoomMgr = nil
  self.roomSets = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CreateChatData(self)
  self.chatRoomMgr = ChatInterface.getRoomMgr()
  DataCenter.ChatCacheMsgManager:RemoveMsgByCache()
  
  local function __GetRoomSetUnreadNumber(roomSet)
    if not roomSet or not roomSet.rooms then
      return 0
    end
    local unread = 0
    for _, room in ipairs(roomSet.rooms) do
      unread = unread + (room and room:getNewMsgNum() or 0)
    end
    return unread
  end
  
  self.roomSets = {
    {
      category = ChatRoomCategory.ALLIANCE,
      groups = {
        ChatGroupType.GROUP_ALLIANCE,
        ChatGroupType.GROUP_ALLIANCE_NOTICE,
        ChatGroupType.GROUP_ALLIANCE_MANAGER
      },
      textKey = "393081",
      rooms = nil,
      currRoom = nil,
      selected = true,
      GetUnreadNumber = __GetRoomSetUnreadNumber
    }
  }
  self:UpdateSetRooms()
end

local function AddChatBottom(self)
  if self.chatBottomReq == nil then
    self.chatBottomReq = self:GameObjectInstantiateAsync(UIAllianceStarMainChatBottomPrefabPath, function(request)
      local go = request.gameObject
      go.name = "chatBottom"
      local trans = go.transform
      trans:SetParent(self.transform)
      trans:Set_localScale(1, 1, 1)
      trans:Set_localRotation(0, 0, 0, 1)
      self.chatBottom = self:AddComponent(UIAllianceStarMainChatBottom, go.name)
      self.chatBottom:SetAnchoredPositionXY(0, 0)
      self.chatBottom:SetSizeDeltaXY(0, 170)
    end)
  end
end

local function RemoveChatBottom(self)
  if self.chatBottom then
    self:RemoveComponent("chatBottom", UIAllianceStarMainChatBottom)
    self.chatBottom = nil
  end
  if self.chatBottomReq then
    self:GameObjectDestroy(self.chatBottomReq)
    self.chatBottomReq = nil
  end
end

local function GetSelectedRoomSet(self)
  if not self.roomSets then
    return nil
  end
  for _, roomSet in pairs(self.roomSets) do
    if roomSet.selected then
      return roomSet
    end
  end
  return nil
end

local function GetSelectedRoom(self)
  local roomSet = self:GetSelectedRoomSet()
  if roomSet then
    return roomSet.currRoom
  end
  return nil
end

local function UpdateSetRooms(self)
  if not self.chatRoomMgr then
    self.chatRoomMgr = ChatInterface.getRoomMgr()
  end
  for _, roomSet in ipairs(self.roomSets) do
    if roomSet.category == ChatRoomCategory.PRIVATE then
      self:UpdatePrivateSetRooms()
    else
      roomSet.rooms = {}
      for _, group in ipairs(roomSet.groups) do
        local room = self.chatRoomMgr:GetRoomDataByGroup(group)
        if room then
          table.insert(roomSet.rooms, room)
          if not roomSet.currRoom then
            roomSet.currRoom = room
          end
        end
      end
    end
  end
end

function UIAllianceStarMainChatPanel:OpenChatView()
  self.middle:OnClickZone()
  local roomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  if roomId then
    self:RemoveChatBottom()
    GoToUtil.OpenChatView(false, {anim = false, immediately = true}, {roomId = roomId})
  end
end

UIAllianceStarMainChatPanel.OnCreate = OnCreate
UIAllianceStarMainChatPanel.OnDestroy = OnDestroy
UIAllianceStarMainChatPanel.OnEnable = OnEnable
UIAllianceStarMainChatPanel.OnDisable = OnDisable
UIAllianceStarMainChatPanel.ComponentDefine = ComponentDefine
UIAllianceStarMainChatPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainChatPanel.DataDefine = DataDefine
UIAllianceStarMainChatPanel.DataDestroy = DataDestroy
UIAllianceStarMainChatPanel.OnAddListener = OnAddListener
UIAllianceStarMainChatPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainChatPanel.CreateChatData = CreateChatData
UIAllianceStarMainChatPanel.AddChatBottom = AddChatBottom
UIAllianceStarMainChatPanel.RemoveChatBottom = RemoveChatBottom
UIAllianceStarMainChatPanel.GetSelectedRoomSet = GetSelectedRoomSet
UIAllianceStarMainChatPanel.GetSelectedRoom = GetSelectedRoom
UIAllianceStarMainChatPanel.UpdateSetRooms = UpdateSetRooms
return UIAllianceStarMainChatPanel
