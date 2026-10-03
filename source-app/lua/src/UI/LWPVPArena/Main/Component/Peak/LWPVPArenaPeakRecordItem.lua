local LWPVPArenaPeakRecordItem = BaseClass("LWPVPArenaPeakRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHead = require("UI.UILWNewsCenter.Component.UILWNewsUserCell")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local compBook = {
  {
    path = "imgTop",
    name = "imgTop",
    type = UIImage
  },
  {
    path = "imgTop/txtDate",
    name = "txtDate",
    type = UIText
  },
  {
    path = "imgTop/btnReplay",
    name = "btnReplay",
    type = UIButton
  },
  {
    path = "Head",
    name = "head",
    type = UIHead
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "btnChallenge",
    name = "btnChallenge",
    type = UIButton
  },
  {
    path = "btnChallenge/txtChallenge",
    name = "txtChallenge",
    type = UIText
  },
  {
    path = "txtSuccess",
    name = "txtSuccess",
    type = UIText
  },
  {
    path = "imgUp",
    name = "imgUp",
    type = UIImage
  },
  {
    path = "imgDown",
    name = "imgDown",
    type = UIImage
  },
  {
    path = "txtUp",
    name = "txtUp",
    type = UIText
  },
  {
    path = "txtDown",
    name = "txtDown",
    type = UIText
  }
}

function LWPVPArenaPeakRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRecordItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.data = nil
end

function LWPVPArenaPeakRecordItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtChallenge:SetText(Localization:GetString("372258"))
  self.btnChallenge:SetOnClick(function()
    if self.data then
      self.view:Challenge(self.data.log.uid)
    end
  end)
  self.btnReplay:SetOnClick(function()
    if self.data and self.data.log and self.data.log.mailUid then
      if not DataCenter.LWKOFBattleManager:IsRecordRequested(self.data.log) then
        DataCenter.LWKOFBattleManager:RequestRecordsMails(self.data.log)
      end
      if not DataCenter.LWKOFBattleManager:IsRecordsParsed(self.data.log) then
        UIUtil.ShowTipsId(500260)
        return
      end
      if not MailParseHelper.CheckMailBattleReportIntegrity(self.data.log.mailUid, true) then
        UIUtil.ShowTipsId(GameDialogDefine.BATTLE_REPORT_LOADING)
        return
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.data.log.mailUid, "PeakArenaRecord")
      self.view.ctrl:CloseSelf()
    end
  end)
end

function LWPVPArenaPeakRecordItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRecordItem:Refresh(data)
  self.data = data
  local second = math.floor(data.log.time / 1000)
  self.txtDate:SetText(UITimeManager:GetInstance():GetNewsDateTime(second))
  local state = data.log.battleState
  local isWin = state == 1 or state == 3
  if isWin then
    self.imgTop:SetColorRGBA(0.81, 0.89, 0.78, 1)
    self.txtSuccess:SetText(Localization:GetString(state == 1 and "311107" or "311109"))
    self.txtSuccess:SetActive(true)
  else
    self.imgTop:SetColorRGBA(0.98, 0.85, 0.84, 1)
    self.txtSuccess:SetActive(false)
  end
  local abbr = string.IsNullOrEmpty(data.log.abbr) and "" or "[" .. data.log.abbr .. "]"
  self.txtName:SetText("#" .. data.log.serverId .. abbr .. data.log.name)
  self.txtPower:SetText(string.GetFormattedStr(data.log.power))
  self.head:Refresh(data.log.uid, data.log.pic, data.log.picver, data.log.headSkinId, data.log.headSkinET, nil)
  self.btnChallenge:SetActive(data.canChallenge)
  if not data.log.changeRank or data.log.changeRank == 0 then
    self.imgUp:SetActive(false)
    self.imgDown:SetActive(false)
    self.txtUp:SetText("")
    self.txtDown:SetText("")
  elseif data.log.changeRank > 0 then
    self.imgUp:SetActive(true)
    self.imgDown:SetActive(false)
    self.txtUp:SetText("+" .. data.log.changeRank)
    self.txtDown:SetText("")
  else
    self.imgUp:SetActive(false)
    self.imgDown:SetActive(true)
    self.txtUp:SetText("")
    self.txtDown:SetText(data.log.changeRank)
  end
  self.btnReplay:SetActive(data.log.mailUid ~= nil)
end

return LWPVPArenaPeakRecordItem
