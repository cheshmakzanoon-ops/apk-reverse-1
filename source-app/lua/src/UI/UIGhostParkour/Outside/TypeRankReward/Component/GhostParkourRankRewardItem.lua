local base = UIBaseContainer
local GhostParkourRankRewardItem = BaseClass("GhostParkourRankRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function GhostParkourRankRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GhostParkourRankRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GhostParkourRankRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgRankingTitleBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRankingTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRankingNormal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.rewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function GhostParkourRankRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgRankingTitleBg = nil
  self.textRankingTitle = nil
  self.textRankingNormal = nil
  self.rewardContent = nil
end

function GhostParkourRankRewardItem:DataDefine()
end

function GhostParkourRankRewardItem:DataDestroy()
end

function GhostParkourRankRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function GhostParkourRankRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GhostParkourRankRewardItem:SetAllCellDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function GhostParkourRankRewardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = DataCenter.RewardManager:ReturnRewardParamForView(list)
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      local index = i
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardContent.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. index
        local cell = self.rewardContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[index])
      end)
    end
  end
end

function GhostParkourRankRewardItem:SetData(viewData, index)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  local showRankingBgLevel = viewData.rankLow
  if viewData.rankLow >= 4 then
    showRankingBgLevel = 4
  end
  if showRankingBgLevel == 1 then
    self:UpdateRankState(true, viewData)
    self.imgRankingTitleBg:LoadSpriteAsync(NewRankIconPath[1])
    self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
  elseif showRankingBgLevel == 2 then
    self:UpdateRankState(true, viewData)
    self.imgRankingTitleBg:LoadSpriteAsync(NewRankIconPath[2])
    self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
  elseif showRankingBgLevel == 3 then
    self:UpdateRankState(true, viewData)
    self.imgRankingTitleBg:LoadSpriteAsync(NewRankIconPath[3])
    self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
  else
    self:UpdateRankState(false, viewData)
    self.imgBg:LoadSpriteAsync("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self:RefreshReward(viewData.reward)
end

function GhostParkourRankRewardItem:UpdateRankState(rankHigh, viewData)
  if rankHigh then
    if viewData.rankLow ~= viewData.rankHigh then
      self.textRankingTitle:SetText(string.format("%d-%d", viewData.rankLow, viewData.rankHigh))
    else
      self.textRankingTitle:SetText(viewData.rankLow)
    end
    self.textRankingTitle.gameObject:SetActive(true)
    self.textRankingNormal.gameObject:SetActive(false)
    self.imgRankingTitleBg:SetActive(true)
  else
    self.imgRankingTitleBg:SetActive(false)
    self.textRankingNormal:SetText(string.format("%d-%d", viewData.rankLow, viewData.rankHigh))
    self.textRankingTitle.gameObject:SetActive(false)
    self.textRankingNormal.gameObject:SetActive(true)
  end
end

return GhostParkourRankRewardItem
