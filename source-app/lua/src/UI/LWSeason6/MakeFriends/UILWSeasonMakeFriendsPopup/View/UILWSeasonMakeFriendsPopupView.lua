local UILWSeasonMakeFriendsPopupView = BaseClass("UILWSeasonMakeFriendsPopupView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Content/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local content_path = "PopUpTitle/Content"
local txt1_path = "PopUpTitle/Content/Txt1"
local txt2_path = "PopUpTitle/Content/Txt2"
local btn_path = "PopUpTitle/Btn"
local my_alli_path = "PopUpTitle/Content/alliances/MyAlli"
local my_alli_name_path = "PopUpTitle/Content/alliances/MyAlli/MyAlliName"
local other_alli_path = "PopUpTitle/Content/alliances/OtherAlli"
local other_alli_name_path = "PopUpTitle/Content/alliances/OtherAlli/OtherAlliName"

function UILWSeasonMakeFriendsPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.allyAllianceId = DataCenter.SeasonAllyFriendManager:GetFriendAllyId()
  if self.allyAllianceId ~= nil and self.allyAllianceId ~= "" then
    local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, self.allyAllianceId)
    else
      self.allianceInfo = allianceInfo
      self:UpdateData()
    end
  end
end

function UILWSeasonMakeFriendsPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsPopupView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("s6_alliance_ally_tittle05")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.txt1 = self:AddComponent(UITextMeshProUGUIEx, txt1_path)
  self.txt2 = self:AddComponent(UITextMeshProUGUIEx, txt2_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.my_alli = self:AddComponent(UIButton, my_alli_path)
  self.my_alli_name = self:AddComponent(UITextMeshProUGUIEx, my_alli_name_path)
  self.other_alli = self:AddComponent(UIButton, other_alli_path)
  self.other_alli_name = self:AddComponent(UITextMeshProUGUIEx, other_alli_name_path)
  self.my_alli:SetOnClick(function()
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil and data.abbr ~= nil then
      UIUtil.TryShowAllianceInfo(data.createServer or data.ownerServerId, data.uid)
    end
  end)
  self.other_alli:SetOnClick(function()
    local data = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if data ~= nil then
      UIUtil.TryShowAllianceInfo(data.createServer or data.ownerServerId, data.uid)
    end
  end)
end

function UILWSeasonMakeFriendsPopupView:ComponentDestroy()
  self.btn_back = nil
  self.content = nil
  self.txt1 = nil
  self.txt2 = nil
  self.btn = nil
  self.my_alli = nil
  self.my_alli_name = nil
  self.other_alli = nil
  self.other_alli_name = nil
end

function UILWSeasonMakeFriendsPopupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  self:UpdateData()
end

function UILWSeasonMakeFriendsPopupView:OnRemoveListener()
  self:RemoveUIListener(EventId.SearchAllianceSuccess, self.UpdateData)
  base.OnRemoveListener(self)
end

function UILWSeasonMakeFriendsPopupView:UpdateData()
  local allianceInfo = self.allianceInfo
  if allianceInfo == nil then
    allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allyAllianceId)
    if allianceInfo == nil then
      return
    end
    self.allianceInfo = allianceInfo
  end
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data == nil or data.abbr == nil then
    return
  end
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local factionName = factionMgr:GetCampName(factionMgr.myCampId)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local name1 = UIUtil.FormatServerAllianceName(mySourceServerId, data.abbr, nil)
  local name2 = UIUtil.FormatServerAllianceName(allianceInfo.createServer or allianceInfo.ownerServerId, allianceInfo.abbr, nil)
  self.txt1:SetLocalText("s6_alliance_ally_desc33", name1, name2)
  self.txt2:SetLocalText("s6_alliance_ally_desc34", factionName)
  self.my_alli_name:SetText(name1)
  self.other_alli_name:SetText(name2)
  self.my_alli:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  self.other_alli:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, allianceInfo.icon))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt1.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt2.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UILWSeasonMakeFriendsPopupView:OnBtnClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMakeFriendsMainUI, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

return UILWSeasonMakeFriendsPopupView
