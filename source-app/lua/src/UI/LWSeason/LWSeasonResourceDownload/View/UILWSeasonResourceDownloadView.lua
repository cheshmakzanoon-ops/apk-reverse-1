local base = UIBaseView
local UILWSeasonResourceDownloadView = BaseClass("UILWSeasonResourceDownloadView", base)
local Localization = CS.GameEntry.Localization
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
local DownloadStatus = {
  UnKnown = 0,
  Wait = 1,
  Working = 2,
  Finish = 3,
  Paused = 4
}
local des_path = "root/des"
local slider_path = "root/area/download/Slider"
local okBtn_path = "root/BtnGo/rightBtn"
local close_path = "root/panel"
local title_path = "root/titleText"
local cancleBtn_path = "root/BtnGo/leftBtn"
local packIcon_path = "root/area/packArea/packIcon"
local packName_path = "root/area/packArea/packName"
local packSize_path = "root/area/packArea/packSize"
local packArea_path = "root/area/packArea"
local leftBtnName_path = "root/BtnGo/leftBtn/leftBtnName"
local rightBtnName_path = "root/BtnGo/rightBtn/rightBtnName"
local downloadSpeed_path = "root/area/download/downloadSpeed"
local downloadTime_path = "root/area/download/downloadTime"
local downloadArea_path = "root/area/download"
local rewardCount_path = "root/area/RawImage/RewardRoot/rewardCount"
local rewardDes_path = "root/area/RawImage/RewardRoot/rewardDes"
local downloadDes_path = "root/area/download/downloadDes"
local leftBtnImg_path = "root/BtnGo/leftBtn/leftBtnImg"
local rightBtnImg_path = "root/BtnGo/rightBtn/rightBtnImg"
local greenBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_1.png"
local yellowBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_3.png"
local redBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_4.png"
local blueBtnPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_5.png"
local image1_path = "root/area/RawImage/Image1"
local image2_path = "root/area/RawImage/Image2"
local image3_path = "root/area/RawImage/Image3"

function UILWSeasonResourceDownloadView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local _configId, _serverId, _crossing = self:GetUserData()
  self.configId = toInt(_configId)
  self.serverId = toInt(_serverId)
  self.crossMode = _crossing
  self.state = DownloadStatus.UnKnown
  self:Refresh()
  if self.skinMgr ~= nil then
    self.skinMgr:ActiveSkin(self.configId)
  end
  Logger.LogInfo(string.format("SeasonResourceDownload %s %s %s", self.configId, self.serverId, not not _crossing))
end

function UILWSeasonResourceDownloadView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonResourceDownloadView:ComponentDefine()
  self.des = self:AddComponent(UIText, des_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.okBtn = self:AddComponent(UIButton, okBtn_path)
  self.close = self:AddComponent(UIButton, close_path)
  self.title = self:AddComponent(UIText, title_path)
  self.cancleBtn = self:AddComponent(UIButton, cancleBtn_path)
  self.packIcon = self:AddComponent(UIImage, packIcon_path)
  self.packName = self:AddComponent(UIText, packName_path)
  self.packSize = self:AddComponent(UIText, packSize_path)
  self.packArea = self:AddComponent(UIBaseContainer, packArea_path)
  self.leftBtnName = self:AddComponent(UIText, leftBtnName_path)
  self.rightBtnName = self:AddComponent(UIText, rightBtnName_path)
  self.downloadSpeed = self:AddComponent(UIText, downloadSpeed_path)
  self.downloadTime = self:AddComponent(UIText, downloadTime_path)
  self.downloadArea = self:AddComponent(UIBaseContainer, downloadArea_path)
  self.rewardCount = self:AddComponent(UIText, rewardCount_path)
  self.downloadDes = self:AddComponent(UIText, downloadDes_path)
  self.leftBtnImg = self:AddComponent(UIImage, leftBtnImg_path)
  self.rightBtnImg = self:AddComponent(UIImage, rightBtnImg_path)
  self.rewardDes = self:AddComponent(UIText, rewardDes_path)
  self.image1 = self:AddComponent(UIRawImage, image1_path)
  self.image2 = self:AddComponent(UIRawImage, image2_path)
  self.image3 = self:AddComponent(UIRawImage, image3_path)
  self.close:SetOnClick(function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonResourceDownload)
  end)
  self.okBtn:SetOnClick(function()
    self:RightBtnClick()
  end)
  self.cancleBtn:SetOnClick(function()
    self:LeftBtnClick()
  end)
  self.slider:SetValue(0)
  self.skinMgr = self:AddComponent(UIDynamicSkin, "")
