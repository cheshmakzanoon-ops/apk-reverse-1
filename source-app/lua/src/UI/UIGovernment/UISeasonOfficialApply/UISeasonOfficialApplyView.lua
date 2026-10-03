local base = UIBaseView
local UISeasonOfficialApplyView = BaseClass("UISeasonOfficialApplyView", base)
local UISeasonOfficialApplyPlayerPanel = require("UI.UIGovernment.UISeasonOfficialApply.UISeasonOfficialApplyPlayerPanel")
local UISeasonOfficialApplyEffectPanel = require("UI.UIGovernment.UISeasonOfficialApply.UISeasonOfficialApplyEffectPanel")
local titleTxt_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local rightBtn_path = "Root/Content/ContentHolder/InfoPanel/RightBtn"
local leftBtn_path = "Root/Content/ContentHolder/InfoPanel/LeftBtn"
local officialPanel_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel"
local officialIcon_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel/Officialcon"
local noPlayerText_path = "Root/Content/ContentHolder/InfoPanel/OfficialPanel/NoPlayerText"
local playerPanel_path = "Root/Content/ContentHolder/InfoPanel/PlayerPanel"
local nonePanel_path = "Root/Content/ContentHolder/AutoPanel/ScrollView/NonePanel"
local noneTipText_path = "Root/Content/ContentHolder/AutoPanel/ScrollView/NonePanel/NoneTipText"
local logBtn_path = "Root/Content/ContentHolder/DownPanel/LogBtn"
local logBtnText_path = "Root/Content/ContentHolder/DownPanel/LogBtn/LogBtnText"
local tipText_path = "Root/Content/ContentHolder/DownPanel/TipText"
local closePanel_path = "Panel"
local setBtn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/SetBtn"
local removeBtn_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/RemoveBtn"
local setBtnText_path = "Root/Content/ContentHolder/DownPanel/BtnPanel/SetBtn/SetBtnText"
local effectPanel_path = "Root/Content/ContentHolder/AutoPanel/EffectPanel"
local downPanel_path = "Root/Content/ContentHolder/DownPanel"
local red_dot_without_num_path = "Root/Content/ContentHolder/DownPanel/ListBtn/RedDotWithoutNum"

function UISeasonOfficialApplyView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

function UISeasonOfficialApplyView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialApplyView:OnEnable()
  base.OnEnable(self)
end

function UISeasonOfficialApplyView:OnDisable()
  base.OnDisable(self)
end

function UISeasonOfficialApplyView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, titleTxt_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.rightBtn = self:AddComponent(UIButton, rightBtn_path)
  self.leftBtn = self:AddComponent(UIButton, leftBtn_path)
  self.officialPanel = self:AddComponent(UIBaseContainer, officialPanel_path)
  self.officialIcon = self:AddComponent(UIImage, officialIcon_path)
  self.noPlayerText = self:AddComponent(UIText, noPlayerText_path)
  self.playerPanel = self:AddComponent(UISeasonOfficialApplyPlayerPanel, playerPanel_path)
  self.nonePanel = self:AddComponent(UIBaseContainer, nonePanel_path)
  self.noneTipText = self:AddComponent(UIText, noneTipText_path)
  self.logBtn = self:AddComponent(UIButton, logBtn_path)
  self.logBtnText = self:AddComponent(UIText, logBtnText_path)
  self.tipText = self:AddComponent(UIText, tipText_path)
  self.tipText:SetActive(false)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.setBtn = self:AddComponent(UIButton, setBtn_path)
  self.removeBtn = self:AddComponent(UIButton, removeBtn_path)
  self.setBtnText = self:AddComponent(UIText, setBtnText_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.rightBtn:SetOnClick(BindCallback(self, self.OnChangePosition, true))
  self.leftBtn:SetOnClick(BindCallback(self, self.OnChangePosition, false))
  self.logBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialHistory, {anim = true}, self.serverId, self.buildingId, self.config)
  end)
  self.effectPanel = self:AddComponent(UISeasonOfficialApplyEffectPanel, effectPanel_path)
  self.setBtn:SetOnClick(function()
    if self:IsInAppointTimeCD() then
      UIUtil.ShowTipsId(457059)
      return
    end
    if not LuaEntry.Player:IsBuildingLeader(self.serverId, self.buildingId) then
      UIUtil.ShowTipsId(393018)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialSelectMember, self.serverId, self.buildingId, self.config)
  end)
  self.removeBtn:SetOnClick(function()
    if not LuaEntry.Player:IsBuildingLeader(self.serverId, self.buildingId) then
      UIUtil.ShowTipsId(393018)
      return
    end
    DataCenter.BuildingOfficialManager:TryKingdomPositionAppoint(self.serverId, self.buildingId, self.config, self.info)
  end)
  self.playerPanel:SetActive(false)
  self.downPanel = self:AddComponent(UIBaseContainer, downPanel_path)
  self.red_dot_without_num = self:AddComponent(UIBaseContainer, red_dot_without_num_path)
