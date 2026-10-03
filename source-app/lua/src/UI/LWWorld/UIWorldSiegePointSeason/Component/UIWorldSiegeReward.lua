local base = UIAsyncContainer
local UIWorldSiegeReward = BaseClass("UIWorldSiegeReward", base)
local reward_txt_path = "rewardText"
local reward_content_path = "ScrollView/Viewport/rewardContent"

function UIWorldSiegeReward:OnCreate()
  base.OnCreate(self)
  self.reward_txt = self:AddComponent(UIText, reward_txt_path)
  self.scroll_content = self:AddComponent(UIBaseContainer, reward_content_path)
end

function UIWorldSiegeReward:ReInit(rewardStr, the_show_reward_str, data)
  self.cityData = data
  self:RefreshTitleLabel()
  if the_show_reward_str ~= self.the_show_reward_str then
    self.rewardStr = rewardStr
    self.the_show_reward_str = the_show_reward_str
    self:UpdateData()
  end
end

function UIWorldSiegeReward:OnDestroy()
  self:ClearItems()
  self.cityData = nil
  base.OnDestroy(self)
end

function UIWorldSiegeReward:CanDestroyState()
  if self.cityData and self.cityData.type == WorldAllianceCityType.City and DataCenter.SeasonCampDestroyManager:IsEnemyServer(self.cityData.serverId) then
    return true
  end
end

function UIWorldSiegeReward:RefreshTitleLabel()
  if IsNull(self.reward_txt) then
    return
  end
  if self:CanDestroyState() then
    self.reward_txt:SetLocalText("season_s6_activity_1200112_desc09")
  elseif LuaEntry.Player:IsInSourceServer() then
    self.reward_txt:SetLocalText(300702)
  else
    self.reward_txt:SetLocalText("season_ui_desc052")
  end
end

function UIWorldSiegeReward:UpdateData()
  if self:AsyncLoadDone() and self.scroll_content then
    local list = self.rewardStr
    if list == nil then
      self:SetActive(false)
    else
      self:RefreshList(list)
    end
    self:RefreshTitleLabel()
  end
end

function UIWorldSiegeReward:AsyncLoadDone()
  return GameObjectIsValid(self.gameObject)
end

function UIWorldSiegeReward:ClearItems()
  self.scroll_content:RemoveComponents(UICommonResItem)
  if self.items then
    for k, v in pairs(self.items) do
      if v then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.items = {}
end

function UIWorldSiegeReward:RefreshList(list)
  self:ClearItems()
  local parent = self.scroll_content.transform
  local rectTransform = self.scroll_content.rectTransform
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
  for i = 1, table.length(list) do
    self.items[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError or IsNull(parent) or IsNull(rectTransform) then
        return
      end
      local go = request.gameObject
      local name = UIUtil.GetLoopListItemIndex()
      go.gameObject:SetActive(true)
      go.transform:SetParent(parent)
      go.transform:Set_localScale(1, 1, 1)
      go.name = name
      local cellItem = self.scroll_content:AddComponent(UICommonResItem, name)
      cellItem:SetSizeDeltaXY(150, 150)
      cellItem:SetSeasonType(seasonType)
      cellItem:ReInit(list[i])
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(rectTransform)
    end)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scroll_content.rectTransform)
end

return UIWorldSiegeReward
