local UILWMummyMainItemEffectTip = BaseClass("UILWMummyMainItemEffectTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TipLine = require("UI.LWSeasonShared.UILWMummyMain.Component.UILWMummyMainItemEffectTipLine")
local hide_btn_path = "HideBtn"
local top_path = "Top"
local icon_path = "Top/icon"
local name_path = "Top/name"
local condition_path = "Top/condition"
local info_btn_path = "Top/infoBtn"
local desc_path = "desc"
local buff_item_path = "BuffItem"

function UILWMummyMainItemEffectTip:OnCreate()
  base.OnCreate(self)
  self.hide_btn = self:AddComponent(UIButton, hide_btn_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.condition = self:AddComponent(UITextMeshProUGUIEx, condition_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.theItem = self.transform:Find(buff_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.hide_btn:SetOnClick(function()
    self:SetActive(false)
    if self.view and self.view.title then
      self.view.title:SetActive(true)
    end
  end)
  self.info_btn:SetOnClick(function()
    if self.lang_id_info then
      local msg = Localization:GetString(self.lang_id_info)
      UIUtil.ShowDetail(msg, nil, nil, false, true)
    end
  end)
end

function UILWMummyMainItemEffectTip:OnDestroy()
  self:RemoveComponents(TipLine)
  self.theItem:GameObjectRecycleAll()
  self.hide_btn = nil
  self.top = nil
  self.icon = nil
  self.name = nil
  self.condition = nil
  self.info_btn = nil
  base.OnDestroy(self)
end

function UILWMummyMainItemEffectTip:ShowTips(statusId, needArmyCount, totalArmyCountNow)
  local meta = LocalController:instance():getLine(TableName.StatusTab, statusId)
  if meta then
    self:SetActive(true)
    self.lang_id_info = meta.info
    self.name:SetLocalText(meta.name)
    self.icon:LoadSprite(meta.icon)
    self.desc:SetLocalText(meta.description)
    local msg = Localization:GetString("season_s3_Mummy_tips005", needArmyCount)
    if needArmyCount <= totalArmyCountNow then
      self.condition:SetText(string.format("<color=#099b4a>%s</color>", msg))
      CS.UIGray.SetGray(self.icon.transform, false, false)
    else
      self.condition:SetText(string.format("<color=#E52727>%s</color>", msg))
      CS.UIGray.SetGray(self.icon.transform, true, false)
    end
    self.info_btn:SetActive(self.lang_id_info ~= nil)
    if self.statusId == nil and meta.effect then
      local effectKeyList = string.split_ii_array(meta.effect, "|")
      local effectValueList = string.split_ff_array(meta.effect_num, "|")
      if effectKeyList and effectValueList then
        local goItem, theItem
        for index, effectId in ipairs(effectKeyList) do
          local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(effectId))
          if effectLine then
            goItem = self.theItem:GameObjectSpawn(self.transform)
            goItem.name = "buff_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self:AddComponent(TipLine, goItem.name)
            theItem:ReInit(effectLine, effectValueList[index] or 0)
          end
        end
      end
    end
    self.statusId = statusId
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  end
end

return UILWMummyMainItemEffectTip
