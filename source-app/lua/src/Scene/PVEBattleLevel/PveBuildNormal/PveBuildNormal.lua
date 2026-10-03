local PveBuildNormal = BaseClass("PveBuildNormal")
local model_path = "Model"
local shop_collider_path = "ShopTrigger"
local buff_pos_path = "BuffPos"
local wait_move_pos_path = "WaitMovePos"
local collider_path = "Collider"
local ShopTriggerDistance = 1

function PveBuildNormal:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:DataDefine()
  self:ComponentDefine()
end

function PveBuildNormal:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function PveBuildNormal:ComponentDefine()
  self.anim = self.transform:Find(model_path):GetComponent(typeof(CS.SimpleAnimation))
  self.pos_go = self.transform:Find(buff_pos_path)
  self.wait_move_go = self.transform:Find(wait_move_pos_path)
  local collider = self.transform:Find(collider_path)
  if collider ~= nil then
    self.colliderPos = collider.transform.position
    local have, cap = collider.gameObject:TryGetComponent(typeof(CS.UnityEngine.CapsuleCollider))
    if have and cap ~= nil then
      self.colliderRadius = cap.radius
    end
  end
end

function PveBuildNormal:ComponentDestroy()
  self:RemoveShopTrigger()
  self.wait_move_go = nil
  self.buff_pos = nil
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function PveBuildNormal:DataDefine()
  self.param = nil
  self.buff_pos = nil
  self.wait_move_pos = nil
  self.isInTrigger = false
  self.shopTriggerDirection = nil
  self.shopTriggerAni = nil
  self.triggerPos = nil
  self.colliderRadius = 2
end

function PveBuildNormal:DataDestroy()
  self.param = nil
  self.buff_pos = nil
  self.wait_move_pos = nil
  self.isInTrigger = nil
  self.shopTriggerDirection = nil
  self.shopTriggerAni = nil
  self.triggerPos = nil
end

function PveBuildNormal:ReInit(param)
  self.param = param
  if self.pos_go ~= nil then
    self.buff_pos = self.pos_go.transform.position
  end
  if self.wait_move_go ~= nil then
    self.wait_move_pos = self.wait_move_go.transform.position
  end
  self:RefreshBuildShop()
  self:DoAnim()
  self:CheckColliderActive()
end

function PveBuildNormal:RefreshAnim(animName)
  if self.param.animName ~= animName then
    self.param.animName = animName
    self:DoAnim()
  end
end

function PveBuildNormal:DoAnim()
  if self.anim ~= nil and self.param.animName ~= nil and self.param.animName ~= "" then
    self.anim:Play(self.param.animName)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_guide_show_build, false)
    BuildBoxFinishEffectManager:GetInstance():ShowOneEffect(self.param.buildName, SceneUtils.WorldToTileIndex(self.param.pos), BuildTilesSize.Two)
  end
end

function PveBuildNormal:IsShowShop()
  if self.buff_pos ~= nil and self.param.buffTriggerList ~= nil and table.count(self.param.buffTriggerList) > 0 then
    for k, v in ipairs(self.param.buffTriggerList) do
      for k1, v1 in ipairs(v) do
        local trigger = DataCenter.BattleLevel:GetTriggerByTriggerId(v1)
        if not trigger:IsTriggerOK() then
          return true
        end
      end
    end
  end
  return false
end

function PveBuildNormal:ChangeParam(param)
  self.param = param
  self:RefreshBuildShop()
end

function PveBuildNormal:GetModelPos()
  if self.buff_pos ~= nil then
    return self.buff_pos
  end
  return self.transform.position
end

function PveBuildNormal:RefreshBuildShop()
  if self:IsShowShop() then
    if self.isInTrigger then
      local param = {}
      param.buff_pos = self.buff_pos
      param.buffTriggerList = self.param.buffTriggerList
      param.wait_move_pos = self.wait_move_pos
      param.id = self.param.id
      param.triggerPosId = self.triggerPosId
      param.triggerId = self.param.triggerId
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEShop, {anim = true}, param)
    end
    self.pos_go.gameObject:SetActive(true)
    self:RefreshTrigger(self.param.triggerDirection or PveBuildTriggerDirection.Bottom)
  else
    self.pos_go.gameObject:SetActive(false)
    self:RefreshTrigger(nil)
  end
end

function PveBuildNormal:RefreshTrigger(triggerDirection)
  if self.shopTriggerDirection ~= triggerDirection then
    self:RemoveShopTrigger()
    self.shopTriggerDirection = triggerDirection
    self:AddShopTrigger()
  end
end

function PveBuildNormal:AddShopTrigger()
  if self.shopTriggerDirection ~= nil then
    local triggerName = shop_collider_path .. self.shopTriggerDirection
    local collider = self.transform:Find(triggerName)
    if collider ~= nil then
      collider.gameObject:SetActive(true)
      self.shopTriggerAni = collider.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
      self.triggerPosId = DataCenter.BattleLevel:GetPosId(SceneUtils.TileIndexToWorld(SceneUtils.WorldToTileIndex(collider.transform.position)))
      self.triggerPos = collider.transform.position
    end
  end
end

function PveBuildNormal:PlayScaleUp()
  if self.shopTriggerAni ~= nil then
    self.shopTriggerAni:Play("fangda")
  end
end

function PveBuildNormal:PlayScaleDown()
  if self.shopTriggerAni ~= nil then
    self.shopTriggerAni:Play("suoxiao")
  end
end

function PveBuildNormal:RemoveShopTrigger()
  if self.shopTrigger ~= nil then
    self.shopTrigger.gameObject:SetActive(false)
    self.shopTrigger.OnCollisionEnterAction = nil
    self.shopTrigger.OnCollisionExitAction = nil
    self.shopTrigger = nil
  end
end

function PveBuildNormal:CheckColliderActive()
  local originalPointId = SceneUtils.WorldToTileIndex(self.param.pos)
  local intRadius, _ = math.modf((self.colliderRadius + 1) / 2)
  local pointId
  for x = -intRadius, intRadius do
    for y = -intRadius, intRadius do
      pointId = SceneUtils.GetIndexByOffset(originalPointId, x, y)
      local list = DataCenter.BattleLevel.collectionMgr:GetCollectList(pointId)
      if list ~= nil then
        for k1, v1 in ipairs(list) do
          if Vector3.Distance(v1:GetPosition(), self.colliderPos) <= self.colliderRadius then
            v1:SetVisible(false)
          end
        end
      end
    end
  end
end

function PveBuildNormal:OnPlayerMoveSignal(pos)
  if self.triggerPos ~= nil then
    local distance = Vector3.Distance(pos, self.triggerPos)
    if distance <= ShopTriggerDistance then
      if self.isInTrigger ~= true then
        self.isInTrigger = true
        if self:IsShowShop() then
          local param = {}
          param.buff_pos = self.buff_pos
          param.buffTriggerList = self.param.buffTriggerList
          param.wait_move_pos = self.wait_move_pos
          param.id = self.param.id
          param.triggerPosId = self.triggerPosId
          param.triggerId = self.param.triggerId
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEShop, {anim = true}, param)
          self:PlayScaleUp()
        end
      end
    elseif self.isInTrigger ~= false then
      self.isInTrigger = false
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVEShop)
      self:PlayScaleDown()
    end
  end
end

return PveBuildNormal
