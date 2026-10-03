local TacticalWeaponManager = BaseClass("TacticalWeaponManager")
local Localization = CS.GameEntry.Localization
local TacticalWeaponInfo = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponInfo")
local ItemType = {Goods = 1, Chip = 2}
local DEFAULT_APPEARANCE_ID = 1201

function TacticalWeaponManager:__init()
  self.tacticalWeaponInfos = {}
  self.prevShowRedPoint = nil
  self.refreshBubbleCallBack = BindCallback(self, self.OnTacticalWeaponLevelUp)
  EventManager:GetInstance():AddListener(EventId.TacticalWeaponLevelUp, self.refreshBubbleCallBack)
  EventManager:GetInstance():AddListener(EventId.TacticalWeaponUpdate, self.refreshBubbleCallBack)
  EventManager:GetInstance():AddListener(EventId.RefreshResourceItem, self.refreshBubbleCallBack)
  self.otherPlayerWeaponInfos = {}
  self.otherPlayerWeaponReqTime = {}
end

function TacticalWeaponManager:__delete()
  self.tacticalWeaponInfos = nil
  self.prevShowRedPoint = nil
  EventManager:GetInstance():RemoveListener(EventId.TacticalWeaponLevelUp, self.refreshBubbleCallBack)
  EventManager:GetInstance():RemoveListener(EventId.TacticalWeaponUpdate, self.refreshBubbleCallBack)
  EventManager:GetInstance():RemoveListener(EventId.RefreshResourceItem, self.refreshBubbleCallBack)
  self.refreshBubbleCallBack = nil
  self.otherPlayerWeaponInfos = nil
  self.otherPlayerWeaponReqTime = nil
  self.decorationUnlockLvMap = nil
  self.decorationLvIdList = nil
end

function TacticalWeaponManager:Init(message)
  if message == nil then
    return
  end
  self.tacticalWeaponInfos = {}
  if message.weaponArr ~= nil then
    for _, v in pairs(message.weaponArr) do
      local tacticalWeaponInfo = TacticalWeaponInfo.New()
      tacticalWeaponInfo:UpdateInfo(v)
      self.tacticalWeaponInfos[tacticalWeaponInfo.id] = tacticalWeaponInfo
    end
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponUpdate)
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponInit)
  end
end

function TacticalWeaponManager:Update(message)
  if message == nil then
    return
  end
  if message.weaponArr ~= nil then
    for _, v in pairs(message.weaponArr) do
      local tacticalWeaponInfo = self:GetTacticalWeaponInfo(v.id)
      if tacticalWeaponInfo == nil then
        tacticalWeaponInfo = TacticalWeaponInfo.New()
      end
      tacticalWeaponInfo:UpdateInfo(v)
      self.tacticalWeaponInfos[tacticalWeaponInfo.id] = tacticalWeaponInfo
    end
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponUpdate)
  end
end

function TacticalWeaponManager:UpdateWeapon(message)
  if not message then
    return
  end
  local id = message.id
  local tacticalWeaponInfo = self:GetTacticalWeaponInfo(id)
  if tacticalWeaponInfo == nil then
    tacticalWeaponInfo = TacticalWeaponInfo.New()
  end
  tacticalWeaponInfo:UpdateInfo(message)
  self.tacticalWeaponInfos[tacticalWeaponInfo.id] = tacticalWeaponInfo
  EventManager:GetInstance():Broadcast(EventId.TacticalWeaponUpdate)
end

function TacticalWeaponManager:GetTacticalWeaponInfo(tacticalWeaponId)
  if not self.tacticalWeaponInfos then
    return nil
  end
  return self.tacticalWeaponInfos[tacticalWeaponId]
end

function TacticalWeaponManager:GetTacticalWeaponInfos()
  return self.tacticalWeaponInfos
end

function TacticalWeaponManager:HasTacticalWeapon()
  return not table.IsNullOrEmpty(self.tacticalWeaponInfos)
end

function TacticalWeaponManager:GetWeaponSkinId()
  return DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_TacticalWeapon) or 0
end

function TacticalWeaponManager:CheckIsNeedCalAppearanceIdFromUwaLvData(skinTemplate)
  if skinTemplate == nil then
    return false
  end
  return skinTemplate:IsDefault()
end

function TacticalWeaponManager:CheckIsNormalSkin(skinTemplate)
  if skinTemplate == nil then
    return false
  end
  return skinTemplate:IsDefault()
end

