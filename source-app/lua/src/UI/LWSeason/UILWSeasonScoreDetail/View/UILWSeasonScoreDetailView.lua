local UILWSeasonScoreDetailView = BaseClass("UILWSeasonScoreDetailView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWSeasonScoreDetailItem = require("UI.LWSeason.UILWSeasonScoreDetail.Component.UILWSeasonScoreDetailItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/ScrollView/Viewport/Content/TitleText"
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local content_path = "PopUpTitle/ScrollView/Viewport/Content/items"

function UILWSeasonScoreDetailView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWSeasonScoreDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonScoreDetailView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.titleBar = self:AddComponent(UILWSeasonScoreDetailItem, item_path)
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
end

function UILWSeasonScoreDetailView:ComponentDestroy()
  self.content:RemoveComponents(UILWSeasonScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  self.btn_back = nil
end

function UILWSeasonScoreDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(UILWSeasonScoreDetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, nil, true)
  self.lw_season_score_config = self:GetUserData()
  self.titleId = self.lw_season_score_config.name or 801449
  self.detailId = self.lw_season_score_config.desc
  self.heroEventId = self.lw_season_score_config.id
  self.scoreList = string.split(self.lw_season_score_config:getValue("score", ""), "|")
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
        theItem = self.content:AddComponent(UILWSeasonScoreDetailItem, theName)
        theItem:ReInit(i, {
          id = scoreId,
          name = cfg:getValue("name"),
          score = cfg:getValue("points")
        }, false)
      end
    end
  end
end

return UILWSeasonScoreDetailView
