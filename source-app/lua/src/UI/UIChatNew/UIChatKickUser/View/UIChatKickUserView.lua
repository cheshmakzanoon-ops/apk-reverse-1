local UIChatKickUserView = BaseClass("UIChatKickUserView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChatUserItem = require("UI.UIChatSearchPerson.Component.UIChatSearchUserItem")
local _cp_txtTitle = "ImgBg/TxtTitle"
local _cp_btnClose = "ImgBg/CloseBtn"
local _cp_allUserContent = "objUser/showList/Viewport/Content"
local _cp_btnKick = "objUser/btnKick"
local _cp_txtKick = "objUser/btnKick/txtKick"

function UIChatKickUserView:ComponentDefine()
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self._allUserContent = self:AddComponent(UIBaseContainer, _cp_allUserContent)
  self._btnKick = self:AddComponent(UIButton, _cp_btnKick)
  self._btnKick:SetOnClick(BindCallback(self, self.OnClickKick))
  self._txtKick = self:AddComponent(UIText, _cp_txtKick)
end

function UIChatKickUserView:OnClickKick()
  local msg = ""
  local uidArr = {}
  for _, userItem in pairs(self._userItemList) do
    if userItem:GetToggle() then
      local userinfo = userItem:GetUserData()
      msg = (msg == "" and "" or ",") .. userinfo:GetUserName()
      uidArr[#uidArr + 1] = userinfo.uid
    end
  end
  if table.length(uidArr) == 0 then
    UIUtil.ShowTipsId(100290)
    return
  end
  EventManager:GetInstance():Broadcast(ChatEventEnum.ROOM_KICK_COMMAND, {
    roomId = self.view.ctrl._chatRoomId,
    uidArr = uidArr
  })
  self.view.ctrl:CloseSelf()
end

function UIChatKickUserView:DataDefine()
  self._freeUserItemList = {}
  self._userItemList = {}
  self._loadingPrefab = {}
  self._prefabNameIndex = 0
end

function UIChatKickUserView:InitView()
  self._txtTitle:SetLocalText(290037)
  self._txtKick:SetLocalText(GameDialogDefine.CONFIRM)
  self._loadingPrefab = {}
  self._allUserContent:DestroyChildNode()
  local chatuserinfo = self.view.ctrl:GetChatRoomMemberIds()
  for index, userId in pairs(chatuserinfo) do
    local userInfo = self.view.ctrl:GetUserInfoById(userId)
    if userInfo.uid ~= ChatInterface.getPlayerUid() then
      self:AddUserItem(userInfo, index)
    end
  end
end

function UIChatKickUserView:OnCreate()
  base.OnCreate(self)
  self.view.ctrl._chatRoomId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIChatKickUserView:AddUserItem(userInfo, index)
  if #self._freeUserItemList > 0 then
    local temp = table.remove(self._freeUserItemList)
    if temp ~= nil then
      temp:SetActive(true)
      temp:setData(userInfo)
      temp.transform:SetParent(self._allUserContent.transform)
      temp.transform:SetAsLastSibling()
      self._userItemList[index] = temp
    end
  else
    local req = self:GameObjectInstantiateAsync(UIAssets.UIChatSearchPersonItem, function(request)
      self:AddUserItemDone(request, userInfo, index)
    end)
    self._loadingPrefab[req] = true
  end
end

function UIChatKickUserView:AddUserItemDone(request, userInfo, index)
  if request.isError then
    return
  end
  local go = request.gameObject
  go.transform:SetParent(self._allUserContent.transform)
  go.transform:SetAsLastSibling()
  go.name = "user" .. "..." .. self._prefabNameIndex
  local temp = self._allUserContent:AddComponent(ChatUserItem, go.name)
  self._prefabNameIndex = self._prefabNameIndex + 1
  if self._loadingPrefab[request] then
    self._loadingPrefab[request] = nil
    go:SetActive(true)
    self._userItemList[index] = temp
    self._userItemList[index]:SetData(userInfo)
  else
    go:SetActive(false)
    table.insert(self._freeUserItemList, temp)
  end
end

return UIChatKickUserView
