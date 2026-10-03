local UIActSlotMachineRecordLogBoxItem = BaseClass("UIActSlotMachineRecordLogBoxItem", UIBaseContainer)
local base = UIBaseContainer
local u_i_common_res_item_path = "UICommonResItem"
local rate_img_path = "rateImg"

function UIActSlotMachineRecordLogBoxItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActSlotMachineRecordLogBoxItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActSlotMachineRecordLogBoxItem:ComponentDefine()
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.rate_img = self:AddComponent(UIImage, rate_img_path)
end

function UIActSlotMachineRecordLogBoxItem:ComponentDestroy()
  self.u_i_common_res_item = nil
  self.rate_img = nil
end

function UIActSlotMachineRecordLogBoxItem:DataDefine()
end

function UIActSlotMachineRecordLogBoxItem:DataDestroy()
end

function UIActSlotMachineRecordLogBoxItem:SetData(param, rateNum)
  self.param = param
  self.rateNum = rateNum
  local showDataList = DataCenter.RewardManager:ReturnRewardParamForView({
    self.param
  })
  if showDataList and 0 < #showDataList then
    local item = showDataList[1]
    if self.rateNum > 1 and item.count then
      item.count = math.floor(item.count / self.rateNum)
    end
    self.u_i_common_res_item:ReInit(item)
    self.rate_img:SetActive(self.rateNum > 1)
  end
end

return UIActSlotMachineRecordLogBoxItem
