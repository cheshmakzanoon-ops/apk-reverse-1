local UIChampionDuelBattleLogDetailView = BaseClass("UIChampionDuelBattleLogDetailView", UIBaseView)
local base = UIBaseView
local title_text_path = "Root/TopBar/TextTitle"
local return_btn_path_close = "Root/BtnClose"
local mail_detail_content_path = "Root/MiddleContentContainer/MailDetailHolder"
local Infos = {
  Muster = {
    Type = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailMuster"),
    Prefab = "Assets/Main/Prefabs/UI/LWMail/MailDetailMuster.prefab"
  },
  War = {
    Type = require("UI.UILWMail.UILWMailMain.Component.UILWMailDetailWar"),
    Prefab = "Assets/Main/Prefabs/UI/LWMail/MailDetailWar.prefab"
  }
}

function UIChampionDuelBattleLogDetailView:OnCreate()
  base.OnCreate(self)
  self.reqs = {}
  self.mailDetails = {}
  self.uid = self:GetUserData()
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.titleText:SetLocalText("310101")
  self.closeBtn = self:AddComponent(UIButton, return_btn_path_close)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, mail_detail_content_path)
  self.ctrl:SetView(self)
  DataCenter.ChampionDuelManager:ReqBattleLogInfo(self.uid)
end

function UIChampionDuelBattleLogDetailView:OnDestroy()
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
  end
  self.reqs = {}
  self.mailDetails = {}
  self.titleText = nil
  self.closeBtn = nil
  self.content = nil
  self.ctrl:ClearData()
  base.OnDestroy(self)
end

function UIChampionDuelBattleLogDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChampionDuelLogInfoRefresh, self.OnGetMailData)
end

function UIChampionDuelBattleLogDetailView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChampionDuelLogInfoRefresh, self.OnGetMailData)
  base.OnRemoveListener(self)
end

function UIChampionDuelBattleLogDetailView:OnGetMailData(mailData)
  self.ctrl:SetMailData(mailData)
  self.ctrl:SetCurrentView(nil)
  self:ContentTrans()
end

function UIChampionDuelBattleLogDetailView:GetCurrentKey()
  return self.ctrl:GetCurrentView() == 4 and "War" or "Muster"
end

function UIChampionDuelBattleLogDetailView:ContentTrans()
  self:CreateDetail(self:GetCurrentKey(), function()
    local curKey = self:GetCurrentKey()
    for k, v in pairs(self.mailDetails) do
      v:SetActive(k == curKey)
      if k == curKey then
        v:RefreshContent()
      end
    end
  end)
end

function UIChampionDuelBattleLogDetailView:CreateDetail(key, cb)
  local mailDetail = self.mailDetails[key]
  if mailDetail ~= nil then
    if cb then
      cb()
    end
    return
  end
  if self.reqs[key] ~= nil then
    return
  end
  local info = Infos[key]
  self.reqs[key] = self:GameObjectInstantiateAsync(info.Prefab, function(req)
    if IsNull(req) then
      return
    end
    local gameObject = req.gameObject
    local transform = gameObject.transform
    transform:SetParent(self.content.transform)
    transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local name = gameObject.name
    mailDetail = self.content:AddComponent(info.Type, name)
    mailDetail:SetOffsetMaxXY(0, 0)
    mailDetail:SetOffsetMinXY(0, 0)
    self.mailDetails[key] = mailDetail
    if cb then
      cb()
    end
  end)
end

return UIChampionDuelBattleLogDetailView
