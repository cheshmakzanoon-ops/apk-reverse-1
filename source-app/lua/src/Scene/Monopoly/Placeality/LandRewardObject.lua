local base = require("Scene.Monopoly.Base.BaseObject")
local LandRewardObject = BaseClass("LandRewardObject", base)
local Const = require("Scene.Monopoly.Const")

function LandRewardObject:OnDelete()
  if self.res then
    if not IsNull(self.gameObject) and not IsNull(self.gameObject.transform) then
      self.gameObject.transform.localScale = self.initScale
    end
    self.res:Destroy()
    self.res = nil
    self.gameObject = nil
    self.initScale = nil
  end
  if self.boxEffectRes then
    self.boxEffectRes:Destroy()
    self.boxEffectRes = nil
  end
  if not IsNull(self.trigger) then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
  self.id = nil
  self.pos = nil
  self.gameObject = nil
  self.simpleAnim = nil
  if self.fingerClickHandleTimer then
    self.fingerClickHandleTimer:Stop()
    self.fingerClickHandleTimer = nil
  end
  if self.fingerClickHandle then
    self.fingerClickHandle:Destroy()
    self.fingerClickHandle = nil
  end
end

function LandRewardObject:Init(id)
  local data = DataCenter.LandLockManager:GetLandLockDataById(id)
  self.id = id
  local pointId = data:GetPointId()
  self.pos = SceneUtils.TileIndexToWorld(pointId)
  if data then
    self.res = self:CreateObject(Const.boxPath, function(req)
      req.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId)
      req.gameObject.transform:Set_position(self.pos.x, self.pos.y, self.pos.z)
      self.gameObject = req.gameObject
      req.gameObject.transform:SetParent(self.mgr.parent.transform)
      self.initScale = Vector3.New(self.gameObject.transform.localScale.x, self.gameObject.transform.localScale.y, self.gameObject.transform.localScale.z)
      self.gameObject.transform.rotation = Vector3.New(0, 180, 0)
      self.gameObject.transform.localScale = Vector3.New(2, 2, 2)
      self.trigger = req.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
      if self.trigger then
        function self.trigger.onPointerClick()
          self:OnTriggerClick()
        end
      end
      self.simpleAnim = self.gameObject.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
      if not IsNull(self.simpleAnim) then
        self.simpleAnim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
      end
      self:PlayAnim(Const.animNames.idle)
      if id == 5 then
        self.fingerClickHandle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/LWOpeningStage/finger_click.prefab")
        self.fingerClickHandle:completed("+", function(handle)
          if handle.isError then
            return
          end
          local gameObject = handle.gameObject
          local transform = gameObject.transform
          transform.position = req.gameObject.transform.position + Vector3(0, 3, 0)
          transform.localScale = Vector3.one * 2
          self.fingerClickHandleTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.fingerClickHandleTimer = nil
            if self.fingerClickHandle then
              self.fingerClickHandle:Destroy()
              self.fingerClickHandle = nil
            end
          end, 4)
        end)
      end
    end)
    self.mgr.effectMgr:ShowEffectObj(Const.unlockEffectPath, self.pos, nil, nil, 2)
  end
end

function LandRewardObject:OnTriggerClick()
  local obj = DataCenter.MonopolyManager:GetOneReward()
  if obj and obj.id ~= self.id then
    GoToUtil.GotoPos(obj.pos, CS.SceneManager.World.InitZoom, 0.2)
    UIUtil.ShowTipsId(800782)
    return
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Env_NewArea_TL, false)
  local effectPos = Vector3.New(self.pos.x, self.pos.y + 2, self.pos.z)
  self.mgr.effectMgr:ShowEffectObj(Const.boxOpenEffectPath, effectPos)
  if self.id then
    SFSNetwork.SendMessage(MsgDefines.UnlockUserLand, self.id)
  end
  if self.mgr then
    self.mgr:LandLockRewardEndById(self.id)
  end
end

return LandRewardObject
