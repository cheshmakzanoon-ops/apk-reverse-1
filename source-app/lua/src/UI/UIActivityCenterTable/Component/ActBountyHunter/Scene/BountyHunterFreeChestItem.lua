local BaseUnitItem = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Scene.BountyHunterBaseItem")
local BountyHunterFreeChestItem = BaseClass("BountyHunterFreeChestItem", BaseUnitItem)
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local base = BaseUnitItem
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local FREE_TIP_BUBBLE_OFFSET = Vector3.New(25, 75, 0)
local FREE_TIP_BUBBLE_OFFSET_4_ARABIC = Vector3.New(-20, 75, 0)

local function __init(self, scene)
  base.__init(self, scene)
end

local function __delete(self)
  base.__delete(self)
  self:Destroy()
end

function BountyHunterFreeChestItem:Init()
  base.Init(self, "chest")
  self.clickWidth = 200
  self.clickHeight = 200
end

function BountyHunterFreeChestItem:Destroy()
  base.Destroy(self)
  if self.openBoxTimer then
    self.openBoxTimer:Stop()
    self.openBoxTimer = nil
  end
  if self.toIdleTimer then
    self.toIdleTimer:Stop()
    self.toIdleTimer = nil
  end
  if self.bronEffReq then
    self.bronEffReq:Destroy()
  end
  self.bronEffReq = nil
  if self.openEffReq then
    self.openEffReq:Destroy()
  end
  self.openEffReq = nil
  if self.preOpenEffReq then
    self.preOpenEffReq:Destroy()
  end
  self.preOpenEffReq = nil
  if self.bornEffReq then
    self.bornEffReq:Destroy()
  end
  self.bornEffReq = nil
  self:RemoveFreeTipBubble()
end

function BountyHunterFreeChestItem:LoadItem(chestData, parent, birthLocalPos, slotIndex, callback)
  self.prefabPath = chestData.prefabPath
  self.callback = callback
  self.uuid = chestData.uuid
  self.slotIndex = slotIndex
  self.parent = parent
  local rotation = Vector3.New(0, 0, 0)
  local scale = 1
  self:LoadModel(self.prefabPath, parent, birthLocalPos, rotation, scale, function()
    self:OnLoadedFinish()
    if callback then
      callback()
    end
  end)
end

function BountyHunterFreeChestItem:OnLoadedFinish()
  if not self.transform then
    return
  end
  if self.bornEffReq then
    self.bornEffReq:Destroy()
  end
  self.bornEffReq = self:GenOneEff(Const.FREE_CHEST_BORN_EFF_PATH, self.parent, self.transform.position)
  local ret, time = self:PlayAni("born")
  if not ret then
    time = 1
  end
  self.toIdleTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayAni("idle")
    if self.preOpenEffReq then
      self.preOpenEffReq:Destroy()
    end
    self.preOpenEffReq = self:GenOneEff(Const.FREE_CHEST_PRE_OPEN_EFF_PATH, self.parent, self.transform.position)
  end, time)
end

function BountyHunterFreeChestItem:PlayOpenAndDisappearAni(rewardData, callback)
  if not self.transform then
    return
  end
  if not self.openEffReq then
    self.openEffReq = self:GenOneEff(Const.FREE_CHEST_OPEN_EFF_PATH, self.parent, self.transform.position)
  end
  self:FlyReward(rewardData)
  if self.openBoxTimer then
    self.openBoxTimer:Stop()
    self.openBoxTimer = nil
  end
  local ret, time = self:PlayAni("open")
  if not ret then
    time = 1
  end
  
  local function deadFunc()
    if self.openEffReq then
      self.openEffReq:Destroy()
    end
    self.openEffReq = nil
    local ret2, time2 = self:PlayAni("dead")
    if not ret2 then
      time2 = 1
    end
    self.openBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
      if callback then
        callback()
      end
    end, time2)
  end
  
  self.openBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
    deadFunc()
  end, time)
  if self.preOpenEffReq then
    self.preOpenEffReq:Destroy()
  end
  self.preOpenEffReq = nil
end

function BountyHunterFreeChestItem:FlyReward(rewardData)
  if not rewardData or not self.transform then
    return
  end
  local flyRewardParam = {}
  flyRewardParam.rewardData = {}
  flyRewardParam.rewardData.rewardDataNoBornEffect = rewardData
  flyRewardParam.startWorldPos = self.transform.position
  EventManager:GetInstance():Broadcast(EventId.BountyHunterPlayStashRewardAni, flyRewardParam)
end

function BountyHunterFreeChestItem:RemoveClickItem()
  base.RemoveClickItem(self)
  self:RemoveFreeTipBubble()
end

function BountyHunterFreeChestItem:OnModelLoadFinish()
  base.OnModelLoadFinish(self)
  self:CheckAndGenFreeTipBubble()
end

function BountyHunterFreeChestItem:CheckAndGenFreeTipBubble()
  if not self.bHunterClickBtn then
    return
  end
  if self.freeTipBubbleReq == nil then
    self.freeTipBubbleReq = Resource:InstantiateAsync(Const.FREE_TIP_BUBBLE_PATH)
    self.freeTipBubbleReq:completed("+", function(req)
      if req.isError then
        Logger.LogError("BountyHunterFreeChestItem:BlindClickItem Error: " .. req.errorMessage)
        return
      end
      local parentTrans = self.bHunterClickBtn.transform.parent.transform
      local tipObj = req.gameObject
      tipObj.transform:SetParent(parentTrans)
      tipObj.transform:Set_localScale(1, 1, 1)
      self:UpdateFreeTipBubblePos()
      local flipContentTrans = tipObj.transform:Find("BG"):GetComponent(typeof(CS.UnityEngine.Transform))
      if flipContentTrans then
        flipContentTrans:Set_localScale(CommonUtil.ArabicAutoMirrorFactor(), 1, 1)
      end
    end)
    return
  end
  self:UpdateFreeTipBubblePos()
end

function BountyHunterFreeChestItem:UpdateFreeTipBubblePos(isLerp)
  if self.freeTipBubbleReq and self.freeTipBubbleReq.gameObject and self.bHunterClickBtn then
    local offset = CommonUtil.IsArabicAutoMirrorOpen() and FREE_TIP_BUBBLE_OFFSET_4_ARABIC or FREE_TIP_BUBBLE_OFFSET
    if not isLerp then
      self.freeTipBubbleReq.gameObject.transform.position = self.bHunterClickBtn.transform.position + offset
    else
      local targetPos = self.bHunterClickBtn.transform.position + offset
      local currentPos = self.freeTipBubbleReq.gameObject.transform.position
      self.freeTipBubbleReq.gameObject.transform.position = Vector3.Lerp(currentPos, targetPos, Time.deltaTime * 100)
    end
  end
end

function BountyHunterFreeChestItem:RemoveFreeTipBubble()
  if self.freeTipBubbleReq then
    self.freeTipBubbleReq:Destroy()
    self.freeTipBubbleReq = nil
  end
end

function BountyHunterFreeChestItem:UpdateClickBtnPos(sceneCamera, rtRowWidth, rtRowHeight)
  base.UpdateClickBtnPos(self, sceneCamera, rtRowWidth, rtRowHeight)
  self:UpdateFreeTipBubblePos(true)
end

BountyHunterFreeChestItem.__init = __init
BountyHunterFreeChestItem.__delete = __delete
return BountyHunterFreeChestItem
