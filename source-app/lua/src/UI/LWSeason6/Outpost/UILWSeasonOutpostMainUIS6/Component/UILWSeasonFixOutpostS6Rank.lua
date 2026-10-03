local UILWSeasonFixOutpostS6Rank = BaseClass("UILWSeasonFixOutpostS6Rank", UIBaseContainer)
local base = UIBaseContainer
local RankItem = require("UI.LWSeason6.Outpost.UILWSeasonOutpostMainUIS6.Component.UILWSeasonFixOutpostS6Item")
local t3_path = "ScrollViewALL/t3"
local t2_path = "ScrollViewALL/t2"
local t1_path = "ScrollViewALL/t1"
local progress_build_path = "ScrollViewALL/progressBuild"
local progress_text_path = "ScrollViewALL/progressBuild/progressBg/progressText"
local content_path = "ScrollViewALL/Viewport/Content"
local btn_back_path = "ScrollViewALL/BtnBack"

function UILWSeasonFixOutpostS6Rank:OnCreate()
  base.OnCreate(self)
  self.t3 = self:AddComponent(UITextMeshProUGUIEx, t3_path)
  self.t2 = self:AddComponent(UITextMeshProUGUIEx, t2_path)
  self.t1 = self:AddComponent(UITextMeshProUGUIEx, t1_path)
  self.progress_build = self:AddComponent(UISlider, progress_build_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(function()
    self:SetActive(false)
    self.gameObject:SetActive(false)
  end)
  self.t3:SetLocalText("war_zone_outpost_7")
  self.t2:SetLocalText("war_zone_outpost_6")
  self.t1:SetLocalText("war_zone_outpost_5")
end

function UILWSeasonFixOutpostS6Rank:OnDestroy()
  self.content:RemoveComponents(RankItem)
  if self.theItemPool ~= nil then
    self.theItemPool:GameObjectRecycleAll()
  end
  self.t3 = nil
  self.t2 = nil
  self.t1 = nil
  self.progress_build = nil
  self.progress_text = nil
  self.content = nil
  self.btn_back = nil
  base.OnDestroy(self)
end

function UILWSeasonFixOutpostS6Rank:ReInit(go, actData, outpostInfo, rankArr)
  if self.theItemPool == nil then
    self.theItemPool = go
    go:GameObjectCreatePool()
  end
  self.content:RemoveComponents(RankItem)
  self.theItemPool:GameObjectRecycleAll()
  if rankArr and 0 < #rankArr then
    table.sort(rankArr, function(a, b)
      return a.rank < b.rank
    end)
    local goItem, theItem
    for i, v in ipairs(rankArr) do
      goItem = self.theItemPool:GameObjectSpawn(self.content.transform)
      goItem.name = "rank_" .. UIUtil.GetLoopListItemIndex()
      goItem:SetActive(true)
      theItem = self.content:AddComponent(RankItem, goItem.name)
      theItem:ReInit(i, rankArr[i], true)
    end
  end
  if actData then
    local needPoint = toInt(actData.para)
    local hasPoint = toInt(outpostInfo.repairScore)
    self.progress_text:SetLocalText("war_zone_outpost_4", hasPoint, needPoint)
    if 0 < needPoint then
      self.progress_build:SetValue(hasPoint / needPoint)
    end
  end
  self.actData = actData
  self.rankArr = rankArr
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return UILWSeasonFixOutpostS6Rank
