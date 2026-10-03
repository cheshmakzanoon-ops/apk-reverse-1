local UICareerStage = BaseClass("UICareerStage", UIBaseContainer)
local base = UIBaseContainer
local root_path = "Root"
local level_path = "Root/UICareerIcon/Level"
local slider_path = "Root/Slider"
local content_path = "Root/Content"
local big_content_icon_path = "Root/Content/BigContentIcon"
local small_content_icon_path = "Root/Content/SmallContentIcon"
local info_path = "Root/Content/Info"
local lock_path = "Root/Content/Lock"
local level_up_path = "Root/Content/LevelUp"
local level_up_text_path = "Root/Content/LevelUp/LevelUpText"
local arrow_path = "Root/Arrow"
local ContentOffset = 0
local ArrowOffset = 0
local BG_WHITE = string.format(LoadPath.UIPlayerLevel, "UIPlayerLevel_img_bubble_1")
local BG_YELLOW = string.format(LoadPath.UIPlayerLevel, "UIPlayerLevel_img_bubble_2")
local MISSING = "Assets/Main/Sprites/UI/LWCommon/Sprite/Common_btn_wenhao"
local ICON_WIDTH_BIG = 100
local ICON_WIDTH_SMALL = 70
local EFFECT_COUNT = 3
local State = {
  Locked = 1,
  Available = 2,
  Engaged = 3
}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.level_text = self:AddComponent(UIText, level_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.content_btn = self:AddComponent(UIButton, content_path)
  self.content_btn:SetOnClick(function()
    self:OnContentClick()
  end)
  self.event_trigger = self:AddComponent(UIEventTrigger, content_path)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.big_content_icon_image = self:AddComponent(UIImage, big_content_icon_path)
  self.small_content_icon_images = {}
  for i = 1, EFFECT_COUNT do
    self.small_content_icon_images[i] = self:AddComponent(UIImage, small_content_icon_path .. i)
  end
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.lock_go = self:AddComponent(UIBaseContainer, lock_path)
  self.level_up_go = self:AddComponent(UIBaseContainer, level_up_path)
  self.level_up_text = self:AddComponent(UIText, level_up_text_path)
  self.level_up_text:SetLocalText(100091)
  self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
  ContentOffset = math.abs(self.content_btn.rectTransform.anchoredPosition.y)
  ArrowOffset = math.abs(self.arrow_go.rectTransform.anchoredPosition.y)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.level_text = nil
  self.slider = nil
  self.content_btn = nil
  self.big_content_icon_image = nil
  self.small_content_icon_images = nil
  self.info_btn = nil
  self.lock_go = nil
  self.level_up_go = nil
  self.arrow_go = nil
end

local function DataDefine(self)
  self.data = nil
  self.state = State.Locked
  self.onContentClick = nil
  self.onInfoClick = nil
  self.onDrag = nil
  self.onBeginDrag = nil
  self.onEndDrag = nil
end

local function DataDestroy(self)
  self.data = nil
  self.state = nil
  self.onContentClick = nil
  self.onInfoClick = nil
  self.onDrag = nil
  self.onBeginDrag = nil
  self.onEndDrag = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDrag(self, eventData)
  if self.onDrag then
    self.onDrag(eventData)
  end
end

local function OnBeginDrag(self, eventData)
  if self.onBeginDrag then
    self.onBeginDrag(eventData)
  end
end

local function OnEndDrag(self, eventData)
  if self.onEndDrag then
    self.onEndDrag(eventData)
  end
end

local function SetData(self, data)
  self.data = data
  self.level_text:SetText(NumToRoman(data.level))
  self:SetState(data.state)
  self.big_content_icon_image:SetActive(data.level ~= 1)
  for i = 1, EFFECT_COUNT do
    self.small_content_icon_images[i]:SetActive(data.level == 1)
  end
  if data.level == 1 then
    for i, id in ipairs(data.idList) do
      local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(id)
      if template == nil then
        Logger.LogError("UICareerStage, SetData, id = " .. id .. ", template = null")
        return
      end
      self.small_content_icon_images[i]:LoadSprite(template:GetIconPath(), MISSING)
      self.small_content_icon_images[i]:SetNativeSize()
      local size = self.small_content_icon_images[i].rectTransform.sizeDelta
      size.y = size.y / size.x * ICON_WIDTH_SMALL
      size.x = ICON_WIDTH_SMALL
      self.small_content_icon_images[i].rectTransform.sizeDelta = size
    end
  else
    local template = DataCenter.PlayerCareerManager:GetCareerEffectTemplate(data.id)
    if template == nil then
      Logger.LogError("UICareerStage, SetData, id = " .. data.id .. ", template = null")
      return
    end
    self.big_content_icon_image:LoadSprite(template:GetIconPath(), MISSING)
    self.big_content_icon_image:SetNativeSize()
    local size = self.big_content_icon_image.rectTransform.sizeDelta
    size.y = size.y / size.x * ICON_WIDTH_BIG
    size.x = ICON_WIDTH_BIG
    self.big_content_icon_image.rectTransform.sizeDelta = size
  end
end

local function SetState(self, state)
  self.state = state
  if state == State.Locked then
    self.content_btn:LoadSprite(BG_WHITE)
    self.lock_go:SetActive(true)
    self.level_up_go:SetActive(false)
  elseif state == State.Available then
    self.content_btn:LoadSprite(BG_YELLOW)
    self.lock_go:SetActive(false)
    self.level_up_go:SetActive(true)
  elseif state == State.Engaged then
    self.content_btn:LoadSprite(BG_WHITE)
    self.lock_go:SetActive(false)
    self.level_up_go:SetActive(false)
  end
end

local function SetOnClick(self, onContentClick, onInfoClick)
  self.onContentClick = onContentClick
  self.onInfoClick = onInfoClick
end

local function SetOnDrag(self, onDrag, onBeginDrag, onEndDrag)
  self.onDrag = onDrag
  self.onBeginDrag = onBeginDrag
  self.onEndDrag = onEndDrag
end

local function SetStagePos(self)
  if self.data.level % 2 == 0 then
    self.content_btn.rectTransform.anchoredPosition = Vector2.New(0, ContentOffset)
    self.arrow_go.rectTransform.anchoredPosition = Vector2.New(0, ArrowOffset)
    self.arrow_go.rectTransform.localScale = Vector3.New(1, 1, 1)
  else
    self.content_btn.rectTransform.anchoredPosition = Vector2.New(0, -ContentOffset)
    self.arrow_go.rectTransform.anchoredPosition = Vector2.New(0, -ArrowOffset)
    self.arrow_go.rectTransform.localScale = Vector3.New(1, -1, 1)
  end
end

local function OnContentClick(self)
  if self.onContentClick then
    self.onContentClick()
  end
end

local function OnInfoClick(self)
  if self.onInfoClick then
    self.onInfoClick()
  end
end

UICareerStage.OnCreate = OnCreate
UICareerStage.OnDestroy = OnDestroy
UICareerStage.ComponentDefine = ComponentDefine
UICareerStage.ComponentDestroy = ComponentDestroy
UICareerStage.DataDefine = DataDefine
UICareerStage.DataDestroy = DataDestroy
UICareerStage.OnAddListener = OnAddListener
UICareerStage.OnRemoveListener = OnRemoveListener
UICareerStage.OnEnable = OnEnable
UICareerStage.OnDisable = OnDisable
UICareerStage.OnDrag = OnDrag
UICareerStage.OnBeginDrag = OnBeginDrag
UICareerStage.OnEndDrag = OnEndDrag
UICareerStage.State = State
UICareerStage.SetData = SetData
UICareerStage.SetState = SetState
UICareerStage.SetOnClick = SetOnClick
UICareerStage.SetOnDrag = SetOnDrag
UICareerStage.SetStagePos = SetStagePos
UICareerStage.OnContentClick = OnContentClick
UICareerStage.OnInfoClick = OnInfoClick
return UICareerStage
