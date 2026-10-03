local ChatUserItem = require("UI.UIChatSearchPerson.Component.UIChatSearchUserItem")
local UIChatSearchPersonCom = BaseClass("UIChatSearchPersonCom", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_inputField = "InputField"
local _cp_inputField_text = "InputField/Placeholder"
local _cp_scrollContent = "showList/Viewport/Content"
local _cp_btnSearch = "btnSearch"
local _cp_btnInvite = "btnInvite"
local _cp_txtInvite = "btnInvite/txtInvite"

function UIChatSearchPersonCom:ComponentDefine()
  self._btnSearch = self:AddComponent(UIButton, _cp_btnSearch)
  self._btnSearch:SetOnClick(BindCallback(self, self.OnClickBtnSearch))
  self._inputField = self:AddComponent(UIInput, _cp_inputField)
  self._inputField_text = self:AddComponent(UIText, _cp_inputField_text)
  self._scrollContent = self:AddComponent(UIBaseContainer, _cp_scrollContent)
  self._btnInvite = self:AddComponent(UIButton, _cp_btnInvite)
  self._btnInvite:SetOnClick(BindCallback(self, self.OnClickInvite))
  self._txtInvite = self:AddComponent(UIText, _cp_txtInvite)
end

function UIChatSearchPersonCom:DataInit()
  self._freeUserItemList = {}
  self._userItemList = {}
  self._loadingPrefab = {}
  self._prefabNameIndex = 0
  self.uidArr = {}
  self.roomName = ""
end

function UIChatSearchPersonCom:OnCreate()
  base.OnCreate(self)
  self:DataInit()
  self:ComponentDefine()
  self._inputField_text:SetLocalText(290039)
  self._txtInvite:SetLocalText(390198)
end

function UIChatSearchPersonCom:ReInit()
  self:DataInit()
  self._scrollContent:DestroyChildNode()
  self._inputField:SetText("")
end

function UIChatSearchPersonCom:OnEnable()
  base.OnEnable(self)
end

function UIChatSearchPersonCom:OnDisable()
  base.OnDisable(self)
end

function UIChatSearchPersonCom:OnAddListener()
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, self.UpdateUserList)
end

function UIChatSearchPersonCom:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT, self.UpdateUserList)
end

function UIChatSearchPersonCom:OnClickBtnSearch()
  local _strInput = self._inputField:GetText()
  if string.IsNullOrEmpty(_strInput) then
    UIUtil.ShowTipsId(120193)
    return
  end
  local param = {}
  param.searchKey = _strInput
  param.page = 1
  EventManager:GetInstance():Broadcast(ChatEventEnum.SEARCH_PLAYER_COMMAND, param)
end

function UIChatSearchPersonCom:OnClickInvite()
  self.uidArr = {}
  self.roomName = ""
  local str = ""
  local spaceStr = ","
  local myName = ChatInterface.getPlayerName()
  for _, userItem in pairs(self._userItemList) do
    if userItem:GetToggle() then
      local userInfo = userItem:GetUserData()
      if userInfo ~= nil then
        local memberName = ""
        if userInfo.name then
          memberName = userInfo.name
          table.insert(self.uidArr, userInfo.uid)
        elseif userInfo.learderName then
          memberName = userInfo.learderName
          table.insert(self.uidArr, userInfo.learderUid)
        end
        if myName ~= memberName then
          if str ~= "" then
            str = str .. spaceStr .. memberName
          else
            str = memberName
          end
        end
      end
    end
  end
  if str == "" then
    self.roomName = myName
    self:CreateRoom()
  else
    self.roomName = myName .. spaceStr .. str
    local endStr = Localization:GetString("290025", str)
    self:GotoAlterView(endStr)
  end
end

function UIChatSearchPersonCom:CreateRoom()
  if self.uidArr == nil or #self.uidArr == 0 then
    UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, "290036", function()
    end)
    return
  end
  local roomId = self.view.ctrl.chatRoomdId
  if roomId == nil then
    local t = {
      type = 0,
      name = self.roomName,
      memberList = self.uidArr
    }
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CREATE_COMMAND, t)
  else
    local t = {
      roomId = roomId,
      uidArr = self.uidArr
    }
    EventManager:GetInstance():Broadcast(ChatEventEnum.ROOM_INVITE_COMMAND, t)
  end
  self.view.ctrl:CloseSelf()
end

function UIChatSearchPersonCom:GotoAlterView(message)
  UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self:CreateRoom()
  end)
end

function UIChatSearchPersonCom:UpdateUserList(_list)
  if _list == nil then
    return
  end
  self._loadingPrefab = {}
  self._scrollContent:DestroyChildNode()
  for index, userInfo in pairs(_list) do
    self:AddUserItem(userInfo, index)
  end
end

function UIChatSearchPersonCom:AddUserItem(userInfo, index)
  if #self._freeUserItemList > 0 then
    local temp = table.remove(self._freeUserItemList)
    if temp ~= nil then
      temp:SetActive(true)
      temp:setData(userInfo)
      temp.transform:SetParent(self._scrollContent.transform)
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

function UIChatSearchPersonCom:AddUserItemDone(request, userInfo, index)
  if request.isError then
    return
  end
  local go = request.gameObject
  go.transform:SetParent(self._scrollContent.transform)
  go.transform:SetAsLastSibling()
  go.name = "user" .. "..." .. self._prefabNameIndex
  local temp = self._scrollContent:AddComponent(ChatUserItem, go.name)
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

return UIChatSearchPersonCom
