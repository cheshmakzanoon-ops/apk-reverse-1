local CitySkinSkillManager = BaseClass("CitySkinSkillManager")
local WaitTime = 10000

local function __init(self)
  self.skillCdDict = {}
  self.skillShowDict = nil
  self.isDataDirty = true
  self.dirtyTime = 0
  self.skillShowList = {}
  self.isHaveListener = false
  self.waitEndTime = 0
  self:AddListener()
end

local function __delete(self)
  self.skillCdDict = nil
  self.skillShowDict = nil
  self.isDataDirty = nil
  self.dirtyTime = nil
  if self.isHaveListener == true then
    self.isHaveListener = false
    EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
  self.isHaveListener = nil
  self.waitEndTime = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.UserSkinUpdate, self.SetDataDirty)
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.UserSkinUpdate, self.SetDataDirty)
end

local function SetDataDirty()
  local self = DataCenter.CitySkinSkillManager
  self.isDataDirty = true
end

local function InitData(self, message)
  if message and message.skinSkillCds then
    for k, v in pairs(message.skinSkillCds) do
      self:SetSkillCdData(v.skillId, v.cdEndTime, v.intervalUseTime)
    end
  end
end

local function SetSkillCdData(self, skillId, cdEndTime, intervalUseTime)
  local inputCdEndTime = cdEndTime or 0
  local inputIntervalUseTime = intervalUseTime or 0
  self.skillCdDict[skillId] = {cdEndTime = inputCdEndTime, intervalUseTime = inputIntervalUseTime}
end

local function GetSkillCdTime(self, skillId)
  local cdTime = 0
  if self.skillCdDict[skillId] then
    cdTime = self.skillCdDict[skillId].cdEndTime
  end
  return cdTime
end

local function GetSkillIntervalUseTime(self, skillId)
  local intervalUseTime = 0
  if self.skillCdDict[skillId] then
    intervalUseTime = self.skillCdDict[skillId].intervalUseTime
  end
  return intervalUseTime
end

local function TryInitSkillTempShowData(self)
  if self.skillShowDict then
    return
  end
  self.skillShowDict = {}
  local allTemplate = DataCenter.DecorationTemplateManager:GetTypeDecorations(DecorationType.DecorationType_Main_City)
  for k, v in pairs(allTemplate) do
    local template = DataCenter.DecorationTemplateManager:GetTemplate(v)
    if template then
      if #template.skill_id_list > 0 then
        for i, skillId in ipairs(template.skill_id_list) do
          local skillTemp = DataCenter.DecorationSkillTemplateManager:GetTemplate(skillId)
          self:AddSkill(skillId, skillTemp, template)
        end
      end
      local skillId = template.callback_skill_id
      local skillTemp = skillId and DataCenter.DecorationSkillTemplateManager:GetTemplate(skillId)
      if skillTemp then
        self:AddSkill(skillId, skillTemp, template)
      end
    end
  end
end

local function AddSkill(self, skillId, skillTemp, template)
  if self.skillShowDict[skillId] == nil then
    self.skillShowDict[skillId] = {
      skillId = skillId,
      skillTemp = skillTemp,
      decorationTemp = template,
      checkTempCanShow = false,
      state = CitySkinSkillState.NoGetPath,
      expiredTime = 0
    }
  end
end