function TacticalWeaponManager:GetRealAppearanceIdForDefaultSkin(skinId, weaponInfo)
  if weaponInfo == nil and (skinId == nil or skinId <= 0) then
    return 1101
  end
  local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if skinTemplate == nil then
    return weaponInfo:GetAppearance()
  end
  if weaponInfo == nil then
    return skinTemplate.appearance
  end
  if not skinTemplate:IsDefault() and skinTemplate.typeGain ~= DecorationGainType.DecorationGainType_LevelUp then
    return skinTemplate.appearance
  end
  local maxLimitLv = weaponInfo.level
  if skinTemplate.customVariable ~= nil then
    maxLimitLv = tonumber(skinTemplate.customVariable)
  end
  if maxLimitLv ~= weaponInfo.level then
    local showLv = math.min(maxLimitLv, weaponInfo.level)
    local ret, appearanceId = DataCenter.TacticalWeaponLevelTemplateManager:TryGetAppearanceIdByLv(showLv)
    if ret then
      return appearanceId
    end
    return weaponInfo:GetAppearance()
  end
  return weaponInfo:GetAppearance()
end

function TacticalWeaponManager:GetDefaultSkinRealAppearanceId(weaponInfo, skinId)
  if not weaponInfo then
    return DEFAULT_APPEARANCE_ID
  end
  local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
  if skinTemplate == nil then
    return weaponInfo:GetAppearance()
  end
  if not skinTemplate:IsDefault() and skinTemplate.typeGain ~= DecorationGainType.DecorationGainType_LevelUp then
    return skinTemplate.appearance
  end
  local curDecorationId, unlockLv = self:GetDecorationIdByLv(weaponInfo.level)
  local showLv = weaponInfo.level
  if curDecorationId ~= skinId then
    local skinMaxLimitLv = 0
    if not string.IsNullOrEmpty(skinTemplate.customVariable) then
      skinMaxLimitLv = tonumber(skinTemplate.customVariable)
    end
    if unlockLv > skinMaxLimitLv then
      showLv = skinMaxLimitLv
    else
      local decorationId, lv = self:GetDecorationIdByLv(skinMaxLimitLv)
      showLv = lv
    end
  end
  local ret, appearanceId = DataCenter.TacticalWeaponLevelTemplateManager:TryGetAppearanceIdByLv(showLv)
  if ret then
    return appearanceId
  end
  return weaponInfo:GetAppearance()
end

function TacticalWeaponManager:GetCurDefaultSkinPath()
  local weaponInfo = self:GetFirstWeaponInfo()
  if weaponInfo == nil then
    return 1
  end
  return self:GetDefaultSkinPathByLevel(weaponInfo.level)
end

function TacticalWeaponManager:GetCurDefaultSkinAppearanceId()
  local weaponInfo = self:GetFirstWeaponInfo()
  if weaponInfo == nil then
    return 1
  end
  return self:GetDefaultSkinAppearanceIdByLevel(weaponInfo.level)
end

function TacticalWeaponManager:GetDefaultSkinAppearanceIdByLevel(lv)
  local ret, appearanceId = DataCenter.TacticalWeaponLevelTemplateManager:TryGetAppearanceIdByLv(lv)
  if not ret then
    appearanceId = DEFAULT_APPEARANCE_ID
  end
  return appearanceId
end

function TacticalWeaponManager:GetDefaultSkinPathByLevel(lv)
  local appearanceId = self:GetDefaultSkinAppearanceIdByLevel(lv)
  local modelPath = ""
  local appearanceTemplate = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
  if appearanceTemplate ~= nil then
    modelPath = appearanceTemplate.heroimg_model
  end
  return modelPath
end

function TacticalWeaponManager:GetWeaponAppearance(weaponId)
  local playerAppearanceId = self:GetPlayerWeaponAppearance(weaponId)
  if playerAppearanceId ~= nil then
    return playerAppearanceId
  end
  return DEFAULT_APPEARANCE_ID
end

function TacticalWeaponManager:GetPlayerWeaponAppearance(weaponId)
  local skinId = self:GetWeaponSkinId()
  if skinId ~= nil and 0 < skinId then
    local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if skinTemplate and not self:CheckIsNeedCalAppearanceIdFromUwaLvData(skinTemplate) then
      return skinTemplate.appearance
    end
  end
  if table.IsNullOrEmpty(self.tacticalWeaponInfos) then
    return nil
  end
  local weaponInfo = self.tacticalWeaponInfos[weaponId]
  if weaponInfo ~= nil and 0 < weaponInfo.level then
    return self:GetDefaultSkinRealAppearanceId(weaponInfo, skinId)
  end
  return nil
end