end

function UILWSeasonResourceDownloadView:ComponentDestroy()
  self.des = nil
  self.slider = nil
  self.okBtn = nil
  self.close = nil
  self.title = nil
  self.cancleBtn = nil
  self.packIcon = nil
  self.packName = nil
  self.packSize = nil
  self.packArea = nil
  self.leftBtnName = nil
  self.rightBtnName = nil
  self.downloadSpeed = nil
  self.downloadTime = nil
  self.downloadArea = nil
  self.rewardCount = nil
  self.downloadDes = nil
  self.leftBtnImg = nil
  self.rightBtnImg = nil
  self.rewardDes = nil
  self.loader = nil
  self.image1 = nil
  self.image2 = nil
  self.image3 = nil
end

function UILWSeasonResourceDownloadView:DataDefine()
  self.curDownload = 0
end

function UILWSeasonResourceDownloadView:DataDestroy()
  EventManager:GetInstance():Broadcast(EventId.SeasonStatusChanged, LuaEntry.Player:GetSelfServerId())
end

function UILWSeasonResourceDownloadView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonResourceDownloadIndexSync, self.SyncCallback)
  self:AddUIListener(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish)
  self:AddUIListener(EventId.LWSeasonResourceDownloadStart, self.StartDownload)
end

function UILWSeasonResourceDownloadView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadStart, self.StartDownload)
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadIndexSync, self.SyncCallback)
  self:RemoveUIListener(EventId.LWSeasonResourceDownloadFinish, self.DownloadFinish)
  base.OnRemoveListener(self)
end

function UILWSeasonResourceDownloadView:SyncCallback(forceStart)
  if self.configId and (forceStart == true or self.state == DownloadStatus.Wait) then
    self.loader = CS.DownloadManifestManager.Instance:AddNewDownload(self.configId, true)
  end
end

function UILWSeasonResourceDownloadView:Refresh()
  self.loader = nil
  local packageConfig = LocalController:instance():getLine(TableName.Download_Packs, self.configId)
  if packageConfig then
    self.packName:SetLocalText(packageConfig.name)
    self.packIcon:SetActive(false)
    local msg
    if self.crossMode == true then
      msg = Localization:GetString(packageConfig.desc_crossing)
    else
      local packageId, needInPreviewMode = SeasonUtil.GetSeasonResourcePackName(false)
      if packageId == self.configId and needInPreviewMode then
        msg = Localization:GetString(packageConfig.desc)
      else
        msg = ""
      end
    end
    self.descStr = msg or ""
    self.des:SetText(self.descStr)
    self.rewardCount:SetText("\195\151" .. packageConfig.diamond)
    self.rewardDes:SetLocalText("package_ui_tips01", packageConfig.diamond)
    local banner = packageConfig.banner
    if not string.IsNullOrEmpty(banner) then
      local bannerList = string.split_ss_array(banner, ";")
      local bannerCount = #bannerList
      if 3 <= bannerCount then
        self.image3:LoadSpriteAsync(bannerList[1])
        self.image2:LoadSpriteAsync(bannerList[2])
        self.image1:LoadSpriteAsync(bannerList[3])
      elseif bannerCount == 2 then
        self.image3:LoadSpriteAsync(bannerList[1])
        self.image2:LoadSpriteAsync(bannerList[2])
      elseif bannerCount == 1 then
        self.image3:LoadSpriteAsync(bannerList[1])
      end
      self.image3:SetActive(0 < bannerCount)
      self.image2:SetActive(1 < bannerCount)
      self.image1:SetActive(2 < bannerCount)
    end
  end
  self.downloadSpeed:SetText("")
  self.downloadTime:SetText("")
  if self.configId then
    self.loader = CS.DownloadManifestManager.Instance:GetLoadManifestData(self.configId)
    if self.loader == nil then
      self.loader = CS.DownloadManifestManager.Instance:CreateDownloadData(self.configId)
    end
    local resourceState = SeasonUtil.IsSeasonResDownloaded(self.configId)
    if resourceState or self.loader:CheckFinish() then
      self:SwitchToFinish()
    elseif self.loader.IsPaused then
      self:SwitchToPause()
    else
      self:SwitchToWorking()
    end
    self.packSize:SetText(Localization:GetString("season_unpack_resource_size_des") .. self:ByteToMegaByte(self.loader.totalSize))
  end
