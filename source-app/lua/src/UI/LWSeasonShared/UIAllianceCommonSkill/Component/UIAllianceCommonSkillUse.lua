local base = UIBaseContainer
local UIAllianceCommonSkillUse = BaseClass("UIAllianceCommonSkillUse", base)
local AllianceUseSkillItemView = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.AllianceUseSkillItemView")
local btn_CommonButton_path = "BottomBar/SkillHistoryBtn"
local btn_UIPlayerHead_path = "UserInfo/Player/UIPlayerHead"
local txt_level_path = "UserInfo/Info/PlayerLevel"
local txt_alliance_path = "UserInfo/Info/PlayerName"
local txt_power_path = "UserInfo/Player/Power/Bg/PowerText"
local txt_desc_path = "UserInfo/Info/desc/DescText"
local go_Content_path = "UICommonScrollViewVertical/Viewport/Content"
local txt_title_tip_path = "UICommonScrollViewVertical/title/txt_title_tip"
local btn_Power_path = "UserInfo/Player/Power"
local go_speak_content_path = "UserInfo/Info/desc"
local img_icon_path = "UserInfo/Player/img_kuang/icon"
local img_kuang_path = "UserInfo/Player/img_kuang"
local go_ItemSkill_path = "UICommonScrollViewVertical/Viewport/ItemSkill"
local sr_UICommonScrollViewVertical_path = "UICommonScrollViewVertical"

function UIAllianceCommonSkillUse:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceCommonSkillUse:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillUse:ComponentDefine()
  self.btn_CommonButton = self:AddComponent(UIButton, btn_CommonButton_path)
  self.btn_UIPlayerHead = self:AddComponent(UIBaseContainer, btn_UIPlayerHead_path)
  self.txt_level = self:AddComponent(UIText, txt_level_path)
  self.txt_alliance = self:AddComponent(UIText, txt_alliance_path)
  self.txt_power = self:AddComponent(UIText, txt_power_path)
  self.txt_desc = self:AddComponent(UIText, txt_desc_path)
  self.txt_title_tip = self:AddComponent(UIText, txt_title_tip_path)
  self.btn_Power = self:AddComponent(UIButton, btn_Power_path)
  self.go_speak_content = self:AddComponent(UIBaseContainer, go_speak_content_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_kuang = self:AddComponent(UIImage, img_kuang_path)
  self.go_ItemSkill = self:AddComponent(UIBaseContainer, go_ItemSkill_path)
  self.sr_UICommonScrollViewVertical = self:AddComponent(UIScrollRect, sr_UICommonScrollViewVertical_path)
  self.btn_UIPlayerHead = self:AddComponent(UICommonHead, btn_UIPlayerHead_path)
  self.btn_UIPlayerHead:SetEnableClickShowInfo(true, true)
  self.go_Content = self:AddComponent(UIGameObjectPoolRoot, go_Content_path)
  self.go_Content:Init(self.go_ItemSkill.gameObject, AllianceUseSkillItemView)
  self.btn_CommonButton:SetOnClick(BindCallback(self, self.ClickRecord))
end

function UIAllianceCommonSkillUse:ComponentDestroy()
  self.btn_CommonButton = nil
  self.btn_UIPlayerHead = nil
  self.txt_level = nil
  self.txt_alliance = nil
  self.txt_power = nil
  self.txt_desc = nil
  self.go_Content = nil
  self.txt_title_tip = nil
  self.btn_Power = nil
  self.go_speak_content = nil
  self.img_icon = nil
  self.img_kuang = nil
  self.go_ItemSkill = nil
  self.sr_UICommonScrollViewVertical = nil
end

function UIAllianceCommonSkillUse:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceSkillReleaseSuccess, self.OnReleaseSuccess)
end

function UIAllianceCommonSkillUse:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceSkillReleaseSuccess, self.OnReleaseSuccess)
  base.OnRemoveListener(self)
end

function UIAllianceCommonSkillUse:ClickRecord()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillRecord, {anim = true}, self.type)
end

function UIAllianceCommonSkillUse:ReInit(type, gotoSkillId)
  self.type = type
  self:RefreshList()
  self:RefreshUser()
  self:GoToSkillId(gotoSkillId)
end

function UIAllianceCommonSkillUse:GoToSkillId(gotoSkillId)
  local gotoIndex = 1
  if self.showDataList then
    for index, v in ipairs(self.showDataList) do
      if v.skillId == gotoSkillId then
        gotoIndex = index
      end
    end
  end
  self.go_Content:SetAnchoredPositionXY(0, 0)
  self.go_Content:SetAnchoredPositionXY(0, gotoIndex == 1 and 0 or 750)
end

function UIAllianceCommonSkillUse:RefreshList()
  local tabInfo = self.holder.view:GetCurToggleInfo()
  self.showDataList = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillListByType(tabInfo.type)
  self.go_Content:Clear()
  for _, v in ipairs(self.showDataList) do
    self.go_Content:AddData(v)
  end
  self.go_Content:Show()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_Content.transform)
end

function UIAllianceCommonSkillUse:RefreshUser()
  local user = #self.showDataList > 0 and self.showDataList[1]:GetUser() or nil
  if user then
    self.txt_level:SetLocalText(140002, user.level)
    self.txt_alliance:SetText("[" .. user.abbr .. "]" .. user.name)
    self.txt_power:SetText(string.GetFormattedSpecial(user.power))
    local headFrame = DataCenter.DecorationDataManager:GetHeadFrame(user.headSkinId, user.headSkinET, false)
    self.btn_UIPlayerHead:SetHead(user.uid, user.headPic, user.headPicVer, nil, headFrame)
  else
    self.txt_alliance:SetLocalText("457033")
  end
  self.btn_UIPlayerHead:SetActive(user ~= nil)
  self.btn_Power:SetActive(user ~= nil)
  self.txt_level:SetActive(user ~= nil)
  self.img_kuang:SetActive(user == nil)
  local tabInfo = self.holder.view:GetCurToggleInfo()
  self.txt_desc:SetLocalText(tabInfo.desc)
  self.txt_title_tip:SetLocalText(tabInfo.name)
  if self.showDataList[1] ~= nil then
    self.img_icon:LoadSpriteAuto(LWAlMemberOffcialParam[self.showDataList[1].config.type].Icon)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.go_speak_content.transform)
end

function UIAllianceCommonSkillUse:OnReleaseSuccess(skillid)
  local commonSkill = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillById(skillid)
  if commonSkill.config.skill_flag == AlOfficialSkillType.RefreshBall then
    TimerManager:GetInstance():DelayInvoke(function()
      SFSNetwork.SendMessage(MsgDefines.AllianceGovernmentSkillGetList)
    end, 5)
    GoToUtil.CloseAllWindows()
  end
end

return UIAllianceCommonSkillUse
