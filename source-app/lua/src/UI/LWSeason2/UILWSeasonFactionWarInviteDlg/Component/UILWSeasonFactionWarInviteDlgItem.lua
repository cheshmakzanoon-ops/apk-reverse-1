local UILWSeasonFactionWarInviteDlgItem = BaseClass("UILWSeasonFactionWarInviteDlgItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWSeasonFactionWarInviteDlgItem:OnCreate()
  base.OnCreate(self)
  self.invitedText = self:AddComponent(UITextMeshProUGUIEx, "InvitedText")
  self.rank_text = self:AddComponent(UITextMeshProUGUIEx, "RankText")
  self.icon = self:AddComponent(UIButton, "icon")
  self.name = self:AddComponent(UITextMeshProUGUIEx, "name")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.do_btn = self:AddComponent(UIButton, "DoBtn")
  self.do_btn_text = self:AddComponent(UITextMeshProUGUIEx, "DoBtn/DoBtnText")
  self.icon:SetOnClick(function()
    if self.data then
      UIUtil.TryShowAllianceInfo(self.data.serverId, self.data.allianceId, self.data.name)
    end
  end)
  self.do_btn:SetOnClick(function()
    if self.data and not self.data.hasSendFlag then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        if self.data then
          if self.parentView then
            self.data.theContent = self.parentView.theContent
            if #self.data.theContent > 150 then
              UIUtil.ShowTipsId(120193)
              return
            end
          else
            self.data.theContent = Localization:GetString("season_s2_faction_war_tips_07")
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarInviteSendDlg, {anim = false}, self.data)
        end
      else
        UIUtil.ShowTipsId(803040)
      end
    end
  end)
  self.do_btn:SetSafeClickMode(true)
  self.rank_text:SetActive(false)
  self.invitedText:SetActive(false)
end

function UILWSeasonFactionWarInviteDlgItem:OnDestroy()
  self.icon = nil
  self.name = nil
  self.desc = nil
  self.do_btn = nil
  self.do_btn_text = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarInviteDlgItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarInviteSendUpdate, self.OnInviteSend)
end

function UILWSeasonFactionWarInviteDlgItem:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarInviteSendUpdate, self.OnInviteSend)
  base.OnRemoveListener(self)
end

function UILWSeasonFactionWarInviteDlgItem:OnInviteSend(t)
  if self.data and t and t.allianceId and t.overTime and t.state == 0 and t.allianceId == self.data.allianceId then
    self.data.hasSendFlag = true
    self.do_btn_text:SetLocalText("season_s2_faction_war_48")
    CS.UIGray.SetGray(self.do_btn.transform, true, false)
    self.invitedText:SetActive(true)
    self.do_btn:SetActive(false)
  end
end

function UILWSeasonFactionWarInviteDlgItem:ReInit(index, data, view)
  self.parentView = view
  self.icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(data.icon)))
  self.name:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
  local power = Localization:GetString("100392", string.GetFormattedStr(data.power))
  local mem = Localization:GetString("455089") .. string.format("%s/%s", data.curMember, data.maxMember)
  local lang = Localization:GetString("455090") .. Localization:GetString(data.language or 115600)
  self.desc:SetText(power .. "\n" .. mem .. "\n" .. lang)
  if data.hasSendFlag then
    self.do_btn_text:SetLocalText("season_s2_faction_war_48")
    CS.UIGray.SetGray(self.do_btn.transform, true, false)
    self.invitedText:SetActive(true)
    self.do_btn:SetActive(false)
  else
    self.do_btn_text:SetLocalText("season_s2_faction_war_46")
    CS.UIGray.SetGray(self.do_btn.transform, false, true)
    self.invitedText:SetActive(false)
    self.do_btn:SetActive(true)
  end
  self.data = data
end

return UILWSeasonFactionWarInviteDlgItem
