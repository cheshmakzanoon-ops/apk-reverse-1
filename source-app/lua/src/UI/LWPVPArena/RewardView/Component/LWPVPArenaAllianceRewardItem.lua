local LWPVPArenaAllianceRewardItem = BaseClass("LWPVPArenaAllianceRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function LWPVPArenaAllianceRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleText")
  self.bg = self:AddComponent(UIImage, "Bg")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
end

function LWPVPArenaAllianceRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.bg = nil
  self.rewardScrollContent = nil
end

function LWPVPArenaAllianceRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaAllianceRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaAllianceRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function LWPVPArenaAllianceRewardItem:RefreshReward(list)
  self:SetAllCellDestroy()
  self.showList = DataCenter.RewardManager:ReturnRewardParamForView(list)
  self.model = {}
  if self.showList ~= nil then
    for i = 1, table.length(self.showList) do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.rewardScrollContent.transform)
        go.transform:Set_localScale(0.78, 0.82, 1)
        go.transform:Set_sizeDelta(91, 97)
        go.transform.pivot = Vector2.New(0.5, 0.5)
        go.name = "item" .. i
        local cell = self.rewardScrollContent:AddComponent(UICommonResItem, go.name)
        cell:ReInit(self.showList[i])
      end)
    end
  end
end

function LWPVPArenaAllianceRewardItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  if viewData.minRank ~= viewData.maxRank then
    self.rankingTitleText:SetText(string.format("%d-%d", viewData.minRank, viewData.maxRank))
  else
    self.rankingTitleText:SetText(viewData.minRank)
  end
  local showRankingBgLevel = viewData.minRank
  if viewData.minRank >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:SetActive(true)
  if showRankingBgLevel == 1 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_1.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
  elseif showRankingBgLevel == 2 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_2.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
  elseif showRankingBgLevel == 3 then
    self.rankingTitleBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/lyp_huodong_zqzhg_paihangbang_3.png")
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
  else
    self.rankingTitleBg:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  end
  self:RefreshReward(viewData.reward)
end

return LWPVPArenaAllianceRewardItem
