local LandLockChooseBubble = BaseClass("LandLockChooseBubble")
local Localization = CS.GameEntry.Localization
local triggerL_path = "RootL/Trigger"
local btnL_path = "RootL/Btn"
local btnL_text_path = "RootL/Btn/BtnText"
local triggerR_path = "RootR/Trigger"
local btnR_path = "RootR/Btn"
local btnR_text_path = "RootR/Btn/BtnText"
local SpecialBubbleOffset = {
  [3] = Vector3.New(0.5, 0, 0),
  [27] = Vector3.New(1.3, 0, 0)
}

local function __init(self)
  self.id = 0
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.showIcon = true
end

local function __delete(self)
  self.id = nil
  self.data = nil
  self.req = nil
  self.onClick = nil
  self.state = nil
  self.showIcon = false
end

local function OnCreate(self)
  self.gameObject = self.req.gameObject
  self.transform = self.gameObject.transform
  self.btnL_sprite = self.transform:Find(btnL_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btnL_text = self.transform:Find(btnL_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.triggerL = self.transform:Find(triggerL_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.triggerL.onPointerClick()
    self:OnClickL()
  end
  
  function self.triggerL.onPointerDoubleClick()
    self:OnClickL()
  end
  
  function self.triggerL.onPointerDown()
    self:ShrinkL(true)
  end
  
  function self.triggerL.onPointerUp()
    self:ShrinkL(false)
  end
  
  self.btnR_sprite = self.transform:Find(btnR_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.btnR_text = self.transform:Find(btnR_text_path):GetComponent(typeof(CS.SuperTextMesh))
  self.triggerR = self.transform:Find(triggerR_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
  
  function self.triggerR.onPointerClick()
    self:OnClickR()
  end
  
  function self.triggerR.onPointerDoubleClick()
    self:OnClickR()
  end
  
  function self.triggerR.onPointerDown()
    self:ShrinkR(true)
  end
  
  function self.triggerR.onPointerUp()
    self:ShrinkR(false)
  end
end

local function OnDestroy(self)
  self.gameObject = nil
  self.transform = nil
  self.rootL_anim = nil
  self.btnL_sprite = nil
  self.btnL_text = nil
  if self.triggerL ~= nil then
    self.triggerL.onPointerClick = nil
    self.triggerL.onPointerDoubleClick = nil
    self.triggerL.onPointerDown = nil
    self.triggerL.onPointerUp = nil
    self.triggerL = nil
  end
  self.rootR_anim = nil
  self.btnR_sprite = nil
  self.btnR_text = nil
  if self.triggerR ~= nil then
    self.triggerR.onPointerClick = nil
    self.triggerR.onPointerDoubleClick = nil
    self.triggerR.onPointerDown = nil
    self.triggerR.onPointerUp = nil
    self.triggerR = nil
  end
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
end

local function Init(self, id)
  self.id = id
  self.data = DataCenter.LandLockManager:GetLandLockDataById(id)
  self:RefreshPosition()
  self:ShrinkL(false)
  self:ShrinkR(false)
end

local function RefreshPosition(self)
  local template = DataCenter.LandLockManager:GetTemplate(self.id)
  local pos = SceneUtils.TileIndexToWorld(self.data:GetPointId())
  pos = pos + Vector3.New(0, template.height, 0) + (SpecialBubbleOffset[self.id] or Vector3.New(0, 0, 0))
  self.transform.position = pos
end

local function SetReq(self, req)
  self.req = req
end

local function SetOnClickL(self, onClickL)
  self.onClickL = onClickL
end

local function OnClickL(self)
  if self.onClickL then
    self.onClickL()
  end
end

local function SetOnClickR(self, onClickR)
  self.onClickR = onClickR
end

local function OnClickR(self)
  if self.onClickR then
    self.onClickR()
  end
end

local function ShrinkL(self, shrink)
  if shrink then
    self.btnL_sprite.transform.localScale = Vector3.New(1.1, 1.1, 1.1)
  else
    self.btnL_sprite.transform.localScale = Vector3.New(1.25, 1.25, 1.25)
  end
end

local function ShrinkR(self, shrink)
  if shrink then
    self.btnR_sprite.transform.localScale = Vector3.New(1.1, 1.1, 1.1)
  else
    self.btnR_sprite.transform.localScale = Vector3.New(1.25, 1.25, 1.25)
  end
end

LandLockChooseBubble.__init = __init
LandLockChooseBubble.__delete = __delete
LandLockChooseBubble.OnCreate = OnCreate
LandLockChooseBubble.OnDestroy = OnDestroy
LandLockChooseBubble.Init = Init
LandLockChooseBubble.RefreshPosition = RefreshPosition
LandLockChooseBubble.SetReq = SetReq
LandLockChooseBubble.SetOnClickL = SetOnClickL
LandLockChooseBubble.OnClickL = OnClickL
LandLockChooseBubble.ShrinkL = ShrinkL
LandLockChooseBubble.SetOnClickR = SetOnClickR
LandLockChooseBubble.OnClickR = OnClickR
LandLockChooseBubble.ShrinkR = ShrinkR
return LandLockChooseBubble
