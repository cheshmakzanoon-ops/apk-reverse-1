local UIActMonopolyBoxRewardContent = BaseClass("UIActMonopolyBoxRewardContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_common_res_item_path = "UICommonResItem"
local content_path = "scrollView/Viewport/Content"
local reward_cell_list_path = "scrollView/Viewport/Content/rewardCellList"
local bottom_btn_path = "bottomBtn"

function UIActMonopolyBoxRewardContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UIActMonopolyBoxRewardContent:OnDestroy()
  self:ClearAllItem()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActMonopolyBoxRewardContent:ComponentDefine()
  self.u_i_common_res_item = self:AddComponent(UIBaseContainer, u_i_common_res_item_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.reward_cell_list = self:AddComponent(UIBaseContainer, reward_cell_list_path)
  self.cellList = {}
  self.u_i_common_res_item:SetActive(false)
  self.u_i_common_res_item.gameObject:GameObjectCreatePool()
  self.bottom_btn = self:AddComponent(UIButton, bottom_btn_path)
  self.bottom_btn:SetOnClick(function()
    self:OnBottomBtnClick()
  end)
end

function UIActMonopolyBoxRewardContent:ComponentDestroy()
  self.u_i_common_res_item = nil
  self.content = nil
  self.reward_cell_list = nil
  self.bottom_btn = nil
end

function UIActMonopolyBoxRewardContent:DataDefine()
  self.activityId = nil
  self.activityDetailData = nil
  self.showData = nil
end

function UIActMonopolyBoxRewardContent:DataDestroy()
  self.activityId = nil
  self.activityDetailData = nil
  self.showData = nil
end

function UIActMonopolyBoxRewardContent:ClearAllItem()
  self.reward_cell_list:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.reward_cell_list.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.u_i_common_res_item.gameObject:GameObjectRecycleAll()
  self.cellList = {}
end

function UIActMonopolyBoxRewardContent:ReInit(activityId)
  self.activityId = activityId
  self.activityDetailData = DataCenter.ActMonopolyDataManager:GetActData(self.activityId)
  local rewardData = self.activityDetailData.damageReward
  local isComplete = self.activityDetailData.isDamageRewardDataComplete
  if isComplete then
    self.showData = DataCenter.RewardManager:ReturnRewardParamForView(rewardData)
  else
    self.showData = {}
  end
  self.content:SetAnchoredPositionXY(0, 0)
  self:ClearAllItem()
  for showIndex, v in ipairs(self.showData) do
    local item = self.u_i_common_res_item.gameObject:GameObjectSpawn(self.reward_cell_list.transform)
    item.name = showIndex
    local obj = self.reward_cell_list:AddComponent(UICommonResItem, item.name)
    obj:SetActive(true)
    self.cellList[showIndex] = obj
    obj:ReInit(v)
  end
end

function UIActMonopolyBoxRewardContent:OnBottomBtnClick()
  SFSNetwork.SendMessage(MsgDefines.RichManDamageRewardReceive, self.activityId)
  self.view.ctrl:CloseSelf()
end

return UIActMonopolyBoxRewardContent
