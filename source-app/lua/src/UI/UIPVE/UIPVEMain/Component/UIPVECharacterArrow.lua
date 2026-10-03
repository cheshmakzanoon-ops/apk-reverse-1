local UIPVECharacterArrow = BaseClass("UIPVECharacterArrow", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local arrow_path = "Bg/Arrow"
local PADDING_X = 200
local PADDING_Y = 160

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_btn = self:AddComponent(UIButton, bg_path)
  self.bg_btn:SetOnClick(function()
    self:OnClick()
  end)
  self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
end

local function ComponentDestroy(self)
  self.bg_btn = nil
  self.arrow_go = nil
end

local function DataDefine(self)
  self.screenWidth = Screen.width
  self.screenHeight = Screen.height
  self.btnActive = false
end

local function DataDestroy(self)
  self.screenWidth = nil
  self.screenHeight = nil
  self.btnActive = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.btnActive = false
  self.bg_btn:SetActive(false)
end

local function Update(self)
  if not DataCenter.BattleLevel.isHighView then
    self:SetBtnActive(false)
    return
  end
  local player = DataCenter.BattleLevel:GetPlayer()
  if player == nil then
    self:SetBtnActive(false)
    return
  end
  local playerPos = player:GetTransform().position
  local cameraPos = DataCenter.BattleLevel:GetCameraTarget()
  local maxDis = 30
  local pPosX = Mathf.Clamp(playerPos.x, cameraPos.x - maxDis, cameraPos.x + maxDis)
  local pPosZ = Mathf.Clamp(playerPos.z, cameraPos.z - maxDis, cameraPos.z + maxDis)
  playerPos = Vector3.New(pPosX, 0, pPosZ)
  local playerScreenPos = DataCenter.BattleLevel:WorldToScreenPoint(playerPos)
  if playerScreenPos.x > 0 and playerScreenPos.x < self.screenWidth and 0 < playerScreenPos.y and playerScreenPos.y < self.screenHeight then
    self:SetBtnActive(false)
    return
  end
  local x = Mathf.Clamp(playerScreenPos.x, PADDING_X, self.screenWidth - PADDING_X)
  local y = Mathf.Clamp(playerScreenPos.y, PADDING_Y, self.screenHeight - PADDING_Y)
  local dirVec = CS.UnityEngine.Vector3(x - self.screenWidth / 2, y - self.screenHeight / 2, 0)
  local rot = CS.UnityEngine.Quaternion.FromToRotation(CS.UnityEngine.Vector3.up, dirVec)
  self.bg_btn.rectTransform:Set_position(x, y, 0)
  self.arrow_go.rectTransform:Set_eulerAngles(0, 0, rot.eulerAngles.z)
  self:SetBtnActive(true)
end

local function SetBtnActive(self, active)
  if self.btnActive ~= active then
    self.btnActive = active
    self.bg_btn:SetActive(active)
  end
end

local function OnClick(self)
  DataCenter.BattleLevel:SetHighView(false, true)
end

UIPVECharacterArrow.OnCreate = OnCreate
UIPVECharacterArrow.OnDestroy = OnDestroy
UIPVECharacterArrow.ComponentDefine = ComponentDefine
UIPVECharacterArrow.ComponentDestroy = ComponentDestroy
UIPVECharacterArrow.DataDefine = DataDefine
UIPVECharacterArrow.DataDestroy = DataDestroy
UIPVECharacterArrow.OnEnable = OnEnable
UIPVECharacterArrow.OnDisable = OnDisable
UIPVECharacterArrow.OnAddListener = OnAddListener
UIPVECharacterArrow.OnRemoveListener = OnRemoveListener
UIPVECharacterArrow.ReInit = ReInit
UIPVECharacterArrow.Update = Update
UIPVECharacterArrow.SetBtnActive = SetBtnActive
UIPVECharacterArrow.OnClick = OnClick
return UIPVECharacterArrow
