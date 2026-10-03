local CommonBoxRewardItem = BaseClass("CommonBoxRewardItem", UIBaseContainer)
local base = UIBaseContainer
local txt_name_path = "TxtName"
local u_i_common_res_item_path = "UICommonResItem"

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
end

local function OnDestroy(self)
  self.txt_name = nil
  self.u_i_common_res_item = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBtnClick(self)
end

local function ReInit(self, value)
  self.u_i_common_res_item:ReInit(value)
  self.txt_name:SetText(self.u_i_common_res_item.nameText)
end

CommonBoxRewardItem.OnCreate = OnCreate
CommonBoxRewardItem.OnDestroy = OnDestroy
CommonBoxRewardItem.OnBtnClick = OnBtnClick
CommonBoxRewardItem.OnEnable = OnEnable
CommonBoxRewardItem.OnDisable = OnDisable
CommonBoxRewardItem.ReInit = ReInit
return CommonBoxRewardItem
