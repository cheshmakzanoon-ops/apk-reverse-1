local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local SeasonSelectLocationDetailsView = BaseClass("SeasonSelectLocationDetailsView", UIBaseView)

function SeasonSelectLocationDetailsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.imgArea = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textOwner = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textOwnerScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textRuleDesc = self.viewSkin:AddComponent(self, UILWScienceDetailDesc, 6)
  self.textStateTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textStateDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.goStateBlue = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.goState = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.textServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnScore = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnScore:SetOnClick(function()
    self:OnBtnScoreClick()
  end)
  self.btnPick = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnPick:SetOnClick(function()
    self:OnBtnPickClick()
  end)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.goTimer = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textHolding = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.btnBlur = self.viewSkin:AddComponent(self, UIButton, 18)
  self.btnBlur:SetOnClick(function()
    self:OnBtnBlurClick()
  end)
  self.goStateRed = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.textOwnerScoreTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.textPick = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  local p_text_center_details_path = "Root/bg/content/top/p_text_center_details"
  self.p_text_center_details = self:AddComponent(UITextMeshProUGUIEx, p_text_center_details_path)
end

function SeasonSelectLocationDetailsView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnClose = nil
  self.imgArea = nil
  self.textOwner = nil
  self.textOwnerScore = nil
  self.textRuleDesc = nil
  self.textStateTitle = nil
  self.textStateDesc = nil
  self.goStateBlue = nil
  self.goState = nil
  self.textServer = nil
  self.textScore = nil
  self.btnScore = nil
  self.btnPick = nil
  self.textTime = nil
  self.goTimer = nil
  self.textHolding = nil
  self.btnBlur = nil
  self.goStateRed = nil
  self.textOwnerScoreTitle = nil
  self.textPick = nil
  self.p_text_center_details = nil
end

function SeasonSelectLocationDetailsView:DataDefine()
end

function SeasonSelectLocationDetailsView:DataDestroy()
  self.Data = nil
end

function SeasonSelectLocationDetailsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self:ReInit(param)
end

function SeasonSelectLocationDetailsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationDetailsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
end

function SeasonSelectLocationDetailsView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectLocationPosDataUpdate, self.OnPosDataUpdate)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationDetailsView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonSelectLocationDetailsView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.SkinCell = data.WorldSkinCell
    return self.SkinCell ~= nil
  end
  return false
end

function SeasonSelectLocationDetailsView:InitUi()
  self.imgArea:LoadSpriteAsync(self.SkinCell.location_icon)
  self.textRuleDesc:SetLocalText(self.SkinCell.location_info)
  self.textTitle:SetLocalText("zone_selection_location_UI_8", CS.GameEntry.Localization:GetString(self.SkinCell.aliases))
  self.textOwnerScoreTitle:SetLocalText(self.SkinCell.aliases)
  self.textOwnerScoreTitle:SetActive(true)
end

function SeasonSelectLocationDetailsView:UpdateData()
  self.TickAct = false
  self.OwnerInfo = DataCenter.SeasonSelectLocationManager:GetPosData(self.Data.Pos)
  self.MyInfo = DataCenter.SeasonSelectLocationManager:GetMyData()
  return self.MyInfo ~= nil
end

