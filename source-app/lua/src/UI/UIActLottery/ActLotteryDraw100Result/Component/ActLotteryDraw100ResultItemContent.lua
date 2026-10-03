local ActLotteryDraw100ResultItemContent = BaseClass("ActLotteryDraw100ResultItemContent", UIBaseContainer)
local Hero100RecruitResItem = require("UI.UIActLottery.ActLotteryDraw100Result.Component.ActLotteryDraw100ResultResItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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
  self.recruitResItemObj = self:AddComponent(UIBaseContainer, "ActLotteryDrawResItem").gameObject
  self.recruitResItemObj:GameObjectCreatePool()
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.recruitResItemObj = nil
end

local function DataDefine(self)
  self.allResItemList = {}
  self.curAniIndex = 1
  self.showAniTimer = nil
  self.showItemInterval = 0.05
end

local function DataDestroy(self)
  self.allResItemList = nil
  self.curAniIndex = nil
  self.showAniTimer = nil
  self.showItemInterval = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ActLotteryDraw100ResultItemContent:SetData(itemDataList)
  self:ClearAllItem()
  self.allResItemList = {}
  self.curAniIndex = 1
  for i, v in ipairs(itemDataList) do
    local name = "item_" .. i
    local itemObj = self.recruitResItemObj:GameObjectSpawn(self.transform)
    itemObj.name = name
    local resItem = self:AddComponent(Hero100RecruitResItem, name)
    resItem:SetData(v)
    resItem:SetShowHideState(false)
    table.insert(self.allResItemList, resItem)
  end
end

function ActLotteryDraw100ResultItemContent:ClearAllItem()
  self.recruitResItemObj:GameObjectRecycleAll()
  self:RemoveAllComponentes(Hero100RecruitResItem)
end

function ActLotteryDraw100ResultItemContent:IsAniAllFinish()
  return self.curAniIndex and self.curAniIndex > (#self.allResItemList or 0)
end

function ActLotteryDraw100ResultItemContent:ExecuteOneAniStep()
  if self.curAniIndex > #self.allResItemList or not self.allResItemList[self.curAniIndex] then
    return
  end
  if self.curAniIndex == 1 then
    self:OnAniStartPlay()
  end
  self.allResItemList[self.curAniIndex]:SetShowHideState(true)
  local screenPos = PosConverse.UIWorldToScreenPos(self.allResItemList[self.curAniIndex].transform.position)
  self.curAniIndex = self.curAniIndex + 1
  return self.showItemInterval, screenPos
end

function ActLotteryDraw100ResultItemContent:OnAniStartPlay()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.RecruitTenTimes)
end

function ActLotteryDraw100ResultItemContent:StopAllTimer()
  if self.showAniTimer then
    self.showAniTimer:Stop()
    self.showAniTimer = nil
  end
end

ActLotteryDraw100ResultItemContent.OnCreate = OnCreate
ActLotteryDraw100ResultItemContent.OnDestroy = OnDestroy
ActLotteryDraw100ResultItemContent.OnEnable = OnEnable
ActLotteryDraw100ResultItemContent.OnDisable = OnDisable
ActLotteryDraw100ResultItemContent.ComponentDefine = ComponentDefine
ActLotteryDraw100ResultItemContent.ComponentDestroy = ComponentDestroy
ActLotteryDraw100ResultItemContent.DataDefine = DataDefine
ActLotteryDraw100ResultItemContent.DataDestroy = DataDestroy
ActLotteryDraw100ResultItemContent.OnAddListener = OnAddListener
ActLotteryDraw100ResultItemContent.OnRemoveListener = OnRemoveListener
return ActLotteryDraw100ResultItemContent
