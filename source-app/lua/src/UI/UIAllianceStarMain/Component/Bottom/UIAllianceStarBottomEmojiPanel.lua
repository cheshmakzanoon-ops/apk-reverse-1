local UIAllianceStarBottomEmojiPanel = BaseClass("UIAllianceStarBottomEmojiPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceStarBottomEmojiItem = require("UI.UIAllianceStarMain.Component.Bottom.UIAllianceStarBottomEmojiItem")

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
  self:SetUnfold(true)
  self:CheckAddFinger()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btnEmoji = self:AddComponent(UIButton, "EmojiPanel/EmojiBtn")
  self.btnEmoji:SetOnClick(function()
    self:OnBtnEmojiClick()
  end)
  self.imgEmojiBtnBg = self:AddComponent(UIImage, "EmojiPanel/EmojiBtn/EmojiBtnBg")
  self.emojiListPanel = self:AddComponent(UIBaseContainer, "EmojiPanel/ListPanel/emoji_content")
  self.imgEmoji1 = self:AddComponent(UIImage, "EmojiPanel/ListPanel/emoji_content/Emoji1")
  self.emojiPool = self.transform:Find("EmojiPanel/ListPanel/emoji_content/Emoji1").gameObject
  self.emojiPool:SetActive(false)
  self.emojiPool:GameObjectCreatePool()
  self.simpleAnim = self:AddComponent(UISimpleAnimation, "")
  self.emojiCanvasGroup = self:AddComponent(UICanvasGroup, "EmojiPanel/ListPanel/emoji_content")
end

local function ComponentDestroy(self)
  self.emojiListPanel:RemoveComponents(UIAllianceStarBottomEmojiItem)
  self.emojiPool:GameObjectRecycleAll()
  self.emojiPool = nil
  self.btnEmoji = nil
  self.imgEmojiBtnBg = nil
  self.emojiListPanel = nil
  self.imgEmoji1 = nil
  self.simpleAnim = nil
  self.emojiCanvasGroup = nil
end

local function DataDefine(self)
  self.emojiItems = {}
  self.unfold = false
  self:InitEmojiList()
end

local function DataDestroy(self)
  self.emojiItems = nil
  self.unfold = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnEmojiClick(self)
  self:SetUnfold(not self.unfold)
end

local function InitEmojiList(self)
  local emojiSetting = DataCenter.AllianceStarManager:GetEmojiSetting()
  local emojiCount = 0
  if emojiSetting then
    local emojiList = emojiSetting.emojiList
    emojiCount = #emojiList
    for i = 1, emojiCount do
      local emojiItem = self.emojiItems[i]
      if emojiItem == nil then
        local obj = self.emojiPool:GameObjectSpawn(self.emojiListPanel.transform)
        obj.name = "emojiItem" .. i
        emojiItem = self.emojiListPanel:AddComponent(UIAllianceStarBottomEmojiItem, obj.name)
        self.emojiItems[i] = emojiItem
      end
      emojiItem:SetActive(true)
      emojiItem:Refresh(i, emojiList[i], self)
    end
  end
  for i = emojiCount + 1, #self.emojiItems do
    self.emojiItems[i]:SetActive(false)
  end
end

local function SetUnfold(self, unfold)
  if unfold then
    self.imgEmojiBtnBg:SetActive(false)
    self.simpleAnim:Play("open")
    self.emojiCanvasGroup:SetInteractable(true)
  else
    self.imgEmojiBtnBg:SetActive(true)
    self.simpleAnim:Play("close")
    self.emojiCanvasGroup:SetInteractable(false)
  end
  self.unfold = unfold
end

local function Refresh(self, param)
  self.configId = param.configId
  self.targetUid = param.targetUid
end

local function SendAllianceStarThumbsUpNew(self, thumbIndex, emojiId)
  local isSelf = false
  local thumbInfo = DataCenter.AllianceStarManager:GetThumbInfo(self.configId, self.targetUid)
  if thumbInfo and thumbInfo.selfThumbs then
    isSelf = table.hasvalue(thumbInfo.selfThumbs, thumbIndex)
  end
  if self.configId and self.targetUid then
    SFSNetwork.SendMessage(MsgDefines.AllianceStarThumbsUpNew, self.configId, self.targetUid, thumbIndex, isSelf and -1 or 1)
    if not isSelf then
      self.view:ShowEmojiBubbleByEmojiId(emojiId, true)
    end
  end
end

function UIAllianceStarBottomEmojiPanel:CheckAddFinger()
  TimerManager:GetInstance():DelayInvoke(function()
    if self.emojiItems and self.emojiItems[1] and DataCenter.AllianceStarManager:GetShowEmojiFinger() then
      local param = {}
      param.positionType = PositionType.Screen
      param.position = self.emojiItems[1].transform.position + Vector3.New(50, -50, 0)
      param.isAutoClose = 2
      DataCenter.ArrowManager:ShowFingerArrow(param)
      DataCenter.AllianceStarManager:SaveShowEmojiFinger()
    end
  end, 0.1)
end

UIAllianceStarBottomEmojiPanel.OnCreate = OnCreate
UIAllianceStarBottomEmojiPanel.OnDestroy = OnDestroy
UIAllianceStarBottomEmojiPanel.OnEnable = OnEnable
UIAllianceStarBottomEmojiPanel.OnDisable = OnDisable
UIAllianceStarBottomEmojiPanel.ComponentDefine = ComponentDefine
UIAllianceStarBottomEmojiPanel.ComponentDestroy = ComponentDestroy
UIAllianceStarBottomEmojiPanel.DataDefine = DataDefine
UIAllianceStarBottomEmojiPanel.DataDestroy = DataDestroy
UIAllianceStarBottomEmojiPanel.OnAddListener = OnAddListener
UIAllianceStarBottomEmojiPanel.OnRemoveListener = OnRemoveListener
UIAllianceStarBottomEmojiPanel.OnBtnEmojiClick = OnBtnEmojiClick
UIAllianceStarBottomEmojiPanel.InitEmojiList = InitEmojiList
UIAllianceStarBottomEmojiPanel.SetUnfold = SetUnfold
UIAllianceStarBottomEmojiPanel.Refresh = Refresh
UIAllianceStarBottomEmojiPanel.SendAllianceStarThumbsUpNew = SendAllianceStarThumbsUpNew
return UIAllianceStarBottomEmojiPanel
