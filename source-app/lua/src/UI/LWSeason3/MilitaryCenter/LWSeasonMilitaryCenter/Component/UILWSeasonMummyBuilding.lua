local UILWSeasonMummyBuilding = BaseClass("UILWSeasonMummyBuilding", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

function UILWSeasonMummyBuilding:OnCreate()
  base.OnCreate(self)
  self.btn_fetch_reward = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, "")
  self.hp_bar = self:AddComponent(UISlider, "HPBar")
  self.popupAnim = self:AddComponent(UISimpleAnimation, "popup")
  self.popup = self:AddComponent(UIBaseComponent, "popup")
  self.pro = self:AddComponent(UIImage, "popup/pro")
  self.res_icon_shake = self:AddComponent(UIImage, "popup/res_icon_shake")
  self.res_count = self:AddComponent(UITextMeshProUGUIEx, "popup/res_count")
  self.res_item = self:AddComponent(UICommonResItem, "popup/ResItem")
  self.btn_fetch_reward:SetOnClick(function()
    self:OnIconClick()
  end)
end

function UILWSeasonMummyBuilding:OnDestroy()
  self.hp_bar = nil
  self.popup = nil
  self.pro = nil
  self.res_icon_shake = nil
  self.res_count = nil
  self.res_item = nil
  base.OnDestroy(self)
end

function UILWSeasonMummyBuilding:OnIconClick()
  if self.jumpMode and self.linkInfo then
    GoToUtil.TryJumpToWorld(self.linkInfo)
  elseif self.buildId and toInt(self.produceResult) > 0 then
    SFSNetwork.SendMessage(MsgDefines.FetchMilitaryCenterBuildResult, self.buildId)
  elseif self.buildData then
    UIUtil.ShowTipsId("season_s3_alliance_building_tips06")
  else
    UIUtil.ShowTipsId("2000292")
  end
end

function UILWSeasonMummyBuilding:ReInit(parentMeta)
  if parentMeta == nil or parentMeta.active_building_id == nil then
    self:SetActive(false)
    return
  end
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(parentMeta.active_building_id)
  if meta == nil then
    self:SetActive(false)
    return
  end
  self.produceStartTime = nil
  self.buildId = meta.baseId
  self.meta = meta
  self:UpdateStatus()
  if self.buildData == nil then
    self:SetActive(false)
  end
end

function UILWSeasonMummyBuilding:UpdateBuildIcon()
  if self.meta == nil or self.buildId == nil then
    self:SetActive(false)
    return
  end
  local buildData
  local theAttachmentList = DataCenter.AllianceMineManager:GetAllianceCenterAttachmentList()
  if theAttachmentList ~= nil then
    for _, theBuild in pairs(theAttachmentList) do
      if theBuild.buildId == self.buildId or theBuild.buildId + theBuild.level == self.buildId then
        buildData = theBuild
        break
      end
    end
  end
  if buildData then
    self:SetActive(true)
    self.icon:LoadSprite(self.meta:GetIconPath())
    if buildData:Injuried() then
      self.hp_bar:SetActive(true)
      self.hp_bar:SetValue(buildData:GetHPRate())
    else
      self.hp_bar:SetActive(false)
    end
    self.buildData = buildData
  else
    self.popup:SetActive(false)
    self.hp_bar:SetActive(false)
  end
end

