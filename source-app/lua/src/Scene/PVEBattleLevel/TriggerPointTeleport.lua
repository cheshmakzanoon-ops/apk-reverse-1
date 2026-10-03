local TriggerPointTeleport = BaseClass("TriggerPointTeleport")
local Const = require("Scene.PVEBattleLevel.Const")
local Tweening = CS.DG.Tweening
local Resource = CS.GameEntry.Resource
local root_path = "Root"
local icon_path = "Root/Icon"
local trigger_path = "Root/Trigger"
local MIN_DISTANCE = 1

function TriggerPointTeleport:__init(request)
  self.request = request
  self.tween = nil
end

function TriggerPointTeleport:__delete()
  self.request = nil
  self.tween = nil
end

function TriggerPointTeleport:Create()
  self.gameObject = self.request.gameObject
  self.transform = self.request.gameObject.transform
  self.root_go = self.transform:Find(root_path).gameObject
  self.root_go.transform.rotation = Quaternion.identity
  self.tween = self.root_go.transform:DORotate(Vector3.New(0, 360, 0), 3, Tweening.RotateMode.FastBeyond360):SetEase(Tweening.Ease.Linear):SetLoops(-1, Tweening.LoopType.Restart)
  self.sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.UIEventTrigger))
  
  function self.trigger.onPointerClick()
    self:OnClick()
  end
  
  self.root_go:SetActive(DataCenter.BattleLevel.isHighView)
end

function TriggerPointTeleport:Destroy()
  self.gameObject = nil
  self.transform = nil
  self.root_go = nil
  self.sprite = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.trigger ~= nil then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
end

function TriggerPointTeleport:OnSetHighView(isHighView)
  if self.root_go ~= nil then
    self.root_go:SetActive(isHighView)
  end
end

function TriggerPointTeleport:OnClick()
  local player = DataCenter.BattleLevel:GetPlayer()
  if player == nil then
    return
  end
  local pos = self.transform.position
  local playerPos = player:GetPosition():Clone()
  local targetPos = Vector3.New(pos.x, 0, pos.z)
  if Vector3.Distance(playerPos, targetPos) < MIN_DISTANCE then
    return
  end
  if self.gameObject.name ~= Const.TeleportBackName then
    DataCenter.BattleLevel:CreateTeleportBack(playerPos)
  else
    DataCenter.BattleLevel:DestroyTeleportBack()
  end
  DataCenter.BattleLevel:SetPosition(targetPos, true)
  DataCenter.BattleLevel:CreateTeleportEffect(playerPos)
  DataCenter.BattleLevel:CreateTeleportEffect(targetPos)
end

function TriggerPointTeleport:CreateEffect(pos)
  local req = Resource:InstantiateAsync(UIAssets.PveHeroSummon)
  req:completed("+", function()
    if req.isError or req.gameObject == nil then
      req:Destroy()
      return
    end
    local go = req.gameObject
    go:SetActive(true)
    local tf = go.transform
    tf.position = pos
    TimerManager:GetInstance():DelayInvoke(function()
      if req ~= nil then
        req:Destroy()
      end
    end, 2)
  end)
end

return TriggerPointTeleport
