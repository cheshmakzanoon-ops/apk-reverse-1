local UIAllyDuelPersonalRewardItem = BaseClass("UIAllyDuelPersonalRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local rank_path = "RankIconNum"
local rankImg_path = "RankIcon"
local rewards_path = "ScrollRect/ViewPort/Content/reward"
local decoration_path = "Decoration"
local bgImg_path = "bg"

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
  self.bgImgN = self:AddComponent(UIImage, bgImg_path)
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

local function SetItem(self, rewardInfo, myRank)
  if rewardInfo.start == rewardInfo["end"] then
    if tonumber(rewardInfo.start) <= 3 then
      self.rankImgN:SetActive(true)
      self.rankN:SetText(rewardInfo.start)
      self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_" .. rewardInfo.start)
      if rewardInfo.start == 1 then
        self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
      elseif rewardInfo.start == 2 then
        self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
      elseif rewardInfo.start == 3 then
        self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
      end
    else
      self.rankImgN:SetActive(false)
      self.rankN:SetText(rewardInfo.start)
    end
  else
    self.rankImgN:SetActive(false)
    self.rankN:SetText(rewardInfo.start .. "-" .. rewardInfo["end"])
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  local isMe = myRank and myRank >= rewardInfo.start and myRank <= rewardInfo["end"]
  if isMe then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
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

UIAllyDuelPersonalRewardItem.OnCreate = OnCreate
UIAllyDuelPersonalRewardItem.OnDestroy = OnDestroy
UIAllyDuelPersonalRewardItem.ComponentDefine = ComponentDefine
UIAllyDuelPersonalRewardItem.ComponentDestroy = ComponentDestroy
UIAllyDuelPersonalRewardItem.DataDefine = DataDefine
UIAllyDuelPersonalRewardItem.DataDestroy = DataDestroy
UIAllyDuelPersonalRewardItem.OnAddListener = OnAddListener
UIAllyDuelPersonalRewardItem.OnRemoveListener = OnRemoveListener
UIAllyDuelPersonalRewardItem.SetItem = SetItem
return UIAllyDuelPersonalRewardItem
