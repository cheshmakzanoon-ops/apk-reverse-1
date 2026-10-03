local UILWSeasonOutpostNodeS6 = BaseClass("UILWSeasonOutpostNodeS6", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")

function UILWSeasonOutpostNodeS6:OnCreate()
  base.OnCreate(self)
  self.btnGo = self:AddComponent(UIButton, "")
  self.bg = self:AddComponent(UIImage, "")
  self.icon = self:AddComponent(UIRawImage, "icon")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.statusTxt = self:AddComponent(UITextMeshProUGUIEx, "NodeList/status")
  self.btn_put = self:AddComponent(UIButton, "NodeList/BtnPut")
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, "NodeList/BtnPut/BtnText")
  self.infoTxt = self:AddComponent(UITextMeshProUGUIEx, "NodeList/info")
  self.destroyTxt = self:AddComponent(UITextMeshProUGUIEx, "NodeList/destroyTxt")
  self.progress_build = self:AddComponent(UISlider, "NodeList/progressBuild")
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, "NodeList/progressBuild/progressBg/progressText")
  self.btn_put:SetOnClick(function()
    local lastStatus = self.lastStatus
    local cityData = self.cityData
    if cityData == nil then
      return
    end
    if lastStatus == 1 then
      UIUtil.ShowTipsId("s0_alliance_boss_go_lock_btn")
      return
    elseif lastStatus == 2 then
      UIUtil.ShowTipsId("activity_1200043_tips28")
      return
    elseif lastStatus == 3 then
    elseif lastStatus == 4 then
    elseif lastStatus == 5 then
    elseif lastStatus == 6 then
    end
    local cityInfo = cityData.cityInfo
    if cityInfo == nil then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonPutOutpostS6, {anim = true}, self.index)
    else
      local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityInfo.cityId, cityInfo.serverId)
      if meta then
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        meta:JumpTo()
      end
    end
  end)
  self.btnGo:SetOnClick(function()
    local cityData = self.cityData
    if cityData == nil then
      return
    end
    local cityInfo = cityData.cityInfo
    if cityInfo ~= nil then
      local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityInfo.cityId, cityInfo.serverId)
      if meta then
        meta:JumpTo()
      end
    end
  end)
  self.campIcon = self:AddComponent(UIRawImage, "camp")
  self.destroyTxt:SetActive(false)
  self.nodeRoot = self:AddComponent(UIBaseComponent, "NodeList")
  self.progress_build:SetValue(0)
  self.progress_text:SetText("")
  self.progress_build:SetActive(false)
end

function UILWSeasonOutpostNodeS6:OnDestroy()
  self.icon = nil
  self.name = nil
  self.campIcon = nil
  self.statusTxt = nil
  self.infoTxt = nil
  self.destroyTxt = nil
  self.btn_put = nil
  self.btn_text = nil
  self.actData = nil
  self.cityData = nil
  self.cityInfo = nil
  self.progress_build = nil
  self.progress_text = nil
  base.OnDestroy(self)
end

function UILWSeasonOutpostNodeS6:Refresh(actData, cityData, dataList)
  self.actData = actData
  self.cityData = cityData
  self.dataList = dataList
  self.myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  self.put_start_time = nil
  self.put_end_time = nil
  if cityData then
    self.index = cityData.index
    self.cityInfo = cityData.cityInfo
    if self.cityInfo then
      self.repairInfo = self.cityInfo.repairInfo or FetchOutpostRepairInfo.GetRepairInfo(self.cityInfo.serverId, self.cityInfo.cityId, true, false)
    end
    self:RefreshBaseData()
    self:Update1000MS()
  end
end

function UILWSeasonOutpostNodeS6:RefreshBaseData()
  if self.actData == nil or self.cityData == nil then
    return
  end
  local cityInfo = self.cityInfo
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.myCampId == 1 then
    self.campIcon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_2.png")
  else
    self.campIcon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/CommonS6/mjc_S6_wenli_zhenying_1.png")
  end
  self.campIcon:SetColorRGBA(1, 1, 1, 0.2)
  self.name:SetLocalText("s6_outpost_title_" .. self.index)
  if now < self.cityData.unlock_time then
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_fangzhi_bg3.png")
  else
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/OutpostS6/mjc_S6_QSZ_fangzhi_bg2.png")
  end
  if cityInfo == nil then
    self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_jianzhu01.png", function()
      self.icon:SetNativeSize()
    end)
  else
    local destroyServerId = DataCenter.WorldAllianceCityDataManager:GetDestroyCityServerId(cityInfo.serverId, cityInfo.cityId)
    if destroyServerId == 0 then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_jianzhu01.png", function()
        self.icon:SetNativeSize()
      end)
    else
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/OutpostS6/mjc_S6_QSZ_jianzhu02.png", function()
        self.icon:SetNativeSize()
      end)
    end
  end
end

