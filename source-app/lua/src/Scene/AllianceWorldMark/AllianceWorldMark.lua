local AllianceWorldMark = BaseClass("AllianceWorldMark")
local Localization = CS.GameEntry.Localization
local MATERIAL_PATH = "Assets/Main/Material/AllanceMark/%s"
local MarkSorter = require("Scene/AllianceWorldMark/WorldMarkSorter")
local icon_path = "mark/UIAlliance_mark_sanjiao"
local r4_path = "mark/UIAlliance_mark_sanjiao/R4"
local nameBg_path = "mark/Arrow/nameBg"
local translate_btnCollider_path = "mark/Arrow/translateBtn/Collider"
local translate_divideLine_path = "mark/Arrow/nameBg/divideLine"
local translate_btnRoot_path = "mark/Arrow/translateBtn"
local translate_transIcon_path = "mark/Arrow/translateBtn/btnIcon"
local translate_transFinishIcon_path = "mark/Arrow/translateBtn/FinishIcon"
local time_icon_path = "mark/Arrow/nameBg/timeIcon"
local time_text_path = "mark/Arrow/nameBg/timeIcon/time"
local nameTmp_path = "mark/Arrow/nameBg/nameTmp"
local arrow_path = "mark/Arrow/arrow"
local bubble_path = "mark/Arrow"
local ShowingState = {
  None = 0,
  Origin = 1,
  Translation = 2
}
local ResourceManager = CS.GameEntry.Resource

function AllianceWorldMark:OnCreate(req, startTime)
  if req ~= nil then
    self.request = req
    self.gameObject = req.gameObject
    self.transform = req.gameObject.transform
    self.rendererSorter = req.gameObject:GetComponent(typeof(CS.RendererSorter))
  end
  self.state = ShowingState.None
  self:ComponentDefine()
end

function AllianceWorldMark:Destroy()
  if self.transLoadingReq then
    self.transLoadingReq:Destroy()
    self.transLoadingReq = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  MarkSorter.UnregisterMark(self.markData)
  self:DeleteTimer()
end

function AllianceWorldMark:FinishListener(finishListener)
  self.finishListener = finishListener
end

function AllianceWorldMark:OnClick()
  if self.state == ShowingState.Origin then
    if string.IsNullOrEmpty(self.markData.translateMsg) and not self.markData.isTranslating and self.markData.tanslateFinish ~= 1 then
      if self.transLoadingIcon then
        self.transIcon.gameObject:SetActive(false)
        self.transLoadingIcon.gameObject:SetActive(true)
      end
      self.showTransLoadingIcon = true
      self.markData:DoTranslate()
    else
      self:ShowTranslation(self.markData.translateMsg)
    end
  elseif self.state == ShowingState.Translation then
    self:ShowOrigin()
  end
  self:SetLayout()
end

