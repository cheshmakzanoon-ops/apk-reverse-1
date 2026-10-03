local p_btn_blur_path = "p_btn_blur"
local p_comp_state_path = "Root/ImgBg/Content/p_comp_state"
local text_name_path = "Root/ImgBg/img_title_bg/titleRoot/text_name"
local text_title_path = "Root/ImgBg/img_title_bg/titleRoot/text_title"
local title_root_path = "Root/ImgBg/img_title_bg/titleRoot"
local UILWSeasonAllianceWarTimeStateComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/UILWSeasonAllianceWarTimeStateComp")
local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local SeasonAllianceWarTimeStateTipsView = BaseClass("SeasonAllianceWarTimeStateTipsView", base)

function SeasonAllianceWarTimeStateTipsView:ComponentDefine()
  base.ComponentDefine(self)
  self.p_comp_state = self:AddComponent(UILWSeasonAllianceWarTimeStateComp, p_comp_state_path)
  self.text_name = self:AddComponent(UITextMeshProUGUIEx, text_name_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_name:SetActive(false)
  self.title_root = self:AddComponent(UIButton, title_root_path)
  self.title_root:SetOnClick(function()
    if not string.IsNullOrEmpty(self.allianceId) then
      local main = UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceDetail)
      if main ~= nil and main.View ~= nil and main.View.allianceId == self.allianceId then
        return
      end
      UIUtil.TryShowAllianceInfo(self.serverId, self.allianceId, nil)
      UIManager:GetInstance():DestroyWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView)
    end
  end)
end

function SeasonAllianceWarTimeStateTipsView:ComponentDestroy()
  self.p_comp_state = nil
  self.title_root = nil
  self.text_name = nil
  self.text_title = nil
  base.ComponentDestroy(self)
end

function SeasonAllianceWarTimeStateTipsView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.OnAllianceInfoFetch)
  self:OnAllianceInfoFetch(false)
end

function SeasonAllianceWarTimeStateTipsView:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.OnAllianceInfoFetch)
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeStateTipsView:OnAllianceInfoFetch(fetchWhenNotExist)
  if string.IsNullOrEmpty(self.allianceId) then
    self.text_name:SetText("")
    self.text_name:SetActive(false)
  elseif self.allianceId == LuaEntry.Player.allianceId then
    local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceInfo ~= nil and allianceInfo.abbr ~= nil and allianceInfo.abbr ~= "" then
      self.text_name:SetText("<u>" .. allianceInfo:GetBaseName() .. "</u>")
      self.text_name:SetActive(true)
    end
  else
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceId)
    if allianceInfo == nil then
      if fetchWhenNotExist == true then
        SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allianceId)
      end
      self.text_name:SetText("")
      self.text_name:SetActive(false)
    else
      self.text_name:SetText("<u>" .. allianceInfo:GetBaseName() .. "</u>")
      self.text_name:SetActive(true)
    end
  end
end

function SeasonAllianceWarTimeStateTipsView:RefreshShow()
  self:ReInit(self:GetUserData())
end

function SeasonAllianceWarTimeStateTipsView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonAllianceWarTimeStateTipsView:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonAllianceWarTimeStateTipsView:InitUi()
  local data = {}
  data.TimeIndex = self.Data.TimeIndex
  data.SetTime = 0
  data.PreviewMode = true
  self.p_comp_state:ReInit(data)
  self.allianceId = self.Data.allianceId
  self:OnAllianceInfoFetch(true)
end

return SeasonAllianceWarTimeStateTipsView