function UILWSeasonOutpostNodeS6:RefreshView(now)
  local cityData = self.cityData
  local lastStatus = self.lastStatus
  if self.actData == nil or cityData == nil or self.gameObject == nil then
    return
  end
  local cityInfo = self.cityInfo
  if now < cityData.unlock_time then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(cityData.unlock_time - now)
    self.infoTxt:SetActive(true)
    self.statusTxt:SetActive(true)
    self.btn_put:SetActive(false)
    self.destroyTxt:SetActive(false)
    self.statusTxt:SetLocalText("s6_outpost_limit_3")
    self.infoTxt:SetText(timeStr)
    self.lastStatus = 1
  elseif cityInfo == nil then
    if self.put_start_time == nil or now < self.put_start_time then
      local timeStr = ""
      if self.put_start_time == nil then
        timeStr = ""
      else
        timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.put_start_time - now)
        if self.put_start_time == nil then
          if self.actData then
            timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.actData.endTime - now)
          else
            timeStr = "??:??:??"
          end
        else
          timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.put_start_time - now)
        end
      end
      self.infoTxt:SetActive(false)
      self.statusTxt:SetActive(true)
      self.btn_put:SetActive(true)
      self.destroyTxt:SetActive(false)
      self.btn_text:SetLocalText("s6_outpost_btn_3")
      self.statusTxt:SetText(timeStr)
      CS.UIGray.SetGray(self.btn_put.transform, true, true)
      self.lastStatus = 2
    else
      self.btn_put:SetActive(true)
      self.statusTxt:SetActive(true)
      self.infoTxt:SetActive(false)
      self.destroyTxt:SetActive(false)
      CS.UIGray.SetGray(self.btn_put.transform, false, true)
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.put_end_time - now)
      self.btn_text:SetLocalText("s6_outpost_btn_3")
      self.statusTxt:SetText("<color=#f97077>" .. timeStr .. "</color>")
      self.lastStatus = 3
    end
  else
    local theCityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityInfo.cityId, cityInfo.serverId)
    if theCityData ~= nil and theCityData.destroyServerId ~= nil and theCityData.destroyServerId ~= 0 then
      local meta = cityInfo.meta
      local pointId = meta:GetPointId()
      local msg = UIUtil.MakeJumpLink(pointId, cityInfo.serverId, 0)
      self.statusTxt:SetText("<color=#F53C3D>" .. msg .. "</color>")
      self.infoTxt:SetActive(false)
      self.btn_put:SetActive(false)
      self.statusTxt:SetActive(true)
      self.destroyTxt:SetActive(true)
      self.lastStatus = 4
    elseif theCityData and theCityData.occupyServerId ~= LuaEntry.Player:GetSourceServerId() then
      local msg = Localization:GetString("801038") .. "#" .. theCityData.occupyServerId
      self.statusTxt:SetText("<color=#F53C3D>" .. msg .. "</color>")
      self.infoTxt:SetActive(false)
      self.btn_put:SetActive(true)
      self.btn_text:SetLocalText("s6_outpost_btn_1")
      self.statusTxt:SetActive(true)
      self.destroyTxt:SetActive(false)
      self.lastStatus = 5
    else
      local meta = cityInfo.meta
      local pointId = meta:GetPointId()
      local msg = UIUtil.MakeJumpLink(pointId, cityInfo.serverId, 0)
      self.statusTxt:SetText(msg)
      self.infoTxt:SetText("")
      self.statusTxt:SetActive(true)
      self.btn_put:SetActive(true)
      self.destroyTxt:SetActive(false)
      self.infoTxt:SetActive(false)
      self.btn_text:SetLocalText("s6_outpost_btn_1")
      self.lastStatus = 6
    end
  end
  if self.lastStatus ~= lastStatus then
    self:RefreshBaseData()
  end
  if self.lastStatus == 6 then
    local repairInfo = self.repairInfo
    local outpostInfo
    if repairInfo then
      outpostInfo = repairInfo.outpostInfo or {}
    end
    if repairInfo ~= nil and outpostInfo ~= nil and outpostInfo.state == 0 then
      self.progress_build:SetValue(0)
      self.progress_text:SetText("")
      local canRepairCount = 0
      if self.actData and outpostInfo then
        local needPoint = toInt(self.actData.para)
        local hasPoint = toInt(outpostInfo.repairScore)
        canRepairCount = toInt(self.actData.para_4)
        self.progress_text:SetLocalText("150033", hasPoint, needPoint)
        if 0 < needPoint then
          self.progress_build:SetValue(hasPoint / needPoint)
        else
          self.progress_build:SetValue(0)
        end
        if needPoint <= hasPoint then
          self.btn_text:SetLocalText("war_zone_outpost_25")
          self.progress_build:SetActive(false)
        else
          self.progress_build:SetActive(true)
          self.btn_text:SetLocalText("war_zone_outpost_18")
        end
      else
        self.progress_build:SetActive(false)
      end
    else
      self.progress_build:SetActive(false)
    end
  else
    self.progress_build:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.nodeRoot.transform)
end

function UILWSeasonOutpostNodeS6:Update1000MS()
  if self.infoTxt == nil or self.statusTxt == nil or self.cityData == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  for _, theCityData in ipairs(self.dataList) do
    if theCityData == nil then
    elseif now < theCityData.put_start_time then
      self.put_start_time = theCityData.put_start_time
      self.put_end_time = theCityData.put_end_time
      break
    elseif now < theCityData.put_end_time then
      self.put_start_time = theCityData.put_start_time
      self.put_end_time = theCityData.put_end_time
      break
    end
  end
  self:RefreshView(now)
end

return UILWSeasonOutpostNodeS6
