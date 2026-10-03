local UIAllianceStarMainThumbItem = BaseClass("UIAllianceStarMainThumbItem", UIBaseContainer)
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
  self.imgEmoji = self:AddComponent(UIImage, "EmojiImg")
  self.textNum = self:AddComponent(UITextMeshProUGUIEx, "NumText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgSelf = self:AddComponent(UIImage, "SelfImg")
  self.imgSelf:SetActive(false)
end

local function ComponentDestroy(self)
  self.imgEmoji = nil
  self.textNum = nil
  self.btn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.targetUid = nil
  self.configId = nil
  self.thumbIndex = nil
  self.isSelf = nil
  self.emojiId = nil
  self.closeThumb = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnClick(self)
  if self.configId and self.targetUid and self.thumbIndex and not self.closeThumb then
    SFSNetwork.SendMessage(MsgDefines.AllianceStarThumbsUpNew, self.configId, self.targetUid, self.thumbIndex, self.isSelf and -1 or 1)
    if not self.isSelf then
      self.view:ShowEmojiBubbleByEmojiId(self.emojiId, true)
    end
  else
    UIUtil.ShowTipsId("alliance_weeklyStar_book_noEdit")
  end
end

local function Refresh(self, thumbIndex, thumbNum, selfThumbs, uid, configId, closeThumb)
  self.targetUid = uid
  self.configId = configId
  self.thumbIndex = thumbIndex
  self.closeThumb = closeThumb
  self.isSelf = false
  if selfThumbs then
    self.isSelf = table.hasvalue(selfThumbs, self.thumbIndex)
  end
  self.imgSelf:SetActive(self.isSelf)
  self.textNum:SetText(thumbNum)
  local emojiSetting = DataCenter.AllianceStarManager:GetEmojiSetting()
  local emojiId = emojiSetting.emojiList[thumbIndex]
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
  self.emojiId = emojiId
  self.imgEmoji:LoadSprite("Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. line.path .. ".png")
end

UIAllianceStarMainThumbItem.OnCreate = OnCreate
UIAllianceStarMainThumbItem.OnDestroy = OnDestroy
UIAllianceStarMainThumbItem.OnEnable = OnEnable
UIAllianceStarMainThumbItem.OnDisable = OnDisable
UIAllianceStarMainThumbItem.ComponentDefine = ComponentDefine
UIAllianceStarMainThumbItem.ComponentDestroy = ComponentDestroy
UIAllianceStarMainThumbItem.DataDefine = DataDefine
UIAllianceStarMainThumbItem.DataDestroy = DataDestroy
UIAllianceStarMainThumbItem.OnAddListener = OnAddListener
UIAllianceStarMainThumbItem.OnRemoveListener = OnRemoveListener
UIAllianceStarMainThumbItem.OnBtnClick = OnBtnClick
UIAllianceStarMainThumbItem.Refresh = Refresh
return UIAllianceStarMainThumbItem
