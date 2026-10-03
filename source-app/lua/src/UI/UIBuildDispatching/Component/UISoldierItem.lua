local UISoldierItem = BaseClass("UISoldierItem", UIBaseContainer)
local base = UIBaseContainer
local promotion_btn_path = "PromotionBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function DataDefine(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, "WorkerIcon")
  self.countText = self:AddComponent(UIText, "WorkerCountText")
  self.levelText = self:AddComponent(UIText, "WorkerLevelText")
  self.btn = self:AddComponent(UIButton, "")
  if self.btn then
    self.btn:SetOnClick(function()
      if self.clickCallBack ~= nil then
        self.clickCallBack(self.soldierData, self.icon.transform.position)
      end
    end)
  end
  self.qualityBg = self:AddComponent(UIImage, "QualityBg")
  if not IsNull(self.transform:Find(promotion_btn_path)) then
    self.promotion_btn = self:AddComponent(UIButton, promotion_btn_path)
    self.promotion_btn:SetActive(false)
    self.promotion_btn:SetOnClick(function()
      if self.promotionBtnClickCallBack ~= nil then
        self.promotionBtnClickCallBack(self.soldierData)
      end
    end)
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDestroy(self)
  self.soldierData = nil
end

local function ComponentDestroy(self)
  self.icon = nil
  self.countText = nil
  self.levelText = nil
  self.btn = nil
  self.promotion_btn = nil
end

local function SetData(self, soldierData, elevenSoldierData)
  if soldierData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.soldierData = soldierData
  local soldierId = soldierData.id
  local count = soldierData.count
  local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
  local soldierLevel = soldierTemplate.lv
  local soldierIcon = ""
  self.elevenSoldierData = elevenSoldierData
  if not self.elevenSoldierData then
    soldierIcon = string.format(LoadPath.ItemPath, soldierTemplate.icon)
  else
    if type(elevenSoldierData) ~= "table" then
      Logger.LogError("UISoldierItem:SetData: soldierData is not a table")
      self.elevenSoldierData = {}
    end
    local curStage = self.elevenSoldierData.stage or 0
    local type = self.elevenSoldierData.type or 0
    local t11Data = {type = type, stage = curStage}
    soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconById(soldierId, t11Data)
  end
  self.levelText:SetText(string.format("Lv.%d", soldierLevel))
  if soldierData.customLvTextColor ~= nil then
    self.levelText:SetColor(soldierData.customLvTextColor)
  end
  self.icon:LoadSpriteAsync(soldierIcon)
  if count ~= nil then
    count = math.floor(count)
    if 9999 < count then
      self.countText:SetText(string.GetFormattedStr(count))
    else
      self.countText:SetText(string.GetFormattedSeparatorNum(count))
    end
  else
    self.countText:SetText("")
  end
  self.qualityBg:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
end

local function SetDataWithCallBack(self, soldierData, elevenData, clickCallBack)
  self:SetData(soldierData, elevenData)
  self.clickCallBack = clickCallBack
end

local function SetInteractable(self, interactable)
  self.btn:SetInteractable(interactable)
end

local function SetCountTextVisible(self, visible)
  self.countText:SetActive(visible)
end

local function SetCountText(self, text)
  self.countText:SetText(text)
end

local function SetPromotionBtnVisible(self, visible)
  if self.promotion_btn then
    self.promotion_btn:SetActive(visible)
  end
end

local function SetPromotionBtnClickCallBack(self, clickCallBack)
  self.promotionBtnClickCallBack = clickCallBack
end

UISoldierItem.OnCreate = OnCreate
UISoldierItem.DataDefine = DataDefine
UISoldierItem.ComponentDefine = ComponentDefine
UISoldierItem.OnDestroy = OnDestroy
UISoldierItem.DataDestroy = DataDestroy
UISoldierItem.ComponentDestroy = ComponentDestroy
UISoldierItem.SetData = SetData
UISoldierItem.SetInteractable = SetInteractable
UISoldierItem.SetCountTextVisible = SetCountTextVisible
UISoldierItem.SetCountText = SetCountText
UISoldierItem.SetPromotionBtnVisible = SetPromotionBtnVisible
UISoldierItem.SetPromotionBtnClickCallBack = SetPromotionBtnClickCallBack
UISoldierItem.SetDataWithCallBack = SetDataWithCallBack
return UISoldierItem
