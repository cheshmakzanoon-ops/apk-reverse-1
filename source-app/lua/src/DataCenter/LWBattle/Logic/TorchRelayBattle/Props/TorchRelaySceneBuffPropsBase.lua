local TorchRelayScenePropsBase = require("DataCenter.LWBattle.Logic.TorchRelayBattle.Props.TorchRelayScenePropsBase")
local TorchRelaySceneBuffPropsBase = BaseClass("TorchRelaySceneBuffPropsBase", TorchRelayScenePropsBase)
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local base = TorchRelayScenePropsBase
local Resource = CS.GameEntry.Resource

function TorchRelaySceneBuffPropsBase:Init()
  base.Init(self)
  self.isCheerItem = false
  self.isFollowPlayer = false
  self.velocityTmp = Vector3.unity_vector3(0, 0, 0)
end

function TorchRelaySceneBuffPropsBase:ReInit(bornData, sceneRoot, logic)
  TorchRelayScenePropsBase.ReInit(self, bornData, sceneRoot, logic)
  self.isFollowPlayer = false
end

function TorchRelaySceneBuffPropsBase:OnUpdate(dt)
  base.OnUpdate(self, dt)
  self:UpdateCheer(dt)
  if self.isFollowPlayer and self.logic and self.logic.player and self.logic.player.transform and self.transform then
    local targetPos
    local curVec = Vector3.New(self.transform.position.x, self.transform.position.y, self.transform.position.z)
    local targetVec = Vector3.New(self.logic.player.transform.position.x, self.logic.player.transform.position.y, self.logic.player.transform.position.z)
    local magneticSpeed = self.logic.data.stage:GetMagneticSpeed()
    targetPos = Vector3.MoveTowards(curVec, targetVec, magneticSpeed * dt)
    self.transform:Set_position(targetPos:Split())
  end
end

function TorchRelaySceneBuffPropsBase:UpdateCheer(dt)
  if not self.isCheerItem then
    return
  end
  if self.cheerFlyTime and self.logic and self.logic.player and self.transform then
    local distance = Vector3.Distance(self.transform.position, self.logic.player.transform.position)
    if distance <= TorchConstant.CHEER_ITEM_ATTRACTION_DISTANCE then
      self:SetFollowPlayer(true)
      self.cheerFlyTime = nil
    else
      if self.transform.position.y < self.logic.player.transform.position.y then
        return
      end
      self.cheerFlyTime = self.cheerFlyTime + dt
      local speed = self.verticalSpeed - TorchConstant.CHEER_ITEM_GRAVITY * self.cheerFlyTime
      self.transform:Translate(self.transform.forward * TorchConstant.CHEER_ITEM_FLY_SPEED * dt, CS.UnityEngine.Space.World)
      self.transform:Translate(self.transform.up * speed * dt, CS.UnityEngine.Space.World)
    end
  end
end

function TorchRelaySceneBuffPropsBase:SetFollowPlayer(isOn)
  self.isFollowPlayer = isOn
end

function TorchRelaySceneBuffPropsBase:SetIsCheerItem(isOn)
  self.isCheerItem = isOn
  if isOn and self.logic and self.logic.player then
    local playerPos = self.logic.player.transform.position
    local targetPos = CS.UnityEngine.Vector3(playerPos.x, playerPos.y, playerPos.z)
    targetPos.z = targetPos.z + TorchConstant.CHEER_ITEM_FORWARD_Z_DISTANCE
    local playerDis = Vector3.Distance(self.transform.position, targetPos)
    local time = playerDis / TorchConstant.CHEER_ITEM_FLY_SPEED
    local riseTime = time / 2
    local downTime = time / 2
    self.verticalSpeed = TorchConstant.CHEER_ITEM_GRAVITY * riseTime
    if self.transform then
      self.transform:LookAt(targetPos)
    end
    self.cheerFlyTime = 0
  end
end

function TorchRelayScenePropsBase:DoDropToFloor()
  if self.bornData and self.bornData.dropToFloor then
    if not self.transform then
      return
    end
    self.bornData.dropToFloor = false
    self.transform:DOMoveY(0, 2):SetEase(CS.DG.Tweening.Ease.OutCubic)
    local req = Resource:InstantiateAsync(TorchConstant.CHEER_ADVANCE_PARACHUTE_ASSET_PATH)
    req:completed("+", function()
      if req.isError or not self.transform then
        req:Destroy()
        return
      end
      req.gameObject.transform:SetParent(self.transform)
      local x, y, z = ResetPosition:Split()
      y = y - 1
      req.gameObject.transform:Set_localPosition(x, y, z)
      req.gameObject:SetActive(false)
      req.gameObject:SetActive(true)
    end)
    self.parachuteReq = req
  end
end

return TorchRelaySceneBuffPropsBase
