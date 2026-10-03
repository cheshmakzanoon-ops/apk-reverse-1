local qnmanager = require("DataCenter.QuestionnaireManager.QNManager")
local UILWChangeRemarkNameView = BaseClass("UILWChangeRemarkNameView", UIBaseView)
local UILWSettingItem = require("UI.LWPlayerInfo.UILWPlayerRemarkName.UILWChangeRemarkName.Component.UILWSettingItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PRIVATE_CHAT_STICKY_LIST = "PRIVATE_CHAT_STICKY_LIST"
local posY = 230
local compBook = {
  {
    path = "PopUpTitle/BtnClose",
    name = "BtnClose",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClose()
    end
  },
  {
    path = "PopUpTitle/Content/NameNode/BtnCopy",
    name = "BtnCopy",
    type = UIButton,
    onClick = function(self)
      self:OnBtnCopy()
    end
  },
  {
    path = "PopUpTitle/Content/RemarksName/BtnModify",
    name = "BtnModify",
    type = UIButton,
    onClick = function(self)
      self:OnBtnModify()
    end
  },
  {
    path = "panel",
    name = "panelBtn",
    type = UIButton,
    onClick = function(self)
      self:OnBtnClose()
    end
  },
  {
    path = "PopUpTitle/Content/NameNode/Bg/Text",
    name = "TextPlayerName",
    type = UITextMeshProUGUIEx
  },
  {
    path = "PopUpTitle/Content/RemarksName/numText",
    name = "TextRemarkCharNum",
    type = UITextMeshProUGUIEx
  },
  {
    path = "PopUpTitle/Content/RemarksName/warnText",
    name = "TextWarm",
    type = UITextMeshProUGUIEx
  },
  {
    path = "PopUpTitle/Content/RemarksName/InputFieldBg/InputField",
    name = "InputFieldRemark",
    type = UIInput
  },
  {
    path = "PopUpTitle/Btns",
    name = "btnsCom",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle/bg",
    name = "bg",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle/bgWhite",
    name = "bgWhite",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle",
    name = "root",
    type = UIBaseContainer
  }
}

function UILWChangeRemarkNameView:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.btnItem = self.transform:Find("PopUpTitle/Btns/btnItem").gameObject
  self.btnItem:GameObjectCreatePool()
  self:InitData()
  self:RefreshView()
end

function UILWChangeRemarkNameView:OnDestroy()
  self:SaveSetting()
  self.btnsCom:RemoveComponents(UILWSettingItem)
  self.btnItem:GameObjectRecycleAll()
  self:ClearCompsByBook(compBook)
  self.playerUid = nil
  self.playerName = nil
  self.originalRemarkName = nil
  self.inputValue = nil
  self.itemList = nil
  self.canChangeName = false
  base.OnDestroy(self)
end

function UILWChangeRemarkNameView:SaveSetting()
  for i = 1, #self.itemList do
    if self.itemList[i].data.isOn ~= self.itemList[i].data.newIsOn then
      self:SaveSettingByType(self.itemList[i].data.type, self.itemList[i].data.newIsOn)
    end
  end
end

function UILWChangeRemarkNameView:SaveSettingByType(type, isOn)
  isOn = isOn or false
  if type == PlayerDetailBottomBtnType.Notify then
    SFSNetwork.SendMessage(MsgDefines.LWUserPushChatSettings, self.playerUid, isOn and 1 or 0)
  elseif type == PlayerDetailBottomBtnType.Sticky then
    self:SaveSticky(isOn)
  elseif type == PlayerDetailBottomBtnType.Block then
    if isOn then
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_BLOCK_COMMAND, self.playerUid)
    else
      local list = ChatManager2:GetInstance().Restrict:GetShieldInfoList()
      local userData
      if list then
        for i, data in pairs(list) do
          if data.uid == self.playerUid then
            userData = data
          end
        end
      end
      if userData then
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_UNBLOCK_COMMAND, userData.uuid)
      end
    end
  end
end

function UILWChangeRemarkNameView:OnAddListener()
  self:AddUIListener(EventId.RemarkNameChangedUpdate, self.OnCheckNameBack)
  self.InputFieldRemark:SetOnValueChange(function(value)
    self:InputFieldOnValueChange(value)
  end)
end

function UILWChangeRemarkNameView:OnRemoveListener()
  self:RemoveUIListener(EventId.RemarkNameChangedUpdate, self.OnCheckNameBack)
end

function UILWChangeRemarkNameView:InitData()
  self.playerUid, self.playerName = self:GetUserData()
  self.originalRemarkName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.playerUid, "")
  self.settingConfig = self.ctrl:GetSettingConfig(self.playerUid)
  self.stickyList = CommonUtil.PlayerPrefsGetTable(PRIVATE_CHAT_STICKY_LIST, {})
  self.inputValue = self.originalRemarkName
  self.canChangeName = false
end

