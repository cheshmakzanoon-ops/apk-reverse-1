local ValentineStarItemComponent = BaseClass("ValentineStarItemComponent", UIBaseContainer)
local StarItem = require("UI.UIActivityCenterTable.Component.UIActValentine.Component.StarItemComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local star_item_path = "StarList/StarItem"
local star_detail_path = "StarDetail"
local star_num_text_path = "StarDetail/StarNumText"
local star_list_path = "StarList"
local eff_ui_valentine_star_explode1_path = "Eff_ui_valentine_star_explode1"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.starListObj = self:AddComponent(UIBaseContainer, star_list_path)
  self.starItemObj = self:AddComponent(UIBaseContainer, star_item_path)
  self.starItemObj.gameObject:GameObjectCreatePool()
  self.starDetailObj = self:AddComponent(UIBaseContainer, star_detail_path)
  self.starNumText = self:AddComponent(UIText, star_num_text_path)
  self.starLightEffObj = self:AddComponent(UIBaseContainer, eff_ui_valentine_star_explode1_path)
end

local function ComponentDestroy(self)
  if self.starLightEffObj then
    self.starLightEffObj.transform:SetParent(self.transform)
  end
  self.starItemObj.gameObject:GameObjectRecycleAll()
  if self.lightEffLogicTimer then
    self.lightEffLogicTimer:Stop()
    self.lightEffLogicTimer = nil
  end
  if self.lightEffShowTimer then
    self.lightEffShowTimer:Stop()
    self.lightEffShowTimer = nil
  end
end

local function DataDefine(self)
  self.allStarItemList = {}
end

local function DataDestroy(self)
  self.allStarItemList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ValentineStarItemComponent:ShowStarList(allStar, lightStar, isShowEff)
  self.starListObj:SetActive(true)
  self.starDetailObj:SetActive(false)
  self.starLightEffObj:SetActive(false)
  self.starLightEffObj.transform:SetParent(self.transform)
  self.starItemObj.gameObject:GameObjectRecycleAll()
  self.allStarItemList = {}
  local lightStarTrans
  for i = 1, allStar do
    local isLight = i <= lightStar
    local gameObject = self.starItemObj.gameObject:GameObjectSpawn(self.starListObj.transform)
    local name = "item_" .. NameCount
    NameCount = NameCount + 1
    gameObject.name = name
    local isLastLightStar = i == lightStar
    local isShowLightEff = isLastLightStar and isShowEff
    if isShowLightEff then
      lightStarTrans = gameObject.transform
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.starListObj.transform)
    local starItem = self.starListObj:AddComponent(StarItem, name)
    table.insert(self.allStarItemList, starItem)
    starItem:ReInit(isLight)
    if isShowLightEff then
      starItem:PlayLightAni()
    end
  end
  if lightStarTrans then
    self:ShowLightStarEff(lightStarTrans.position)
  end
end

function ValentineStarItemComponent:ShowStarNum(starNum)
  self.starListObj:SetActive(false)
  self.starDetailObj:SetActive(true)
  self.starNumText:SetText(starNum)
end

function ValentineStarItemComponent:RefreshSelf(activityId)
  local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(activityId)
  if not rData then
    return
  end
  local curExp = rData:GetCurExp()
  self:RefreshByActivityAndRankData(activityId, curExp)
end

function ValentineStarItemComponent:RefreshByActivityAndRankData(activityId, exp, isShowEff, lightFinishCallback)
  local rData = DataCenter.ValentineDataManager:GetActivityReceiveData(activityId)
  if not rData then
    return
  end
  local rankData = rData:GetRankDataByExp(exp)
  if not rankData then
    return
  end
  self:RefreshByRankData(rankData, isShowEff, lightFinishCallback)
end

function ValentineStarItemComponent:RefreshByRankData(rankData, isShowEff, lightFinishCallback)
  local curStar = 0
  local isMaxRank = rankData.isTopRank == 1
  if rankData then
    curStar = rankData.star
  end
  local curRankMaxStar = rankData.rankCount
  if isMaxRank then
    self:ShowStarNum(curStar, isShowEff)
  else
    self:ShowStarList(curRankMaxStar, curStar, isShowEff)
  end
  if self.lightEffLogicTimer then
    self.lightEffLogicTimer:Stop()
    self.lightEffLogicTimer = nil
  end
  self.lightEffLogicTimer = TimerManager:GetInstance():DelayInvoke(function()
    if lightFinishCallback then
      lightFinishCallback()
    end
    self.lightEffLogicTimer = nil
  end, 1.5)
end

function ValentineStarItemComponent:ShowLightStarEff(starPosition)
  if not starPosition then
    return
  end
  if self.lightEffShowTimer then
    self.lightEffShowTimer:Stop()
    self.lightEffShowTimer = nil
  end
  self.starLightEffObj.transform.position = starPosition
  self.starLightEffObj:SetActive(true)
  self.lightEffShowTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.lightEffShowTimer = nil
    self.starLightEffObj:SetActive(false)
  end, 1.5)
end

ValentineStarItemComponent.OnCreate = OnCreate
ValentineStarItemComponent.OnDestroy = OnDestroy
ValentineStarItemComponent.OnEnable = OnEnable
ValentineStarItemComponent.OnDisable = OnDisable
ValentineStarItemComponent.ComponentDefine = ComponentDefine
ValentineStarItemComponent.ComponentDestroy = ComponentDestroy
ValentineStarItemComponent.DataDefine = DataDefine
ValentineStarItemComponent.DataDestroy = DataDestroy
ValentineStarItemComponent.OnAddListener = OnAddListener
ValentineStarItemComponent.OnRemoveListener = OnRemoveListener
return ValentineStarItemComponent
