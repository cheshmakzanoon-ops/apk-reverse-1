local base = UIAsyncContainer
local UIEBR_MyData = BaseClass("UIEBR_MyData", base)
local UIEBR_MyDataItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Component.UIEBR_MyDataItem")
local title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local playerHead_path = "UIPlayerHead"
local nameText_path = "NameText"
local battleResultDataItem_path = "GridContent/BattleResultMyDataItem"

function UIEBR_MyData:OnCreate()
  base.OnCreate(self)
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.titleN:SetLocalText("YiBianJinQu_battle_result_tips_13")
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, nameText_path)
  self.items = {}
  for i = 1, 4 do
    self.items[i] = self:AddComponent(UIEBR_MyDataItem, battleResultDataItem_path .. i)
  end
end

function UIEBR_MyData:OnDestroy()
  self.items = {}
  base.OnDestroy(self)
end

function UIEBR_MyData:UpdateData()
  self.playerHead:SetAsMyself()
  self.nameText:SetText(LuaEntry.Player:GetFullName())
  local msg = self.view.msg
  for i, item in ipairs(self.items) do
    item:SetData(i, msg.scoreInfo)
  end
  DataCenter.LWSoundManager:PlaySound(93017, false)
end

return UIEBR_MyData
