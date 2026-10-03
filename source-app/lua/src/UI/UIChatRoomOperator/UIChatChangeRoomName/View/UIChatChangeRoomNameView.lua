local UIChatChangeRoomNameView = BaseClass("UIChatChangeRoomNameView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_txtTitle = "UICommonMidPopUpTitle/titleText"
local _cp_btnClose = "UICommonMidPopUpTitle/CloseBtn"
local _cp_input = "InputField"
local _cp_btnOk = "RightBtn"
local _cp_txtBtnOk = "RightBtn/RightBtnName"

function UIChatChangeRoomNameView:ComponentDefine()
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self._input = self:AddComponent(UIInput, _cp_input)
  self._btnOk = self:AddComponent(UIButton, _cp_btnOk)
  self._btnOk:SetOnClick(BindCallback(self, self.OnClickBtnOk))
  self._txtBtnOk = self:AddComponent(UIText, _cp_txtBtnOk)
end

function UIChatChangeRoomNameView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_NAME, self.OnChangeName)
end

function UIChatChangeRoomNameView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_UPDATE_ROOM_NAME, self.OnChangeName)
  base.OnRemoveListener(self)
end

function UIChatChangeRoomNameView:DataDefine()
  self._isLeft = false
  self._isAnim = false
end

function UIChatChangeRoomNameView:OnClickBtnOk()
  local roomData = ChatInterface.getRoomData(self._roomId)
  if roomData == nil then
    return
  end
  local _inputStr = self._input:GetText()
  _inputStr = string.trim(_inputStr)
  if string.IsNullOrEmpty(_inputStr) or string.word_count(_inputStr) > 10 then
    UIUtil.ShowTipsId(120193)
    return
  end
  if string.startswith(_inputStr, "PRIVATE") then
    self._input:SetText("")
    UIUtil.ShowTipsId(290036)
    return
  end
  local param = {
    roomId = roomData.roomId,
    roomName = _inputStr
  }
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ROOM_CHANGE_NAME_COMMAND, param)
end

function UIChatChangeRoomNameView:InitView()
  self._txtTitle:SetLocalText(110002)
  self._txtBtnOk:SetLocalText(GameDialogDefine.CONFIRM)
  local roomName = ChatInterface.getRoomName(self._roomId)
  self._input:SetText(roomName)
end

function UIChatChangeRoomNameView:OnCreate()
  base.OnCreate(self)
  self._roomId = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIChatChangeRoomNameView:OnChangeName(roomId)
  if roomId == self._roomId then
    self.view.ctrl:CloseSelf()
    return
  end
end

return UIChatChangeRoomNameView