function AllianceWorldMark:ComponentDefine()
  if not self.componentDefined then
    self.markIcon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
    self.transR4 = self.transform:Find(r4_path)
    self.transBg = self.transform:Find(nameBg_path)
    self.nameBg = self.transBg:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.btnCollider = self.transform:Find(translate_btnCollider_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    
    function self.btnCollider.onPointerClick()
      self:OnClick()
    end
    
    self.transDivideLine = self.transform:Find(translate_divideLine_path).gameObject
    self.transDivideLine:SetActive(false)
    self.bgDivideLine = self.transDivideLine:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.transRoot = self.transform:Find(translate_btnRoot_path).gameObject
    self.transIcon = self.transform:Find(translate_transIcon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.transFinishIcon = self.transform:Find(translate_transFinishIcon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.timeRoot = self.transform:Find(time_icon_path)
    if self.timeRoot then
      self.timeRoot = self.timeRoot.gameObject
    end
    self.textTime = self.transform:Find(time_text_path)
    if self.textTime then
      self.textTime = self.textTime:GetComponent(typeof(CS.TextMeshProEx))
    end
    self.markNameTmp = self.transform:Find(nameTmp_path)
    self.markNameTmp = self.markNameTmp:GetComponent(typeof(CS.TextMeshProEx))
    self.markNameTmp.gameObject:SetActive(true)
    self.showTransLoadingIcon = false
    self.arrowTran = self.transform:Find(arrow_path)
    local request = ResourceManager:InstantiateAsync(UIAssets.MarkTranslateLoading)
    self.transLoadingReq = request
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject:SetActive(self.showTransLoadingIcon)
      self.transLoadingIcon = request.gameObject.transform
      self.transLoadingIcon:SetParent(self.transRoot.transform)
      self.transLoadingIcon.position = self.transIcon.transform.position
      self.transLoadingIcon.localScale = Vector3.New(0.5, 0.5, 0.5)
      self.transLoadingIcon.localRotation = Quaternion.Euler(180, 0, 0)
    end)
    self.bubbleRoot = self.transform:Find(bubble_path)
    if self.bubbleRoot then
      self.bubbleRoot = self.bubbleRoot.gameObject
    end
    self.componentDefined = true
  end
end

function AllianceWorldMark:ShowMark(markData)
  self.markData = markData
  local edgeL = self.markData.pos % 10
  local tempPoint = (self.markData.pos - edgeL) / 10
  local worldPos = BuildingUtils.GetBuildModelCenterVec(tempPoint, 1, 1, ForceChangeScene.World, self.markData.server)
  local v3 = Vector3.New(worldPos.x, worldPos.y, worldPos.z)
  self.transform.position = v3
  local dynamicIcon = DataCenter.WorldFavoDataManager:GetBookMarkDynamicIcon(markData.type)
  if self.markIcon and not string.IsNullOrEmpty(dynamicIcon) then
    local matAsset = ResourceManager:LoadAsset(string.format(MATERIAL_PATH, dynamicIcon), typeof(CS.UnityEngine.Material))
    if not IsNull(matAsset) and not IsNull(matAsset.asset) then
      local newMat = CS.UnityEngine.Material(matAsset.asset)
      self.markIcon.sharedMaterial = newMat
    end
  end
  if self.transR4 then
    local showR4 = markData.viewRank and markData.viewRank >= 4
    self.transR4.gameObject:SetActive(showR4)
  end
  self:ShowText()
  self:SetOrderInLayer()
  self:RefreshBubbleRoot()
  MarkSorter.RegisterMark(markData, worldPos, self.rendererSorter)
end

function AllianceWorldMark:ShowText()
  local markData = self.markData
  if markData == nil or string.IsNullOrEmpty(markData.name) then
    self.state = ShowingState.None
    self.transRoot.gameObject:SetActive(false)
    if self.markNameTmp then
      self.markNameTmp.text = ""
    end
    return
  end
  self.transRoot.gameObject:SetActive(true)
  if string.IsNullOrEmpty(markData:GetTranslationMsg()) and not markData.isTranslating and markData.tanslateFinish ~= 1 then
    self:ShowOrigin()
  else
    self:ShowTranslation()
  end
  self:SetTime()
  self:SetLayout()
end

function AllianceWorldMark:SetLayout()
  if not self.markData then
    return
  end
  local showTime = 0 < (self.markData.startTime or 0) - UITimeManager:GetInstance():GetServerTime()
  local bgWidth = 0
  local bgHeight = 0
  local leftPad = 0.35
  local rightPad = 0.35
  local labelWidth = self.markNameTmp:GetWidth()
  local tranIconPos = Vector3.New(0, 0.4, 0)
  local labelPos = Vector3.New(-0.2, 0, 0)
  local arrowPos = Vector3.New(0, 0, 0)
  bgWidth = labelWidth + leftPad + rightPad
  bgWidth = math.max(1.3, bgWidth)
  tranIconPos.x = labelWidth * 0.5 + 0.1
  if showTime then
    self.transDivideLine:SetActive(true)
    bgHeight = 0.8
    labelPos.y = 0.16
    arrowPos.y = -0.084
  else
    self.transDivideLine:SetActive(false)
    bgHeight = 0.55
    labelPos.y = 0
    arrowPos.y = 0.047
  end
  self.nameBg.size = Vector2.New(bgWidth, bgHeight)
  self.transRoot.transform.localPosition = tranIconPos
  self.markNameTmp.transform.localPosition = labelPos
  self.bgDivideLine.size = Vector2.New(bgWidth - 0.65, 0.02)
  self.arrowTran.transform.localPosition = arrowPos
end

function AllianceWorldMark:ShowOrigin()
  self.state = ShowingState.Origin
  self.transIcon.gameObject:SetActive(true)
  if self.transLoadingIcon then
    self.transLoadingIcon.gameObject:SetActive(false)
  end
  self.showTransLoadingIcon = false
  self.transFinishIcon.gameObject:SetActive(false)
  local markData = self.markData
  local showName
  if markData.type == MarkType.Alliance_rally or markData.type == MarkType.Alliance_OtherServerRally then
    if markData and markData.IsSelfAlliance and markData:IsSelfAlliance() then
      showName = Localization:GetString(markData.type == MarkType.Alliance_rally and 455018 or "s5_allianceflag_name01")
    else
      showName = string.format("[%s] %s", markData.allianceAbbr, markData.allianceName)
    end
  elseif markData and markData.IsSelfAlliance and markData:IsSelfAlliance() then
    showName = markData.name
  else
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(markData.allianceId)
    if data == nil then
      showName = markData.name
    else
      showName = string.format("[%s] %s", data.abbr, markData.name)
    end
  end
  self.markNameTmp.text = showName
  self.markNameTmp.gameObject:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.markNameTmp.transform)
end

function AllianceWorldMark:ShowTranslation()
  self.state = ShowingState.Translation
  if self.transLoadingIcon then
    self.transLoadingIcon.gameObject:SetActive(false)
  end
  self.showTransLoadingIcon = false
  if self.markData.type == MarkType.Alliance_rally or self.markData.type == MarkType.Alliance_OtherServerRally then
    self.markNameTmp.text = Localization:GetString(self.markData.type == MarkType.Alliance_rally and 455018 or "s5_allianceflag_name01")
  else
    self.markNameTmp.text = self.markData:GetTranslationMsg()
  end
  self.markNameTmp.gameObject:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.markNameTmp.transform)
  self.transFinishIcon.gameObject:SetActive(true)
  self.transIcon.gameObject:SetActive(false)
