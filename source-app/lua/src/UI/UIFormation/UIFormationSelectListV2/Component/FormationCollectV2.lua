local FormationCollectV2 = BaseClass("FormationCollectV2", UIAsyncContainer)
local base = UIAsyncContainer
local collectNumText_path = "collectNumBg/layout1/Content/collectNum"
local collectTimeText_path = "collectTimeBg/layout1/Content/timeNum"
local collectEndTimeText_path = "collectOverTimeBg/endTimeNum"
local collectNumTitle_path = "collectNumBg/layout1/Content/collecTitle"
local collectTimeTitle_path = "collectTimeBg/layout1/Content/timeTitle"
local collectNumIcon_path = "collectNumBg/layout1/funBtn/collectIcon"
local collectTimeIcon_path = "collectTimeBg/layout1/funBtn/timeIcon"
local collectEndTimeIcon_path = "collectOverTimeBg/endTimeIcon"

function FormationCollectV2:OnCreate()
  base.OnCreate(self)
  self.collectNum = self:AddComponent(UIText, collectNumText_path)
  self.collectTimeNum = self:AddComponent(UIText, collectTimeText_path)
  self.collectEndTimeNum = self:AddComponent(UIText, collectEndTimeText_path)
  self.collectIcon = self:AddComponent(UIImage, collectNumIcon_path)
  self.collectTimeIcon = self:AddComponent(UIImage, collectTimeIcon_path)
  self.collectEndTimeIcon = self:AddComponent(UIImage, collectEndTimeIcon_path)
  self.collectTitleText = self:AddComponent(UIText, collectNumTitle_path)
  self.collectTimeTitleText = self:AddComponent(UIText, collectTimeTitle_path)
end

function FormationCollectV2:OnDestroy()
  base.OnDestroy(self)
end

function FormationCollectV2:RefreshData(data)
  self.data = data
end

function FormationCollectV2:SetResourceCollectData(targetType, GatherResourceId, canGetResourceNum, pointIndex)
  self.targetType = targetType
  self.GatherResourceId = GatherResourceId
  self.canGetResourceNum = canGetResourceNum
  self.pointIndex = pointIndex
  self:UpdateData()
end

function FormationCollectV2:SetMeteoriteCollectData(targetType, collectTime, canGetResourceNum)
  self.targetType = targetType
  self.collectTime = collectTime
  self.canGetResourceNum = canGetResourceNum
  self:UpdateData()
end

function FormationCollectV2:SetAllianceResource(targetType, resId, configId, canGetResourceNum)
  self.targetType = targetType
  self.resId = resId
  self.configId = configId
  self.canGetResourceNum = canGetResourceNum
  self:UpdateData()
end

function FormationCollectV2:SetAsPickGarbage()
  self.targetType = MarchTargetType.PICK_GARBAGE
  self:UpdateData()
end

function FormationCollectV2:SetSample()
  self.targetType = MarchTargetType.SAMPLE
  self:UpdateData()
end

function FormationCollectV2:UpdateData()
  if not self:AsyncLoadDone() then
    return
  end
  if self.collectIconPath then
    self:SetCollectIconPath(self.collectIconPath)
  end
  self:ShowResourceCollect()
end

function FormationCollectV2:SetCollectIconPath(collectIconPath)
  if collectIconPath ~= self.collectIconPath then
    self.collectIconPath = collectIconPath
  end
  if self.collectIcon then
    self.collectIcon:LoadSprite(collectIconPath)
  end
end

