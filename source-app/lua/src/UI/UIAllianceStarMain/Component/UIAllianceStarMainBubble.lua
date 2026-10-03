local UIAllianceStarMainBubble = BaseClass("UIAllianceStarMainBubble", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

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
  self.bubbleBg1 = self:AddComponent(UIImage, "Bg1")
  self.bubbleBg2 = self:AddComponent(UIImage, "Bg2")
  self.bubbleText1 = self:AddComponent(UITextMeshProUGUIEx, "Bg1/BubbleText1")
  self.bubbleText2 = self:AddComponent(UITextMeshProUGUIEx, "Bg2/BubbleText2")
  self.bubbleArrow1 = self:AddComponent(UIImage, "Bg1/Arrow")
  ChatInterface.SetEmojiTextProperty(self.bubbleText1)
  self.bubbleText1:SetRichText(true)
  ChatInterface.SetEmojiTextProperty(self.bubbleText2)
  self.bubbleText2:SetRichText(true)
  self.textSize = self.bubbleText1:GetSizeDelta()
end

local function ComponentDestroy(self)
  self.bubbleBg1 = nil
  self.bubbleBg2 = nil
  self.bubbleText1 = nil
  self.bubbleText2 = nil
  self.bubbleArrow1 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function CheckCanShow(self, text)
  self.bubbleText1:SetText_NotNative(text)
  local canShow = true
  if self.bubbleText1:GetWidth() > self.textSize.x or self.bubbleText1:GetHeight() > self.textSize.y then
    canShow = false
  end
  return canShow
end

local function Refresh(self, param, isSelf)
  if param.dialogTemplate.bubbleType and param.dialogTemplate.bubbleType == 2 then
    self.bubbleBg1:SetActive(false)
    self.bubbleBg2:SetActive(true)
    self.bubbleText2:SetText_NotNative(param.dialogStr)
  else
    self.bubbleBg2:SetActive(false)
    self.bubbleBg1:SetActive(true)
    self.bubbleText1:SetText_NotNative(param.dialogStr)
    if isSelf then
      self.bubbleBg1:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_tip_kuang.png")
      self.bubbleArrow1:LoadSprite("Assets/Main/Sprites/UI/UIAllianceStar/zxl_tmzx_tip_jiao_2.png")
    else
      self.bubbleBg1:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyon_tip_kuang.png")
      self.bubbleArrow1:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyon_tip_jiao_2.png")
    end
  end
  self:SetAnchoredPosition(param.pos)
  self.unit = param.unit
  self.showTime = param.dialogTemplate.bubbleStay
end

local function Clear(self)
  self.unit = nil
end

local function Update(self)
  if not (self.unit ~= nil and self.unit.showBubble) or self.showTime <= 0 then
    self.holder:RemoveAllyBubble(self.unit, self)
    return
  end
  self.showTime = self.showTime - Time.deltaTime
end

UIAllianceStarMainBubble.OnCreate = OnCreate
UIAllianceStarMainBubble.OnDestroy = OnDestroy
UIAllianceStarMainBubble.OnEnable = OnEnable
UIAllianceStarMainBubble.OnDisable = OnDisable
UIAllianceStarMainBubble.ComponentDefine = ComponentDefine
UIAllianceStarMainBubble.ComponentDestroy = ComponentDestroy
UIAllianceStarMainBubble.DataDefine = DataDefine
UIAllianceStarMainBubble.DataDestroy = DataDestroy
UIAllianceStarMainBubble.OnAddListener = OnAddListener
UIAllianceStarMainBubble.OnRemoveListener = OnRemoveListener
UIAllianceStarMainBubble.CheckCanShow = CheckCanShow
UIAllianceStarMainBubble.Refresh = Refresh
UIAllianceStarMainBubble.Update = Update
UIAllianceStarMainBubble.Clear = Clear
return UIAllianceStarMainBubble
