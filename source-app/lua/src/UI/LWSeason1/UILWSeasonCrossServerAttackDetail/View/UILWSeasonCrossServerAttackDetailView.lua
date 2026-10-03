local UILWSeasonCrossServerAttackDetailView = BaseClass("UILWSeasonCrossServerAttackDetailView", UIBaseView)
local base = UIBaseView
local DetailItem = require("UI.LWSeason1.UILWSeasonCrossServerAttackDetail.Component.UILWSeasonCrossServerAttackDetailItem")
local item_path = "PopUpTitle/ScrollView/Viewport/Content/item"
local items_path = "PopUpTitle/ScrollView/Viewport/Content/items"
local close_btn_path = "PopUpTitle/CloseBtn"
local desc_text_path = "PopUpTitle/ScrollView/Viewport/Content/DescText"
local title_text_path = "PopUpTitle/Common_img_title/TitleText"

function UILWSeasonCrossServerAttackDetailView:OnCreate()
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:UpdateData()
  self.title_text:SetLocalText(self.param.title or "170001")
  self.desc_text:SetLocalText(self.param.desc or "")
end

function UILWSeasonCrossServerAttackDetailView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCrossServerAttackDetailView:ComponentDefine()
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.titleBar = self:AddComponent(DetailItem, item_path)
  self.content = self:AddComponent(UIBaseContainer, items_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.panel = self:AddComponent(UIButton, "panel")
  self.panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.theItem = self.titleBar.gameObject
  self.theItem:GameObjectCreatePool()
end

function UILWSeasonCrossServerAttackDetailView:ComponentDestroy()
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  self.title_text = nil
  self.desc_text = nil
end

function UILWSeasonCrossServerAttackDetailView:UpdateData()
  local goItem
  local theItem = self.titleBar
  self.content:RemoveComponents(DetailItem)
  self.theItem:GameObjectRecycleAll()
  theItem:ReInit(0, true)
  local hero_event_id = toInt(self.param.id)
  local heroEventCfg = LocalController:instance():getLine(TableName.HeroEvent, hero_event_id)
  if heroEventCfg then
    local score = heroEventCfg.score
    if score then
      local scoreList = string.split_ii_array(score, "|")
      if scoreList then
        for index, scoreId in ipairs(scoreList) do
          local cfg = LocalController:instance():getLine(TableName.Score, scoreId)
          if cfg then
            local theName = "item_" .. UIUtil.GetLoopListItemIndex()
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = theName
            goItem:SetActive(true)
            theItem = self.content:AddComponent(DetailItem, theName)
            theItem:ReInit(index, false, cfg.name, cfg.points)
          end
        end
      end
    end
  end
end

return UILWSeasonCrossServerAttackDetailView
