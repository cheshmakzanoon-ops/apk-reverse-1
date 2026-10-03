local NewPeakArenaRewardItem = BaseClass("NewPeakArenaRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")

function NewPeakArenaRewardItem:ComponentDefine()
  self.rankingTitleBg = self:AddComponent(UIImage, "RankingTitleBg")
  self.rankingTitleText = self:AddComponent(UIText, "RankingTitleBg/RankingTitleText")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Viewport/Content")
  self.tipBtn = self:AddComponent(UIButton, "RankingTitleBg/tipBtn")
  self.tipBtn:SetOnClick(function()
    self:OnTipBtnClick()
  end)
end

function NewPeakArenaRewardItem:ComponentDestroy()
  self.rankingTitleBg = nil
  self.rankingTitleText = nil
  self.rewardScrollContent = nil
  self.tipBtn = nil
end

function NewPeakArenaRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function NewPeakArenaRewardItem:OnDestroy()
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaRewardItem:SetAllCellDestroy()
  self.rewardScrollContent:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function NewPeakArenaRewardItem:RefreshReward(list)
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

function NewPeakArenaRewardItem:SetData(viewData)
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

function NewPeakArenaRewardItem:OnTipBtnClick()
  local showStrId = "new_arena_tips_14"
  if self.view.pvpArenaType == PVPArenaType.NewGaleArena then
    if self.viewData.minRank == 1 then
      showStrId = "gale_arena_tips04"
    elseif self.viewData.minRank == 2 then
      showStrId = "gale_arena_tips05"
    elseif self.viewData.minRank == 3 then
      showStrId = "gale_arena_tips06"
    elseif self.viewData.minRank == 4 then
      showStrId = "gale_arena_tips07"
    end
  elseif self.viewData.minRank == 1 then
    showStrId = "new_arena_tips_14"
  elseif self.viewData.minRank == 2 then
    showStrId = "new_arena_tips_15"
  elseif self.viewData.minRank == 3 then
    showStrId = "new_arena_tips_16"
  elseif self.viewData.minRank == 4 then
    showStrId = "new_arena_tips_17"
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

return NewPeakArenaRewardItem