function FormationCollectV2:ShowResourceCollect()
  local data = self.data
  if not self:AsyncLoadDone() or data == nil then
    return
  end
  local uuid = data.uuid
  if self.targetType == MarchTargetType.SAMPLE then
    local k3 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
    self.collectNum:SetText(string.GetFormattedStr2(math.floor(k3)))
    self.collectIcon:LoadSprite(string.format(LoadPath.LWCommonPath, "Common_icon_electricity"))
  end
  if self.targetType == MarchTargetType.PICK_GARBAGE then
    local k2 = LuaEntry.DataConfig:TryGetNum("Reconnaissance_power_consumption", "k3")
    self.collectNum:SetText(string.GetFormattedStr2(math.floor(k2)))
    self.collectIcon:LoadSprite(string.format(LoadPath.LWCommonPath, "Common_icon_electricity"))
  end
  if self.targetType == MarchTargetType.COLLECT and self.canGetResourceNum and self.GatherResourceId then
    local GatherResourceId = self.GatherResourceId
    local theType = LocalController:instance():getIntValue(TableName.GatherResource, GatherResourceId, "resource_type")
    local oneTemplate = DataCenter.GatherResourceTemplateManager:GetTemplate(GatherResourceId)
    if oneTemplate ~= nil then
      local reserve = oneTemplate.reserve
      self.collectNum:SetText(string.GetFormattedStr(math.floor(self.canGetResourceNum)) .. "/" .. string.GetFormattedStr(math.floor(reserve)))
      local speed = oneTemplate.gathering
      local keyString = "lw_resource_gather_speed"
      local useLightWorkerMan = data.UseLightWorkerMan == 1
      if theType == ResourceType.Food then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k2", 10)
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan) + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_FoodCollect_Add))
      elseif theType == ResourceType.Metal then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k1", 10)
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan) + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MetalCollect_Add))
      elseif theType == ResourceType.Wood then
        local effect50116 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add)
        local effect71030NoLight = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030)
        local effect71030 = DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan)
        local effect50146 = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_GoldCollect_Add)
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k3", 6)
        speed = speed * (1 + effect50116 + effect71030 + effect50146)
        Logger.LogInfo(string.format("CollectGoldMineSpeed/%s/%s/%s/%s/%s", speed, effect50116, effect71030, effect50146, effect71030NoLight))
      elseif theType == ResourceType.Gold then
        if oneTemplate.type == ResPointInfoType.BlackDiamond then
          speed = LuaEntry.DataConfig:TryGetNum(keyString, "k6", 0.1)
        else
          speed = LuaEntry.DataConfig:TryGetNum(keyString, "k4", 1)
          speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan))
        end
      elseif theType == ResourceType.DragonItem then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k5", 3.5)
      elseif theType == ResourceType.FLINT then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k8", 200)
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan))
      elseif theType == ResourceType.OBSIDIAN then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k7", 200)
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan))
      elseif theType == ResourceType.Petroleum then
        speed = LuaEntry.DataConfig:TryGetNum(keyString, "k9", 6000)
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030, useLightWorkerMan))
      end
      if oneTemplate.type == ResPointInfoType.Radar then
        local eventInfo = DataCenter.RadarCenterDataManager:GetEventInfoByPointId(self.pointIndex)
        if eventInfo and eventInfo.template and eventInfo.template.para2 ~= nil and eventInfo.template.para2 ~= "" then
          local speedMultiplier = checknumber(eventInfo.template.para2) + 1
          speed = speed * speedMultiplier
        end
      end
      self.collectTitleText:SetLocalText(458562)
      self.collectTimeTitleText:SetLocalText(458563)
      local collectTime = math.ceil(self.canGetResourceNum / speed)
      self.collectTimeNum:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(collectTime))
      local time = data.view:GetTimeInFormation(uuid, data.fixedSoldierType, data.UseLightWorkerMan == 1)
      local realTime = time * 1000 + toInt(data.extraTime)
      local endTime = UITimeManager:GetInstance():GetServerSeconds() + collectTime + realTime / 1000
      local showEndTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(endTime * 1000)
      self.collectEndTimeNum:SetLocalText(458564, showEndTime)
    else
      self.collectNum:SetText(string.GetFormattedStr(math.floor(self.canGetResourceNum)))
    end
    if theType >= ResourceType.ResourceItem then
      local icon
      if GatherResourceId == 4001 then
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(ResourceType.DragonItem)
        if template ~= nil then
          icon = template.pic
        end
      else
        local param = GetTableData(TableName.GatherResource, GatherResourceId, "param")
        local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic_new")
        if string.IsNullOrEmpty(icon_full_path) then
          icon = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic")
        else
          if data.cost_add_img then
            data.cost_add_img:LoadSprite(icon_full_path)
          end
          self.collectIcon:LoadSprite(icon_full_path)
        end
      end
      if icon ~= nil and icon ~= "" then
        if data.cost_add_img then
          data.cost_add_img:LoadSprite(string.format(LoadPath.ItemPath, icon))
        end
        self.collectIcon:LoadSprite(string.format(LoadPath.ItemPath, icon))
      end
    else
      if data.cost_add_img then
        data.cost_add_img:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(theType))
      end
      self.collectIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(theType))
    end
    local addPercent = 0
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
    if formation ~= nil then
      addPercent = MarchUtil.GetFormationCollectSpeedAdd(formation.heroes, theType)
    end
    if data.cost_add_img then
      data.cost_add_num:SetText(string.GetFormattedPercentStr(addPercent / 100))
    end
  end
  if self.targetType == MarchTargetType.COLLECT_METEORITE and self.canGetResourceNum and self.collectTime then
    self.collectTitleText:SetLocalText(458562)
    self.collectTimeTitleText:SetLocalText(458563)
    local collectTime = self.collectTime
    self.collectTimeNum:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(collectTime))
    local time = data.view:GetTimeInFormation(uuid, data.fixedSoldierType, data.UseLightWorkerMan == 1)
    local realTime = time * 1000 + toInt(data.extraTime)
    local endTime = UITimeManager:GetInstance():GetServerSeconds() + collectTime + realTime / 1000
    local showEndTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(endTime * 1000)
    self.collectEndTimeNum:SetLocalText(458564, showEndTime)
    self.collectNum:SetText(tostring(self.canGetResourceNum))
  end
  if self.targetType == MarchTargetType.ALLIANCE_RESOURCE_COLLECT and self.configId and self.canGetResourceNum then
    local config = LocalController:instance():getLine(TableName.AllianceMine, self.configId)
    if config ~= nil then
      local resource_type = toInt(config.resource_type)
      local speed = config.gathering
      self.collectNum:SetText(string.GetFormattedStr(math.floor(self.canGetResourceNum)) .. "/" .. string.GetFormattedStr(math.floor(config.reserve)))
      if resource_type == ResourceType.Food then
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030) + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_FoodCollect_Add))
      elseif resource_type == ResourceType.Metal then
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030) + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MetalCollect_Add))
      elseif resource_type == ResourceType.Wood then
        speed = speed * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_CommonCollect_Add) + DataCenter.ArmyFormationDataManager:GetEffectResult(uuid, EffectDefine.LW_Collect_Add_71030) + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_GoldCollect_Add))
      end
      self.collectTitleText:SetLocalText(458562)
      self.collectTimeTitleText:SetLocalText(458563)
      local collectTime = self.canGetResourceNum / speed
      self.collectTimeNum:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(collectTime))
      local time = data.view:GetTimeInFormation(uuid, data.fixedSoldierType, data.UseLightWorkerMan == 1)
      local realTime = time * 1000 + toInt(data.extraTime)
      local endTime = UITimeManager:GetInstance():GetServerSeconds() + collectTime + realTime / 1000
      local showEndTime = UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(endTime * 1000)
      self.collectEndTimeNum:SetLocalText(458564, showEndTime)
      if resource_type >= ResourceType.ResourceItem then
        local icon
        if self.resId == 4001 then
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(ResourceType.DragonItem)
          if template ~= nil then
            icon = template.pic
          end
        else
          local param = GetTableData(TableName.GatherResource, self.resId, "param")
          local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic_new")
          if string.IsNullOrEmpty(icon_full_path) then
            icon = GetTableData(TableName.Aps_Resource_Item, tonumber(param), "pic")
          else
            if data.cost_add_img then
              data.cost_add_img:LoadSprite(icon_full_path)
            end
            self.collectIcon:LoadSprite(icon_full_path)
          end
        end
        if icon ~= nil and icon ~= "" then
          if data.cost_add_img then
            data.cost_add_img:LoadSprite(string.format(LoadPath.ItemPath, icon))
          end
          self.collectIcon:LoadSprite(string.format(LoadPath.ItemPath, icon))
        end
      else
        if data.cost_add_img then
          data.cost_add_img:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resource_type))
        end
        self.collectIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resource_type))
      end
      local addPercent = 0
      local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(uuid)
      if formation ~= nil then
        addPercent = MarchUtil.GetFormationCollectSpeedAdd(formation.heroes, resource_type)
      end
    else
      self.collectNum:SetText(string.GetFormattedStr(math.floor(self.canGetResourceNum)))
    end
  end
end

return FormationCollectV2
