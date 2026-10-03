local base = UIAsyncContainer
local HistoryConsignComponent = BaseClass("HistoryConsignComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local GradePath = {
  A = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icona.png",
  B = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_iconb.png",
  C = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_iconc.png",
  D = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icond.png",
  S = "Assets/Main/SeasonRes/S5/Sprites/HighSpeedRailway/LXYS5_zhanquhuoche_icons.png"
}

function HistoryConsignComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HistoryConsignComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HistoryConsignComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textProfit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textRemainNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textProfitNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textRemain = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textSold = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textSoldNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgGrade = self.viewSkin:AddComponent(self, UIImage, 9)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textSold:SetLocalText("activity_1200044_tips59", "")
  self.textRemain:SetLocalText("activity_1200044_tips60", "")
  self.textProfit:SetLocalText("activity_1200044_tips61", "")
end

function HistoryConsignComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textProfit = nil
  self.textTime = nil
  self.textRemainNum = nil
  self.textProfitNum = nil
  self.textRemain = nil
  self.textSold = nil
  self.textTitle = nil
  self.textSoldNum = nil
  self.imgGrade = nil
  self.btnLWInfo = nil
end

function HistoryConsignComponent:DataDefine()
end

function HistoryConsignComponent:DataDestroy()
  self.data = nil
end

function HistoryConsignComponent:OnAddListener()
  base.OnAddListener(self)
end

function HistoryConsignComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HistoryConsignComponent:OnBtnLWInfoClick()
  if self.data then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHSRPersonalHistoryDetail, {anim = true}, self.data.uuid)
  end
end

function HistoryConsignComponent:SetData(data)
  self.data = data
end

function HistoryConsignComponent:UpdateData()
  self.textTitle:SetLocalText("activity_1200044_tips58", self.data.stationNum)
  self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.createTrainTime))
  self.textSoldNum:SetText(string.GetFormattedSeparatorNum(self.data.totalNum))
  self.textRemainNum:SetText(string.GetFormattedSeparatorNum(self.data.sellNum))
  self.textProfitNum:SetText(string.GetFormattedSeparatorNum(self.data.profit))
  self.imgGrade:LoadSpriteAsync(GradePath[self.data.rate])
end

return HistoryConsignComponent
