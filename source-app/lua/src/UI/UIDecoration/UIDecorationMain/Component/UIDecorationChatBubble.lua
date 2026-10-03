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
  self.imgBubble1Border = self:TryAddComponent(UIImage, "bubbles/imgBubble1/imgBubble1Border")
  self.imgBubble1Pic = self:TryAddComponent(UIImage, "bubbles/imgBubble1/imgBubble1Pic")
  self.imgBubble2Border = self:TryAddComponent(UIImage, "bubbles/imgBubble2/imgBubble2Border")
  self.imgBubble2Pic = self:TryAddComponent(UIImage, "bubbles/imgBubble2/imgBubble2Pic")
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
    self.frame:LoadSpriteAuto(self.data.frame)
  else
    self.frame:LoadSpriteAuto(DefaultHeadFramePath)
  end
  if self.imgBubble1Pic then
    self.imgBubble1Pic:LoadSpriteAuto(self.data.bubbleRes)
  else
    self.imgBubble1:LoadSpriteAuto(self.data.bubbleRes)
  end
  if self.imgBubble2Pic then
    self.imgBubble2Pic:LoadSpriteAuto(self.data.bubbleRes)
  else
    self.imgBubble2:LoadSpriteAuto(self.data.bubbleRes)
  end
  if self.data.bubbleResBorder then
    if self.imgBubble1Border then
      self.imgBubble1Border:LoadSpriteAuto(self.data.bubbleResBorder)
    end
    if self.imgBubble2Border then
      self.imgBubble2Border:LoadSpriteAuto(self.data.bubbleResBorder)
    end
  end
  self.txtMsg1:SetColor(self.data.msgColor)
  self.txtMsg2:SetColor(self.data.msgColor)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtMsg1.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtMsg2.transform)
  local msg1Width = self.txtMsg1:GetSizeDelta().x + 75
  local msg2Width = self.txtMsg2:GetSizeDelta().x + 75
  self.imgBubble1:SetSizeDelta(Vector2.New(msg1Width, self.imgBubble1:GetSizeDelta().y))
  self.imgBubble2:SetSizeDelta(Vector2.New(msg2Width, self.imgBubble2:GetSizeDelta().y))
  self.bubbles:SetSizeDelta(Vector2.New(math.max(msg1Width, msg2Width), self.bubbles:GetSizeDelta().y))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

return UIDecorationChatBubble
