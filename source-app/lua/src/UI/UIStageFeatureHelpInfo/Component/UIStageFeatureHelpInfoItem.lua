local UIStageFeatureHelpInfoItem = BaseClass("UIStageFeatureHelpInfoItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TabType = {HelpToMe = 1, HelpFromMe = 2}
local bgPath = {
  [TabType.HelpToMe] = "Assets/Main/Sprites/UI/LWUIStageFeatureChapter/wxy_qianxian_yaoqing_duifangfenxiangdi.png",
  [TabType.HelpFromMe] = "Assets/Main/Sprites/UI/LWUIStageFeatureChapter/wxy_qianxian_yaoqing_wofenxiangdi.png"
}

function UIStageFeatureHelpInfoItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIStageFeatureHelpInfoItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStageFeatureHelpInfoItem:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "bg")
  self.head = self:AddComponent(UICommonHead, "head")
  self.emptyHead = self:AddComponent(UIImage, "emptyHead")
  self.txtName = self:AddComponent(UITextMeshProUGUIEx, "txtName")
  self.btnHead = self:AddComponent(UIButton, "btnHead")
  self.btnGo = self:AddComponent(UIButton, "btnGo")
  self.txtBtnGo = self:AddComponent(UITextMeshProUGUIEx, "btnGo/btnGoText")
  self.btnAccept = self:AddComponent(UIButton, "btnAccept")
  self.txtBtnAccept = self:AddComponent(UITextMeshProUGUIEx, "btnAccept/btnAcceptText")
  self.imgComplete = self:AddComponent(UIImage, "imgComplete")
  self.txtComplete = self:AddComponent(UITextMeshProUGUIEx, "imgComplete/txtComplete")
  self.txtExpired = self:AddComponent(UITextMeshProUGUIEx, "txtExpired")
  self.txtDate = self:AddComponent(UITextMeshProUGUIEx, "txtDate")
  self.txtCountDown = self:AddComponent(UITextMeshProUGUIEx, "txtCountDown")
  self.txtDesc = self:AddComponent(UITextMeshProUGUIEx, "txtDesc")
  self.btnHead:SetOnClick(function()
    if self.data and self.userData and self.userData.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.userData.uid)
    end
  end)
  self.btnGo:SetOnClick(function()
    self:OnClickBtnGo()
  end)
  self.btnAccept:SetOnClick(function()
    self:OnClickBtnAccept()
  end)
end

function UIStageFeatureHelpInfoItem:ComponentDestroy()
  self.bg = nil
  self.head = nil
  self.txtName = nil
  self.btnHead = nil
  self.btnGo = nil
  self.txtBtnGo = nil
  self.btnAccept = nil
  self.txtBtnAccept = nil
  self.imgComplete = nil
  self.txtComplete = nil
  self.txtExpired = nil
  self.txtDate = nil
  self.txtCountDown = nil
  self.txtDesc = nil
end

function UIStageFeatureHelpInfoItem:Refresh(data, tabType)
  if not data then
    Logger.LogError("UIStageFeatureHelpInfoItem Refresh data is nil")
    return
  end
  self.data = data
  self.userData = data.user
  self.tabType = tabType
  if self.userData then
    self.emptyHead:SetActive(false)
    self.head:SetActive(true)
    self.head:SetData(self.userData.uid, self.userData.headPic, self.userData.headPicVer)
    local name = self.userData.name
    name = UIUtil.FormatAllianceAndName(self.userData.abbr, self.userData.name, self.userData.uid)
    self.txtName:SetText(name)
  else
    self.emptyHead:SetActive(true)
    self.head:SetActive(false)
    self.txtName:SetLocalText("frontline_help_message_17")
  end
  self.txtExpired:SetLocalText("frontline_help_message_13")
  local levelName = DataCenter.LWStageFeatureChapterManager:GetStageFeatureName(data.stageId)
  self.txtDesc:SetText(levelName)
  self.txtDate:SetText(UITimeManager:GetInstance():TimeStampToMDHSForLocalMinute(self.data.startTime))
  if self.tabType == TabType.HelpToMe then
    self.bg:LoadSprite(bgPath[TabType.HelpToMe])
  else
    self.bg:LoadSprite(bgPath[TabType.HelpFromMe])
  end
  self:RefreshItemState()
  if self.data.state == StageFeatureHelpInfoState.Expire then
    self.txtCountDown:SetLocalText("frontline_help_message_09")
  end
  self:SetCountDown()
