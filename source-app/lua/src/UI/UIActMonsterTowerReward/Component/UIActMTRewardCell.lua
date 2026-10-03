local UIArenaRewardCell = BaseClass("UIArenaRewardCell", UIBaseContainer)
local base = UIBaseContainer
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

local function ShowRewards(self, param, isSelf)
  self.titleN:SetLocalText(300665, param.title)
  self.selfRankBgN:SetActive(isSelf)
  self:SetAllRewardsDestroy()
  self.rewardModelCount = 0
  local list = param.reward
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
        local cell = self.contentN:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(list[i])
        table.insert(self.rewardItemsList, cell)
      end)
    end
  end
end

local function SetAllRewardsDestroy(self)
  self.contentN:RemoveComponents(UICommonResItem)
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
