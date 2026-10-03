local base = UIBaseContainer
local UILWSeasonRainforestKingRewardItem = BaseClass("UILWSeasonRainforestKingRewardItem", base)

function UILWSeasonRainforestKingRewardItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "bg")
  self.effect = self:AddComponent(UIBaseContainer, "effect")
  self.icon = self:AddComponent(UIImage, "Icon")
  self.btn_reward = self:AddComponent(UIButton, "BtnReward")
  self.target_num = self:AddComponent(UITextMeshProUGUIEx, "targetNum")
  self.effect2 = self:AddComponent(UIBaseContainer, "effect2")
  self.btn:SetOnClick(function()
    self:TryShowDetail()
  end)
  self.btn_reward:SetOnClick(function()
    self:TryShowDetail()
  end)
  self.serverId = 0
  self.isCityDestroy = false
  self.isGatherDestroyReward = false
end

function UILWSeasonRainforestKingRewardItem:OnDestroy()
  self.bg = nil
  self.effect = nil
  self.effect2 = nil
  self.icon = nil
  self.btn_reward = nil
  self.target_num = nil
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingRewardItem:RefreshUI(destroyList, gatherDestroyList)
  if destroyList and gatherDestroyList then
    local isCityDestroy = false
    local isGatherDestroyReward = false
    for _, serverId in pairs(destroyList) do
      if toInt(serverId) == self.serverId then
        isCityDestroy = true
        break
      end
    end
    for serverId, time in pairs(gatherDestroyList) do
      if toInt(serverId) == self.serverId then
        isGatherDestroyReward = true
        break
      end
    end
    self.isCityDestroy = isCityDestroy
    self.isGatherDestroyReward = isGatherDestroyReward
    self.effect:SetActive(isCityDestroy and not isGatherDestroyReward)
    self.effect2:SetActive(isCityDestroy and not isGatherDestroyReward)
    if isGatherDestroyReward then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/cell/box_kai.png")
      self.bg:SetColorHex("#D6D8CC")
    else
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/CommonS6/cell/box.png")
      self.bg:SetColorHex("#CCE6B3")
    end
  else
    self.effect:SetActive(false)
    self.effect2:SetActive(false)
  end
end

function UILWSeasonRainforestKingRewardItem:ReInit(campInfo, view)
  self.campInfo = campInfo
  self.pView = view
  self.serverId = campInfo.serverId
  self.effect:SetActive(false)
  self.effect2:SetActive(false)
  self.target_num:SetText("#" .. self.serverId)
end

function UILWSeasonRainforestKingRewardItem:TryShowDetail()
  if self.isCityDestroy then
    if self.isGatherDestroyReward then
      UIUtil.ShowTipsId("richman_boss_desc3")
    else
      SFSNetwork.SendMessage(MsgDefines.FetchRainforestKingBattleGatherDestroyChest, self.serverId)
      return
    end
  end
  if self.campInfo and self.pView then
    self.pView:ShowReward(self.btn_reward)
  end
end

local UILWSeasonRainforestKingRewardRoot = BaseClass("UILWSeasonRainforestKingRewardRoot", base)

function UILWSeasonRainforestKingRewardRoot:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIRawImage, "bg")
  self.tbg = self:AddComponent(UIImage, "tbg")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "tbg/title")
  self.reward_content = self:AddComponent(UIBaseContainer, "RewardContent")
  self.box_item1 = self:AddComponent(UILWSeasonRainforestKingRewardItem, "RewardContent/boxItem1")
  self.box_item2 = self:AddComponent(UILWSeasonRainforestKingRewardItem, "RewardContent/boxItem2")
  self.box_item3 = self:AddComponent(UILWSeasonRainforestKingRewardItem, "RewardContent/boxItem3")
  self.box_item4 = self:AddComponent(UILWSeasonRainforestKingRewardItem, "RewardContent/boxItem4")
  self:InitKingNodes()
end

function UILWSeasonRainforestKingRewardRoot:OnDestroy()
  self.bg = nil
  self.tbg = nil
  self.title = nil
  self.reward_content = nil
  self.box_item1 = nil
  self.box_item2 = nil
  self.box_item3 = nil
  self.box_item4 = nil
  base.OnDestroy(self)
end

function UILWSeasonRainforestKingRewardRoot:InitKingNodes()
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData() or {}
  local dataList = {}
  for k, v in pairs(campInfo) do
    if v.campId ~= myCampId and (SeasonFactionType.Rebels == v.campId or SeasonFactionType.Gendarmerie == v.campId) then
      table.insert(dataList, v)
    end
  end
  table.sort(dataList, function(a, b)
    return a.serverId < b.serverId
  end)
  for index, v in ipairs(dataList) do
    local node = self["box_item" .. index]
    if node then
      node:ReInit(v, self)
    end
  end
  self:RefreshUI()
end

function UILWSeasonRainforestKingRewardRoot:RefreshUI()
  local data = DataCenter.SeasonRainforestKingBattleManager:GetBattleInfo(false, false)
  if data then
    for i = 1, 4 do
      local node = self["box_item" .. i]
      if node then
        node:RefreshUI(data.destroyList, data.gatherDestroyList)
      end
    end
  end
end

function UILWSeasonRainforestKingRewardRoot:ReInit(kingRewardData)
  self.kingRewardData = kingRewardData
end

function UILWSeasonRainforestKingRewardRoot:ShowReward(node)
  if self.kingRewardData then
    local data = self.kingRewardData
    local position = node:GetPosition()
    UIUtil.ShowLootRewardList(position, data, 0)
  end
end

return UILWSeasonRainforestKingRewardRoot
