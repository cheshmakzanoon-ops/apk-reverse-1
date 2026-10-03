local LWUIOptionalWeekCardRewardItemRender = BaseClass("LWUIOptionalWeekCardRewardItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_common_res_item_path = "UICommonResItem"
local delete_btn_path = "DeleteBtn"
local add_btn_path = "AddBtn"
local select_state_path = "SelectState"
local select_btn_path = "SelectBtn"

function LWUIOptionalWeekCardRewardItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUIOptionalWeekCardRewardItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIOptionalWeekCardRewardItemRender:ComponentDefine()
  self.ani = self.transform:Find(""):GetComponent(typeof(CS.SimpleAnimation))
  self.ui_common_res_item = self:AddComponent(UICommonResItem, ui_common_res_item_path)
  self.delete_btn = self:AddComponent(UIButton, delete_btn_path)
  self.delete_btn:SetOnClick(function()
    self:DeleteBtnClick()
  end)
  self.delete_btn:SetSafeClickMode(true)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:AddBtnClick()
  end)
  self.select_state = self:AddComponent(UIImage, select_state_path)
  self.select_btn = self:AddComponent(UIButton, select_btn_path)
  self.select_btn:SetSafeClickMode(true)
  self.select_btn:SetOnClick(function()
    self:SelectBtnClick()
  end)
  self.compRewardChangeNew = self:AddComponent(UIBaseComponent, "RewardChangeNew")
  self.compEffAccuRechargeJiantou = self:AddComponent(UIBaseComponent, "Eff_AccuRecharge_jiantou")
  self.compEffUiAccuRechargeNew01 = self:AddComponent(UIBaseComponent, "Eff_ui_AccuRecharge_new01")
end

function LWUIOptionalWeekCardRewardItemRender:ComponentDestroy()
  self.ani = nil
  self.ui_common_res_item = nil
  self.delete_btn = nil
  self.add_btn = nil
  self.select_state = nil
  self.select_btn = nil
  self.compRewardChangeNew = nil
  self.compEffAccuRechargeJiantou = nil
  self.compEffUiAccuRechargeNew01 = nil
end

function LWUIOptionalWeekCardRewardItemRender:ReInit(activityId, index, cardId, rewardData, isChoose, isShowDelete, isOperate, addBtnAction)
  self.activityId = activityId
  self.index = index
  self.cardId = cardId
  self.isChoose = isChoose
  self.addBtnAction = addBtnAction
  self.rewardData = rewardData
  self.ui_common_res_item:SetActive(rewardData)
  self.add_btn:SetActive(not rewardData)
  if rewardData then
    self.ui_common_res_item:ReInit(rewardData)
  else
    self.ani:Play("Default")
  end
  self.delete_btn:SetActive(isShowDelete)
  self.select_state:SetActive(isChoose)
  self.select_btn:SetActive(isOperate)
  self.compEffAccuRechargeJiantou:SetActive(false)
  self.compEffUiAccuRechargeNew01:SetActive(false)
  self.compRewardChangeNew:SetActive(false)
end

function LWUIOptionalWeekCardRewardItemRender:DeleteBtnClick()
  DataCenter.LWOptionalWeekCardManager:DeleteSelectReward(self.activityId, self.cardId, self.index)
  local param = {}
  param.cardId = self.cardId
  param.isDelete = true
  EventManager:GetInstance():Broadcast(EventId.RefreshOptionalWeekCardRewardSelect, param)
end

function LWUIOptionalWeekCardRewardItemRender:AddBtnClick()
  if self.addBtnAction ~= nil then
    self.addBtnAction()
  end
end

function LWUIOptionalWeekCardRewardItemRender:SelectBtnClick()
  if self.isChoose then
    self.isChoose = false
  else
    local weekCardInfo = DataCenter.LWOptionalWeekCardManager:GetWeekCardDataById(self.activityId, self.cardId)
    if weekCardInfo ~= nil then
      local optionalRewardCount = weekCardInfo:GetAlreadyChooseRewardCount()
      if optionalRewardCount >= weekCardInfo.optionalNum then
        UIUtil.ShowTipsId("activity_98600_desc12")
        return
      end
    end
    self.isChoose = true
  end
  self.select_state:SetActive(self.isChoose)
  DataCenter.LWOptionalWeekCardManager:SetSelectReward(self.activityId, self.cardId, self.index, self.isChoose)
  local param = {}
  param.cardId = self.cardId
  EventManager:GetInstance():Broadcast(EventId.RefreshOptionalWeekCardRewardSelect, param)
end

function LWUIOptionalWeekCardRewardItemRender:PlayUpdateEffect()
  self.compEffAccuRechargeJiantou:SetActive(false)
  self.compEffUiAccuRechargeNew01:SetActive(false)
  self.compEffAccuRechargeJiantou:SetActive(true)
  self.compEffUiAccuRechargeNew01:SetActive(true)
end

function LWUIOptionalWeekCardRewardItemRender:PlayNewEffect()
  self.compRewardChangeNew:SetActive(false)
  self.compRewardChangeNew:SetActive(true)
end

function LWUIOptionalWeekCardRewardItemRender:GetItemId()
  if self.rewardData then
    return checknumber(self.rewardData.itemId)
  end
end

return LWUIOptionalWeekCardRewardItemRender
