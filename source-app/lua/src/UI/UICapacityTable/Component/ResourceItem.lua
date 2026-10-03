local ResourceItem = BaseClass("ResourceItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local btn_path = "clickBtn"
local item_num_path = "clickBtn/NumText"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local flag_go_path = "clickBtn/FlagGo"
local redDot_path = "clickBtn/redDot"
local red_img_path = "clickBtn/Img_Red"
local showFormatNumStrMoreThan = 10000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.item_num = self:AddComponent(UIText, item_num_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectGoods, false)
    self:OnBtnClick()
  end)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
  self.redDot = self:AddComponent(UIBaseContainer, redDot_path)
  self.red_img = self:AddComponent(UIBaseContainer, red_img_path)
  self.imgExtra = self:AddComponent(UIImage, "clickBtn/ImgExtra")
  self.nodeHeroDebris = self:AddComponent(UIBaseContainer, "clickBtn/HeroDebris")
  self.nodeHeroDebris:SetActive(false)
end

local function ComponentDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.item_num = nil
  self.btn = nil
  self.num = nil
  self.red_img:SetActive(false)
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

local function RedDotRefresh(self, state)
  if self.param.template and self.param.template.important == 2 then
    self.red_img:SetActive(not state)
    self.redDot:SetActive(false)
    DataCenter.ItemData:SetItemRed(self.param.data.uuid)
  else
    self.redDot:SetActive(not state)
    self.red_img:SetActive(false)
  end
end

local function RefreshData(self, param)
  self.param = param
  self.imgExtra:SetActive(false)
  if param.tabType == UICapacityTableTab.Item then
    if self.param.flagtxt ~= "" then
      self.flag_go:SetActive(true)
      self.flag_text:SetText(self.param.flagtxt)
    else
      self.flag_go:SetActive(false)
    end
    self.item_quality:LoadSprite(self.param.quality_name)
  else
    self.flag_go:SetActive(false)
    self.item_quality:LoadSprite(string.format(LoadPath.ItemPath, self.param.quality_name))
    if self.view.curSelectCell and self.param.index == self.view.curSelectCell then
      self.delay = TimerManager:GetInstance():DelayInvoke(function()
        self:OnBtnClick()
      end, 0.2)
    end
  end
  if param.tabType == UICapacityTableTab.Resource then
    self.item_icon:LoadSprite(self.param.icon_name)
  elseif param.tabType == UICapacityTableTab.Item then
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon_name))
  else
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon_name))
  end
  if self.param.num ~= nil then
    self.item_num:SetText(self.param.num)
  else
    self:RefreshNum()
  end
end

local function OnBtnClick(self)
  if self.param.callBack ~= nil then
    if not self.param.redState then
      self:RedDotRefresh(true)
      self.view:RedReference(self.param.index)
    end
    self.param.callBack(self.transform, self.param.index)
    return
  end
  local cellW = self.item_icon.rectTransform.rect.width
  local posX = self.item_icon.transform.position.x
  local posY = self.item_icon.transform.position.y
  local scrollPos = self.view.scroll_view.transform.position
  local rect = self.view.scroll_view.rectTransform.rect
  local arrowMinY = scrollPos.y + rect.y
  local arrowMaxY = arrowMinY + rect.height
  local index = toInt(self.__name)
  local isLineEnd = self.param.constraintCount * 0.5 < (self.param.index - 1) % self.param.constraintCount + 1
  if self.param.tabType == UICapacityTableTab.Resource then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTip, {anim = true, playEffect = false}, arrowMinY, arrowMaxY, isLineEnd, self.param.tabType, posX, posY, cellW, self.param.resourceType)
  else
    local uuid = self.uuid
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByUuid(uuid)
    if IsNull(itemData) then
      uuid = nil
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityTip, {anim = true, playEffect = false}, arrowMinY, arrowMaxY, isLineEnd, self.param.tabType, posX, posY, cellW, self.param.itemId, uuid)
  end
end

local function RefreshNum(self)
  local curNum = 0
  if self.param.tabType == UICapacityTableTab.Resource then
    curNum = LuaEntry.Resource:GetCntByResType(self.param.resourceType)
  else
    local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.param.itemId)
    if itemData ~= nil then
      self.uuid = itemData.uuid
      curNum = itemData.number
    end
  end
  if curNum >= showFormatNumStrMoreThan then
    self.item_num:SetText(string.GetFormattedStr(curNum))
  else
    self.item_num:SetText(string.GetFormattedSeperatorNum(curNum))
  end
end

local function GetIndex(self)
  return self.param.index
end

ResourceItem.OnCreate = OnCreate
ResourceItem.OnDestroy = OnDestroy
ResourceItem.OnBtnClick = OnBtnClick
ResourceItem.OnEnable = OnEnable
ResourceItem.OnDisable = OnDisable
ResourceItem.ComponentDefine = ComponentDefine
ResourceItem.ComponentDestroy = ComponentDestroy
ResourceItem.DataDefine = DataDefine
ResourceItem.DataDestroy = DataDestroy
ResourceItem.RefreshNum = RefreshNum
ResourceItem.RefreshData = RefreshData
ResourceItem.RedDotRefresh = RedDotRefresh
ResourceItem.GetIndex = GetIndex
return ResourceItem
