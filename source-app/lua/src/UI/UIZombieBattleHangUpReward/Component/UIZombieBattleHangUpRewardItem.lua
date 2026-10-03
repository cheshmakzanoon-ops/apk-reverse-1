local UIZombieBattleHangUpRewardItem = BaseClass("UIZombieBattleHangUpRewardItem", UIBaseContainer)
local UIZombieBattleHangUpResourceCell = require("UI.UIZombieBattleHangUpReward.Component.UIZombieBattleHangUpResourceCell")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

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
  self.textName = self:AddComponent(UIText, "NameText")
  self.imgFill = self:AddComponent(UIImage, "TimeSlider/FillArea/Fill")
  self.textTimeNum = self:AddComponent(UIText, "TimeSlider/TimeNum")
  self.imgResBgImage1 = self:AddComponent(UIImage, "ResBar/bg/resBgImage1")
  self.imgResBgImage2 = self:AddComponent(UIImage, "ResBar/bg/resBgImage2")
  self.imgResBgImage3 = self:AddComponent(UIImage, "ResBar/bg/resBgImage3")
  self.textRewardTitle = self:AddComponent(UIText, "RewardBg/RewardTitle")
  self.gridLayoutGroupRewardGrid1 = self:AddComponent(UIGridLayoutGroup, "RewardBg/RewardGrid1")
  self.topResBar = self:AddComponent(UIBaseContainer, "ResBar")
  self.headIcon = self:AddComponent(UIImage, "HeadBg/HeadIcon")
  self.btnRate = self:AddComponent(UIButton, "rateBtn")
  self.textRewardTitle:SetLocalText(456811)
  self.resBgImageList = {
    self.imgResBgImage1,
    self.imgResBgImage2,
    self.imgResBgImage3
  }
end

local function ComponentDestroy(self)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  if self.flyText then
    for _, v in pairs(self.flyText) do
      v:Destroy()
    end
    self.flyText = nil
  end
  self.textName = nil
  self.imgFill = nil
  self.textTimeNum = nil
  self.imgResBgImage1 = nil
  self.imgResBgImage2 = nil
  self.imgResBgImage3 = nil
  self.textRewardTitle = nil
  self.gridLayoutGroupRewardGrid1 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function Refresh(self, param, pageType)
  self.pageType = pageType
  if pageType == JeepAdventurePageType.Domintor then
    self.stageMgr = DataCenter.DomintorStageManager
    self.lastOpenId = param.lastDominatorUpId
    self.currRewardsMeta = param.dominatorPerReward
    self.lastRewardsMeta = param.lastDominatorPerReward
    self.headIcon:LoadSprite(DataCenter.DominatorManager:GetCityBuildingShowIconPath())
    self.textName:SetLocalText("dominator_truck_title_name")
    self.btnRate:SetActive(true)
    self.btnRate:SetOnClick(function()
      local tRewardProbability = DataCenter.DominatorUpTemplateManager:GetRewardProbability()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHangUpRewardProbability, {anim = true}, tRewardProbability)
    end)
  else
    self.stageMgr = DataCenter.StageManager
    self.lastOpenId = param.lastStageId
    self.currRewardsMeta = param.perReward
    self.lastRewardsMeta = param.lastPerReward
    self.headIcon:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guajitanchuang_kachetouxiang"))
    self.textName:SetLocalText("armed_truck_title_name")
    self.btnRate:SetActive(false)
  end
  if self.stageMgr.idleReward then
    self:OnGetReward(self.stageMgr.idleReward)
  end
  self:AddResourceCell()
  self:Update1000MS()
end

local function Update1000MS(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local timeDelta = curTime - self.stageMgr.lastIdleRewardTimeStamp
  local maxTime = self.stageMgr.hangUpMaxTime
  if timeDelta > maxTime then
    timeDelta = maxTime
  end
  local curNum = timeDelta
  local maxNum = maxTime
  local percent = curNum / maxNum
  percent = math.max(0, math.min(percent, 1))
  self.imgFill:SetFillAmount(percent)
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeDelta)
  self.textTimeNum:SetText(timeStr)
end

