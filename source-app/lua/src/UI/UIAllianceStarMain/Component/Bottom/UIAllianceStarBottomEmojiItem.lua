local UIAllianceStarBottomEmojiItem = BaseClass("UIAllianceStarBottomEmojiItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.img = self:AddComponent(UIImage, "")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.parentPanel then
      self.parentPanel:SetUnfold(false)
      self.parentPanel:SendAllianceStarThumbsUpNew(self.emojiIndex, self.emojiId)
    end
  end)
end

local function ComponentDestroy(self)
  self.img = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.emojiIndex = nil
  self.emojiId = nil
  self.parentPanel = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, emojiIndex, emojiId, parentPanel)
  self.emojiIndex = emojiIndex
  self.emojiId = emojiId
  self.parentPanel = parentPanel
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
  self.img:LoadSprite("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
end

UIAllianceStarBottomEmojiItem.OnCreate = OnCreate
UIAllianceStarBottomEmojiItem.OnDestroy = OnDestroy
UIAllianceStarBottomEmojiItem.OnEnable = OnEnable
UIAllianceStarBottomEmojiItem.OnDisable = OnDisable
UIAllianceStarBottomEmojiItem.ComponentDefine = ComponentDefine
UIAllianceStarBottomEmojiItem.ComponentDestroy = ComponentDestroy
UIAllianceStarBottomEmojiItem.DataDefine = DataDefine
UIAllianceStarBottomEmojiItem.DataDestroy = DataDestroy
UIAllianceStarBottomEmojiItem.OnAddListener = OnAddListener
UIAllianceStarBottomEmojiItem.OnRemoveListener = OnRemoveListener
UIAllianceStarBottomEmojiItem.Refresh = Refresh
return UIAllianceStarBottomEmojiItem
