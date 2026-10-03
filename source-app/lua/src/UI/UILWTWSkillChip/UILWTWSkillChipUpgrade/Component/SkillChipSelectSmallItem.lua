local SkillChipSelectSmallItem = BaseClass("SkillChipSelectSmallItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")
local click_btn_path = "clickBtn"
local icon_path = "icon"
local unset_btn_path = "deleteBtn"
local count_text_path = "num"
local stars_layout_path = "StarsLayout"
local warnning_icon_path = "warnningIcon"
local border_path = "border"
local bg_path = "bg"
local ItemType = {Goods = 1, Chip = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  if self.clickBtn then
    DOTween.Kill(self.clickBtn.transform)
  end
  self.clickCallback = nil
  self.longPressCallback = nil
  self.pointerUpCallback = nil
  self.unsetCallback = nil
  self.unsetLongPressCallback = nil
  self.unsetPointerUpCallback = nil
  self.beginDragCallback = nil
  self.endDragCallback = nil
  self.dragCallback = nil
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ClearStars(self)
  if self.stars then
    self.starsLayout:RemoveComponents(UIHeroSkillStar)
    for i, v in ipairs(self.stars) do
      self:GameObjectDestroy(v)
    end
    self.stars = {}
  end
end

local function ComponentDefine(self)
  self.click_btn = self:AddComponent(UIButton, click_btn_path)
  self.click_btn:SetOnClick(function()
    if self.clickCallback then
      self.clickCallback(self, self.info)
    end
  end)
  self.eventTrigger = self:AddComponent(UIEventTrigger, click_btn_path)
  self.eventTrigger:onLongPress(function()
    if self.longPressCallback then
      self.longPressCallback(self, self.info)
    end
  end)
  self.eventTrigger:OnPointerUp(function()
    if self.pointerUpCallback then
      self.pointerUpCallback(self, self.info)
    end
  end)
  self.eventTrigger:OnBeginDrag(function(eventData)
    if self.beginDragCallback then
      self.beginDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    if self.endDragCallback then
      self.endDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnDrag(function(eventData)
    if self.dragCallback then
      self.dragCallback(eventData)
    end
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.unset_btn = self:AddComponent(UIButton, unset_btn_path)
  self.unset_btn:SetOnClick(function()
    if self.unsetCallback then
      self.unsetCallback(self, self.info)
    end
  end)
  self.unset_trigger = self:AddComponent(UIEventTrigger, unset_btn_path)
  self.unset_trigger:onLongPress(function()
    if self.unsetLongPressCallback then
      self.unsetLongPressCallback(self, self.info)
    end
  end)
  self.unset_trigger:OnPointerUp(function()
    if self.unsetPointerUpCallback then
      self.unsetPointerUpCallback(self, self.info)
    end
  end)
  self.count_text = self:AddComponent(UIText, count_text_path)
  self.starsLayout = self:AddComponent(UIBaseContainer, stars_layout_path)
  self.warningFlag = self:AddComponent(UIBaseContainer, warnning_icon_path)
  self.border = self:AddComponent(UIImage, border_path)
  self.bg = self:AddComponent(UIImage, bg_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.stars = {}
end

local function DataDestroy(self)
  self.stars = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetStars(self, starCount)
  ClearStars(self)
  if 0 < starCount then
    local showStarCount = math.min(starCount, 5)
    local leftWindow = math.max(0, starCount - 5)
    local rightWindow = starCount
    for i = 1, showStarCount do
      local starRequest = self:GameObjectInstantiateAsync(UIAssets.UIHeroSkillStar, function(request)
        if IsNull(request.gameObject) then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.starsLayout.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local cell = self.starsLayout:AddComponent(UIHeroSkillStar, go)
        cell:SetFilled(true)
        local viewStarIndex = leftWindow + i
        cell:SetStarIndex(viewStarIndex)
        cell.transform:Set_sizeDelta(22.12, 23.26)
      end)
      table.insert(self.stars, starRequest)
    end
  end
end

local function SetData(self, itemInfo)
  if not itemInfo then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  local type = itemInfo.type
  self.info = itemInfo
  if type == ItemType.Chip then
    self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.TWSkillChip, itemInfo.configId))
    local chipInfo = DataCenter.TacticalChipManager:GetChipInfo(itemInfo.uuid)
    if chipInfo then
      self.icon:LoadSpriteAuto(chipInfo:GetIcon())
      SetStars(self, chipInfo:GetStar())
      local isNotRecommended = DataCenter.TacticalChipManager:NotRecommendedFeed(chipInfo.uuid)
      self.warningFlag:SetActive(isNotRecommended)
    end
  elseif type == ItemType.Goods then
    local goodsInfo = DataCenter.ItemData:GetItemByUuid(itemInfo.uuid)
    self.bg:LoadSprite(DataCenter.RewardManager:GetRewardQualityBg(RewardType.GOODS, goodsInfo.itemId))
    self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, goodsInfo.itemId))
    ClearStars(self)
    self.warningFlag:SetActive(false)
  end
  self.count_text:SetText(string.format("%s/%s", itemInfo.useCount, itemInfo.maxCount))
  self.unset_btn:SetActive(itemInfo.useCount > 0)
  self.border:SetActive(type == ItemType.Chip)
  self:SetSelected(false)
  self:SetIsWearing(false)
