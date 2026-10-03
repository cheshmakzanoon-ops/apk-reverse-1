local base = UIBaseContainer
local LLBuffItem = BaseClass("LLBuffItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLBuffItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLBuffItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLBuffItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compLock = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.imgTop = self.viewSkin:AddComponent(self, UIImage, 5)
end

function LLBuffItem:ComponentDestroy()
  self.viewSkin = nil
  self.textDesc = nil
  self.imgIcon = nil
  self.textTitle = nil
  self.compLock = nil
  self.imgTop = nil
end

function LLBuffItem:DataDefine()
end

function LLBuffItem:DataDestroy()
end

function LLBuffItem:OnAddListener()
  base.OnAddListener(self)
end

function LLBuffItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLBuffItem:SetData(data)
  local bUnlock = data.active
  local id = data.id
  self.compLock:SetActive(not bUnlock)
  self.imgTop:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bUnlock and "zxl_shamo_biaoti_huang.png" or "zxl_shamo_biaoti_hui.png"))
  local condition = string.split(data.condition, "|")
  local cType = tonumber(condition[1])
  local descKey = data.condition_desc
  if cType == 1 then
    self.textTitle:SetLocalText(descKey)
  else
    local list = string.split(condition[2] or "", ",")
    if descKey == "zonewar_landlord_buff_condition_desc_10002" or descKey == "zonewar_landlord_buff_condition_desc_10003" then
      self.textTitle:SetLocalText(descKey, toInt(list[1]) + 1, list[2])
    else
      self.textTitle:SetLocalText(descKey, table.unpack(list))
    end
  end
  local icon = ActMgr:GetBuffIcon(id)
  self.imgIcon:LoadSpriteAuto(icon)
  local desc = ActMgr:GetBuffDesc(id)
  self.textDesc:SetText(desc)
end

return LLBuffItem
