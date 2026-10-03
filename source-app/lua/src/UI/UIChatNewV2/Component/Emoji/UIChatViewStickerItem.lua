local base = UIBaseContainer
local UIChatViewStickerItem = BaseClass("UIChatViewStickerItem", base)
local compBook = {
  {
    path = "Sticker",
    name = "stickerBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCLick()
    end
  },
  {
    path = "Sticker",
    name = "stickerImg",
    type = UIImage
  },
  {
    path = "Sticker/expireTime",
    name = "expireTime",
    type = UIImage
  },
  {
    path = "Sticker/expireTimeTxtContent/expireTimeTxt",
    name = "expireTimeTxt",
    type = UIText
  },
  {
    path = "Sticker/expireTimeTxtContent",
    name = "expireTimeTxtContent",
    type = UIBaseContainer
  }
}

function UIChatViewStickerItem:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.stickerBtn.unity_uibutton.onClick:RemoveAllListeners()
  self.stickerBtn:SetOnClick(function()
    DataCenter.ChatEmojiTemplateManager:TrySendSticker(self.SendMessage, self)
  end)
end

function UIChatViewStickerItem:OnDestroy()
  self:ClearCompsByBook(compBook)
  base.OnDestroy(self)
end

function UIChatViewStickerItem:ReInit(rowCfg)
  self.rowCfg = rowCfg
  self.expirTime = DataCenter.ChatEmojiTemplateManager:TryGetStickerExpiredTime(rowCfg.id)
  local path = string.format(ChatStickerCoverPath, rowCfg.name)
  self.stickerImg:LoadSprite(path)
  self.expireTime:SetActive(self.expirTime ~= nil)
  self.expireTimeTxtContent:SetActive(self.expirTime ~= nil)
  self:Update1000MS()
end

function UIChatViewStickerItem:SendMessage()
  if self.rowCfg.id == 5 then
    local num = math.random(1, 6)
    self.view.ctrl:SendMessage("<lwSticker:" .. self.rowCfg.id .. ":" .. num .. ":>", 0, PostType.Chat_Stickers)
  else
    self.view.ctrl:SendMessage("<lwSticker:" .. self.rowCfg.id .. ":>", 0, PostType.Chat_Stickers)
  end
  PostEventLog.Track(PostEventLog.Defines.c_sticker_chat, {
    c_sticker_chat_id = self.rowCfg.id
  })
  if self.view and self.view.middle and self.view.middle.scrollMsgs then
    self.view.middle.scrollMsgs:ScrollToTail()
  end
end

function UIChatViewStickerItem:Update1000MS()
  if self.expirTime == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local leftTime = self.expirTime - curTime
  if leftTime <= 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():SecondToFmtString(leftTime)
  self.expireTimeTxt:SetText(countDownTimeStr)
end

return UIChatViewStickerItem
