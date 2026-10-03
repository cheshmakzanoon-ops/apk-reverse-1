local ValentineRewardItemComponent = BaseClass("ValentineRewardItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local receive_obj_path = "ReceiveObj"
local img_red_path = "Img_Red"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.commonResItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.redPoint = self:AddComponent(UIBaseContainer, img_red_path)
  self.receivedObj = self:AddComponent(UIBaseContainer, receive_obj_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ValentineRewardItemComponent:ReInit(param)
  if param.rewardData then
    self.commonResItem:ParseInfo(param.rewardData)
  end
  self.redPoint:SetActive(param.isShowRed)
  self.receivedObj:SetActive(param.isShowReceived)
end

ValentineRewardItemComponent.OnCreate = OnCreate
ValentineRewardItemComponent.OnDestroy = OnDestroy
ValentineRewardItemComponent.OnEnable = OnEnable
ValentineRewardItemComponent.OnDisable = OnDisable
ValentineRewardItemComponent.ComponentDefine = ComponentDefine
ValentineRewardItemComponent.ComponentDestroy = ComponentDestroy
ValentineRewardItemComponent.DataDefine = DataDefine
ValentineRewardItemComponent.DataDestroy = DataDestroy
ValentineRewardItemComponent.OnAddListener = OnAddListener
ValentineRewardItemComponent.OnRemoveListener = OnRemoveListener
return ValentineRewardItemComponent
