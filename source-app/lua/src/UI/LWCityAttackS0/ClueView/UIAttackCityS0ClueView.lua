local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIAttackCityS0ClueView = BaseClass("UIAttackCityS0ClueView", base)
local CompItem = require("UI.LWCityAttackS0.ClueView.Component.ItemComponent")
local Localization = CS.GameEntry.Localization
local Width = 690
local spacingX = 0
local cellHeight = 136

function UIAttackCityS0ClueView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0ClueView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0ClueView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgMap = self:AddComponent(UIImage, "root/RightView/imgMap")
  self.imgReward = self.viewSkin:AddComponent(self, UIImage, 1)
  self.gridLayoutGroup = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 2)
  self.mapEffect = self:AddComponent(UIBaseContainer, "root/RightView/imgMap/mapEffect")
  self.compItem = self.viewSkin:AddComponent(self, CompItem, 3)
  self.theItem = self.transform:Find("root/RightView/imgMap/rectFrame/Gird/Item").gameObject
  self.theItem:GameObjectCreatePool()
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textRemainTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textRewardTitle = self:AddComponent(UITextMeshProUGUIEx, "root/RightView/GameObject/rewardTitle")
  self.compRewardItem = self:AddComponent(UIBaseComponent, "root/RightView/GameObject/rewardItem")
  self.scrollRectScrollView = self:AddComponent(UIScrollRect, "root/RightView/GameObject/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "root/RightView/GameObject/ScrollView/Viewport/Content")
  self.rewardItem = self.transform:Find("root/RightView/GameObject/rewardItem").gameObject
  self.rewardItem:GameObjectCreatePool()
  self.textTips = self:AddComponent(UITextMeshProUGUIEx, "root/RightView/GameObject/tipsText")
  self.toggleHead = self.viewSkin:AddComponent(self, UIToggle, 12)
  self.toggleHead:SetOnValueChanged(function(value)
    DataCenter.AttackCityS0DataManager:SetToggleState(value)
    self:OnToggleHead(value)
  end)
  self.textLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnGoal = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnGoal:SetOnClick(function()
    self:OnBtnGoalClick()
  end)
  self.btnReward = self:AddComponent(UIButton, "root/RightView/Bottom/BtnReward")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textGoal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textGoalTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
end

function UIAttackCityS0ClueView:ComponentDestroy()
  self.viewSkin = nil
  self.imgReward = nil
  self.gridLayoutGroup = nil
  self.mapEffect = nil
  self.compItem = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.textRemainTime = nil
  self.textRewardTitle = nil
  self.compRewardItem = nil
  self.scrollRectScrollView = nil
  self.content = nil
  self.textTips = nil
  self.toggleHead = nil
  self.textLabel = nil
  self.btnGoal = nil
  self.textGoal = nil
  self.textGoalTime = nil
  self.btnBack = nil
  self.imgMap = nil
end

function UIAttackCityS0ClueView:DataDefine()
  self.clueItems = {}
end

function UIAttackCityS0ClueView:DataDestroy()
  self:DestroyContent()
  self:DestroyRewardContent()
  self.clueItems = nil
  self.theItem = nil
  self.rewardItem = nil
  self.clueData = nil
end

function UIAttackCityS0ClueView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityS0CityClueInfo, self.UpdateDataView)
end

function UIAttackCityS0ClueView:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityS0CityClueInfo, self.UpdateDataView)
  base.OnRemoveListener(self)
end

function UIAttackCityS0ClueView:OnBtnInfoClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIAttackCityS0ClueView:OnBtnGoalClick()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if isR4orR5 and self.clueData.curCount == tonumber(self.param.total) then
    DataCenter.AttackCityS0DataManager:SendUnlockCityClueRewardMsg(self.configId)
    self.mapEffect.gameObject:SetActive(true)
  elseif self.clueData.curCount ~= tonumber(self.param.total) then
    if isR4orR5 then
      UIUtil.ShowTipsId("city_war_tips_07")
    else
      UIUtil.ShowTipsId("city_war_tips_08")
    end
  end
end

function UIAttackCityS0ClueView:OnBtnRewardClick()
  DataCenter.AttackCityS0DataManager:SendGetCityClueRewardMsg(self.configId)
end

