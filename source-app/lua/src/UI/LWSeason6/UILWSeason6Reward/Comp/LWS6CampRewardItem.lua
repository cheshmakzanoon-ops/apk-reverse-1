local LWS6CampRewardItem = BaseClass("LWS6CampRewardItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "bg"
local u_i_common_res_item_path = "bg/UICommonResItem"
local content_path = "bg/Content"
local title_path = "bg/Image/title"
local title1_path = "bg/content_condition/title1"
local title2_path = "bg/content_condition/title2"
local p_go_cur_tier_path = "bg/content_condition/p_go_cur_tier"
local content_condition_path = "bg/content_condition"

function LWS6CampRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWS6CampRewardItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWS6CampRewardItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.p_go_cur_tier = self:AddComponent(UIImage, p_go_cur_tier_path)
  self.content_condition = self:AddComponent(UIImage, content_condition_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.common_res_item = self.transform:Find(u_i_common_res_item_path).gameObject
  self.common_res_item:GameObjectCreatePool()
end

function LWS6CampRewardItem:ComponentDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.content = nil
  if self.common_res_item then
    self.common_res_item:GameObjectRecycleAll()
  end
  self.common_res_item = nil
  self.bg = nil
  self.title = nil
  self.title1 = nil
  self.title2 = nil
  self.p_go_cur_tier = nil
  self.content_condition = nil
  self.content = nil
end

function LWS6CampRewardItem:ReInit(data)
  self.title:SetText(data.title1)
  self.title1:SetText(data.title2)
  self.title2:SetText(data.title2)
  self.title1:SetActive(not data.isCur)
  self.title2:SetActive(data.isCur)
  local reward = data.data.reward
  self.content:RemoveComponents(UICommonResItem)
  self.common_res_item:GameObjectRecycleAll()
  self.content:SetAnchoredPositionXY(0, 0)
  if reward then
    for index, value in ipairs(reward) do
      local go = self.common_res_item:GameObjectSpawn(self.content.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(0.86, 0.86, 0.86)
      go.name = "item" .. tostring(index)
      local cell = self.content:AddComponent(UICommonResItem, go.name)
      cell:ReInit(value)
    end
  end
  self.p_go_cur_tier:SetActive(data.isCur)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_condition.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.transform)
end

return LWS6CampRewardItem
