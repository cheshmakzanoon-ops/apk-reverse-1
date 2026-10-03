local KingPowerView = BaseClass("KingPowerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local KingPowerItem = require("UI.UIGovernment.KingPower.Component.KingPowerItem")
local btn_back_path = "Root/BottomBar/BtnBack"
local btn_effect_path = "Root/BottomBar/BtnEffect"
local info_btn_path = "Root/PackList/select/InfoBtn"
local text_title_path = "Root/TopBar/TextTitle"
local cell_path = "Root/PackList/cell"
local content_path = "Root/PackList/Viewport/Content"
local remain_time_path = "Root/PackList/select/TimeBg/remainTime"

function KingPowerView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self:ComponentDefine()
end

function KingPowerView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function KingPowerView:OnAddListener()
  base.OnAddListener(self)
end

function KingPowerView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function KingPowerView:ComponentDefine()
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.text_title:SetLocalText("457005")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btn_history = self:AddComponent(UIButton, btn_effect_path)
  self.btn_history:SetActive(false)
  self.btn_help = self:AddComponent(UIButton, info_btn_path)
  self.btn_help:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("457013")
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.cell = self:AddComponent(UIImage, cell_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.num_text = self:AddComponent(UIText, remain_time_path)
  self.num_text:SetText(Localization:GetString("457012") .. ": 123,456,789")
  self.theItem = self.transform:Find(cell_path).gameObject
  self.theItem:GameObjectCreatePool()
  local goItem, theItem
  for i = 1, 5 do
    local levelName = "item_" .. i
    goItem = self.theItem:GameObjectSpawn(self.content.transform)
    goItem.name = levelName
    goItem:SetActive(true)
    theItem = self.content:AddComponent(KingPowerItem, levelName)
    theItem:ReInit(i)
  end
end

function KingPowerView:ComponentDestroy()
  self.content:RemoveComponents(KingPowerItem)
  self.theItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.btn_back = nil
end

function KingPowerView:UpdateData()
end

return KingPowerView