end

function UILWSeasonResourceDownloadView:SwitchToFinish()
  self.state = DownloadStatus.Finish
  self.rightBtnImg:LoadSprite(greenBtnPath)
  self.title:SetLocalText("package_ui_tittle03")
  self.des:SetLocalText("package_ui_tips06")
  self.rightBtnName:SetLocalText("package_ui_btn04")
  self.okBtn:SetActive(true)
  self.cancleBtn:SetActive(false)
  self.downloadArea:SetActive(false)
end

function UILWSeasonResourceDownloadView:SwitchToWorking()
  local curSize = self.loader.alreadyDownloadSize + self.loader.downloadSize
  local curDownloadValue = self:ByteToMegaByte(curSize)
  self.state = DownloadStatus.Working
  self.curDownload = curSize
  self.downloadArea:SetActive(true)
  self.okBtn:SetActive(true)
  self.cancleBtn:SetActive(true)
  self.title:SetLocalText("package_ui_tittle02")
  self.des:SetLocalText("package_ui_tips02")
  self.rightBtnName:SetLocalText("package_ui_btn03")
  self.leftBtnName:SetLocalText("package_ui_btn05")
  self.rightBtnImg:LoadSprite(blueBtnPath)
  self.leftBtnImg:LoadSprite(redBtnPath)
  self.downloadDes:SetText(string.format("%s/%sMb", curDownloadValue, self.loader.totalSizeMBStr))
  self.packSize:SetText(Localization:GetString("season_unpack_resource_size_des") .. self:ByteToMegaByte(self.loader.totalSize))
  self:Update1000MS()
end

function UILWSeasonResourceDownloadView:SwitchToPause()
  local curSize = self.loader.alreadyDownloadSize + self.loader.downloadSize
  local curDownloadValue = self:ByteToMegaByte(curSize)
  self.state = DownloadStatus.Paused
  self.downloadArea:SetActive(true)
  self.okBtn:SetActive(true)
  self.cancleBtn:SetActive(true)
  self.title:SetLocalText("package_ui_tittle01")
  self.des:SetText(self.descStr or "")
  self.slider:SetValue(curSize / self.loader.totalSize)
  self.rightBtnName:SetLocalText("package_ui_btn02")
  self.leftBtnName:SetLocalText("package_ui_btn01")
  self.rightBtnImg:LoadSprite(greenBtnPath)
  self.leftBtnImg:LoadSprite(redBtnPath)
  self.downloadDes:SetText(string.format("%s/%sMb", curDownloadValue, self.loader.totalSizeMBStr))
  self.packSize:SetText(Localization:GetString("season_unpack_resource_size_des") .. self:ByteToMegaByte(self.loader.totalSize))
end

