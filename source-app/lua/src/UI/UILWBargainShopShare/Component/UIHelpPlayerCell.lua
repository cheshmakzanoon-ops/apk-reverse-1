local UIHelpPlayerCell = BaseClass("UIHelpPlayerCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local nameConst = "[%s]%s"

function UIHelpPlayerCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIHelpPlayerCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIHelpPlayerCell:ComponentDefine()
  self.player_head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.playerName_text = self:AddComponent(UIText, "desInfo/playerName")
  self.des_text = self:AddComponent(UIText, "desInfo/des")
  self.desLayout = self:AddComponent(UIBaseContainer, "desInfo/layout")
  self.savedDes = self:AddComponent(UIText, "desInfo/layout/savedDes")
  self.addIcon = self:AddComponent(UIImage, "addIcon")
  self.addIconBtn = self:AddComponent(UIButton, "addIcon")
  self.desIcon = self:AddComponent(UIImage, "desInfo/layout/Image")
  self.desContainer = self:AddComponent(UIBaseContainer, "desInfo")
  self.addIconBtn:SetOnClick(function()
    if self.data.callBack then
      self.data.callBack()
    end
  end)
end

function UIHelpPlayerCell:ComponentDestroy()
  self.player_head = nil
  self.playerName_text = nil
  self.des_text = nil
  self.savedDes = nil
  self.addIcon = nil
  self.data = nil
end

function UIHelpPlayerCell:SetData(data)
  self.data = data
  if data and data.playerInfo and not string.IsNullOrEmpty(data.playerInfo.uid) then
    self:PlayerInit(data)
    return
  end
  self:BlankInit()
end

function UIHelpPlayerCell:PlayerInit(data)
  self.player_head:SetActive(true)
  self.desContainer:SetActive(true)
  self.addIcon:SetActive(false)
  self.player_head:SetHeadAndFrame(data.playerInfo.uid, data.playerInfo.pic, data.playerInfo.picver, false, data.playerInfo.headSkinId)
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(self.data.currency))
  self.desIcon:LoadSprite(iconPath)
  local name = ""
  if string.IsNullOrEmpty(data.playerInfo.abbr) then
    name = data.playerInfo.name
  else
    name = string.format(nameConst, data.playerInfo.abbr, data.playerInfo.name)
  end
  self.playerName_text:SetText(name)
  self.des_text:SetLocalText("activity_bargain_shop_desc41")
  self.savedDes:SetText(Localization:GetString("activity_bargain_shop_desc33", data.reducePrice))
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.savedDes.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desLayout.transform)
end

function UIHelpPlayerCell:BlankInit()
  self.desContainer:SetActive(false)
  self.player_head:SetActive(false)
  self.addIcon:SetActive(true)
end

return UIHelpPlayerCell
