local CityShieldItemCell = BaseClass("CityShieldItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local item_icon_path = "UICommonResItem/clickBtn/ItemIcon"
local title_txt_path = "Text_title"
local des_txt_Path = "Text_des"
local count_txt_Path = "Text_count"
local itemPrice_txt_Path = "BtnPurchase/btnTxtObj/txt2"
local itemSure_txt_Path = "BtnPurchase/btnTxtObj/txt1"
local buy_btn_path = "BtnPurchase"
local use_btn_path = "UseBtn"
local use_btn_txt_path = "UseBtn/UseBtnName"

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

local function ComponentDefine(self)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.title_txt = self:AddComponent(UIText, title_txt_path)
  self.des_txt = self:AddComponent(UIText, des_txt_Path)
  self.count_txt = self:AddComponent(UIText, count_txt_Path)
  self.price_txt = self:AddComponent(UIText, itemPrice_txt_Path)
  self.itemSure_txt = self:AddComponent(UIText, itemSure_txt_Path)
  self.use_btn_txt = self:AddComponent(UIText, use_btn_txt_path)
  self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.buy_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuyBtnClick()
  end)
  self.use_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnUseBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.item_icon = nil
  self.title_txt = nil
  self.des_txt = nil
  self.count_txt = nil
  self.price_txt = nil
  self.itemSure_txt = nil
  self.use_btn_txt = nil
end

local function DataDefine(self)
  self.itemSure_txt:SetLocalText(110001)
  self.use_btn_txt:SetLocalText(110046)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  if self.param ~= nil then
    self.title_txt:SetText(self.param.name)
    self.des_txt:SetLocalText(self.param.description)
    self.price_txt:SetText(self.param.price)
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon))
    self.count_txt:SetText(Localization:GetString("100100") .. " " .. self.param.count)
    if self.param.count > 0 then
      self.buy_btn.gameObject:SetActive(false)
      self.use_btn.gameObject:SetActive(true)
    else
      self.buy_btn.gameObject:SetActive(true)
      self.use_btn.gameObject:SetActive(false)
    end
  end
end

local function OnBuyBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param)
  end
end

local function OnUseBtnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.param)
  end
end

CityShieldItemCell.OnCreate = OnCreate
CityShieldItemCell.OnDestroy = OnDestroy
CityShieldItemCell.OnEnable = OnEnable
CityShieldItemCell.OnDisable = OnDisable
CityShieldItemCell.ComponentDefine = ComponentDefine
CityShieldItemCell.ComponentDestroy = ComponentDestroy
CityShieldItemCell.DataDefine = DataDefine
CityShieldItemCell.DataDestroy = DataDestroy
CityShieldItemCell.OnAddListener = OnAddListener
CityShieldItemCell.OnRemoveListener = OnRemoveListener
CityShieldItemCell.ReInit = ReInit
CityShieldItemCell.OnUseBtnClick = OnUseBtnClick
CityShieldItemCell.OnBuyBtnClick = OnBuyBtnClick
return CityShieldItemCell
