local ConsumeItem = BaseClass("ConsumeItem", UIBaseContainer)
local base = UIBaseContainer
local item_quality_path = "IconNode/UIGiftItem/clickBtn/ImgQuality"
local item_icon_path = "IconNode/UIGiftItem/clickBtn/ItemIcon"
local imgExtra_path = "IconNode/UIGiftItem/clickBtn/ImgExtra"
local name_text_path = "TxtName"
local flag_text_path = "IconNode/UIGiftItem/clickBtn/FlagGo/FlagText"
local btn_path = "IconNode/UIGiftItem/clickBtn"
local num_txt_path = "TxtNum"

local function OnCreate(self)
  base.OnCreate(self)
  self.item_quality = self:AddComponent(UIImage, item_quality_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.imgExtra = self:AddComponent(UIImage, imgExtra_path)
  self.flag_text = self:AddComponent(UIText, flag_text_path)
  self.num_txet = self:AddComponent(UIText, num_txt_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
  end)
end

local function OnDestroy(self)
  self.item_quality = nil
  self.item_icon = nil
  self.imgExtra = nil
  self.flag_text = nil
  self.param = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self.param = data
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  if goods then
    self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
    if goods.type == 2 then
      if goods.para1 ~= nil and goods.para1 ~= "" then
        local para1 = goods.para1
        local temp = string.split(para1, ";")
        if temp ~= nil and 1 < #temp then
          self.flag_text:SetText(temp[1] .. temp[2])
        end
      end
    elseif goods.type == 3 then
      local type2 = goods.type2
      if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
        local res_num = tonumber(goods.para)
        self.flag_text:SetText(string.GetFormattedStr(res_num))
      end
    end
    self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
  if self.param.count then
    self.num_txet:SetActive(true)
    self.num_txet:SetText("x" .. self.param.count)
  else
    self.num_txet:SetActive(false)
  end
end

local function OnBtnClick(self)
  if self.param.itemId ~= nil then
    local param = {}
    param.itemId = self.param.itemId
    param.alignObject = self.item_icon
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

ConsumeItem.OnCreate = OnCreate
ConsumeItem.OnDestroy = OnDestroy
ConsumeItem.OnEnable = OnEnable
ConsumeItem.OnDisable = OnDisable
ConsumeItem.RefreshData = RefreshData
ConsumeItem.OnBtnClick = OnBtnClick
return ConsumeItem
