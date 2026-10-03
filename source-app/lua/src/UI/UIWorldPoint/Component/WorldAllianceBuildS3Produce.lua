local WorldAllianceBuildS3Produce = BaseClass("WorldAllianceBuildS3Produce", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local status_pro_path = "work_icon/status_pro"
local status_icon_path = "work_icon/status_icon"
local status_txt_path = "status_txt"
local status_value_path = "status_value"
local res_item_path = "work_icon/ResItem"

function WorldAllianceBuildS3Produce:OnCreate()
  base.OnCreate(self)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.status_pro = self:AddComponent(UIImage, status_pro_path)
  self.status_icon = self:AddComponent(UIImage, status_icon_path)
  self.status_icon_btn = self:AddComponent(UIButton, status_icon_path)
  self.status_txt = self:AddComponent(UITextMeshProUGUIEx, status_txt_path)
  self.status_value = self:AddComponent(UITextMeshProUGUIEx, status_value_path)
  self.transform:SetAsFirstSibling()
  self.res_item:SetActive(false)
  self.status_icon_btn:SetOnClick(function()
    if self.res_desc_str then
      UIUtil.ShowButtonTips(self.status_icon, self.res_name_str, self.res_desc_str, true)
    end
  end)
end

function WorldAllianceBuildS3Produce:OnDestroy()
  self.res_item = nil
  self.status_pro = nil
  self.status_icon = nil
  self.status_txt = nil
  self.status_value = nil
  base.OnDestroy(self)
end

function WorldAllianceBuildS3Produce:OnAddListener()
  base.OnAddListener(self)
end

function WorldAllianceBuildS3Produce:OnRemoveListener()
  base.OnRemoveListener(self)
end

function WorldAllianceBuildS3Produce:ReInit(data, allianceBuildInfo)
  self.data = data
  self.allianceBuildInfo = allianceBuildInfo
  self:UpdateData()
end

function WorldAllianceBuildS3Produce:UpdateData()
  if IsNull(self.gameObject) or self.data == nil then
    return
  end
  local buildId = toInt(self.data.buildId)
  local level = math.max(1, toInt(self.data.level))
  local state = self.data.state or AllianceMineStatus.Build
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId + level)
  if meta ~= nil then
    local speedHour = 0
    local theResName, resIconPath
    local theProduceInfo = meta:GetProduceInfo()
    for k, v in pairs(theProduceInfo) do
      if v.ResType then
        speedHour = toInt(v.ResValue) * SEASON_MUMMY_RES_TIME_SCALE
        resIconPath = DataCenter.ResourceManager:GetResourceIconByType(v.ResType)
        theResName = DataCenter.ResourceManager:GetResourceNameByType(v.ResType)
        self.res_name_str = theResName
        self.res_desc_str = DataCenter.ResourceManager:GetResourceDescByType(v.ResType)
        self.res_item:SetActive(false)
        break
      elseif v.itemId then
        speedHour = toInt(v.itemCount) * SEASON_MUMMY_RES_TIME_SCALE
        resIconPath = nil
        local item_meta = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
        if item_meta then
          theResName = item_meta:GetName()
        end
        self.res_item:SetActive(true)
        self.res_item:ReInit({
          rewardType = RewardType.GOODS,
          itemId = v.itemId
        })
        break
      end
    end
    if theResName == nil then
      theResName = ""
    end
    if resIconPath == nil or not CS.GameEntry.Resource:HasAsset(resIconPath) then
      self.status_icon:SetActive(false)
    else
      self.status_icon:SetActive(true)
      self.status_icon:LoadSprite(resIconPath)
    end
    self.coverSpeed = nil
    if state == AllianceMineStatus.Build or state == AllianceMineStatus.Constructing then
      self.produceStartTime = nil
      self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui05"))
      self.status_value:SetText("+0/h")
    elseif state == AllianceMineStatus.Ruin then
      self.produceStartTime = nil
      self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui06"))
      self.status_value:SetText("+0/h")
    elseif self:Injuried() then
      self.produceStartTime = nil
      self.status_pro:SetFillAmount(0)
      self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui08"))
      self.status_value:SetText("+0/h")
      self.status_pro:SetColorRGBA255(255, 93, 0)
      self.coverSpeed = toInt(self.data.durabilitySpeed or self.data.coverSpeed or 0)
    elseif self.allianceBuildInfo ~= nil then
      if self.allianceBuildInfo.outputStat == 0 then
        self.produceStartTime = nil
        self.status_pro:SetColorRGBA255(255, 93, 0)
        if self.allianceBuildInfo.endTime ~= nil and self.allianceBuildInfo.endTime ~= 0 then
          local totalTime = self.allianceBuildInfo.endTime - self.allianceBuildInfo.beginTime
          local rate = math.min(1, totalTime / 600000)
          self.status_pro:SetFillAmount(rate)
        else
          self.status_pro:SetFillAmount(math.random())
        end
        self.produceStartTime = nil
        self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui08"))
        self.status_value:SetText("+0/h")
      else
        self.produceStartTime = self.allianceBuildInfo.beginTime
        self.status_pro:SetColorRGBA255(46, 200, 82)
        self:Update100MS()
        self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui09"))
        self.status_value:SetText("+" .. speedHour .. "/h")
      end
    else
      self.produceStartTime = nil
      self.status_pro:SetFillAmount(0)
      self.status_txt:SetText(theResName .. Localization:GetString("season_s3_alliance_building_ui09"))
      self.status_value:SetText("+" .. speedHour .. "/h")
      self.status_pro:SetColorRGBA255(46, 200, 82)
    end
  end
end

function WorldAllianceBuildS3Produce:GetDurability()
  if self.data == nil then
    return 0
  end
  local state = self.data.state or AllianceMineStatus.Build
  if state == AllianceMineStatus.Ruin then
    return 0
  end
  local buildId = self.data.buildId or 0
  local level = self.data.level or 1
  local allianceId = self.data.allianceId
  local maxHp = self.data.resDurable or self.data.maxHp or 0
  local curHp = self.data.durability or self.data.curHp or 0
  local lastHpTime = toInt(self.data.lastDurabilityTime or self.data.lastHpTime or 0)
  local coverSpeed = toInt(self.data.durabilitySpeed or self.data.coverSpeed or 0)
  if 0 < coverSpeed and 0 < lastHpTime and maxHp > curHp then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    curHp = curHp + (curTime - lastHpTime) / 1000 * coverSpeed
    curHp = math.min(curHp, maxHp)
  end
  return curHp
end

function WorldAllianceBuildS3Produce:Injuried()
  if self.data == nil then
    return true
  end
  local maxHp = self.data.resDurable or self.data.maxHp or 0
  local state = self.data.state or AllianceMineStatus.Build
  if state == AllianceMineStatus.Ruin then
    return true
  end
  return self:GetDurability() < toInt(maxHp)
end

function WorldAllianceBuildS3Produce:Update1000MS()
  if self.coverSpeed ~= nil and self.coverSpeed ~= 0 then
    self:UpdateData()
  end
end

function WorldAllianceBuildS3Produce:Update100MS()
  if self.produceStartTime ~= nil and self.produceStartTime ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local totalTime = now - self.produceStartTime
    local rate = math.min(1, totalTime / 600000)
    self.status_pro:SetFillAmount(rate)
    if 0.99999 <= rate then
      self.produceStartTime = now
    end
  end
end

return WorldAllianceBuildS3Produce
