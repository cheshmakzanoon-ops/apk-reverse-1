local base = require("Scene.Monopoly.Base.BaseObject")
local Placeality = BaseClass("Placeality", base)
local Const = require("Scene.Monopoly.Const")
local Resource = CS.GameEntry.Resource

function Placeality:ArrivalBefore()
end

function Placeality:__init(mgr, obstacle)
  base.__init(self, mgr)
  self.obstacle = obstacle
end

function Placeality:__delete()
  base.__delete(self)
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
    self.modelTrigger = nil
  end
  if self.Res then
    self.Res:Destroy()
    self.Res = nil
  end
  if self.EffRes then
    self.EffRes:Destroy()
    self.EffRes = nil
  end
  self.obstacle = nil
end

function Placeality:CreatedModel(path, fun)
  local loadPath = path and path or self.data.pad_before
  if self.data.state == MonopolyPlacealityType.Leave and path == nil and not string.IsNullOrEmpty(self.data.pad_after) then
    loadPath = self.data.pad_after
  end
  if self.Res then
    self.Res:Destroy()
    self.Res = nil
  end
  if self.gameObject then
    self.gameObject = nil
  end
  self.Res = Resource:InstantiateAsync(string.format(UIAssets.MonopolyTiles, loadPath))
  self.Res:completed("+", function(req)
    local pos = self.data:GetCenterWorldPos()
    req.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
    self.gameObject = req.gameObject
    if self.mgr.parent.transform then
      self.gameObject.transform:SetParent(self.mgr.parent.transform)
    end
    self.simpleAnim = self.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not IsNull(self.simpleAnim) then
      self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
    end
    if fun then
      fun()
    end
    self.modelTrigger = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.modelTrigger then
      function self.modelTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
  end)
end

function Placeality:ClearTrigger()
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
  end
end

function Placeality:ShowCondition(curId)
  if not (curId < self.data.id and self.data.showCondition ~= MonplolyObstacleShowCondition.Every and (not self.obstacle or self.data.showCondition ~= MonplolyObstacleShowCondition.UnLandLock or not self.obstacle.gameObject) and self.data.showCondition == MonplolyObstacleShowCondition.MainLv and self.data.showConditionMainLv and self.data.showConditionMainLv <= DataCenter.BuildManager:GetMainLevel()) or self.obstacle.gameObject then
  end
end

function Placeality:OnTriggerClick()
  local tempData = DataCenter.MonopolyManager.dataManager:GetCurData()
  if tempData and self.obstacle and self.data then
    if self.data.id == tempData.id then
      self.obstacle:OnBattleEffectTriggerClick()
    elseif self:ShowCondition(tempData.id) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIMonopolyObstacleInfo, {anim = true}, self.data)
    end
  end
end

function Placeality:ShowOccupyEffect()
  local pos = self.data:GetCenterWorldPos()
  local effectPos = Vector3.New(pos.x, pos.y + 0.2, pos.z)
  self.mgr.effectMgr:ShowEffectObj(Const.placealityOccupyEffectPath, effectPos)
  self:RefreshCaptureRes()
end

function Placeality:ShowMoveEffect()
  if self.moveEffectRes then
    return
  end
  local pos = self.data:GetCenterWorldPos()
  local effectPos = Vector3.New(pos.x, pos.y + 0.3, pos.z)
  self.effectId = self.mgr.effectMgr:ShowEffectObj(Const.placealityEffectPath, effectPos, nil, nil, 9999)
end

function Placeality:DeleteMoveEffect()
  self.mgr.effectMgr:DestroyEffectById(self.effectId)
end

function Placeality:RefreshCaptureRes()
  self:CreatedModel(self.data.pad_after, function()
    self:PlayAnim("down")
  end)
end

return Placeality
