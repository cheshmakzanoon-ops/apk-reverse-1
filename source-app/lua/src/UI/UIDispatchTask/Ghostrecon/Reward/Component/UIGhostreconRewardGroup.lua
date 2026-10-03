local UIGhostreconRewardGroup = BaseClass("UIGhostreconRewardGroup", UIBaseContainer)
local base = UIBaseContainer
local u_i_common_res_item1_path = "UICommonResItem1"
local u_i_common_res_item2_path = "UICommonResItem2"
local u_i_common_res_item3_path = "UICommonResItem3"
local u_i_common_res_item4_path = "UICommonResItem4"

function UIGhostreconRewardGroup:OnCreate()
  base.OnCreate(self)
  self.u_i_common_res_item1 = self:AddComponent(UICommonResItem, u_i_common_res_item1_path)
  self.u_i_common_res_item2 = self:AddComponent(UICommonResItem, u_i_common_res_item2_path)
  self.u_i_common_res_item3 = self:AddComponent(UICommonResItem, u_i_common_res_item3_path)
  self.u_i_common_res_item4 = self:AddComponent(UICommonResItem, u_i_common_res_item4_path)
  self.itemList = {}
  table.insert(self.itemList, self.u_i_common_res_item1)
  table.insert(self.itemList, self.u_i_common_res_item2)
  table.insert(self.itemList, self.u_i_common_res_item3)
  table.insert(self.itemList, self.u_i_common_res_item4)
end

function UIGhostreconRewardGroup:OnDestroy()
  self.u_i_common_res_item1 = nil
  self.u_i_common_res_item2 = nil
  self.u_i_common_res_item3 = nil
  self.u_i_common_res_item4 = nil
  base.OnDestroy(self)
end

function UIGhostreconRewardGroup:SetItem(param)
  self.param = param
  local rewardList = param
  if rewardList == nil then
    return
  end
  local rewardCount = #rewardList
  for i = 1, rewardCount do
    local rewardParam = rewardList[i]
    local p = UICommonResItem.Param.New()
    p.rewardType = rewardParam.rewardType
    p.itemId = rewardParam.itemId
    p.count = rewardParam.count
    p.heroUuid = rewardParam.heroUuid
    p.isHeroBox = rewardParam.isHeroBox
    p.bUuid = rewardParam.bUuid
    local cellItem = self.itemList[i]
    cellItem:SetActive(true)
    cellItem.name_text:SetActive(true)
    if p.superReward then
    else
    end
    cellItem:ReInit(p)
  end
  for i = rewardCount + 1, 4 do
    local cellItem = self.itemList[i]
    if cellItem then
      cellItem:SetActive(false)
    end
  end
end

return UIGhostreconRewardGroup
