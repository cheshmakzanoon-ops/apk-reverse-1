local UIChatEmojiItem = BaseClass("UIChatEmojiItem", UIBaseContainer)
local base = UIBaseContainer

function UIChatEmojiItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIChatEmojiItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIChatEmojiItem:OnEnable()
  base.OnEnable(self)
end

function UIChatEmojiItem:OnDisable()
  base.OnDisable(self)
end

function UIChatEmojiItem:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "Image")
  self.btn:SetOnClick(function()
    self:DoSendEmoji()
  end)
  self.btnImg = self:AddComponent(UIImage, "Image")
end

function UIChatEmojiItem:ComponentDestroy()
end

function UIChatEmojiItem:DataDefine()
end

function UIChatEmojiItem:DataDestroy()
end

function UIChatEmojiItem:DoSendEmoji()
  local msg = "<lwEmoji:" .. self.param.id .. ":>"
  EventManager:GetInstance():Broadcast(ChatEventEnum.LF_OnSendClick, {text = msg, clear = false})
end

function UIChatEmojiItem:SetData(params)
  self.param = params
  self.btnImg:LoadSprite(params.path)
end

return UIChatEmojiItem
