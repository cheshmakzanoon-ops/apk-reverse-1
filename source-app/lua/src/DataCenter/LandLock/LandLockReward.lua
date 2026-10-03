local LandLockReward = BaseClass("LandLockReward")
local Localization = CS.GameEntry.Localization
local CallIcon = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_call.png"
local CallPressedIcon = "Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_call_pressed.png"

local function __init(self)
  self.id = 0
  self.req = nil
  self.onClick = nil
  self.clickTimer = nil
end

local function __delete(self)
  self.id = nil
  self.req = nil
  self.onClick = nil
  if self.clickTimer ~= nil then
    self.clickTimer:Stop()
  end
  self.clickTimer = nil
end

local function OnCreate(self, rewardType)
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.trigger = self.gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
  
  function self.trigger.onPointerDoubleClick()
    self:OnClick()
  end
  
  self.rewardType = rewardType
  if self.rewardType == LandLockRewardType.CallChest or self.rewardType == LandLockRewardType.CallSoldier then
    local sprite = self.transform:Find("Model/Icon"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    sprite:LoadSprite(CallIcon)
    self.sprite = sprite
  else
    self.sprite = nil
  end
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.LandLockReward, tostring(self.id))
end

local function OnDestroy(self)
  self.gameObject = nil
  self.transform = nil
  self.sprite = nil
  if self.trigger ~= nil and IsNull(self.trigger) == false then
    self.trigger.onPointerClick = nil
    self.trigger.onPointerDoubleClick = nil
    self.trigger = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.rewardType = nil
end

local function Init(self, id)
  self.id = id
end

local function SetReq(self, req)
  self.req = req
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
  if self.rewardType == LandLockRewardType.CallChest or self.rewardType == LandLockRewardType.CallSoldier then
    if self.clickTimer ~= nil then
      self.clickTimer:Stop()
    end
    if self.sprite ~= nil then
      self.sprite:LoadSprite(CallPressedIcon)
      self.clickTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.sprite then
          self.sprite:LoadSprite(CallIcon)
        end
      end, 0.125)
    end
  end
end

local function SetActive(self, active)
  self.gameObject:SetActive(active)
end

local function GetGameObject(self)
  if self.trigger ~= nil then
    return self.trigger.gameObject
  end
  if self.sprite ~= nil then
    return self.sprite.gameObject
  end
  return self.gameObject
end

LandLockReward.__init = __init
LandLockReward.__delete = __delete
LandLockReward.OnCreate = OnCreate
LandLockReward.OnDestroy = OnDestroy
LandLockReward.Init = Init
LandLockReward.SetReq = SetReq
LandLockReward.SetOnClick = SetOnClick
LandLockReward.OnClick = OnClick
LandLockReward.SetActive = SetActive
LandLockReward.GetGameObject = GetGameObject
return LandLockReward
