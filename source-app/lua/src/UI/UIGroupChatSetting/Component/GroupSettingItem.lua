local base = UIBaseContainer
local GroupSettingItem = BaseClass("GroupSettingItem", UIBaseContainer)
local UIPushSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local Localization = CS.GameEntry.Localization

function GroupSettingItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GroupSettingItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GroupSettingItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "Btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnSlider = self:AddComponent(UIPushSettingsSlider, "slider")
  self.btnSlider:Switch(false)
  
  function self.btnSlider.onSwitch(isOn)
    self:OnSliderSwitched(isOn)
  end
  
  self.compInputCom = self:AddComponent(UIBaseComponent, "inputCom")
  self.exitCom = self:AddComponent(UIBaseComponent, "exitRoot")
  self.input = self:AddComponent(UIInput, "inputCom/InputField")
  self.input:SetOnValueChange(function(value)
    self:IptOnValueChange(value)
  end)
  self.line = self:AddComponent(UIBaseComponent, "line")
  self.input:SetOnEndEdit(function(value)
    self:OnInputEnd(value)
  end)
  self.exitBtn = self:AddComponent(UIButton, "exitRoot/clickBtn")
  self.exitBtn:SetOnClick(function()
    self:OnExitBtnClick()
  end)
  self.exitImg = self:AddComponent(UIImage, "exitRoot/clickBtn")
  self.exitText = self:AddComponent(UIText, "exitRoot/clickBtn/name")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Text")
  self.operationList = {
    self.btn,
    self.btnSlider,
    self.compInputCom,
    self.exitCom
  }
end

function GroupSettingItem:OnSliderSwitched(isOn)
  self.isOn = isOn
  self.view:OnSliderSwitched(self.isOn, self.config.type)
end

function GroupSettingItem:OnExitBtnClick()
  local count = self.content.room and self.content.room.memberList and #self.content.room.memberList or 0
  if 1 < count and self.content.room.owner == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("group_leave_tips1")
    return
  end
  UIUtil.ShowMessage(Localization:GetString("group_leave_tips2"), 2, "btn_cancel", "btn_leave", function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageTip, {anim = false, playEffect = false})
  end, function()
    ChatManager2:GetInstance().Room:RoomTop(self.content.room.roomId, self.content.room.group, false)
    ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomQuit, self.content.room.roomId, self.content.room.group)
    self.view.ctrl:CloseSelf()
  end)
end

function GroupSettingItem:OnInputEnd(value)
  self:IptOnValueChange(value)
  local name = self.input:GetText()
  if not string.IsNullOrEmpty(name) and name ~= self.content.room.name then
    local param = {
      tipText = Localization:GetString("group_name_tips"),
      btnNum = 2,
      text1 = "110006",
      text2 = "btn_cancel",
      sureAction = function()
        ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.ChatRoomModifyName, self.content.room.roomId, value, self.content.room.group)
      end,
      cancelAction = function()
        self.input:SetText(self.content.room.name)
      end,
      showToggle = false
    }
    UIUtil.ShowSecondMessageByParam(param)
  else
    self.input:SetText(self.content.room.name)
  end
end

function GroupSettingItem:IptOnValueChange(value)
  self.inputValue = value
  if value == nil or value ~= "" then
  else
  end
end

function GroupSettingItem:ComponentDestroy()
  self.btn = nil
  self.btnSlider = nil
  self.compInputCom = nil
  self.text = nil
end

function GroupSettingItem:DataDefine()
end

function GroupSettingItem:DataDestroy()
end

function GroupSettingItem:UpdateItem(config)
  self.config = config
  self.text:SetActive(true)
  self.text:SetLocalText(self.config.lanageKey)
  self.line:SetActive(true)
  local operation
  if self.config.type == GroupChatSettingType.MakeOver or self.config.type == GroupChatSettingType.Report then
    operation = self.btn
  elseif self.config.type == GroupChatSettingType.push then
    operation = self.btnSlider
    self.isOn = DataCenter.PushSettingsManager:GetGroupChatPushSetting(self.view.room.roomId)
    self.btnSlider:Switch(self.isOn)
  elseif self.config.type == GroupChatSettingType.ReName then
    operation = self.compInputCom
    self.input:SetText(self.content.room.name)
  elseif self.config.type == GroupChatSettingType.Exit then
    operation = self.exitCom
    self.exitText:SetLocalText(self.config.lanageKey)
    self.text:SetActive(false)
    self.exitText:SetColor(ChatUIThemeConfig.GroupChatExitNameColor[ChatInterface.GetChatTheme()])
    self.exitImg:SetColor(ChatUIThemeConfig.GroupChatExitImgColor[ChatInterface.GetChatTheme()])
    self.line:SetActive(false)
  elseif self.config.type == GroupChatSettingType.RoomTop then
    operation = self.btnSlider
    self.isOn = ChatInterface.getRoomMgr():GetRoomIsTop(self.view.room.roomId, ChatGroupType.GROUP_CUSTOM_GROUP)
    self.btnSlider:Switch(self.isOn)
  elseif self.config.type == GroupChatSettingType.IsMuted then
    self.isOn = ChatInterface.getGroupChatMgr():GetIsNotDisturbingRoom(self.view.room.roomId)
    self.btnSlider:Switch(self.isOn)
    operation = self.btnSlider
  end
  if operation then
    self:RefreshBtn(operation)
  end
end

function GroupSettingItem:RefreshBtn(operation)
  for i = 1, #self.operationList do
    self.operationList[i]:SetActive(false)
  end
  operation:SetActive(true)
end

function GroupSettingItem:SetContentViewScript(content)
  self.content = content
end

function GroupSettingItem:OnAddListener()
  base.OnAddListener(self)
end

function GroupSettingItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GroupSettingItem:OnBtnClick()
  if self.config.type == GroupChatSettingType.MakeOver then
    local param = {
      openType = GroupMemberOpenType.GroupMembersMakeOver,
      roomId = self.content.room.roomId
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatGroupSelectMember, {anim = true}, param)
  elseif self.config.type == GroupChatSettingType.Report then
    local param = {
      type = ReportType.GroupChat,
      roomData = self.content.room
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, param)
  end
end

return GroupSettingItem
