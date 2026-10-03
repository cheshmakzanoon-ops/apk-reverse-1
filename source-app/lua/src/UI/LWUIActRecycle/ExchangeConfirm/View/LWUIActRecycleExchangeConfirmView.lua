local LWUIActRecycleExchangeConfirmView = BaseClass("LWUIActRecycleExchangeConfirmView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local UISliderBtnInputField = require("Framework.UI.Component.UISliderBtnInputField")

function LWUIActRecycleExchangeConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

function LWUIActRecycleExchangeConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIActRecycleExchangeConfirmView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCommonActivityPopUpBgPart = self.viewSkin:AddComponent(self, CommonActivityPopUpBgPart, 1)
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.compUICommonResItem01 = self.viewSkin:AddComponent(self, UICommonResItem, 3)
  self.compUICommonResItem02 = self.viewSkin:AddComponent(self, UICommonResItem, 4)
  self.compUISliderBtnInputField = self.viewSkin:AddComponent(self, UISliderBtnInputField, 5)
  self.btnLWCommonNew = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnLWCommonNew:SetOnClick(function()
    self:OnBtnLWCommonNewClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgLWBtnCommonNewBase = self.viewSkin:AddComponent(self, UIImage, 8)
  self.imgArrow = self.viewSkin:AddComponent(self, UIImage, 9)
end

function LWUIActRecycleExchangeConfirmView:ComponentDestroy()
  self.viewSkin = nil
  self.compCommonActivityPopUpBgPart = nil
  self.btnUICommonBlackMask = nil
  self.compUICommonResItem01 = nil
  self.compUICommonResItem02 = nil
  self.compUISliderBtnInputField = nil
  self.btnLWCommonNew = nil
  self.textBtn = nil
  self.imgLWBtnCommonNewBase = nil
  self.imgArrow = nil
end

function LWUIActRecycleExchangeConfirmView:DataDefine()
  self.param = nil
  self.time = 0
end

function LWUIActRecycleExchangeConfirmView:DataDestroy()
  self.param = nil
  self.time = nil
end

function LWUIActRecycleExchangeConfirmView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccess)
end

function LWUIActRecycleExchangeConfirmView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActRecycleExchangeSuccessMsg, self.OnExchangeSuccess)
  base.OnRemoveListener(self)
end

function LWUIActRecycleExchangeConfirmView:OnOpen()
  self.param = self:GetUserData()
  self.compCommonActivityPopUpBgPart:InitByActivityId(self.param.activityId)
  self.compCommonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  self.compUICommonResItem01:ReInit(self.param.cost)
  self.compUICommonResItem02:ReInit(self.param.reward)
  local haveCount = 0
  if self.param.cost.rewardType == RewardType.GOODS then
    haveCount = DataCenter.ItemData:GetItemCount(self.param.cost.itemId)
  elseif self.param.cost.rewardType == RewardType.RESOURCE_ITEM then
    haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(self.param.cost.itemId)
  elseif RewardToResType[self.param.cost.rewardType] then
    haveCount = LuaEntry.Resource:GetCntByResType(RewardToResType[self.param.cost.rewardType])
  end
  local maxExchangeTime = 0
  if self.param.leftExchangeTime ~= nil then
    maxExchangeTime = math.min(math.floor(haveCount / self.param.cost.count), self.param.leftExchangeTime)
  else
    maxExchangeTime = math.floor(haveCount / self.param.cost.count)
  end
  if maxExchangeTime <= 0 then
    self.ctrl:CloseSelf()
    return
  end
  self.compUISliderBtnInputField:Init(1, maxExchangeTime, 1, function(num)
    self.time = num
    self.compUISliderBtnInputField:SetTipText(tostring(self.time))
    self:OnSliderChange()
  end)
  self.time = 1
  if self.param.shop_type == 1 then
    self.compCommonActivityPopUpBgPart:SetTitle("activity_99165_train3_1_title")
    self.imgLWBtnCommonNewBase:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
    self.textBtn:SetLocalText("activity_99165_train3_2_btn", self.time)
  else
    self.compCommonActivityPopUpBgPart:SetTitle("activity_99165_train3_3_title")
    self.imgLWBtnCommonNewBase:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
    self.textBtn:SetLocalText("activity_99165_train3_4_btn", self.time)
  end
  local arrowImagePath = UIAssets.ActRecycleExchangeArrowDefaultImage
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.param.activityId)
  if activityInfo ~= nil then
    local mainTemplate = DataCenter.ActRecycleManager:GetActivityCycleTemplateById(activityInfo.subType)
    if mainTemplate ~= nil and not string.IsNullOrEmpty(mainTemplate.res_aro) then
      arrowImagePath = mainTemplate.res_aro
    end
  end
  self.imgArrow:LoadSpriteAsync(arrowImagePath)
end

function LWUIActRecycleExchangeConfirmView:OnSliderChange()
  self.compUICommonResItem01:SetItemCount(self.param.cost.count * self.time)
  self.compUICommonResItem02:SetItemCount(self.param.reward.count * self.time)
  if self.param.shop_type == 1 then
    self.textBtn:SetLocalText("activity_99165_train3_2_btn", self.time)
  else
    self.textBtn:SetLocalText("activity_99165_train3_4_btn", self.time)
  end
end

function LWUIActRecycleExchangeConfirmView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleExchangeConfirmView:OnExchangeSuccess()
  self.ctrl:CloseSelf()
end

function LWUIActRecycleExchangeConfirmView:OnBtnLWCommonNewClick()
  self.param.callback(self.time)
end

return LWUIActRecycleExchangeConfirmView
