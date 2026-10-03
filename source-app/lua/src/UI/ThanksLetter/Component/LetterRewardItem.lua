local base = UIBaseContainer
local LetterRewardItem = BaseClass("LetterRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local black_mask_item_path = "BlackMaskItem"

function LetterRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LetterRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LetterRewardItem:ComponentDefine()
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.black_mask_item = self:AddComponent(UIImage, black_mask_item_path)
end

function LetterRewardItem:ComponentDestroy()
  self.u_i_common_res_item = nil
  self.black_mask_item = nil
end

function LetterRewardItem:DataDefine()
end

function LetterRewardItem:DataDestroy()
  self.clickHandler = nil
end

function LetterRewardItem:SetData(param, isReceive)
  self.param = param
  self.isReceive = isReceive
  self.u_i_common_res_item:ReInit(param)
  self.black_mask_item:SetActive(self.isReceive)
end

return LetterRewardItem
