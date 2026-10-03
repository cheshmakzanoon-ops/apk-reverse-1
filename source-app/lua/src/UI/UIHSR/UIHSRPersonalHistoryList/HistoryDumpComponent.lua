local base = UIAsyncContainer
local HistoryDumpComponent = BaseClass("HistoryDumpComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local GradePath = {
  A = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icona.png",
  B = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_iconb.png",
  C = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_iconc.png",
  D = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icond.png",
  S = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icons.png"
}

function HistoryDumpComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HistoryDumpComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HistoryDumpComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textUnitPriceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textSoldNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textUnitPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.imgGrade = self.viewSkin:AddComponent(self, UIImage, 10)
  self.textTitle:SetLocalText("activity_1200044_tips81")
  self.textSold:SetLocalText("activity_1200044_tips80", "")
  self.textUnitPrice:SetLocalText("activity_1200044_tips79")
  self.textProfit:SetLocalText("activity_1200044_tips61", "")
end

function HistoryDumpComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnLWInfo = nil
  self.textProfit = nil
  self.textProfitNum = nil
  self.textUnitPriceNum = nil
  self.textSoldNum = nil
  self.textUnitPrice = nil
  self.textTitle = nil
  self.textTime = nil
  self.textSold = nil
  self.imgGrade = nil
end

function HistoryDumpComponent:DataDefine()
end

function HistoryDumpComponent:DataDestroy()
  self.data = nil
end

function HistoryDumpComponent:OnAddListener()
  base.OnAddListener(self)
end

function HistoryDumpComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HistoryDumpComponent:OnBtnLWInfoClick()
  if self.data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true}, self.data.uuid)
  end
end

function HistoryDumpComponent:SetData(data)
  self.data = data
end

function HistoryDumpComponent:UpdateData()
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.createTrainTime))
  self.textSoldNum:SetText(string.GetFormattedSeparatorNum(self.data.sellNum))
  self.textUnitPriceNum:SetText(string.GetFormattedSeparatorNum(math.floor(self.data.profit / self.data.sellNum)))
  self.textProfitNum:SetText(string.GetFormattedSeparatorNum(self.data.profit))
  self.imgGrade:LoadSpriteAsync(GradePath[self.data.rate])
end

return HistoryDumpComponent