function UIAttackCityS0ClueView:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textTitle:SetLocalText("city_war_clue_collection_02")
  self.imgMap.gameObject:SetActive(false)
  self:Update1000MS()
  self:UpdateDataView()
end

function UIAttackCityS0ClueView:InitData()
  self.param = DataCenter.AttackCityS0ConfigManager:GetCityClueConfigData(self.configId)
  self.imgReward:LoadSpriteAsync(self.param.icon, "Assets/Main/Sprites/UI/UIAttackCityS0/UIAttackCityS0Clue/FX_CSJS_baoxiang01.png")
  local cellWidth = (Width - (self.param.column - 1) * spacingX) / self.param.column
  self.gridLayoutGroup:SetCellSize(cellWidth, cellHeight)
  local goItem, theItem
  self.gridLayoutGroup:RemoveComponents(CompItem)
  self.theItem:GameObjectRecycleAll()
  for i = 1, self.param.total do
    local levelName = "item_" .. i
    goItem = self.theItem:GameObjectSpawn(self.gridLayoutGroup.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    theItem = self.gridLayoutGroup:AddComponent(CompItem, levelName)
    theItem:ReInit(nil, false, self.param.total, i)
    self.clueItems[i] = theItem
  end
  self:UpdateRewardScroll()
end

function UIAttackCityS0ClueView:DestroyContent()
  self.gridLayoutGroup:RemoveComponents(CompItem)
  self.theItem:GameObjectRecycleAll()
  local tfCount = self.gridLayoutGroup.transform.childCount
  if 0 < tfCount then
    for i = 0, tfCount - 1 do
      local tf = self.gridLayoutGroup.transform:GetChild(i)
      CS.UnityEngine.GameObject.Destroy(tf)
    end
  end
end

function UIAttackCityS0ClueView:DestroyRewardContent()
  self.content:RemoveComponents(UICommonResItem)
  self.rewardItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
end

function UIAttackCityS0ClueView:UpdateRewardScroll()
  local groups = DataCenter.ChampionDuelManager:GetRewardsById(self.param.reward)
  if groups ~= nil then
    local goItem, rewardItem
    self.content:RemoveComponents(UICommonResItem)
    self.rewardItem:GameObjectRecycleAll()
    for i, item in ipairs(groups) do
      local levelName = "rewardItem_" .. i
      goItem = self.rewardItem:GameObjectSpawn(self.content.transform)
      goItem.name = levelName
      goItem:SetActive(true)
      rewardItem = self.content:AddComponent(UICommonResItem, levelName)
      rewardItem:ReInit(item)
    end
  end
end

function UIAttackCityS0ClueView:UpdateDataView()
  self.imgMap.gameObject:SetActive(true)
  local clueData = DataCenter.AttackCityS0DataManager:GetCityClueInfo()
  self.clueData = clueData
  if clueData and not table.IsNullOrEmpty(clueData) then
    self.configId = clueData.configId
    self:InitData()
    self.dataList = clueData.cityClueList
    if not table.IsNullOrEmpty(self.dataList) then
      for i, v in pairs(self.dataList) do
        self.clueItems[v.indexId]:ReInit(v.roleInfo, true, self.param.total, i)
        self.clueItems[v.indexId]:UpdatePlayerState(self.toggleHead:GetIsOn())
      end
    end
    self.btnReward.gameObject:SetActive(clueData.unLock and not clueData.hasReward)
    self.btnGoal.gameObject:SetActive(not clueData.unLock)
    self.textTips.gameObject:SetActive(not clueData.unLock)
    self.textGoalTime:SetText(clueData.curCount .. "/" .. self.param.total)
  end
  local toggleValue = DataCenter.AttackCityS0DataManager:GetToggleState()
  self.toggleHead:SetIsOn(toggleValue)
  self:OnToggleHead(toggleValue)
end

function UIAttackCityS0ClueView:OnToggleHead(value)
  for _, v in pairs(self.dataList) do
    self.clueItems[v.indexId]:UpdatePlayerState(value)
  end
end

function UIAttackCityS0ClueView:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local cityLevel, nextStateTime = DataCenter.AttackCityS0DataManager:GetActCityLevelAndStateTime()
  local leftTime = nextStateTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textRemainTime:SetText(countDownTimeStr)
end

return UIAttackCityS0ClueView
