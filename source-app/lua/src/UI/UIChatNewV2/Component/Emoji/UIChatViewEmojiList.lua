local base = UIBaseContainer
local UIChatViewEmojiList = BaseClass("UIChatViewEmojiList", base)
local UIChatViewEmojiItem = require("UI.UIChatNewV2.Component.Emoji.UIChatViewEmojiItem")

function UIChatViewEmojiList:OnCreate()
  base.OnCreate(self)
  self.parent = nil
  self:ComponentDefine()
end

function UIChatViewEmojiList:OnDestroy()
  self.emojiItem:GameObjectRecycleAll()
  self:ComponentDestroy()
  self.parent = nil
  base.OnDestroy(self)
end

function UIChatViewEmojiList:ComponentDefine()
  self.emojiItem = self.transform:Find("emojiItem").gameObject
  self.emojiItem:GameObjectCreatePool()
end

function UIChatViewEmojiList:ReInit(emojiData, parent)
  local maxCount = 7
  self.parent = parent
  self.emojiItem:GameObjectRecycleAll()
  if not emojiData or not emojiData.list then
    return
  end
  local item
  for i = 1, maxCount do
    if not emojiData.list[i] then
      return
    end
    item = self.emojiItem:GameObjectSpawn(self.transform)
    NameCount = NameCount + 1
    item.name = NameCount
    item:SetActive(true)
    local obj = self:AddComponent(UIChatViewEmojiItem, item.name)
    obj:ReInit(emojiData.list[i], self.parent.mobilInputId)
  end
end

function UIChatViewEmojiList:ComponentDestroy()
end

function UIChatViewEmojiList:UpdateItems()
end

return UIChatViewEmojiList
