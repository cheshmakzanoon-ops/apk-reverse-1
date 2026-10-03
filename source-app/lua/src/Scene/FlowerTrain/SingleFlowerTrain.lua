local SingleFlowerTrain = BaseClass("SingleFlowerTrain")
local GameObject = CS.UnityEngine.GameObject
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local CheerActor = require("Scene.FlowerTrain.FlowerTrainCheerActor")
local FlowerTrainConstant = require("DataCenter.FlowerTrain.FlowerTrainConstant")
local SingleFlowerTrainEffControl = require("Scene.FlowerTrain.SingleFlowerTrainEffControl")
local POINT_ROOT_PATH = "Assets/Main/Prefabs/World/FlowerTrain_World_Prefab/WorldTroopFlowerTrain4Custom.prefab"
local camera_follow_path = "CameraFollow"
local model_path = "Model"
local lv_img_path = "Model/Label/FlowerTrainLable/Root/LvImg"
local time_info_text_path = "Model/Label/FlowerTrainLable/Root/ProgressInfo/TimeInfoText"
local progress_val_path = "Model/Label/FlowerTrainLable/Root/ProgressInfo/ProgressVal"
local flower_train_lable_path = "Model/Label/FlowerTrainLable"
local bottom_tip_text_path = "Model/Label/FlowerTrainLable/Root/BottomTipText"
local SHOW_LOD = 2
local FAR_AWAY = Vector3.New(10000, 10000, 10000)
local EXP_SHOW_MAX_VALUE = 9999999
local EXP_WIDTH = 2.84
local EXP_HEIGHT = 0.366
local CHEER_SLOT_ROT_CONFIG = {
  [1] = {isRight = true, zOffset = 0},
  [2] = {isRight = false, zOffset = 0},
  [3] = {isRight = true, zOffset = 3},
  [4] = {isRight = false, zOffset = 3},
  [5] = {isRight = true, zOffset = 6},
  [6] = {isRight = false, zOffset = 6}
}

function SingleFlowerTrain:__init()
end

function SingleFlowerTrain:__delete()
  self:Destroy()
end

function SingleFlowerTrain:Init(index, singleUnitData, parent, cameraFollowTransform, flowerTrainCustomRoot)
  self.index = index
  self.parent = parent
  self.cameraFollowTransform = cameraFollowTransform
  self.flowerTrainCustomRoot = flowerTrainCustomRoot
  self.lod = CS.SceneManager.World:GetLodLevel()
  self.curAllCheerActorDic = {}
  self.now = UITimeManager:GetInstance():GetServerTime()
  self:UpdateSingleFlowerTrain(index, singleUnitData, parent)
end

function SingleFlowerTrain:UpdateSingleFlowerTrain(index, singleTrainData)
  self.index = index
  self.uuid = singleTrainData.uuid
  self.singleTrainData = singleTrainData
  self.marchInfo = singleTrainData.marchInfo
  self.marchUuid = self.marchInfo.uuid
  self:ParseMarchInfo()
  self:CreatePoint()
end

function SingleFlowerTrain:ParseMarchInfo()
  if not self.singleTrainData then
    Logger.LogError("SingleFlowerTrain:ParseMarchInfo singleTrainData is nil")
    return
  end
  self.speed = self.singleTrainData.speed
  self.pathList = self.singleTrainData.pathList
  self.startTime = self.singleTrainData.startTime
  self.endTime = self.singleTrainData.endTime
  self.startPointId = self.singleTrainData.startPointId
  self.endPointId = self.singleTrainData.endPointId
  self.startWorldPos = self.singleTrainData.startWorldPos
  self.endWorldPos = self.singleTrainData.endWorldPos
end

function SingleFlowerTrain:CreatePoint()
  if self.pointObj then
    self:OnPointLoadFinish()
    return
  end
  if self.pointReq then
    return
  end
  self.pointReq = Resource:InstantiateAsync(POINT_ROOT_PATH)
  self.pointReq:completed("+", function(request)
    self.pointObj = request.gameObject
    self.pointTrans = request.gameObject.transform
    self.pointTrans:SetParent(self.parent)
    self.pointTrans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.pointTrans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.pointTrans:Set_localPosition(0, 0, 0)
    self:OnPointLoadFinish()
  end)
end