local function TryRefreshSkillShowData(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.isDataDirty or self.dirtyTime > 0 and curTime >= self.dirtyTime then
    self.isDataDirty = false
    self.dirtyTime = 0
    for k, v in pairs(self.skillShowDict) do
      if v.state ~= CitySkinSkillState.UnLock then
        local template = v.decorationTemp
        local data = DataCenter.DecorationDataManager:GetSkinDataById(template.id)
        if not self:CanShowSkillByType(template.id, v.skillId, v.skillTemp.type) then
          v.state = CitySkinSkillState.NoGetPath
        else
          local isUnlock = template:IsDefault() or data ~= nil and data:IsInExpireTime()
          if isUnlock then
            local expiredTime = data and data.expireTime or 0
            if 0 < expiredTime then
              v.state = CitySkinSkillState.UnLockLimitTime
              v.expiredTime = expiredTime
              if self.dirtyTime == 0 or v.expiredTime < self.dirtyTime then
                self.dirtyTime = v.expiredTime
              end
            else
              v.state = CitySkinSkillState.UnLock
            end
          else
            if v.checkTempCanShow == false then
              v.checkTempCanShow = template:CheckTemplateCanShow()
            end
            if v.checkTempCanShow then
              v.state = CitySkinSkillState.Lock
            else
              v.state = CitySkinSkillState.NoGetPath
            end
          end
        end
      end
    end
    self.skillShowList = {}
    for k, v in pairs(self.skillShowDict) do
      if v.state ~= CitySkinSkillState.NoGetPath then
        table.insert(self.skillShowList, v)
      end
    end
    table.sort(self.skillShowList, function(a, b)
      local aIsUnLock = a.state == CitySkinSkillState.UnLock or a.state == CitySkinSkillState.UnLockLimitTime
      local bIsUnLock = b.state == CitySkinSkillState.UnLock or b.state == CitySkinSkillState.UnLockLimitTime
      if aIsUnLock ~= bIsUnLock then
        if aIsUnLock then
          return true
        else
          return false
        end
      end
      local aOrder = a.skillTemp.order or 0
      local bOrder = b.skillTemp.order or 0
      return aOrder < bOrder
    end)
  end
end

local function GetSkillShowData(self)
  self:TryInitSkillTempShowData()
  self:TryRefreshSkillShowData()
  return self.skillShowList
end

local function IsHaveSkillShow(self)
  local isHvae = false
  local skillShowList = self:GetSkillShowData()
  isHvae = skillShowList and 0 < #skillShowList
  return isHvae
end

local function SetWaitOpenView(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.waitEndTime = curTime + WaitTime
  if self.isHaveListener == false then
    self.isHaveListener = true
    EventManager:GetInstance():AddListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():AddListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
  self:TryOpenPoint()
end

local function TryOpenPoint()
  local self = DataCenter.CitySkinSkillManager
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.waitEndTime and self.isHaveListener == true then
    self.isHaveListener = false
    EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
    EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
  end
  local curScene = CS.SceneManager.CurrSceneID
  if curScene ~= SceneManagerSceneID.World then
    return
  end
  local pointId = LuaEntry.Player:GetMainWorldPos()
  local pointInfo
  if pointId ~= nil then
    pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
    if pointInfo ~= nil and pointInfo.PointType == WorldPointType.PlayerBuilding and pointInfo.ownerUid == LuaEntry.Player.uid then
      if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWComic) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.Building, pointId, SkillUseInWorldType.CitySkinSkill)
      end
      if self.isHaveListener == true then
        self.isHaveListener = false
        EventManager:GetInstance():RemoveListener(EventId.WorldGetBlockMsg, self.TryOpenPoint)
        EventManager:GetInstance():RemoveListener(EventId.WorldGetMarchInfosMsg, self.TryOpenPoint)
      end
    end
  end
end

local function CanShowSkillByType(self, decoId, skillId, skillType)
  if not skillType or skillType <= 1 then
    return true
  end
  if skillType == DecorationSkillType.Season then
    if not DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, decoId, true) then
      return false
    end
    if not SeasonUtil.IsInSeasonCityStrongholdMode(true) then
      return false
    end
    if BattleFieldUtil.InBattleField() then
      return false
    end
  elseif skillType == DecorationSkillType.SeasonMummy then
    if not DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, decoId, true) then
      return false
    end
    if not SeasonUtil.IsInSeasonMummyMode(true) then
      return false
    end
    if BattleFieldUtil.InBattleField() then
      return false
    end
  elseif skillType == DecorationSkillType.SeasonRainforest then
    if not DataCenter.SeasonCallbackManager:GetConfigDataByCallbackId(SeasonCallbackType.Base, decoId, true) then
      return false
    end
    if not SeasonUtil.IsInRainforestSeason(true) then
      return false
    end
    if BattleFieldUtil.InBattleField() then
      return false
    end
  end
  return true
end

CitySkinSkillManager.__init = __init
CitySkinSkillManager.__delete = __delete
CitySkinSkillManager.AddListener = AddListener
CitySkinSkillManager.RemoveListener = RemoveListener
CitySkinSkillManager.GetSkillShowData = GetSkillShowData
CitySkinSkillManager.InitData = InitData
CitySkinSkillManager.SetDataDirty = SetDataDirty
CitySkinSkillManager.SetSkillCdData = SetSkillCdData
CitySkinSkillManager.GetSkillCdTime = GetSkillCdTime
CitySkinSkillManager.GetSkillIntervalUseTime = GetSkillIntervalUseTime
CitySkinSkillManager.TryInitSkillTempShowData = TryInitSkillTempShowData
CitySkinSkillManager.TryRefreshSkillShowData = TryRefreshSkillShowData
CitySkinSkillManager.IsHaveSkillShow = IsHaveSkillShow
CitySkinSkillManager.SetWaitOpenView = SetWaitOpenView
CitySkinSkillManager.TryOpenPoint = TryOpenPoint
CitySkinSkillManager.CanShowSkillByType = CanShowSkillByType
CitySkinSkillManager.AddSkill = AddSkill
return CitySkinSkillManager