end

function AllianceWorldMark:OnTranslateFinish(markData)
  local data = self.markData
  local translateMsg = markData:GetTranslationMsg()
  if markData and not string.IsNullOrEmpty(translateMsg) and markData.createTime == data.createTime then
    self:ShowTranslation(translateMsg)
    self:SetLayout()
  end
end

function AllianceWorldMark:GetMarkIcon(markType)
  local iconName = DataCenter.WorldFavoDataManager:GetBookMarkIconName(markType)
  return string.format(LoadPath.AllianceMark, iconName)
end

function AllianceWorldMark:SetOrderInLayer()
end

function AllianceWorldMark:GetPosY(type)
  return (type - 4) * 0.6
end

function AllianceWorldMark:SetTime()
  if not self.markData.startTime or self.markData.startTime <= 0 then
    self.timeRoot:SetActive(false)
    return
  end
  self.timeRoot:SetActive(true)
  self:AddTimer()
  self:TimerCallback()
end

function AllianceWorldMark:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerCallback, self, false, false, false)
  end
  self.timer:Start()
end

function AllianceWorldMark:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function AllianceWorldMark:TimerCallback()
  local startTime = self.markData.startTime or 0
  local leftTime = startTime - UITimeManager:GetInstance():GetServerTime()
  if leftTime < 0 then
    self:DeleteTimer()
    self.timeRoot:SetActive(false)
    self:SetLayout()
    return
  end
  self.textTime.text = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
end

function AllianceWorldMark:RefreshBubbleRoot()
  local markType = self.markData.type
  local markData = self.markData
  if AllianceRallyType[markType] then
    local hide = LuaEntry.Player:GetUserSetting(UserSettingKey.ALLIANCE_RALLY_HIDE_TEXT) == "1"
    if markData == nil or string.IsNullOrEmpty(markData.name) then
      self.transRoot.gameObject:SetActive(false)
    else
      self.transRoot.gameObject:SetActive(not hide)
    end
    self.transBg.gameObject:SetActive(not hide)
    self.arrowTran.gameObject:SetActive(not hide)
    if not hide then
      self:SetLayout()
    end
  else
    if markData == nil or string.IsNullOrEmpty(markData.name) then
      self.transRoot.gameObject:SetActive(false)
    else
      self.transRoot.gameObject:SetActive(true)
    end
    self.transBg.gameObject:SetActive(true)
    self.arrowTran.gameObject:SetActive(true)
  end
end

return AllianceWorldMark
