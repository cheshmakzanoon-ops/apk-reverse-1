local UIVip18HistoryMessageComponent = BaseClass("UIVip18HistoryMessageComponent", UIBaseContainer)
local UIVip18HistoryPhotoComponent = require("UI.UIVipExtend.UIVip18History.UIVip18HistoryPhotoComponent")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MaxPhotoCount = 9

function UIVip18HistoryMessageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIVip18HistoryMessageComponent:ComponentDefine()
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "Top/textName")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "Top/head/UIPlayerHead")
  self.textTime = self:AddComponent(UITextMeshProUGUIEx, "Bot/BgBot/BgTop/textTime")
  self.textContentBig = self:AddComponent(UITextMeshProUGUIEx, "Bot/BgBot/textContentBig")
  self.photoComps = {}
  for i = 1, MaxPhotoCount do
    self.photoComps[i] = self:AddComponent(UIVip18HistoryPhotoComponent, "Bot/BgBot/groupPhoto/Photo" .. i)
  end
end

function UIVip18HistoryMessageComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVip18HistoryMessageComponent:ComponentDestroy()
  self.textName = nil
  self.compUIPlayerHead = nil
  self.textTime = nil
  self.textContentBig = nil
  for i = 1, MaxPhotoCount do
    self.photoComps[i] = nil
  end
  self.photoComps = nil
  self.data = nil
end

function UIVip18HistoryMessageComponent:SetData(data)
  self.data = data
  if data.sender == "system" then
    self.textName:SetLocalText("vip18_extend_history_service_name")
    self.compUIPlayerHead:SetHead(nil, "Assets/Main/Sprites/HeroIconsSmall/hero_icon_Monica")
  else
    self.textName:SetText(LuaEntry.Player.name)
    self.compUIPlayerHead:SetAsMyself()
  end
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(data.sendTime))
  if data.messageId ~= nil and data.messageId ~= "" then
    self.textContentBig:SetText(Localization:GetString(data.messageId, LuaEntry.Player.name) .. (data.msg or ""))
  else
    self.textContentBig:SetText(data.msg or "")
  end
  if data.picVerList == nil or #data.picVerList < 1 then
    for i = 1, MaxPhotoCount do
      self.photoComps[i]:SetActive(false)
    end
    return
  end
  for i = 1, MaxPhotoCount do
    if data.picVerList[i] ~= nil then
      self.photoComps[i]:SetActive(true)
      self.photoComps[i]:SetData(data.picVerList[i])
    else
      self.photoComps[i]:SetActive(false)
    end
  end
end

return UIVip18HistoryMessageComponent
