local StaminaItem = BaseClass("StaminaItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "UICommonResItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonResItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonResItem/clickBtn/FlagGo"
local item_quality_path = "UICommonResItem/clickBtn/ImgQuality"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"
local own_text_path = "layout/OwnText"
local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"
local use_btn_lock_path = "UseBtn/Img_lock"
local more_btn_go_path = "MoreBtnGo"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.extra_text = self:AddComponent(UIText, extra_text_path)
  self.extra = self:AddComponent(UIText, extra_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.own_text = self:AddComponent(UIText, own_text_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.buy_btn_name = self:AddComponent(UIText, buy_btn_name_path)
  self.buy_btn_count = self:AddComponent(UIText, buy_btn_count_path)
  self.buy_btn_count_shadow = self:AddComponent(UIShadow, buy_btn_count_path)
  self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_btn_name_shadow = self:AddComponent(UIShadow, use_btn_name_path)
  self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
  self.use_btn_lock = self:AddComponent(UIImage, use_btn_lock_path)
  self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
  self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.use_btn:SetOnClick(function()
    self:OnUseBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.extra_text = nil
  self.extra = nil
  self.name_text = nil
  self.des_text = nil
  self.own_text = nil
  self.buy_btn = nil
  self.buy_btn_name = nil
  self.buy_btn_count = nil
  self.buy_btn_count_shadow = nil
  self.buy_btn_icon = nil
  self.use_btn = nil
  self.use_btn_name = nil
  self.use_btn_lock = nil
  self.more_btn_go = nil
  self.item_quality_img = nil
end

local function DataDefine(self)
  self.param = {}
  self.callUse = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.itemId = 0
  self.isLock = true
  self.param = param
  self.costGoldNum = 0
  self.recoverNum = 0
  if self.param.info.type == "Gold" then
    self.extra:SetActive(false)
    self.name_text:SetText(Localization:GetString("104217"))
    self.buy_btn_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FORMATION_STAMINA))
    self.item_quality_img:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_img_quality_purple")
    self:RefreshGoldData()
  else
    self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
    self.use_btn_lock:SetActive(false)
    self.itemId = self.param.info.data.itemId
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if template ~= nil then
      if template.para ~= nil and template.para ~= "" then
        local para = tonumber(template.para)
        if 0 < para then
          self.extra:SetActive(true)
          self.extra_text:SetText(string.GetFormattedStr(para))
        else
          self.extra:SetActive(false)
        end
      end
      self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
      self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(template.id))
      self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(template.id))
      self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
      self.own_text:SetActive(true)
      self.own_text:SetText(Localization:GetString("100100") .. param.info.data.count)
      self.buy_btn:SetActive(false)
      self.use_btn:SetActive(true)
      self.use_btn_name:SetLocalText(110046)
    end
  end
end

local function RefreshGoldData(self)
  if self.param.info.type == "Gold" then
    self.isLock = true
    self.costGoldNum = 0
    self.recoverNum = 0
    local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
    local strArr = string.split(goldStr, "|")
    local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
    if 0 < #strArr then
      local index = math.min(useCount + 1, #strArr)
      local str = strArr[index]
      local arr = string.split(str, ";")
      if 2 <= #arr then
        self.isLock = false
        self.costGoldNum = tonumber(arr[1])
        self.recoverNum = tonumber(arr[2])
      end
    end
    self.des_text:SetText(Localization:GetString("104218", self.recoverNum))
    if self.isLock then
      self.buy_btn:SetActive(false)
      self.use_btn:SetActive(true)
      self.use_btn_name:SetText("")
      self.use_btn_lock:SetActive(true)
      self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
    else
      self.use_btn_lock:SetActive(false)
      self.own_text:SetActive(false)
      self.buy_btn:SetActive(true)
      self.use_btn:SetActive(false)
      self.buy_btn_name:SetLocalText(110001)
      self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
      self:RefreshColor(LuaEntry.Player.gold)
    end
  end
end

local function OnBuyBtnClick(self)
  if self.isLock == true then
    UIUtil.ShowTipsId(104216)
  elseif self.param.callBack ~= nil then
    local isBuy = true
    self.param.callBack(self.param.index, nil, isBuy, self.costGoldNum)
  end
end

local function OnUseBtnClick(self)
  if self.itemId == 0 and self.isLock == true then
    UIUtil.ShowTipsId(104216)
  elseif self.itemId ~= nil and self.itemId ~= 0 and self.param.callBack ~= nil and self.itemId ~= nil and self.itemId ~= 0 then
    local isBuy = false
    self.param.callBack(self.param.index, self.itemId, isBuy)
  end
end

local function RefreshOwnCount(self, count)
  self.param.count = count
  self.own_text:SetText(Localization:GetString("100100") .. count)
end

local function RefreshColor(self, gold)
  if self.param.info.type == "Gold" then
    if gold < self.costGoldNum then
      self.buy_btn_count:SetColor(RedColor)
      self.buy_btn_count_shadow:AllEnable(false)
    else
      self.buy_btn_count:SetColor(WhiteColor)
      self.buy_btn_count_shadow:AllEnable(true)
    end
  end
end

local function GetMoreBtnParent(self)
  return self.more_btn_go.transform
end

StaminaItem.OnCreate = OnCreate
StaminaItem.OnDestroy = OnDestroy
StaminaItem.OnEnable = OnEnable
StaminaItem.OnDisable = OnDisable
StaminaItem.ComponentDefine = ComponentDefine
StaminaItem.ComponentDestroy = ComponentDestroy
StaminaItem.DataDefine = DataDefine
StaminaItem.DataDestroy = DataDestroy
StaminaItem.ReInit = ReInit
StaminaItem.OnBuyBtnClick = OnBuyBtnClick
StaminaItem.OnUseBtnClick = OnUseBtnClick
StaminaItem.RefreshOwnCount = RefreshOwnCount
StaminaItem.RefreshColor = RefreshColor
StaminaItem.GetMoreBtnParent = GetMoreBtnParent
StaminaItem.RefreshGoldData = RefreshGoldData
return StaminaItem
