local AllyDuelLeaguePersonalRewardItem = BaseClass("AllyDuelLeaguePersonalRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function AllyDuelLeaguePersonalRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeaguePersonalRewardItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeaguePersonalRewardItem:ComponentDefine()
  self.rankN = self:AddComponent(UIText, "RankIconNum")
  self.rankImgN = self:AddComponent(UIImage, "RankIcon")
  self.bgImgN = self:AddComponent(UIImage, "bg")
  self.content = self:AddComponent(UIBaseContainer, "ScrollRect/ViewPort/Content")
end

function AllyDuelLeaguePersonalRewardItem:ComponentDestroy()
  self:RemoveReward()
end

function AllyDuelLeaguePersonalRewardItem:DataDefine()
end

function AllyDuelLeaguePersonalRewardItem:DataDestroy()
end

function AllyDuelLeaguePersonalRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelLeaguePersonalRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelLeaguePersonalRewardItem:SetItem(rewardInfo, isMineRange)
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
  local curRankInAlly = DataCenter.LeagueMatchManager:GetCurRankInAlly()
  local isMe = isMineRange and curRankInAlly and curRankInAlly >= rewardInfo.start and curRankInAlly <= rewardInfo["end"]
  if isMe then
    self.bgImgN:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
  end
  self:RefreshReward(rewardInfo)
end

function AllyDuelLeaguePersonalRewardItem:RemoveReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
  end
  self.itemReqs = {}
end

function AllyDuelLeaguePersonalRewardItem:RefreshReward(rewardInfo)
  self:RemoveReward()
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo.reward) or {}
  for i, v in ipairs(rewardsList) do
    if v.rewardType == RewardType.GOLD then
      local tempR = v
      table.remove(rewardsList, i)
      table.insert(rewardsList, 1, tempR)
      break
    end
  end
  for i = 1, #rewardsList do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(0.75, 0.75, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      cell:ReInit(rewardsList[i])
    end)
  end
end

return AllyDuelLeaguePersonalRewardItem
