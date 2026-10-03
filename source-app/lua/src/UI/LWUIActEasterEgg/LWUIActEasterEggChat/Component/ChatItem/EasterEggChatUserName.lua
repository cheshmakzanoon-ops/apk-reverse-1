local EasterEggChatUserName = BaseClass("EasterEggChatUserName", UIBaseContainer)
local M = EasterEggChatUserName
local base = UIBaseContainer
local ChatMessageHelper = require("Chat.Other.ChatMessageHelper")
local logger = require("Framework.Logger.Logger")
local compBook = {
  {
    path = "Line",
    name = "layout",
    type = nil
  },
  {
    path = "Line/Gender",
    name = "nodeGender",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Gender/Man",
    name = "iconMale",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Gender/Woman",
    name = "iconFemale",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Answer",
    name = "nodeAnswer",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Answer/Answer_A",
    name = "iconAnswer_A",
    type = UIGameObjectWrap
  },
  {
    path = "Line/Answer/Answer_B",
    name = "iconAnswer_B",
    type = UIGameObjectWrap
  },
  {
    path = "Line/NameText",
    name = "txtUserName",
    type = UIText
  }
}

function M:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.uid = nil
  self.chatData = nil
  self.alignToRight = false
  self.isShowGender = false
  self.nameColor = Color32.New(0.3176470588235294, 0.3176470588235294, 0.3176470588235294, 1)
end

function M:OnDestroy()
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
  self.chatData = nil
  self.uid = nil
  self.isShowGender = false
  self.nameColor = nil
end

function M:OnAddListener()
  self:AddUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnChatUserInfoUpdate)
end

function M:UpdateLayout()
  if self.layout then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
  end
end

function M:OnChatUserInfoUpdate(uid)
  if self.uid and self.uid == uid and self.chatData then
    local userInfo = ChatInterface.getUserData(uid)
    if userInfo then
      self:UpdateName(userInfo, self.chatData)
    end
  end
end

function M:UpdateName(userInfo, chatData)
  if userInfo == nil then
    self.txtUserName:SetText("")
    return
  end
  self.chatData = chatData
  self.uid = userInfo.uid
  local anonymousData = chatData.extra
  if anonymousData == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\230\178\161\230\156\137extra")
    return
  end
  self.txtUserName.unity_tmpro.enableVertexGradient = false
  self.txtUserName.unity_tmpro.outlineWidth = 0
  self.txtUserName:SetColor(self.nameColor)
  if anonymousData.anonymousHead == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148chatData\231\154\132extra \228\184\173\230\178\161\230\156\137 anonymousHead")
    return
  end
  local curAnonymousInfo = string.split(anonymousData.anonymousHead, ";")
  local isAnonymous = tonumber(curAnonymousInfo[3]) == 0
  if isAnonymous then
    local name
    if self.uid == LuaEntry.Player.uid then
      local activityData = DataCenter.ActEasterEggManager:GetActivityData()
      name = activityData.anonymousName
    else
      local lastestAnonymousHead = userInfo.curAnonymousHead or anonymousData.anonymousHead
      curAnonymousInfo = string.split(lastestAnonymousHead, ";")
      name = curAnonymousInfo[1]
    end
    local showName = DataCenter.ActEasterEggManager:GetTranslateName(name)
    self.txtUserName:SetText(showName)
  else
    local senderName = chatData:getSenderNameWithAlliance()
    self:ComposeName(senderName, userInfo)
  end
  self:UpdateAnswer(tonumber(anonymousData.answer) or 0)
  self:UpdateGender(userInfo)
  self:UpdateLayout()
  TimerManager:GetInstance():GetTimer(1, function()
    self:UpdateLayout()
  end, self, true, true):Start()
end

function M:ComposeName(senderName, userInfo)
  if not self.isShowGender and not self.isShowGover then
    senderName = " " .. senderName
  end
  self.txtUserName:SetText(senderName)
end

function M:UpdateGender(userInfo)
  if not self.nodeGender then
    self.isShowGender = false
    return
  end
  if not (userInfo ~= nil and userInfo.gender) or userInfo.gender == 0 or userInfo.gender == 3 then
    self.nodeGender:SetActive(false)
    self.isShowGender = false
    return
  end
  self.nodeGender:SetActive(true)
  self.isShowGender = true
  local isMan = userInfo.gender == 1
  self.iconMale:SetActive(isMan)
  self.iconFemale:SetActive(not isMan)
end

function M:UpdateAnswer(answer)
  self.nodeAnswer:SetActive(answer ~= 0)
  self.iconAnswer_A:SetActive(answer == 1)
  self.iconAnswer_B:SetActive(answer == 2)
end

return EasterEggChatUserName
