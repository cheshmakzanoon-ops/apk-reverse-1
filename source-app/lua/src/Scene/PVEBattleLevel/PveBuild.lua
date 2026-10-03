local Resource = CS.GameEntry.Resource
local PveBuild = BaseClass("PveBuild")
local Const = require("Scene.PVEBattleLevel.Const")
local PveBuildNormal = require("Scene.PVEBattleLevel.PveBuildNormal.PveBuildNormal")

function PveBuild:__init(battleLevel, param)
  self.battleLevel = battleLevel
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self.moveManCount = battleLevel.InitMovePeopleNum
  self:Create()
end

function PveBuild:Destroy()
  if self.req ~= nil then
    self.req:Destroy()
  end
  self.transform = nil
  self.gameObject = nil
  self.model = nil
  self.moveManCount = nil
end

function PveBuild:Create()
  if self.req == nil then
    self.req = Resource:InstantiateAsync(string.format(LoadPath.CityScene, self.param.buildName))
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self.gameObject:SetActive(true)
      self.transform.position = self.param.pos
      self.transform.rotation = Quaternion.Euler(self.param.rot.x, self.param.rot.y, self.param.rot.z)
      local effect = PveBuildNormal.New()
      effect:OnCreate(self.req)
      local param = {}
      param.buildName = self.param.buildName
      param.pos = self.param.pos
      param.animName = self.param.animName
      param.id = self.param.id
      param.buffTriggerList = self.param.buffTriggerList
      param.triggerDirection = self.param.triggerDirection
      param.triggerId = self.param.triggerId
      effect:ReInit(param)
      self.model = effect
    end)
  end
end

function PveBuild:ChangeParam(param)
  if self.param.buildName ~= param.buildName then
    self:Destroy()
    self.param = param
    self:Create()
  else
    self.param = param
    if self.model ~= nil then
      self.model:RefreshAnim(self.param.animName)
      self.model:ChangeParam(param)
    end
  end
end

function PveBuild:GetModelPos()
  if self.model ~= nil then
    return self.model:GetModelPos()
  end
  return self.param.pos
end

function PveBuild:AddMoveManCount(addNum)
  self.moveManCount = self.moveManCount + addNum
end

function PveBuild:IsNeedAddMoveMan()
  if self.param.buffTriggerList ~= nil and table.count(self.param.buffTriggerList) > 0 then
    for k, v in ipairs(self.param.buffTriggerList) do
      for k1, v1 in ipairs(v) do
        local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(v1)
        if not trigger:IsTriggerOK() and trigger:IsTypeBuyWaitResItem() then
          return true
        end
      end
    end
  end
  return false
end

function PveBuild:GetMoveManCount()
  return self.moveManCount
end

function PveBuild:RefreshBuildShop()
  if self.model ~= nil then
    return self.model:RefreshBuildShop()
  end
end

function PveBuild:OnPlayerMoveSignal(pos)
  if self.model ~= nil then
    return self.model:OnPlayerMoveSignal(pos)
  end
end

return PveBuild
