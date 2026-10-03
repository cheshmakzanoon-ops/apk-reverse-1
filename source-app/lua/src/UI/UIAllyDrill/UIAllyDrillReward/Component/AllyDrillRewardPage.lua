local AllyDrillRewardPage = BaseClass("AllyDrillRewardPage", UIBaseContainer)
local base = UIBaseContainer
local AllyDrillRewardItem = require("UI.UIAllyDrill.UIAllyDrillReward.Component.AllyDrillRewardItem")

function AllyDrillRewardPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDrillRewardPage:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDrillRewardPage:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
  self.curContent = self:AddComponent(UIBaseContainer, "Bot/Cur/ScrollRect/ViewPort/curContent")
  self.cur = self:AddComponent(UIBaseComponent, "Bot/Cur")
  self.curRewardValueTxt = self:AddComponent(UIText, "Bot/Cur/damageTxt")
  self.NoneTxt = self:AddComponent(UIText, "Bot/Cur/NoneTxt")
  self.curRewardValueLabel = self:AddComponent(UIText, "Bot/Cur/costTxt")
  self.TipsTxt = self:AddComponent(UIText, "Bot/TipsTxt")
  self.topLabelLeft = self:AddComponent(UIText, "Top/LabelLeft")
  self.topLabelRight = self:AddComponent(UIText, "Top/LabelRight")
end

function AllyDrillRewardPage:ComponentDestroy()
  self:RemoveCurItems()
  self:RemoveRewards()
  self.content = nil
  self.curContent = nil
  self.curRewardValueTxt = nil
  self.cur = nil
end

function AllyDrillRewardPage:DataDefine()
  self.itemReqs = {}
  self.rewardReqs = {}
end

function AllyDrillRewardPage:DataDestroy()
end

function AllyDrillRewardPage:OnAddListener()
  base.OnAddListener(self)
end

function AllyDrillRewardPage:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDrillRewardPage:Refresh(isPerson)
  local bossType = DataCenter.AllyDrillDataManager:GetBossType()
  local stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
  local rewardsList = {}
  local curRewards
  local rewardValue = 0
  local isStart = stage >= AllyDrillStage.AttackStage
  self.cur:SetActive(isStart)
  if not isPerson then
    if bossType == AllyDrillBoss.TankBoss or bossType == AllyDrillBoss.RoadHog then
      local _
      local curTotalDamage = 0
      _, curRewards, _, rewardsList, curTotalDamage = DataCenter.AllyDrillDataManager:GetCurAllyRewardData()
      if isStart then
        self.curRewardValueTxt:SetText(string.GetFormattedStr(curTotalDamage))
      end
      rewardValue = curTotalDamage
      self.curRewardValueLabel:SetLocalText("2010322")
      self.TipsTxt:SetLocalText("2010316")
      self.topLabelLeft:SetLocalText("2010315")
      self.topLabelRight:SetLocalText("2010321")
    elseif bossType == AllyDrillBoss.HugeSandWorm then
      local curAllyS3Reward, realS3Reward, rewardS3List, rewardIndex = DataCenter.AllyDrillDataManager:GetCurAllyS3RewardData()
      curRewards = curAllyS3Reward
      rewardsList = rewardS3List
      local curBossData = DataCenter.AllyDrillDataManager:GetNewBossData()
      local bossStage = curBossData and curBossData.stage or 1
      if isStart then
        self.curRewardValueTxt:SetText(bossStage)
      end
      rewardValue = rewardIndex - 1
      self.curRewardValueLabel:SetLocalText("new_alliance_boss_tips_11")
      self.TipsTxt:SetLocalText("new_alliance_boss_tips_12")
      self.topLabelLeft:SetLocalText("new_alliance_boss_tips_11")
      self.topLabelRight:SetLocalText("2010321")
    end
  else
    local curPersonalReward, rewardList, curPersonalDamage = DataCenter.AllyDrillDataManager:GetCurPersonalRewardData()
    curRewards = curPersonalReward
    rewardsList = rewardList
    rewardValue = curPersonalDamage
    if isStart then
      self.curRewardValueTxt:SetText(string.GetFormattedStr(curPersonalDamage))
    end
    self.curRewardValueLabel:SetLocalText("2010322")
    self.TipsTxt:SetLocalText("2010316")
    self.topLabelLeft:SetLocalText("2010315")
    self.topLabelRight:SetLocalText("2010321")
  end
  curRewards = curRewards or {}
  self.NoneTxt:SetActive(isStart and #curRewards == 0)
  if isStart then
    self:RemoveCurItems()
    local content = self.curContent
    for i = 1, #curRewards do
      self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(content.transform)
        transform:Set_localScale(0.75, 0.75, 1)
        transform:Set_sizeDelta(150, 150)
        transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = content:AddComponent(UICommonResItem, nameStr)
        local data = curRewards[i]
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
  self:RemoveRewards()
  for i = 1, #rewardsList do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/AllyDrillRewardItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(AllyDrillRewardItem, nameStr)
      cell:Refresh(rewardsList[i], rewardValue)
    end)
  end
end

function AllyDrillRewardPage:RemoveCurItems()
  self.curContent:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
    self.itemReqs = {}
  end
end

function AllyDrillRewardPage:RemoveRewards()
  self.content:RemoveComponents(AllyDrillRewardItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
    self.rewardReqs = {}
  end
end

return AllyDrillRewardPage
