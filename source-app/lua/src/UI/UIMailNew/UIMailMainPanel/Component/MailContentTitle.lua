local MailContentTitle = BaseClass("MailContentTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local base64 = require("Framework.Common.base64")
local rapidjson = require("rapidjson")
local _cp_txtMainTitle = "txtMainTitle"
local _cp_txtSubTitle = "txtSubTitle"
local _cp_txtSubTitle_Fight = "txtSubTitle_Fight"
local _cp_txtTime = "txtTime"
local _cp_txtMainTitle_Fight = "txtMainTitle_Fight"

function MailContentTitle:OnCreate()
  base.OnCreate(self)
  self._txtMainTitle_Fight = self:AddComponent(UIText, _cp_txtMainTitle_Fight)
  self._txtMainTitle_FightOutline = self:AddComponent(UIOutline, _cp_txtMainTitle_Fight)
  self._txtMainTitle = self:AddComponent(UIText, _cp_txtMainTitle)
  self._txtSubTitle = self:AddComponent(UIText, _cp_txtSubTitle)
  self._txtTime = self:AddComponent(UIText, _cp_txtTime)
  self._txtSubTitle_Fight = self:AddComponent(UITextMeshProUGUIEx, _cp_txtSubTitle_Fight)
  self._txtSubTitle_Fight:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
end

function MailContentTitle:OnPointerClick(clickPos)
  if self._txtSubTitle_Fight == nil then
    return
  end
  local linkId = self._txtSubTitle_Fight:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local linkMsg = base64.decode(linkId)
  linkMsg = rapidjson.decode(linkMsg)
  self:OnHandleLink(linkMsg)
end

function MailContentTitle:OnHandleLink(linkMsg)
  if linkMsg.action == "Jump" then
    self:OnMoveToPos(linkMsg)
  end
end

function MailContentTitle:OnMoveToPos(linkMsg)
  local pointId = tonumber(linkMsg.pointId) or 1
  local serverId = linkMsg.server or LuaEntry.Player:GetCurServerId()
  self.view.ctrl:OnClickPosBtn(pointId, serverId)
end

function MailContentTitle:SetData(titledata)
  local mainTitle = titledata.main
  local subTitle = titledata.sub
  local time = titledata.time
  local mailData = titledata.mailInfo
  self._txtMainTitle:SetText(mainTitle)
  self._txtSubTitle:SetText("")
  self._txtSubTitle_Fight:SetActive(true)
  self._txtSubTitle_Fight:SetText(subTitle)
  self._txtTime:SetText(time)
  self._txtMainTitle_Fight:SetText(mainTitle)
  if mailData ~= nil and (mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.MARCH_DESTROY_MAIL) then
    self._txtMainTitle_Fight:SetActive(true)
    self._txtMainTitle:SetActive(false)
    local battleWin = mailData:GetMailExt():GetBattleWin()
    if battleWin then
      self._txtMainTitle_Fight:SetColor(Const_Color_Green)
      self._txtMainTitle_FightOutline:SetColor(Const_Green_Outline)
    else
      self._txtMainTitle_Fight:SetColor(Const_Color_Red)
      self._txtMainTitle_FightOutline:SetColor(Const_Red_Outline)
    end
  else
    self._txtMainTitle_Fight:SetActive(false)
    self._txtMainTitle:SetActive(true)
  end
end

return MailContentTitle
