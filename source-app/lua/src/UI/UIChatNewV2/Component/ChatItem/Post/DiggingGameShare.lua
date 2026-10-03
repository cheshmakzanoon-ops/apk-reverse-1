local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_DiggingGameShare = BaseClass("ChatItemPost_DiggingGameShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")

function ChatItemPost_DiggingGameShare:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "Bg")
  self.icon = self:AddComponent(UIRawImage, "Bg/Icon")
  self.tipText = self:AddComponent(UIText, "Bg/TipText")
  self.gotoBtn = self:AddComponent(UIButton, "Bg/GotoBtn")
  self.gotoBtnText = self:AddComponent(UIText, "Bg/GotoBtn/GotoBtnText")
  self.gotoBtnText:SetLocalText("110003")
  self.gotoBtn:SetOnClick(Bind(self, self.OnGotoBtnClick))
  self.bgGotoBtn = self:AddComponent(UIButton, "Bg")
  self.bgGotoBtn:SetOnClick(Bind(self, self.OnGotoBtnClick))
end

function ChatItemPost_DiggingGameShare:OnGotoBtnClick()
  if not self.attachInfo or not self.attachInfo.uuid then
    return
  end
  DataCenter.DiggingDataManager:OpenDiggingMap(self.attachInfo.uuid, self.attachInfo.uid, SeasonDigGameType.Single)
end

function ChatItemPost_DiggingGameShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_DiggingGameShare:OnLoaded()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  if chatData.post ~= PostType.DiggingGameShareSingle then
    Logger.LogError("chatUpdateItem error ----------- > roomId : " .. chatData.roomId .. "seqId : " .. chatData.seqId)
    return
  end
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self.roomId = chatData.roomId
  self.attachInfo = chatData:getMessageParam(false)
  if not self.attachInfo then
    return
  end
  if self._chatData:isMyChat() then
    self.bg:LoadSprite(string.format(LoadPath.LWChatFolder, "zyf_liaotian_kuang2"))
    self.gotoBtn:SetActive(false)
    self.tipText:SetSizeDeltaXY(400, 100)
  else
    self.bg:LoadSprite(string.format(LoadPath.LWChat2Folder, "zyf_liaotian_kuang1"))
    self.gotoBtn:SetActive(true)
    self.tipText:SetSizeDeltaXY(250, 100)
  end
  self.tipText:SetLocalText(self.attachInfo.tipText or "")
end

function ChatItemPost_DiggingGameShare:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_DiggingGameShare:ComponentDestroy()
  self.bg = nil
  self.icon = nil
  self.tipText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
end

function ChatItemPost_DiggingGameShare:DataDestroy()
  self.attachInfo = nil
end

function ChatItemPost_DiggingGameShare:OnRecycle()
end

function ChatItemPost_DiggingGameShare:HandleClick()
  return true
end

return ChatItemPost_DiggingGameShare
