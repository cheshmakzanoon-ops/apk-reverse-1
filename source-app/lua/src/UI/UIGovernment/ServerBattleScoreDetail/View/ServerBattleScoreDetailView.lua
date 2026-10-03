local ServerBattleScoreDetailView = BaseClass("ServerBattleScoreDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local ServerBattleScoreDetailItem = require("UI.UIGovernment.ServerBattleScoreDetail.Component.ServerBattleScoreDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/TitleText"
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local content_path = "PopUpTitle/ScrollView/Viewport/Content/items"

function ServerBattleScoreDetailView:OnCreate()
  base.OnCreate(self)
  local titleId, detailId = self:GetUserData()
  self.titleId = titleId or 801449
  self.detailId = detailId or 801450
  self:ComponentDefine()
end

function ServerBattleScoreDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ServerBattleScoreDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.dialog_title_text:SetLocalText(self.titleId)
  self.title_text:SetLocalText(self.detailId)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.titleBar = self:AddComponent(ServerBattleScoreDetailItem, item_path)
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
  self:UpdateData()
end

function ServerBattleScoreDetailView:ComponentDestroy()
  self.content:RemoveComponents(ServerBattleScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function ServerBattleScoreDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:SetActive(true)
  self.content:RemoveComponents(ServerBattleScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.taskList = DataCenter.ZoneWarManager:GetZoneWarScoreConfigList()
  theItem:ReInit(0, nil, true)
  for i, v in ipairs(self.taskList) do
    if v and 0 < toInt(v.score) and self:CanShow(v) then
      local theName = "item_" .. i
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      theItem = self.content:AddComponent(ServerBattleScoreDetailItem, theName)
      theItem:ReInit(i, v, false)
    end
  end
end

function ServerBattleScoreDetailView:CanShow(v)
  if DataCenter.ZoneWarManager:IsCampBattle() and (v.type == 5 or v.type == 6) then
    return false
  end
  return v.on_off
end

return ServerBattleScoreDetailView
