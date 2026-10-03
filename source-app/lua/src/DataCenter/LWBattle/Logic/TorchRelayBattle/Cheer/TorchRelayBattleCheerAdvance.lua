local FSMachine = require("Common.FSMachine")
local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local base = require("DataCenter/LWBattle/Logic/TorchRelayBattle/Cheer/TorchRelayBattleCheerBase")
local TorchConstant = require("DataCenter/LWBattle/Logic/TorchRelayBattle/TorchRelayBattleConstant")
local TorchRelayBattleCheerAdvance = BaseClass("TorchRelayBattleCheerAdvance", base)

function TorchRelayBattleCheerAdvance:__init(cheerTemplate, sceneIndex, logic, data)
  self.logic = logic
  self.cheerTemplate = cheerTemplate
  self.sceneIndex = sceneIndex
  self.cheerData = data
  self.animData = nil
  self.shadowStartPosZ = nil
  self.dropItemStartPosZ = nil
  self.triggeredShadow = false
  self.triggeredDropItem = false
  if self.logic and self.logic.activityId and self.logic.data then
    local actData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.logic.activityId)
    if actData then
      local growUpSpeedLevel = actData:GetGrowUpLevelByType(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed)
      local growUpSpeedTemplate = actData:GetGrowUpConfig(DataCenter.ActivityTorchRelayManager.GrowUpType.Speed, growUpSpeedLevel)
      if growUpSpeedTemplate then
        self.animData = growUpSpeedTemplate:GetAdvanceCheerShowData()
        local sceneConfig = self.logic.data:GetSceneConfigAtIndex(self.sceneIndex)
        if sceneConfig then
          self.shadowStartPosZ = sceneConfig.offset - self.animData.shadowPreZDistance
          self.dropItemStartPosZ = sceneConfig.offset - self.animData.dropItemPreZDistance
          self.logic:PrintEditorLog(string.format("\233\171\152\231\186\167\229\138\169\229\168\129\233\163\158\230\156\186\232\167\166\229\143\145\232\183\157\231\166\187\239\188\154%s, \233\129\147\229\133\183\232\167\166\229\143\145\232\183\157\231\166\187\239\188\154%s", tostring(self.shadowStartPosZ), tostring(self.dropItemStartPosZ)))
        end
      end
    end
  end
  if self.animData == nil and self.logic then
    self.logic:PrintRealErrorLog("advance cheer init failed, null anim data")
  end
end

function TorchRelayBattleCheerAdvance:__delete()
  self.logic = nil
  self.cheerTemplate = nil
  self.sceneIndex = nil
end

function TorchRelayBattleCheerAdvance:AddListener()
end

function TorchRelayBattleCheerAdvance:RemoveListener()
end

function TorchRelayBattleCheerAdvance:OnSceneChanged(evtData)
  if not self.logic then
    return
  end
  if evtData ~= nil and evtData.curSceneData ~= nil then
    local sceneData = evtData.curSceneData
    if sceneData.index == self.sceneIndex - 1 then
      if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.logic:PrintEditorLog("\229\138\169\229\168\129", "\229\189\177\229\173\144")
        self:TriggerShadow(sceneData)
      end, 2)
    elseif sceneData.index > self.sceneIndex then
    end
  end
end

function TorchRelayBattleCheerAdvance:TriggerShadow()
  if self.logic then
    self.logic:PrintEditorLog("\233\171\152\231\186\167\229\138\169\229\168\129", "\232\167\166\229\143\145\228\186\134\233\163\158\230\156\186\229\138\168\231\148\187")
  end
  if not self.animData or not self.shadowStartPosZ then
    return
  end
  local req = Resource:InstantiateAsync(TorchConstant.CHEER_ADVANCE_SHADOW_ASSET_PATH)
  req:completed("+", function()
    if req.isError then
      req:Destroy()
      return
    end
    self.shadowObj = req.gameObject
    self.transShadow = req.gameObject.transform
    self.transShadow:Set_position(TorchConstant.PLAYER_BIRTH_POS.x, 0, self.shadowStartPosZ)
    self.transShadow:DOMove(self.transShadow.position + Vector3(0, 0, self.animData.shadowPlayZDistance), self.animData.shadowPlayTime):OnComplete(function()
      self:DestroyShadow()
    end):SetEase(CS.DG.Tweening.Ease.OutCubic)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_torch_relay_plane)
  end)
  self.req = req
end

function TorchRelayBattleCheerAdvance:StartDropItems()
  if self.logic then
    self.logic:PrintEditorLog("\233\171\152\231\186\167\229\138\169\229\168\129", "\232\167\166\229\143\145\228\186\134\233\129\147\229\133\183\228\184\139\232\144\189")
  end
  if self.logic and self.sceneIndex then
    local scene = self.logic:GetSceneByIndex(self.sceneIndex)
    if not scene then
      return
    end
    scene:DropAllItems()
  end
end

function TorchRelayBattleCheerAdvance:DestroyShadow()
  if not IsNull(self.req) then
    self.req:Destroy()
  end
  self.req = nil
end

function TorchRelayBattleCheerAdvance:Destroy()
  self:DestroyShadow()
end

function TorchRelayBattleCheerAdvance:OnUpdate(dt)
  if not self.shadowStartPosZ or not self.dropItemStartPosZ then
    return
  end
  if (not self.triggeredShadow or not self.triggeredDropItem) and self.logic and self.logic.player then
    local curPosZ = self.logic.player:GetPosition().z
    if curPosZ >= self.shadowStartPosZ and not self.triggeredShadow then
      self:TriggerShadow()
      self:TriggerMainUI()
      self.triggeredShadow = true
    end
    if curPosZ >= self.dropItemStartPosZ and not self.triggeredDropItem then
      self:StartDropItems()
      self.triggeredDropItem = true
    end
  end
end

function TorchRelayBattleCheerAdvance:GetSceneIndex()
  if self.sceneIndex then
    return self.sceneIndex
  end
  return 0
end

function TorchRelayBattleCheerAdvance:GetRare()
  if self.cheerTemplate ~= nil then
    return self.cheerTemplate.cheer_rare
  end
  return -1
end

function TorchRelayBattleCheerAdvance:GetTemplate()
  return self.cheerTemplate
end

return TorchRelayBattleCheerAdvance
