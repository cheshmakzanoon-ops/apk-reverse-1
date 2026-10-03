local base = UIBaseContainer
local LWBuyDiamondResDownloadComponent = BaseClass("LWBuyDiamondResDownloadComponent", base)
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local Localization = CS.GameEntry.Localization
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

function LWBuyDiamondResDownloadComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWBuyDiamondResDownloadComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBuyDiamondResDownloadComponent:ComponentDefine()
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/TitleText")
  self.textDes = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/DesText")
  self.compDownloadBtn = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/DownloadBtn")
  self.textSizeTitle = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/ProgressContent/Layout/SizeTitleText")
  self.textSizeValue = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/ProgressContent/Layout/SizeValueText")
  self.compCompleteBtn = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/CompleteBtn")
  self.textFinal = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/FinalText")
  self.compMainContent = self:AddComponent(UIBaseComponent, "MainContent")
  self.compFlagComplete2 = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/CompleteBtn/FlagComplete2")
  self.compFlagComplete = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/CompleteBtn/FlagComplete")
  self.textSlider = self:AddComponent(UITextMeshProUGUIEx, "MainContent/CenterContent/ProgressContent/TextSlider")
  self.sliderLWSimple = self:AddComponent(UISlider, "MainContent/CenterContent/ProgressContent/LW_Simple_Slider/Slider")
  self.compFlagDownload = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/LW_Simple_Slider/Slider/Fill Area/Fill/soldierRoot/FlagDownload")
  self.compFlagDownload2 = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/LW_Simple_Slider/Slider/Fill Area/Fill/soldierRoot/FlagDownload2")
  self.compSoldierRoot = self:AddComponent(UIBaseComponent, "MainContent/CenterContent/ProgressContent/LW_Simple_Slider/Slider/Fill Area/Fill/soldierRoot")
end

function LWBuyDiamondResDownloadComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textDes = nil
  self.sliderLWSimple = nil
  self.compFlagDownload = nil
  self.compFlagDownload2 = nil
  self.compDownloadBtn = nil
  self.textSizeTitle = nil
  self.textSizeValue = nil
  self.compCompleteBtn = nil
  self.textFinal = nil
  self.compMainContent = nil
  self.compFlagComplete2 = nil
  self.compFlagComplete = nil
  self.textSlider = nil
  self.compSoldierRoot = nil
end

function LWBuyDiamondResDownloadComponent:DataDefine()
  self.packConfigIdList = {}
  self.curShowPackConfigId = 0
  
  function self.func_on_countdown_tick()
    self:OnCountdownTick()
  end
end

function LWBuyDiamondResDownloadComponent:DataDestroy()
  self.packConfigIdList = nil
  self.curShowPackConfigId = nil
  if self.delayShowNextTimer then
    self.delayShowNextTimer:Stop()
    self.delayShowNextTimer = nil
  end
end

function LWBuyDiamondResDownloadComponent:OnEnable()
  base.OnEnable(self)
  self.isEnable = true
end

function LWBuyDiamondResDownloadComponent:OnDisable()
  base.OnDisable(self)
  self.isEnable = false
end

function LWBuyDiamondResDownloadComponent:OnAddListener()
  base.OnAddListener(self)
end

function LWBuyDiamondResDownloadComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWBuyDiamondResDownloadComponent:SetData(rechargeId, onDownloadCompleteFunc)
  self.rechargeId = rechargeId
  self.onDownloadCompleteFunc = onDownloadCompleteFunc
  self.packConfigIdList = self:GetPackConfigIdList(self.rechargeId)
  self.curShowPackConfigId = self:GetNextShowPackConfigId(self.packConfigIdList)
  self.isDownloading = false
  self.curShowPackData = nil
  self:SetSoldierRect()
  self:TryShowNextDownloadPack()
end

function LWBuyDiamondResDownloadComponent:SetDataByActivityId(activityId, onDownloadCompleteFunc)
  self.onDownloadCompleteFunc = onDownloadCompleteFunc
  self.packConfigIdList = self.packConfigIdList or {}
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if actInfo then
    self.packConfigIdList = actInfo:GetDownloadResPackConfigIdList()
  end
  self.curShowPackConfigId = self:GetNextShowPackConfigId(self.packConfigIdList)
  self.isDownloading = false
  self.curShowPackData = nil
  self:SetSoldierRect()
  self:TryShowNextDownloadPack()
end

function LWBuyDiamondResDownloadComponent:SetPackageCfgIdListData(packageCfgIdList, onDownloadCompleteFunc)
  self.onDownloadCompleteFunc = onDownloadCompleteFunc
  self.packConfigIdList = packageCfgIdList
  self.curShowPackConfigId = self:GetNextShowPackConfigId(self.packConfigIdList)
  self.isDownloading = false
  self.curShowPackData = nil
  self:SetSoldierRect()
  self:TryShowNextDownloadPack()
end

function LWBuyDiamondResDownloadComponent:SetSoldierRect()
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.compSoldierRoot:SetLocalScaleXYZ(-1, 1, 1)
    self.compSoldierRoot.transform:GetComponent(typeof(CS.UnityEngine.RectTransform)):SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Left, 0, 50)
  else
    self.compSoldierRoot:SetLocalScaleXYZ(1, 1, 1)
    self.compSoldierRoot.transform:GetComponent(typeof(CS.UnityEngine.RectTransform)):SetInsetAndSizeFromParentEdge(CS.UnityEngine.RectTransform.Edge.Right, 0, 50)
  end
end

