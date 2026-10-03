local base = UIBaseContainer
local ChatAIAssistantEmojiItem = BaseClass("ChatAIAssistantEmojiItem", base)

function ChatAIAssistantEmojiItem:OnCreate()
  base.OnCreate(self)
  self.emojiSelectBtn = self:AddComponent(UIButton, "Select")
  self.emojiItemBtn = self:AddComponent(UIButton, "Data")
  self.emojiBg = self:AddComponent(UIImage, "Data/Bg")
  self.emojiImage = self:AddComponent(UIImage, "Data/Emoji")
  self.emojiClickCount = self:AddComponent(UIText, "Data/Text")
  self.emojiSelectEffect = self:AddComponent(UIImage, "Data/SelectEffect")
  self.emojiSelectBtn:SetOnClick(function()
    if self.theCellRoot == nil then
      return
    end
    local param = {}
    param.emoji_array = self.emoji_array
    param.alignObject = self.emojiSelectBtn
    
    function param.callback(emoji_id)
      if self.theCellRoot ~= nil and self.theCellRoot:AddNewEmoji(emoji_id) then
        self.theCellRoot:ReloadData()
      end
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatAIEmojiPopup, {anim = true}, param)
  end)
  self.emojiItemBtn:SetOnClick(function()
    self.theCellRoot:ClickExistEmoji(self.emoji_id)
    self.theCellRoot:ReloadData()
  end)
end

function ChatAIAssistantEmojiItem:SetData(theCellRoot, emoji_mine, emoji_click, emoji_data, emoji_array, emojiBgPath)
  local mine_click = false
  self.theCellRoot = theCellRoot
  self.emoji_array = emoji_array
  self.emoji_click = emoji_click
  self.emoji_data = emoji_data
  if emoji_click ~= nil then
    self.emoji_id = emoji_click.emoji_id
    self.emojiBg:LoadSprite(emojiBgPath)
    self.emojiImage:LoadSprite(emoji_data.path)
    self.emojiClickCount:SetText(tostring(emoji_click.count))
    for k, v in ipairs(emoji_mine) do
      if v == emoji_click.emoji_id then
        mine_click = true
      end
    end
  end
  self.emojiSelectEffect:SetActive(mine_click)
  self.emojiSelectBtn:SetActive(emoji_click == nil)
  self.emojiItemBtn:SetActive(emoji_click ~= nil)
end

function ChatAIAssistantEmojiItem:OnDestroy()
  self.theCellRoot = nil
  self.emojiSelectEffect = nil
  self.emojiPopupContainer = nil
  self.emojiSelectBtn = nil
  self.emojiItemBtn = nil
  self.emojiImage = nil
  self.emojiClickCount = nil
  base.OnDestroy(self)
end

return ChatAIAssistantEmojiItem
