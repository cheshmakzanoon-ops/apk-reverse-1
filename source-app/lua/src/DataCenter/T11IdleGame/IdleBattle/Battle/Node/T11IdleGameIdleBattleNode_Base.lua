local T11IdleGameIdleBattleNode_Base = BaseClass("T11IdleGameIdleBattleNode_Base")
local ResourceManager = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameIdleBattleNode_Base:__init(logic, owner)
  self.logic = logic
  self.owner = owner
  self.data = nil
  self.curPlayTime = 0
  self.propReq = nil
  self.propObj = nil
  self.propAnim = nil
  self.assetReqs = {}
end

function T11IdleGameIdleBattleNode_Base:__delete()
  self.logic = nil
  self.owner = nil
  self.data = nil
  self.curPlayTime = nil
  self.propReq = nil
  self.propObj = nil
  self.propAnim = nil
  self.assetReqs = nil
end

function T11IdleGameIdleBattleNode_Base:Destroy()
  self.data = nil
  self.curPlayTime = 0
  self:DestroyProp()
  self:DestroyAssets()
end

function T11IdleGameIdleBattleNode_Base:SetNodeData(data)
  self.data = data
end

function T11IdleGameIdleBattleNode_Base:OnUpdate(deltaTime)
  if self.curPlayTime then
    self.curPlayTime = self.curPlayTime + deltaTime
    if self.curPlayTime >= Const.MaxNodePlayTime then
      self:Finish()
    end
  end
end

function T11IdleGameIdleBattleNode_Base:Start()
  self.curPlayTime = 0
end

function T11IdleGameIdleBattleNode_Base:Finish()
  self:End()
  if self.owner then
    self.owner:OnNodePlayFinish(self.data)
  end
end

function T11IdleGameIdleBattleNode_Base:End()
end

function T11IdleGameIdleBattleNode_Base:CreateProp(assetPath, pos, rotation, finishCallback)
  self:DestroyProp()
  if self.data == nil or self.owner == nil then
    return
  end
  local propRoot = self.owner:GetNodePropRootByNodeType(self.data:GetType())
  if IsNull(propRoot) then
    return
  end
  local req = ResourceManager:InstantiateAsync(assetPath)
  req:completed("+", function(request)
    if request.isError or IsNull(propRoot) then
      return
    end
    request.gameObject.transform:SetParent(propRoot.transform)
    request.gameObject.transform:Set_localPosition(pos:Split())
    request.gameObject.transform:Set_localEulerAngles(rotation:Split())
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.propObj = request.gameObject
    self.propAnim = request.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
    if finishCallback then
      finishCallback()
    end
  end)
  self.propReq = req
end

function T11IdleGameIdleBattleNode_Base:DestroyProp()
  if self.propReq then
    self.propReq:Destroy()
    self.propReq = nil
  end
  self.propObj = nil
  self.propAnim = nil
end

function T11IdleGameIdleBattleNode_Base:DestroyAssets()
  if self.assetReqs then
    for i, v in pairs(self.assetReqs) do
      v:Destroy()
    end
  end
  self.assetReqs = {}
end

function T11IdleGameIdleBattleNode_Base:CreateAsset(assetPath, parent, pos, rotation, finishCallback)
  local req = ResourceManager:InstantiateAsync(assetPath)
  req:completed("+", function(request)
    if request.isError or IsNull(request.gameObject) then
      return
    end
    request.gameObject.transform:SetParent(parent.transform)
    request.gameObject.transform:Set_localPosition(pos:Split())
    request.gameObject.transform:Set_localEulerAngles(rotation:Split())
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if finishCallback then
      finishCallback(request.gameObject)
    end
  end)
  table.insert(self.assetReqs, req)
  return req
end

function T11IdleGameIdleBattleNode_Base:ShowTips(text)
  if self.logic then
    local uiComp = self.logic:GetBattleUIComponent()
    if uiComp then
      uiComp:ShowBlueTips(text, 2)
    end
  end
end

function T11IdleGameIdleBattleNode_Base:RefreshUINodeInfoComponent()
  if self.logic then
    local uiComp = self.logic:GetBattleUIComponent()
    if uiComp then
      uiComp:RefreshPassedNodeInfoContent(self.data)
    end
  end
end

function T11IdleGameIdleBattleNode_Base:PlayUIFlyEffectToTaskBtn()
  if self.logic then
    local uiComp = self.logic:GetBattleUIComponent()
    if uiComp then
      uiComp:PlayFlyEffectToTaskBtn()
    end
  end
end

return T11IdleGameIdleBattleNode_Base