function SeasonSelectLocationDetailsView:UpdateUi()
  local isCenter = self:IsCenter()
  self.goState:SetActive(not isCenter)
  self.p_text_center_details:SetActive(isCenter)
  self.TickAct = false
  local tryTick = false
  self.textOwnerScore:SetActive(false)
  self.goStateRed:SetActive(false)
  self.goStateBlue:SetActive(false)
  if isCenter then
    self.textOwner:SetLocalText("zone_selection_location_UI_35")
    self.p_text_center_details:SetLocalText("zone_selection_location_UI_44")
  else
    if self.OwnerInfo == nil then
      self.textOwner:SetLocalText("zone_selection_location_UI_35")
      self.goStateBlue:SetActive(true)
      self.textStateTitle:SetText(self:GetBlueText("zone_selection_location_UI_13"))
      self.textStateDesc:SetText(self:GetBlueText("zone_selection_location_UI_15"))
      tryTick = true
      self.textHolding:SetActive(false)
      self.btnPick:SetActive(true)
      self.textPick:SetLocalText("zone_selection_location_UI_18")
    else
      self.textOwner:SetText("#" .. self.OwnerInfo.ServerId)
      if self.MyInfo.ServerId == self.OwnerInfo.ServerId then
        self.textHolding:SetActive(true)
        self.goStateBlue:SetActive(true)
        self.btnPick:SetActive(false)
        self.textStateTitle:SetText(self:GetBlueText("zone_selection_location_UI_14"))
        self.textStateDesc:SetText(self:GetBlueText("zone_selection_location_UI_45"))
      else
        tryTick = true
        self.textHolding:SetActive(false)
        self.btnPick:SetActive(true)
        self.textPick:SetLocalText("zone_selection_location_UI_19")
        self.textOwnerScore:SetActive(true)
        self.textOwnerScore:SetLocalText("zone_selection_location_UI_49", string.GetFormattedSeparatorNum(self.OwnerInfo.Score))
        if self:CanPlace(self.MyInfo, self.OwnerInfo) then
          self.goStateBlue:SetActive(true)
          self.textStateTitle:SetText(self:GetBlueText("zone_selection_location_UI_14"))
          self.textStateDesc:SetText(self:GetBlueText("zone_selection_location_UI_16"))
        else
          self.goStateRed:SetActive(true)
          self.textStateTitle:SetText(self:GetRedText("zone_selection_location_UI_14"))
          self.textStateDesc:SetText(self:GetRedText("zone_selection_location_UI_17"))
        end
      end
    end
    if checknumber(self.MyInfo.Pos) <= 0 then
      self.textServer:SetLocalText("zone_selection_location_UI_5", string.format("#%s", LuaEntry.Player.serverId))
    else
      local areaName = ""
      local skinCell = DataCenter.SeasonSelectLocationManager:GetWorldSkinCell(self.MyInfo.Pos)
      if skinCell ~= nil then
        areaName = CS.GameEntry.Localization:GetString(skinCell.aliases)
      end
      self.textServer:SetLocalText("zone_selection_location_UI_6", string.format("#%s", LuaEntry.Player.serverId), areaName)
    end
    if not DataCenter.SeasonSelectLocationManager:IsSelectStage() then
      self.btnPick:SetActive(false)
      self.textStateTitle:SetText(self:GetBlueText("zone_selection_location_UI_46"))
      self.textStateDesc:SetText(self:GetBlueText("zone_selection_location_UI_47"))
    end
    self.textScore:SetLocalText("zone_selection_location_UI_11", string.GetFormattedSeparatorNum(self.MyInfo.Score))
  end
  if tryTick then
    local isCdValid, nextTime = DataCenter.SeasonSelectLocationManager:IsCdValid()
    if not isCdValid and nextTime < LongMaxValue then
      self.TickAct = true
    end
  end
  self.goTimer:SetActive(self.TickAct)
  self:Update1000MS()
end

function SeasonSelectLocationDetailsView:CanPlace(myInfo, otherInfo)
  if otherInfo == nil or otherInfo.Score <= 0 then
    return true
  end
  if myInfo.Score > otherInfo.Score or myInfo.Score == otherInfo.Score and myInfo.Time > otherInfo.Time then
    return false
  end
  return true
end

function SeasonSelectLocationDetailsView:IsCenter()
  return self.Data ~= nil and self.Data.Pos == 5
end

function SeasonSelectLocationDetailsView:Update1000MS()
  if not self.TickAct then
    return
  end
  local nextSetTime = DataCenter.SeasonSelectLocationManager:GetNextSetTime()
  local leftTime = nextSetTime - UITimeManager:GetInstance():GetServerSeconds()
  if leftTime == 0 and self:UpdateData() then
    self:UpdateUi()
  end
  if 0 < leftTime and leftTime < OneWeekTime then
    self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(leftTime))
  end
end

function SeasonSelectLocationDetailsView:GetRedText(text)
  return self:GetColorText("#D24641", text)
end

function SeasonSelectLocationDetailsView:GetBlueText(text)
  return self:GetColorText("#1F96CD", text)
end

function SeasonSelectLocationDetailsView:GetColorText(color, text)
  return "<color=" .. color .. ">" .. CS.GameEntry.Localization:GetString(text) .. "</color>"
end

function SeasonSelectLocationDetailsView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonSelectLocationDetailsView:OnBtnScoreClick()
end

function SeasonSelectLocationDetailsView:OnBtnPickClick()
  if self.Data ~= nil then
    DataCenter.SeasonSelectLocationManager:SendSetPos(self.Data.Pos)
  end
end

function SeasonSelectLocationDetailsView:OnPosDataUpdate(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonSelectLocationDetailsView:OnBtnBlurClick()
  self.ctrl:CloseSelf()
end

return SeasonSelectLocationDetailsView
