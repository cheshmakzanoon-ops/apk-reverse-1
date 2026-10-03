local UIMainMailTipsPanelView = BaseClass("UIMainMailTipsPanelView", UIBaseView)
local base = UIBaseView
local _cp_txt_title = "root/TxtName"
local _cp_txt_content = "root/TxtDesc"
local _cp_imgIcon = "root/icon"
local _cp_btn_panel = "Panel"
local _cp_root = "root"

function UIMainMailTipsPanelView:ComponentDefine()
  self._txt_title = self:AddComponent(UIText, _cp_txt_title)
  self._txt_content = self:AddComponent(UIText, _cp_txt_content)
  self._imgicon = self:AddComponent(UIImage, _cp_imgIcon)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._btnRoot = self:AddComponent(UIButton, _cp_root)
  self._btnRoot:SetOnClick(BindCallback(self, self.OnClickBg))
end

function UIMainMailTipsPanelView:OnClickBtn()
  self.ctrl:CloseSelf()
end

function UIMainMailTipsPanelView:OnClickBg()
  self.ctrl:CloseSelf()
  GoToUtil.GotoOpenView(UIWindowNames.UIMailNew)
end

local Color_Green = Color32.New(0.20784313725490197, 0.807843137254902, 0.19607843137254902, 1)
local Color_Red = Color32.New(0.807843137254902, 0.29411764705882354, 0.19607843137254902, 1)

function UIMainMailTipsPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local mailId, mailNode = self:GetUserData()
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(mailId)
  if mailInfo == nil or mailNode == nil then
    return
  end
  local mailExt = mailInfo:GetMailExt()
  if mailExt == nil then
    return
  end
  self._root.transform.position = mailNode.transform.position + Vector3.New(30, 10, 0)
  local imgicon = ""
  local battleWin = true
  if IsMailScoutType(mailInfo.type) or mailInfo.type == MailType.LW_SEASON_SCOUT_MAIL then
    imgicon = "UIMain_img_common_btn_guangcha"
  elseif IsMailNewFightType(mailInfo.type) then
    imgicon = "UIMain_img_common_btn_confirm"
    battleWin = mailExt:GetBattleWin()
  end
  self._imgicon:LoadSprite(string.format(LoadPath.UIMainNew, imgicon))
  if battleWin then
    self._txt_title:SetColor(Color_Green)
  else
    self._txt_title:SetColor(Color_Red)
  end
  local mainTitle = MailShowHelper.GetMainTitle(mailInfo)
  self._txt_title:SetText(mainTitle)
  local subTitle = MailShowHelper.GetMailSubTitle(mailInfo)
  self._txt_content:SetText(subTitle)
  self._timer = TimerManager:GetInstance():DelayInvoke(function()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMainMailTipsPanel)
    self._timer = nil
  end, 3)
end

function UIMainMailTipsPanelView:OnDestroy()
  if self._timer ~= nil then
    self._timer:Stop()
  end
  self._timer = nil
end

return UIMainMailTipsPanelView
