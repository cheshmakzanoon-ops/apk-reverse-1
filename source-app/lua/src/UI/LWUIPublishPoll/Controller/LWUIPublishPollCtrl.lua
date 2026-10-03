local LWUIPublishPollCtrl = BaseClass("LWUIPublishPollCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIPublishPoll)
end

local function GetInitOptionDatas()
  return {
    {
      btnType = 1,
      bgIndex = 1,
      info = ""
    },
    {
      btnType = 1,
      bgIndex = 1,
      info = ""
    },
    {
      btnType = 2,
      bgIndex = 3,
      info = ""
    }
  }
end

local function GetOptionsTextIsNil(self, datas)
  for i = 1, #datas - 1 do
    if not datas[i].info or string.IsNullOrEmpty(datas[i].info) then
      return true
    end
  end
end

LWUIPublishPollCtrl.CloseSelf = CloseSelf
LWUIPublishPollCtrl.GetInitOptionDatas = GetInitOptionDatas
LWUIPublishPollCtrl.GetOptionsTextIsNil = GetOptionsTextIsNil
return LWUIPublishPollCtrl
