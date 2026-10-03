local UIAllianceStarMainBubblePanel = BaseClass("UIAllianceStarMainBubblePanel", UIBaseContainer)
local UIAllianceStarMainBubble = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainBubble")
local Regex = CS.System.Text.RegularExpressions.Regex
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
  self:RandomEmoji()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bubble = self:AddComponent(UIAllianceStarMainBubble, "Bubble")
  self.bubblePool = self.bubble.gameObject
  self.bubblePool:GameObjectCreatePool()
  self.compereBubble = self:AddComponent(UIBaseContainer, "CompereBubble")
  self.compereBubbleBg1 = self:AddComponent(UIBaseContainer, "CompereBubble/Bg1")
  self.compereBubbleBg2 = self:AddComponent(UIBaseContainer, "CompereBubble/Bg2")
  self.compereBubbleText1 = self:AddComponent(UIText, "CompereBubble/Bg1/CompereBubbleText1")
  self.compereBubbleText2 = self:AddComponent(UIText, "CompereBubble/Bg2/CompereBubbleText2")
  self.bubble:SetActive(false)
  self.compereBubble:SetActive(false)
end

local function ComponentDestroy(self)
  self:RemoveComponents(UIAllianceStarMainBubble)
  self.bubblePool:GameObjectRecycleAll()
  self.bubble = nil
  self.bubblePool = nil
  self.compereBubble = nil
  self.compereBubbleBg1 = nil
  self.compereBubbleBg2 = nil
  self.compereBubbleText1 = nil
  self.compereBubbleText2 = nil
end

local function DataDefine(self)
  self.bubbleIndex = 1
  self.bubbleShowTime = 3
  self.freeAllyBubble = {}
  self.allAllyBubble = {}
  self.emojiSetting = DataCenter.AllianceStarManager:GetEmojiSetting()
end

local function DataDestroy(self)
  self.bubbleIndex = nil
  self.bubbleShowTime = nil
  self.freeAllyBubble = nil
  self.allAllyBubble = nil
  self.waitBubbleDelay = nil
  self.waitBubbleParam = nil
  self.emojiSetting = nil
  self.emojiSpawnDelay = nil
  self.emojiText = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStarCeremonyCompereRefreshBubble, self.TryRefreshCompereBubble)
  self:AddUIListener(EventId.AllianceStarCeremonyAddCustomBubble, self.AddCustomAllyBubble)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceStarCeremonyCompereRefreshBubble, self.TryRefreshCompereBubble)
  self:RemoveUIListener(EventId.AllianceStarCeremonyAddCustomBubble, self.AddCustomAllyBubble)
  base.OnRemoveListener(self)
end

local function CheckAddAllyBubble(self, chatData, isSelf)
  if chatData.post ~= PostType.Text_Normal then
    return
  end
  local text = chatData.msg
  local scene = DataCenter.AllianceStarManager.ceremonyScene
  if scene then
    local ally, pos = scene:GetFreeAllyBubblePos(self.rectTransform)
    if ally and pos then
      local template = DataCenter.AllianceStarManager:GetAlStarPlayScriptTemplateInfo(2)
      local param = {}
      param.unit = ally
      param.dialogTemplate = template
      param.dialogStr = text
      param.pos = pos
      self:AddAllyBubble(param, isSelf)
    end
  end
end

local function AddAllyBubble(self, param, isSelf)
  local comp
  if #self.freeAllyBubble > 0 then
    comp = table.remove(self.freeAllyBubble)
  end
  if comp == nil then
    local bubbleObj = self.bubblePool:GameObjectSpawn(self.transform)
    bubbleObj.name = "bubble" .. self.bubbleIndex
    comp = self:AddComponent(UIAllianceStarMainBubble, bubbleObj.name)
    table.insert(self.allAllyBubble, comp)
    self.bubbleIndex = self.bubbleIndex + 1
  end
  comp:SetActive(true)
  comp:Refresh(param, isSelf)
end

local function RemoveAllyBubble(self, unit, bubble)
  if unit then
    unit:CloseBubble()
  end
  bubble:SetActive(false)
  bubble:Clear()
  table.insert(self.freeAllyBubble, bubble)
end

local function AddCustomAllyBubble(self, customParam)
  local scene = DataCenter.AllianceStarManager.ceremonyScene
  if scene then
    local pos = scene:GetAllyBubblePos(self.rectTransform, customParam.unit)
    if pos then
      local template = DataCenter.AllianceStarManager:GetAlStarPlayScriptTemplateInfo(1)
      local param = {}
      param.unit = customParam.unit
      param.dialogTemplate = template
      param.dialogStr = customParam.dialogStr
      param.pos = pos
      for i, v in pairs(self.allAllyBubble) do
        if v.unit and v.unit == customParam.unit then
          self:RemoveAllyBubble(v.unit, v)
        end
      end
      self:AddAllyBubble(param)
    end
  end
end