end

function UISeasonOfficialApplyView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.rightBtn = nil
  self.leftBtn = nil
  self.officialPanel = nil
  self.officialIcon = nil
  self.noPlayerText = nil
  self.playerPanel = nil
  self.nonePanel = nil
  self.noneTipText = nil
  self.logBtn = nil
  self.logBtnText = nil
  self.tipText = nil
  self.closePanel = nil
  self.setBtn = nil
  self.removeBtn = nil
  self.setBtnText = nil
  self.effectPanel = nil
  self.red_dot_without_num = nil
end

function UISeasonOfficialApplyView:DataDefine()
  self.serverId, self.buildingId, self.config = self:GetUserData()
end

function UISeasonOfficialApplyView:DataDestroy()
  self.config = nil
  self.theCD = nil
  self.serverId = nil
end

function UISeasonOfficialApplyView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionList, self.RefreshAll)
end

function UISeasonOfficialApplyView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionList, self.RefreshAll)
  base.OnRemoveListener(self)
end

function UISeasonOfficialApplyView:RefreshAll()
  self.info = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId, self.config.id)
  self:RefreshPlayerPanel()
  self:RefreshDownPanel()
end

function UISeasonOfficialApplyView:RefreshPlayerPanel()
  local template = self.config
  self.titleTxt:SetLocalText(template.name)
  local positionInfo = self.info
  if positionInfo and positionInfo.uid ~= nil and positionInfo.uid ~= "" then
    self.playerPanel:SetActive(true)
    self.officialPanel:SetActive(false)
    self.playerPanel:SetData(positionInfo)
  else
    self.playerPanel:SetActive(false)
    self.officialPanel:SetActive(true)
    self.officialIcon:LoadSprite(self.config.icon)
    self.officialIcon:SetNativeSize()
  end
  self.effectPanel:SetData(self.config.id)
end

function UISeasonOfficialApplyView:RefreshDownPanel()
  self.setBtn:SetActive(false)
  self.removeBtn:SetActive(false)
  local isLeader = LuaEntry.Player:IsBuildingLeader(self.serverId, self.buildingId)
  if isLeader then
    self.setBtn:SetActive(true)
    local positionInfo = self.info
    if positionInfo then
      if positionInfo.uid ~= nil and positionInfo.uid ~= "" then
        self.removeBtn:SetActive(true)
      else
        self.removeBtn:SetActive(false)
      end
      self.theCD = positionInfo:GetAppointTimeCD()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      self.theCD = self.theCD - curTime
    else
      self.theCD = 0
    end
    if not self:IsInAppointTimeCD() then
      CS.UIGray.SetGray(self.setBtn.transform, false, true)
      self.setBtnText:SetLocalText(457093)
    else
      CS.UIGray.SetGray(self.setBtn.transform, true, true)
      self.setBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.theCD))
    end
  end
end

function UISeasonOfficialApplyView:Update1000MS()
  local deltaTime = 1000
  if self.theCD ~= nil and self.theCD > 0 then
    self.theCD = self.theCD - deltaTime
    if self.theCD > 0 then
      self.setBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.theCD))
    else
      self.theCD = 0
      self:RefreshDownPanel()
    end
  end
end

function UISeasonOfficialApplyView:OnChangePosition(isAdd)
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
  local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(self.config.type, seasonSubType)
  local list = {}
  if LuaEntry.Player:IsDeepLeader(self.serverId, self.buildingId) then
    list = templates
  else
    for _, v in ipairs(templates) do
      if v.order > 0 then
        table.insert(list, v)
      end
    end
  end
  local index = 1
  for i, value in ipairs(list) do
    if value.id == self.config.id then
      index = i
      break
    end
  end
  if isAdd then
    index = index + 1
    if index > #list then
      index = 1
    end
  else
    index = index - 1
    if index <= 0 then
      index = #list
    end
  end
  self.config = list[index]
  self:RefreshAll()
end

function UISeasonOfficialApplyView:IsInAppointTimeCD()
  return self.theCD ~= nil and self.theCD > 0
end

return UISeasonOfficialApplyView
