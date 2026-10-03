local LeagueMatchRewardItem = BaseClass("LeagueMatchRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_path = "rank"
local rankImg_path = "rankImg"
local rewards_path = "rewards/reward_"
local decoration_path = "Rect_Decoration"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.rankN = self:AddComponent(UIText, rank_path)
  self.rankImgN = self:AddComponent(UIImage, rankImg_path)
  self.rewardsTbN = {}
  for i = 1, 8 do
    local reward = self:AddComponent(UICommonResItem, rewards_path .. i)
    table.insert(self.rewardsTbN, reward)
  end
  self._decoration_rect = self:AddComponent(UICommonResItem, decoration_path)
end

local function ComponentDestroy(self)
  self.rankN = nil
  self.rewardsTbN = nil
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

local function SetItem(self, rewardInfo)
  if rewardInfo.start == rewardInfo["end"] then
    if tonumber(rewardInfo.start) <= 3 then
      self.rankImgN:SetActive(true)
      self.rankN:SetText("")
      self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_" .. rewardInfo.start)
    else
      self.rankImgN:SetActive(false)
      self.rankN:SetText(rewardInfo.start)
    end
  else
    self.rankImgN:SetActive(false)
    self.rankN:SetText(rewardInfo.start .. "-" .. rewardInfo["end"])
  end
  local rewardCount = 0
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo.reward)
  if rewardsList ~= nil then
    rewardCount = #rewardsList
    for i, v in ipairs(rewardsList) do
      if v.rewardType == RewardType.GOLD then
        local tempR = v
        table.remove(rewardsList, i)
        table.insert(rewardsList, 1, tempR)
        break
      end
    end
  end
  for i, v in ipairs(self.rewardsTbN) do
    if i <= rewardCount then
      v:SetActive(true)
      v:ReInit(rewardsList[i])
    else
      v:SetActive(false)
    end
  end
  if rewardInfo.titleSkinId then
    local template = DataCenter.DecorationTemplateManager:GetTemplate(tonumber(rewardInfo.titleSkinId))
    if template then
      self._decoration_rect:SetActive(true)
      local param = {}
      param.iconName = template.icon
      param.itemColor = template.quality
      param.rewardType = RewardType.GOODS
      self._decoration_rect:ReInit(param)
    end
  else
    self._decoration_rect:SetActive(false)
  end
end

LeagueMatchRewardItem.OnCreate = OnCreate
LeagueMatchRewardItem.OnDestroy = OnDestroy
LeagueMatchRewardItem.ComponentDefine = ComponentDefine
LeagueMatchRewardItem.ComponentDestroy = ComponentDestroy
LeagueMatchRewardItem.DataDefine = DataDefine
LeagueMatchRewardItem.DataDestroy = DataDestroy
LeagueMatchRewardItem.OnAddListener = OnAddListener
LeagueMatchRewardItem.OnRemoveListener = OnRemoveListener
LeagueMatchRewardItem.SetItem = SetItem
return LeagueMatchRewardItem
