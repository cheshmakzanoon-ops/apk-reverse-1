local PveWaitMove = BaseClass("PveWaitMove")
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshPro)
local TypeOfSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
local Resource = CS.GameEntry.Resource
local PveWaitMoveMan = require("Scene.PVEBattleLevel.PveWaitMoveMan")
local Const = require("Scene.PVEBattleLevel.Const")
local show_num_go_path = "ShowNumGo"
local icon_path = "ShowNumGo/imgIcon"
local num_text_path = "ShowNumGo/textNum"
local CarryResNum = 1
local WaitShowManTime = 3

local function OnCreate(self, go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.show_num_go = self.transform:Find(show_num_go_path)
  self.icon = self.transform:Find(icon_path):GetComponent(TypeOfSpriteRenderer)
  self.num_text = self.transform:Find(num_text_path):GetComponent(UnityTextMeshPro)
end

local function ComponentDestroy(self)
  self.show_num_go = nil
  self.icon = nil
  self.num_text = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.visible = true
  self.param = nil
  self.num = 0
  self.carryMan = {}
  self.curTime = 0
  self.isCheck = false
  self.manCount = 0
end

local function DataDestroy(self)
  for k, v in pairs(self.carryMan) do
    if v.model ~= nil then
      v.model:OnDestroy()
    end
    if v.inst then
      v.inst:Destroy()
    end
  end
  self.carryMan = nil
  self.param = nil
  self.visible = nil
  self.num = nil
  self.curTime = nil
  self.isCheck = nil
  self.manCount = nil
end

local function ReInit(self, param)
  self.param = param
  self.num = param.num
  self.transform.position = self.param.position
  self.icon:LoadSprite(Const.ResTypeIconPath[Const.UnlockToResType[self.param.resType]])
  self:RefreshNum()
  self.curTime = 0
  self:LoadCarryMan()
end

local function RefreshRotation(self)
  if self.visible then
    self.show_num_go.rotation = DataCenter.BattleLevel:GetCameraRotation()
  end
end

local function RefreshNum(self)
  self.num_text:SetText(tostring(self.num))
  if self.num <= 0 then
    self.visible = false
    self.gameObject:SetActive(false)
  elseif not self.visible then
    self.visible = true
    self.gameObject:SetActive(true)
    self:CheckManToCarry()
  end
end

local function GetNum(self)
  return self.num
end

local function CutOne(self)
  if self.num >= CarryResNum then
    self.num = self.num - CarryResNum
    self:RefreshNum()
  end
end

local function OnUpdate(self, deltaTime)
  self:RefreshRotation()
  for k, v in pairs(self.carryMan) do
    if v.model ~= nil then
      v.model:OnUpdate()
    end
  end
  if self.isCheck then
    self.curTime = self.curTime + deltaTime
    if self.curTime >= WaitShowManTime then
      self.curTime = 0
      self.isCheck = false
      self:CheckManToCarry()
    end
  end
end

local function LoadCarryMan(self)
  self.manCount = DataCenter.BattleLevel:GetMoveManCount(self.param.id)
  for i = 1, self.manCount do
    if self.carryMan[i] == nil then
      self.carryMan[i] = {}
      self.carryMan[i].inst = Resource:InstantiateAsync(string.format(LoadPath.CityScene, "PveWaitMoveMan"))
      self.carryMan[i].inst:completed("+", function(req)
        local effect = PveWaitMoveMan.New()
        effect:OnCreate(req)
        local param = {}
        param.id = i
        param.originalPos = self.transform.position
        param.targetPos = nil
        param.resType = self.param.resType
        param.num = CarryResNum
        param.parent = self
        effect:ReInit(param)
        self.carryMan[i].model = effect
        self:CheckManToCarry()
      end)
    end
  end
  local curNum = table.count(self.carryMan)
  if curNum > self.manCount then
    for j = self.manCount + 1, curNum do
      if self.carryMan[j].model ~= nil then
        self.carryMan[j].model:OnDestroy()
      end
      if self.carryMan[j].inst then
        self.carryMan[j].inst:Destroy()
      end
    end
  end
end

local function FindTargetPos(self)
  if self.num >= CarryResNum and self.visible then
    local result = DataCenter.BattleLevel:GetTriggerPointByRes(self.param.resType)
    if result ~= nil then
      local showPos = result:GetTilePos() or result:GetShowPos()
      if showPos then
        self:CutOne()
        return SceneUtils.TileToWorld(showPos)
      end
    end
  end
end

local function ChangeTargetPos(self, id)
  if self.carryMan[id] ~= nil and self.carryMan[id].model ~= nil then
    self.carryMan[id].model:ChangeTargetPos(self:FindTargetPos())
  end
end

local function AddNum(self, num)
  self.num = self.num + num
  self:RefreshNum()
  self:CheckManToCarry()
end

local function CheckManToCarry(self)
  if not self.isCheck then
    for k, v in pairs(self.carryMan) do
      if v.model ~= nil and not v.model.visible then
        local pos = self:FindTargetPos()
        if pos ~= nil then
          v.model:ChangeTargetPos(pos)
          if k ~= self.manCount then
            self.curTime = 0
            self.isCheck = true
            break
          end
        end
      end
    end
  end
end

local function RefreshMoveManCount(self)
  self:LoadCarryMan()
end

PveWaitMove.OnCreate = OnCreate
PveWaitMove.OnDestroy = OnDestroy
PveWaitMove.ComponentDefine = ComponentDefine
PveWaitMove.ComponentDestroy = ComponentDestroy
PveWaitMove.DataDefine = DataDefine
PveWaitMove.DataDestroy = DataDestroy
PveWaitMove.ReInit = ReInit
PveWaitMove.RefreshRotation = RefreshRotation
PveWaitMove.RefreshNum = RefreshNum
PveWaitMove.GetNum = GetNum
PveWaitMove.CutOne = CutOne
PveWaitMove.OnUpdate = OnUpdate
PveWaitMove.LoadCarryMan = LoadCarryMan
PveWaitMove.FindTargetPos = FindTargetPos
PveWaitMove.ChangeTargetPos = ChangeTargetPos
PveWaitMove.AddNum = AddNum
PveWaitMove.CheckManToCarry = CheckManToCarry
PveWaitMove.RefreshMoveManCount = RefreshMoveManCount
return PveWaitMove
