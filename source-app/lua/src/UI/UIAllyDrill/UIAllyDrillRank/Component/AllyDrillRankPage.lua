local AllyDrillRankPage = BaseClass("AllyDrillRankPage", UIBaseContainer)
local base = UIBaseContainer
local AllyDrillRankItem = require("UI.UIAllyDrill.UIAllyDrillRank.Component.AllyDrillRankItem")
local Localization = CS.GameEntry.Localization

function AllyDrillRankPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDrillRankPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDrillRankPage:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "TopView/slider")
  self.sliderTxt = self:AddComponent(UIText, "TopView/sliderTxt")
  self.SliderTitle = self:AddComponent(UIText, "TopView/sliderTitle")
  self.curReward = self:AddComponent(UIBaseContainer, "TopView/rewardView/Viewport/Content")
  self.bonusTxt = self:AddComponent(UIText, "TopView/layoutNode/bonusTxt")
  self.bonusNode = self:AddComponent(UIBaseContainer, "TopView/layoutNode")
  self.infoBtn = self:AddComponent(UIButton, "TopView/InfoBtn")
  self.infoBtn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.bonusBtn = self:AddComponent(UIButton, "TopView/bonusBtn")
  self.bonusBtn:SetOnClick(function()
    self:OnClickBonusBtn()
  end)
  self.items = {}
  self.content = self:AddComponent(UIBaseContainer, "AllyScroll/ViewPort/AllyContent")
  self.loopListView = self:AddComponent(UILoopListView2, "AllyScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.selfRank = self:AddComponent(AllyDrillRankItem, "SelfObj")
  self.emptyTxt = self:AddComponent(UIBaseComponent, "EmptyTxt")
  self.selfTxt = self:AddComponent(UITextMeshProUGUIEx, "text")
  self.tipsTxt = self:AddComponent(UITextMeshProUGUIEx, "tipsTxt")
  self.sliderFillImg = self:AddComponent(UIImage, "TopView/slider/FillArea/Fill")
end

function AllyDrillRankPage:ComponentDestroy()
  self:RemoveCurReward()
  self:RemoveRanks()
  self.curReward = nil
  self.loopListView = nil
  self.bonusNode = nil
end

function AllyDrillRankPage:DataDefine()
  self.itemReqs = {}
end

function AllyDrillRankPage:DataDestroy()
end

function AllyDrillRankPage:OnAddListener()
  base.OnAddListener(self)
end

function AllyDrillRankPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDrillRankPage:Refresh()
  self.actInfo = DataCenter.AllyDrillDataManager:GetActInfo()
  self.bossType = DataCenter.AllyDrillDataManager:GetBossType()
  self.rankData = DataCenter.AllyDrillDataManager:GetRankData()
  if self.rankData and self.rankData.topList then
    for i = 1, #self.rankData.topList do
      if self.rankData.topList[i].uid == LuaEntry.Player.uid then
        self.myRankData = self.rankData.topList[i]
      end
    end
  end
  if not self.actInfo.data then
    return
  end
  local realReward
  if self.bossType == AllyDrillBoss.TankBoss or self.bossType == AllyDrillBoss.RoadHog then
    self.sliderFillImg:SetColorRGBA(0.28, 1, 0.2, 1)
    local nextTotalDamage = 0
    self.curAllyReward, realReward, nextTotalDamage = DataCenter.AllyDrillDataManager:GetCurAllyRewardData()
    local curTotalDamage = self.actInfo.data.totalDamage
    local curBonus = math.max(1, self.actInfo.data.currBonus)
    if nextTotalDamage < 0 then
      self.slider:SetValue(1)
      self.sliderTxt:SetText(string.GetFormattedStr(curTotalDamage) .. "/...")
    else
      self.slider:SetValue(curTotalDamage / nextTotalDamage)
      self.sliderTxt:SetText(string.GetFormattedStr(curTotalDamage) .. "/" .. string.GetFormattedStr(nextTotalDamage))
    end
    self.bonusTxt:SetLocalText(2010335, curBonus)
    self.bonusNode:SetActive(true)
    self.bonusBtn:SetActive(true)
    self.SliderTitle:SetLocalText("2010312")
    self.tipsTxt:SetLocalText("2010316")
  elseif self.bossType == AllyDrillBoss.HugeSandWorm then
    self.sliderFillImg:SetColorRGBA(1, 0, 0, 1)
    self.curAllyReward, realReward = DataCenter.AllyDrillDataManager:GetCurAllyS3RewardData()
    local curBossData = DataCenter.AllyDrillDataManager:GetNewBossData()
    local totalHp = curBossData and curBossData.totalHp or 1
    local curHp = curBossData and curBossData.curHp or 1
    self.slider:SetValue(curHp / totalHp)
    self.sliderTxt:SetText(string.GetFormattedStr(curHp) .. "/" .. string.GetFormattedStr(totalHp))
    self.bonusNode:SetActive(false)
    self.bonusBtn:SetActive(false)
    self.SliderTitle:SetLocalText("new_alliance_boss_tips_10", curBossData.stage)
    self.tipsTxt:SetLocalText("new_alliance_boss_tips_12")
  end
  local rankList = self.rankData and self.rankData.topList
  self:RemoveCurReward()
  self:RemoveRanks()
  if self.curAllyReward then
    for i = 1, #self.curAllyReward do
      self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(self.curReward.transform)
        transform:Set_localScale(0.75, 0.75, 1)
        transform:Set_sizeDelta(150, 150)
        transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.curReward:AddComponent(UICommonResItem, nameStr)
        local data = self.curAllyReward[i]
        local param = UICommonResItem.Param.New()
        param.rewardType = data.type
        if type(data.value) == "table" then
          param.itemId = data.value.id
          param.count = data.value.num
        else
          param.itemId = data.type
          param.count = data.value
        end
        param.rewardType = data.type
        param.heroUuid = data.heroUuid
        param.isHeroBox = data.isHeroBox
        cell:ReInit(param)
      end)
    end
  end
  self.emptyTxt:SetActive(not rankList or #rankList == 0)
  if rankList and 0 < #rankList then
    self.loopListView:SetListItemCount(#rankList, false, false)
    self.loopListView:RefreshAllShownItem()
  end
  local stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
  local isStart = stage >= AllyDrillStage.AttackStage
  if isStart then
    if self.myRankData then
      self.selfRank:SetActive(true)
      self.selfRank:Refresh(self.myRankData)
    else
      self.selfRank:SetActive(false)
      self.selfTxt:SetLocalText(361054)
    end
  else
    self.selfRank:SetActive(false)
    self.selfTxt:SetLocalText(2010369)
  end
end

function AllyDrillRankPage:GetScrollItem(listview, index)
  local dataList = self.rankData.topList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem(index == 1 and "TopRankItem" or "NormalRankItem")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "NormalRankItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(AllyDrillRankItem, nameStr)
  end
  self.items[csItem]:Refresh(dataList[index])
  return csItem
end

function AllyDrillRankPage:RemoveCurReward()
  self.curReward:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
    self.itemReqs = {}
  end
end

function AllyDrillRankPage:RemoveRanks()
  self.items = {}
  self.content:RemoveComponents(AllyDrillRankItem)
  self.loopListView:ClearAllItems()
end

function AllyDrillRankPage:OnClickInfoBtn()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillReward, {anim = true})
end

function AllyDrillRankPage:OnClickBonusBtn()
  local curBonus = self.actInfo.data.currBonus
  local pos = self.bonusBtn:GetPosition()
  local meta = DataCenter.AllyDrillDataManager:GetCfg(self.actInfo.data.difficultyLevel)
  local curStage = 1
  for i = 1, #meta.alliance_bonus do
    if meta.alliance_bonus[i].bonus == curBonus then
      curStage = i
      break
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillMvpTip, {anim = true}, pos, meta, curStage)
end

return AllyDrillRankPage
