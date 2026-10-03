local LWPVPArenaRewardItem = BaseClass("LWPVPArenaRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

function LWPVPArenaRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
  self.tipBtn = self:AddComponent(UIButton, "RankingTitleBg/tipBtn")
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function LWPVPArenaRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
  self.tipBtn = nil
end

function LWPVPArenaRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function LWPVPArenaRewardItem:RefreshReward(list)
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

function LWPVPArenaRewardItem:SetData(viewData)
  if not viewData then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.viewData = viewData
  local showRankingBgLevel = viewData.minRank
  if viewData.minRank >= 4 then
    showRankingBgLevel = 4
  end
  self.rankingTitleBg:LoadSprite(string.format("Assets/Main/Sprites/UI/UIActivity/lyp_huodong_zqzhg_paihangbang_jiangli_%d.png", showRankingBgLevel))
  self:RefreshReward(viewData.reward)
  local rankTitleStrId = 500244
  if self.viewData.minRank == 1 then
    rankTitleStrId = 500241
  elseif self.viewData.minRank == 2 then
    rankTitleStrId = 500242
  elseif self.viewData.minRank == 3 then
    rankTitleStrId = 500243
  end
  self.rankingTitleText:SetLocalText(rankTitleStrId)
  self.tipBtn:SetActive(self.viewData.minRank <= 4)
end

function LWPVPArenaRewardItem:OnTipBtnClick()
  local showStrId = "500245"
  if self.viewData.minRank == 1 then
    showStrId = "500245"
  elseif self.viewData.minRank == 2 then
    showStrId = "500246"
  elseif self.viewData.minRank == 3 then
    showStrId = "500247"
  elseif self.viewData.minRank == 4 then
    showStrId = "500248"
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.tipBtn.transform.position + Vector3.New(0, 10, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString(showStrId)
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

return LWPVPArenaRewardItem