function UILWSeasonMummyBuilding:UpdateStatus()
  if self.meta == nil or self.buildId == nil then
    self:SetActive(false)
    return 0
  end
  local data = DataCenter.AllianceMineManager.militaryCenterBuildInfos
  self:UpdateBuildIcon()
  self.anim_name = "Idle"
  self.jumpMode = false
  if data and self.buildData then
    local ProduceSpeed = 0
    local resIconPath
    local theProduceInfo = self.meta:GetProduceInfo()
    for k, v in pairs(theProduceInfo) do
      if v.ResType then
        ProduceSpeed = toInt(v.ResValue)
        resIconPath = DataCenter.ResourceManager:GetResourceIconByType(v.ResType, true)
        self.res_item:SetActive(false)
        break
      elseif v.itemId then
        ProduceSpeed = toInt(v.itemCount)
        resIconPath = nil
        self.res_item:SetActive(true)
        self.res_item:ReInit({
          rewardType = RewardType.GOODS,
          itemId = v.itemId,
          clickCallBack = function()
            self:OnIconClick()
          end
        })
        break
      end
    end
    if resIconPath == nil then
      self.res_icon_shake:SetActive(false)
    else
      self.res_icon_shake:SetActive(true)
      self.res_icon_shake:LoadSprite(resIconPath)
    end
    self.produceSpeed = ProduceSpeed
    self.produceResult = 0
    self.produceStartTime = nil
    self.productInfo = nil
    self.productStatus = nil
    if data.info then
      for k, v in pairs(data.info) do
        if v and (v.buildId == self.buildId or v.buildId + 1 == self.buildId) then
          self.productInfo = v
          break
        end
      end
    end
    if data.buildInfo then
      for k, v in pairs(data.buildInfo) do
        if v and (v.buildId == self.buildId or v.buildId + 1 == self.buildId) then
          self.productStatus = v
          break
        end
      end
    end
    if self.productInfo == nil then
      self.produceResult = 0
      self.res_count:SetText("0")
    else
      local num = toInt(self.productInfo.num)
      local speed = toInt(self.produceSpeed)
      self.produceResult = num * speed
      self.res_count:SetText(string.GetFormattedSeparatorNum(self.produceResult))
    end
    if self.buildData and self.buildData.pointId then
      local link = {
        action = "Jump",
        pointId = self.buildData.pointId,
        server = LuaEntry.Player:GetSourceServerId(),
        worldId = 0
      }
      self.linkInfo = link
    end
    local produceResult = toInt(self.produceResult)
    if self.buildData and self.buildData.status == AllianceMineStatus.Build and produceResult == 0 then
      self.res_count:SetText("")
      self.res_item:SetActive(false)
      self.res_icon_shake:SetActive(true)
      self.res_icon_shake:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/cfm_zhujiemian_tubiao_chuizi.png")
      self.pro:SetActive(false)
      self.popup:SetActive(true)
      self.anim_name = "Idle"
      self.produceResult = 0
      self.jumpMode = true
    elseif self.buildData and produceResult == 0 and self.buildData:Injuried() and DataCenter.SeasonFactionWarDataManager:GetCurrStep() ~= SeasonFactionDeclareWarStep.battle then
      self.res_count:SetText("")
      self.res_item:SetActive(false)
      self.res_icon_shake:SetActive(true)
      self.res_icon_shake:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/bubble_icon_hospital.png")
      self.pro:SetActive(false)
      self.popup:SetActive(true)
      self.produceResult = 0
      self.jumpMode = true
    elseif self.productStatus ~= nil then
      self.jumpMode = false
      if DataCenter.SeasonDataManager:GetSeasonSettleTime() < UITimeManager:GetInstance():GetServerTime() then
        self.produceStartTime = nil
        self.pro:SetActive(false)
      elseif self.productStatus.outputStat == 0 then
        self.produceStartTime = nil
        self.pro:SetColorRGBA255(255, 93, 0)
        self.pro:SetActive(true)
        if self.productStatus.endTime ~= nil and self.productStatus.endTime ~= 0 then
          local totalTime = self.productStatus.endTime - self.productStatus.beginTime
          local rate = math.min(1, totalTime / 600000)
          self.pro:SetFillAmount(rate)
        else
          self.pro:SetFillAmount(math.random())
        end
      else
        self.produceStartTime = self.productStatus.beginTime
        self.pro:SetColorRGBA255(46, 200, 82)
        self.pro:SetActive(true)
        self:Update100MS()
      end
      self.popup:SetActive(true)
      if self.produceResult ~= nil and self.produceResult ~= 0 then
        self.anim_name = "Default"
      else
        self.anim_name = "Idle"
      end
    else
      self.popup:SetActive(false)
    end
  else
    self.produceStartTime = nil
    self.popup:SetActive(false)
  end
end

function UILWSeasonMummyBuilding:Update100MS()
  if self.produceStartTime ~= nil and self.produceStartTime ~= 0 then
    local now = UITimeManager:GetInstance():GetServerTime()
    local totalTime = now - self.produceStartTime
    local rate = math.min(1, totalTime / 600000)
    self.pro:SetFillAmount(rate)
    if 0.99999 <= rate then
      self.produceStartTime = now
    end
  end
  if self.anim_name then
    if self.popupAnim:IsPlaying(self.anim_name) then
      self.popupAnim:Rewind(self.anim_name)
    else
      self.popupAnim:Stop()
      self.popupAnim:Play(self.anim_name)
    end
    self.anim_name = nil
  end
end

return UILWSeasonMummyBuilding
