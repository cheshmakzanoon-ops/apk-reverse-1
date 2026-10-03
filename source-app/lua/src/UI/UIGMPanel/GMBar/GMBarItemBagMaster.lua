local base = UIAsyncContainer
local GMBarItemBagMaster = BaseClass("GMBarItemBagMaster", base)
local Localization = CS.GameEntry.Localization

function GMBarItemBagMaster:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function GMBarItemBagMaster:OnDestroy()
  self.currentArgs = nil
  if self.delayRefreshTimer then
    self.delayRefreshTimer:Stop()
    self.delayRefreshTimer = nil
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemBagMaster:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.inputFieldItemIdInput = self.viewSkin:AddComponent(self, UIInput, 1)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btn1 = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btn1:SetOnClick(function()
    self:OnBtn1Click()
  end)
  self.btn2 = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btn2:SetOnClick(function()
    self:OnBtn2Click()
  end)
  self.textTmpBtn1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpBtn2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compLayoutTop = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compLayoutDown = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.textTmpSelectionName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.textTmpBtnGo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.num_1 = 100
  self.num_2 = 1
  self.num_3 = 1
  self.numMulti = 1
  self.textTmpBtnGo:SetText(string.format("%s%s", self.num_3 > 0 and "+" or "", self.num_3))
  self:RefreshLayout()
end

function GMBarItemBagMaster:ComponentDestroy()
  self.viewSkin = nil
  self.inputFieldItemIdInput = nil
  self.btnGo = nil
  self.btn1 = nil
  self.btn2 = nil
  self.textTmpBtn1 = nil
  self.textTmpBtn2 = nil
  self.compLayoutTop = nil
  self.compLayoutDown = nil
  self.textTmpSelectionName = nil
  self.textTmpBtnGo = nil
end

function GMBarItemBagMaster:DataDefine()
end

function GMBarItemBagMaster:DataDestroy()
end

function GMBarItemBagMaster:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GM_BagMasterSelectionChanged, self.OnGM_BagMasterSelectionChanged)
end

function GMBarItemBagMaster:OnRemoveListener()
  self:RemoveUIListener(EventId.GM_BagMasterSelectionChanged, self.OnGM_BagMasterSelectionChanged)
  base.OnRemoveListener(self)
end

function GMBarItemBagMaster:OnBtnGoClick()
end

function GMBarItemBagMaster:OnBtn1Click()
end

function GMBarItemBagMaster:OnBtn2Click()
end

function GMBarItemBagMaster:OnGM_BagMasterSelectionChanged(args)
  self.currentArgs = args
  self:RefreshLayout()
end

function GMBarItemBagMaster:RefreshLayout()
  local goodsId, resId = self:GetGoodId()
  self.compLayoutDown:SetActive(goodsId ~= nil or resId ~= nil)
  if not goodsId and not resId then
    return
  end
  if resId then
    self.numMulti = 1000
  else
    self.numMulti = 1
  end
  self.compLayoutDown:SetActive(self.currentArgs ~= nil)
  if not self.currentArgs then
    return
  end
  self:RefreshAddNumber()
  local name = self.currentArgs.name
  self.textTmpSelectionName:SetText(string.format("%s[%s]", name, goodsId or resId))
end

function GMBarItemBagMaster:GetGoodId()
  if not self.currentArgs then
    return
  end
  local itemId = self.currentArgs.itemId
  local resId = self.currentArgs.resId
  return itemId and tostring(itemId), resId and tostring(resId)
end

function GMBarItemBagMaster:OnBtn1Click()
  if not self.currentArgs then
    return
  end
  local goodsId, resId = self:GetGoodId()
  if goodsId then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, goodsId, self.num_1)
  elseif resId then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, resId, self.num_1 * self.numMulti, nil, nil)
  end
end

function GMBarItemBagMaster:OnBtn2Click()
  if not self.currentArgs then
    return
  end
  local goodsId, resId = self:GetGoodId()
  if goodsId then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, goodsId, self.num_2)
  elseif resId then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, resId, self.num_2 * self.numMulti, nil, nil)
  end
end

function GMBarItemBagMaster:OnBtnGoClick()
  local input = self.inputFieldItemIdInput:GetText()
  if input and 0 < #input then
    SFSNetwork.SendMessage(MsgDefines.GMAddResourceMessage, nil, nil, nil, nil, input, self.num_3)
  end
end

function GMBarItemBagMaster:RefreshAddNumber()
  local n1 = self.num_1 * self.numMulti
  local n2 = self.num_2 * self.numMulti
  self.textTmpBtn1:SetText(string.format("%s%s", self.num_1 > 0 and "+" or "", string.GetFormattedStr0(n1)))
  self.textTmpBtn2:SetText(string.format("%s%s", self.num_2 > 0 and "+" or "", string.GetFormattedStr0(n2)))
end

return GMBarItemBagMaster