function UILWChangeRemarkNameView:SaveSticky(state)
  if self.playerUid == nil then
    return
  end
  local isFull = table.count(self.stickyList) >= STICKY_MAX_COUNT
  if state == true and self.stickyList[tostring(self.playerUid)] == nil and isFull then
    UIUtil.ShowTipsId("convo_top_set_notice")
    return
  end
  if state then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.stickyList[tostring(self.playerUid)] = curTime
  else
    self.stickyList[tostring(self.playerUid)] = nil
  end
  local isPinned = self.stickyList[tostring(self.playerUid)] ~= nil
  ChatInterface.getRoomMgr():RoomTop(self.playerUid, ChatGroupType.GROUP_CUSTOM, isPinned)
  if self.playerUid and isPinned then
    local roomId = ChatInterface.GetUtil().GeneratePrivateRoomId(self.playerUid)
    if not ChatManager2:GetInstance().Room:GetRoomData(roomId) then
      local template = "{\"members\":\"%s\",\"name\":\"%s\",\"roomId\":\"%s\"}"
      local name = string.format("PRIVATE_%s_STICKY_%s", LuaEntry.Player.uid, self.playerUid)
      local members = string.format("%s|%s", LuaEntry.Player.uid, self.playerUid)
      ChatManager2:GetInstance().Room:OnGetCustomRoomList({
        string.format(template, members, name, roomId)
      })
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {roomId})
    end
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_PRIVATE_ROOMLAST_UPDATE, true)
  end
end

function UILWChangeRemarkNameView:RefreshView()
  self.InputFieldRemark:SetText(self.originalRemarkName)
  self:InputFieldOnValueChange(self.originalRemarkName)
  self.TextPlayerName:SetText(self.playerName)
  self.itemList = {}
  self.btnsCom:SetActive(true)
  self.bgWhite:SetSizeDeltaXY(self.bgWhite:GetSizeDelta().x, 830)
  self.bg:SetSizeDeltaXY(self.bg:GetSizeDelta().x, 1000)
  self.root:SetAnchoredPositionXY(0, posY)
  if self.settingConfig then
    local item
    for i = 1, #self.settingConfig do
      item = self.btnItem:GameObjectSpawn(self.btnsCom.transform)
      item.name = self.settingConfig[i].name .. i
      item:SetActive(true)
      item = self.btnsCom:AddComponent(UILWSettingItem, item.name)
      item:ReInit(self.settingConfig[i])
      table.insert(self.itemList, item)
    end
  end
end

function UILWChangeRemarkNameView:OnCheckNameBack(type)
  if type == CheckNameType.None then
    self.view.ctrl:CloseSelf()
  else
    self:CheckNameChangeState(type)
  end
end

function UILWChangeRemarkNameView:RefreshNameChatNum()
  local charNumStr = ""
  if self.inputValue ~= "" then
    charNumStr = #self.inputValue .. "/" .. MAX_AL_NAME_CHAR
  end
  self.TextRemarkCharNum:SetText(charNumStr)
end

function UILWChangeRemarkNameView:CheckNameChangeState(type)
  self.canChangeName = type ~= CheckNameType.MinNameChar and type ~= CheckNameType.MaxNameChar and type ~= CheckNameType.IllegalChar and type ~= CheckNameType.SensitiveWords and type ~= CheckNameType.Unchanged
  if self.inputValue == "" then
    self.canChangeName = DataCenter.PlayerInfoDataManager:IsPlayerRemarked(self.playerUid)
    self.TextWarm:SetText("")
  elseif type == CheckNameType.None then
    self.TextWarm:SetText("")
  elseif type == CheckNameType.MinNameChar or type == CheckNameType.MaxNameChar then
    self.TextWarm:SetLocalText(120193)
  elseif type == CheckNameType.IllegalChar then
    self.TextWarm:SetLocalText(129082)
  elseif type == CheckNameType.SensitiveWords then
    self.TextWarm:SetLocalText(280073)
  else
    self.TextWarm:SetText("")
  end
  CS.UIGray.SetGray(self.BtnModify.transform, not self.canChangeName, self.canChangeName)
end

function UILWChangeRemarkNameView:InputFieldOnValueChange(value)
  self.inputValue = value
  self:RefreshNameChatNum()
  local state = self.ctrl:CheckName(self.inputValue, self.originalRemarkName) or CheckNameType.None
  self:CheckNameChangeState(state)
end

function UILWChangeRemarkNameView:OnBtnClose()
  self.view.ctrl:CloseSelf()
end

function UILWChangeRemarkNameView:OnBtnCopy()
  CommonUtil.CopyTextToClipboard(self.playerName)
  UIUtil.ShowTipsId(128031)
end

function UILWChangeRemarkNameView:OnBtnModify()
  if not DataCenter.PlayerInfoDataManager:IsPlayerRemarked(self.playerUid) and DataCenter.PlayerInfoDataManager:IsReachRemarkLimit() then
    UIUtil.ShowTipsId("remark_limit_notice")
    return
  end
  UIUtil.ShowMessage(Localization:GetString("remark_change_notice"), 2, "btn_save", GameDialogDefine.CANCEL, function()
    self.ctrl:SendChangeNameMessage(self.playerUid, self.inputValue)
  end)
end

return UILWChangeRemarkNameView
