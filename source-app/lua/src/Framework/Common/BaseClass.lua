require("Framework.Common.OptClass")
BaseClass = OptClass.Declare
BaseClassCache = OptClass.Declare
CS.GameFramework.Log.Info("BaseClass:OptClass")
local CS_ERROR = CS.GameFramework.Log.LUA_Error
local CS_Warning = CS.GameFramework.Log.Warning
local string = string or require("string")

function Implement(luaClass, ...)
  local count = select("#", ...)
  if not luaClass or count == 0 then
    return
  end
  for i = 1, count do
    local tab = select(i, ...)
    if tab then
      for _, fName in ipairs(tab) do
        if luaClass[fName] == nil then
          luaClass[fName] = function()
            CS_Warning(string.format("[NotImplementedException] %s.%s NOT implemented", luaClass.__cname, fName))
          end
        elseif type(luaClass[fName]) ~= "function" then
          CS_ERROR(string.format("[NotImplementedException] %s.%s is not a function, type is %s", luaClass.__cname, fName, type(luaClass[fName])))
        end
      end
    end
  end
end

ChildClassImplementList = {}
ChildClassImplementCheckedList = {}

function ImplementChildClass(luaClass, ...)
  if CommonUtil and CommonUtil.IsEditor() then
    local count = select("#", ...)
    if not luaClass or count == 0 then
      return
    end
    for i = 1, count do
      local tab = select(i, ...)
      if tab then
        if not ChildClassImplementList[luaClass] then
          ChildClassImplementList[luaClass] = {}
        end
        for _, fName in ipairs(tab) do
          ChildClassImplementList[luaClass][fName] = true
        end
      end
    end
  end
end