end

local function SetSelected(self, selected)
end

local function SetOnClick(self, callback)
  self.clickCallback = callback
end

local function SetIsWearing(self, isWearing)
end

local function SetOnLongPress(self, callback)
  self.longPressCallback = callback
end

local function SetOnPointerUp(self, callback)
  self.pointerUpCallback = callback
end

local function GetMaxCount(self)
  if self.info then
    return self.info.maxCount or 0
  end
  return 0
end

local function SetSelectNumber(self, selectNumber)
  selectNumber = selectNumber or 0
  local maxCount = self:GetMaxCount()
  if maxCount then
    if 0 < selectNumber then
      self.count_text:SetText(string.format("%d/%d", selectNumber, maxCount))
      self.unset_btn:SetActive(true)
    else
      self.count_text:SetText(string.format("%d/%d", 0, maxCount))
      self.unset_btn:SetActive(false)
    end
  end
  self.info.useCount = selectNumber
end

local function SetConfig(self, id, level, star, count)
  if not id then
    self:SetActive(false)
    return
  end
  level = level or 1
  star = star or 0
  if not self.tempChipData then
    self.tempChipData = TWSkillChipInfo.New()
  end
  self.tempChipData:CreateFromTemplate(id, level, star)
  self.tempChipData.num = count or 0
  self:SetData({
    type = ItemType.Chip,
    data = self.tempChipData
  })
  self.unset_btn:SetActive(false)
end

local function SetGoods(self, itemId, count)
  if not itemId then
    self:SetActive(false)
    return
  end
  count = count or 0
  if not self.tempGoodsData then
    self.tempGoodsData = {}
  end
  self.tempGoodsData.itemId = itemId
  self.tempGoodsData.count = count
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
  if itemTemplate then
    self.tempGoodsData.para1 = itemTemplate.para1
  end
  self:SetData({
    type = ItemType.Goods,
    data = self.tempGoodsData
  })
  self.unset_btn:SetActive(false)
end

local function SetOnUnsetClick(self, callback)
  self.unsetCallback = callback
end

local function SetOnUnsetLongPress(self, callback)
  self.unsetLongPressCallback = callback
end

local function SetOnUnsetPointerUp(self, callback)
  self.unsetPointerUpCallback = callback
end

local function SetOnBeginDrag(self, callback)
  self.beginDragCallback = callback
end

local function SetOnEndDrag(self, callback)
  self.endDragCallback = callback
end

local function SetOnDrag(self, callback)
  self.dragCallback = callback
end

SkillChipSelectSmallItem.OnCreate = OnCreate
SkillChipSelectSmallItem.OnDestroy = OnDestroy
SkillChipSelectSmallItem.ComponentDefine = ComponentDefine
SkillChipSelectSmallItem.ComponentDestroy = ComponentDestroy
SkillChipSelectSmallItem.DataDefine = DataDefine
SkillChipSelectSmallItem.DataDestroy = DataDestroy
SkillChipSelectSmallItem.OnEnable = OnEnable
SkillChipSelectSmallItem.OnDisable = OnDisable
SkillChipSelectSmallItem.SetData = SetData
SkillChipSelectSmallItem.SetSelected = SetSelected
SkillChipSelectSmallItem.SetOnClick = SetOnClick
SkillChipSelectSmallItem.SetIsWearing = SetIsWearing
SkillChipSelectSmallItem.SetOnLongPress = SetOnLongPress
SkillChipSelectSmallItem.SetSelectNumber = SetSelectNumber
SkillChipSelectSmallItem.SetOnPointerUp = SetOnPointerUp
SkillChipSelectSmallItem.SetOnUnsetClick = SetOnUnsetClick
SkillChipSelectSmallItem.SetOnUnsetLongPress = SetOnUnsetLongPress
SkillChipSelectSmallItem.SetOnUnsetPointerUp = SetOnUnsetPointerUp
SkillChipSelectSmallItem.SetConfig = SetConfig
SkillChipSelectSmallItem.GetMaxCount = GetMaxCount
SkillChipSelectSmallItem.SetGoods = SetGoods
SkillChipSelectSmallItem.SetOnBeginDrag = SetOnBeginDrag
SkillChipSelectSmallItem.SetOnEndDrag = SetOnEndDrag
SkillChipSelectSmallItem.SetOnDrag = SetOnDrag
return SkillChipSelectSmallItem
