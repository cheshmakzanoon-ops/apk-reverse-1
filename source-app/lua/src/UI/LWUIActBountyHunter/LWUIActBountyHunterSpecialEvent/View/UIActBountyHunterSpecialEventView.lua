local UIActBountyHunterSpecialEventView = BaseClass("UIActBountyHunterSpecialEventView", UIBaseView)
local ResourceManager = CS.GameEntry.Resource
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Const = require("UI/UIActivityCenterTable/Component/ActBountyHunter/BountyHunterConstant")
local BOSS_EVENT_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSpecialEvent/BountyHunterBossEvent.prefab"
local RANDOM_BOMB_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSpecialEvent/BountyHunterRandomBombEvent.prefab"
local FULL_SCREEN_ATTACK_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSpecialEvent/BountyHunterFullScreenAttackEvent.prefab"
local SHOP_EVENT_PREFAB_PATH = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSpecialEvent/BountyHunterShopEvent.prefab"
local content_path = "Content"
local PREFAB_CONFIG = {
  [BountyHunterEventType.BossEvent] = BOSS_EVENT_PREFAB_PATH,
  [BountyHunterEventType.RandomBomb] = RANDOM_BOMB_PREFAB_PATH,
  [BountyHunterEventType.FullScreeAttack] = FULL_SCREEN_ATTACK_PREFAB_PATH,
  [BountyHunterEventType.Shop] = SHOP_EVENT_PREFAB_PATH
}
local SOUND = {
  [BountyHunterEventType.BossEvent] = 0,
  [BountyHunterEventType.RandomBomb] = 0,
  [BountyHunterEventType.FullScreeAttack] = 92008,
  [BountyHunterEventType.Shop] = 92009
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.params = self:GetUserData()
  self:ReInit()
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
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIActBountyHunterSpecialEventView:ReInit()
  local eventType = self.params
  local path = PREFAB_CONFIG[eventType]
  if not path then
    self:ClosePanel()
    return
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self:LoadPrefab(path, SOUND[eventType])
  if self.closeTimer then
    self.closeTimer:Stop()
    self.closeTimer = nil
  end
  local closeTime = Const.WINDOW_AUTO_CLOSE_TIME_CONFIG[eventType]
  self.closeTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:ClosePanel()
  end, closeTime or 1)
end

function UIActBountyHunterSpecialEventView:LoadPrefab(prefabPath, soundId)
  self.request = ResourceManager:InstantiateAsync(prefabPath)
  self.request:completed("+", function()
    if self.request.isError then
      return
    end
    self.eventObj = self.request.gameObject
    self.eventObj:SetActive(true)
    self.eventObj.transform:SetParent(self.content.transform)
    self.eventObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.eventObj.transform:Set_localPosition(0, 0, 0)
    self.eventObj.transform:Set_anchorMin(0, 0)
    self.eventObj.transform:Set_anchorMax(1, 1)
    self.eventObj.transform:Set_offsetMin(0, 0)
    self.eventObj.transform:Set_offsetMax(0, 0)
    if soundId and 0 < soundId then
      DataCenter.LWSoundManager:PlaySound(soundId, false)
    end
  end)
end

function UIActBountyHunterSpecialEventView:ClosePanel()
  self.ctrl:CloseSelf()
end

UIActBountyHunterSpecialEventView.OnCreate = OnCreate
UIActBountyHunterSpecialEventView.OnDestroy = OnDestroy
UIActBountyHunterSpecialEventView.OnEnable = OnEnable
UIActBountyHunterSpecialEventView.OnDisable = OnDisable
UIActBountyHunterSpecialEventView.ComponentDefine = ComponentDefine
UIActBountyHunterSpecialEventView.ComponentDestroy = ComponentDestroy
UIActBountyHunterSpecialEventView.DataDefine = DataDefine
UIActBountyHunterSpecialEventView.DataDestroy = DataDestroy
UIActBountyHunterSpecialEventView.OnAddListener = OnAddListener
UIActBountyHunterSpecialEventView.OnRemoveListener = OnRemoveListener
return UIActBountyHunterSpecialEventView
