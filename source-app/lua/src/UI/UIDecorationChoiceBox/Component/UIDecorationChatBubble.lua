local UIDecorationChatBubble = BaseClass("UIDecorationChatBubble", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "UIPlayerHead/HeadIcon",
    name = "head",
    type = UIPlayerHead
  },
  {
    path = "UIPlayerHead/Foreground",
    name = "frame",
    type = UIImage
  },
  {
    path = "bubbles",
    name = "bubbles",
    type = UIBaseContainer
  },
  {
    path = "bubbles/imgBubble1",
    name = "imgBubble1",
    type = UIImage
  },
  {
    path = "bubbles/imgBubble1",
    name = "imgBubble1LayoutElement",
    type = UILayoutElement
  },
  {
    path = "bubbles/imgBubble2",
    name = "imgBubble2",
    type = UIImage
  },
  {
    path = "bubbles/imgBubble1/txtMsg1",
    name = "txtMsg1",
    type = UIText,
    textKey = 2900050
  },
  {
    path = "bubbles/imgBubble2/txtMsg2",
    name = "txtMsg2",
    type = UIText,
    textKey = 2900051
  }
}

function UIDecorationChatBubble:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIDecorationChatBubble:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDecorationChatBubble:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDecorationChatBubble:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIDecorationChatBubble:ReInit(data)
  self.data = data
  self:RefreshView()
end

function UIDecorationChatBubble:RefreshView()
  local userPic = LuaEntry.Player:GetPic() or ""
  local userPicVer = LuaEntry.Player.picVer or 0
  self.head:SetData(LuaEntry.Player:GetUid(), userPic, userPicVer)
  if not string.IsNullOrEmpty(self.data.frame) then
    self.frame:LoadSprite(self.data.frame)
  else
    self.frame:LoadSprite(DefaultHeadFramePath)
  end
  self.imgBubble1:LoadSprite(self.data.bubbleRes)
  self.imgBubble2:LoadSprite(self.data.bubbleRes)
  self.txtMsg1:SetColor(self.data.msgColor)
  self.txtMsg2:SetColor(self.data.msgColor)
  self.txtMsg1.unity_tmpro:ForceMeshUpdate()
  self.txtMsg2.unity_tmpro:ForceMeshUpdate()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imgBubble1.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.imgBubble2.transform)
  local msg1Width = self.txtMsg1:GetSizeDelta().x + 67
  local msg2Width = self.txtMsg2:GetSizeDelta().x + 67
  local maxW = 350
  if msg1Width > maxW then
    self.imgBubble1LayoutElement:SetPreferredWidth(maxW)
  else
    self.imgBubble1LayoutElement:SetPreferredWidth(msg1Width)
  end
  self.bubbles:SetSizeDelta(Vector2.New(math.max(msg1Width, msg2Width), self.bubbles:GetSizeDelta().y))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UIDecorationChatBubble
