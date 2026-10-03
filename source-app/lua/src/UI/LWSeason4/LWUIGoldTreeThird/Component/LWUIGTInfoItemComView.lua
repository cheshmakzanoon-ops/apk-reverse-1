local Localization = CS.GameEntry.Localization
local LWUIGTInfoItemComView = BaseClass("LWUIGTInfoItemComView", UIBaseContainer)
local base = UIBaseContainer
local LWUIGTInfoItemComAuto = require("UI.LWSeason4.LWUIGoldTreeThird.Auto.LWUIGTInfoItemComAuto")

function LWUIGTInfoItemComView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGTInfoItemComAuto.New()
  self.binder:bind(self)
end

function LWUIGTInfoItemComView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  base.OnDestroy(self)
end

function LWUIGTInfoItemComView:ReInit(data, history)
  self.data = data
  local playerData = self.data.userInfo
  local oneData = PlayerRankData.New()
  oneData:ParseData(playerData)
  local name = oneData.name
  if not string.IsNullOrEmpty(oneData.abbr) then
    name = "[" .. oneData.abbr .. "] " .. oneData.name
  end
  if self.data.hide == 0 or history then
    self.bind_uicommonhead:SetEnableClickShowInfo(true, true)
    self.bind_uicommonhead:SetHead(oneData.uid, oneData.pic, oneData.picVer, nil, oneData:GetHeadBgImg())
  else
    name = Localization:GetString("390810")
    self.bind_uicommonhead:SetEnableClickShowInfo(false, true)
    self.bind_uicommonhead:SetHead(nil, "Assets/Main/Sprites/UI/UIHeadIcon/player_head_3_big.png")
  end
  self.txt_firstnametxt:SetText(name)
  for index = 1, #self.mul_img_card do
    local curCard = self.data.cardArr[index]
    self.mul_img_card[index]:SetActive(curCard ~= nil)
    if curCard ~= nil then
      local prayConf = DataCenter.SeasonGoldTreeTemplateManager:GetCardTemp(curCard.cardId)
      self.mul_img_card[index]:LoadSprite(prayConf.icon)
    end
  end
  self.txt_lotterycount:SetText(#self.data.stageArr)
end

return LWUIGTInfoItemComView
