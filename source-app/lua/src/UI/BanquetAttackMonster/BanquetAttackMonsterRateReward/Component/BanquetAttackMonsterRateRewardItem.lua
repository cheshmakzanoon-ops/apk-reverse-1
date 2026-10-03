local BanquetAttackMonsterRateRewardItem = BaseClass("BanquetAttackMonsterRateRewardItem", UIBaseContainer)
local base = UIBaseContainer
local u_i_common_res_item_path = "UICommonResItem"
local rate_txt_path = "rateTxt"
local tip_img_path = "tipImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.rate_txt = self:AddComponent(UITextMeshProUGUIEx, rate_txt_path)
  self.tip_img = self:AddComponent(UIImage, tip_img_path)
end

local function ComponentDestroy(self)
end

local function SetData(self, data)
  self.data = data
  self.u_i_common_res_item:ReInit(self.data)
  if self.data and self.data.itemId then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.itemId)
    if itemTemplate and itemTemplate.type == GOODS_TYPE.GOODS_TYPE_182 then
      self.data.hideHaveCountShow = true
      self.u_i_common_res_item:SetItemCountActive(false)
    end
  end
  local rate = self.data.rateNum or 0
  self.rate_txt:SetText(string.format("%.2f", rate) .. "%")
  local isTip = self.data.isTip or 0
  self.tip_img:SetActive(0 < isTip)
end

BanquetAttackMonsterRateRewardItem.OnCreate = OnCreate
BanquetAttackMonsterRateRewardItem.OnDestroy = OnDestroy
BanquetAttackMonsterRateRewardItem.ComponentDefine = ComponentDefine
BanquetAttackMonsterRateRewardItem.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterRateRewardItem.SetData = SetData
return BanquetAttackMonsterRateRewardItem
