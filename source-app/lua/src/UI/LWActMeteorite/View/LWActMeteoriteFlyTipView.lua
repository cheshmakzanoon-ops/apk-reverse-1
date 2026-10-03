local LWActMeteoriteFlyTipView = BaseClass("LWActMeteoriteFlyTipView", UIBaseView)
local base = UIBaseView
local closeBtn_path = "Root/Common_bg_orange/CloseBtn"
local closeBg_path = "Root/panel"
local item_path = "Root/Common_bg_orange/Item"
local btn_path = "Root/Common_bg_orange/Btn"

function LWActMeteoriteFlyTipView:OnCreate()
  base.OnCreate(self)
  self.mailUid = self:GetUserData()
  if string.IsNullOrEmpty(self.mailUid) then
    Logger.Log("LWActMeteoriteFlyTipView mailUuid is null")
    self.ctrl:CloseSelf()
    return
  end
  Logger.LogCustom("LWActMeteoriteFlyTipView mailId: " .. self.mailUid)
  DataCenter.MailDataManager:ReadMail(self.mailUid)
  local mailInfo = DataCenter.MailDataManager:GetMailInfoById(self.mailUid)
  if mailInfo == nil then
    Logger.LogInfo("LWActMeteoriteFlyTipView mailInfo is null")
  end
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closeBg = self:AddComponent(UIButton, closeBg_path)
  self.closeBg:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.item = self:AddComponent(UICommonResItem, item_path)
  local reward = mailInfo ~= nil and mailInfo:GetMailReward() or nil
  local tabReward = reward ~= nil and reward.rewardInfo or nil
  if table.count(tabReward) > 0 then
    self.item:SetActive(true)
    for _, info in pairs(tabReward) do
      local param = {
        rewardType = info.type,
        itemId = info.id,
        count = info.num
      }
      self.item:ReInit(param)
      break
    end
  else
    local itemId = LuaEntry.DataConfig:TryGetNum("login_popup_notification", "k2")
    if itemId then
      local param = {
        rewardType = RewardType.GOODS,
        itemId = itemId,
        count = 1
      }
      self.item:ReInit(param)
    else
      self.item:SetActive(false)
    end
  end
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

function LWActMeteoriteFlyTipView:OnDestroy()
  self.close_btn = nil
  self.closeBg = nil
  self.item = nil
  self.btn = nil
  self.mailUid = nil
  base.OnDestroy(self)
end

function LWActMeteoriteFlyTipView:OnBtnClick()
  DataCenter.MailDataManager:SetAllAndOne(false)
  DataCenter.MailDataManager:RewardMail(self.mailUid)
  EventManager:GetInstance():Broadcast(EventId.OnClickReceiveOneMailReward)
  self.ctrl:CloseSelf()
end

return LWActMeteoriteFlyTipView
