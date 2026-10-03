local TorchRelayScenePropsPool = BaseClass("TorchRelayScenePropsPool")
local PropsClassTitle = "DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelaySceneProps%s"

function TorchRelayScenePropsPool:__init()
  self.propsListDic = {}
  self.root = CS.UnityEngine.GameObject("TorchRelayScenePropsPool")
end

function TorchRelayScenePropsPool:__delete()
  for _, list in pairs(self.propsListDic) do
    for i, v in ipairs(list) do
      v:Delete()
    end
  end
  self.propsListDic = nil
  if self.root then
    CS.UnityEngine.GameObject.Destroy(self.root)
    self.root = nil
  end
end

function TorchRelayScenePropsPool:Get(param, resLoadCallback)
  local propsType = param.propsType
  local bornData = param.bornData
  local sceneRoot = param.sceneRoot
  local logic = param.logic
  local res
  if not self.propsListDic[propsType] or #self.propsListDic[propsType] == 0 then
    if self:GetPropsClassExtend(propsType) == nil then
      Logger.LogError("[TorchRelay] propsType not find.  propsType:.." .. tostring(propsType))
      return nil
    end
    local class = require(string.format(PropsClassTitle, self:GetPropsClassExtend(propsType)))
    res = class.New(bornData, sceneRoot, logic, resLoadCallback)
  else
    local item = table.remove(self.propsListDic[propsType])
    item:ReInit(bornData, sceneRoot, logic)
    if item.isLoaded and resLoadCallback then
      resLoadCallback(item)
    end
    res = item
  end
  if res == nil and logic then
    logic:PrintRealErrorLog("pool get null")
  end
  return res
end

function TorchRelayScenePropsPool:Recycle(item)
  local propsType = item.bornData.propsType
  if not self.propsListDic[propsType] then
    self.propsListDic[propsType] = {}
  end
  item:Recycle()
  if item.isLoaded then
    item.transform:SetParent(self.root.transform)
  end
  table.insert(self.propsListDic[propsType], item)
end

function TorchRelayScenePropsPool:GetPropsClassExtend(propsType)
  if propsType == TorchRelayScenePropsType.StrengthAdd then
    return "StrengthAdd"
  elseif propsType == TorchRelayScenePropsType.SpeedAdd then
    return "SpeedAdd"
  elseif propsType == TorchRelayScenePropsType.Defend then
    return "Defend"
  elseif propsType == TorchRelayScenePropsType.AutoCollect then
    return "AutoCollect"
  elseif propsType == TorchRelayScenePropsType.Invincible then
    return "Invincible"
  elseif propsType == TorchRelayScenePropsType.TreasureBox then
    return "TreasureBox"
  elseif propsType == TorchRelayScenePropsType.Obstacles then
    return "Obstacles"
  elseif propsType == TorchRelayScenePropsType.ZombieObstacles then
    return "ZombieObstacles"
  end
end

return TorchRelayScenePropsPool