end

function UIStageFeatureHelpInfoItem:RefreshItemState()
  local state = self.data.state
  if state == StageFeatureHelpInfoState.Complete then
    if self.tabType == TabType.HelpToMe then
      self.btnAccept:SetActive(false)
      self.imgComplete:SetActive(true)
    else
      self.btnAccept:SetActive(true)
      self.imgComplete:SetActive(false)
    end
    self.btnGo:SetActive(false)
    self.txtComplete:SetLocalText("frontline_help_message_12")
    self.txtExpired:SetActive(false)
  else
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.data.endTime
    local isExpired = curTime > endTime
    if isExpired and state ~= StageFeatureHelpInfoState.AcceptResult then
      self.data.state = StageFeatureHelpInfoState.Expire
      self.btnGo:SetActive(false)
      self.btnAccept:SetActive(false)
      self.imgComplete:SetActive(false)
      self.txtExpired:SetActive(true)
      self.bg:LoadSprite("Assets/Main/Sprites/UI/LWUIStageFeatureChapter/wxy_qianxian_yaoqing_huidi.png")
    elseif state == StageFeatureHelpInfoState.None then
      if self.tabType == TabType.HelpToMe then
        self.btnAccept:SetActive(true)
      else
        self.btnAccept:SetActive(false)
      end
      self.btnGo:SetActive(false)
      self.imgComplete:SetActive(false)
      self.txtExpired:SetActive(false)
    elseif state == StageFeatureHelpInfoState.AcceptInvite then
      if self.tabType == TabType.HelpToMe then
        self.btnGo:SetActive(true)
        self.imgComplete:SetActive(false)
      else
        self.btnGo:SetActive(false)
        self.imgComplete:SetActive(true)
        self.txtComplete:SetLocalText("frontline_help_message_16")
      end
      self.btnAccept:SetActive(false)
      self.txtExpired:SetActive(false)
    elseif state == StageFeatureHelpInfoState.AcceptResult then
      self.btnGo:SetActive(false)
      self.btnAccept:SetActive(false)
      self.imgComplete:SetActive(true)
      self.txtComplete:SetLocalText("frontline_help_message_12")
      self.txtExpired:SetActive(false)
    end
  end
end

function UIStageFeatureHelpInfoItem:Update1000MS()
  if not self.data then
    return
  end
  self:SetCountDown()
end

function UIStageFeatureHelpInfoItem:SetCountDown()
  if not self.data then
    return
  end
  local state = self.data.state
  if self.data.state == StageFeatureHelpInfoState.Expire then
    return
  end
  if self.tabType == TabType.HelpToMe and state == StageFeatureHelpInfoState.Complete then
    return
  end
  if self.tabType == TabType.HelpFromMe and state == StageFeatureHelpInfoState.AcceptResult then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.data.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.txtCountDown:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.data.state = StageFeatureHelpInfoState.Expire
    self.txtCountDown:SetLocalText("frontline_help_message_09")
    self:RefreshItemState()
  end
end

function UIStageFeatureHelpInfoItem:OnClickBtnGo()
  if not self.data then
    return
  end
  DataCenter.LWStageFeatureChapterManager:GoToHelp(self.data.uuid, self.data.stageId)
end

function UIStageFeatureHelpInfoItem:OnClickBtnAccept()
  if not self.data then
    return
  end
  local param = {}
  param.uuid = self.data.uuid
  param.stageId = self.data.stageId
  param.endTime = self.data.endTime
  param.senderInfo = self.userData
  param.fromList = true
  if self.tabType == TabType.HelpToMe then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpInvite, {anim = false}, param)
  else
    param.soldierNum = self.data.soldier
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStageFeatureHelpResult, {anim = false}, param)
  end
end

return UIStageFeatureHelpInfoItem