function UILWSeasonResourceDownloadView:RightBtnClick()
  if CS.CommonUtils.IsDebug() then
    Logger.LogInfo(string.format("SRD.RightBtnClick, configId = %s, state = %s", self.configId, self.state))
  end
  if self.state == DownloadStatus.Wait or self.state == DownloadStatus.Paused then
    if self.configId ~= 0 then
      DataCenter.SeasonResourceDownloadManager:AddDataAndSync(self.configId, false)
      self:SyncCallback(true)
      EventManager:GetInstance():Broadcast(EventId.SeasonStatusChanged, LuaEntry.Player:GetSelfServerId())
    end
  elseif self.state == DownloadStatus.Working then
    self.ctrl:CloseSelf()
  elseif self.state == DownloadStatus.Finish then
    if self.configId and self.configId ~= 0 and not LuaEntry.Player:CheckUnpackResourceReward(self.configId) then
      SFSNetwork.SendMessage(MsgDefines.LwSeasonResRqReward, self.configId)
    end
    self.ctrl:CloseSelf()
  end
end

function UILWSeasonResourceDownloadView:LeftBtnClick()
  if CS.CommonUtils.IsDebug() then
    Logger.LogInfo(string.format("SRD.LeftBtnClick, configId = %s, state = %s", self.configId, self.state))
  end
  if self.state == DownloadStatus.Wait or self.state == DownloadStatus.Paused then
    self.ctrl:CloseSelf()
  elseif self.state == DownloadStatus.Working then
    self:SwitchToPause()
    CS.DownloadManifestManager.Instance:StopDownload(self.configId)
    DataCenter.SeasonResourceDownloadManager:AddDataAndSync(self.configId, true)
    EventManager:GetInstance():Broadcast(EventId.LWUnpackResourceRewardUpdate)
  end
end

function UILWSeasonResourceDownloadView:StartDownload(loaderKey)
  if self.configId == loaderKey then
    self.loader = CS.DownloadManifestManager.Instance:GetLoadManifestData(self.configId)
    self:SwitchToWorking()
  end
end

function UILWSeasonResourceDownloadView:DownloadFinish(loaderKey)
  if self.loader and self.loader.configId == loaderKey and self.loader.isDone then
    if string.IsNullOrEmpty(self.loader.errMsg) then
      self.packSize:SetText(Localization:GetString("season_unpack_resource_size_des") .. self:ByteToMegaByte(self.loader.totalSize))
      self.slider:SetValue(1)
      if SeasonUtil.IsSeasonResDownloaded(loaderKey) and not LuaEntry.Player:CheckUnpackResourceReward(self.configId) then
        SFSNetwork.SendMessage(MsgDefines.LwSeasonResRqReward, toInt(self.configId))
      end
      self:SwitchToFinish()
    else
      self:SwitchToPause()
      Logger.LogError(self.loader.errMsg)
    end
  end
end

function UILWSeasonResourceDownloadView:Update1000MS()
  if self.loader and self.state == DownloadStatus.Working then
    self.slider:SetValue(self.loader.TotalProgress)
    local curSize = self.loader.alreadyDownloadSize + self.loader.downloadSize
    local curDownloadValue = self:ByteToMegaByte(curSize)
    local newSize = curSize - self.curDownload
    self.curDownload = curSize
    if 0 < newSize then
      self.downloadSpeed:SetText(self:ByteToMegaByte(newSize) .. "/s")
      local time = toInt((self.loader.totalSize - curSize) / newSize)
      self.downloadTime:SetText(UITimeManager:GetInstance():SecondToFmtString(time))
    else
      self.downloadSpeed:SetText("0Mb/s")
      self.downloadTime:SetText("")
    end
    self.downloadDes:SetText(string.format("%s/%sMb", curDownloadValue, self.loader.totalSizeMBStr))
  else
    self.downloadSpeed:SetText("")
    self.downloadTime:SetText("")
  end
end

function UILWSeasonResourceDownloadView:ByteToMegaByte(byteData)
  if byteData and 0 < byteData then
    return string.format("%.2f", byteData / 1048576) .. "Mb"
  else
    return "???"
  end
end

return UILWSeasonResourceDownloadView
