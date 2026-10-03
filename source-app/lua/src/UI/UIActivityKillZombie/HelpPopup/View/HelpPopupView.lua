local UIActivityKillZombieHelpPopupView = BaseClass("UIActivityKillZombieHelpPopupView", UIBaseView)
local base = UIBaseView
local HelpPopupItem = require("UI.UIActivityKillZombie.HelpPopup.Component.HelpPopupItem")
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local cell_path = "PopUpTitle/Common/ScrollView/Viewport/Cell"
local content_path = "PopUpTitle/Common/ScrollView/Viewport/Content"
local btn_go_path = "PopUpTitle/BtnGo"
local go_text_path = "PopUpTitle/BtnGo/GoText"

function UIActivityKillZombieHelpPopupView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function UIActivityKillZombieHelpPopupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityKillZombieHelpPopupView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, panel_path)
  self.btnPanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.titleText = self:AddComponent(UIText, title_text_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.go_text = self:AddComponent(UIText, go_text_path)
  self.theCellItem = self.transform:Find(cell_path).gameObject
  self.theCellItem:GameObjectCreatePool()
  self.titleText:SetLocalText(self.param.title or 2000047)
  self.go_text:SetLocalText("2800055")
  self.btn_go:SetOnClick(function()
    if self.param ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityKillZombieHelpReward, {anim = true}, self.param)
    end
  end)
  self:handleHelpList(self.content, self.param.activityData)
end

function UIActivityKillZombieHelpPopupView:ComponentDestroy()
  self.content:RemoveComponents(HelpPopupItem)
  self.theCellItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.content = nil
  self.btn_go = nil
  self.go_text = nil
  self.btnPanel = nil
  self.titleText = nil
  self.closeBtn = nil
end

function UIActivityKillZombieHelpPopupView:handleHelpList(content, activityData)
  local goItem, theItem
  content:RemoveComponents(HelpPopupItem)
  for i = 1, 10 do
    local name = "item_" .. i
    goItem = self.theCellItem:GameObjectSpawn(content.transform)
    goItem.name = name
    goItem:SetActive(true)
    theItem = content:AddComponent(HelpPopupItem, name)
    theItem:ReInit(i, activityData)
  end
end

return UIActivityKillZombieHelpPopupView
