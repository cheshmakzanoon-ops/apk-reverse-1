local ValentineSmallGiftItemComponent = BaseClass("ValentineSmallGiftItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_count_text_path = "ItemCountText"
local icon_img_path = "IconImg"
local select_img_path = "SelectImg"
local click_btn_path = "ClickBtn"
local eff_ui_zone_box_explode_path = "Eff_ui_zone_box_explode"

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
  if self.effObj then
    self.effObj:SetActive(false)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  if self.expBallFlyInSoundHandle then
    DataCenter.LWSoundManager:StopSound(self.expBallFlyInSoundHandle)
    self.expBallFlyInSoundHandle = nil
  end
end

local function ComponentDefine(self)
  self.numText = self:AddComponent(UIText, item_count_text_path)
  self.icon = self:AddComponent(UIImage, icon_img_path)
  self.selectObj = self:AddComponent(UIBaseContainer, select_img_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:BeClick()
  end)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.effObj = self:TryAddComponent(UIBaseContainer, eff_ui_zone_box_explode_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.allTimerList = {}
end

local function DataDestroy(self)
  for _, v in ipairs(self.allTimerList) do
    v:Stop()
  end
  self.allTimerList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ValentineSmallGiftItemComponent:ReInit(param)
  if not param then
    return
  end
  self.itemId = param.itemId
  self.limitUseCount = param.limitUseCount
  self.clickCallback = param.clickCallback
  self:UpdateItemNum()
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(self.itemId)
  if iconPath then
    self.icon:LoadSprite(iconPath)
  end
end

function ValentineSmallGiftItemComponent:UpdateItemNum()
  if not self.itemId then
    return
  end
  local itemNum = DataCenter.ItemData:GetItemCount(self.itemId)
  self.numText:SetText(itemNum)
end

function ValentineSmallGiftItemComponent:SetSelectState(isSelect)
  self.selectObj:SetActive(isSelect)
end

function ValentineSmallGiftItemComponent:BeClick()
  if self.clickCallback then
    self.clickCallback(self.itemId)
  end
end

function ValentineSmallGiftItemComponent:PlaySpecialReceiveItemAi(delayTime)
  if self.aniTimer then
    self.aniTimer:Stop()
    self.aniTimer = nil
  end
  local aniTimer
  aniTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.simpleAni then
      self.simpleAni:Rewind("Play")
      self.simpleAni:Play("Play")
    end
    table.remove(self.allTimerList, 1)
    if self.expBallFlyInSoundHandle then
      DataCenter.LWSoundManager:StopSound(self.expBallFlyInSoundHandle)
      self.expBallFlyInSoundHandle = nil
    end
    self.expBallFlyInSoundHandle = DataCenter.LWSoundManager:PlaySound(202632, false)
  end, delayTime)
  table.insert(self.allTimerList, aniTimer)
end

ValentineSmallGiftItemComponent.OnCreate = OnCreate
ValentineSmallGiftItemComponent.OnDestroy = OnDestroy
ValentineSmallGiftItemComponent.OnEnable = OnEnable
ValentineSmallGiftItemComponent.OnDisable = OnDisable
ValentineSmallGiftItemComponent.ComponentDefine = ComponentDefine
ValentineSmallGiftItemComponent.ComponentDestroy = ComponentDestroy
ValentineSmallGiftItemComponent.DataDefine = DataDefine
ValentineSmallGiftItemComponent.DataDestroy = DataDestroy
ValentineSmallGiftItemComponent.OnAddListener = OnAddListener
ValentineSmallGiftItemComponent.OnRemoveListener = OnRemoveListener
return ValentineSmallGiftItemComponent