function SingleFlowerTrain:OnPointLoadFinish()
  if not self.hasBlind then
    self.selfCameraFollowTransform = self.pointTrans:Find(camera_follow_path)
    self.modelRootTrans = self.pointTrans:Find(model_path)
    self.labelRootTrans = self.pointTrans:Find(flower_train_lable_path)
    self.lvImg = self.pointTrans:Find(lv_img_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.timeInfoText = self.pointTrans:Find(time_info_text_path):GetComponent(typeof(CS.SuperTextMesh))
    self.expProgressSlider = self.pointTrans:Find(progress_val_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.faceToCamera = self.pointTrans:Find(flower_train_lable_path):GetComponent(typeof(CS.AutoFaceToCamera))
    self.bottomTipsText = self.pointTrans:Find(bottom_tip_text_path):GetComponent(typeof(CS.SuperTextMesh))
    if self.faceToCamera then
      self.faceToCamera.IgnoreCacheRotation = true
    end
    self.hasBlind = true
  end
  self:CreatePrefab()
  self:RefreshBaseInfo()
  self:UpdateAllCheerActor()
  self:AdjustLabelYPos()
end

function SingleFlowerTrain:RefreshBaseInfo()
  if self.lvImg and self.singleTrainData then
    local lvImgPath = self.singleTrainData:GetLvImgPath()
    self.lvImg:LoadSpriteAsync(lvImgPath)
  end
  self:RefreshState()
end

function SingleFlowerTrain:OnTriggerClick()
  if self.cameraFollowTransform and self.selfCameraFollowTransform then
    self.cameraFollowTransform.position = self.selfCameraFollowTransform.position
  end
  UIUtil.OnClickFlowerTrain(self.marchUuid, self.index or 1)
end

function SingleFlowerTrain:CreatePrefab()
  local prefabPath = self.singleTrainData:GetPrefabPath()
  if not prefabPath or prefabPath == "" then
    Logger.LogError("SingleFlowerTrain:CreatePrefab prefabPath is nil")
    return
  end
  if self.carReq and self.carReq.PrefabPath == prefabPath then
    return
  elseif self.carReq then
    self.carReq:Destroy()
    self.carReq = nil
    if self.effCtrl then
      self.effCtrl:Destroy()
      self.effCtrl = nil
    end
  end
  self.carReq = Resource:InstantiateAsync(prefabPath)
  self.carReq:completed("+", function(request)
    self.carObj = request.gameObject
    self.carTrans = request.gameObject.transform
    self.carTrans:SetParent(self.modelRootTrans)
    self.carTrans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.carTrans:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.carTrans:Set_localPosition(0, 0, 0)
    self:OnPrefabLoadFinish()
  end)
end

function SingleFlowerTrain:OnPrefabLoadFinish()
  self.simpleAni = self.carTrans:GetComponentInChildren(typeof(CS.SimpleAnimation))
  self:CheckAndPlayAniWhenPrefabCreate()
  if not self.effCtrl then
    self.effCtrl = SingleFlowerTrainEffControl.New()
    self.effCtrl:Init(self.singleTrainData, self.carTrans)
    self.effCtrl:OnStateChange(nil, self.state)
  end
end

function SingleFlowerTrain:CheckAndPlayAniWhenPrefabCreate()
  local isInBron = self:IsInBornTime()
  if isInBron then
    local ret, bornTime = self:PlayAni("born")
    if ret then
      self.bornTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:PlayAni("move")
      end, bornTime)
    end
  else
    self:PlayAni("move")
  end
end

function SingleFlowerTrain:IsInBornTime()
  if not self.singleTrainData or not self.now then
    return false
  end
  local sendTime = self.singleTrainData.sendTime
  local diffTime = self.now - sendTime
  return diffTime < 2000
end

function SingleFlowerTrain:OnUpdate(now)
end

function SingleFlowerTrain:Update1000MS()
  self.now = UITimeManager:GetInstance():GetServerTime()
  self:RefreshState()
  self:UpdateAllCheerActor()
  self:CheckAndDestroyExpireActor()
  self:CheckCheerAni()
end

function SingleFlowerTrain:RefreshState()
  if not self.singleTrainData or not self.pointTrans then
    return
  end
  local curState = self.singleTrainData:GetCurState()
  if self.state ~= curState then
    local fromState = self.state
    local toState = curState
    self:OnStateChange(fromState, toState)
  end
  self.state = curState
  if self.state == FlowerTrainState.WaitingReward then
    self:RefreshWaitingRewardState()
  else
    self:RefreshNormalState()
  end
end

function SingleFlowerTrain:OnStateChange(fromState, toState)
  if self.effCtrl then
    self.effCtrl:OnStateChange(fromState, toState)
  end
end

function SingleFlowerTrain:RefreshWaitingRewardState()
  if not self.singleTrainData then
    return
  end
  local nextThrowLvBoxTime = self.singleTrainData:GetNextThrowLvBoxTime() or 0
  local remainTime = nextThrowLvBoxTime - self.now
  local remainTimeStr = UITimeManager:GetInstance():SecondToFmtString(remainTime / 1000)
  self.timeInfoText.text = remainTimeStr
  self.expProgressSlider:Set_size(EXP_WIDTH, EXP_HEIGHT)
  if not self.waitRewardStr then
    self.waitRewardStr = Localization:GetString("2025halloween_treasure_list_desc6")
  end
  self.bottomTipsText.text = self.waitRewardStr
end

function SingleFlowerTrain:RefreshNormalState()
  self:RefreshExpInfo()
  if not self.movingStr then
    self.movingStr = Localization:GetString("2025halloween_treasure_list_desc2")
  end
  self.bottomTipsText.text = self.movingStr
end

function SingleFlowerTrain:RefreshExpInfo()
  if not self.singleTrainData or not self.pointTrans then
    return
  end
  local curTotalExp = self.singleTrainData:GetCurTotalExp()
  local curLvFullExp = self.singleTrainData:GetCurLvFullExp()
  curLvFullExp = self.singleTrainData:IsMaxLv() and EXP_SHOW_MAX_VALUE or curLvFullExp
  curTotalExp = Mathf.Clamp(curTotalExp, 0, curLvFullExp)
  local curLvUpgradeTotalExp = self.singleTrainData:GetCurLvUpgradeCostTotalExp()
  local curLvUpgradeExp = self.singleTrainData:GetCurLvUpgradeCostExp()
  if self.singleTrainData:IsMaxLv() then
    self.expProgressSlider:Set_size(EXP_WIDTH, EXP_HEIGHT)
    self.timeInfoText.text = curTotalExp
  else
    local textStr = Localization:GetString(135225, curTotalExp, curLvUpgradeTotalExp + curLvUpgradeExp)
    self.timeInfoText.text = textStr
    local expProgressVal = Mathf.Clamp((curTotalExp - curLvUpgradeTotalExp) / curLvUpgradeExp, 0, 1)
    self.expProgressSlider:Set_size(EXP_WIDTH * expProgressVal, EXP_HEIGHT)
  end
end

function SingleFlowerTrain:UpdateMovement(now)
  self.position = self.position
  if self.pointTrans then
    self.pointTrans.position = self.position
  end
end

function SingleFlowerTrain:UpdateRotation(now)
  if not self.pointTrans then
    return
  end
  local moveDir = self.dir
  local curRotation = Quaternion.LookRotation(moveDir, Vector3.up)
  self.pointTrans:Set_rotation(curRotation.x, curRotation.y, curRotation.z, curRotation.w)
end

function SingleFlowerTrain:CalculateCurMovementState()
end

function SingleFlowerTrain:OnChangeCameraLod(lod)
  if not lod then
    return
  end
  self.lod = lod
  if self.curAllCheerActorDic then
    for _, v in pairs(self.curAllCheerActorDic) do
      v:OnChangeCameraLod(lod)
    end
  end
  if self.effCtrl then
    self.effCtrl:OnChangeCameraLod(lod)
  end
end

function SingleFlowerTrain:OnDisplayModeUpdate(displayLv)
  if self.curAllCheerActorDic then
    for _, v in pairs(self.curAllCheerActorDic) do
      v:OnDisplayModeUpdate(displayLv)
    end
  end
  if self.effCtrl then
    self.effCtrl:OnDisplayModeUpdate(displayLv)
  end
end

function SingleFlowerTrain:CheckModelShowHideState()
end

function SingleFlowerTrain:IsCanShowModel()
  return true
end

function SingleFlowerTrain:Destroy()
  if self.effCtrl then
    self.effCtrl:Destroy()
    self.effCtrl = nil
  end
  if self.carReq then
    self.carReq:Destroy()
    self.carReq = nil
  end
  if self.pointReq then
    self.pointReq:Destroy()
    self.pointReq = nil
  end
  self.hasBlind = false
  self.movingStr = nil
  self.waitRewardStr = nil
  self.simpleAni = nil
  if self.curAllCheerActorDic then
    for _, cheerActor in pairs(self.curAllCheerActorDic) do
      cheerActor:Destroy()
    end
    self.curAllCheerActorDic = nil
  end
  self:StopAllTimer()
end

function SingleFlowerTrain:CrossFade(aniName, fadeLength)
  if not self.simpleAni or string.IsNullOrEmpty(aniName) then
    return false
  end
  local anim = self.simpleAni:GetState(aniName)
  if anim == nil then
    return false
  end
  if self.simpleAni:IsPlaying(aniName) then
    self.simpleAni:Rewind(aniName)
  else
    self.simpleAni:Stop()
    self.simpleAni:CrossFade(aniName, fadeLength or 0.2)
  end
  return true
end

function SingleFlowerTrain:PlayAni(aniName)
  return self:PlayAnimationReturnTime(aniName)
end

function SingleFlowerTrain:PlayAnimationReturnTime(animName)
  if not self.simpleAni then
    return
  end
  if string.IsNullOrEmpty(animName) then
    return
  end
  local anim = self.simpleAni:GetState(animName)
  if anim == nil then
    return false, 1
  end
  if self.simpleAni:IsPlaying(animName) then
    self.simpleAni:Rewind(animName)
  else
    self.simpleAni:Play(animName)
  end
  return true, self.simpleAni:GetClipLength(animName)
end

function SingleFlowerTrain:StopAllTimer()
  if self.bornTimer then
    self.bornTimer:Stop()
    self.bornTimer = nil
  end
  if self.throwTimer then
    self.throwTimer:Stop()
    self.throwTimer = nil
  end
end

function SingleFlowerTrain:UpdateAllCheerActor()
  if not self:IsCanShowCheerActor() then
    self:HideAllCheerActor()
    return
  end
  if self.curAllCheerActorDic then
    for _, v in pairs(self.curAllCheerActorDic) do
      v:Update1000MS()
    end
  end
  if not self.pointObj or not self.singleTrainData then
    return
  end
  local cheerPlayerDic = self.singleTrainData:GetCheerPlayerInfo()
  if not cheerPlayerDic or table.count(cheerPlayerDic) <= 0 then
    return
  end
  for uid, cheerData in pairs(cheerPlayerDic) do
    local cheerTime = cheerData.cheerTime * 1000
    local cheerDurationTime = FlowerTrainUtils.GetCheerActorExistDuration()
    local disappearTime = cheerTime + cheerDurationTime
    local isNeedDisappear = disappearTime - self.now <= 2000
    if not isNeedDisappear then
      local cheerActor = self:GetCheerActor(uid)
      if cheerActor then
        cheerActor:UpdateDisappearTime(disappearTime)
      else
        local isSelf = LuaEntry.Player.uid == uid
        if self:IsSlotMax() then
          if isSelf then
            self:RandomDestroyOneCheerActor()
            goto lbl_82
          end
        else
          ::lbl_82::
          local data = {}
          data.uid = uid
          data.cheerTime = cheerTime
          data.pic = cheerData.pic
          data.picVer = cheerData.picVer
          data.headSkinId = cheerData.headSkinId
          data.headSkinET = cheerData.headSkinET
          data.disappearTime = disappearTime
          data.moveData = self:GetOneFreeCheerActorSlotPos()
          data.isSelf = isSelf
          data.actorPrefabPath = self.singleTrainData:GetCheerActorPrefabPath()
          if data and data.moveData then
            self:CreateOneCheerActor(data)
          end
        end
      end
    end
  end
end

function SingleFlowerTrain:CheckAndDestroyExpireActor()
  if not self.curAllCheerActorDic then
    return
  end
  local allNeedDestroyActorUidList
  for _, cheerActor in pairs(self.curAllCheerActorDic) do
    if cheerActor:IsExpire() then
      allNeedDestroyActorUidList = allNeedDestroyActorUidList or {}
      table.insert(allNeedDestroyActorUidList, cheerActor.uid)
    end
  end
  if allNeedDestroyActorUidList then
    for _, actorUid in ipairs(allNeedDestroyActorUidList) do
      self:DestroyOneCheerActor(actorUid)
    end
  end
end

function SingleFlowerTrain:CreateOneCheerActor(data)
  if not data then
    return
  end
  local cheerPlayerUid = data.uid
  local cheerActor = self:GetCheerActor(cheerPlayerUid)
  if not cheerActor then
    cheerActor = CheerActor.New()
    cheerActor:Init(self.flowerTrainCustomRoot, self.pointTrans, data)
    self.curAllCheerActorDic[cheerPlayerUid] = cheerActor
  end
end

function SingleFlowerTrain:RandomDestroyOneCheerActor()
  if not self.curAllCheerActorDic then
    return
  end
  for uid, v in pairs(self.curAllCheerActorDic) do
    self:DestroyOneCheerActor(uid)
    break
  end
end

function SingleFlowerTrain:HideAllCheerActor()
  for _, cheerActor in pairs(self.curAllCheerActorDic) do
    local isLoadFinish = cheerActor:IsLoadFinish()
    if not isLoadFinish then
      local uid = cheerActor:GetUid()
      self:DestroyOneCheerActor(uid)
    else
      cheerActor:Hide()
    end
  end
end

function SingleFlowerTrain:DestroyOneCheerActor(cheerPlayerUid)
  if not cheerPlayerUid then
    return
  end
  local cheerActor = self:GetCheerActor(cheerPlayerUid)
  if cheerActor then
    cheerActor:Destroy()
  end
  self.curAllCheerActorDic[cheerPlayerUid] = nil
end

function SingleFlowerTrain:GetCheerActor(cheerPlayerUid)
  if not cheerPlayerUid then
    return
  end
  return self.curAllCheerActorDic[cheerPlayerUid]
end

function SingleFlowerTrain:GetOneFreeCheerActorSlotPos()
  local curActorCount = self:GetCurGenCheerActorCount()
  local posCfg = CHEER_SLOT_ROT_CONFIG[curActorCount + 1]
  if not posCfg then
    return nil
  end
  local curForward = self.parent.transform.forward
  local angle = posCfg.isRight and 90 or -90
  local zOffset = posCfg.zOffset + FlowerTrainConstant.FlowerTrainDropFrontDist
  local offsetDir = Quaternion.AngleAxis(angle, Vector3.up) * Vector3.New(curForward.x, curForward.y, curForward.z)
  local runDist = FlowerTrainConstant.FlowerTrainCheerNearCarDist + FlowerTrainConstant.FlowerTrainCheerRunDist
  local fromPos = self.parent.transform.position + offsetDir:SetNormalize() * runDist + curForward.normalized * zOffset
  local targetPos = self.parent.transform.position + offsetDir:SetNormalize() * FlowerTrainConstant.FlowerTrainCheerNearCarDist + curForward.normalized * zOffset
  local targetRotation = Quaternion.LookRotation(Vector3.New(-offsetDir.x, -offsetDir.y, -offsetDir.z))
  local data = {}
  data.fromPos = fromPos
  data.targetPos = targetPos
  data.targetRot = targetRotation
  return data
end

function SingleFlowerTrain:IsSlotMax()
  return self:GetCurGenCheerActorCount() == #CHEER_SLOT_ROT_CONFIG
end

function SingleFlowerTrain:GetCurGenCheerActorCount()
  return self.curAllCheerActorDic and table.count(self.curAllCheerActorDic) or 0
end

function SingleFlowerTrain:IsCanShowCheerActor()
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local isSimpleMode = displayLv < 0
  if isSimpleMode then
    return false
  end
  return true
end

function SingleFlowerTrain:CheckCheerAni()
  if not self.singleTrainData then
    return
  end
  local curCheerCount = self.singleTrainData:GetCheerCount()
  if curCheerCount <= (self.cheerAniCountCache or 0) then
    return
  end
  self.cheerAniCountCache = curCheerCount
  local randomAni = 1 < math.random(1, 2) and "throwRight" or "throwLeft"
  local ret, time = self:PlayAnimationReturnTime(randomAni or "throwRight")
  if not ret then
    return
  end
  if self.throwTimer then
    self.throwTimer:Stop()
  end
  self.throwTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:CrossFade("move")
    self.throwTimer = nil
  end, time)
end

function SingleFlowerTrain:AdjustLabelYPos()
  if not self.labelRootTrans then
    return
  end
  if not self.singleTrainData or not self.singleTrainData.paraMeta then
    return
  end
  if string.IsNullOrEmpty(self.singleTrainData.paraMeta.title_offset) then
    return
  end
  local offsetY = toInt(self.singleTrainData.paraMeta.title_offset)
  self.labelRootTrans.localPosition = Vector3.New(0, offsetY, 0)
end

return SingleFlowerTrain