local function TryRefreshCompereBubble(self, bubbleParam)
  if bubbleParam and bubbleParam.dialogTemplate and bubbleParam.dialogTemplate.bubbleDelay and bubbleParam.dialogTemplate.bubbleDelay > 0 then
    self.waitBubbleDelay = bubbleParam.dialogTemplate.bubbleDelay
    if bubbleParam.dialogDelay then
      self.waitBubbleDelay = self.waitBubbleDelay - bubbleParam.dialogDelay
    end
    if 0 < self.waitBubbleDelay then
      self:RefreshCompereBubble()
      self.waitBubbleDelay = bubbleParam.dialogTemplate.bubbleDelay
      self.waitBubbleParam = bubbleParam
    else
      self:RefreshCompereBubble(bubbleParam)
    end
  else
    self:RefreshCompereBubble(bubbleParam)
  end
end

local function RefreshCompereBubble(self, bubbleParam)
  if bubbleParam == nil or string.IsNullOrEmpty(bubbleParam.dialogStr) then
    self.compereBubble:SetActive(false)
  else
    self.compereBubble:SetActive(true)
    if bubbleParam.dialogTemplate.bubbleType and bubbleParam.dialogTemplate.bubbleType == 2 then
      self.compereBubbleBg2:SetActive(true)
      self.compereBubbleText2:SetText(bubbleParam.dialogStr)
      self.compereBubbleBg1:SetActive(false)
    else
      self.compereBubbleBg1:SetActive(true)
      self.compereBubbleText1:SetText(bubbleParam.dialogStr)
      self.compereBubbleBg2:SetActive(false)
    end
  end
  self.waitBubbleDelay = nil
  self.waitBubbleParam = nil
end

function UIAllianceStarMainBubblePanel:RandomEmoji()
  self.emojiSpawnDelay = math.random(0, 1) + math.random(self.emojiSetting.sendInterval[1], self.emojiSetting.sendInterval[2])
  local emojiId = table.randomArrayValue(self.emojiSetting.emojiList)
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
  local emojiText = Regex.Unescape("\\u" .. line.path)
  local emojiNum = math.random(self.emojiSetting.numInterval[1], self.emojiSetting.numInterval[2])
  self.emojiText = ""
  for i = 1, emojiNum do
    self.emojiText = self.emojiText .. emojiText
  end
end

function UIAllianceStarMainBubblePanel:ShowEmojiBubbleByEmojiId(emojiId, isSelf)
  local line = LocalController:instance():getLine(TableName.LW_EMOJI, emojiId)
  local emojiText = Regex.Unescape("\\u" .. line.path)
  self:ShowEmojiBubble(emojiText, isSelf)
end

function UIAllianceStarMainBubblePanel:ShowEmojiBubble(emojiText, isSelf)
  local chatData = {}
  chatData.post = PostType.Text_Normal
  chatData.msg = emojiText
  self:CheckAddAllyBubble(chatData, isSelf)
end

local function Update(self)
  if self.waitBubbleDelay then
    self.waitBubbleDelay = self.waitBubbleDelay - Time.deltaTime
    if self.waitBubbleDelay <= 0 then
      self:RefreshCompereBubble(self.waitBubbleParam)
    end
  end
  if self.emojiSpawnDelay then
    self.emojiSpawnDelay = self.emojiSpawnDelay - Time.deltaTime
    if 0 >= self.emojiSpawnDelay then
      self.emojiSpawnDelay = nil
      self:ShowEmojiBubble(self.emojiText)
      self:RandomEmoji()
    end
  end
end

UIAllianceStarMainBubblePanel.OnCreate = OnCreate
UIAllianceStarMainBubblePanel.OnDestroy = OnDestroy
UIAllianceStarMainBubblePanel.OnEnable = OnEnable
UIAllianceStarMainBubblePanel.OnDisable = OnDisable
UIAllianceStarMainBubblePanel.ComponentDefine = ComponentDefine
UIAllianceStarMainBubblePanel.ComponentDestroy = ComponentDestroy
UIAllianceStarMainBubblePanel.DataDefine = DataDefine
UIAllianceStarMainBubblePanel.DataDestroy = DataDestroy
UIAllianceStarMainBubblePanel.OnAddListener = OnAddListener
UIAllianceStarMainBubblePanel.OnRemoveListener = OnRemoveListener
UIAllianceStarMainBubblePanel.CheckAddAllyBubble = CheckAddAllyBubble
UIAllianceStarMainBubblePanel.AddAllyBubble = AddAllyBubble
UIAllianceStarMainBubblePanel.RemoveAllyBubble = RemoveAllyBubble
UIAllianceStarMainBubblePanel.AddCustomAllyBubble = AddCustomAllyBubble
UIAllianceStarMainBubblePanel.TryRefreshCompereBubble = TryRefreshCompereBubble
UIAllianceStarMainBubblePanel.RefreshCompereBubble = RefreshCompereBubble
UIAllianceStarMainBubblePanel.Update = Update
return UIAllianceStarMainBubblePanel