function TacticalWeaponManager:GetSelfWeaponAppearance()
  local weaponInfo = self:GetFirstWeaponInfo()
  if not weaponInfo then
    return nil
  end
  local skinId = self:GetWeaponSkinId()
  if skinId ~= nil and 0 < skinId then
    local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if skinTemplate and not self:CheckIsNeedCalAppearanceIdFromUwaLvData(skinTemplate) then
      return skinTemplate.appearance
    end
  end
  if table.IsNullOrEmpty(self.tacticalWeaponInfos) then
    return nil
  end
  if weaponInfo ~= nil and 0 < weaponInfo.level then
    return self:GetDefaultSkinRealAppearanceId(weaponInfo, skinId)
  end
  return nil
end

function TacticalWeaponManager:GetWeaponAppearanceData(weaponInfo, skinId)
  if skinId ~= nil and 0 < skinId then
    local skinTemplate = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if skinTemplate and not self:CheckIsNormalSkin(skinTemplate) then
      return skinTemplate.appearance
    end
  end
  if weaponInfo ~= nil and 0 < weaponInfo.level then
    return self:GetDefaultSkinRealAppearanceId(weaponInfo, skinId)
  end
  return nil
end

function TacticalWeaponManager:ShowRedPoint()
  if table.IsNullOrEmpty(self.tacticalWeaponInfos) then
    return false
  end
  for k, v in pairs(self.tacticalWeaponInfos) do
    if v:ShowRedPoint() then
      return true
    end
  end
  return false
end

function TacticalWeaponManager:OnTacticalWeaponLevelUp()
  self:OnRefreshBubble()
  self:CheckIsNeedUpdateSkinWhenWeaponLvUp()
end

function TacticalWeaponManager:CheckIsNeedUpdateSkinWhenWeaponLvUp()
  EventManager:GetInstance():Broadcast(EventId.UserSkinUpdate, DecorationType.DecorationType_TacticalWeapon)
end

function TacticalWeaponManager:OnRefreshBubble()
  local showRedPoint = self:ShowRedPoint()
  if self.prevShowRedPoint ~= showRedPoint then
    self.prevShowRedPoint = showRedPoint
    EventManager:GetInstance():Broadcast(EventId.TacticalWeaponBubbleRefresh)
  end
end

function TacticalWeaponManager:GetFirstWeaponInfo()
  if table.IsNullOrEmpty(self.tacticalWeaponInfos) then
    return nil
  end
  for k, v in pairs(self.tacticalWeaponInfos) do
    self:UpdateWeaponInfo(v)
    return v
  end
end

function TacticalWeaponManager:UpdateWeaponInfo(weaponInfo)
  if weaponInfo == nil then
    return
  end
  weaponInfo:UpdateSkillInfoExtra()
end