local function OnGetReward(self, param)
  local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  local index = 0
  for _, v in pairs(rewards) do
    local req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    local p = v
    index = index + 1
    local name = index
    req:completed("+", function(req)
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      go.name = name
      go.transform:SetParent(self.gridLayoutGroupRewardGrid1.transform)
      go.transform:Set_localScale(1, 1, 1)
      local cell = self:AddComponent(UICommonResItem, go)
      cell:ReInit(p)
    end)
    table.insert(self.reqs, req)
  end
end

local function AddResourceCell(self)
  local currOpenId = self.stageMgr.idleRewardStageId
  local lastOpenId = self.lastOpenId
  local currRewardsMeta = self.currRewardsMeta
  local lastRewardsMeta = self.lastRewardsMeta
  if not currRewardsMeta then
    return
  end
  local resAddRateEffect = 0
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  if 0 < #buildDataList then
    local buildData = buildDataList[1]
    for k, v in pairs(buildData.assignedHeroList) do
      local workerData = DataCenter.WorkerDataManager:GetWorkerDataByUid(tonumber(v))
      if workerData ~= nil then
        resAddRateEffect = resAddRateEffect + Mathf.RoundTo(workerData:GetWorkerProperty(EffectDefine.LW_STAGE_RES_ADD_RATE), 4)
      end
    end
  end
  local currRes = {
    0,
    0,
    0,
    0
  }
  self.resourceCells = {}
  local numScale = 12
  if self.pageType == JeepAdventurePageType.Domintor then
    numScale = 3600 / LuaEntry.DataConfig:TryGetNum("dominator_idle_reward", "k1")
  elseif self.pageType == JeepAdventurePageType.TowerUp then
    numScale = 3600 / LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k1")
  end
  for i, rewardRow in ipairs(currRewardsMeta) do
    local resType = rewardRow.rewardType
    local val = rewardRow.count
    local param = {}
    if resType == RewardType.GOODS then
      param.iconName = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(rewardRow.itemId))
      param.resNum = math.floor(val * numScale)
      currRes[i] = param.resNum
    else
      param.iconName = DataCenter.ResourceManager:GetResourceIconByType(RewardToResType[resType])
      param.resNum = math.floor(val * numScale * (1 + resAddRateEffect))
      currRes[i] = val
    end
    self:GameObjectInstantiateAsync(UIAssets.UIMainTopResourceCell, function(request)
      if request.isError then
        self.resourceCells[resType] = nil
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.topResBar.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(i)
      go.name = nameStr
      local model = self.topResBar:AddComponent(UIZombieBattleHangUpResourceCell, nameStr)
      model.background:SetActive(false)
      self.resourceCells[resType] = model
      model:ReInit(param)
    end)
  end
  local showNum = #currRewardsMeta
  for i = 1, #self.resBgImageList do
    if i <= showNum then
      self.resBgImageList[i]:SetActive(true)
    else
      self.resBgImageList[i]:SetActive(false)
    end
  end
end

UIZombieBattleHangUpRewardItem.OnCreate = OnCreate
UIZombieBattleHangUpRewardItem.OnDestroy = OnDestroy
UIZombieBattleHangUpRewardItem.OnEnable = OnEnable
UIZombieBattleHangUpRewardItem.OnDisable = OnDisable
UIZombieBattleHangUpRewardItem.ComponentDefine = ComponentDefine
UIZombieBattleHangUpRewardItem.ComponentDestroy = ComponentDestroy
UIZombieBattleHangUpRewardItem.DataDefine = DataDefine
UIZombieBattleHangUpRewardItem.DataDestroy = DataDestroy
UIZombieBattleHangUpRewardItem.OnAddListener = OnAddListener
UIZombieBattleHangUpRewardItem.OnRemoveListener = OnRemoveListener
UIZombieBattleHangUpRewardItem.Refresh = Refresh
UIZombieBattleHangUpRewardItem.Update1000MS = Update1000MS
UIZombieBattleHangUpRewardItem.OnGetReward = OnGetReward
UIZombieBattleHangUpRewardItem.AddResourceCell = AddResourceCell
return UIZombieBattleHangUpRewardItem
