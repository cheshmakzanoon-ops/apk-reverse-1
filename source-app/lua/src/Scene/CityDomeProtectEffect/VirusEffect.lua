local VirusEffect = BaseClass("VirusEffect")
local Localization = CS.GameEntry.Localization
local explode_path = "explode"
local tip_text_path = "explode/Tips/Image/tipText"
local tip_time_path = "explode/Tips/Image/tipTime"

function VirusEffect:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.numNode = self.transform:Find("num")
    self.numNode:Set_localScale(1, 1, 1)
    self.virus_level = self.transform:Find("num/level"):GetComponent(typeof(CS.SuperTextMesh))
    self.virus_icon = self.transform:Find("num/iconVirus"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.explode_root = self.transform:Find(explode_path).gameObject
    self.explode_tip_text = self.transform:Find(tip_text_path):GetComponent(typeof(CS.TextMeshProUGUIEx))
    self.explode_tip_time = self.transform:Find(tip_time_path):GetComponent(typeof(CS.TextMeshProUGUIEx))
    self.explode_root:SetActive(false)
    self.gameObject:SetActive(false)
    
    function self.timer_action(temp)
      if self.lod == 1 or self.lod == 2 then
        self:CheckVirusFinish()
        self:CheckVirusExplode()
      elseif IsNotNull(self.gameObject) then
        self.gameObject:SetActive(false)
      end
    end
    
    self.virusLifeTime = toInt(GetTableData(TableName.StatusTab, CityState.VirusCity, "time", 300))
    self.maxHp = LuaEntry.Effect:GetGameEffect(EffectDefine.MAX_MY_CITY_DEFENCE)
  end
end

function VirusEffect:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self:DeleteTimer()
  self.explodeTime = nil
  self.timer_action = nil
  self.gameObject = nil
  self.transform = nil
  self.virus_level = nil
  self.bUuid = nil
end

function VirusEffect:OnPlayerHPChanged()
  if self.bUuid == nil or self.transform == nil or self.virusNum == 0 or self.worldPos == nil then
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
  if info ~= nil then
    cast(info, typeof(CS.BuildPointInfo))
    self.curHp = toInt(info.curHp)
    self:ModifyOffset()
  end
end

function VirusEffect:ModifyOffset()
  if self.lod == 1 then
    if self.curHp < self.maxHp then
      self.transform.position = self.worldPos + Vector3.New(0, 1.5, 0)
    else
      self.transform.position = self.worldPos + Vector3.New(0, 0.75, 0)
    end
  else
    if self.lod == 2 then
      if self.curHp < self.maxHp then
        self.transform.position = self.worldPos + Vector3.New(0, 2, 0)
      else
        self.transform.position = self.worldPos + Vector3.New(0, 1.2, 0)
      end
    else
    end
  end
end

function VirusEffect:SetBasePos(worldPos)
  self.worldPos = worldPos
end

function VirusEffect:OnCameraChangeLod(lod)
  if IsNull(self.transform) or self.worldPos == nil then
    return
  end
  self.lod = lod
  pcall(self.timer_action)
  self:ModifyOffset()
end

function VirusEffect:ReInit(virusNum, virusEndTime, uuid, mainIndex, curHp, statusList, refuseTreadVirus)
  self.refuseTreadVirus = refuseTreadVirus
  if IsNull(self.transform) or self.worldPos == nil then
    return
  end
  if IsNotNull(self.virus_icon) then
    if refuseTreadVirus then
      self.virus_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/Mjc_saiji2_shijie_bingdu_gray.png")
    else
      self.virus_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason1/virus/Mjc_saiji2_shijie_bingdu.png")
    end
  end
  if self.virus_level ~= nil then
    self.explodeTime = nil
    self.virusNum = toInt(virusNum)
    self.virusEndTime = toInt(virusEndTime)
    self.bUuid = uuid
    self.curHp = toInt(curHp)
    self.mainIndex = toInt(mainIndex)
    self.myself = mainIndex == LuaEntry.Player:GetMainWorldPos()
    if self.virusNum == 0 then
      self.isUpdate = false
      self.gameObject:SetActive(false)
    else
      self.isUpdate = true
      self.gameObject:SetActive(true)
      self:RefreshText(self.virusNum)
      self:ModifyOffset()
      local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
      if hasVirus and statusList ~= nil and 0 < statusList.Count then
        local count = statusList.Count
        local now = UITimeManager:GetInstance():GetServerTime()
        for i = 0, count - 1 do
          local oneStatus = statusList[i]
          if oneStatus and oneStatus.Id == theVirusMaxEffectId and oneStatus.ExpireTime then
            local expireTime = LuaEntry.DataConfig:TryGetNum("season_virus", "k2", 30)
            self.explodeTime = oneStatus.BeginTime + expireTime * 1000
            if self.explodeTime ~= oneStatus.ExpireTime then
              Logger.LogInfo(tostring(UITimeManager:GetInstance():MilliSecondToFmtString(oneStatus.ExpireTime - now)))
            end
            self.explode_tip_text.text = Localization:GetString("season_s1_virus_explode_tip")
            break
          end
        end
      end
      self.explode_root:SetActive(self.explodeTime ~= nil)
      if self.explodeTime then
        local info = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
        if info and 0 < info:GetStatusExpireTime(27) then
          self.explode_root.transform:Set_localPosition(0, 2.7, 0)
        else
          self.explode_root.transform:Set_localPosition(0, 0, 0)
        end
      end
      pcall(self.timer_action)
    end
    self:AddTimer()
  else
    self.gameObject:SetActive(false)
    self:DeleteTimer()
  end
end

function VirusEffect:RefreshText(level)
  if not self.curLevel then
    self.curLevel = 0
  end
  if self.curLevel == level then
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
      self.virus_level.text = tostring(level) .. " - " .. math.floor(self.virusEndTime - UITimeManager:GetInstance():GetServerSeconds())
    end
    return
  end
  if level > self.curLevel and self.numNode then
    local seq = DOTween.Sequence()
    seq:Append(self.numNode:DOScale(Vector3.New(1.6, 1.6, 1), 0.1))
    seq:AppendInterval(0.1)
    seq:Append(self.numNode:DOScale(ResetScale, 0.3))
    
    function seq.onComplete()
      self.tweenSeq = nil
    end
    
    self.tweenSeq = seq
  end
  if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
    self.virus_level.text = tostring(level) .. " - " .. math.floor(self.virusEndTime - UITimeManager:GetInstance():GetServerSeconds())
  else
    self.virus_level.text = tostring(level)
  end
  self.curLevel = level
end

function VirusEffect:DeleteTimer()
  self.isUpdate = false
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function VirusEffect:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function VirusEffect:CheckVirusExplode()
  if self.explodeTime ~= nil then
    local now = UITimeManager:GetInstance():GetServerTime()
    local expireTime = self.explodeTime - now
    if 0 < expireTime then
      if self.explode_tip_time and GameObjectIsValid(self.explode_tip_time) then
        self.explode_tip_time.text = UITimeManager:GetInstance():MilliSecondToFmtString(expireTime)
      end
    else
      self.explodeTime = nil
      self.explode_root:SetActive(false)
    end
  end
end

function VirusEffect:CheckVirusFinish()
  if self.isUpdate ~= true or IsNull(self.gameObject) then
    return
  end
  if self.myself then
    if LuaEntry.Player.VirusLayer - 1 == self.virusNum then
      EventManager:GetInstance():Broadcast(EventId.VirusPoisonedBubble, {
        bUuid = self.bUuid
      })
    end
    if self.virusEndTime and self.virusNum and self.virusNum ~= LuaEntry.Player.VirusLayer then
      self.virusNum, self.virusEndTime = SeasonUtil.CalcVirusLevel(self.virusNum, self.virusEndTime)
    end
    self.virusNum = LuaEntry.Player.VirusLayer
    if LuaEntry.Player.VirusLayer == 0 then
      self.gameObject:SetActive(false)
    else
      self.gameObject:SetActive(true)
      self:RefreshText(LuaEntry.Player.VirusLayer)
    end
  elseif self.virusEndTime and self.virusNum then
    self.virusNum, self.virusEndTime = SeasonUtil.CalcVirusLevel(self.virusNum, self.virusEndTime)
    if self.virusNum > 0 then
      self.gameObject:SetActive(true)
      self:RefreshText(self.virusNum)
    else
      self.gameObject:SetActive(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end

return VirusEffect