function TacticalWeaponManager:GetAllSelfWearingEquips()
  return DataCenter.CommonEquipDataManager:GetAllWearingEquipsByOwnerUid(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
end

function TacticalWeaponManager:IsSelfHasBetterEquip()
  return DataCenter.CommonEquipDataManager:IsHasBetterCommonEquip(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
end

function TacticalWeaponManager:IsSelfCanUpgradeEquip()
  return DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgradeByOwner(CommonEquipType.SquadEquip, BuildingTypes.LW_BUILD_TACTICAL_CENTER)
end

function TacticalWeaponManager:IsEquipFunctionUnlock()
  if self.equipNeedBuildingLevel == nil then
    self.equipNeedBuildingLevel = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k1", 0)
  end
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
  if buildData == nil or buildData.level < self.equipNeedBuildingLevel then
    return false, self.equipNeedBuildingLevel
  end
  return true
end

function TacticalWeaponManager:OnGetOtherPlayerWeaponInfo(msg)
  if not msg then
    return
  end
  if not self.otherPlayerWeaponInfos then
    self.otherPlayerWeaponInfos = {}
  end
  if msg.uid then
    self.otherPlayerWeaponInfos[msg.uid] = DeepCopy(msg)
    EventManager:GetInstance():Broadcast(EventId.GetOtherWeaponInfo, msg.uid)
  end
end

function TacticalWeaponManager:GetOtherPlayerWeaponInfo(uid, serverId)
  if not self.otherPlayerWeaponInfos then
    self:RequestOtherPlayerWeapon(uid, serverId)
    return nil
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.otherPlayerWeaponReqTime[uid] then
      local reqTime = self.otherPlayerWeaponReqTime[uid]
      if 20000 < curTime - reqTime then
        self:RequestOtherPlayerWeapon(uid, serverId)
      end
    else
      self:RequestOtherPlayerWeapon(uid, serverId)
    end
  end
  return self.otherPlayerWeaponInfos[uid]
end

function TacticalWeaponManager:RequestOtherPlayerWeapon(uid, serverId)
  if not uid or not serverId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.WeaponInfoView, uid, serverId)
  if not self.otherPlayerWeaponReqTime then
    self.otherPlayerWeaponReqTime = {}
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.otherPlayerWeaponReqTime[uid] = curTime
end

function TacticalWeaponManager:GetWeaponTotalPower()
  local totalPower = 0
  if LuaEntry.Player and LuaEntry.Player.squadEquipPower then
    totalPower = LuaEntry.Player.squadEquipPower
  end
  return totalPower
end

function TacticalWeaponManager:GetDecorationUnlockLv(decorationId)
  if self.decorationUnlockLvMap == nil then
    self.decorationUnlockLvMap = {}
    local str = LuaEntry.DataConfig:TryGetStr("uav_level_reward_skin_config", "k2")
    if not string.IsNullOrEmpty(str) then
      local strList = string.split(str, "|")
      for _, pairStr in ipairs(strList) do
        if not string.IsNullOrEmpty(pairStr) then
          local pairList = string.split(pairStr, ";")
          self.decorationUnlockLvMap[tonumber(pairList[1])] = tonumber(pairList[2])
        end
      end
    end
  end
  return self.decorationUnlockLvMap[tonumber(decorationId)]
end

function TacticalWeaponManager:GetDecorationIdByLv(lv)
  if self.decorationLvIdList == nil then
    self.decorationLvIdList = {}
    local str = LuaEntry.DataConfig:TryGetStr("uav_level_reward_skin_config", "k1")
    if not string.IsNullOrEmpty(str) then
      local strList = string.split(str, "|")
      for _, pairStr in ipairs(strList) do
        if not string.IsNullOrEmpty(pairStr) then
          local pairList = string.split(pairStr, ";")
          table.insert(self.decorationLvIdList, {
            lv = tonumber(pairList[1]),
            id = tonumber(pairList[2])
          })
        end
      end
    end
  end
  for i, v in ipairs(self.decorationLvIdList) do
    if v and lv < v.lv then
      local pre = self.decorationLvIdList[i - 1]
      return pre.id, pre.lv
    end
  end
  local final = self.decorationLvIdList[#self.decorationLvIdList]
  return final.id, final.lv
end

function TacticalWeaponManager:OpenSuperUpgradeView()
  local weaponInfo = self:GetFirstWeaponInfo()
  if weaponInfo then
    local decorationId = self:GetDecorationIdByLv(weaponInfo.level)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if template.quality == 5 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSuperStageUpGold)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITacticalWeaponSuperStageUpPurple)
    end
  end
end

function TacticalWeaponManager:GetMainWeaponMaxLevelExtra()
  local scienceExtra = LuaEntry.Effect:GetGameEffect(ScienceEffectID.TacticalWeaponLevelMaxLimit) or 0
  scienceExtra = math.floor(scienceExtra + 0.5)
  return scienceExtra
end

function TacticalWeaponManager:GetMainWeaponSkillStarExtra()
  local skillStarExtra = LuaEntry.Effect:GetGameEffect(ScienceEffectID.TacticalSkillStarUp) or 0
  skillStarExtra = math.floor(skillStarExtra + 0.5)
  return skillStarExtra
end

local RedPointKey_TacticalWeaponPreview = "TacticalWeaponPreviewRedPoint"

function TacticalWeaponManager:RefreshPreviewPageRedPoint()
  local weaponInfo = self:GetFirstWeaponInfo()
  if weaponInfo then
    local curLv = weaponInfo.level
    if curLv % 50 == 0 then
      CommonUtil.PlayerPrefsSetInt(RedPointKey_TacticalWeaponPreview, 1)
      return true
    end
  end
end

function TacticalWeaponManager:SetPreviewPageRedPoint()
  CommonUtil.PlayerPrefsSetInt(RedPointKey_TacticalWeaponPreview, 0)
end

function TacticalWeaponManager:GetPreviewPageRedPoint()
  return CommonUtil.PlayerPrefsGetInt(RedPointKey_TacticalWeaponPreview, 1) > 0
end

local RedPointKey_TacticalWeaponSkinPage = "TacticalWeaponSkinPageRedPoint"

function TacticalWeaponManager:SetSkinPageRedPoint()
  CommonUtil.PlayerPrefsSetInt(RedPointKey_TacticalWeaponSkinPage, 0)
end

function TacticalWeaponManager:GetSkinPageRedPoint()
  return CommonUtil.PlayerPrefsGetInt(RedPointKey_TacticalWeaponSkinPage, 1) == 1
end

return TacticalWeaponManager
