local VisitorOperateMessage = BaseClass("VisitorOperateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, visitorUid, operate)
  base.OnCreate(self)
  self.sfsObj:PutLong("uid", visitorUid)
  self.sfsObj:PutInt("operate", operate)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode == nil or t.errorCode == "" then
    DataCenter.RewardManager:AddRewardsAndRes(t)
    DataCenter.CityVisitorManager:FinishVisitor(t)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICityVisitor, {
      anim = false,
      UIMainAnim = UIMainAnimType.AllShow
    })
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorkerDetail)
  else
    local lang = Localization:GetString(t.errorCode)
    local str = lang or t.errorCode
    UIUtil.ShowTips(lang or str)
  end
end

function VisitorOperateMessage:GetTestData(visitorUid, operate)
  local t = {}
  t.reward = {
    {
      type = 7,
      value = {
        itemId = "520014",
        otherPara = "",
        rewardAdd = 1,
        use = "1",
        count = 17,
        para1 = "4",
        para2 = "0.1",
        para3 = "1",
        uuid = tostring(math.random(100000, 10000000000))
      }
    }
  }
  t.uid = visitorUid
  t.operate = operate or 1
  t.visitorType = 0
  t.operateName = "ACCEPT"
  return t
end

VisitorOperateMessage.OnCreate = OnCreate
VisitorOperateMessage.HandleMessage = HandleMessage
return VisitorOperateMessage
