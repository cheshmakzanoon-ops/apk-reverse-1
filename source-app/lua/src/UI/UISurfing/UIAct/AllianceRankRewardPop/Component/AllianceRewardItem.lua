local base = UIBaseContainer
local AllianceRewardItem = BaseClass("AllianceRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function AllianceRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllianceRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AllianceRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.rankingTitleBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textRankingTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textRankingNormal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.rewardScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
end

function AllianceRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.rankingTitleBg = nil
  self.textRankingTitle = nil
  self.textRankingNormal = nil
  self.rewardScrollContent = nil
end

function AllianceRewardItem:DataDefine()
end

function AllianceRewardItem:DataDestroy()
end

function AllianceRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function AllianceRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllianceRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function AllianceRewardItem:RefreshReward(list)
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

function AllianceRewardItem:SetData(viewData, index)
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
    self.rankingTitleBg:LoadSprite(NewRankIconPath[1])
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_1.png")
  elseif showRankingBgLevel == 2 then
    self:UpdateRankState(true, viewData)
    self.rankingTitleBg:LoadSprite(NewRankIconPath[2])
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_2.png")
  elseif showRankingBgLevel == 3 then
    self:UpdateRankState(true, viewData)
    self.rankingTitleBg:LoadSprite(NewRankIconPath[3])
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_3.png")
  else
    self:UpdateRankState(false, viewData)
    self.imgBg:LoadSprite("Assets/Main/Sprites/UI/UIRank/ljq_tongyong_paihangbang_4.png")
  end
  self:RefreshReward(viewData.reward)
end

function AllianceRewardItem:UpdateRankState(rankHigh, viewData)
  if rankHigh then
    if viewData.rankLow ~= viewData.rankHigh then
      self.textRankingTitle:SetText(string.format("%d-%d", viewData.rankLow, viewData.rankHigh))
    else
      self.textRankingTitle:SetText(viewData.rankLow)
    end
    self.textRankingTitle.gameObject:SetActive(true)
    self.textRankingNormal.gameObject:SetActive(false)
    self.rankingTitleBg:SetActive(true)
  else
    self.rankingTitleBg:SetActive(false)
    self.textRankingNormal:SetText(string.format("%d-%d", viewData.rankLow, viewData.rankHigh))
    self.textRankingTitle.gameObject:SetActive(false)
    self.textRankingNormal.gameObject:SetActive(true)
  end
end

return AllianceRewardItem
