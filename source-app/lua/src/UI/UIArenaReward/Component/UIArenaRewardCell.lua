local UIArenaRewardCell = BaseClass("UIArenaRewardCell", UIBaseContainer)
local base = UIBaseContainer
local MailRewardItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem")
local titleTxt_path = "rewardBg/TitleBg/Title"
local tipTxt_path = "Tip"
local content_path = "rewardBg/Rewards"
local selfRankBg_path = "rewardBg/selfRankBg"

local function OnCreate(self)
  base.OnCreate(self)
  self.rewardModels = {}
  self.rewardItemsList = {}
  self.titleN = self:AddComponent(UIText, titleTxt_path)
  self.tipN = self:AddComponent(UIText, tipTxt_path)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.selfRankBgN = self:AddComponent(UIBaseContainer, selfRankBg_path)
end

local function OnDestroy(self)
  self.rewardModels = nil
  self.rewardItemsList = nil
  self.titleN = nil
  self.tipN = nil
  self.contentN = nil
  base.OnDestroy(self)
end

local function ShowRewards(self, title, rewards, hideCount)
  local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
  local strTitle = string.split(title, "-")
  if tonumber(strTitle[1]) == tonumber(strTitle[2]) then
    self.titleN:SetLocalText(280138, strTitle[1])
    local isSelfRank = selfInfo.selfRank >= tonumber(strTitle[1]) and selfInfo.selfRank <= tonumber(strTitle[2])
    self.selfRankBgN:SetActive(isSelfRank)
  elseif #strTitle == 1 then
    self.titleN:SetLocalText(372278, strTitle[1])
    self.selfRankBgN:SetActive(selfInfo.selfRank == tonumber(strTitle[1]))
  else
    self.selfRankBgN:SetActive(selfInfo.selfRank == tonumber(strTitle[1]))
    self.titleN:SetLocalText(280138, title)
  end
  self.tipN:SetActive(false)
  local list = {}
  local strReward = string.split(rewards, ";")
  for i = 1, #strReward do
    list[i] = {}
    local str = string.split(strReward[i], ",")
    list[i].itemId = tonumber(str[1])
    list[i].rewardType = tonumber(str[2])
    list[i].count = tonumber(str[3])
  end
  self:SetAllRewardsDestroy()
  self.rewardModelCount = 0
  if list ~= nil and 0 < #list then
    for i = 1, table.length(list) do
      self.rewardModelCount = self.rewardModelCount + 1
      self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.contentN.transform)
        go.transform.localScale = Vector3.New(0.54, 0.54, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.contentN:AddComponent(MailRewardItem, nameStr)
        cell:ShowCount(hideCount)
        local param = {}
        param.itemId = list[i].itemId
        param.rewardType = list[i].rewardType
        param.count = list[i].count
        cell:RefreshData(param)
        cell:SetNameText("")
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
        EventManager:GetInstance():Broadcast(EventId.AllianceCompeteRewardsReposition)
        table.insert(self.rewardItemsList, cell)
      end)
    end
  end
end

local function SetAllRewardsDestroy(self)
  self.contentN:RemoveComponents(MailRewardItem)
  if self.rewardModels ~= nil then
    for k, v in pairs(self.rewardModels) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardModels = {}
  self.rewardItemsList = {}
end

UIArenaRewardCell.OnCreate = OnCreate
UIArenaRewardCell.OnDestroy = OnDestroy
UIArenaRewardCell.ShowRewards = ShowRewards
UIArenaRewardCell.SetAllRewardsDestroy = SetAllRewardsDestroy
return UIArenaRewardCell
