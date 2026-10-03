local base = UIBaseContainer
local LWSeasonCityOccupyTip = BaseClass("LWSeasonCityOccupyTip", base)
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local btn_tip_mask_path = "BtnTipMask"
local tip_box_empty_path = "TipBoxEmpty"
local tip_box_path = "TipBox"
local content_path = "TipBox/content"
local desc_item_line_path = "TipBox/content/DescItemLine"

function LWSeasonCityOccupyTip:OnCreate()
  base.OnCreate(self)
  self.btn_tip_mask = self:AddComponent(UIButton, btn_tip_mask_path)
  self.tip_box_empty = self:AddComponent(UIBaseComponent, tip_box_empty_path)
  self.tip_box = self:AddComponent(UIBaseComponent, tip_box_path)
  self.content = self:AddComponent(UIBaseComponent, content_path)
  self.theItem = self.transform:Find(desc_item_line_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.btn_tip_mask:SetOnClick(function()
    self:SetActive(false)
    self.tooltip_tick = 0
  end)
  self.tip_box_empty:SetActive(false)
  self.tip_box:SetActive(false)
end

function LWSeasonCityOccupyTip:OnDestroy()
  self.theItem:GameObjectRecycleAll()
  self.btn_tip_mask = nil
  self.tip_box_empty = nil
  self.tip_box = nil
  self.detail = nil
  self.content = nil
  base.OnDestroy(self)
end

function LWSeasonCityOccupyTip:ShowEffectInfo(effects, appendData, localTxt)
  self:SetActive(true)
  self.tooltip_tick = 5
  if effects == nil then
    self.dataCount = 0
    self.tip_box_empty:SetActive(true)
    self.tip_box:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box_empty.transform)
    return
  end
  local dataCount = 0
  local goItem
  self.theItem:GameObjectRecycleAll()
  self.tip_box_empty:SetActive(false)
  self.tip_box:SetActive(true)
  for effectId, effectValue in pairs(effects) do
    local buffAddNum, effectName = UIUtil.GetEffectStr(nil, effectValue, effectId)
    if buffAddNum ~= nil then
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem:SetActive(true)
      local DescText = goItem.transform:Find("DescText")
      local DescValue = goItem.transform:Find("DescValue")
      if DescText ~= nil then
        local desc_tmp = DescText.gameObject:GetComponent(UnityTextMeshProEx)
        if desc_tmp ~= nil then
          desc_tmp:SetLocalText(effectName)
        end
      end
      if DescValue ~= nil then
        local value_tmp = DescValue.gameObject:GetComponent(UnityTextMeshProEx)
        if value_tmp ~= nil then
          value_tmp.text = buffAddNum or ""
        end
      end
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(goItem.transform)
      dataCount = dataCount + 1
    end
  end
  if appendData then
    for k, v in pairs(appendData) do
      goItem = self.theItem:GameObjectSpawn(self.content.transform)
      goItem:SetActive(true)
      local DescText = goItem.transform:Find("DescText")
      local DescValue = goItem.transform:Find("DescValue")
      if DescText ~= nil then
        local desc_tmp = DescText.gameObject:GetComponent(UnityTextMeshProEx)
        if desc_tmp ~= nil then
          if localTxt then
            desc_tmp:SetText(k)
          else
            desc_tmp:SetLocalText(k)
          end
        end
      end
      if DescValue ~= nil then
        local value_tmp = DescValue.gameObject:GetComponent(UnityTextMeshProEx)
        if value_tmp ~= nil then
          value_tmp.text = v or ""
        end
      end
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(goItem.transform)
      dataCount = dataCount + 1
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box.transform)
  self.dataCount = dataCount
end

function LWSeasonCityOccupyTip:Update1000MS()
  if self.tooltip_tick ~= nil and self.tooltip_tick > 0 then
    self.tooltip_tick = self.tooltip_tick - 1
    if self.tooltip_tick <= 0 then
      self:SetActive(false)
    elseif self.dataCount and 0 < self.dataCount then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tip_box.transform)
    end
  end
end

return LWSeasonCityOccupyTip
