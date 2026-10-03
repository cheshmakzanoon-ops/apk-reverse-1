local LWSeasonAllianceScoreDetailView = BaseClass("LWSeasonAllianceScoreDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonAllianceScoreDetailItem = require("UI.LWSeason.LWSeasonAllianceScoreDetail.Component.LWSeasonAllianceScoreDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/TitleText"
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local content_path = "PopUpTitle/ScrollView/Viewport/Content/items"

function LWSeasonAllianceScoreDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function LWSeasonAllianceScoreDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonAllianceScoreDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.titleBar = self:AddComponent(LWSeasonAllianceScoreDetailItem, item_path)
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
end

function LWSeasonAllianceScoreDetailView:ComponentDestroy()
  self.content:RemoveComponents(LWSeasonAllianceScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function LWSeasonAllianceScoreDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(LWSeasonAllianceScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, nil, true)
  local titleId, detailId, heroEventId = self:GetUserData()
  self.titleId = titleId or 801449
  self.detailId = detailId or 801450
  self.heroEventId = heroEventId
  if heroEventId then
    local cfg = LocalController:instance():getLine(TableName.HeroEvent, heroEventId)
    if cfg then
      self.scoreList = string.split(cfg:getValue("score", ""), "|")
      self.titleId = cfg:getValue("name", 801449)
      self.detailId = cfg:getValue("desc", 801450)
    end
  else
    self.dialog_title_text:SetLocalText("801449")
    self.title_text:SetLocalText("801450")
    return
  end
  self.dialog_title_text:SetLocalText(self.titleId)
  self.title_text:SetLocalText(self.detailId)
  if self.scoreList then
    for i, scoreId in ipairs(self.scoreList) do
      local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
      if cfg then
        local theName = "item_" .. i
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = theName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(LWSeasonAllianceScoreDetailItem, theName)
        theItem:ReInit(i, {
          id = scoreId,
          name = cfg:getValue("name"),
          score = cfg:getValue("points")
        }, false)
      end
    end
  end
end

return LWSeasonAllianceScoreDetailView