function LWBuyDiamondResDownloadComponent:TryShowNextDownloadPack()
  self.isDownloading = false
  local nextConfigId = self:GetNextShowPackConfigId(self.packConfigIdList)
  if nextConfigId == nil then
    self:SwitchToRealContent()
  else
    DataCenter.PlayerDownloadCenterManager:SetShowTrulyDownloadProgress(nextConfigId, true)
    DataCenter.PlayerDownloadCenterManager:SetDownloadPackageState(nextConfigId, Const.DownloadState.Downloading)
    self.curShowPackData = ResGroupManager:StartDownload(nextConfigId)
    self.curShowPackData:completed("+", function(loaderReq)
      if not ResGroupManager:IsDownload(nextConfigId) then
        Logger.LogError("pack\228\184\139\232\189\189\229\174\140\228\185\139\229\144\142\230\156\172\229\156\176\230\178\161\230\137\190\229\136\176\239\188\159\239\188\159 packConfigId: " .. nextConfigId)
      end
      if loaderReq.isDownloadSuccess then
        DataCenter.PlayerDownloadCenterManager:SetDownloadPackageState(loaderReq.configId, Const.DownloadState.Completed)
      else
        DataCenter.PlayerDownloadCenterManager:SetDownloadPackageState(nextConfigId, Const.DownloadState.Paused)
      end
      if not self.isEnable then
        return
      end
      self:OnDownloadComplete(loaderReq)
    end)
    self.isDownloading = true
    self:RefreshDownloading()
  end
end

function LWBuyDiamondResDownloadComponent:SwitchToRealContent()
  if self.onDownloadCompleteFunc then
    self.onDownloadCompleteFunc()
  end
end

function LWBuyDiamondResDownloadComponent:OnDownloadComplete(loaderReq)
  if self.curShowPackData ~= nil and loaderReq ~= nil and loaderReq.configId == self.curShowPackData.configId then
    self:RefreshDownloadFinish()
    if self.delayShowNextTimer then
      self.delayShowNextTimer:Stop()
      self.delayShowNextTimer = nil
    end
    self.delayShowNextTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:TryShowNextDownloadPack()
    end, 1)
  end
  self.isDownloading = false
end

function LWBuyDiamondResDownloadComponent:RefreshDownloadFinish()
  if self.curShowPackData == nil then
    Logger.LogError("LWBuyDiamondResDownloadComponent Error: RefreshDownloadFinish when no packdata")
    return
  end
  self.textDes:SetActive(false)
  self.textTitle:SetLocalText("package_ui_tittle03")
  self.sliderLWSimple:SetValue(1)
  self.textSlider:SetText("100%")
  self.compFlagDownload:SetActive(false)
  self.compFlagDownload2:SetActive(false)
  self.textSizeValue:SetText(string.format("%sMb", self.curShowPackData.totalSizeMBStr))
  self.textSizeTitle:SetText(string.format("%sMb", self.curShowPackData.totalSizeMBStr) .. "/")
  self.compCompleteBtn:SetActive(true)
  self.compDownloadBtn:SetActive(false)
  self.compFlagComplete:SetActive(true)
  self.compFlagComplete2:SetActive(true)
end

function LWBuyDiamondResDownloadComponent:RefreshDownloading()
  if self.curShowPackData == nil then
    return
  end
  self.textDes:SetActive(true)
  self.textTitle:SetLocalText("activity_commondownload_title")
  self.textDes:SetLocalText("activity_commondownload_desc3")
  local progress = self.curShowPackData.TotalProgress
  self.sliderLWSimple:SetValue(progress)
  self.textSlider:SetText(string.GetFormattedPercentStr(progress))
  self.compFlagDownload:SetActive(true)
  self.compFlagDownload2:SetActive(true)
  local curSize = self.curShowPackData.alreadyDownloadSize + self.curShowPackData.downloadSize
  if curSize > self.curShowPackData.totalSize then
    curSize = self.curShowPackData.totalSize
  end
  local curSizeMBStr = self:ByteToMegaByte(curSize)
  self.textSizeValue:SetText(string.format("%sMb", self.curShowPackData.totalSizeMBStr))
  self.textSizeTitle:SetText(string.format("%sMb", curSizeMBStr) .. "/")
  self.compCompleteBtn:SetActive(false)
  self.compDownloadBtn:SetActive(true)
  self.compFlagComplete:SetActive(false)
  self.compFlagComplete2:SetActive(false)
  self.textFinal:SetActive(false)
end

function LWBuyDiamondResDownloadComponent:GetPackConfigIdList(rechargeId)
  if rechargeId == nil then
    return nil
  end
  local tagInfo = WelfareController.getShowTagInfoById(rechargeId)
  if not tagInfo then
    return nil
  end
  local packConfigIdList = {}
  local pageType = tagInfo:getType()
  if pageType == WelfareTagType.SingleActivity then
    local actData = tagInfo:getInfo()
    if actData then
      local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actData.id)
      if actInfo then
        packConfigIdList = actInfo:GetDownloadResPackConfigIdList()
      end
    end
  end
  return packConfigIdList
end

function LWBuyDiamondResDownloadComponent:ByteToMegaByte(byteData)
  if byteData and 0 < byteData then
    return string.format("%.2f", byteData / 1048576)
  else
    return "???"
  end
end

function LWBuyDiamondResDownloadComponent:Update100MS()
  if self.isDownloading then
    self:RefreshDownloading()
  end
end

function LWBuyDiamondResDownloadComponent:GetNextShowPackConfigId(configIdList)
  if table.IsNullOrEmpty(configIdList) then
    return nil
  end
  for i, configId in ipairs(configIdList) do
    if not ResGroupManager:IsDownload(configId) then
      return configId
    end
  end
end

return LWBuyDiamondResDownloadComponent
