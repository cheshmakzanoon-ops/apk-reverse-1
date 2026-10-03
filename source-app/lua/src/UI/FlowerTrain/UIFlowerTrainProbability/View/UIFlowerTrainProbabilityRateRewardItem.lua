local UIFlowerTrainProbabilityRateRewardItem = BaseClass("UIFlowerTrainProbabilityRateRewardItem", UIBaseContainer)
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

function UIFlowerTrainProbabilityRateRewardItem:ReInit(data)
  self:SetData(data)
end

local function SetData(self, data)
  self.data = data
  self.u_i_common_res_item:ReInit(self.data)
  self.data.rateNum = self.data.rateNum or 0
  self.rate_txt:SetText(string.format("%.2f", self.data.rateNum) .. "%")
  self.data.isTip = self.data.isTip or 0
  self.tip_img:SetActive(0 < self.data.isTip)
end

UIFlowerTrainProbabilityRateRewardItem.OnCreate = OnCreate
UIFlowerTrainProbabilityRateRewardItem.OnDestroy = OnDestroy
UIFlowerTrainProbabilityRateRewardItem.ComponentDefine = ComponentDefine
UIFlowerTrainProbabilityRateRewardItem.ComponentDestroy = ComponentDestroy
UIFlowerTrainProbabilityRateRewardItem.SetData = SetData
return UIFlowerTrainProbabilityRateRewardItem
